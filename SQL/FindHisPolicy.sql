SELECT IA1.END_Sequence,a.Id,iai.TotalBeforeFee,iai.TotalAfterFee,iai.TotalDuty,iai.Id,a.ReferenceNumber,iai2.TotalBeforeFee,iai2.TotalAfterFee,iai2.TotalDuty,iai.PrimaryCoverageLevel
FROM InsuranceApplication IA1 
INNER JOIN InsuranceApplication IA2 ON IA2.Id = IA1.ParentId 
INNER JOIN InsuranceApplicationItem iai on iai.InsuranceApplication_Id=IA1.Id
INNER JOIN Agreement a on (a.InsuranceApplication_Id = IA1.Id)
LEFT JOIN InsuranceApplicationItem iai2 on (iai2.InsuranceApplication_Id=IA1.Id)
WHERE IA1.PolicyNumber = '18205/POL/000011-511'
AND a.Discriminator = 'InsuranceEndorsement'
AND iai.InsuranceApplicationItemType_Id like 'F8%'
AND iai2.InsuranceApplicationItemType_Id like '213F8708-FCC2-4430-A804-A1D115F718C5'
order by IA1.END_Sequence 

SELECT IA1.END_Sequence,a.Id,iai.TotalBeforeFee,iai.TotalAfterFee,iai.TotalDuty,iai.Id,a.ReferenceNumber,iai2.TotalBeforeFee,iai2.TotalAfterFee,iai2.TotalDuty,iai.PrimaryCoverageLevel
FROM InsuranceApplication IA1 
INNER JOIN InsuranceApplication IA2 ON IA2.Id = IA1.ParentId 
INNER JOIN InsuranceApplicationItem iai on iai.InsuranceApplication_Id=IA1.Id
INNER JOIN Agreement a on (a.InsuranceApplication_Id = IA1.Id)
LEFT JOIN InsuranceApplicationItem iai2 on (iai2.InsuranceApplication_Id=IA1.Id)
WHERE IA1.END_Sequence = 0
AND a.Discriminator = 'InsuranceEndorsement'
AND iai.InsuranceApplicationItemType_Id like 'F8%'
AND iai2.InsuranceApplicationItemType_Id like '213F8708-FCC2-4430-A804-A1D115F718C5'
order by IA1.END_Sequence 


--update iai
--set --primarycoveragelevel=0,--ทุนเอาประกันภัย
--totalbeforefee=2390--เบี้ยสุทธิ
--,amount=2390 --เบี้ยสุทธิ  
--,totalduty=12 --อากร
--,totalafterfee=2400 --เบี้ยรวม
----select iai.primarycoveragelevel,iai.totalbeforefee,iai.totalafterfee,iai.totalduty,iai.amount,iai.*
--from agreement a
--inner join insuranceapplication ia on a.insuranceapplication_id=ia.id
--inner join insuranceapplicationitem iai on iai.insuranceapplication_id=ia.id
--where a.id = '4BB609A8-06D8-4750-9B9D-8D1F69522AF7' --#<<<<<<<<<<<<<<<<<<<<<<<< guid ของ policy #
--and insuranceapplicationitemtype_id='f89579db-7c44-409f-8d50-a0061d29d04e'


select b.* 
from Agreement a
inner join InsuranceApplicationItem b on (a.InsuranceApplication_Id = b.InsuranceApplication_Id)
where a.ReferenceNumber = '18181/POL/000005-520'
and a.Discriminator = 'BaseInsurancePolicy' 
and b.InsuranceApplicationItemType_Id = 'F89579DB-7C44-409F-8D50-A0061D29D04E'

select * from PolicyItemPremium where InsuranceApplicationItem_Id = 'FED97E8D-BC4E-4170-B4B0-202C8ED6EAA0'
select d.* 
from Agreement a
inner join PartyRole b on (a.InsuranceApplication_Id = b.InsuranceApplication_Id)
inner join InsuranceApplicationRoleItem c on (b.Id = c.InsuranceApplicationRole_Id)
inner join InsuranceApplicationItem d on (c.InsuranceApplicationItem_Id = d.Id)
where a.ReferenceNumber = '18181/POL/000003-520'
and a.Discriminator = 'BaseInsurancePolicy' 
and c.IsPayment = 1
union
select d.* 
from Agreement a
inner join PartyRole b on (a.InsuranceApplication_Id = b.InsuranceApplication_Id)
inner join InsuranceApplicationRoleItem c on (b.Id = c.InsuranceApplicationRole_Id)
inner join InsuranceApplicationItem d on (c.InsuranceApplicationItem_Id = d.Id)
where a.ReferenceNumber = '18181/POL/000005-520'
and a.Discriminator = 'BaseInsurancePolicy' 
and c.IsPayment = 0

UPDATE InsuranceApplicationItem
SET Parent_Id = ''
WHERE InsuranceApplication_Id = '64E2844F-62FC-4785-AA9C-6F7726975D39'

select c.* 
from Agreement a
inner join PartyRole b on (a.InsuranceApplication_Id = b.InsuranceApplication_Id)
inner join InsuranceApplicationRoleItem c on (b.Id = c.InsuranceApplicationRole_Id)
inner join InsuranceApplicationItem d on (c.InsuranceApplicationItem_Id = d.Id)
where a.ReferenceNumber = '18181/POL/000005-520'
and a.Discriminator = 'InsurancePolicy' 
and c.IsPayment = 1
and d.Id = '7629ABEC-ADB0-42B1-9F41-E3B107DD7BD8'

select * from #PolicyItemPremium
union
select * from PolicyItemPremium where InsuranceApplicationItem_Id = '2271842B-B6E3-4FCE-B261-036F71FC9447'
select * into #PolicyItemPremium from PolicyItemPremium where InsuranceApplicationItem_Id = '7629ABEC-ADB0-42B1-9F41-E3B107DD7BD8'


--select * into #PolicyItemPremium from PolicyItemPremium where InsuranceApplicationItem_Id = '7629ABEC-ADB0-42B1-9F41-E3B107DD7BD8'


select * from PremiumSchedule where InsuranceApplication_Id = '64E2844F-62FC-4785-AA9C-6F7726975D39'
select * from PolicyItemPremium where PremiumSchedule_Id = 'DCB48C49-56AB-46FD-91DB-810522B7405B'


select * from PremiumSchedule where InsuranceApplication_Id = '86219F79-E763-496F-86DA-A92DACDCF1E2'
select * from PolicyItemPremium where PremiumSchedule_Id = 'B9915921-4B8C-43F2-9E7F-BB02B8A3C73B'

select * from InsuranceApplicationRoleItem where Id = '0A4178F1-9D0C-404D-BA4B-E46896619482'
select * from PartyRole where Id = '0A4178F1-9D0C-404D-BA4B-E46896619482'

select b.* 
from Agreement a
inner join InsuranceApplicationItem b on (a.InsuranceApplication_Id = b.InsuranceApplication_Id)
where a.ReferenceNumber = '18181/POL/000005-520'
and a.Discriminator = 'BaseInsurancePolicy' 
and b.InsuranceApplicationItemType_Id = 'F89579DB-7C44-409F-8D50-A0061D29D04E'

select * from InsuranceApplicationItem where Id = '2271842B-B6E3-4FCE-B261-036F71FC9447'
union
select * from InsuranceApplicationItem where Id = '939C9D7D-4D78-44B3-BE82-C1888A53E812'
union
select * from InsuranceApplicationItem where Id = 'FED97E8D-BC4E-4170-B4B0-202C8ED6EAA0'
union
select b.* 
from Agreement a
inner join InsuranceApplicationItem b on (a.InsuranceApplication_Id = b.InsuranceApplication_Id)
where a.ReferenceNumber = '18181/POL/000005-520'
and a.Discriminator = 'InsurancePolicy' 
--and Parent_Id is null
and b.InsuranceApplicationItemType_Id = 'F89579DB-7C44-409F-8D50-A0061D29D04E'

select *
from InsuranceApplicationItem 
where Parent_Id = '7D76AF31-1772-4B0B-925E-76A2F4DDDE3F'

select * 
from InsuranceApplicationRoleItem
where InsuranceApplicationItem_Id = '7D76AF31-1772-4B0B-925E-76A2F4DDDE3F'
	
