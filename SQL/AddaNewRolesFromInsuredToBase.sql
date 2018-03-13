-- หากรมธรรม์
SELECT IA.PolicyNumber FROM Agreement AG
INNER JOIN InsuranceApplication IA
ON	AG.InsuranceApplication_Id = IA.Id
where AG.ReferenceNumber = '17502/POL/001026-511' 

select Discriminator,InsuranceApplication_Id from Agreement where ReferenceNumber = '17502/POL/001026-511'

select * from PartyRole where InsuranceApplication_Id = 'F22C2AE4-6C20-4AF4-9E63-B8CC7BECC159' --base		check role
select * from PartyRole where InsuranceApplication_Id = '3479CC8B-8260-4ACC-9DF9-EFD80F37DFB8' --insure     check role

select * from InsuranceApplicationRoleItem where InsuranceApplicationRole_Id = 'FEBC7267-189E-4EF0-BAFF-F793069CF252'
select * from InsuranceApplicationItem where id = '171BA123-C510-4D99-98EC-EC01DAC13874'



----- Process
DECLARE @Agreement_Id uniqueidentifier
DECLARE @InAppSource_Id uniqueidentifier		-- insured
DECLARE @InAppTarget_Id uniqueidentifier		-- base
DECLARE @Policy_Ref nvarchar(30)
DECLARE @End_sequence int
DECLARE @ReferenceNumber nvarchar(30) = '17502/POL/001026-511'

DECLARE @numCur int
DECLARE @numParent int


select	@InAppSource_Id = InsuranceApplication_Id
from	Agreement 
where	ReferenceNumber = @ReferenceNumber 
and		Discriminator = 'InsurancePolicy'

select	@InAppTarget_Id = InsuranceApplication_Id
from	Agreement 
where	ReferenceNumber = @ReferenceNumber 
and		Discriminator = 'BaseInsurancePolicy'

--=== Parent RefernecNumber
SELECT top 1 * FROM Agreement WHERE InsuranceApplication_Id = @InAppTarget_Id order by ModifiedDate DESC

--== PartyRoles of Current
select @numCur = count(1) 
from PartyRole 
where InsuranceApplication_Id = @InAppSource_Id and -- Current Policy/Endorse
Party_Id is not null and
[Type_Id] is not null 

print @End_sequence
--== PartyRoles of Insurance
IF @End_sequence = 1
	BEGIN
		select @numParent = count(a.Id) 
		from PartyRole a
		inner join Agreement b on (b.InsuranceApplication_Id = a.InsuranceApplication_Id)
		where ReferenceNumber = @Policy_Ref and b.Discriminator = 'BaseInsurancePolicy' and -- Parent of Current Policy/Endorse
		Party_Id is not null and
		a.[Type_Id] is not null 
	END
ELSE
	BEGIN
		select @numParent = count(a.Id) 
		from PartyRole a
		inner join Agreement b on (b.InsuranceApplication_Id = a.InsuranceApplication_Id)
		where ReferenceNumber = @Policy_Ref and b.Discriminator = 'InsurancePolicy' and -- Parent of Current Policy/Endorse
		Party_Id is not null and
		a.[Type_Id] is not null 
	END

print @Agreement_Id
print @InAppSource_Id
print @InAppTarget_Id
print @numCur
print @numParent

--IF @numCur > @numParent
--	BEGIN
			--============ Find the people not in Parent
			select * 
			INTO #PartyRole
			from PartyRole 
			where InsuranceApplication_Id = @InAppSource_Id and --Current policy/endorse
			Party_Id is not null and
			[Type_Id] is not null
			and Party_Id not in 
			(
			select Party_Id 
			from PartyRole 
			where InsuranceApplication_Id = @InAppTarget_Id and --Parent of Current
			Party_Id is not null
			)

			
			Update #PartyRole
			SET Id = newId() ,
			InsuranceApplication_Id = @InAppTarget_Id
			--============== End insert to #PartyRole

			--================== InsertData To #InsuranceApplicationItem

			select c.*
			INTO #InsuranceApplicationItem
			from InsuranceApplicationRoleItem a
			inner join PartyRole b on (a.InsuranceApplicationRole_Id = b.Id)
			inner join InsuranceApplicationItem c on (a.InsuranceApplicationItem_Id = c.Id)
			where b.InsuranceApplication_Id = @InAppSource_Id
			and Party_Id  not in 
			(
				select Party_Id 
				from PartyRole 
				where InsuranceApplication_Id = @InAppTarget_Id and --BaseInsurancePolicy
				Party_Id is not null
			)

				--============= Create InsuranceApplicationItem Mapping ID
				select c.Id as Id, newId() as NewId, c.Discriminator
				INTO #InsuranceApplicationItem_Map
				from InsuranceApplicationRoleItem a
				inner join PartyRole b on (a.InsuranceApplicationRole_Id = b.Id)
				inner join InsuranceApplicationItem c on (a.InsuranceApplicationItem_Id = c.Id)
				where b.InsuranceApplication_Id = @InAppSource_Id
				and Party_Id  not in 
				(
					select Party_Id 
					from PartyRole 
					where InsuranceApplication_Id = @InAppTarget_Id and --BaseInsurancePolicy
					Party_Id is not null
				)

			
			DECLARE @parentId uniqueidentifier 
			select @parentId = [NewId] from #InsuranceApplicationItem_Map where Discriminator = 'InsuranceApplicationItem'

			Update #InsuranceApplicationItem
			SET Id = @parentId,
			InsuranceApplication_Id = NULL,
			Parent_Id = NULL
			where Discriminator = 'InsuranceApplicationItem' and CreatedUserId is not null and CreatedUserName is not null

			
			Update #InsuranceApplicationItem 
			SET Id = a.[NewId],
			InsuranceApplication_Id = NULL,
			Parent_Id = NULL
			FROM #InsuranceApplicationItem_Map a
			WHERE #InsuranceApplicationItem.Id = a.Id and 
			a.Discriminator = 'InsuranceApplicationItem' and CreatedUserId is  null and CreatedUserName is  null
			--select * from #InsuranceApplicationItem where Discriminator = 'InsuranceApplicationItem' 

			Update #InsuranceApplicationItem 
			SET Id = a.[NewId],
			Parent_Id = @parentId,
			InsuranceApplication_Id = @InAppTarget_Id 
			FROM #InsuranceApplicationItem_Map a
			WHERE #InsuranceApplicationItem.Id = a.Id
			AND a.Discriminator = 'InsuranceApplicationPackageItem' 

			
			--================== End Insert in To #InsuranceApplicationItem

			--================== InsertData To #InsuranceApplicationRoleItem
			select a.*
			INTO #InsuranceApplicationRoleItem
			from InsuranceApplicationRoleItem a
			inner join PartyRole b on (a.InsuranceApplicationRole_Id = b.Id)
			inner join InsuranceApplicationItem c on (a.InsuranceApplicationItem_Id = c.Id)
			where b.InsuranceApplication_Id = @InAppSource_Id
			and Party_Id not in 
			(
				select Party_Id 
				from PartyRole 
				where InsuranceApplication_Id = @InAppTarget_Id and --BaseInsurancePolicy
				Party_Id is not null
			)

			Update #InsuranceApplicationRoleItem
			SET Id = newId(),
			InsuranceApplicationRole_Id = c.Id
			FROM PartyRole a
			INNER JOIN #PartyRole c on (a.Party_Id = c.Party_Id)
			WHERE #InsuranceApplicationRoleItem.InsuranceApplicationRole_Id = a.Id 
			and a.Party_Id in 
			(
				select b.Party_Id
				from InsuranceApplicationRoleItem a
				inner join PartyRole b on (a.InsuranceApplicationRole_Id = b.Id)
				inner join InsuranceApplicationItem c on (a.InsuranceApplicationItem_Id = c.Id)
				where b.InsuranceApplication_Id = @InAppSource_Id
				and Party_Id not in 
				(
					select Party_Id 
					from PartyRole 
					where InsuranceApplication_Id = @InAppTarget_Id and --BaseInsurancePolicy
					Party_Id is not null
				)
			)

			Update #InsuranceApplicationRoleItem
			SET InsuranceApplicationItem_Id = a.[NewId]
			FROM #InsuranceApplicationItem_Map a
			WHERE #InsuranceApplicationRoleItem.InsuranceApplicationItem_Id = a.Id

			BEGIN TRY
				BEGIN TRANSACTION
					INSERT INTO PartyRole
					select * from #PartyRole

					INSERT INTO InsuranceApplicationItem
					select * from #InsuranceApplicationItem

					--UPDATE #InsuranceApplicationItem
					--SET Id = '4294F0B7-3C90-40F2-9824-CCDAC64CBDC1'
					--where Id = '1D1E09F9-566B-4513-9AEE-02D24FD72B0D' and CreatedUserId = 'RSTOWER\narumons'

					INSERT INTO InsuranceApplicationRoleItem
					select * from #InsuranceApplicationRoleItem

					--select * from InsuranceApplicationItem where Id in (select Id from #InsuranceApplicationItem)
				COMMIT TRANSACTION
			END TRY

			BEGIN CATCH
				SELECT  
					ERROR_NUMBER() AS ErrorNumber  
					,ERROR_SEVERITY() AS ErrorSeverity  
					,ERROR_STATE() AS ErrorState  
					,ERROR_PROCEDURE() AS ErrorProcedure  
					,ERROR_MESSAGE() AS ErrorMessage; 

				IF @@TRANCOUNT > 0
					ROLLBACK
					--COMMIT
			END CATCH
	
			drop table #InsuranceApplicationRoleItem
			drop table #InsuranceApplicationItem
			drop table #InsuranceApplicationItem_Map
			drop table #PartyRole
	END