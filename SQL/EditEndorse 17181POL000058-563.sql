

--Update Insured in Policy
UPDATE PartyRole
SET IsActive = 1
WHERE Id = '873A5E38-0706-43ED-A20F-C7178E2904F7'

--Delete Decreased insured
UPDATE ApplicantEndorsementItem
SET ApplicantEndorsement_Id = NULL
WHERE Id = 'A4621FC3-12B5-46DB-AEF6-6E3DC921FF9E'

select * from ApplicantEndorsementTracking where ApplicantEndorsementItem_Id = 'A4621FC3-12B5-46DB-AEF6-6E3DC921FF9E'
UPDATE ApplicantEndorsementTracking
SET InsuranceApplicationRole_Id = null --1991C3CD-5962-4F7E-BA25-10067A8452F4
 where ApplicantEndorsementItem_Id = 'A4621FC3-12B5-46DB-AEF6-6E3DC921FF9E'


 UPDATE InsuranceApplicationItem
 SET TotalBeforeFee = 2880.00,
	 TotalAfterFee = 2892.00,
	 PrimaryCoverageLevel = 30000
 WHERE Id = 'EFA2B281-4F22-4492-A5B6-5086ABB4030F' -- Update Item of endorse

 
 
 UPDATE InsuranceApplicationItem
 SET TotalBeforeFee = 2880.00,
	 TotalAfterFee = 2892.00,
	 PrimaryCoverageLevel = 30000
 WHERE Id = '88D3F8FB-F1E1-4D9F-BF1C-4331E4BE2DA2' -- Update Item of Policy

 
 --UPDATE InsuranceApplicationItem
 --SET TotalBeforeFee = 2880.00,
	-- TotalAfterFee = 2892.00,
	-- PrimaryCoverageLevel = 30000
 --WHERE Id = 'C57B2F9F-F772-4DFB-8D24-DE8995381654' -- Update Item of Policy

-- select * from InsuranceApplicationItem where Id = '0ACDDB34-1C5E-4253-BB81-E3B0144CF072'
-- SELECT * from InsuranceApplicationItem where id in ('14673C19-DD0D-46F6-B54F-132D8CE3B48A'
--,'EFA2B281-4F22-4492-A5B6-5086ABB4030F')
-- SELECT * from InsuranceApplicationItem where id in ('88D3F8FB-F1E1-4D9F-BF1C-4331E4BE2DA2'
--,'9356DF06-02A2-48DB-8729-C222C1FAD550')
-- select * from InsuranceApplicationRoleItem where InsuranceApplicationRole_Id = '1991C3CD-5962-4F7E-BA25-10067A8452F4'

-- select * from ApplicantEndorsementItem where Id = '157e67c3-c6f3-425f-a0ff-ddc3df028537'
-- select * from Agreement where Id = '721FF6D1-C49F-4E5F-BB29-195AF5B33DC0'
-- select * from InsuranceApplicationRoleItem where InsuranceApplicationRole_Id = '3F02DB64-03C4-4FEB-8972-0381DE7EAEEA'
-- select * from  InsuranceApplicationItem where Id = 'C57B2F9F-F772-4DFB-8D24-DE8995381654'

-- Update Insured in Endorse
UPDATE PartyRole
SET IsActive = 1
WHERE Id = '05A79047-C23E-4CB0-8ABE-E74CE8FDD179'

select b.*
from Agreement a
inner join InsuranceApplicationItem b on (a.InsuranceApplication_Id = b.InsuranceApplication_Id)
where a.ReferenceNumber = '17181/APE/000254-563'
 order by PrimaryCoverageLevel DESC

 Update InsuranceApplicationItem
 SET PrimaryCoverageLevel = '3600000'
 WHERE Id = 'B8B1A3CB-E01C-4124-8FA7-F58B191D1C2E'

 
select b.*
from Agreement a
inner join InsuranceApplicationItem b on (a.InsuranceApplication_Id = b.InsuranceApplication_Id)
where a.ReferenceNumber = '18181/APE/000015-563'
 order by PrimaryCoverageLevel DESC

 Update InsuranceApplicationItem
 SET PrimaryCoverageLevel = '3540000'
 WHERE Id = 'AF5A4A34-FA23-4D9F-BA65-2236A7DB4190'

select * 
from InsuranceApplicationItem
 where InsuranceApplication_Id = '3b8a7208-e3ba-4c1a-8921-e374fbf052d4' --Policy
 order by PrimaryCoverageLevel DESC

 
 Update InsuranceApplicationItem
 SET PrimaryCoverageLevel = '3540000'
 WHERE Id = '65069D31-1F5F-41DE-9A76-03797848EBD4'
