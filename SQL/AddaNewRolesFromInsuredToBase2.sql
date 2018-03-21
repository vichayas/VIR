----- Process
DECLARE @Agreement_Id uniqueidentifier
DECLARE @InAppPolicy_Id uniqueidentifier		-- insured
DECLARE @InAppBase_Id uniqueidentifier		-- base
DECLARE @Policy_Ref nvarchar(30)
DECLARE @End_sequence int
DECLARE @ReferenceNumber nvarchar(30) = '17502/POL/001026-511'

DECLARE @numInsuredPolicy int
DECLARE @numInsuredBase int


select	@InAppPolicy_Id = InsuranceApplication_Id
from	Agreement 
where	ReferenceNumber = @ReferenceNumber 
and		Discriminator = 'InsurancePolicy'

select	@InAppBase_Id = InsuranceApplication_Id
from	Agreement 
where	ReferenceNumber = @ReferenceNumber 
and		Discriminator = 'BaseInsurancePolicy'

--=== Parent RefernecNumber
SELECT top 1 * FROM Agreement WHERE InsuranceApplication_Id = @InAppBase_Id order by ModifiedDate DESC

--== PartyRoles of InsurancePolicy
select @numInsuredPolicy = count(1) 
from PartyRole 
where InsuranceApplication_Id = @InAppPolicy_Id and -- Current Policy/Endorse
Party_Id is not null and
[Type_Id] is not null 

--== PartyRoles of Base

select @numInsuredBase = count(a.Id) 
from PartyRole a
inner join Agreement b on (b.InsuranceApplication_Id = a.InsuranceApplication_Id)
where ReferenceNumber = @Policy_Ref and b.Discriminator = 'BaseInsurancePolicy' and -- Parent of Current Policy/Endorse
Party_Id is not null and
a.[Type_Id] is not null

print @Agreement_Id
print @InAppPolicy_Id
print @InAppBase_Id
print @numCur
print @numParent

IF @numInsuredPolicy > @numInsuredBase
	BEGIN
			--============ Find the people not in Base
			select * 
			INTO #PartyRole
			from PartyRole 
			where InsuranceApplication_Id = @InAppPolicy_Id and --Current policy/endorse
			Party_Id is not null and
			[Type_Id] is not null
			and Party_Id not in 
			(
			select Party_Id 
			from PartyRole 
			where InsuranceApplication_Id = @InAppBase_Id and --Parent of Current
			Party_Id is not null
			)

			
			Update #PartyRole
			SET Id = newId() ,
			InsuranceApplication_Id = @InAppBase_Id
			--============== End insert to #Base

			--================== InsertData To #InsuranceApplicationItem

			--Add missing item of insured
			select c.*
			INTO #InsuranceApplicationItem
			from InsuranceApplicationRoleItem a
			inner join PartyRole b on (a.InsuranceApplicationRole_Id = b.Id)
			inner join InsuranceApplicationItem c on (a.InsuranceApplicationItem_Id = c.Id)
			where b.InsuranceApplication_Id = @InAppPolicy_Id
			and Party_Id  not in 
			(
				select Party_Id 
				from PartyRole 
				where InsuranceApplication_Id = @InAppBase_Id and --BaseInsurancePolicy
				Party_Id is not null
			)

			--Update missing InAppItem
			INSERT into #InsuranceApplicationItem
			select * from InsuranceApplicationItem 
			where InsuranceApplication_Id = @InAppPolicy_Id
			and Id not in
				(
					select c.Id
					from InsuranceApplicationRoleItem a
					inner join PartyRole b on (a.InsuranceApplicationRole_Id = b.Id)
					inner join InsuranceApplicationItem c on (a.InsuranceApplicationItem_Id = c.Id)
					where b.InsuranceApplication_Id = @InAppPolicy_Id
				)

				--============= Create InsuranceApplicationParentMapping 
				
				select distinct Parent_Id, newId() as new_Parent_Id
				into #Parent_Map
				from #InsuranceApplicationItem
				where Parent_Id is not null

				--============= Create InsuranceApplicationItem Mapping ID
				select c.Id as Id, newId() as NewId, c.Discriminator
				INTO #InsuranceApplicationItem_Map
				from InsuranceApplicationRoleItem a
				inner join PartyRole b on (a.InsuranceApplicationRole_Id = b.Id)
				inner join InsuranceApplicationItem c on (a.InsuranceApplicationItem_Id = c.Id)
				where b.InsuranceApplication_Id = @InAppPolicy_Id
				and Party_Id  not in 
				(
					select Party_Id 
					from PartyRole 
					where InsuranceApplication_Id = @InAppBase_Id and --BaseInsurancePolicy
					Party_Id is not null
				)

			
			--DECLARE @parentId uniqueidentifier = newId()
			DECLARE @receiptItemId uniqueidentifier = newId()

			--insert into #InsuranceApplicationItem
			--select *
			--from InsuranceApplicationItem 
			--where InsuranceApplication_Id = @InAppPolicy_Id
			--and InsuranceApplicationItemType_Id = 'F89579DB-7C44-409F-8D50-A0061D29D04E' --㺤Ӣ�
			--select @parentId = [NewId] from #InsuranceApplicationItem_Map where IsParent = 1

			--Update #InsuranceApplicationItem
			--SET Id = @receiptItemId,
			--InsuranceApplication_Id = NULL,
			--Parent_Id = NULL
			--where Discriminator = 'InsuranceApplicationItem' and CreatedUserId is not null and CreatedUserName is not null

			
			--Update #InsuranceApplicationItem 
			--SET Id = a.[NewId],
			--InsuranceApplication_Id = NULL,
			--Parent_Id = NULL
			--FROM #InsuranceApplicationItem_Map a
			--WHERE #InsuranceApplicationItem.Id = a.Id and 
			--a.Discriminator = 'InsuranceApplicationItem' and CreatedUserId is  null and CreatedUserName is  null
			--select * from #InsuranceApplicationItem where Discriminator = 'InsuranceApplicationItem' 
			--================= Update #InsuranceApplicationItem

			Update #InsuranceApplicationItem 
			SET Id = a.[NewId],
			InsuranceApplication_Id = @InAppBase_Id 
			FROM #InsuranceApplicationItem_Map a
			WHERE #InsuranceApplicationItem.Id = a.Id
			AND InsuranceApplication_Id is not null

			UPDATE #InsuranceApplicationItem
			SET Id = a.new_Parent_Id
			FROM #Parent_Map a
			WHERE #InsuranceApplicationItem.Id = a.Parent_Id

			UPDATE #InsuranceApplicationItem
			SET Parent_Id = a.new_Parent_Id
			FROM #Parent_Map a
			WHERE #InsuranceApplicationItem.Parent_Id = a.Parent_Id

			
			--================== End Insert in To #InsuranceApplicationItem

			--================== InsertData To #InsuranceApplicationRoleItem
			select a.*
			INTO #InsuranceApplicationRoleItem
			from InsuranceApplicationRoleItem a
			inner join PartyRole b on (a.InsuranceApplicationRole_Id = b.Id)
			inner join InsuranceApplicationItem c on (a.InsuranceApplicationItem_Id = c.Id)
			where b.InsuranceApplication_Id = @InAppPolicy_Id
			and Party_Id not in 
			(
				select Party_Id 
				from PartyRole 
				where InsuranceApplication_Id = @InAppBase_Id and --BaseInsurancePolicy
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
				where b.InsuranceApplication_Id = @InAppPolicy_Id
				and Party_Id not in 
				(
					select Party_Id 
					from PartyRole 
					where InsuranceApplication_Id = @InAppBase_Id and --BaseInsurancePolicy
					Party_Id is not null
				)
			)

			Update #InsuranceApplicationRoleItem
			SET InsuranceApplicationItem_Id = a.[NewId]
			FROM #InsuranceApplicationItem_Map a
			WHERE #InsuranceApplicationRoleItem.InsuranceApplicationItem_Id = a.Id

			--============= Update PolicyItemSchedule
			
			select * into #PolicyItemPremium from PolicyItemPremium where 1=0

			select c.*
			from InsuranceApplicationRoleItem a
			inner join PartyRole b on (a.InsuranceApplicationRole_Id = b.Id)
			inner join InsuranceApplicationItem c on (a.InsuranceApplicationItem_Id = c.Id)
			where b.InsuranceApplication_Id = @InAppPolicy_Id
			and a.IsPayment = 1
			and Party_Id  not in 
			(
				select Party_Id 
				from PartyRole 
				where InsuranceApplication_Id = @InAppBase_Id and --BaseInsurancePolicy
				Party_Id is not null
			)
			DECLARE @HavePayment int = @@ROWCOUNT

			if(@HavePayment = 0)
				BEGIN
					INSERT INTO #PolicyItemPremium
					select b.* 
					from PremiumSchedule a
					inner join PolicyItemPremium b on (a.Id = b.PremiumSchedule_Id)
					where a.InsuranceApplication_Id = @InAppPolicy_Id

					DECLARE @ItemPaymentId varchar(100)
					DECLARE @RoleItemPaymentId varchar(100)
					select @ItemPaymentId = InsuranceApplicationItem_Id,
							@RoleItemPaymentId = Id 
					FROM #InsuranceApplicationRoleItem
					WHERE IsPayment = 1

					UPDATE #PolicyItemPremium
					SET Id = newId(),
						InsuranceApplicationItem_Id = @ItemPaymentId,
						InsuranceApplicationRoleItem_Id = @RoleItemPaymentId
				END

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

					if(@HavePayment = 0)
						BEGIN
							INSERT INTO PolicyItemPremium
							select * from #PolicyItemPremium
						END
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