/*
Create an Invoice
*/

--UPDATE PolicyItemPremium
--SET PremiumSchedule_Id = null
--where Id = '82B3E16C-321C-4090-ADB7-6A2B377E776A'

--select * from Agreement where InsuranceApplication_Id = 'C7D03F55-E6F7-4C4C-98B3-9E79CB679048'

Declare @RefNo varchar(50) = '18181/END/000061-574'
DECLARE @yearAD varchar(3) = LEFT(@RefNo,2)
Declare @Subclass varchar(3) = RIGHT(@RefNo,3)
Declare @BranchCode varchar(3) = RIGHT(LEFT(@RefNo,5),3)
Declare @Type varchar(3) = RIGHT(LEFT(@RefNo,9),3)
Declare @BranchId uniqueidentifier
Declare @PremiumSchedule_Id uniqueidentifier
Declare @PolicyItemPremiumTarget_Id uniqueidentifier
Declare @PolicyNo varchar(50)



print @Type
print @BranchCode
print @yearAD
print @Subclass

select a.Id as AgreementId,a.InsuranceApplication_Id, b.Id as PremiumScheduleId, c.Id as PaymentApplication, 
d.ReferenceNumber, d.Id as PaymentId, d.Discriminator,
f.Id as PaymentRole_Id, e.Id as PolicyItemPremiumId,
j.Id as DependencyContextItemId
from Agreement a
left join PremiumSchedule b on (a.InsuranceApplication_Id = b.InsuranceApplication_Id)
left join PaymentApplication c on (b.Id = c.PremiumSchedule_Id)
left join Payment d on (c.Payment_Id = d.Id)
left join PaymentRole f on (f.Payment_Id = d.Id)
left join PolicyItemPremium e on (b.Id = e.PremiumSchedule_Id)
left join PaymentRole g on (g.Payment_Id = d.Id)
left join DependencyContextItem j on (j.DependencyContextId = a.InsuranceApplication_Id and (g.PersonIdentification_Id = j.DependencyContextItemId or g.CompanyRegistration_Id = j.DependencyContextItemId))
where a.ReferenceNumber = @RefNo

--select top 2 * from DocumentRunningRegistration 
--where YearAD = @yearAD
--and SubClass = @Subclass
--and BranchCode = @BranchCode
--and DescriptionTH like '%RCP%'
--and DocumentRunningConfigurationAvailability_Id = 'E16E5273-6654-4D3B-884D-26CC161F3AD5'
--order by RunningNumber desc

delete Payment where Id = '986C5D4A-3F64-4150-ACFF-5DA73786972D'

DECLARE @PaymentTarget_Id uniqueidentifier = newId()
DECLARE @InAppId uniqueidentifier
DECLARE @InsuranceProductCategory_Id uniqueidentifier
DECLARE @Disciminator varchar(50)
DECLARE @UserName varchar(20) = 'vichayas'
DECLARE @Vat integer = 0
DECLARE @END_Sequence varchar(2) = null
DECLARE @VATReferenceBeforeFee float
DECLARE @VATReferenceAfterFee float
DECLARE @ReferenceDate varchar(30)

select @InAppId = a.InsuranceApplication_Id, 
      @InsuranceProductCategory_Id = f.InsuranceProductCategoryId,
	  @BranchId = c.BranchId,
	  @PremiumSchedule_Id = b.Id,
	  @PolicyItemPremiumTarget_Id = e.Id,
	  @Vat = b.VatAmount,
	  @PolicyNo = f.PolicyNumber,
	  @END_Sequence = f.END_Sequence,
	  @VATReferenceBeforeFee = b.PremiumAmount+b.StampsDutyAmount,
	  @VATReferenceAfterFee=0,
	  @ReferenceDate = a.CreatedDate
from Agreement a
inner join InsuranceApplication f on (a.InsuranceApplication_Id = f.Id)
left join PremiumSchedule b on (a.InsuranceApplication_Id = b.InsuranceApplication_Id)
left join PaymentApplication c on (b.Id = c.PremiumSchedule_Id)
left join Payment d on (c.Payment_Id = d.Id)
left join PolicyItemPremium e on (b.Id = e.PremiumSchedule_Id)
where a.ReferenceNumber = @RefNo

print CONCAT('@Vat =',@Vat)

DECLARE @TypeId varchar(100)
DECLARE @PartyRoleId varchar(100)
DECLARE @VatReferenceNumber varchar(100)
		DECLARE @VatDate datetime = NULL

		IF @Vat < 0
			BEGIN
				SET @Disciminator = 'InsuranceCreditNote'
			   SET @TypeId = '1634B132-4285-4D54-87A9-6A3770A0AD2D'
			   SET @VatReferenceNumber = @PolicyNo
				SET @VatDate = GETDATE()
			END
		ELSE IF @Subclass = '511' or  @Subclass = '515' 
		   BEGIN
			   SET @Disciminator = 'InsuranceTaxInvoice'
			   SET @TypeId = '1634B132-4285-4D54-87A9-6A3770A0AD2D'
			   SET @VatReferenceNumber = @PolicyNo
				SET @VatDate = GETDATE()
				SET @END_Sequence = null
				SET  @VATReferenceBeforeFee = null
				SET  @VATReferenceAfterFee=null
				SET  @ReferenceDate = null
		   END
		 ELSE IF @Subclass = '533' or  @Subclass = '569' 
		   BEGIN
			   SET @Disciminator = 'InsuranceCustomerReceipt'
			   SET @TypeId = '1634B132-4285-4D54-87A9-6A3770A0AD2D'
				SET @END_Sequence = null
				SET  @VATReferenceBeforeFee = null
				SET  @VATReferenceAfterFee=null
				SET  @ReferenceDate = null
		   END
		
		ELSE
			BEGIN
				SET @Disciminator = 'InsuranceCustomerReceipt'
				SET @TypeId = '2CF5008B-C398-40C4-A173-0DF16969BC3B'
				SET @END_Sequence = null
				SET  @VATReferenceBeforeFee = null
				SET  @VATReferenceAfterFee=null
				SET  @ReferenceDate = null
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
							VATDate, VATReferenceNumber, PolicyNumber,
							VATReferenceBeforeFee , VATReferenceAfterFee ,
							ReferenceDate , END_Sequence )
		SELECT @PaymentTarget_Id,  0, 
			   BranchCode, BranchId, NULL,
			   1,PremiumAmount,TotalAmount,
			   StampsDutyAmount,VatAmount,0,
			   0,0,0,
			   GETDATE(),@Disciminator,GETDATE(),
			   'AddPayment', @UserName,
			   @VatDate, @VatReferenceNumber, @VatReferenceNumber,
			   @VATReferenceBeforeFee, @VATReferenceAfterFee,
			   @ReferenceDate, @END_Sequence
		FROM PremiumSchedule
		WHERE InsuranceApplication_Id = @InAppId 

		--Declare @refNo varchar(30)
		DECLARE @runningNumberPOL int
		DECLARE @runningNumber int
		DECLARE @DocAvailabilityId uniqueidentifier
		DECLARE @DocRunningConfigId varchar(100)


			DECLARE @DocRunConfigId varchar(100)
		IF @Vat < 0
			BEGIN
				SET @DocRunningConfigId =  'ECE2619C-7317-4F88-B44E-ABEF82058308'
				select @DocRunConfigId  = Id
				from DocumentRunningConfigurationAvailability 
				WHERE InsuranceProductCategory_Id = @InsuranceProductCategory_Id
				and DocumentRunningConfiguration_Id = @DocRunningConfigId --DEC
			END
		ELSE IF (@Subclass = '511' or  @Subclass = '515' )
			BEGIN
				SET @DocRunningConfigId =  '1B7AD7C7-41AF-4C81-9D7D-E288E3E8EA44' 
				select @DocRunConfigId  = Id
				from DocumentRunningConfigurationAvailability 
				WHERE InsuranceProductCategory_Id = @InsuranceProductCategory_Id
				and DocumentRunningConfiguration_Id = @DocRunningConfigId --VAT
			END;
		ELSE
			BEGIN
				SET @DocRunningConfigId =  '5DE8D973-A89F-400B-BEDB-3492620CE8B9'
				select @DocRunConfigId  = Id
				from DocumentRunningConfigurationAvailability 
				WHERE InsuranceProductCategory_Id = @InsuranceProductCategory_Id
				and DocumentRunningConfiguration_Id = @DocRunningConfigId --RCP
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

			select @refNo = dbo.GenReferenceNumber2(@runningNumber,@BranchCode,@Subclass,@yearAD,NULL,@DocRunningConfigId)


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
		
		print CONCAT('4. Insert PaymentRole PartyRole= ',@PartyRoleId)
		INSERT INTO PaymentRole (Id, SequenceNo, BranchCode, BranchId,
								Payment_Id, PartyRole_Id, [Type_Id],
								Party_Id, PersonName_Id, PersonIdentification_Id,
								PartyClassificationTH_Id, PartyClassificationEN_Id,
								OrganizationName_Id, CompanyRegistration_Id,
								ContactMechanism_Id,PaymentRoleType_Id,
										CreatedDate, CreatedUserId, CreatedUserName)
		select top 1 newId(), 1, @BranchCode, @BranchId,
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
		left join CompanyRegistration f on (a.Party_Id = f.Organization_Id  and e.ThruDate is null and e.Type_Id = 'F8E30A8A-00DE-4A77-AD47-10CF35F923F4') --เลขผู้เสียภาษี
		left join InsuranceApplicationRoleContactMechanism g on (a.Id = g.InsuranceApplicationRole_Id  and g.ShowOnPolicy = 1 and (g.ContactMechanismPurposeType_Id = '636B3BA8-9158-4AEE-A669-5B2F2D7DC5BB' or g.ContactMechanismPurposeType_Id = 'E3A26D7E-94C2-439F-9B8A-A644078304B2')) --จัดส่งใบเสร็จ/ใบกำกับภาษี
		left join Citizenship h on (a.Party_Id = h.Person_Id)
		left join PersonIdentification i on (i.Citizenship_Id = h.Id and i.[Type_Id] is not null)
		left join DependencyContextItem j on (j.DependencyContextId = a.InsuranceApplication_Id and (i.Id = j.DependencyContextItemId or f.Id = j.DependencyContextItemId))
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