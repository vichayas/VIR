----- Process
DECLARE @Agreement_Id uniqueidentifier
DECLARE @InAppPolicy_Id uniqueidentifier		-- insured
DECLARE @InAppAPE_Id uniqueidentifier		-- base
DECLARE @Policy_Ref nvarchar(30)
DECLARE @End_sequence int
DECLARE @ReferenceNumberPol nvarchar(30) = '17181/POL/000160-520'
DECLARE @ReferenceNumberAPE nvarchar(30) = '18181/APE/000168-520'

DECLARE @numInsuredPolicy int
DECLARE @numInsuredBase int


select	@InAppPolicy_Id = InsuranceApplication_Id
from	Agreement 
where	ReferenceNumber = @ReferenceNumberPol 
and		Discriminator = 'InsurancePolicy'

select	@InAppAPE_Id = InsuranceApplication_Id
from	Agreement 
where	ReferenceNumber = @ReferenceNumberAPE 


--=== Parent RefernecNumber
SELECT top 1 * FROM Agreement WHERE InsuranceApplication_Id = @InAppAPE_Id order by ModifiedDate DESC

--== PartyRoles of InsurancePolicy
select @numInsuredPolicy = count(1) 
from PartyRole 
where InsuranceApplication_Id = @InAppPolicy_Id and -- Current Policy/Endorse
Party_Id is not null and
[Type_Id] is not null 

--== PartyRoles of APE

select @numInsuredBase = count(a.Id) 
from PartyRole a
inner join Agreement b on (b.InsuranceApplication_Id = a.InsuranceApplication_Id)
where ReferenceNumber = @ReferenceNumberAPE and -- Parent of Current Policy/Endorse
Party_Id is not null and
a.[Type_Id] is not null

print @Agreement_Id
print @InAppPolicy_Id
print @InAppAPE_Id
print @numInsuredPolicy
print @numInsuredBase

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
			where InsuranceApplication_Id = @InAppAPE_Id and --Parent of Current
			Party_Id is not null
			)

			
			Update #PartyRole
			SET Id = newId() ,
			InsuranceApplication_Id = @InAppAPE_Id
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
				where InsuranceApplication_Id = @InAppAPE_Id and --BaseInsurancePolicy
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
				
				select  Parent_Id, newId() as new_Parent_Id
				into #Parent_Map
				from #InsuranceApplicationItem
				where Parent_Id is not null
				group by Parent_Id

				

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
					where InsuranceApplication_Id = @InAppAPE_Id and --BaseInsurancePolicy
					Party_Id is not null
				)

			
			
			--================= Update #InsuranceApplicationItem

			Update #InsuranceApplicationItem 
			SET Id = a.[NewId],
			InsuranceApplication_Id = @InAppAPE_Id 
			FROM #InsuranceApplicationItem_Map a
			WHERE #InsuranceApplicationItem.Id = a.Id
			AND InsuranceApplication_Id is not null

			
			Update #InsuranceApplicationItem 
			SET Id = a.[NewId]
			FROM #InsuranceApplicationItem_Map a
			WHERE #InsuranceApplicationItem.Id = a.Id
			AND InsuranceApplication_Id is  null and #InsuranceApplicationItem.Id not in (select Parent_Id from #Parent_Map)

			UPDATE #InsuranceApplicationItem
			SET Id = a.new_Parent_Id,
			InsuranceApplication_Id = @InAppAPE_Id 
			FROM #Parent_Map a
			WHERE #InsuranceApplicationItem.Id = a.Parent_Id

			UPDATE #InsuranceApplicationItem
			SET Parent_Id = a.new_Parent_Id
			FROM #Parent_Map a
			WHERE #InsuranceApplicationItem.Parent_Id = a.Parent_Id

			select * from #Parent_Map
			
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
				where InsuranceApplication_Id = @InAppAPE_Id and --BaseInsurancePolicy
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
					where InsuranceApplication_Id = @InAppAPE_Id and --BaseInsurancePolicy
					Party_Id is not null
				)
			)

			Update #InsuranceApplicationRoleItem
			SET InsuranceApplicationItem_Id = a.[NewId]
			FROM #InsuranceApplicationItem_Map a
			WHERE #InsuranceApplicationRoleItem.InsuranceApplicationItem_Id = a.Id

			--============= Update PolicyItemSchedule
			
			select * into #PolicyItemPremium from PolicyItemPremium where 1=0

			select c.Id
			from InsuranceApplicationRoleItem a
			inner join PartyRole b on (a.InsuranceApplicationRole_Id = b.Id)
			inner join InsuranceApplicationItem c on (a.InsuranceApplicationItem_Id = c.Id)
			where b.InsuranceApplication_Id = @InAppPolicy_Id
			and a.IsPayment = 1
			and Party_Id  not in 
			(
				select Party_Id 
				from PartyRole 
				where InsuranceApplication_Id = @InAppAPE_Id and --BaseInsurancePolicy
				Party_Id is not null
			)
			DECLARE @HavePayment int = @@ROWCOUNT

			if(@HavePayment > 0)
				BEGIN
					INSERT INTO #PolicyItemPremium
					select b.* 
					from PremiumSchedule a
					inner join PolicyItemPremium b on (a.Id = b.PremiumSchedule_Id)
					where a.InsuranceApplication_Id = @InAppPolicy_Id

					DECLARE @ItemPaymentId varchar(100)
					DECLARE @RoleItemPaymentId varchar(100)
					DECLARE @PremiumScheduleId varchar(100)

					select @PremiumScheduleId = Id
					from PremiumSchedule
					where InsuranceApplication_Id = @InAppAPE_Id

					select @ItemPaymentId = InsuranceApplicationItem_Id,
							@RoleItemPaymentId = Id 
					FROM #InsuranceApplicationRoleItem
					WHERE IsPayment = 1

					UPDATE polItem
					SET Id = newId(),
						InsuranceApplicationItem_Id = rolItem.InsuranceApplicationItem_Id,
						InsuranceApplicationRoleItem_Id = rolItem.Id,
						PremiumSchedule_Id = @PremiumScheduleId
					FROM #PolicyItemPremium polItem
						inner join #InsuranceApplicationItem_Map map on (polItem.InsuranceApplicationItem_Id = map.Id)
						inner join #InsuranceApplicationRoleItem rolItem on (map.[NewId] = rolItem.InsuranceApplicationItem_Id)
					
					UPDATE polItem
					SET PremiumAmount = b.PremiumAmount,
						StampsDutyAmount = b.StampsDutyAmount,
						SubTotalAmount = b.TotalAmount
					FROM #PolicyItemPremium polItem
						inner join PremiumSchedule b on (polItem.PremiumSchedule_Id = b.Id)
					where InsuranceApplication_Id = @InAppAPE_Id
					and polItem.PremiumAmount != 0

				END

			BEGIN TRY
				BEGIN TRANSACTION
					INSERT INTO PartyRole
					select * from #PartyRole
	
					INSERT INTO InsuranceApplicationItem
					select * from #InsuranceApplicationItem
					--select * from #Parent_Map

					INSERT INTO InsuranceApplicationRoleItem
					select * from #InsuranceApplicationRoleItem
					--select * from #Parent_Map
					if(@HavePayment > 0)
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
			drop table #Parent_Map
			drop table #PolicyItemPremium
	END


