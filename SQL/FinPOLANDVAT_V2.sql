

select 
a.referencenumber as appnumber, b.referencenumber as polnumber, 
f.referencenumber as paymnernumber,
party.DescriptionTH as InsuredName
from agreement a
inner join agreement b on (a.insuranceapplication_id = b.insuranceapplication_id and b.discriminator = 'InsurancePolicy')
inner join insuranceapplication c on (a.insuranceapplication_id = c.id)
inner join PartyRole party on (a.InsuranceApplication_Id = party.InsuranceApplication_Id)
left join premiumschedule d on (d.insuranceapplication_id = c.id)
left join paymentapplication e on (d.id = e.premiumschedule_id)
left join payment f on (f.id = e.payment_id)
where a.referencenumber in 
(
select ReferenceNumber
from 
Agreement 
where LEFT(ReferenceNumber,2) = '17'
and RIGHT(ReferenceNumber,3) = '511'
and RIGHT(LEFT(ReferenceNumber,5),3) = '502'
and (RunningNumber >= 995 and RunningNumber <= 1048)
and Discriminator = 'FileImportApplicant'
)
and party.[Type_Id] = '1634B132-4285-4D54-87A9-6A3770A0AD2D'
order by appnumber

select * from Agreement where Id ='A137AA3F-93A5-4AAD-AB8A-39C457B56C18'
select * from Agreement where InsuranceApplication_Id = '343368B3-3A1B-4537-94F9-598B57F6D58E'
select * from DocumentRunningRegistration where DescriptionTH = '18003/POL/000002-511'