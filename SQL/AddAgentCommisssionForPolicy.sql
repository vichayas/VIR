DECLARE @BranchCode Varchar(4)
DECLARE @Subclass Varchar(4)
DECLARE @BranchId uniqueidentifier
DECLARE @InAppId uniqueidentifier 
DECLARE @AppAgreement_Id uniqueidentifier
DECLARE @AppNo  Varchar(100) = '17003/APP/000181-511'
DECLARE @UserName  Varchar(100) = 'vichayas'

--======= Find InAppId & AppAgreement_Id ==================
  SELECT @AppAgreement_Id = Id, @InAppId = InsuranceApplication_Id, @BranchCode = BranchCode, @BranchId = BranchId
  FROM Agreement WHERE ReferenceNumber = @AppNo AND CurrentApprovalResult = 2

  DECLARE @HavePolNumber bit = @@ROWCOUNT
  SELECT @Subclass = b.Code
  FROM InsuranceApplication a
  inner join ProductCategory b on (a.InsuranceProductCategoryId = b.Id)
  WHERE a.Id =@InAppId
  select distinct Agreement_Id from AgentCommission where Agreement_Id = @AppAgreement_Id
  print @@ROWCOUNT 


IF @@ROWCOUNT = 0 and @HavePolNumber = 1
	BEGIN
		-- Create Store for add AgentCommission For 511
		--Find InAppItemId
		DECLARE @InAppItemId varchar(100)
		DECLARE @PolAmount float
		select @InAppItemId = Id , @PolAmount = Amount
		from InsuranceApplicationItem 
		where InsuranceApplication_Id = @InAppId 
		and InsuranceApplicationItemType_Id = 'F89579DB-7C44-409F-8D50-A0061D29D04E'

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

		--select * from #AgentCommission

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
			WHERE a.Rate_Id = 'E9718FD6-5243-4698-ADF1-AA9D4DEE93EF' --��ҵͺ᷹�ҵðҹ
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
		BEGIN TRY
				BEGIN TRANSACTION 
					INSERT INTO AgentCommission
					select * from #AgentCommission
				COMMIT TRANSACTION
		END TRY
		BEGIN CATCH
			 SELECT  
				ERROR_NUMBER() AS ErrorNumber  
				,ERROR_SEVERITY() AS ErrorSeverity  
				,ERROR_STATE() AS ErrorState  
				,ERROR_PROCEDURE() AS ErrorProcedure  
				,ERROR_MESSAGE() AS ErrorMessage;  
		  
				ROLLBACK
		END CATCH
		
		select * from #AgentCommission
		drop table #AgentCommission
	END