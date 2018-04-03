Select * from FinancialAccount
select top 1 * from FinancialAccountRole where FinancialAccount_Id = '3B9E83DB-6F35-4BBD-AAD7-01FF50DDF050'
select * from InsuranceApplicationRoleItem where FinancialAccountRole_Id is not null


select a.ReferenceNumber,d.DueDate as permit_date, f.ThruDate as expire_date, f.AccountName, f.AccountNo,f.Branch_Id, 
bank.Code as back_code, cc.Code as card_type, branch.Code as bank_branch_code,  branch.DescriptionTH,
payM.Code as paid_method, payM.DescriptionTH
from Agreement a
inner join PartyRole  b on (a.InsuranceApplication_Id = b.InsuranceApplication_Id)
inner join InsuranceApplicationRoleItem c on (b.Id = c.InsuranceApplicationRole_Id)
inner join PaymentMethodType payM on (c.PaymentMethodType_Id = payM.Id)
inner join PolicyItemPremium d on (c.InsuranceApplicationItem_Id = d.InsuranceApplicationItem_Id)
left join FinancialAccountRole e on (c.FinancialAccountRole_Id = e.Id)
left join FinancialAccount f on (e.FinancialAccount_Id = f.Id)
left join Party bank on (f.Bank_Id = bank.Id)
left join CreditCardType cc on (f.CreditCardType_Id = cc.Id)
left join ContactMechanism branch on (f.Branch_Id = branch.Id)
where a.ReferenceNumber like '%569'
and c.FinancialAccountRole_Id is not null
and payM.Code <> 4


select * from ContactMechanism where Id = 'E721AA3D-C2BD-4D46-9299-BA6D7F7D678B'



select d.*
from Agreement a
inner join PartyRole  b on (a.InsuranceApplication_Id = b.InsuranceApplication_Id)
inner join InsuranceApplicationRoleItem c on (b.Id = c.InsuranceApplicationRole_Id)
inner join PolicyItemPremium d on (c.InsuranceApplicationItem_Id = d.InsuranceApplicationItem_Id)
where a.ReferenceNumber = '16181/POL/000135-569'
and c.FinancialAccountRole_Id is not null


