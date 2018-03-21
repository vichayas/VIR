SELECT IA1.END_Sequence,a.Id,iai.TotalBeforeFee,iai.TotalAfterFee,iai.TotalDuty,a.ReferenceNumber,iai2.TotalBeforeFee,iai2.TotalAfterFee,iai2.TotalDuty,iai.PrimaryCoverageLevel
FROM InsuranceApplication IA1 
INNER JOIN InsuranceApplication IA2 ON IA2.Id = IA1.ParentId 
INNER JOIN InsuranceApplicationItem iai on iai.InsuranceApplication_Id=IA1.Id
INNER JOIN Agreement a on (a.InsuranceApplication_Id = IA1.Id)
LEFT JOIN InsuranceApplicationItem iai2 on (iai2.InsuranceApplication_Id=IA1.Id)
WHERE IA1.PolicyNumber = '17181/POL/000294-520'
AND a.Discriminator = 'InsuranceEndorsement'
AND iai.InsuranceApplicationItemType_Id like 'F8%'
AND iai2.InsuranceApplicationItemType_Id like '213F8708-FCC2-4430-A804-A1D115F718C5'
order by IA1.END_Sequence 

select * from InsuranceApplicationItemType where Id = '213F8708-FCC2-4430-A804-A1D115F718C5'

select * from Agreement where ReferenceNumber = '17181/POL/000002-574' and Discriminator = 'InsurancePolicy'

select * from InsuranceApplicationItem where Id = '66F642E8-C061-4020-9F7E-1110AC124A59'

select * from Agreement where ReferenceNumber = '18181/END/000008-520' 



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

	
