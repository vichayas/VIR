select a.ReferenceNumber,a2.ReferenceNumber, ia.PolicyNumber, ia.END_Sequence, c1.DescriptionTH, c2.DescriptionTH, iai.TotalBeforeFee, iai.TotalAfterFee, iai.TotalDuty, b.EndorsementType_Id
,b.InsuranceApplication_Id
 from Agreement a
 inner join  Agreement a2 on (a.InsuranceApplication_Id = a2.InsuranceApplication_Id and a2.Discriminator = 'InsuranceEndorsement')
 inner join ApplicantEndorsementItem b on (a.Id = b.ApplicantEndorsement_Id)
 inner join Endorsement c1 on (a.ApplicantEndorsementCategoryId = c1.Id)
 inner join Endorsement c2 on (b.EndorsementType_Id = c2.Id)
 inner join InsuranceApplication ia on (ia.Id = a.InsuranceApplication_Id)
 inner join ApplicantEndorsementItem api on (a.Id = api.ApplicantEndorsement_Id and b.EndorsementType_Id = api.EndorsementType_Id)
inner join InsuranceApplicationItem iai on (api.InsuranceApplication_Id =iai.InsuranceApplication_Id)
  where a2.ReferenceNumber = '18205/END/000002-511'  and iai.InsuranceApplicationItemType_Id='213F8708-FCC2-4430-A804-A1D115F718C5' 
  order by c2.DescriptionTH, iai.TotalAfterFee

select InsuranceApplicationItem.*
from Agreement 
inner join ApplicantEndorsementItem on Agreement.Id = ApplicantEndorsementItem.ApplicantEndorsement_Id
inner join InsuranceApplicationItem on ApplicantEndorsementItem.InsuranceApplication_Id = InsuranceApplicationItem.InsuranceApplication_Id
where Agreement.ReferenceNumber= '18181/APE/000004-574' --#<<<<<<<<<<<<<<<<<<<<<< เลขที่ APE #
and InsuranceApplicationItem.InsuranceApplicationItemType_Id='213F8708-FCC2-4430-A804-A1D115F718C5' 
and ApplicantEndorsementItem.EndorsementType_Id='4B6F241B-3D35-4555-A394-40E0B563831F' 
  
select DescriptionTH,* from Endorsement where Id = 'C59823FA-4ADF-439B-A281-D7E759CAE307'

UPDATE InsuranceApplicationItem
SET TotalBeforeFee = 511.08,
	TotalAfterFee = 3,
	TotalDuty = 514.08
WHERE Id = '7B0EEBFC-A171-42BF-957F-F0932B964C1F'
