Declare @RefNo varchar(50) = '18502/APP/000503-511' ---17502/APP/000109-511,18502/APP/000178-511
DECLARE @yearAD varchar(3) = LEFT(@RefNo,2)
Declare @Subclass varchar(3) = RIGHT(@RefNo,3)
Declare @BranchCode varchar(3) = RIGHT(LEFT(@RefNo,5),3)
Declare @Type varchar(3) = RIGHT(LEFT(@RefNo,9),3)
Declare @BranchId uniqueidentifier
Declare @PolicyItemPremiumTarget_Id uniqueidentifier

--select * 
--INTO #PartyRole
--from PartyRole 
--where Party_Id = 'CA6185FE-B1EB-4E38-B842-60D966BB4241'
--and InsuranceApplication_Id = '7CD096A1-182F-48C9-9493-E74B3DEF7C0A'  --Address   105/1 บริษัท โตโยต้าสุโขทัย ผู้จำหน่ายโตโยต้า จำกัด

--select * from Party where DescriptionTH like '%โตโยต้าสุโขทัย ผู้จำหน่ายโตโยต้า%'
--select * from CompanyRegistration where Organization_Id =  'CA6185FE-B1EB-4E38-B842-60D966BB4241'
--select * from OrganizationName where Organization_Id =  'CA6185FE-B1EB-4E38-B842-60D966BB4241'
--select * from PartyClassification where Party_Id =  'CA6185FE-B1EB-4E38-B842-60D966BB4241'

--select * from PaymentRole where PartyRole_Id = '059D53E6-C734-40C0-BC6B-46E6E092689B'

--select * 
--INTO #PartyRole
--from PartyRole 
--where InsuranceApplication_Id = '3BE134C5-FCF5-4601-B1C9-8CABC63BC18D' 
--and Party_Id = 'BCD52734-932C-4B75-87A0-F70FFAA1EC17' --Address   76/11  บริษัท สุโขทัย ฮอนด้าคาร์ส์ จำกัด

--UPDATE #PartyRole
--SET InsuranceApplication_Id = @InsuranceApplication_Id,
--    Party_Id = 'CA6185FE-B1EB-4E38-B842-60D966BB4241',
--	DescriptionTH = 'บริษัท โตโยต้าสุโขทัย ผู้จำหน่ายโตโยต้า จำกัด สำนักงานใหญ่',
--	DescriptionEN = 'บริษัท โตโยต้าสุโขทัย ผู้จำหน่ายโตโยต้า จำกัด สำนักงานใหญ่'


--select * from CompanyRegistration where Organization_Id = '3DCB1D20-0D50-4DC3-AC56-963BFB3AD21B'

--select * 
----INTO #PartyRole
--from PartyRole 
--where InsuranceApplication_Id = 'FD6B2AFD-97D3-4F9F-AB5E-BBD7C13D7B01' 
--and Party_Id = 'D3069434-045D-478E-92DB-7FD81C6C2D8A' --Address 127 
----and DescriptionTH like '%บริษัท โตโยต้าสุโขทัยผู้จำหน่ายโตโยต้า จำกัด%'

--select top 2 c.Id as ContactMechanism_Id, e.Id as ContactMechanismPurposeType_Id, a.DescriptionTH, c.Address1
--INTO #RoleContactMechanismMap
--from Party a
--inner join PartyContactMechanism  b on (a.Id = b.Party_Id)
--inner join ContactMechanism c on (b.ContactMechanism_Id = c.Id)
--left join PartyContactMechanismPurpose d on (b.Id = d.PartyContactMechanism_Id)
--left join ContactMechanismPurposeType e on (d.[Type_Id] = e.Id)
--where a.Id = 'CA6185FE-B1EB-4E38-B842-60D966BB4241'--Address   105/1 บริษัท โตโยต้าสุโขทัย ผู้จำหน่ายโตโยต้า จำกัด
--and b.Id in ('44ECD39E-EAF9-4606-AAB9-06C4798930EE','78165550-A289-48D9-92B7-0D5B0C6887F2' )
--order by c.CreatedDate DESC

Declare @AgreementId uniqueidentifier
Declare @InsuranceApplication_Id uniqueidentifier
Declare @PremiumSchedule_Id uniqueidentifier
Declare @PaymentId uniqueidentifier
Declare @PaymentRole_Id uniqueidentifier
Declare @PolicyItemPremium_Id uniqueidentifier

print @Type
print @BranchCode
print @yearAD
print @Subclass

select @AgreementId = a.Id,
@InsuranceApplication_Id =a.InsuranceApplication_Id, 
@PremiumSchedule_Id = b.Id, 
 @PaymentId = d.Id,
@PaymentRole_Id = f.Id, 
@PolicyItemPremium_Id = e.Id
from Agreement a
left join PremiumSchedule b on (a.InsuranceApplication_Id = b.InsuranceApplication_Id)
left join PaymentApplication c on (b.Id = c.PremiumSchedule_Id)
left join Payment d on (c.Payment_Id = d.Id)
left join PaymentRole f on (f.Payment_Id = d.Id)
left join PolicyItemPremium e on (b.Id = e.PremiumSchedule_Id)
where a.ReferenceNumber = @RefNo 

print @InsuranceApplication_Id
print @PaymentId
print @AgreementId

DECLARE @PartyId varchar(100)-- = '955B59C8-0236-4007-B13C-7A37AD2E5EAE' 
--Create #PartyRole

--select * 
--INTO #PartyRole
--from PartyRole 
--where  Party_Id = 'A66B6287-0F0F-4A5E-9A3A-ECE4656D63DB'
--and InsuranceApplication_Id = '960D9FEB-D7F5-41F6-A2CD-E7502957385A' --  180 สำนักงานใหญ่ 

--select top 2 c.Id as ContactMechanism_Id, e.Id as ContactMechanismPurposeType_Id, c.Address1
--INTO #RoleContactMechanismMap
--from Party a
--inner join PartyContactMechanism  b on (a.Id = b.Party_Id)
--inner join ContactMechanism c on (b.ContactMechanism_Id = c.Id)
--inner join PartyContactMechanismPurpose d on (b.Id = d.PartyContactMechanism_Id)
--inner join ContactMechanismPurposeType e on (d.[Type_Id] = e.Id)
--where a.Id = 'A66B6287-0F0F-4A5E-9A3A-ECE4656D63DB'  --  180 สำนักงานใหญ่
--and c.Address1 like 'เลขที่ 180%'
--order by c.CreatedDate DESC

--select b.Address1 
--from InsuranceApplicationRoleContactMechanism a
--inner join ContactMechanism b on (a.ContactMechanism_Id = b.Id)
--where a.InsuranceApplicationRole_Id = '9686EAF0-1570-4BE0-BF0D-28BCC559CF7B'

--select * from Party where Id = 'A66B6287-0F0F-4A5E-9A3A-ECE4656D63DB'
--select * from CompanyRegistration where Organization_Id = 'A66B6287-0F0F-4A5E-9A3A-ECE4656D63DB' and ThruDate is null


--============================== End Address    180 อุตรดิต สำนักงานใหญ่ 0535538000015


--select top 2 c.Id as ContactMechanism_Id, e.Id as ContactMechanismPurposeType_Id, c.Address1
----INTO #RoleContactMechanismMap
--from Party a
--inner join PartyContactMechanism  b on (a.Id = b.Party_Id)
--inner join ContactMechanism c on (b.ContactMechanism_Id = c.Id)
--inner join PartyContactMechanismPurpose d on (b.Id = d.PartyContactMechanism_Id)
--inner join ContactMechanismPurposeType e on (d.[Type_Id] = e.Id)
--where a.Id = 'E5802500-983B-4ECC-9DCF-ACF2159DBAD4' --Address  19 สำนักงานใหญ่
--and c.Address1 like 'เลขที่ 19%'
--order by c.CreatedDate DESC

--select * 
----INTO #PartyRole
--from PartyRole 
--where InsuranceApplication_Id = '252BC3A8-94A5-4454-9A80-0C8586029406'
--and Party_Id = 'E5802500-983B-4ECC-9DCF-ACF2159DBAD4' --Address  19 สำนักงานใหญ่


--select b.Address1 
--from InsuranceApplicationRoleContactMechanism a
--inner join ContactMechanism b on (a.ContactMechanism_Id = b.Id)
--where a.InsuranceApplicationRole_Id = 'B272022D-A897-4F11-A9AC-2C6437648E75'

--select * from Party where Id = 'E5802500-983B-4ECC-9DCF-ACF2159DBAD4'
--select * from CompanyRegistration where Organization_Id = 'E5802500-983B-4ECC-9DCF-ACF2159DBAD4' and ThruDate is null

--============================== End Address  19 บริษัท อีซูซุพิษณุโลกฮกอันตึ๊ง จำกัด สำนักงานใหญ่ 0655536000092

--select * 
----INTO #PartyRole
--from PartyRole 
--where InsuranceApplication_Id = 'B8FAD54E-6D72-4E49-9CD2-41722BE64825' 
--and Party_Id = 'B297E7E4-BB49-4C3B-884F-33B33E5913D7' --Address   168  บริษัท (EN) อีซูซุพิษณุโลกฮกอันตึ๊ง  สาขาที่ 00001


--select top 2 c.Id as ContactMechanism_Id, e.Id as ContactMechanismPurposeType_Id, a.DescriptionTH, c.Address1
----INTO #RoleContactMechanismMap
--from Party a
--inner join PartyContactMechanism  b on (a.Id = b.Party_Id)
--inner join ContactMechanism c on (b.ContactMechanism_Id = c.Id)
--left join PartyContactMechanismPurpose d on (b.Id = d.PartyContactMechanism_Id)
--left join ContactMechanismPurposeType e on (d.[Type_Id] = e.Id)
--where a.Id = 'B297E7E4-BB49-4C3B-884F-33B33E5913D7'  --Address  168 บริษัท (EN) อีซูซุพิษณุโลกฮกอันตึ๊ง  สาขาที่ 00001
--and b.Id in ('60D42AA9-5A91-4988-BF0A-2E5DF84A435E')
--order by c.CreatedDate DESC

--select b.Address1 
--from InsuranceApplicationRoleContactMechanism a
--inner join ContactMechanism b on (a.ContactMechanism_Id = b.Id)
--where a.InsuranceApplicationRole_Id = '4050A720-C209-469B-887E-54F33F715129'

--select * from Party where Id = 'B297E7E4-BB49-4C3B-884F-33B33E5913D7'
--select * from CompanyRegistration where Organization_Id = 'B297E7E4-BB49-4C3B-884F-33B33E5913D7' and ThruDate is null


--============================== End Address  168 บริษัท (EN) อีซูซุพิษณุโลกฮกอันตึ๊ง  สาขาที่ 00001 0655536000092


--select top 2 c.Id as ContactMechanism_Id, e.Id as ContactMechanismPurposeType_Id, c.Address1
----INTO #RoleContactMechanismMap
--from Party a
--inner join PartyContactMechanism  b on (a.Id = b.Party_Id)
--inner join ContactMechanism c on (b.ContactMechanism_Id = c.Id)
--inner join PartyContactMechanismPurpose d on (b.Id = d.PartyContactMechanism_Id)
--inner join ContactMechanismPurposeType e on (d.[Type_Id] = e.Id)
--where a.Id = 'E8B4AC8D-58C0-4206-8A7F-45B3DED7C414'  --Address  206/4-8 สุโขทัยฮกอันตึ๊
--order by c.CreatedDate DESC

--select * 
----INTO #PartyRole
--from PartyRole 
--where InsuranceApplication_Id = 'F92BFA25-301C-41B9-A986-D1D3E5166610' 
--and Party_Id = 'E8B4AC8D-58C0-4206-8A7F-45B3DED7C414' --Address   206/4-8  สุโขทัยฮกอันตึ๊


--select b.Address1 
--from InsuranceApplicationRoleContactMechanism a
--inner join ContactMechanism b on (a.ContactMechanism_Id = b.Id)
--where a.InsuranceApplicationRole_Id = '406125E6-0A14-409D-99D4-017E2BAAFF1D'

--select * from Party where Id = 'E8B4AC8D-58C0-4206-8A7F-45B3DED7C414'
--select * from CompanyRegistration where Organization_Id = 'E8B4AC8D-58C0-4206-8A7F-45B3DED7C414' and ThruDate is null


--============================== End Address   206/4-8  บริษัท สุโขทัยฮกอันตึ๊ง (1978) จำกัด สำนักงานใหญ่ 0645521000024

--select c.Id as ContactMechanism_Id, e.Id as ContactMechanismPurposeType_Id, c.Address1
----INTO #RoleContactMechanismMap
--from Party a
--inner join PartyContactMechanism  b on (a.Id = b.Party_Id)
--inner join ContactMechanism c on (b.ContactMechanism_Id = c.Id)
--inner join PartyContactMechanismPurpose d on (b.Id = d.PartyContactMechanism_Id)
--inner join ContactMechanismPurposeType e on (d.[Type_Id] = e.Id)
--where a.Id = 'D3069434-045D-478E-92DB-7FD81C6C2D8A'  --Address  168 อีซูซุตากฮกอันตึ๊ง
--and Address1 like '%168%'
--order by c.CreatedDate DESC

--select * 
----INTO #PartyRole
--from PartyRole 
--where InsuranceApplication_Id = '871BC10B-E381-4A7F-B128-64F726A38F2C' 
--and Party_Id = 'D3069434-045D-478E-92DB-7FD81C6C2D8A' --Address   168  อีซูซุตากฮกอันตึ๊ง


--select b.Address1 
--from InsuranceApplicationRoleContactMechanism a
--inner join ContactMechanism b on (a.ContactMechanism_Id = b.Id)
--where a.InsuranceApplicationRole_Id = 'CBFA0EE6-CEC0-446F-A52A-8732485D5D2B'

--select * from Party where Id = 'D3069434-045D-478E-92DB-7FD81C6C2D8A'
--select * from CompanyRegistration where Organization_Id = 'D3069434-045D-478E-92DB-7FD81C6C2D8A' and ThruDate is null


--============================== End Address   168  บริษัท (EN) อีซูซุตากฮกอันตึ๊ง จำกัด สำนักงานใหญ่ 0635542000155
--select * 
--INTO #PartyRole
--from PartyRole 
--where InsuranceApplication_Id = '7FC5C6AE-4D12-4B6F-BB33-BE13253C45DB' 
--and Party_Id = '418A4E21-F28B-4F1B-BC3A-93A365976C4B' --Address  16/12
----and DescriptionTH = 'บริษัท อีซูซุตากฮกอันตึ๊ง จำกัด สาขาแม่สอด สาขาที่ 00001'

--select top 2 c.Id as ContactMechanism_Id, e.Id as ContactMechanismPurposeType_Id, c.Address1
--INTO #RoleContactMechanismMap
--from Party a
--inner join PartyContactMechanism  b on (a.Id = b.Party_Id)
--inner join ContactMechanism c on (b.ContactMechanism_Id = c.Id)
--inner join PartyContactMechanismPurpose d on (b.Id = d.PartyContactMechanism_Id)
--inner join ContactMechanismPurposeType e on (d.[Type_Id] = e.Id)
--where a.Id = '418A4E21-F28B-4F1B-BC3A-93A365976C4B'  --  --Address  16/12
--order by c.CreatedDate DESC


--select b.Address1 
--from InsuranceApplicationRoleContactMechanism a
--inner join ContactMechanism b on (a.ContactMechanism_Id = b.Id)
--where a.InsuranceApplicationRole_Id = 'D6669CD3-F233-4BF7-A15D-3271C7BBDE93'

--select * from Party where Id = '418A4E21-F28B-4F1B-BC3A-93A365976C4B'
--select * from CompanyRegistration where Organization_Id = '418A4E21-F28B-4F1B-BC3A-93A365976C4B' and ThruDate is null


--============================== End Address   16/12 บริษัท อีซูซุตากฮกอันตึ๊ง จำกัด สาขาแม่สอด สาขาที่ 00001 0635542000155


--select top 2 c.Id as ContactMechanism_Id, e.Id as ContactMechanismPurposeType_Id, c.Address1
--INTO #RoleContactMechanismMap
--from Party a
--inner join PartyContactMechanism  b on (a.Id = b.Party_Id)
--inner join ContactMechanism c on (b.ContactMechanism_Id = c.Id)
--inner join PartyContactMechanismPurpose d on (b.Id = d.PartyContactMechanism_Id)
--inner join ContactMechanismPurposeType e on (d.[Type_Id] = e.Id)
--where a.Id = 'D3069434-045D-478E-92DB-7FD81C6C2D8A' --Address  127 ตาก
--and c.Address1 like 'เลขที่ 127%'
--order by c.CreatedDate DESC


--select * 
--INTO #PartyRole
--from PartyRole 
--where InsuranceApplication_Id = 'FD6B2AFD-97D3-4F9F-AB5E-BBD7C13D7B01' 
--and Party_Id = 'D3069434-045D-478E-92DB-7FD81C6C2D8A' --Address 127 
--and DescriptionTH like '%บริษัท อีซูซุตากฮกอันตึ๊ง จำกัด%'

--select b.Address1 
--from InsuranceApplicationRoleContactMechanism a
--inner join ContactMechanism b on (a.ContactMechanism_Id = b.Id)
--where a.InsuranceApplicationRole_Id = '26B70C25-C377-4050-A761-03FE0228F0E1'

--select * from Party where Id = 'D3069434-045D-478E-92DB-7FD81C6C2D8A'
--select * from CompanyRegistration where Organization_Id = 'D3069434-045D-478E-92DB-7FD81C6C2D8A' and ThruDate is null


--============================== End Address  127 บริษัท อีซูซุตากฮกอันตึ๊ง จำกัด สำนักงานใหญ่ 0635542000155

--select * 
----INTO #PartyRole
--from PartyRole 
--where InsuranceApplication_Id = '3BE134C5-FCF5-4601-B1C9-8CABC63BC18D' 
--and Party_Id = 'BCD52734-932C-4B75-87A0-F70FFAA1EC17' --Address   76/11  บริษัท สุโขทัย ฮอนด้าคาร์ส์ จำกัด


--select top 2 c.Id as ContactMechanism_Id, e.Id as ContactMechanismPurposeType_Id, a.DescriptionTH, c.Address1
----INTO #RoleContactMechanismMap
--from Party a
--inner join PartyContactMechanism  b on (a.Id = b.Party_Id)
--inner join ContactMechanism c on (b.ContactMechanism_Id = c.Id)
--left join PartyContactMechanismPurpose d on (b.Id = d.PartyContactMechanism_Id)
--left join ContactMechanismPurposeType e on (d.[Type_Id] = e.Id)
--where a.Id = 'BCD52734-932C-4B75-87A0-F70FFAA1EC17' --Address  76/11  บริษัท สุโขทัย ฮอนด้าคาร์ส์ จำกัด
--and b.Id in ('DFB33E9D-DA6D-4024-A0BF-E1AB15CE246E')
--order by c.CreatedDate DESC

--select b.Address1 
--from InsuranceApplicationRoleContactMechanism a
--inner join ContactMechanism b on (a.ContactMechanism_Id = b.Id)
--where a.InsuranceApplicationRole_Id = 'E507B1A2-70AC-4E09-82E2-075B88D00070'

--select * from Party where Id = 'BCD52734-932C-4B75-87A0-F70FFAA1EC17'
--select * from CompanyRegistration where Organization_Id = 'BCD52734-932C-4B75-87A0-F70FFAA1EC17' and ThruDate is null

----============================== End Address   76/11  บริษัท สุโขทัย ฮอนด้าคาร์ส์ จำกัด 0645538000081



--select * 
----INTO #PartyRole
--from PartyRole 
--where Party_Id = 'CA6185FE-B1EB-4E38-B842-60D966BB4241'
--and InsuranceApplication_Id = '0A44A64D-47D3-409F-B8E6-EE9AED11624D'  --Address   105/1 บริษัท โตโยต้าสุโขทัย ผู้จำหน่ายโตโยต้า จำกัด


--select top 2 c.Id as ContactMechanism_Id, e.Id as ContactMechanismPurposeType_Id, a.DescriptionTH, c.Address1
----INTO #RoleContactMechanismMap
--from Party a
--inner join PartyContactMechanism  b on (a.Id = b.Party_Id)
--inner join ContactMechanism c on (b.ContactMechanism_Id = c.Id)
--left join PartyContactMechanismPurpose d on (b.Id = d.PartyContactMechanism_Id)
--left join ContactMechanismPurposeType e on (d.[Type_Id] = e.Id)
--where a.Id = 'CA6185FE-B1EB-4E38-B842-60D966BB4241'--Address   105/1 บริษัท โตโยต้าสุโขทัย ผู้จำหน่ายโตโยต้า จำกัด
--and b.Id in ('44ECD39E-EAF9-4606-AAB9-06C4798930EE','78165550-A289-48D9-92B7-0D5B0C6887F2' )
--order by c.CreatedDate DESC

--select b.Address1 
--from InsuranceApplicationRoleContactMechanism a
--inner join ContactMechanism b on (a.ContactMechanism_Id = b.Id)
--where a.InsuranceApplicationRole_Id = 'A7A5F6B5-E293-4178-AAC8-F49AE8C5B2D1'

--select * from Party where Id = 'CA6185FE-B1EB-4E38-B842-60D966BB4241'
--select * from CompanyRegistration where Organization_Id = 'CA6185FE-B1EB-4E38-B842-60D966BB4241' and ThruDate is null

--============================== End Address  105/1 บริษัท โตโยต้าสุโขทัย ผู้จำหน่ายโตโยต้า จำกัด 0645516000038


--==============================
select top 2 c.Id as ContactMechanism_Id, e.Id as ContactMechanismPurposeType_Id, c.Address1
INTO #RoleContactMechanismMap
from Party a
inner join PartyContactMechanism  b on (a.Id = b.Party_Id)
inner join ContactMechanism c on (b.ContactMechanism_Id = c.Id)
inner join PartyContactMechanismPurpose d on (b.Id = d.PartyContactMechanism_Id)
inner join ContactMechanismPurposeType e on (d.[Type_Id] = e.Id)
where a.Id = '1E4446D4-38E9-44D4-B7A9-53AA92770996'  --Address  89 บริษัท สุโขทัย พี แอนด์ วาย มอเตอร์ จำกัด สำนักงานใหญ่ง
order by c.CreatedDate DESC

select * 
INTO #PartyRole
from PartyRole 
where InsuranceApplication_Id = '805C3BE5-FE4B-4042-B05A-00E1E4F2E46E' 
and Party_Id = '1E4446D4-38E9-44D4-B7A9-53AA92770996' --Address   89  บริษัท สุโขทัย พี แอนด์ วาย มอเตอร์ จำกัด สำนักงานใหญ่ง

--select b.* 
--from PaymentRole a 
--inner join OrganizationName b on (a.OrganizationName_Id = b.Id)
--where PartyRole_Id = 'B3738D0E-3751-4D71-B1E9-2C13AA467683' 

--select b.Address1 
--from InsuranceApplicationRoleContactMechanism a
--inner join ContactMechanism b on (a.ContactMechanism_Id = b.Id)
--where a.InsuranceApplicationRole_Id = 'B3738D0E-3751-4D71-B1E9-2C13AA467683'

--select * from Party where Id = '1E4446D4-38E9-44D4-B7A9-53AA92770996'
--select * from CompanyRegistration where Organization_Id ='1E4446D4-38E9-44D4-B7A9-53AA92770996' and ThruDate is null

--============================== End Address   89  บริษัท สุโขทัย พี แอนด์ วาย มอเตอร์ จำกัด สำนักงานใหญ่ 0645547000170

Declare @Role_Id uniqueidentifier
Declare @InApppSource_Id uniqueidentifier
Declare @RoleTarget_Id uniqueidentifier = newId()
select @Role_Id=Id, @InApppSource_Id = InsuranceApplication_Id from #PartyRole 


--- Insert #PaymentRole
select * 
INTO #PaymentRole
from PaymentRole where Payment_Id = @PaymentId--@PaymentId


--Create #InsuranceApplicationRoleItem
select * 
INTO #InsuranceApplicationRoleItem
from InsuranceApplicationRoleItem 
where InsuranceApplicationRole_Id = @Role_Id

Declare @InsuranceApplicationItem_Id uniqueidentifier
Declare @InsuranceApplicationItemTarget_Id uniqueidentifier = newId()


select @InsuranceApplicationItem_Id=InsuranceApplicationItem_Id from #InsuranceApplicationRoleItem 


-- Insert InsuranceApplicationItem
select * 
INTO #InsuranceApplicationItem
from InsuranceApplicationItem where Id = @InsuranceApplicationItem_Id


-- Create #InsuranceApplicationRoleContactMechanism
select * 
INTO #InsuranceApplicationRoleContactMechanism
from InsuranceApplicationRoleContactMechanism where InsuranceApplicationRole_Id = @Role_Id




--select * from ContactMechanism where Id in ('5A80E6A2-33E8-4CBC-B2B0-CEA118B7728B','B235D906-23EA-4F40-9E16-E58C25F8AED6') --127
--select * from ContactMechanism where Id in ('4492C38A-595F-475D-8441-DFECBE613DB4','C743C63E-AE7F-4B35-852F-C174C261C99F') --180

-- Create #DependencyContextItem
select * 
INTO #DependencyContextItem
from DependencyContextItem where DependencyContextId = '123A53FD-886B-4E81-A4D8-31CB56CD373F' and DescriptionTH<> 'DTR.DataModel.Common.Party.PersonIdentityCard'

DECLARE @ComReg_Id uniqueidentifier
DECLARE @ComName_Id uniqueidentifier

select @ComReg_Id = Id from CompanyRegistration where Organization_Id = '955B59C8-0236-4007-B13C-7A37AD2E5EAE'and ThruDate is null and [Type_Id] = '4BA1E440-9EE7-461A-9400-DC25AE81177E' 
select @ComName_Id = Id from OrganizationName where Organization_Id = '955B59C8-0236-4007-B13C-7A37AD2E5EAE'and ThruDate is null



UPDATE #PartyRole
SET Id = @RoleTarget_Id,
InsuranceApplication_Id = @InsuranceApplication_Id

UPDATE #InsuranceApplicationItem
SET Id = @InsuranceApplicationItemTarget_Id

UPDATE #InsuranceApplicationRoleItem
SET Id = newId(),
	InsuranceApplicationItem_Id = @InsuranceApplicationItemTarget_Id,
	InsuranceApplicationRole_Id = @RoleTarget_Id

UPDATE #InsuranceApplicationRoleContactMechanism
SET Id = newId(),
	InsuranceApplicationRole_Id = @RoleTarget_Id	

UPDATE #DependencyContextItem
SET DependencyContextId = @InsuranceApplication_Id,
	DependencyContextItemId = @ComName_Id,
	Id = newId()
where Id = 'C96D0C66-5A38-421F-B9EA-78649FEAB238' --OrganizationName

UPDATE #DependencyContextItem
SET DependencyContextId = @InsuranceApplication_Id,
	DependencyContextItemId = @ComReg_Id,
	Id = newId()
where Id = 'FD4D04BC-AAE1-4626-A1E8-2CC6D645ADAC' --CompanyRegistration


UPDATE #PaymentRole
SET PartyRole_Id = @RoleTarget_Id,
	[Type_Id]    = a.[Type_Id],
	Party_Id = a.Party_Id,
	PartyClassificationTH_Id = c.Id,
	PartyClassificationEN_Id = d.Id,
	OrganizationName_Id = b.Id,
	CompanyRegistration_Id = f.Id,
	ContactMechanism_Id = g.ContactMechanism_Id
From PartyRole a 
left join OrganizationName b on (a.Party_Id = b.Organization_Id and b.ThruDate is NULL)
left join PartyClassification c on (a.Party_Id = c.Party_Id and c.SequencePartyType = 1 and c.Party_Id is not null)
left join PartyClassification d on (a.Party_Id = d.Party_Id and d.SequencePartyType = 2 and d.Party_Id is not null)
left join CompanyRegistration f on (a.Party_Id = f.Organization_Id and f.[Type_Id] = 'F8E30A8A-00DE-4A77-AD47-10CF35F923F4' and f.ThruDate is null) --�Ţ�����������
left join InsuranceApplicationRoleContactMechanism g on (a.Id = g.InsuranceApplicationRole_Id  and g.ShowOnPolicy = 1 and (g.ContactMechanismPurposeType_Id = '636B3BA8-9158-4AEE-A669-5B2F2D7DC5BB' or g.ContactMechanismPurposeType_Id = 'E3A26D7E-94C2-439F-9B8A-A644078304B2')) --�Ѵ�������/㺡ӡѺ����
left join DependencyContextItem j on (j.DependencyContextId = a.InsuranceApplication_Id and (f.Id = j.DependencyContextItemId))
where a.Id = @Role_Id 


--delete #DependencyContextItem
--INSERT INTO #DependencyContextItem
--SELECT * FROM DependencyContextItem where Id = '4E7D50F1-D340-4FCA-A6C8-B2C9F881158E'
--UPDATE #DependencyContextItem
--SET Id = newId(),
--	DependencyContextId = '4FE16BA3-256B-4BBB-9E57-6E9F4EDE0D91',
--	DependencyContextItemId = PersonName.Id,
--	DescriptionTH = 'DTR.DataModel.Common.Party.PersonName',
--	DescriptionEN = 'DTR.DataModel.Common.Party.PersonName'
--from PersonName 
--where Person_Id = '0275C86D-263C-4FA2-9E0C-A8A7D91423B5'

--from PersonName 
--where Person_Id = '0275C86D-263C-4FA2-9E0C-A8A7D91423B5'

--select * from PartyRole where InsuranceApplication_Id = '787D77EE-CE1D-40DA-A272-BA26812015E4'

BEGIN TRY
begin tran
	INSERT INTO PartyRole
	SELECT * FROM #PartyRole
	
	--SELECT * FROM  #PaymentRole
	--UNION
	SELECt * FROM PartyRole WHERE InsuranceApplication_Id = @InsuranceApplication_Id 
	IF @@ROWCOUNT != 6
		BEGIN
			ROLLBACK 
		END

		print 'insert InsuranceApplicationItem'
	INSERT INTO InsuranceApplicationItem
	SELECT * FROM #InsuranceApplicationItem
	IF @@ROWCOUNT != 1
		BEGIN
			ROLLBACK 
		END
		
		print 'insert InsuranceApplicationRoleItem'
	INSERT INTO InsuranceApplicationRoleItem
	SELECT * FROM #InsuranceApplicationRoleItem
	IF @@ROWCOUNT != 1
		BEGIN
			ROLLBACK 
		END
		
	SELECT * FROM #InsuranceApplicationRoleContactMechanism where InsuranceApplicationRole_Id = (select Id from #PartyRole)
		print 'insert InsuranceApplicationRoleContactMechanism'
	INSERT INTO InsuranceApplicationRoleContactMechanism
	SELECT * FROM #InsuranceApplicationRoleContactMechanism

	IF @@ROWCOUNT != 2
		BEGIN
			ROLLBACK 
		END
	
		print 'insert DependencyContextItem'
	INSERT INTO DependencyContextItem
	SELECT * FROM #DependencyContextItem
	IF @@ROWCOUNT != 2
		BEGIN
			ROLLBACK 
		END
	

	select * from #PaymentRole
	
		print 'insert PaymentRole'
	UPDATE PaymentRole
	SET PartyRole_Id = a.PartyRole_Id,
		[Type_Id]    = a.[Type_Id],
		Party_Id = a.Party_Id,
		PartyClassificationTH_Id = a.PartyClassificationTH_Id,
		PartyClassificationEN_Id = a.PartyClassificationEN_Id,
		OrganizationName_Id = a.OrganizationName_Id,
		CompanyRegistration_Id = a.CompanyRegistration_Id,
		ContactMechanism_Id = a.ContactMechanism_Id,
		PersonIdentification_Id = NULL,
		PersonName_Id = NULL
	From #PaymentRole a 
	WHERE PaymentRole.Id =a.Id --and PaymentRole.Id = '4199BD92-E30C-4278-B30B-07F2E90341E2'

	IF @@ROWCOUNT != 1
		BEGIN
			ROLLBACK 
		END
	
	select a.*,b.Address1
	from PaymentRole a
	inner join ContactMechanism b on (a.ContactMechanism_Id = b.Id)
	where PartyRole_Id = @RoleTarget_Id




	DECLARE @InsuredRoleItem_Id uniqueidentifier
	select @InsuredRoleItem_Id = Id from #InsuranceApplicationRoleItem
	
		print 'insert PolicyItemPremium'
	UPDATE PolicyItemPremium
	SET InsuranceApplicationRoleItem_Id = @InsuredRoleItem_Id,
		InsuranceApplicationItem_Id = @InsuranceApplicationItemTarget_Id
	WHERE PremiumSchedule_Id = @PremiumSchedule_Id

	DECLARE @InsuredRole_Id uniqueidentifier
	select @InsuredRole_Id = Id
	from PartyRole 
	where InsuranceApplication_Id = @InsuranceApplication_Id 
	and [Type_Id] = '1634B132-4285-4D54-87A9-6A3770A0AD2D'

	select * 
	from insuranceapplicationroleitem 
	where InsuranceApplicationRole_Id = @InsuredRole_Id
	
		print 'insert insuranceapplicationroleitem'
	update insuranceapplicationroleitem
	set ispayment = 0,
	paymentmethodtype_id = null,
	sequence = null
	where InsuranceApplicationRole_Id = @InsuredRole_Id and PaymentMethodType_Id is not null
	DECLARE @InAppItem_Id varchar(50)	
	DECLARE @InAppRoleItem_Id varchar(50)
	select @InAppRoleItem_Id = a.Id, @InAppItem_Id = b.Id
		from insuranceapplicationroleitem a
		inner join InsuranceApplicationItem b on (a.InsuranceApplicationItem_Id = b.Id)
		where InsuranceApplicationRole_Id =  @InsuredRole_Id
		and b.InsuranceApplicationItemType_Id is null

	
	delete from insuranceapplicationroleitem where Id = @InAppRoleItem_Id
	IF @@ROWCOUNT != 1
		BEGIN
			ROLLBACK 
		END
	delete from InsuranceApplicationItem where Id = @InAppItem_Id
	IF @@ROWCOUNT != 1
		BEGIN
			ROLLBACK 
		END

	print CONCAT('@InsuredRole_Id :',@InsuredRole_Id);
	select * 
	from insuranceapplicationroleitem 
	where InsuranceApplicationRole_Id = @InsuredRole_Id
	IF @@ROWCOUNT != 2
		BEGIN
			ROLLBACK 
		END
	

	UPDATE InsuranceApplicationRoleContactMechanism
	SET ShowOnPolicy = 1
	where InsuranceApplicationRole_Id = @InsuredRole_Id
	and ContactMechanismPurposeType_Id = 'E3A26D7E-94C2-439F-9B8A-A644078304B2'
	IF @@ROWCOUNT != 1
		BEGIN
			ROLLBACK 
		END

	select * 
	from InsuranceApplicationRoleContactMechanism
	where InsuranceApplicationRole_Id = @InsuredRole_Id
	and ContactMechanismPurposeType_Id = 'E3A26D7E-94C2-439F-9B8A-A644078304B2'
	IF @@ROWCOUNT != 1
		BEGIN
			ROLLBACK 
		END

	select d.ReferenceNumber, g.NameTH, h.RegistrationNumber, i.Address1
	from Agreement a
	left join PremiumSchedule b on (a.InsuranceApplication_Id = b.InsuranceApplication_Id)
	left join PaymentApplication c on (b.Id = c.PremiumSchedule_Id)
	left join Payment d on (c.Payment_Id = d.Id)
	left join PaymentRole f on (f.Payment_Id = d.Id)
	inner join OrganizationName g on (f.Party_Id = g.Organization_Id and g.ThruDate is null)
	inner join CompanyRegistration h on (f.CompanyRegistration_Id = h.Id and g.ThruDate is null )
	inner join ContactMechanism i on (f.ContactMechanism_Id = i.Id)
	where a.ReferenceNumber = @RefNo
--rollback
commit
END TRY
BEGIN CATCH
	 SELECT  
        ERROR_NUMBER() AS ErrorNumber  
        ,ERROR_SEVERITY() AS ErrorSeverity  
        ,ERROR_STATE() AS ErrorState  
        ,ERROR_PROCEDURE() AS ErrorProcedure  
        ,ERROR_MESSAGE() AS ErrorMessage;  
		  
    IF @@TRANCOUNT > 0
        ROLLBACK
END CATCH
--===============



--select * from #PaymentRole
--select * from ContactMechanism where Id = '982786FA-1E83-4F6A-99D2-93BD97B0D140'

DROP TABLE #DependencyContextItem
DROP TABLE #PartyRole
DROP TABLE #InsuranceApplicationItem
DROP TABLE #InsuranceApplicationRoleItem
DROP TABLE #InsuranceApplicationRoleContactMechanism
DROP TABLE #PaymentRole
DROP TABLE #RoleContactMechanismMap


--begin tran

--select * from PartyRole where InsuranceApplication_Id ='F6D2611F-5DE1-4E53-823E-44170A38E70D'
--select * from   PartyRole where Id ='3C1A149F-C1B4-47C9-B4FB-1EEAFDFEDE7C'
--select * from InsuranceApplicationRoleItem where InsuranceApplicationRole_Id = '3C1A149F-C1B4-47C9-B4FB-1EEAFDFEDE7C'
--select * from InsuranceApplicationItem where Id = '90754DCE-7197-40E7-B920-AAB66E592EFE'
--select * from PolicyItemPremium where InsuranceApplicationRoleItem_Id = 'A8A0A641-BED6-49BC-96C7-B34FFE11C01A'
--select * from PaymentApplication where PolicyItemPremium_Id = '691F7B7C-157A-44B1-B28D-DA22E8ECBBCC'
--select * from PaymentRole where PartyRole_Id = '3C1A149F-C1B4-47C9-B4FB-1EEAFDFEDE7C'
--select * from InsuranceApplicationRoleContactMechanism where InsuranceApplicationRole_Id = '3C1A149F-C1B4-47C9-B4FB-1EEAFDFEDE7C'

--delete  from InsuranceApplicationRoleContactMechanism where InsuranceApplicationRole_Id = '3C1A149F-C1B4-47C9-B4FB-1EEAFDFEDE7C'
--delete  from PaymentRole where Id = '66A21947-CE0F-4F88-A299-784A614EC00C'
--delete  from PaymentApplication where Id ='200D6844-97A2-40C6-B081-41B00C3D36E2'
--delete  from PolicyItemPremium where Id ='691F7B7C-157A-44B1-B28D-DA22E8ECBBCC'
--delete  from InsuranceApplicationRoleItem where Id ='A8A0A641-BED6-49BC-96C7-B34FFE11C01A'
--delete  from PartyRole where Id ='3C1A149F-C1B4-47C9-B4FB-1EEAFDFEDE7C'
--delete  from InsuranceApplicationItem where Id ='90754DCE-7197-40E7-B920-AAB66E592EFE'

--rollback
----commit


