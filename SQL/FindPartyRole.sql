select b.*
from Agreement a
inner join PartyRole b on (a.InsuranceApplication_Id = b.InsuranceApplication_Id)
where b.[Type_Id] like '163%' and a.ReferenceNumber = '18181/POL/000032-520' and a.Discriminator = 'BaseInsurancePolicy'

select b.*
from Agreement a
inner join PartyRole b on (a.InsuranceApplication_Id = b.InsuranceApplication_Id)
where b.[Type_Id] like '163%' and a.ReferenceNumber = '18181/POL/000032-520' and a.Discriminator = 'InsurancePolicy'