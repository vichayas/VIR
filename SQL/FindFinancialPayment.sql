select top 1 * 
from payment

select top 1 * from PaymentApplication

select * from InsuranceApplicationRoleItem where FinancialAccountRole_Id is not null and PaymentMethodType_Id = 'D9C58BFD-78B1-4575-B71C-358AB36E393E' order by CreatedDate desc

select * from FinancialAccount where Id = '2386F0A4-1A79-4CDF-AEB4-0BF6962C763B'
select * from FinancialAccountRole where Id = 'FF5F2514-843E-4628-9323-CD9CBEDA7C55'
select * from PaymentMethodType where Id = '0AE570CB-FBA5-43EF-A217-1C36A8C13BF9'
