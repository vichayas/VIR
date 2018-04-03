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

select * from InsuranceApplicationRoleItem where InsuranceApplicationItem_Id = '7D76AF31-1772-4B0B-925E-76A2F4DDDE3F'
drop table #InsuranceApplicationItem
select b.* 
--into #InsuranceApplicationItem
from Agreement a
inner join InsuranceApplicationItem b on (a.InsuranceApplication_Id = b.InsuranceApplication_Id)
where a.ReferenceNumber = '18108/POL/000006-520'
and a.Discriminator = 'InsurancePolicy' 
--and Parent_Id is null
and b.InsuranceApplicationItemType_Id = 'F89579DB-7C44-409F-8D50-A0061D29D04E'

select b.* 
from Agreement a
inner join InsuranceApplicationItem b on (a.InsuranceApplication_Id = b.InsuranceApplication_Id)
where a.ReferenceNumber = '18108/POL/000006-520'
and a.Discriminator = 'BaseInsurancePolicy' 
--and Parent_Id is null
and b.InsuranceApplicationItemType_Id = 'F89579DB-7C44-409F-8D50-A0061D29D04E'

select d.* 
from Agreement a
inner join PartyRole b on (a.InsuranceApplication_Id = b.InsuranceApplication_Id)
inner join InsuranceApplicationRoleItem c on (b.Id = c.InsuranceApplicationRole_Id)
inner join InsuranceApplicationItem d on (c.InsuranceApplicationItem_Id = d.Id)
where a.ReferenceNumber = '18108/POL/000006-520'
and a.Discriminator = 'BaseInsurancePolicy' 
and c.IsPayment = 1

select c.* 
from Agreement a
inner join PartyRole b on (a.InsuranceApplication_Id = b.InsuranceApplication_Id)
inner join InsuranceApplicationRoleItem c on (b.Id = c.InsuranceApplicationRole_Id)
inner join InsuranceApplicationItem d on (c.InsuranceApplicationItem_Id = d.Id)
where a.ReferenceNumber = '18108/POL/000006-520'
and a.Discriminator = 'InsurancePolicy' 
and c.IsPayment = 1

drop table #PolicyItemPremium
select * from PremiumSchedule where InsuranceApplication_Id = 'F85C4F62-0A8D-4B46-840B-BD7C2C403BBB'
select * into #PolicyItemPremium from PolicyItemPremium where PremiumSchedule_Id = 'C9D75432-CB50-441B-BDF6-2CA1D3A999DD'

select * from PremiumSchedule where InsuranceApplication_Id = '83E06E49-FB66-4E96-9731-900C0F59A40B'

select * from PolicyItemPremium where PremiumSchedule_Id = 'A6360C89-99F8-4D1C-A4BD-E31FFF3A2B93'
select * from PaymentApplication where PremiumSchedule_Id = 'B5747768-8F55-4E50-89D9-CFA764B85EC5'
select * from Payment where Id in ('D2A27F59-880A-4A10-AD95-F48D0E56CC91','AED83CFC-A90D-46F5-B69A-E1B75DF6C1E3')
select * from #InsuranceApplicationItem
select * from #PolicyItemPremium
select * from InsuranceApplicationRoleItem where Id in ('96C34CAC-B319-4BAE-9BCB-A27D8852C9D7','F4B42C19-B585-4ACF-BC8C-7E233787F033')
select * from InsuranceApplicationItem where Id = '244C2072-6625-475F-BED9-008822E2DF84'


/*

UPDATE #InsuranceApplicationItem
SET Id = newId(),
Amount = 14492,
	TotalBeforeFee = 14492,
	TotalAfterFee = 14550,
	TotalDuty = 58,
	PrimaryCoverageLevel = 9700000,
	InsuranceApplication_Id = '8DAECBA7-88F5-435A-8740-CA989D9B0BE4'

insert into InsuranceApplicationItem
select * from #InsuranceApplicationItem

UPDATE InsuranceApplicationItem
SET Parent_Id = null
WHERE InsuranceApplication_Id ='8DAECBA7-88F5-435A-8740-CA989D9B0BE4'
and Id !=  '201EC5EB-1EDF-49B9-BA11-60FD704DC3E7'


UPDATE InsuranceApplicationItem
SET Parent_Id = '201EC5EB-1EDF-49B9-BA11-60FD704DC3E7'
WHERE Id in 
(
select d.Id
from Agreement a
inner join PartyRole b on (a.InsuranceApplication_Id = b.InsuranceApplication_Id)
inner join InsuranceApplicationRoleItem c on (b.Id = c.InsuranceApplicationRole_Id)
inner join InsuranceApplicationItem d on (c.InsuranceApplicationItem_Id = d.Id)
where a.ReferenceNumber = '18108/POL/000006-520'
and a.Discriminator = 'BaseInsurancePolicy' 
and c.IsPayment = 0
)

select d.* 
from Agreement a
inner join PartyRole b on (a.InsuranceApplication_Id = b.InsuranceApplication_Id)
inner join InsuranceApplicationRoleItem c on (b.Id = c.InsuranceApplicationRole_Id)
inner join InsuranceApplicationItem d on (c.InsuranceApplicationItem_Id = d.Id)
where a.ReferenceNumber = '18108/POL/000006-520'
and a.Discriminator = 'BaseInsurancePolicy' 
and c.IsPayment = 1

select c.* 
from Agreement a
inner join PartyRole b on (a.InsuranceApplication_Id = b.InsuranceApplication_Id)
inner join InsuranceApplicationRoleItem c on (b.Id = c.InsuranceApplicationRole_Id)
inner join InsuranceApplicationItem d on (c.InsuranceApplicationItem_Id = d.Id)
where a.ReferenceNumber = '18108/POL/000006-520'
and a.Discriminator = 'InsurancePolicy' 
and c.IsPayment = 1

select * from PremiumSchedule where InsuranceApplication_Id = '8DAECBA7-88F5-435A-8740-CA989D9B0BE4'
select * from PolicyItemPremium where PremiumSchedule_Id = '147A51A6-2B42-402D-82C5-EB9D51060F13'
select * from  #PolicyItemPremium


UPDATE #PolicyItemPremium
SET PremiumSchedule_Id = 'A6360C89-99F8-4D1C-A4BD-E31FFF3A2B93',
	Id = newId()

UPDATE #PolicyItemPremium
SET	InsuranceApplicationRoleItem_Id = 'B02F881D-719C-4CB6-A80C-6B425E01C128',
	InsuranceApplicationItem_Id = 'C5AB1574-1131-4225-AA1C-8BFD8FE94DA0'
WHERE InsuranceApplicationRoleItem_Id = 'D2C7E2FE-95C6-4AC5-8974-2FBD2728ECB3'


UPDATE #PolicyItemPremium
SET	InsuranceApplicationRoleItem_Id = 'BABAC749-45A3-47F8-995E-4C99F76141B1',
	InsuranceApplicationItem_Id = 'E53A0277-B9FB-49AC-AD3C-3C5CA6757536'
WHERE InsuranceApplicationRoleItem_Id = 'A54A4137-C9AB-44BA-A89F-F570CC32BAB7'

insert into PolicyItemPremium
select * from #PolicyItemPremium

*/

select d.* 
from Agreement a
inner join PartyRole b on (a.InsuranceApplication_Id = b.InsuranceApplication_Id)
inner join InsuranceApplicationRoleItem c on (b.Id = c.InsuranceApplicationRole_Id)
inner join InsuranceApplicationItem d on (c.InsuranceApplicationItem_Id = d.Id)
where a.ReferenceNumber = '17181/POL/000038-563'
and c.IsPayment = 1

select * from InsuranceApplicationRoleItem where InsuranceApplicationItem_Id = '3D72A1F7-6E87-443D-BD92-277D912D9079'
select * from InsuranceApplicationItem where InsuranceApplication_Id = '996E6221-F496-4EF0-A0EA-D3F770F6CE13' and InsuranceApplicationItemType_Id = 'F89579DB-7C44-409F-8D50-A0061D29D04E' 
select * from InsuranceApplicationItem where Parent_Id = '58AE5829-D8D8-433D-B3E4-32B856C8E170'

select * from InsuranceApplicationItem where InsuranceApplication_Id = 'A75D2305-D2A5-4D5C-9FA7-15D047777779'
and Id not in
(
select d.Id
from Agreement a
inner join PartyRole b on (a.InsuranceApplication_Id = b.InsuranceApplication_Id)
inner join InsuranceApplicationRoleItem c on (b.Id = c.InsuranceApplicationRole_Id)
inner join InsuranceApplicationItem d on (c.InsuranceApplicationItem_Id = d.Id)
where a.ReferenceNumber =  '17502/POL/001023-511'
and a.Discriminator = 'BaseInsurancePolicy' 
and c.IsPayment = 0
)

select * from InsuranceApplicationItem where Parent_Id = '0EBC46A7-6EE6-4E82-91DC-744CDB2043D6'
select * from InsuranceApplicationItem where Parent_Id = '0B9D96A3-DDE5-4E4C-A36A-A6008A9DD432'

--select distinct Parent_Id
--				from InsuranceApplicationItem
--				where InsuranceApplication_Id = 'A75D2305-D2A5-4D5C-9FA7-15D047777779' and Parent_Id is not  null

select * from InsuranceApplicationRoleItem where InsuranceApplicationItem_Id = '3D72A1F7-6E87-443D-BD92-277D912D9079'
select * from InsuranceApplicationItem where InsuranceApplication_Id = 'A75D2305-D2A5-4D5C-9FA7-15D047777779' and InsuranceApplicationItemType_Id = 'F89579DB-7C44-409F-8D50-A0061D29D04E' 
select * from InsuranceApplicationItem where Parent_Id = '0EBC46A7-6EE6-4E82-91DC-744CDB2043D6'
select * from InsuranceApplicationItem where Parent_Id = '0B9D96A3-DDE5-4E4C-A36A-A6008A9DD432'


select * from PolicyItemPremium where InsuranceApplicationItem_Id = '2AEE431B-3A23-40A6-B3B6-9256E38F11AC'

select * from InsuranceApplicationItem where Parent_Id = 'A788CAA6-890E-4138-8645-EE2B9E9A5DB7'

select d.* 
from Agreement a
inner join PartyRole b on (a.InsuranceApplication_Id = b.InsuranceApplication_Id)
inner join InsuranceApplicationRoleItem c on (b.Id = c.InsuranceApplicationRole_Id)
inner join InsuranceApplicationItem d on (c.InsuranceApplicationItem_Id = d.Id)
where a.ReferenceNumber = '17181/POL/000018-574'
and a.Discriminator = 'BaseInsurancePolicy' 
and b.SequenceNo = 239

select * from InsuranceProduct where Id = '8C3C7DFD-C942-45E7-8123-621F2141D434'

select b.Id,d.*
from Agreement a
inner join PartyRole b on (a.InsuranceApplication_Id = b.InsuranceApplication_Id)
inner join InsuranceApplicationRoleItem c on (b.Id = c.InsuranceApplicationRole_Id)
inner join InsuranceApplicationItem d on (c.InsuranceApplicationItem_Id =d.Id)
where a.ReferenceNumber = '18181/APE/000059-574'
and b.SequenceNo = 239

select * from ApplicantEndorsementTracking where InsuranceApplicationRole_Id = 'F6D6F13A-76DA-4EB8-9D0B-CA257771FA2F'
select * from InsuranceApplicationItem where Id = 'D546F0DF-EBA6-4769-96E3-85A28668D6F9'

--UPDATE InsuranceApplicationItem 
--SET TotalBeforeFee = -5044.27,
--	TotalAfterFee = -5044.27
--where Id = 'D546F0DF-EBA6-4769-96E3-85A28668D6F9'

