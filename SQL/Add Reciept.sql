/*
Create an Invoice
*/

--'18100/POL/000178-533'

Declare @RefNo varchar(50) = '18181/POL/000091-533'
DECLARE @yearAD varchar(3) = LEFT(@RefNo,2)
Declare @Subclass varchar(3) = RIGHT(@RefNo,3)
Declare @BranchCode varchar(3) = RIGHT(LEFT(@RefNo,5),3)
Declare @Type varchar(3) = RIGHT(LEFT(@RefNo,9),3)
Declare @BranchId uniqueidentifier
Declare @PremiumSchedule_Id uniqueidentifier
Declare @PolicyItemPremiumTarget_Id uniqueidentifier

print @Type
print @BranchCode
print @yearAD
print @Subclass

select a.Id as AgreementId,a.InsuranceApplication_Id, b.Id as PremiumScheduleId, c.Id as PaymentApplication, 
d.ReferenceNumber, d.Id as PaymentId, d.Discriminator,
f.Id as PaymentRole_Id, e.Id as PolicyItemPremiumId,
k.Id as PolicyItemPremium_Id
from Agreement a
left join PremiumSchedule b on (a.InsuranceApplication_Id = b.InsuranceApplication_Id)
left join PolicyItemPremium k on (b.Id = k.PremiumSchedule_Id)
left join PaymentApplication c on (b.Id = c.PremiumSchedule_Id)
left join Payment d on (c.Payment_Id = d.Id)
left join PaymentRole f on (f.Payment_Id = d.Id)
left join PolicyItemPremium e on (b.Id = e.PremiumSchedule_Id)
left join DependencyContextItem j on (j.DependencyContextId = a.InsuranceApplication_Id and (f.PersonIdentification_Id = j.DependencyContextItemId or f.CompanyRegistration_Id = j.DependencyContextItemId))
where a.ReferenceNumber = @RefNo and a.Discriminator = 'InsurancePolicy'

DECLARE @PaymentTarget_Id uniqueidentifier = newId()
DECLARE @InAppId uniqueidentifier
DECLARE @InsuranceProductCategory_Id uniqueidentifier
DECLARE @Disciminator varchar(50)
DECLARE @UserName varchar(20) = 'vichayas'

select @InAppId = a.InsuranceApplication_Id, 
      @InsuranceProductCategory_Id = f.InsuranceProductCategoryId,
	  @BranchId = c.BranchId,
	  @PremiumSchedule_Id = b.Id,
	  @PolicyItemPremiumTarget_Id = e.Id
from Agreement a
inner join InsuranceApplication f on (a.InsuranceApplication_Id = f.Id)
left join PremiumSchedule b on (a.InsuranceApplication_Id = b.InsuranceApplication_Id)
left join PaymentApplication c on (b.Id = c.PremiumSchedule_Id)
left join Payment d on (c.Payment_Id = d.Id)
left join PolicyItemPremium e on (b.Id = e.PremiumSchedule_Id)
where a.ReferenceNumber = @RefNo

DECLARE @TypeId varchar(100)
DECLARE @PartyRoleId varchar(100)
		DECLARE @VatDate datetime = NULL

		IF @Subclass = '511' or  @Subclass = '515' 
		   BEGIN
			   SET @Disciminator = 'InsuranceTaxInvoice'
			   SET @TypeId = '1634B132-4285-4D54-87A9-6A3770A0AD2D'
				SET @VatDate = GETDATE()
		   END
		 ELSE IF @Subclass = '533' or  @Subclass = '569' 
		   BEGIN
			   SET @Disciminator = 'InsuranceCustomerReceipt'
			   SET @TypeId = '1634B132-4285-4D54-87A9-6A3770A0AD2D'
		   END
		ELSE
			BEGIN
				SET @Disciminator = 'InsuranceCustomerReceipt'
				SET @TypeId = '2CF5008B-C398-40C4-A173-0DF16969BC3B'
			END

		SELECT @PartyRoleId = Id
		FROM PartyRole a
		WHERE a.InsuranceApplication_Id = @InAppId 
		and a.[Type_Id] =@TypeId --����͡������� or �����һ�Сѹ



BEGIN TRY
	BEGIN TRANSACTION
		print '1. Insert Payment'
		INSERT INTO Payment (Id, IsWaitQueueProcess, 
							BranchCode, BranchId, RunningNumber,
							IsLastest,  TotalBeforeFee, TotalAfterFee,
							TotalDuty,  TotalTax, ExchangeTotalBeforeFee,
							ExchangeTotalAfterFee, ExchangeTotalDuty, ExchangeTotalTax,
							IssuedDate, Discriminator, CreatedDate,
							CreatedUserId, CreatedUserName, 
							VATDate)
		SELECT @PaymentTarget_Id,  0, 
			   BranchCode, BranchId, NULL,
			   1,PremiumAmount,TotalAmount,
			   StampsDutyAmount,VatAmount,0,
			   0,0,0,
			   GETDATE(),@Disciminator,GETDATE(),
			   'AddPayment', @UserName,
			   @VatDate
		FROM PremiumSchedule
		WHERE InsuranceApplication_Id = @InAppId 

		--Declare @refNo varchar(30)
		DECLARE @runningNumberPOL int
		DECLARE @runningNumber int
		DECLARE @DocAvailabilityId uniqueidentifier


			DECLARE @DocRunConfigId varchar(100)
		IF (@Subclass = '511' or  @Subclass = '515' )
			BEGIN
				select @DocRunConfigId  = Id
				from DocumentRunningConfigurationAvailability 
				WHERE InsuranceProductCategory_Id = @InsuranceProductCategory_Id
				and DocumentRunningConfiguration_Id = '1B7AD7C7-41AF-4C81-9D7D-E288E3E8EA44' --VAT
			END;
		ELSE
			BEGIN
				select @DocRunConfigId  = Id
				from DocumentRunningConfigurationAvailability 
				WHERE InsuranceProductCategory_Id = @InsuranceProductCategory_Id
				and DocumentRunningConfiguration_Id = '5DE8D973-A89F-400B-BEDB-3492620CE8B9' --RCP
			END;
	
		print CONCAT('1. Insert #DocumentRunningRegistration 1 DocId =',@DocRunConfigId, ' Subclass = ',@Subclass,' Branc = ',@BranchCode)
		select top 1 * 
		into #DocumentRunningRegistration
		from DocumentRunningRegistration
		-- WITH (TABLOCK, HOLDLOCK)
		where BranchCode = @BranchCode 
		and SubClass = @Subclass
		and YearAD = @yearAD
		and DocumentRunningConfigurationAvailability_Id = @DocRunConfigId
		order by RunningNumber desc

		select * from #DocumentRunningRegistration
		
		SET @runningNumber = NULL

		select @runningNumber = RunningNumber+1 from #DocumentRunningRegistration where DocumentRunningConfigurationAvailability_Id = @DocRunConfigId

		if(@runningNumber is null)
			SET @runningNumber = 1

		IF (@Subclass = '511' or  @Subclass = '515')
			select @refNo = dbo.GenReferenceNumber(@runningNumber,0,1,@BranchCode,@Subclass,@yearAD,NULL)
		ELSE
			select @refNo = dbo.GenReferenceNumber(@runningNumber,0,0,@BranchCode,@Subclass,@yearAD,NULL)

		if(@runningNumber = 1)
			BEGIN
				
				print  '1. Insert DocumentRunningRegistration'
				INSERT INTO DocumentRunningRegistration (Id, DescriptionTH, DescriptionEN, RunningNumber, 
														TargetId,CreatedDate,CreatedUserId,CreatedUserName,
														YearAD, SubClass, BranchCode, DocumentRunningConfigurationAvailability_Id)
				VALUES (newId(),@refNo,@refNo,@runningNumber,
						@PaymentTarget_Id,GETDATE(),'ByPassToPolicy', @UserName,
						@yearAD, @Subclass, @BranchCode,@DocRunConfigId)

			END;
		else
			BEGIN
				print CONCAT('1. Update #DocumentRunningRegistration 2 DocId =',@DocRunConfigId)
				UPDATE #DocumentRunningRegistration
				SET Id = newId(),
					DescriptionTH = @refNo,
					DescriptionEN = @refNo,
					RunningNumber = @runningNumber,
					TargetId = @PaymentTarget_Id,
					CreatedDate = GETDATE(),
					CreatedUserId = 'ByPassToPolicy',
					CreatedUserName = @UserName,
					ModifiedDate = NULL,
					ModifiedUserId = NULL,
					ModifiedUserName = NULL
				where DocumentRunningConfigurationAvailability_Id = @DocRunConfigId
			END;

		if(@runningNumber > 1)
			BEGIN
				print '1. Insert DocumentRunningRegistration'
				INSERT INTO DocumentRunningRegistration
				SELECT * FROM #DocumentRunningRegistration
			END;

		
		print CONCAT('2. Insert Payment Id = ',@PaymentTarget_Id)
		UPDATE Payment
		SET ReferenceNumber = @refNo,
			RunningNumber = @runningNumber
		where Id = @PaymentTarget_Id

		
		--======== Insert PaymentApplication
		print '3. Insert PaymentApplication'
		INSERT INTO PaymentApplication (Id, BranchCode, BranchId,
										PremiumSchedule_Id, PolicyItemPremium_Id, Payment_Id, 
										CreatedDate, CreatedUserId, CreatedUserName, Discriminator)
		VALUES (newId(), @BranchCode, @BranchId,
				@PremiumSchedule_Id, @PolicyItemPremiumTarget_Id, @PaymentTarget_Id,
				GETDATE(),'ByPassToPolicy',@UserName, 'PremiumPaymentApplication')
		--======= End 

		--======= Insert PaymentRole
		print CONCAT('4. Insert PaymentRole = ',@PartyRoleId)
		INSERT INTO PaymentRole (Id, SequenceNo, BranchCode, BranchId,
								Payment_Id, PartyRole_Id, [Type_Id],
								Party_Id, PersonName_Id, PersonIdentification_Id,
								PartyClassificationTH_Id, PartyClassificationEN_Id,
								OrganizationName_Id, CompanyRegistration_Id,
								ContactMechanism_Id,PaymentRoleType_Id,
										CreatedDate, CreatedUserId, CreatedUserName)
		select top 1  newId(), 1, @BranchCode, @BranchId,
				@PaymentTarget_Id, a.Id as PartyRole_Id, a.[Type_Id],
				a.Party_Id, e.Id as PersonName_Id,i.Id as  PersonIdentification_Id, 
				c.Id as PartyClassificationTH_Id, d.Id as PartyClassificationEN_Id,
				b.Id as OrganizationName_Id, f.Id as CompanyRegistration_Id,
				g.ContactMechanism_Id, '052CD53C-526D-4124-BE90-3E323D5BC194' ,
				GETDATE(),'ByPassToPolicy',@UserName
		From PartyRole a 
		left join OrganizationName b on (a.Party_Id = b.Organization_Id and b.ThruDate is NULL)
		left join PartyClassification c on (a.Party_Id = c.Party_Id and c.SequencePartyType = 1 and c.Party_Id is not null and c.ThruDate is null)
		left join PartyClassification d on (a.Party_Id = d.Party_Id and d.SequencePartyType = 2 and d.Party_Id is not null and d.ThruDate is null)
		left join PersonName e on (a.Party_Id = e.Person_Id and e.ThruDate is null)
		left join CompanyRegistration f on (a.Party_Id = f.Organization_Id  and e.ThruDate is null) --เลขผู้เสียภาษี
		left join InsuranceApplicationRoleContactMechanism g on (a.Id = g.InsuranceApplicationRole_Id  and g.ShowOnPolicy = 1 and (g.ContactMechanismPurposeType_Id = '636B3BA8-9158-4AEE-A669-5B2F2D7DC5BB' or g.ContactMechanismPurposeType_Id = 'E3A26D7E-94C2-439F-9B8A-A644078304B2')) --จัดส่งใบเสร็จ/ใบกำกับภาษี
		left join Citizenship h on (a.Party_Id = h.Person_Id)
		left join PersonIdentification i on (i.Citizenship_Id = h.Id and i.[Type_Id] is not null)
		inner join DependencyContextItem j on (j.DependencyContextId = a.InsuranceApplication_Id and (i.Id = j.DependencyContextItemId or f.Id = j.DependencyContextItemId))
		where a.Id = @PartyRoleId --@PartyRole
		order by e.ModifiedDate, b.ModifiedDate DESC

		IF @@ROWCOUNT != 1
			ROLLBACK
		--===== End
		drop table #DocumentRunningRegistration
	COMMIT TRANSACTION
END TRY
BEGIN CATCH

    IF @@TRANCOUNT > 0
        ROLLBACK
END CATCH