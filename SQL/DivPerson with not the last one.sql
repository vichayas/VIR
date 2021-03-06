USE [VIS_DB]
GO
/****** Object:  StoredProcedure [dbo].[DivPersonCalculate]    Script Date: 11/24/2017 2:04:26 PM ******/

	  Declare @PolicyNo   VARCHAR(50)
      Declare @AppEndosNo VARCHAR(50)

          Declare @InsuranceApplicationRoleItemId uniqueidentifier
          Declare @InsuranceApplicationItemId uniqueidentifier
       declare @ins_seq nvarchar(20) = NULL
          declare @CaltotalBeforeFee decimal(20,2)
       declare @OldtotalBeforeFee decimal(20,2) = 0
       declare @totalAfterFee decimal(20,2) = 0
       declare @totalBeforeFee decimal(20,2) = 0
       declare @totalDuty int
       declare @ItemType uniqueidentifier = NULL
          declare @day float(20)
          declare @chk_ins nvarchar(100)
          declare @Duty int
          declare @TotalNetPremiumEndos decimal(20,2)
          declare @daydiv float(20)
		  declare @totalSequence int
          SET @chk_ins=''
		  SET @PolicyNo='17181/POL/000017-574'
		  SET @AppEndosNo='18181/APE/000069-574'
       -----เพิ่มคน Update in สลักหลัง หาเบี้ยจากแผน
              Declare cursor_ape cursor for
              select iar.InsuranceApplicationRole_Id,iar.InsuranceApplicationItem_Id,pr.SequenceNo,iai.InsuranceApplicationItemType_Id,iai.TotalDuty
              from Agreement a
              inner join ApplicantEndorsementItem aei on a.Id=aei.ApplicantEndorsement_Id
              inner join ApplicantEndorsementTracking aet on aei.Id=aet.ApplicantEndorsementItem_Id
              inner join PartyRole pr on pr.Id=aet.InsuranceApplicationRole_Id
              inner join InsuranceApplicationRoleItem iar on iar.InsuranceApplicationRole_Id=pr.Id
              inner join InsuranceApplicationItem iai on iai.Id=iar.InsuranceApplicationItem_Id
              where a.ReferenceNumber= @AppEndosNo and aei.EndorsementType_Id='C59823FA-4ADF-439B-A281-D7E759CAE307' order by pr.SequenceNo ASC
              open cursor_ape 
              fetch cursor_ape into @InsuranceApplicationRoleItemId,@InsuranceApplicationItemId,@ins_seq,@ItemType,@Duty
              while @@FETCH_STATUS=0
              begin
                     --Select หาเบี้ยก่อนทำสลักหลัง จาก
                                  SELECT @OldtotalBeforeFee=iai.TotalBeforeFee
                                  FROM InsuranceApplication IA1 
                                  INNER JOIN InsuranceApplication IA2 ON IA2.Id = IA1.ParentId 
                                  INNER JOIN PartyRole pr on pr.InsuranceApplication_Id=IA1.Id
                                  INNER JOIN InsuranceApplicationRoleItem iar on iar.InsuranceApplicationRole_Id=pr.id
                                  INNER JOIN InsuranceApplicationItem iai on iai.Id=iar.InsuranceApplicationItem_Id
                                  WHERE IA1.PolicyNumber = @PolicyNo 
                                  AND IA1.END_Sequence=
                                         (SELECT max(IA1.END_Sequence) 
                                         FROM InsuranceApplication IA1 
                                         INNER JOIN InsuranceApplication IA2 ON IA2.Id = IA1.ParentId 
                                         WHERE IA1.PolicyNumber = @PolicyNo)-2
                                  AND pr.SequenceNo=@ins_seq
                                  AND iai.InsuranceApplicationItemType_Id='037F67EC-7B87-4DC3-9F43-D6640B2F0363'
					
					--SELECT max(IA1.END_Sequence) 
     --                                    FROM InsuranceApplication IA1 
     --                                    INNER JOIN InsuranceApplication IA2 ON IA2.Id = IA1.ParentId 
     --                                    WHERE IA1.PolicyNumber = @PolicyNo
                     -- End
                     ----------------------Select day-------------------------------------------------
                     select @day= DATEDIFF(day,EffectiveDate,ExpirationDate)
                     from InsuranceApplicationRoleItem iar
                     inner join InsuranceApplicationItem iai on iai.Id=iar.InsuranceApplicationItem_Id and iai.InsuranceApplicationItemType_Id='037F67EC-7B87-4DC3-9F43-D6640B2F0363'
                     where InsuranceApplicationRole_Id=@InsuranceApplicationRoleItemId 
                     --หา datediv
                     select @daydiv=CASE When r.EffectiveDate is not null then DATEDIFF(day,r.EffectiveDate,r.ExpirationDate) else 365 end
					from Agreement a
					inner join InsuranceApplication i on a.InsuranceApplication_Id=i.Id
					inner join PartyRole p on p.InsuranceApplication_Id=i.Id
					inner join InsuranceApplicationRoleItem r on r.InsuranceApplicationRole_Id=p.Id
					where a.ReferenceNumber=@PolicyNo and p.SequenceNo=@ins_seq and a.Discriminator='InsurancePolicy' and r.ThruDate is not null and r.FromDate is not null
                     ----------------------Select-------------------------------------------------       
                     SET @CaltotalBeforeFee=((@OldtotalBeforeFee*@day/@daydiv)*(-1))
                     SET @totalBeforeFee=@OldtotalBeforeFee+@CaltotalBeforeFee
                     
                     if @ItemType='037F67EC-7B87-4DC3-9F43-D6640B2F0363'
                     BEGIN
                           SET @totalDuty=@Duty

                     END
                     ELSE
                     BEGIN
                           SET @totalDuty=CEILING(@totalBeforeFee*(0.4/100))
                     END
                     SET @totalAfterFee=@totalBeforeFee+@totalDuty
       --update InsuranceApplicationItem ของ สลักหลัง

                     update InsuranceApplicationItem set 
                     TotalBeforeFee=@TotalBeforeFee,
                     TotalDuty=@totalDuty,
                     TotalAfterFee=@TotalAfterfee,
                     Amount=@TotalBeforeFee
                     where id=@InsuranceApplicationItemId

                     
              
                     --############### Policy ###########################
                           update iai
                           SET TotalBeforeFee=@TotalBeforeFee,
                           Amount=@TotalBeforeFee,
                           TotalDuty=@TotalDuty,
                           TotalAfterFee=@TotalAfterfee
                           from Agreement a
                           inner join PartyRole pr on pr.InsuranceApplication_Id=a.InsuranceApplication_Id
                           inner join InsuranceApplicationRoleItem iar on iar.InsuranceApplicationRole_Id=pr.Id
                           inner join InsuranceApplicationItem iai on iai.Id=iar.InsuranceApplicationItem_Id
                           where a.ReferenceNumber=@PolicyNo and a.Discriminator='InsurancePolicy' and pr.SequenceNo = @ins_seq and InsuranceApplicationItemType_Id=@ItemType
                           
                  IF @chk_ins <> @ins_seq
                     Begin
                   --############### ใบประหน้า สลักหลัง ######################
                           update iai
                           SET TotalBeforeFee=@CaltotalBeforeFee,--เบี้ยสุทธิ
                           TotalDuty=0, --อากร
                           TotalAfterFee=@CaltotalBeforeFee+0 --เบี้ยรวม
                           from Agreement a
                           inner join ApplicantEndorsementItem aei on a.Id=aei.ApplicantEndorsement_Id
                           inner join ApplicantEndorsementTracking aet on aei.Id=aet.ApplicantEndorsementItem_Id
                           inner join insuranceApplicationitem iai on iai.id=aet.InsuranceApplicationItem_Id
                           inner join PartyRole pr on pr.Id=aet.InsuranceApplicationRole_Id
                           where a.ReferenceNumber= @AppEndosNo and aei.EndorsementType_Id='C59823FA-4ADF-439B-A281-D7E759CAE307' and pr.SequenceNo = @ins_seq
                           SET @chk_ins=@ins_seq
                     END
                     

                     print @ins_seq
                     --print @ItemType
                     --print @OldtotalBeforeFee
					 IF(@ins_seq = '239')
						 begin
						  select DATEDIFF(day,EffectiveDate,ExpirationDate),EffectiveDate,ExpirationDate
						 from InsuranceApplicationRoleItem iar
						 inner join InsuranceApplicationItem iai on iai.Id=iar.InsuranceApplicationItem_Id and iai.InsuranceApplicationItemType_Id='037F67EC-7B87-4DC3-9F43-D6640B2F0363'
						 where InsuranceApplicationRole_Id=@InsuranceApplicationRoleItemId 
						 end
					 print @OldtotalBeforeFee
					 print @day
					 print @daydiv
                     print @CaltotalBeforeFee
                     print @totalBeforeFee
                     --print @totalDuty
                     --print @totalAfterFee
                     print '-------------------------------------------------'
					
       --	

              fetch next from cursor_ape  
              into  @InsuranceApplicationRoleItemId,@InsuranceApplicationItemId,@ins_seq,@ItemType,@Duty
              end
              close cursor_ape
              deallocate cursor_ape

   ------------------------------------Select Sum ใบประหน้า -----------------------------------
              select @TotalNetPremiumEndos=SUM(iai.TotalBeforeFee)
              from Agreement a
              inner join ApplicantEndorsementItem aei on a.Id=aei.ApplicantEndorsement_Id
              inner join ApplicantEndorsementTracking aet on aei.Id=aet.ApplicantEndorsementItem_Id
              inner join InsuranceApplicationItem iai on iai.Id=aet.InsuranceApplicationItem_Id
              where a.ReferenceNumber= @AppEndosNo and aei.EndorsementType_Id='C59823FA-4ADF-439B-A281-D7E759CAE307'

--update เบี้ยรวมสลักหลัง

              update iai
              set iai.totalbeforefee=@totalnetpremiumendos,
              iai.totalduty=0,
              iai.totalafterfee=@totalnetpremiumendos+0
              from agreement a 
              inner join applicantendorsementitem aei on a.id=aei.applicantendorsement_id
              inner join insuranceapplicationitem iai on aei.insuranceapplication_id=iai.insuranceapplication_id
              where a.referenceNumber= @AppEndosNo and iai.InsuranceApplicationItemType_Id='213F8708-FCC2-4430-A804-A1D115F718C5' and aei.EndorsementType_Id='C59823FA-4ADF-439B-A281-D7E759CAE307'
             
				 select @totalSequence = count(p.Sequence) 
				from Agreement a
				inner join PremiumSchedule ps on ps.InsuranceApplication_Id=a.InsuranceApplication_Id
				inner join PaymentApplication pa on pa.PremiumSchedule_Id=ps.Id
				inner join Payment p on p.Id=pa.Payment_Id
				where a.ReferenceNumber in(@AppEndosNo)
				if(@totalSequence = 0)
				begin
					set @totalSequence=1
				end
			  
              select @TotalNetPremiumEndos as TotalNetPremiumEndos, @totalSequence as totalSequence


