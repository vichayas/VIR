select a.ReferenceNumber,a.Id,a.CreatedDate, b.InsuranceApplication_Id, count(b.Id), max(b.TotalBeforeFee)
from Agreement a
inner join InsuranceApplicationItem b on (a.InsuranceApplication_Id = b.InsuranceApplication_Id)
inner join InsuranceApplicationStatus c on (a.Id = c.InsuranceAgreement_Id )
where a.Discriminator = 'BaseInsurancePolicy' 
and CONVERT(varchar(13), a.CreatedDate, 121) >= CONVERT(varchar(13),GETDATE()-30,121)
group by a.ReferenceNumber,a.Id,a.CreatedDate, b.InsuranceApplication_Id
order by ReferenceNumber



select a.ReferenceNumber,a.Id,a.CreatedDate, b.InsuranceApplication_Id, count(b.Id), max(b.TotalBeforeFee)
from Agreement a
inner join InsuranceApplicationItem b on (a.InsuranceApplication_Id = b.InsuranceApplication_Id)
where a.Discriminator = 'InsurancePolicy' 
and a.ReferenceNumber in (
select a.ReferenceNumber
from Agreement a
where a.Discriminator = 'BaseInsurancePolicy' 
and CONVERT(varchar(13), a.CreatedDate, 121) >= CONVERT(varchar(13),GETDATE()-30,121)
)
group by a.ReferenceNumber,a.Id,a.CreatedDate, b.InsuranceApplication_Id
order by ReferenceNumber


select * from InsuranceApplicationStatus where InsuranceAgreement_Id in ('6C2E43E5-EFBD-4A8F-8D47-601E62B47CBE',
'971F591D-F353-497D-8DB0-93FCCEC76AD0',
'15D65F98-7425-4F91-B582-46219C9087BD')
select * from InsuranceApplicationStatusType where Id = '3E972C7E-630C-4848-9A7F-EE463B923810'