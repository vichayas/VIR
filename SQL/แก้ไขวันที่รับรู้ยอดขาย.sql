select a.id,a.ReferenceNumber, a.CreatedDate, ia.PolicyIssuedDate, ia.TransactionDate, SignedDate, ia.CoveragePeriodStartDate, ia.CoveragePeriodEndDate, ias.FromDate , ias.CreatedDate 
from Agreement a inner join InsuranceApplication ia on
a.InsuranceApplication_Id = ia.id  inner join InsuranceApplicationStatus ias on
a.id = ias.InsuranceAgreement_Id
where a.Discriminator = 'InsurancePolicy' and substring(a.ReferenceNumber,1,2) = '18' and substring(a.ReferenceNumber,3,3) = '108' and 
substring(a.ReferenceNumber,11,6) = '000006' and substring(a.ReferenceNumber,18,3) = '520'
order by 2


update InsuranceApplicationStatus
set FromDate = '2018-03-12 19:59:23.447' --2018-02-21 19:59:23.447
--	CreatedDate = '2018-03-12 19:59:23.447'
from Agreement a inner join InsuranceApplication ia on
a.InsuranceApplication_Id = ia.id  inner join InsuranceApplicationStatus ias on
a.id = ias.InsuranceAgreement_Id
where a.Discriminator = 'InsurancePolicy' and substring(a.ReferenceNumber,1,2) = '18' and substring(a.ReferenceNumber,3,3) = '108' and 
substring(a.ReferenceNumber,11,6) = '000006' and substring(a.ReferenceNumber,18,3) = '520'

update InsuranceApplication
set PolicyIssuedDate  = '2018-03-12', --2018-02-21 19:59:04.663
	TransactionDate  = '2018-03-12',  --2018-02-21 19:59:04.663
	SignedDate  = '2018-03-12' --2018-02-16 00:00:00.000
--	CreatedDate = '2018-03-12'
from Agreement a inner join InsuranceApplication ia on
a.InsuranceApplication_Id = ia.id  inner join InsuranceApplicationStatus ias on
a.id = ias.InsuranceAgreement_Id
where a.Discriminator = 'InsurancePolicy' and substring(a.ReferenceNumber,1,2) = '18' and substring(a.ReferenceNumber,3,3) = '108' and 
substring(a.ReferenceNumber,11,6) = '000006' and substring(a.ReferenceNumber,18,3) = '520'


update InsuranceApplicationStatus
set ThruDate = '2018-03-12 19:59:23.447',
	CreatedDate = '2018-03-12 19:59:23.447'
where id in ('7D82B4D6-9DD0-4892-B014-E885F112A7AE')



select iast.DescriptionTH, a.ReferenceNumber, ias.* 
from InsuranceApplicationStatus ias inner join InsuranceApplicationStatusType iast on
ias.Type_Id = iast.id inner join Agreement a on
a.id = ias.InsuranceAgreement_Id
where ias.InsuranceAgreement_Id in ('48A4B10F-5517-45C6-8D01-27CEFC25E4C8','F5FD29D9-95D4-41D6-AA73-F8215B9ABD80')
order by CreatedDate desc

select * from InsuranceApplicationStatus
where id in ('7D82B4D6-9DD0-4892-B014-E885F112A7AE')


select * from InsuranceApplication
where id in ('F81A25B9-BFF9-416C-8231-2F11E3132FB0')

select * from Agreement
where InsuranceApplication_Id  in ('F81A25B9-BFF9-416C-8231-2F11E3132FB0')

print ' update วันที่อนุมัติ '
select CreatedDate, * from Agreement
where ReferenceNumber = '18181/POL/000006-520'
/*
update Agreement
set CreatedDate = '2018-03-12 20:01:00.947'
where ReferenceNumber = '18181/POL/000006-520'
*/