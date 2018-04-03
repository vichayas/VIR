select a.ReferenceNumber
from Agreement a
inner join InsuranceApplication b on (a.InsuranceApplication_Id = b.Id)
where a.Discriminator like 'InsurancePolicy'
and b.END_Sequence = 0
and LEFT(a.ReferenceNumber,2) = '16'
and RIGHT(a.ReferenceNumber,3) = '563'
order by a.ReferenceNumber


select * from InsuranceBranchAvailabilty

select b.Code,a.DescriptionTH,a.Code,c.branch_code
from ContactMechanism  a  WITH(NOlock) 
inner join Party b WITH(NOlock) on (a.Party_Id = b.Id)
inner join 
(
	select a.bank_code, count(a.bank_code) as cT,  branch_name, count(branch_name) as bbT
	from [VISCON].[centerdb_vib].[dbo].[bankbranch] a
	group by a.bank_code, branch_name 
	having count(branch_name) = 2
) as c on (b.Code = c.bank_code and a.DescriptionTH = c.branch_name)
where a.Discriminator = 'Branch' and a.Code is null
order by b.Code


UPDATE a
SET  a.Code = c.branch_code
from ContactMechanism  a  WITH(NOlock) 
inner join Party b WITH(NOlock) on (a.Party_Id = b.Id)
inner join [VISCON].[centerdb_vib].[dbo].[bankbranch] c on (b.Code = c.bank_code and a.DescriptionTH = c.branch_name)
where a.Discriminator = 'Branch' and a.Code is null
group by  b.Code,a.DescriptionTH,c.branch_code
where a.Discriminator = 'Branch' 



select a.bank_code, count(a.bank_code),  branch_name, count(branch_name)
from [VISCON].[centerdb_vib].[dbo].[bankbranch] a
inner join  [VISCON].[centerdb_vib].[dbo].[bank] b on a.bank_code = b.bank_code
where b.active_row = 'Y' and branch_name <> '' and a.active_row = 'Y'
group by a.bank_code, branch_name 
having count(1) = 1


select * from  [VISCON].[centerdb_vib].[dbo].[bankbranch] where bank_code = 'SCB' and branch_code = '0820'
select * from  [VISCON].[centerdb_vib].[dbo].[bank] where bank_code = 'BAAC' and active_row = 'Y'