
DECLARE @Agreement_Id uniqueidentifier
DECLARE @InAppSource_Id uniqueidentifier
DECLARE @InAppTarget_Id uniqueidentifier
DECLARE @Policy_Ref nvarchar(30)
DECLARE @End_sequence int
DECLARE @ReferenceNumber nvarchar(30) = '18181/END/000001-563'

DECLARE @numCur int
DECLARE @numParent int

SELECT @InAppSource_Id = b.Id,@Agreement_Id = a.Id,  @InAppTarget_Id = b.ParentId, @End_sequence = b.END_Sequence, @Policy_Ref = PolicyNumber
FROM Agreement a
INNER JOIN InsuranceApplication b on (a.InsuranceApplication_Id = b.Id)
WHERE a.ReferenceNumber = @ReferenceNumber

select a.ReferenceNumber,a2.ReferenceNumber, iai.PolicyNumber, c1.DescriptionTH, c2.DescriptionTH, iai.END_Sequence
 from Agreement a
 inner join  Agreement a2 on (a.InsuranceApplication_Id = a2.InsuranceApplication_Id and a2.Discriminator = 'InsuranceEndorsement')
 inner join ApplicantEndorsementItem b on (a.Id = b.ApplicantEndorsement_Id)
 inner join Endorsement c1 on (a.ApplicantEndorsementCategoryId = c1.Id)
 inner join Endorsement c2 on (b.EndorsementType_Id = c2.Id)
 inner join InsuranceApplication iai on (iai.Id = a.InsuranceApplication_Id)
  where a2.ReferenceNumber = @ReferenceNumber

--=== Parent RefernecNumber
SELECT top 1 * FROM Agreement WHERE InsuranceApplication_Id = @InAppTarget_Id order by ModifiedDate DESC

--== PartyRoles of Current
select @numCur = count(1) 
from PartyRole 
where InsuranceApplication_Id = @InAppSource_Id and -- Current Policy/Endorse
Party_Id is not null and
[Type_Id] is not null 

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

IF @numCur > @numParent
	BEGIN
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
			where Discriminator = 'InsuranceApplicationItem' 

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

					INSERT INTO InsuranceApplicationRoleItem
					select * from #InsuranceApplicationRoleItem
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
			END CATCH
			
			drop table #InsuranceApplicationRoleItem
			drop table #InsuranceApplicationItem
			drop table #PartyRole
	END