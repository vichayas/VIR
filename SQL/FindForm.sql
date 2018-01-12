select fc.* 
from FormConfiguration fc
inner join FormAvailability fa on fa.FormConfiguration_Id=fc.Id
inner join ProductCategory p on p.Id=fa.InsuranceProductCategory_Id
where p.Code='511'
