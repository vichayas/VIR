
select   a.InsuranceApplicationItemType_Id, c.DescriptionTH, count(a.Id)
from InsuranceApplicationItem a
inner join Agreement b on (a.InsuranceApplication_Id = b.InsuranceApplication_Id)
inner join  InsuranceApplicationItemType c on (a.InsuranceApplicationItemType_Id = c.Id)
where b.ReferenceNumber = '18108/POL/000006-520' and b.Discriminator ='BaseInsurancePolicy' 
group by a.InsuranceApplicationItemType_Id , c.DescriptionTH
order by DescriptionTH

select   a.InsuranceApplicationItemType_Id, c.DescriptionTH, count(a.Id)
from InsuranceApplicationItem a
inner join Agreement b on (a.InsuranceApplication_Id = b.InsuranceApplication_Id)
inner join  InsuranceApplicationItemType c on (a.InsuranceApplicationItemType_Id = c.Id)
where b.ReferenceNumber = '18108/POL/000006-520' and b.Discriminator ='InsurancePolicy' 
group by a.InsuranceApplicationItemType_Id , c.DescriptionTH
order by DescriptionTH

select *
from
(
select t.*,a.ReferenceNumber as BaseReference,a.CreatedDate as BaseCreatedDate,  count(b.Id) as BaseItems, 
			max(b.TotalBeforeFee) as BaseMaxPremium, d.DescriptionTH as BaseStatus
from
(
select a.ReferenceNumber as PolicyReference, a.CreatedDate as PolicyCreateDate,  
count(b.Id) as PolicyItems, max(b.TotalBeforeFee) as PolicyMaxPremium, d.DescriptionTH as PolicyStatus, 
e.DescriptionTH as PolicyItemType, e.Id as PolicyItemTypeId
	from Agreement a
		inner join InsuranceApplicationItem b on (a.InsuranceApplication_Id = b.InsuranceApplication_Id)
		inner join InsuranceApplicationStatus c on (a.Id = c.InsuranceAgreement_Id )
		inner join InsuranceApplicationStatusType d on (c.[Type_Id] = d.Id)
		inner join  InsuranceApplicationItemType e on (b.InsuranceApplicationItemType_Id = e.Id)
	where  c.ThruDate is null and a.Discriminator = 'InsurancePolicy'  and c.[Type_Id] != 'B31F7CC4-6F71-4AA9-8E22-DACB520FA96C'
	group by a.ReferenceNumber,a.Id,a.CreatedDate, b.InsuranceApplication_Id,d.DescriptionTH,e.DescriptionTH, e.Id
) as t
inner join Agreement a on (t.PolicyReference  = a.ReferenceNumber)
inner join InsuranceApplication ia on (a.InsuranceApplication_Id = ia.Id)
left join InsuranceApplicationItem b on (a.InsuranceApplication_Id = b.InsuranceApplication_Id and b.InsuranceApplicationItemType_Id = t.PolicyItemTypeId)
inner join InsuranceApplicationStatus c on (a.Id = c.InsuranceAgreement_Id)
inner join InsuranceApplicationStatusType d on (c.[Type_Id] = d.Id)
where c.ThruDate is null and a.Discriminator = 'BaseInsurancePolicy' 
group by a.ReferenceNumber,a.CreatedDate,d.DescriptionTH,
		 t.PolicyReference, t.PolicyCreateDate, t.PolicyItems,t.PolicyMaxPremium,t.PolicyStatus,t.PolicyItemType,t.PolicyItemTypeId
) as t2
where t2.BaseItems = 0 and t2.PolicyItemTypeId = 'F89579DB-7C44-409F-8D50-A0061D29D04E'
order by t2.BaseReference
