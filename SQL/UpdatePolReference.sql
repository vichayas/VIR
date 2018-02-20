Declare @RefNo varchar(50) = '18302/APP/000083-511'
DECLARE @yearAD varchar(3) = LEFT(@RefNo,2)
Declare @Subclass varchar(3) = RIGHT(@RefNo,3)
Declare @BranchCode varchar(3) = RIGHT(LEFT(@RefNo,5),3)
Declare @Type varchar(3) = RIGHT(LEFT(@RefNo,9),3)
Declare @InApp_Id uniqueidentifier
Declare @Agree_Id uniqueidentifier
Declare @InsuranceBranchOwnerId uniqueidentifier
Declare @PolicyCode varchar(3)

DECLARE @runningNumberPOL int
DECLARE @DocAvailabilityId uniqueidentifier
DECLARE @InsuranceProductCategory_Id uniqueidentifier

select @Agree_Id = Id, @InApp_Id = InsuranceApplication_Id from Agreement where ReferenceNumber = @RefNo
select @InsuranceBranchOwnerId = InsuranceBranchOwnerId, @InsuranceProductCategory_Id = InsuranceProductCategoryId from InsuranceApplication where Id =@InApp_Id
select @PolicyCode = PolicyCode from PartyRole where Id = @InsuranceBranchOwnerId

select PolicyCode = @PolicyCode

select * from Agreement where InsuranceApplication_Id = @InApp_Id

select * from AgentCommission where Agreement_Id = @Agree_Id


	select @DocAvailabilityId = Id
		from DocumentRunningConfigurationAvailability 
		WHERE InsuranceProductCategory_Id = @InsuranceProductCategory_Id
		and DocumentRunningConfiguration_Id = '35FE7921-FCFA-4FCF-A73C-DE7A4730CDA6'

select top 2 * from DocumentRunningRegistration 
where YearAD = @yearAD
and SubClass = @Subclass
and BranchCode = @BranchCode
and DescriptionTH like '%POL%'
and DocumentRunningConfigurationAvailability_Id = @DocAvailabilityId
order by RunningNumber desc


DECLARE @AgreePolId uniqueidentifier 
select @AgreePolId=Id from Agreement where InsuranceApplication_Id = @InApp_Id and Discriminator = 'InsurancePolicy'


DECLARE @UserName varchar(30) = 'vichayas'


		--BEGIN TRANSACTION
		select top 1 * 
		into #DocumentRunningRegistration
		from DocumentRunningRegistration
		where BranchCode = @BranchCode 
		and SubClass = @Subclass
		and YearAD = @yearAD
		and DocumentRunningConfigurationAvailability_Id = @DocAvailabilityId
		order by RunningNumber desc

		select @runningNumberPOL = RunningNumber+1 from #DocumentRunningRegistration

		if(@runningNumberPOL is null)
			SET @runningNumberPOL = 1

		select @refNo = dbo.GenReferenceNumber(@runningNumberPOL,1,0,@BranchCode,@Subclass,@yearAD,@PolicyCode)

		if(@runningNumberPOL = 1)
			BEGIN
				INSERT INTO DocumentRunningRegistration (Id, DescriptionTH, DescriptionEN, RunningNumber, 
														TargetId,CreatedDate,CreatedUserId,CreatedUserName,
														YearAD, SubClass, BranchCode, DocumentRunningConfigurationAvailability_Id)
				VALUES (newId(),@refNo,@refNo,@runningNumberPOL,
						@AgreePolId,GETDATE(),'ByPassToPolicy', @UserName,
						@yearAD, @Subclass, @BranchCode, @DocAvailabilityId)

			END;
		else
			BEGIN
				UPDATE #DocumentRunningRegistration
				SET Id = newId(),
					DescriptionTH = @refNo,
					DescriptionEN = @refNo,
					RunningNumber = @runningNumberPOL,
					TargetId = @AgreePolId,
					CreatedDate = GETDATE(),
					CreatedUserId = 'ByPassToPolicy',
					CreatedUserName = @UserName,
					ModifiedDate = NULL,
					ModifiedUserId = NULL,
					ModifiedUserName = NULL
			END;




begin tran

		UPDATE Agreement
		SET ReferenceNumber = @refNo,
		RunningNumber = @runningNumberPOL
		WHERE Id=@AgreePolId

		INSERT INTO DocumentRunningRegistration
		select * from #DocumentRunningRegistration

		drop table #DocumentRunningRegistration
rollback
--commit