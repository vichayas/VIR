select * from Payment where Id = 'B21FBAAF-6AB8-4E7A-AC73-6FEB6FAD824C'
select * from PremiumSchedule where Id ='03563E4A-A04E-4217-B031-B2FA19C8F052'
select * from InsuranceApplication where Id = '4267ADEC-2F5D-4202-BD18-3CD0AA60B7F8'

select b.*
from PartyRole a
inner join InsuranceApplicationRoleItem b on (a.Id = b.InsuranceApplicationRole_Id)
where a.InsuranceApplication_Id = '4267ADEC-2F5D-4202-BD18-3CD0AA60B7F8'
and a.[Type_Id] = '1634B132-4285-4D54-87A9-6A3770A0AD2D'


select * from InsuranceApplicationItem where InsuranceApplication_Id = '4267ADEC-2F5D-4202-BD18-3CD0AA60B7F8' and InsuranceApplicationItemType_Id = 'F89579DB-7C44-409F-8D50-A0061D29D04E'

select * from InsuranceApplicationItem where Id = 'B621C4E0-DC5A-4D61-8228-7791DC94616D'
select * from InsuranceProduct where Id = 'B93A8A41-90D8-421D-8F63-678D4AE6BD62'


	
	select cl.CoverageLimitFrom, cp.*
	from CoverageTypeAvailability as cta
		inner join CoveragePremium as cp
			on cta.Id = cp.CoverageTypeAvailability_Id
		inner join CoverageLevel as cl
			on cl.Id = cp.CoverageRange_Id
		inner join InsuranceRate as ir
			on ir.Id = RangeInsuranceRate_Id
	where cta.InsuranceProduct_Id = 'B93A8A41-90D8-421D-8F63-678D4AE6BD62'
		and cp.PeriodMin <= 5 and cp.PeriodMax >= 5

	select * from InsuranceApplication where Id = '4267ADEC-2F5D-4202-BD18-3CD0AA60B7F8'
			
