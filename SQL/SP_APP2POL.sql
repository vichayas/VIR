USE [VIS_DB]
GO
/****** Object:  StoredProcedure [dbo].[AppToPolicy_New]    Script Date: 15/02/2018 8:34:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER PROCEDURE [dbo].[AppToPolicy_New] 
@AppNo varchar(50),
@UserName varchar(50)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

		DECLARE @BranchCode Varchar(4)
		DECLARE @BranchId uniqueidentifier
		DECLARE @InAppId uniqueidentifier 
		DECLARE @AppAgreement_Id uniqueidentifier
		DECLARE @yearYD varchar(3) = LEFT(@AppNo,2)
		--DECLARE @UserName varchar(50) = 'vichayas'

		--======= Find InAppId & AppAgreement_Id ==================
		SELECT @AppAgreement_Id = Id, @InAppId = InsuranceApplication_Id
		FROM Agreement WHERE ReferenceNumber = @AppNo
		--==============================================================

		DECLARE @ApprovalTrackingId uniqueidentifier = newId()
		DECLARE @ApprovalTrackingItemId uniqueidentifier = newId()
		DECLARE @PolicyId uniqueidentifier = newId()
		DECLARE @PaymentId uniqueidentifier = newId()
		DECLARE @ApprovalConfigurationId uniqueidentifier;
		DECLARE @ApprovalConfigurationItemId uniqueidentifier;

		--1.Find ApprovalConfigurationId and ApprovalConfigurationItemId

		SELECT 
		@ApprovalConfigurationId  = b.Id,
		@ApprovalConfigurationItemId = d.Id,
		@BranchCode = b.BranchCode,
		@BranchId = b.BranchId
		FROM ApprovalConfigurationAvailability a
		inner join ApprovalConfiguration b on (a.ApprovalConfiguration_Id = b.Id)
		inner join ApprovalContentType c on (b.ApprovalContentType_Id = c.Id)
		inner join ApprovalConfigurationItem d on (a.ApprovalConfiguration_Id = d.ApprovalConfiguration_Id)
		inner join ControllerAction e on (a.ControllerAction_Id = e.Id)
		WHERE ControllerName = 'InsuranceApplication' and ActionName = 'NewCreate'

BEGIN TRY
		--2.Insert ApprovalTracking
		BEGIN TRANSACTION 
		print CONCAT('1. Insert ApprovalTracking Id = ',@ApprovalTrackingId)
		INSERT INTO ApprovalTracking (Id, TokenId, IsEnded, CreatedDate, ApprovalConfiguration_Id)
		VALUES (@ApprovalTrackingId, @AppAgreement_Id, 0, GETDATE(), @ApprovalConfigurationId)

		--3.Insert ApprovalTrackingItem
		print CONCAT('2. Insert ApprovalTrackingItem Id = ',@ApprovalTrackingItemId)
		INSERT INTO ApprovalTrackingItem (Id, Sequence, IsLatest, ApprovalKey, CreatedDate, ApprovalTracking_Id, Approvalconfigurationitem_id)
		values (@approvaltrackingitemid, 1, 1, 'ap001', getdate(), @approvaltrackingid, @approvalconfigurationitemid)

		--4. Insert InsuranceApplicationItem
		--4.1 Find Party Role of the insured 
		DECLARE @PartyRoleId uniqueidentifier
		DECLARE @InsuranceApplicationItem_Id uniqueidentifier
		DECLARE @InsuranceProductCategory_Id uniqueidentifier
		DECLARE @InsuranceApplicationRoleItem uniqueidentifier
		DECLARE @Subclass varchar(10)
		DECLARE @InsuranceApplicationItemTarget_Id uniqueidentifier = newId()
		DECLARE @InsuranceBranchOwnerId uniqueidentifier
		DECLARE @PolicyCode varchar(3)

		
		print CONCAT('@InAppId = ',@InAppId)
		SELECT  @InsuranceBranchOwnerId = InsuranceBranchOwnerId, @Subclass = b.Code, @InsuranceProductCategory_Id = a.InsuranceProductCategoryId 
		FROM InsuranceApplication a
		INNER JOIN ProductCategory b on (a.InsuranceProductCategoryId = b.Id)
		WHERE a.Id =@InAppId

		SELECT @PolicyCode = PolicyCode from PartyRole where Id = @InsuranceBranchOwnerId

		SELECT PolicyCode = @PolicyCode
		--SELECT @InsuranceProductCategory_Id = InsuranceProductCategoryId FROM InsuranceApplication WHERE Id =@InAppId

		SELECT a.*
		INTO #SubClassDiscount
		FROM ProductFeature a
		inner join ProductCategory b on (a.InsuranceProductCategory_Id = b.Id and b.Id = @InsuranceProductCategory_Id) -- SubclassId = '4f2cdaff-a8ee-4c25-a585-0261cd54ea28'
		inner join ProductFeatureIntegration c on (c.Parent_Id = a.Id)
		inner join InsuranceProductFeaturePurposeType d on (a.InsuranceProductFeaturePurposeType_Id = d.Id)
		WHERE d.Id =  '83EEE16C-76AA-426E-8C71-C5EBB7AA38BA' or --��ǹŴ��������
		d.Id = '67B7AF52-914B-4D54-B0AE-BDDCA7098549' --������������ǹ�á SubClass
		order by a.CalculatedSequence, a.Sequence


		--DECLARE @TypeId varchar(100)
		--IF (@Subclass = '511' or @Subclass = '515' or @Subclass = '533')
		--	SET @TypeId = '1634B132-4285-4D54-87A9-6A3770A0AD2D'
		--ELSE
		--	SET @TypeId = '2CF5008B-C398-40C4-A173-0DF16969BC3B'

		--SELECT @PartyRoleId = Id
		--FROM PartyRole a
		--WHERE a.InsuranceApplication_Id = @InAppId 
		--and a.[Type_Id] =@TypeId --ผู้ถือกรมธรรม์ or ผู้เอาประกัน

		select @PartyRoleId = a.Id
		from PartyRole a
		inner join InsuranceApplicationRoleItem b on (a.Id = b.InsuranceApplicationRole_Id)
		where  a.InsuranceApplication_Id = @InAppId AND b.IsPayment = 1

		--4.2 Find the prevoius InsuranceApplicationRoleItem
		print CONCAT('@PartyRoleId = ',@PartyRoleId)
		SELECT @InsuranceApplicationItem_Id = InsuranceApplicationItem_Id
		FROM InsuranceApplicationRoleItem
		WHERE InsuranceApplicationRole_Id = @PartyRoleId
		AND IsPayment = 1 --Update for 511

		--4.3 insert InsuranceApplicationItem for ����͡������� 
		print @InsuranceApplicationItemTarget_Id
		print @InsuranceApplicationItem_Id

		SELECT *
		INTO #InsuranceApplicationItem
		FROM InsuranceApplicationItem
		WHERE Id = @InsuranceApplicationItem_Id

		Update #InsuranceApplicationItem
		SET Id = @InsuranceApplicationItemTarget_Id,
			CreatedUserId = 'ByPassToPolicy',
			CreatedUserName = @UserName,
			ModifiedDate = NULL,
			ModifiedUserId = NULL,
			ModifiedUserName = NULL

	
				DECLARE @InAppItemOfApplicationId uniqueidentifier
				SELECT @InAppItemOfApplicationId = Id, @BranchId = BranchId, @BranchCode = BranchCode
				FROM InsuranceApplicationItem
				WHERE InsuranceApplication_Id = @InAppId
				 and InsuranceApplicationItemType_Id = 'F89579DB-7C44-409F-8D50-A0061D29D04E'

		IF @InsuranceProductCategory_Id = '4f2cdaff-a8ee-4c25-a585-0261cd54ea28' -- Subclass 563
			BEGIN
				-- 4.4 Insert �дѺ��ǹŴ ��ǹ�����ͧ㺵Ӣ� (563)
				---DECLARE @BranchCode varchar(10)
				DECLARE @InAppItemOfCoverageId uniqueidentifier = newId()


				 INSERT INTO #InsuranceApplicationItem (Id, IsShowOnPolicy, ProductFeatureConditionValue,
														Amount, BranchCode,
														BranchId,Discriminator, InsuranceApplication_Id,
														Parent_Id,InsuranceApplicationItemType_Id)
				VALUES( @InAppItemOfCoverageId, 0, 0,
						0,@BranchCode, 
						@BranchId, 'InsuranceApplicationItem',@InAppId,
						@InAppItemOfApplicationId, '1FF63025-9034-4A81-B935-D5BD889E810D'
					 )


				-- 4.4 Insert �ԡѴ�ѵ������ 2 record for (563)
				SELECT * FROM #SubClassDiscount

				INSERT INTO #InsuranceApplicationItem (Id, IsShowOnPolicy, InsuranceRateValue,
														InsuranceRateUOMId, Amount, BranchCode,
														BranchId,Discriminator, InsuranceApplication_Id,
														Parent_Id,InsuranceProductFeaturePurposeType_Id,ProductFeature_Id,
														InsuranceApplicationItemType_Id)
				SELECT NEWID(), 0, 0,
					   InsuranceRateUOMId, 0,BranchCode, 
					   BranchId, 'InsuranceApplicationItem',@InAppId,
					   @InAppItemOfCoverageId, InsuranceProductFeaturePurposeType_Id, Id,
					   '28818507-5151-402C-BAE6-C655349C5082'
				FROM #SubClassDiscount

				Update #InsuranceApplicationItem
				SET CreatedDate = GETDATE(),
					CreatedUserId = 'ByPassToPolicy',
					CreatedUserName = @UserName,
					ModifiedDate = NULL,
					ModifiedUserId = NULL,
					ModifiedUserName = NULL

	
			 END

		print '3.Insert InsuranceApplicationItem '
		INSERT INTO InsuranceApplicationItem
		SELECT * FROM #InsuranceApplicationItem		

		--5. Insert InsuranceApplicationItemFee
		SELECT * 
		INTO #InsuranceApplicationItemFee
		FROM InsuranceApplicationItemFee
		WHERE InsuranceApplicationPackageItem_Id = @InAppItemOfApplicationId

		UPDATE #InsuranceApplicationItemFee
		SET Id = newId(),
			CreatedDate = GETDATE(),
			CreatedUserId = 'ByPassToPolicy',
			CreatedUserName = @UserName,
			ModifiedDate = NULL,
			ModifiedUserId = NULL,
			ModifiedUserName = NULL


		DELETE InsuranceApplicationItemFee WHERE InsuranceApplicationPackageItem_Id = @InAppItemOfApplicationId

		print '4. Insert InsuranceApplicationItemFee '
		 INSERT INTO InsuranceApplicationItemFee
		SELECT * FROM #InsuranceApplicationItemFee


		--6. Insert TABLE InsuranceApplicationRoleItem
		DECLARE @InAppRoleItemTarget_Id uniqueidentifier = newId()
		DECLARE @InAppRoleItemSource_Id uniqueidentifier 
		DECLARE @PayerName nvarchar(500) 

		Print CONCAT('Id @InsuranceApplicationItem_Id = ',@InsuranceApplicationItem_Id)
		SELECT @InAppRoleItemSource_Id = Id,@PayerName = PaymentRoleDescriptionTH FROM InsuranceApplicationRoleItem 
		WHERE InsuranceApplicationItem_Id = @InsuranceApplicationItem_Id
		and PaymentMethodType_Id = 'D9C58BFD-78B1-4575-B71C-358AB36E393E'

		SELECT * 
		INTO #InsuranceApplicationRoleItem 
		FROM InsuranceApplicationRoleItem 
		WHERE Id = @InAppRoleItemSource_Id


		UPDATE #InsuranceApplicationRoleItem
		SET Id = @InAppRoleItemTarget_Id,
			InsuranceApplicationItem_Id = @InsuranceApplicationItemTarget_Id,
			CreatedDate = GETDATE(),
			CreatedUserId = 'ByPassToPolicy',
			CreatedUserName = @UserName,
			ModifiedDate = NULL,
			ModifiedUserId = NULL,
			ModifiedUserName = NULL

		print '5. Insert InsuranceApplicationRoleItem '
		INSERT INTO InsuranceApplicationRoleItem
		SELECT * FROM #InsuranceApplicationRoleItem
 
		-- 7. Insert PolicyItemPremium
		DECLARE @PolicyItemPremiumTarget_Id uniqueidentifier = newId()
		DECLARE @PolicyItemPremiumSource_Id uniqueidentifier
		DECLARE @PremiumSchedule_Id uniqueidentifier

		SELECT @PremiumSchedule_Id =Id
		FROM PremiumSchedule
		WHERE InsuranceApplication_Id = @InAppId 


		SELECT *
		INTO #PolicyItemPremium
		FROM PolicyItemPremium
		WHERE PremiumSchedule_Id =  @PremiumSchedule_Id
		and InsuranceApplicationRoleItem_Id = @InAppRoleItemSource_Id
		print CONCAT('Id Premium  ',@PremiumSchedule_Id)
		print CONCAT('Id AppRoleItem  ',@InAppRoleItemSource_Id)
		
		SELECT * FROM #PolicyItemPremium

		SELECT @PolicyItemPremiumSource_Id = Id FROM #PolicyItemPremium
		
		UPDATE #PolicyItemPremium
		SET Id = @PolicyItemPremiumTarget_Id,
			InsuranceApplicationItem_Id = @InsuranceApplicationItemTarget_Id,
			InsuranceApplicationRoleItem_Id = @InAppRoleItemTarget_Id,
			CreatedDate = GETDATE(),
			CreatedUserId = 'ByPassToPolicy',
			CreatedUserName = @UserName,
			ModifiedDate = NULL,
			ModifiedUserId = NULL,
			ModifiedUserName = NULL

		print '6. Insert PolicyItemPremium '
		 INSERT INTO PolicyItemPremium
		SELECT * FROM #PolicyItemPremium

		
		 
		--== 9.Insert to PartyRole of ���᷹ ��� ���˹��


		SELECT * 
		INTO #PartyRole
		FROM PartyRole 
		WHERE InsuranceApplication_Id = @InAppId 
		and [Type_Id] in  ('6A4014A6-2F41-4BDF-9506-483B081F2776', 'F1125715-9AB4-4426-8EFF-5776E10E8D1D')

		UPDATE #PartyRole
		SET Id = newId(),
			CreatedDate = GETDATE(),
			CreatedUserId = 'ByPassToPolicy',
			CreatedUserName = @UserName,
			ModifiedDate = NULL,
			ModifiedUserId = NULL,
			ModifiedUserName = NULL

		DELETE PartyRole WHERE InsuranceApplication_Id = @InAppId and [Type_Id] in  ('6A4014A6-2F41-4BDF-9506-483B081F2776', 'F1125715-9AB4-4426-8EFF-5776E10E8D1D')


		print '7. Insert PartyRole '
		INSERT INTO PartyRole
		SELECT * FROM #PartyRole

		-- ===== DELETE DATA =======
		DELETE PolicyItemPremium WHERE Id = @PolicyItemPremiumSource_Id
		print CONCAT('@InAppRoleItemSource_Id = ',@InAppRoleItemSource_Id)
		DELETE InsuranceApplicationRoleItem WHERE Id = @InAppRoleItemSource_Id
		print CONCAT('@@InsuranceApplicationItem_Id = ',@InsuranceApplicationItem_Id)
		DELETE InsuranceApplicationItem WHERE Id = @InsuranceApplicationItem_Id
		-- ==========================
		--= 10. Insert InsuranceApplicationStatus for change status -> Draft 
	
		SELECT *
		INTO #InsuranceApplicationStatus
		FROM InsuranceApplicationStatus
		WHERE InsuranceAgreement_Id = @AppAgreement_Id and ThruDate is null


		print '8.1 Update THruDate of Draft in InsuranceApplicationStatus '
		UPDATE InsuranceApplicationStatus
		SET ThruDate = GETDATE(),
			ModifiedDate = GETDATE(),
			ModifiedUserId = 'ByPassToPolicy',
			ModifiedUserName = @UserName
		WHERE InsuranceAgreement_Id = @AppAgreement_Id and
		[Type_Id] in ('AD77EEFA-8A33-4C74-83F4-BFFEAC2AE957')


		UPDATE #InsuranceApplicationStatus
		SET Id = newId(),
			[Type_Id] = 'DDFF3A10-963E-462B-82B5-892374782388',
			FromDate = GETDATE(),
			CreatedDate = GETDATE(),
			CreatedUserId = 'ByPassToPolicy',
			CreatedUserName = @UserName,
			ModifiedDate = NULL,
			ModifiedUserId = NULL,
			ModifiedUserName = NULL



		print '8.2 Insert a new status'
		 INSERT INTO InsuranceApplicationStatus
		SELECT * FROM #InsuranceApplicationStatus


		--Query to get ApprovalMatchedUser

		--== 10. insert ApprovalMatchedUser
		print '9. ApprovalMatchedUser'
		INSERT INTO ApprovalMatchedUser (Id, CreatedDate, ApprovalTrackingItem_Id, UserProfile_Id)
		SELECT newId() as Id, GETDATE() as CreatedDate, @ApprovalTrackingItemId as ApprovalTrackingItem_Id, T1.Id as UserProfile_Id
		FROM
		(
		SELECT e.Id 
		FROM NavigationMenuAccessibility a 
		inner join ControllerAction b on (a.ControllerAction_Id = b.Id and 
											ControllerName = 'InsuranceApplication'
											and ActionName = 'NewCreate')
		inner join NavigationMenuUsage c on (c.NavigationMenuAccessibility_Id = a.Id)
		inner join ApprovalKey d on (d.NavigationMenuUsage_Id = c.Id and d.[Key] ='AP001')
		inner join UserProfile e on (a.UserProfile_Id = e.Id)
		WHERE a.Discriminator = 'UserAccessibility'
		union
		--Group
		SELECT e.Id FROM
		NavigationMenuAccessibility a
		inner join ControllerAction b on (a.ControllerAction_Id = b.Id and 
											ControllerName = 'InsuranceApplication'
											and ActionName = 'NewCreate')
		inner join UserGroup c on (a.UserGroup_Id = c.Id)
		inner join UserGroupMembership d on (d.UserGroup_Id = c.Id)
		inner join UserProfile e on (d.UserProfile_Id = e.Id) 
		inner join NavigationMenuUsage f on (f.NavigationMenuAccessibility_Id = a.Id)
		inner join ApprovalKey g on (g.NavigationMenuUsage_Id = f.Id and g.[Key] ='AP001')
		WHERE a.Discriminator = 'GroupAccessibility'
		) as T1

		-- TABLE Agreement

		print '10. Update Agreement of APP to be Apporved'
		UPDATE Agreement
		SET CurrentApprovalResult = 2,
			CurrentApprovalKey = 'AP001',
			CurrentApprovalTrackingItemId = @ApprovalTrackingItemId,
			ModifiedDate = GETDATE(),
			ModifiedUserId = 'ByPassToPolicy',
			ModifiedUserName = @UserName
		WHERE Id = @AppAgreement_Id


		-- TABLE InsuranceApplication
		DECLARE @SignedDate CHAR(16)=CONCAT(CONVERT(char(11),GETDATE(),121), '00:00')
		--print @SignedDate
		DECLARE @GenerateReferenceNumberPaymentType VARCHAR(1) 
		SELECT @GenerateReferenceNumberPaymentType = GenerateReferenceNumberPaymentType
		FROM ProductCategory
		WHERE Id = 'E50873DF-D767-4DED-A5FA-4476635D2F81'
		IF(@GenerateReferenceNumberPaymentType = 'M')
			SET @GenerateReferenceNumberPaymentType = 'P'
		ELSE IF (@GenerateReferenceNumberPaymentType = 'A')
			SET @GenerateReferenceNumberPaymentType = 'N'

		

		print '11. Update InsuranceApplication of APP to be Apporved'
		UPDATE InsuranceApplication
		SET TransactionDate = @SignedDate,
			PolicyIssuedDate = @SignedDate,
			SignedDate = @SignedDate,
			StockReferenceNo = '',
			RelatedExternalPolicyReferenceNo = '',
			Reporter = '',
			ExchangeRateValue = 0,
			OldReferenceNumber = '',
			ExternalRelatedPolicyReferenceNo = '',
			GenerateReferenceNumberPaymentType =  @GenerateReferenceNumberPaymentType,
			AttachmentDescription = '',
			ModifiedDate = GETDATE(),
			ModifiedUserId = 'ByPassToPolicy',
			ModifiedUserName = @UserName
		WHERE Id =  @InAppId 

		--=== Draft -> Approval


		DECLARE @PaymentTarget_Id uniqueidentifier = newId()
		DECLARE @PolicyTarget_Id uniqueidentifier  = newId()


		--==== Insert Payment
		DECLARE @Disciminator varchar(50)
		DECLARE @VatDate datetime = NULL
		IF @Subclass = '511' or @Subclass = '515'
			BEGIN
				SET @Disciminator = 'InsuranceTaxInvoice'
				SET @VatDate = GETDATE()
			END
		ELSE
			SET @Disciminator = 'InsuranceCustomerReceipt'

		print '12. Insert Payment'
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
			   'ByPassToPolicy', @UserName,
			   @VatDate

		FROM PremiumSchedule
		WHERE InsuranceApplication_Id = @InAppId 

		--=== Insert Agreement of Policy
		SELECT * 
		INTO #AgreementPol
		FROM Agreement
		WHERE Id = @AppAgreement_Id

		UPDATE #AgreementPol
		SET Id = @PolicyTarget_Id,
			Discriminator = 'InsurancePolicy',
			CreatedDate = GETDATE(),
			CreatedUserId = 'ByPassToPolicy',
			CreatedUserName = @UserName,
			ModifiedDate = NULL,
			ModifiedUserId = NULL,
			ModifiedUserName = NULL


		--//// Reserve the ReferenceNumber for Pol and Payment \\\\
		/*
		'86B56355-CADE-47F7-8C15-1B551D0DBF79' => RCP
		'4206CE25-9D30-4B76-867F-6C2BC3D5A67C' => POL
		'EAE6FE20-1885-4CAA-8DBD-9A4DE174847B' => APP
		'47C2F6EA-4C28-4957-8FF2-823005A541B3' => VAT
		*/
		Declare @refNo varchar(30)
		Declare @refNoPol varchar(30)
		Declare @refNoPay varchar(30)
		DECLARE @runningNumberPOL int
		DECLARE @runningNumber int
		DECLARE @DocAvailabilityId uniqueidentifier
		-- Create Policy's reference number
		select @DocAvailabilityId = Id
		from DocumentRunningConfigurationAvailability 
		WHERE InsuranceProductCategory_Id = @InsuranceProductCategory_Id
		and DocumentRunningConfiguration_Id = '35FE7921-FCFA-4FCF-A73C-DE7A4730CDA6'

		--BEGIN TRANSACTION
		select top 1 * 
		into #DocumentRunningRegistration
		from DocumentRunningRegistration
		where BranchCode = @BranchCode 
		and SubClass = @Subclass
		and YearAD = @yearYD
		and DocumentRunningConfigurationAvailability_Id = @DocAvailabilityId
		order by RunningNumber desc

		select @runningNumberPOL = RunningNumber+1 from #DocumentRunningRegistration

		if(@runningNumberPOL is null)
			SET @runningNumberPOL = 1

		select @refNo = dbo.GenReferenceNumber(@runningNumberPOL,1,0,@BranchCode,@Subclass,@yearYD,@PolicyCode)

		if(@runningNumberPOL = 1)
			BEGIN
				INSERT INTO DocumentRunningRegistration (Id, DescriptionTH, DescriptionEN, RunningNumber, 
														TargetId,CreatedDate,CreatedUserId,CreatedUserName,
														YearAD, SubClass, BranchCode, DocumentRunningConfigurationAvailability_Id)
				VALUES (newId(),@refNo,@refNo,@runningNumberPOL,
						@PolicyTarget_Id,GETDATE(),'ByPassToPolicy', @UserName,
						@yearYD, @Subclass, @BranchCode, @DocAvailabilityId)

			END;
		else
			BEGIN
				UPDATE #DocumentRunningRegistration
				SET Id = newId(),
					DescriptionTH = @refNo,
					DescriptionEN = @refNo,
					RunningNumber = @runningNumberPOL,
					TargetId = @PolicyTarget_Id,
					CreatedDate = GETDATE(),
					CreatedUserId = 'ByPassToPolicy',
					CreatedUserName = @UserName,
					ModifiedDate = NULL,
					ModifiedUserId = NULL,
					ModifiedUserName = NULL
			END;


		
		UPDATE #AgreementPol
		SET ReferenceNumber = @refNo,
		RunningNumber = @runningNumberPOL

		SET @refNoPol = @refNo

		-- Create Payment's reference number



		DECLARE @DocRunConfigId varchar(100)
		IF (@Subclass = '511' or @Subclass = '515')
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

		INSERT into #DocumentRunningRegistration
		select top 1 * 
		from DocumentRunningRegistration
		-- WITH (TABLOCK, HOLDLOCK)
		where BranchCode = @BranchCode 
		and SubClass = @Subclass
		and YearAD = @yearYD
		and DocumentRunningConfigurationAvailability_Id = @DocRunConfigId
		order by RunningNumber desc

		SET @runningNumber = NULL

		select @runningNumber = RunningNumber+1 from #DocumentRunningRegistration where DocumentRunningConfigurationAvailability_Id = @DocRunConfigId

		if(@runningNumber is null)
			SET @runningNumber = 1

		IF (@Subclass = '511' or @Subclass = '515')
			select @refNo = dbo.GenReferenceNumber(@runningNumber,0,1,@BranchCode,@Subclass,@yearYD,@PolicyCode)
		ELSE
			select @refNo = dbo.GenReferenceNumber(@runningNumber,0,0,@BranchCode,@Subclass,@yearYD,@PolicyCode)

		if(@runningNumber = 1)
			BEGIN
				INSERT INTO DocumentRunningRegistration (Id, DescriptionTH, DescriptionEN, RunningNumber, 
														TargetId,CreatedDate,CreatedUserId,CreatedUserName,
														YearAD, SubClass, BranchCode, DocumentRunningConfigurationAvailability_Id)
				VALUES (newId(),@refNo,@refNo,@runningNumber,
						@PaymentTarget_Id,GETDATE(),'ByPassToPolicy', @UserName,
						@yearYD, @Subclass, @BranchCode,@DocRunConfigId)

			END;
		else
			BEGIN
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




 
 
		print '13. Insert Agreement'
		INSERT INTO Agreement
		SELECT * FROM #AgreementPol
		if(@runningNumber > 1 or @runningNumberPOL > 1)
			BEGIN
				SET @refNoPay = @refNo
				print '14. Insert DocumentRunningRegistration'
				INSERT INTO DocumentRunningRegistration
				SELECT * FROM #DocumentRunningRegistration
			END;

		
		print '15. Update Payment'
		UPDATE Payment
		SET ReferenceNumber = @refNo,
			RunningNumber = @runningNumber,
			PolicyNumber = @refNoPol
		where Id = @PaymentTarget_Id

		--COMMIT TRANSACTION

		--==================== End =======================================



		--======== Insert PaymentApplication
		
		print '15. Insert  PaymentApplication'
		print CONCAT('@@PolicyItemPremiumSource_Id = ',@PolicyItemPremiumSource_Id)
		print CONCAT('@PolicyItemPremiumTarget_Id = ',@PolicyItemPremiumTarget_Id)
		print @PolicyItemPremiumTarget_Id
		INSERT INTO PaymentApplication (Id, BranchCode, BranchId,
										PremiumSchedule_Id, PolicyItemPremium_Id, Payment_Id, 
										CreatedDate, CreatedUserId, CreatedUserName, Discriminator)
		VALUES (newId(), @BranchCode, @BranchId,
				@PremiumSchedule_Id, @PolicyItemPremiumTarget_Id, @PaymentTarget_Id,
				GETDATE(),'ByPassToPolicy',@UserName, 'PremiumPaymentApplication')
		--======= End 

		--======= Insert PaymentRole
		print '16. Insert  PaymentRole'
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
		left join CompanyRegistration f on (a.Party_Id = f.Organization_Id  and e.ThruDate is null) --เลขผู้เสียภาษี
		left join InsuranceApplicationRoleContactMechanism g on (a.Id = g.InsuranceApplicationRole_Id  and g.ShowOnPolicy = 1 and (g.ContactMechanismPurposeType_Id = '636B3BA8-9158-4AEE-A669-5B2F2D7DC5BB' or g.ContactMechanismPurposeType_Id = 'E3A26D7E-94C2-439F-9B8A-A644078304B2')) --จัดส่งใบเสร็จ/ใบกำกับภาษี
		left join Citizenship h on (a.Party_Id = h.Person_Id)
		left join PersonIdentification i on (i.Citizenship_Id = h.Id and i.[Type_Id] is not null)
		inner join DependencyContextItem j on (j.DependencyContextId = a.InsuranceApplication_Id and (i.Id = j.DependencyContextItemId or f.Id = j.DependencyContextItemId))
		where a.Id = @PartyRoleId --@PartyRole
		order by e.ModifiedDate, b.ModifiedDate DESC

		IF @@ROWCOUNT > 1 or @@ROWCOUNT = 0
			BEGIN
				ROLLBACK
				print 'Can not approved'
			END
		--===== End

		--======= Insert a new status for APP InsuranceStatus
		DELETE #InsuranceApplicationStatus
		
		print '17. Insert  InsuranceApplicationStatus To Approved'
		INSERT INTO #InsuranceApplicationStatus
		SELECT *
		FROM InsuranceApplicationStatus
		WHERE InsuranceAgreement_Id = @AppAgreement_Id and ThruDate is NULL
		print '17.1 Insert  InsuranceApplicationStatus To Approved'
		update insuranceapplicationstatus
		set thrudate = getdate(),
			modifieddate = getdate(),
			modifieduserid = 'bypasstopolicy',
			modifiedusername = @UserName
		where insuranceagreement_id = @appagreement_id and
		[type_id] = ('ddff3a10-963e-462b-82b5-892374782388')

		
		print '17.2 Insert  InsuranceApplicationStatus To Approved'
		UPDATE #InsuranceApplicationStatus
		SET Id = newId(),
			FromDate = GETDATE(),
			 ThruDate = NULL,
			[Type_Id] = '2F37C283-0BAD-4AFA-8849-8C09C6498EA0',
			CreatedDate = GETDATE(),
			CreatedUserId = 'ByPassToPolicy',
			CreatedUserName = @UserName,
			ModifiedDate = NULL,
			ModifiedUserId = NULL,
			ModifiedUserName = NULL
			WHERE [Type_Id] = 'DDFF3A10-963E-462B-82B5-892374782388'

		--===== Insert a new status for POL
		INSERT INTO InsuranceApplicationStatus
		SELECT * FROM #InsuranceApplicationStatus
		
		print '17.3 Insert  InsuranceApplicationStatus To Approved'
		UPDATE #InsuranceApplicationStatus
		SET Id = newId(),
			InsuranceAgreement_Id = @PolicyTarget_Id,
			FromDate = GETDATE(),
			 ThruDate = NULL,
			[Type_Id] = 'B33BB2E3-81EF-4B86-82F0-FABE63A263C2',
			CreatedDate = GETDATE(),
			CreatedUserId = 'ByPassToPolicy',
			CreatedUserName = @UserName,
			ModifiedDate = NULL,
			ModifiedUserId = NULL,
			ModifiedUserName = NULL
			WHERE [Type_Id] = '2F37C283-0BAD-4AFA-8849-8C09C6498EA0'
		
		
		print '17.4(END) Insert  InsuranceApplicationStatus To Approved'
		INSERT INTO InsuranceApplicationStatus
		SELECT * FROM #InsuranceApplicationStatus

		--============ Update Approved user

		--2.P Update ApprovalTracking
		
		print '18. Update  ApprovalTracking To Approved'
		UPDATE ApprovalTracking
		SET IsEnded = 1,
			ModifiedDate = GETDATE(),
			ModifiedUserId = 'ByPassToPolicy',
			ModifiedUserName = @UserName
			WHERE Id = @ApprovalTrackingId

		--3.P Update ApprovalTrackingItem
		
		print '19. Update  ApprovalTrackingItem To Approved'
		UPDATE ApprovalTrackingItem
		SET IsLatest = 0,
			ModifiedDate = GETDATE(),
			ModifiedUserId = 'ByPassToPolicy',
			ModifiedUserName = @UserName
			WHERE Id = @ApprovalTrackingItemId

		--======== Update ApprovalMatchedUser
		DECLARE @UserProfileId uniqueidentifier
		SELECT @UserProfileId = Id FROM UserProfile WHERE DescriptionTH = @UserName
		UPDATE ApprovalMatchedUser
		SET ApprovalResultType_Id = '6AA6BB2B-CC64-4DD3-BE0A-0FF1541626A0',
			ModifiedDate = GETDATE(),
			ModifiedUserId = 'ByPassToPolicy',
			ModifiedUserName = @UserName
		WHERE ApprovalTrackingItem_Id = @ApprovalTrackingItemId 
		AND UserProfile_Id = @UserProfileId

		
		--======== Add AgentCommission
		print '20. Insert AgentCommission'
		--Find InAppItemId
		DECLARE @InAppItemId varchar(100)
		DECLARE @PolAmount float
		select @InAppItemId = Id , @PolAmount = Amount
		from InsuranceApplicationItem 
		where InsuranceApplication_Id = @InAppId 
		and InsuranceApplicationItemType_Id = 'F89579DB-7C44-409F-8D50-A0061D29D04E' --ใบคำขอ

		--Find AgentId
		DECLARE @party_Id uniqueidentifier
		DECLARE @agent_Id uniqueidentifier
		select @party_Id = Party_Id 
		from PartyRole 
		where InsuranceApplication_Id = @InAppId and 
		[Type_Id] = '6A4014A6-2F41-4BDF-9506-483B081F2776'

		select @agent_Id = Id 
		from PartyRole 
		where Party_Id = @party_Id  and Discriminator = 'InsuranceAgent' and IsActive = 1
		print CONCAT('AGENT ID = ',@agent_Id);

		--Find RateId
		DECLARE @agentComRate_Id varchar(100)

		select @agentComRate_Id = a.Rate_Id
		from AgentCommission a
		inner join Agreement b on (a.Agreement_Id = b.Id)
		inner join AgentCommissionRate c on (a.Rate_Id = c.Id)
		where  a.Parent_Id is null  and c.Discriminator = 'AgentTotalCommissionRate'  and c.IsLatest = 1
		and  a.AgentId = @agent_Id AND RIGHT(b.ReferenceNumber,3) = @Subclass

		DECLARE @totalRate float
		DECLARE @totalAmount decimal(20,5)
		select @totalRate =Rate 
		from AgentCommissionRate
		where Id = @agentComRate_Id and IsLatest = 1

		SELECT top 1 * 
		INTO #AgentCommission
		from AgentCommission
		WHERE Rate_Id = @agentComRate_Id


		delete #AgentCommission 

		SET @totalAmount = (@PolAmount * @totalRate)/100
		DECLARE @newAgentCom_Id uniqueidentifier = newId()

		INSERT INTO #AgentCommission (Id,
									  AgentId,
									  TotalAmount,
									  SubTotalAmount,
									  RateAmount,
									  AgentToBrokerPaymentAmount,
									  CompanyToBrokerPaymentAmount,
									  IsLatest,
									  RevisionGroup,
									  BranchCode,
									  BranchId,
									  Rate_Id,
									  Premium_Id,
									  Agreement_Id,
									  CreatedDate,
									  CreatedUserId,
									  CreatedUserName)
		SELECT @newAgentCom_Id,
				@agent_Id,
				round(@totalAmount,2),
				@totalAmount,
				@totalRate,
				0,
				0,
				1,
				newId(),
				@BranchCode,
				@BranchId,
				Id,
				@InAppItemId, -- PremiumId
				@AppAgreement_Id, --AgreementId
				GETDATE(),
				'ByPassToPolicy',
				@UserName
		FROM AgentCommissionRate
		where Id = @agentComRate_Id and IsLatest = 1

		INSERT INTO #AgentCommission (Id,
									  AgentId,
									  TotalAmount,
									  RateAmount,
									  BranchCode,
									  BranchId,
									  Rate_Id,
									  Parent_Id,
									  Agreement_Id,
									  CreatedDate,
									  CreatedUserId,
									  CreatedUserName)
		SELECT newId(),
				@agent_Id,
				((@PolAmount*Rate)/100),
				Rate,
				@BranchCode,
				@BranchId,
				Id,
				@newAgentCom_Id,
				@AppAgreement_Id,--AgreementId
				GETDATE(),
				'ByPassToPolicy',
				@UserName
		FROM AgentCommissionRate
		where Parent_Id = @agentComRate_Id

		--========= Update data to total ===============
		If(@Subclass = 511)
			BEGIN
				UPDATE #AgentCommission
				SET ExtraAmount = T1.TotalAmount
				FROM 
				(
				SELECT SUM(a.TotalAmount) as TotalAmount
				FROM #AgentCommission a
				INNER JOIN AgentCommissionRate b on (a.Rate_Id = b.Id)
				INNER JOIN AgentCommissionRatePurposeType c on (b.AgentCommissionPurposeType_Id = c.Id)
				WHERE c.[Group] = 'Optional'
				GROUP BY c.[Group] 
				) as T1
				WHERE Id = @newAgentCom_Id


				UPDATE #AgentCommission
				SET StandardAmount = T2.TotalAmount
				FROM 
				(
				SELECT TotalAmount
				FROM #AgentCommission a
				WHERE a.Rate_Id = 'E9718FD6-5243-4698-ADF1-AA9D4DEE93EF' --ค่าตอบแทนมาตรฐาน
				) AS T2
				WHERE Id = @newAgentCom_Id
			 END
		 If(@Subclass = 563)
			 BEGIN
				UPDATE #AgentCommission
				SET ExtraAmount = 0,
					StandardAmount = T1.TotalAmount
				FROM 
				(
				SELECT SUM(a.TotalAmount) as TotalAmount
				FROM #AgentCommission a
				INNER JOIN AgentCommissionRate b on (a.Rate_Id = b.Id)
				INNER JOIN AgentCommissionRatePurposeType c on (b.AgentCommissionPurposeType_Id = c.Id)
				WHERE c.[Group] = 'Standard'
				GROUP BY c.[Group] 
				) as T1
				WHERE Id = @newAgentCom_Id
			 END

			 
			INSERT INTO AgentCommission
			select * from #AgentCommission
			 IF @@ROWCOUNT = 0
				BEGIN
					ROLLBACK
				END

		 --================ End Adding to AgentCommission
		DECLARE @RegisterNumber varchar(50)
		
		select @RegisterNumber = b.RegistrationNumber
		from DependencyContextItem a
		inner join CompanyRegistration b on (a.DependencyContextItemId = b.Id)
		where a.DependencyContextId = @InAppId and 
		a.DescriptionTH like 'System.Data.Entity.DynamicProxies.CompanyRegistration%'

		PRINT '---------------------------------------------------------------'
		PRINT CONCAT('Policy Number = ',@refNoPol)
		PRINT CONCAT('Payment Number = ',@refNoPay)
		PRINT CONCAT('Payer Number = ',@PayerName)
		IF @RegisterNumber is not NULL
			BEGIN
				PRINT CONCAT('Register Number = ',@RegisterNumber)
			END
		PRINT '---------------------------------------------------------------'
		PRINT CONCAT('Payment Id = ',@PaymentTarget_Id)
		PRINT CONCAT('Policy  Id = ',@PolicyTarget_Id)
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
		
		DROP TABLE #DocumentRunningRegistration
		drop table #AgreementPol
		DROP TABLE #InsuranceApplicationStatus
		DROP TABLE #PartyRole
		DROP TABLE #PolicyItemPremium
		DROP TABLE #InsuranceApplicationRoleItem
		DROP TABLE #InsuranceApplicationItemFee
		DROP TABLE #InsuranceApplicationItem, #SubClassDiscount

END