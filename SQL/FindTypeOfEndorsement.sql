select a.ReferenceNumber,a2.ReferenceNumber, iai.PolicyNumber, c1.DescriptionTH, c2.DescriptionTH, iai.END_Sequence
 from Agreement a
 inner join  Agreement a2 on (a.InsuranceApplication_Id = a2.InsuranceApplication_Id and a2.Discriminator = 'InsuranceEndorsement')
 inner join ApplicantEndorsementItem b on (a.Id = b.ApplicantEndorsement_Id)
 inner join Endorsement c1 on (a.ApplicantEndorsementCategoryId = c1.Id)
 inner join Endorsement c2 on (b.EndorsementType_Id = c2.Id)
 inner join InsuranceApplication iai on (iai.Id = a.InsuranceApplication_Id)
  where a2.ReferenceNumber = '17181/END/000262-563'
