select a.ReferenceNumber as BaseReference,a.CreatedDate as BaseCreatedDate,  count(b.Id) as BaseItems, max(b.TotalBeforeFee) as BaseMaxPremium, d.DescriptionTH as BaseStatus
from Agreement a
inner join InsuranceApplicationItem b on (a.InsuranceApplication_Id = b.InsuranceApplication_Id)
inner join InsuranceApplicationStatus c on (a.Id = c.InsuranceAgreement_Id )
inner join InsuranceApplicationStatusType d on (c.[Type_Id] = d.Id)
where  c.ThruDate is null and a.Discriminator = 'BaseInsurancePolicy' 
and CONVERT(varchar(13), a.CreatedDate, 121) >= CONVERT(varchar(13),GETDATE()-30,121)
group by a.ReferenceNumber,a.Id,a.CreatedDate, b.InsuranceApplication_Id,d.DescriptionTH
order by ReferenceNumber

select * from InsuranceApplication where Id = 'B6F060A1-9A7F-416D-9948-2AAEDFF57066'
select * from Agreement where InsuranceApplication_Id = 'F2CCB578-6268-4B30-B20D-50BCCFE4787C' --Parent
select * from Agreement where InsuranceApplication_Id = 'B6F060A1-9A7F-416D-9948-2AAEDFF57066'



select a.ReferenceNumber,a.Id,a.CreatedDate, b.InsuranceApplication_Id, count(b.Id), max(b.TotalBeforeFee), d.DescriptionTH
from Agreement a
inner join InsuranceApplicationItem b on (a.InsuranceApplication_Id = b.InsuranceApplication_Id)
inner join InsuranceApplicationStatus c on (a.Id = c.InsuranceAgreement_Id)
inner join InsuranceApplicationStatusType d on (c.[Type_Id] = d.Id)
where c.ThruDate is null and a.Discriminator = 'InsurancePolicy' 
and a.ReferenceNumber in (
select a.ReferenceNumber
from Agreement a
where a.Discriminator = 'BaseInsurancePolicy' 
and CONVERT(varchar(13), a.CreatedDate, 121) >= CONVERT(varchar(13),GETDATE()-30,121)
)
group by a.ReferenceNumber,a.Id,a.CreatedDate, b.InsuranceApplication_Id,d.DescriptionTH
order by ReferenceNumber


select *
from
(
select t.*, a.ReferenceNumber as PolicyReference, a.CreatedDate as PolicyCreateDate,  count(b.Id) as PolicyItems, max(b.TotalBeforeFee) as PolicyMaxPremium, d.DescriptionTH as PolicyStatus
from
(
	select a.ReferenceNumber as BaseReference,a.CreatedDate as BaseCreatedDate,  count(b.Id) as BaseItems, 
			max(b.TotalBeforeFee) as BaseMaxPremium, d.DescriptionTH as BaseStatus
	from Agreement a
		inner join InsuranceApplicationItem b on (a.InsuranceApplication_Id = b.InsuranceApplication_Id)
		inner join InsuranceApplicationStatus c on (a.Id = c.InsuranceAgreement_Id )
		inner join InsuranceApplicationStatusType d on (c.[Type_Id] = d.Id)
	where  c.ThruDate is null and a.Discriminator = 'BaseInsurancePolicy' 
	group by a.ReferenceNumber,a.Id,a.CreatedDate, b.InsuranceApplication_Id,d.DescriptionTH
) as t
inner join Agreement a on (t.BaseReference  = a.ReferenceNumber)
inner join InsuranceApplication ia on (a.InsuranceApplication_Id = ia.Id and ia.END_Sequence = 1)
inner join InsuranceApplicationItem b on (a.InsuranceApplication_Id = b.InsuranceApplication_Id)
inner join InsuranceApplicationStatus c on (a.Id = c.InsuranceAgreement_Id)
inner join InsuranceApplicationStatusType d on (c.[Type_Id] = d.Id)
where c.ThruDate is null and a.Discriminator = 'InsurancePolicy' 
group by a.ReferenceNumber,a.CreatedDate,d.DescriptionTH,
		 t.BaseReference, t.BaseCreatedDate, t.BaseItems,t.BaseMaxPremium,t.BaseStatus
) as t2
where t2.BaseItems <> t2.PolicyItems or t2.BaseMaxPremium < t2.PolicyMaxPremium
order by t2.BaseReference


select b.*
from Agreement a
inner join InsuranceApplicationItem b on (a.InsuranceApplication_Id = b.InsuranceApplication_Id)
where a.Discriminator  = 'BaseInsurancePolicy' 
and a.ReferenceNumber = '18108/POL/000006-520'


select *
from
(
select t.*, a.ReferenceNumber as PolicyReference, a.CreatedDate as PolicyCreateDate,  
count(b.Id) as PolicyItems, max(b.TotalBeforeFee) as PolicyMaxPremium, 
d.DescriptionTH as PolicyStatus, ia.Id
from
(
	select a.ReferenceNumber as BaseReference,a.CreatedDate as BaseCreatedDate,  count(b.Id) as BaseItems, 
			max(b.TotalBeforeFee) as BaseMaxPremium, d.DescriptionTH as BaseStatus
	from Agreement a
		inner join InsuranceApplicationItem b on (a.InsuranceApplication_Id = b.InsuranceApplication_Id)
		inner join InsuranceApplicationStatus c on (a.Id = c.InsuranceAgreement_Id )
		inner join InsuranceApplicationStatusType d on (c.[Type_Id] = d.Id)
	where  c.ThruDate is null and a.Discriminator = 'BaseInsurancePolicy' 
	group by a.ReferenceNumber,a.Id,a.CreatedDate, b.InsuranceApplication_Id,d.DescriptionTH
) as t
inner join Agreement a on (t.BaseReference  = a.ReferenceNumber)
inner join InsuranceApplication ia on (a.InsuranceApplication_Id = ia.Id and ia.END_Sequence = 1)
left join InsuranceApplicationItem b on (a.InsuranceApplication_Id = b.InsuranceApplication_Id )
inner join InsuranceApplicationStatus c on (a.Id = c.InsuranceAgreement_Id)
inner join InsuranceApplicationStatusType d on (c.[Type_Id] = d.Id)
where c.ThruDate is null and a.Discriminator = 'InsurancePolicy' and ia.END_Sequence = 1
group by a.ReferenceNumber,a.CreatedDate,d.DescriptionTH,
		 t.BaseReference, t.BaseCreatedDate, t.BaseItems,t.BaseMaxPremium,t.BaseStatus, ia.Id
) as t2
where  (t2.BaseItems - t2.PolicyItems) = -1
order by t2.BaseReference






select *
from InsuranceApplicationItemType
where Id in
(
select  distinct InsuranceApplicationItemType_Id 
from InsuranceApplicationItem a
inner join Agreement b on (a.InsuranceApplication_Id = b.InsuranceApplication_Id)
where b.ReferenceNumber = '14181/POL/000081-520' and b.Discriminator ='BaseInsurancePolicy' 
)



select *
from InsuranceApplicationItemType
where Id in
(
select  distinct InsuranceApplicationItemType_Id 
from InsuranceApplicationItem a
inner join Agreement b on (a.InsuranceApplication_Id = b.InsuranceApplication_Id)
where b.ReferenceNumber = '14181/POL/000081-520' and b.Discriminator ='InsurancePolicy' 
)


select  *
from PartyRole a
inner join Agreement b on (a.InsuranceApplication_Id = b.InsuranceApplication_Id)
where b.ReferenceNumber = '18181/END/000002-573' 


select  *
from PartyRole a
inner join Agreement b on (a.InsuranceApplication_Id = b.InsuranceApplication_Id)
where b.ReferenceNumber = '18181/END/000003-573' 
