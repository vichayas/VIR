select * from InsuranceApplicationItem where CONVERT(char(15),CreatedDate,121) = '2017-12-18 10:2' order by CreatedDate desc

--select * from InsuranceApplicationStatus where CONVERT(char(8),CreatedDate,112) = '20171217' order by CreatedDate desc

--select * from InsuranceApplicationRoleItem where  convert(char(8),CreatedDate,112)='20171217'

select CreatedDate, ModifiedDate,* from InsuranceApplicationItem a where CONVERT(char(8),CreatedDate,112) = '20171218' order by a.CreatedDate DESC

--select Name = 'InsuranceApplicationRoleItem', TDate = convert(char(19),max(CreatedDate),121), count(1) 
--from InsuranceApplicationRoleItem with (nolock) 
--group by convert(char(8),CreatedDate,112)
-- having convert(char(8),CreatedDate,112)='20171217' 
-- and max(CreatedDate) > 0