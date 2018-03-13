print '*** หา InsuranceApplication_Id ***'
select a.id,a.InsuranceApplication_Id,a.ReferenceNumber ,ia.CurrentPolicyReferenceNo, ia.CoveragePeriodStartDate ,a.BranchCode, a.CreatedDate, a.CreatedUserName
from Agreement a inner join  InsuranceApplication ia on
a.InsuranceApplication_Id = ia.id --inner join  InsuranceApplication ia2 on
where a.ReferenceNumber is  null and a.CreatedDate between '2017-01-01' and getdate() and --a.BranchCode = '108' and 
a.Discriminator = 'InsuranceNotificationRenewal'
order by 6,ia.CurrentPolicyReferenceNo

-- http://localhost:1958/InsuranceRenewal/UpdateRenewal?GUID=02979DA3-3958-4598-9B0A-28D73E82E8C2
/*
update Agreement
set  IsWaitQueueProcess = '0',
IsDataEnough = '1'
where id IN ('70A262DA-3845-4907-AB38-E12AFD253E61')

IsWaitQueueProcess = '0'  -- พร้อมบันทึก
IsWaitQueueProcess = '1' -- เรียบร้อย
IsWaitQueueProcess = '2' -- กำลังบันทึก
*/

select IsWaitQueueProcess,IsDataEnough,* from agreement
where --id = '17F5C0FA-30A7-496C-958A-82719408E866' or ReferenceNumber in ('17181/REW/000228-533','17181/POL/000039-533')
ReferenceNumber in ('17210/POL/000008-117')
--ReferenceNumber in ('17709/REW/000001-117')


select iast.[Group], iast.DescriptionTH, ias.*
from InsuranceApplicationStatus ias inner join  InsuranceApplicationStatusType iast on
 ias.Type_Id = iast.id
where ias.InsuranceAgreement_Id = '70A262DA-3845-4907-AB38-E12AFD253E61'
/*
delete InsuranceApplicationStatus
where id = 'EADD6DBD-B040-4D55-8590-FC560DFEE4FA'

update InsuranceApplicationStatus
set ThruDate = null
where id = '3E3A8805-E3B6-49B4-9681-152E07CEA39A'
*/

select * from InsuranceApplication
where id in (
'CDF36F9D-C513-4CD5-8202-D8344200103E',
'EC7E4129-958D-4D1D-863D-E2F0E19BCB69',
'23D362DA-3967-4C61-9024-40DC0042EF49')

-- หาเลข Renewal
select a1.ReferenceNumber as 'Policy', a2.ReferenceNumber as 'Renewal'
from Agreement a1 inner join PolicyRenewalItem prei on
a1.id = prei.InsurancePolicyId inner join agreement a2 on
a2.id = prei.InsuranceRenewalId
where a1.ReferenceNumber in (
'17181/POL/000004-563',
'17181/POL/000005-563',
'17181/POL/000006-563',
'17181/POL/000007-563',
'17181/POL/000008-563',
'17181/POL/000009-563',
'17181/POL/000010-563',
'17181/POL/000011-563',
'17181/POL/000012-563',
'17181/POL/000016-563',
'17181/POL/000025-563')
order by 1
