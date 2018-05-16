

declare curtablename cursor local fast_forward for
select distinct ReferenceNumber
from [ExportMiscDB_VIB_VIS2MAMA_Empty].dbo.ExportResults
where Comment like '%pol_holder has%'
--select a.ReferenceNumber
--from Agreement a
--inner join InsuranceApplication b On (a.InsuranceApplication_Id = b.Id)
--where LEFT(a.ReferenceNumber,2) = 16
--and RIGHT(a.ReferenceNumber,3) in ('563', '574', '520', '511', '533') 
--and a.Discriminator = 'InsurancePolicy'
--and b.END_Sequence > 0

--select b.*
--from InsuranceApplication a
--inner join Agreement b on (a.Id = b.InsuranceApplication_Id)
--where a.PolicyNumber in
--(
--select a.ReferenceNumber
--from Agreement a
--inner join InsuranceApplication b On (a.InsuranceApplication_Id = b.Id)
--where LEFT(a.ReferenceNumber,2) = 16
--and RIGHT(a.ReferenceNumber,3) in ('563', '574', '520', '511', '533') 
--and a.Discriminator = 'InsurancePolicy'
--and b.END_Sequence > 0
--)
--AND b.Discriminator = 'InsuranceEndorsement'
--order by b.ReferenceNumber


DECLARE @RefNumber varchar(30)
DECLARE @sql  nvarchar(max)

open curtablename
fetch next from curtablename into @RefNumber
while(@@FETCH_STATUS=0)
begin
	
	set @sql= '[dbo].[VIS2MAMA_New_Policy] @Refno = '''+@RefNumber+''''
	print @sql
	execute sp_executesql @sql;
	fetch next from curtablename into @RefNumber
end
close curtablename
deallocate curtablename