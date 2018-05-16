--Print Original
select a.FromDate,a.ThruDate,c.* 
from FormAvailability a
inner join ProductCategory b on(a.InsuranceProductCategory_Id = b.Id) 
inner join FormConfiguration c on (a.FormConfiguration_Id = c.Id)
inner join FormConfigurationAvailability d on (d.FormConfiguration_Id = c.Id)
inner join FormClassificationTypeAvailability e on (d.FormClassificationTypeAvailability_Id = e.Id)
where b.Code = '511'
--and a.PrintDefault = 0
and c.ShowStamp = 1
and a.PrintAsOriginal = 1
--and c.PaperSizeType_Id = '1BD99181-09C1-4A80-A740-91317E45F512'
and e.FormClassificationType_Id in
(
'FD668614-F5FF-4F09-A3CF-1D238B3F7DAE'--, --Policy
--'58BC8C2A-2E47-4FAD-A13A-D6C0E9B30431'  --Endorsement
)
order by c.Code


-- Print Copy

select a.FromDate,a.ThruDate,c.* 
from FormAvailability a
inner join ProductCategory b on(a.InsuranceProductCategory_Id = b.Id) 
inner join FormConfiguration c on (a.FormConfiguration_Id = c.Id)
inner join FormConfigurationAvailability d on (d.FormConfiguration_Id = c.Id)
inner join FormClassificationTypeAvailability e on (d.FormClassificationTypeAvailability_Id = e.Id)
where b.Code = '511'
--and a.PrintDefault = 0
and c.ShowStamp = 0
and a.PrintAsOriginal = 0
--and c.PaperSizeType_Id = '1BD99181-09C1-4A80-A740-91317E45F512'
and e.FormClassificationType_Id in
(
'FD668614-F5FF-4F09-A3CF-1D238B3F7DAE'--, --Policy
--'58BC8C2A-2E47-4FAD-A13A-D6C0E9B30431'  --Endorsement
)
order by c.Code


--select  c.*
--from EndorsementAvailability a
--inner join ProductCategory b on(a.InsuranceProductCategory_Id = b.Id) 
--inner join Endorsement c on (a.Endorsement_Id = c.Id)
--inner join Endorsement d on (c.Parent_Id = d.Id)
--where b.Code = '511'
