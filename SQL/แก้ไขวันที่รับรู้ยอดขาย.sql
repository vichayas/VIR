select a.id,a.ReferenceNumber, a.CreatedDate, ia.PolicyIssuedDate, ia.TransactionDate, SignedDate, ia.CoveragePeriodStartDate, ia.CoveragePeriodEndDate, ias.FromDate , ias.CreatedDate 
from Agreement a inner join InsuranceApplication ia on
a.InsuranceApplication_Id = ia.id  inner join InsuranceApplicationStatus ias on
a.id = ias.InsuranceAgreement_Id
where a.Discriminator = 'InsurancePolicy' and substring(a.ReferenceNumber,1,2) = '18' and substring(a.ReferenceNumber,3,3) = '181' and 
substring(a.ReferenceNumber,11,6) in ('000001','000002','000003','000004','000005','000006','000007','000008','000009','000010','000011') and substring(a.ReferenceNumber,18,3) = '518'
order by 2


update InsuranceApplicationStatus
set FromDate = '2018-04-30 19:59:23.447' --2018-02-21 19:59:23.447
--	CreatedDate = '2018-03-12 19:59:23.447'
from Agreement a inner join InsuranceApplication ia on
a.InsuranceApplication_Id = ia.id  inner join InsuranceApplicationStatus ias on
a.id = ias.InsuranceAgreement_Id
where a.Discriminator = 'InsurancePolicy' and substring(a.ReferenceNumber,1,2) = '18' and substring(a.ReferenceNumber,3,3) = '181' and 
substring(a.ReferenceNumber,11,6) in ('000001','000002','000003','000004','000005','000006','000007','000008','000009','000010','000011')  and substring(a.ReferenceNumber,18,3) = '518'

update InsuranceApplication
set PolicyIssuedDate  = '2018-04-30', --2018-02-21 19:59:04.663
	TransactionDate  = '2018-04-30',  --2018-02-21 19:59:04.663
	SignedDate  = '2018-04-30' --2018-02-16 00:00:00.000
--	CreatedDate = '2018-03-12'
from Agreement a inner join InsuranceApplication ia on
a.InsuranceApplication_Id = ia.id  inner join InsuranceApplicationStatus ias on
a.id = ias.InsuranceAgreement_Id
where a.Discriminator = 'InsurancePolicy' and substring(a.ReferenceNumber,1,2) = '18' and substring(a.ReferenceNumber,3,3) = '181' and 
substring(a.ReferenceNumber,11,6) in ('000001','000002','000003','000004','000005','000006','000007','000008','000009','000010','000011')  and substring(a.ReferenceNumber,18,3) = '518'


update InsuranceApplicationStatus
set ThruDate = '2018-04-30 19:59:23.447',
	CreatedDate = '2018-04-30 19:59:23.447'
where id in ('7D82B4D6-9DD0-4892-B014-E885F112A7AE')



select iast.DescriptionTH, a.ReferenceNumber, ias.* 
from InsuranceApplicationStatus ias inner join InsuranceApplicationStatusType iast on
ias.Type_Id = iast.id inner join Agreement a on
a.id = ias.InsuranceAgreement_Id
where ias.InsuranceAgreement_Id in ('3070750F-4B50-4A0A-A786-38FECF5E3F74')
order by CreatedDate desc

select * from InsuranceApplicationStatus
where id in ('7D82B4D6-9DD0-4892-B014-E885F112A7AE')


select * from InsuranceApplication
where id in ('F81A25B9-BFF9-416C-8231-2F11E3132FB0')

select * from Agreement
where InsuranceApplication_Id  in ('F81A25B9-BFF9-416C-8231-2F11E3132FB0')

print ' update วันที่อนุมัติ '
select CreatedDate, * from Agreement
where ReferenceNumber in ('18181/POL/000001-518',
 '18181/POL/000002-518',
 '18181/POL/000003-518',
 '18181/POL/000004-518',
 '18181/POL/000005-518',
 '18181/POL/000006-518',
 '18181/POL/000007-518',
 '18181/POL/000008-518',
 '18181/POL/000009-518',
 '18181/POL/000010-518',
 '18181/POL/000011-518'
)
/*
update Agreement
set CreatedDate = '2018-04-30 19:59:23.447'
where ReferenceNumber = '18181/POL/000001-518'
*/

