Declare @RefNo varchar(50) = '17502/APP/000998-511'
DECLARE @yearAD varchar(3) = LEFT(@RefNo,2)
Declare @Subclass varchar(3) = RIGHT(@RefNo,3)
Declare @BranchCode varchar(3) = RIGHT(LEFT(@RefNo,5),3)
Declare @Type varchar(3) = RIGHT(LEFT(@RefNo,9),3)
Declare @BranchId uniqueidentifier
Declare @PolicyItemPremiumTarget_Id uniqueidentifier
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

DECLARE @PartyId varchar(100) = '955B59C8-0236-4007-B13C-7A37AD2E5EAE' 
--Create #PartyRole
select * 
INTO #PartyRole
from PartyRole 
where InsuranceApplication_Id = '9B4FD316-F481-415D-911B-DAAE4EDCDA05' 
and Party_Id = '955B59C8-0236-4007-B13C-7A37AD2E5EAE' --Address 180, 127, 19

select top 2 c.Id as ContactMechanism_Id, e.Id as ContactMechanismPurposeType_Id, c.Address1
INTO #RoleContactMechanismMap
from Party a
inner join PartyContactMechanism  b on (a.Id = b.Party_Id)
inner join ContactMechanism c on (b.ContactMechanism_Id = c.Id)
inner join PartyContactMechanismPurpose d on (b.Id = d.PartyContactMechanism_Id)
inner join ContactMechanismPurposeType e on (d.[Type_Id] = e.Id)
where a.Id = '955B59C8-0236-4007-B13C-7A37AD2E5EAE'  --Address  180
and c.Address1 like 'เลขที่ 180%'
order by c.CreatedDate DESC

--============================== End Address  180 สำนักงานใหญ่

select top 2 c.Id as ContactMechanism_Id, e.Id as ContactMechanismPurposeType_Id, c.Address1
--INTO #RoleContactMechanismMap
from Party a
inner join PartyContactMechanism  b on (a.Id = b.Party_Id)
inner join ContactMechanism c on (b.ContactMechanism_Id = c.Id)
inner join PartyContactMechanismPurpose d on (b.Id = d.PartyContactMechanism_Id)
inner join ContactMechanismPurposeType e on (d.[Type_Id] = e.Id)
where a.Id = '955B59C8-0236-4007-B13C-7A37AD2E5EAE'  --Address  127 สำนักงานใหญ่
and c.Address1 like 'เลขที่ 127%'
order by c.CreatedDate DESC

select * 
--INTO #PartyRole
from PartyRole 
where InsuranceApplication_Id = '25FE5515-E248-43EC-93A3-436EDBD4E7D6' 
and Party_Id = '955B59C8-0236-4007-B13C-7A37AD2E5EAE' --Address  127


--============================== End Address  127 สำนักงานใหญ่

select top 2 c.Id as ContactMechanism_Id, e.Id as ContactMechanismPurposeType_Id, c.Address1
--INTO #RoleContactMechanismMap
from Party a
inner join PartyContactMechanism  b on (a.Id = b.Party_Id)
inner join ContactMechanism c on (b.ContactMechanism_Id = c.Id)
inner join PartyContactMechanismPurpose d on (b.Id = d.PartyContactMechanism_Id)
inner join ContactMechanismPurposeType e on (d.[Type_Id] = e.Id)
where a.Id = 'E5802500-983B-4ECC-9DCF-ACF2159DBAD4' --Address  19 สำนักงานใหญ่
and c.Address1 like 'เลขที่ 19%'
order by c.CreatedDate DESC

select * 
--INTO #PartyRole
from PartyRole 
where InsuranceApplication_Id = 'B773D494-0BAB-4910-8352-D92F7F375F00'
and Party_Id = 'E5802500-983B-4ECC-9DCF-ACF2159DBAD4' --Address  19 สำนักงานใหญ่


--============================== End Address  19 สำนักงานใหญ่

select * 
--INTO #PartyRole
from PartyRole 
where InsuranceApplication_Id = '84CA745E-BDEC-4AAD-8C1B-7E28065622AD' 
and Party_Id = 'B297E7E4-BB49-4C3B-884F-33B33E5913D7' --Address   168  บริษัท (EN) อีซูซุพิษณุโลกฮกอันตึ๊ง  สาขาที่ 00001


--select * from Party where Id = 'D3069434-045D-478E-92DB-7FD81C6C2D8A'
--select top 1* from Party where DescriptionTH like 'บริษัท อีซูซุพิษณุโลกฮกอันตึ๊ง จำกัด สาขาสี่แยกอินโดจีน สาขาที่ 00001%'

select top 2 c.Id as ContactMechanism_Id, e.Id as ContactMechanismPurposeType_Id, a.DescriptionTH
--INTO #RoleContactMechanismMap
from Party a
inner join PartyContactMechanism  b on (a.Id = b.Party_Id)
inner join ContactMechanism c on (b.ContactMechanism_Id = c.Id)
left join PartyContactMechanismPurpose d on (b.Id = d.PartyContactMechanism_Id)
left join ContactMechanismPurposeType e on (d.[Type_Id] = e.Id)
where a.Id = 'B297E7E4-BB49-4C3B-884F-33B33E5913D7'  --Address  168 บริษัท (EN) อีซูซุพิษณุโลกฮกอันตึ๊ง  สาขาที่ 00001
and b.Id in ('60D42AA9-5A91-4988-BF0A-2E5DF84A435E')
order by c.CreatedDate DESC

--select * from OrganizationName where Organization_Id = 'FB575B38-7DB8-4C20-B577-E6599CE52F9C'
--select * from OrganizationName where NameTH like '%อีซูซุพิษณุโลกฮกอันตึ๊%' and ThruDate is null
--select * from Party where Id = 'B297E7E4-BB49-4C3B-884F-33B33E5913D7'

--UPDATE #PartyRole
--SET Party_Id = 'E5802500-983B-4ECC-9DCF-ACF2159DBAD4', 
--	DescriptionTH = a.DescriptionTH
--FROM #RoleContactMechanismMap a


--============================== End Address  19 บริษัท (EN) อีซูซุพิษณุโลกฮกอันตึ๊ง  สาขาที่ 00001


select top 2 c.Id as ContactMechanism_Id, e.Id as ContactMechanismPurposeType_Id, c.Address1
--INTO #RoleContactMechanismMap
from Party a
inner join PartyContactMechanism  b on (a.Id = b.Party_Id)
inner join ContactMechanism c on (b.ContactMechanism_Id = c.Id)
inner join PartyContactMechanismPurpose d on (b.Id = d.PartyContactMechanism_Id)
inner join ContactMechanismPurposeType e on (d.[Type_Id] = e.Id)
where a.Id = 'E8B4AC8D-58C0-4206-8A7F-45B3DED7C414'  --Address  206/4-8 สุโขทัยฮกอันตึ๊
order by c.CreatedDate DESC

select * 
--INTO #PartyRole
from PartyRole 
where InsuranceApplication_Id = '853D4FE8-9843-471F-9A0F-759B847B51C5' 
and Party_Id = 'E8B4AC8D-58C0-4206-8A7F-45B3DED7C414' --Address   206/4-8  สุโขทัยฮกอันตึ๊

select * from OrganizationName where Organization_Id = 'E8B4AC8D-58C0-4206-8A7F-45B3DED7C414'
--============================== End Address   206/4-8  สุโขทัยฮกอันตึ๊



select top 2 c.Id as ContactMechanism_Id, e.Id as ContactMechanismPurposeType_Id, c.Address1
--INTO #RoleContactMechanismMap
from Party a
inner join PartyContactMechanism  b on (a.Id = b.Party_Id)
inner join ContactMechanism c on (b.ContactMechanism_Id = c.Id)
inner join PartyContactMechanismPurpose d on (b.Id = d.PartyContactMechanism_Id)
inner join ContactMechanismPurposeType e on (d.[Type_Id] = e.Id)
where a.Id = 'D3069434-045D-478E-92DB-7FD81C6C2D8A'  --Address  168 อีซูซุตากฮกอันตึ๊ง
order by c.CreatedDate DESC

select * 
--INTO #PartyRole
from PartyRole 
where InsuranceApplication_Id = '871BC10B-E381-4A7F-B128-64F726A38F2C' 
and Party_Id = 'D3069434-045D-478E-92DB-7FD81C6C2D8A' --Address   168  อีซูซุตากฮกอันตึ๊ง

--select * from Party where DescriptionTH = 'บริษัท อีซูซุตากฮกอันตึ๊ง จำกัด สาขาแม่สอด สาขาที่ 00001'

--============================== End Address   168  อีซูซุตากฮกอันตึ๊ง
select * 
--INTO #PartyRole
from PartyRole 
where InsuranceApplication_Id = '1A3AC46D-C3D1-45AD-A1C9-FE1F7B842C48' 
and Party_Id = '418A4E21-F28B-4F1B-BC3A-93A365976C4B' --Address  16/12
--and DescriptionTH = 'บริษัท อีซูซุตากฮกอันตึ๊ง จำกัด สาขาแม่สอด สาขาที่ 00001'

select top 2 c.Id as ContactMechanism_Id, e.Id as ContactMechanismPurposeType_Id, c.Address1
--INTO #RoleContactMechanismMap
from Party a
inner join PartyContactMechanism  b on (a.Id = b.Party_Id)
inner join ContactMechanism c on (b.ContactMechanism_Id = c.Id)
inner join PartyContactMechanismPurpose d on (b.Id = d.PartyContactMechanism_Id)
inner join ContactMechanismPurposeType e on (d.[Type_Id] = e.Id)
where a.Id = '418A4E21-F28B-4F1B-BC3A-93A365976C4B'  --  --Address  16/12
order by c.CreatedDate DESC

--============================== End Address  19 สำนักงานใหญ่
select top 2 c.Id as ContactMechanism_Id, e.Id as ContactMechanismPurposeType_Id, c.Address1
I--NTO #RoleContactMechanismMap
from Party a
inner join PartyContactMechanism  b on (a.Id = b.Party_Id)
inner join ContactMechanism c on (b.ContactMechanism_Id = c.Id)
inner join PartyContactMechanismPurpose d on (b.Id = d.PartyContactMechanism_Id)
inner join ContactMechanismPurposeType e on (d.[Type_Id] = e.Id)
where a.Id = 'D3069434-045D-478E-92DB-7FD81C6C2D8A' --Address  127 ตาก
and c.Address1 like 'เลขที่ 127%'
order by c.CreatedDate DESC

--select * from Party where DescriptionTH like 'บริษัท อีซูซุตากฮกอันตึ๊ง จำกัด%'

select * 
--INTO #PartyRole
from PartyRole 
where InsuranceApplication_Id = 'FD6B2AFD-97D3-4F9F-AB5E-BBD7C13D7B01' 
and Party_Id = 'D3069434-045D-478E-92DB-7FD81C6C2D8A' --Address  16/12
--and DescriptionTH like '%บริษัท อีซูซุตากฮกอันตึ๊ง จำกัด%'

--select * 
----INTO #PartyRole
--from PartyRole 
--where InsuranceApplication_Id = 'B773D494-0BAB-4910-8352-D92F7F375F00'
--and Party_Id = 'E5802500-983B-4ECC-9DCF-ACF2159DBAD4' --Address    127 ตาก


--============================== End Address  19 สำนักงานใหญ่
--select * from Party where Id ='418A4E21-F28B-4F1B-BC3A-93A365976C4B'

--select * 
--INTO #PartyRole
--from PartyRole 
--where InsuranceApplication_Id = 'EDE39B86-A953-48A7-94D9-E7C9254A6739' 
--and Party_Id = 'E11E642E-D6D8-4C60-9310-447D5ED33E24'  --Address 180, 16/12

--select * from #PartyRole

Declare @Role_Id uniqueidentifier
Declare @InApppSource_Id uniqueidentifier
Declare @RoleTarget_Id uniqueidentifier = newId()
select @Role_Id=Id, @InApppSource_Id = InsuranceApplication_Id from #PartyRole 

select * from Party where Id = '955B59C8-0236-4007-B13C-7A37AD2E5EAE'


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
left join CompanyRegistration f on (a.Party_Id = f.Organization_Id and f.[Type_Id] = 'F8E30A8A-00DE-4A77-AD47-10CF35F923F4') --�Ţ�����������
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

begin tran
	INSERT INTO PartyRole
	SELECT * FROM #PartyRole
	--SELECT * FROM  #PaymentRole
	--UNION
	SELECt * FROM PartyRole WHERE InsuranceApplication_Id = '787D77EE-CE1D-40DA-A272-BA26812015E4'
	IF @@ROWCOUNT != 6
		BEGIN
			ROLLBACK 
		END

	INSERT INTO InsuranceApplicationItem
	SELECT * FROM #InsuranceApplicationItem

	INSERT INTO InsuranceApplicationRoleItem
	SELECT * FROM #InsuranceApplicationRoleItem

	INSERT INTO InsuranceApplicationRoleContactMechanism
	SELECT * FROM #InsuranceApplicationRoleContactMechanism
	
	INSERT INTO DependencyContextItem
	SELECT * FROM #DependencyContextItem

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

	
	UPDATE PaymentRole
	SET 
		[Type_Id]    = a.[Type_Id],
		Party_Id = a.Party_Id,
		PartyClassificationTH_Id = c.Id,
		PartyClassificationEN_Id = d.Id,
		OrganizationName_Id = b.Id,
		CompanyRegistration_Id = f.Id,
		ContactMechanism_Id = g.ContactMechanism_Id,
		PersonIdentification_Id = NULL,
		PersonName_Id = NULL
	From PartyRole a 
left join OrganizationName b on (a.Party_Id = b.Organization_Id and b.ThruDate is NULL)
left join PartyClassification c on (a.Party_Id = c.Party_Id and c.SequencePartyType = 1 and c.Party_Id is not null)
left join PartyClassification d on (a.Party_Id = d.Party_Id and d.SequencePartyType = 2 and d.Party_Id is not null)
left join CompanyRegistration f on (a.Party_Id = f.Organization_Id and f.[Type_Id] = 'F8E30A8A-00DE-4A77-AD47-10CF35F923F4' and f.ThruDate is null) --�Ţ�����������
left join InsuranceApplicationRoleContactMechanism g on (a.Id = g.InsuranceApplicationRole_Id  and g.ShowOnPolicy = 1 and (g.ContactMechanismPurposeType_Id = '636B3BA8-9158-4AEE-A669-5B2F2D7DC5BB' or g.ContactMechanismPurposeType_Id = 'E3A26D7E-94C2-439F-9B8A-A644078304B2')) --�Ѵ�������/㺡ӡѺ����
left join DependencyContextItem j on (j.DependencyContextId = a.InsuranceApplication_Id and (f.Id = j.DependencyContextItemId))
where a.Id =  '3FC013CC-30F2-4AF9-BCBA-AD54DDE8463C'
and PaymentRole.PartyRole_Id = a.Id


	DECLARE @InsuredRoleItem_Id uniqueidentifier
	select @InsuredRoleItem_Id = Id from #InsuranceApplicationRoleItem

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
	
	update insuranceapplicationroleitem
	set ispayment = 0,
	paymentmethodtype_id = null,
	sequence = null
	where InsuranceApplicationRole_Id = @InsuredRole_Id and PaymentMethodType_Id is not null


	select * 
	from insuranceapplicationroleitem 
	where InsuranceApplicationRole_Id = @InsuredRole_Id

	

	UPDATE InsuranceApplicationRoleContactMechanism
	SET ShowOnPolicy = 1
	where InsuranceApplicationRole_Id = @InsuredRole_Id
	and ContactMechanismPurposeType_Id = 'E3A26D7E-94C2-439F-9B8A-A644078304B2'

	select * 
	from InsuranceApplicationRoleContactMechanism
	where InsuranceApplicationRole_Id = @InsuredRole_Id
	and ContactMechanismPurposeType_Id = 'E3A26D7E-94C2-439F-9B8A-A644078304B2'

rollback
--commit

--===============

DROP TABLE #DependencyContextItem
DROP TABLE #PartyRole
DROP TABLE #InsuranceApplicationItem
DROP TABLE #InsuranceApplicationRoleItem
DROP TABLE #InsuranceApplicationRoleContactMechanism
DROP TABLE #PaymentRole
DROP TABLE #RoleContactMechanismMap

/*
select [Type_Id],* from CompanyRegistration where Organization_Id = '955B59C8-0236-4007-B13C-7A37AD2E5EAE'and ThruDate is null and [Type_Id] = '4BA1E440-9EE7-461A-9400-DC25AE81177E' 
select * from OrganizationName where Organization_Id = '955B59C8-0236-4007-B13C-7A37AD2E5EAE'and ThruDate is null

select [Type_Id],* from CompanyRegistration where Id = '9F432C18-FDB5-4325-B7C1-E110470E31E0'
select [Type_Id],* from CompanyRegistration where  Organization_Id = 'E11E642E-D6D8-4C60-9310-447D5ED33E24'and ThruDate is null and [Type_Id] = 'F8E30A8A-00DE-4A77-AD47-10CF35F923F4' 
select [Type_Id],* from CompanyRegistration where Organization_Id = '955B59C8-0236-4007-B13C-7A37AD2E5EAE'and ThruDate is null and [Type_Id] = 'F8E30A8A-00DE-4A77-AD47-10CF35F923F4' 

select * from OrganizationName where Id = '6602EF19-3499-4E0B-BBC0-A55423648117'
select * from OrganizationName where Id = '0A42084E-41A9-4BBE-A2FB-467A57494239'

select * from OrganizationName where Organization_Id = '955B59C8-0236-4007-B13C-7A37AD2E5EAE'and ThruDate is null
select * from OrganizationName where Organization_Id = 'E11E642E-D6D8-4C60-9310-447D5ED33E24'and ThruDate is null
select * from Party where Id = 'E11E642E-D6D8-4C60-9310-447D5ED33E24'
select * from Party where Id = '955B59C8-0236-4007-B13C-7A37AD2E5EAE'
select * from CompanyRegistrationType where Id in ('F8E30A8A-00DE-4A77-AD47-10CF35F923F4','CA3BEEE9-ECB3-464C-9AA2-47A1B11DC4F6','4BA1E440-9EE7-461A-9400-DC25AE81177E')
*/

SELECT b.*
FROM Agreement a 
INNER JOIN PartyRole b on (a.InsuranceApplication_Id = b.InsuranceApplication_Id)
where a.ReferenceNumber = '' 



SELECT b.*
FROM Agreement a 
INNER JOIN PartyRole b on (a.InsuranceApplication_Id = b.InsuranceApplication_Id)
where a.ReferenceNumber = '' 

--====== 

SELECT  a.DescriptionTH,b.*
FROM PartyRole a 
INNER JOIN InsuranceApplicationRoleContactMechanism b on (a.Id = b.InsuranceApplicationRole_Id)
WHERE a.InsuranceApplication_Id = '74FA73D3-A20D-4AAA-ABDF-F4AF46559B5E'

SELECT a.DescriptionTH,a.*,b.*
FROM PartyRole a 
INNER JOIN InsuranceApplicationRoleContactMechanism b on (a.Id = b.InsuranceApplicationRole_Id)
WHERE a.InsuranceApplication_Id = '4FE16BA3-256B-4BBB-9E57-6E9F4EDE0D91'
--=======
select * from PartyRole where InsuranceApplication_Id = '787D77EE-CE1D-40DA-A272-BA26812015E4'
SELECT a.*
FROM InsuranceApplicationRoleItem a
INNER JOIN InsuranceApplicationItem b on (a.InsuranceApplicationItem_Id = b.Id)
where a.InsuranceApplicationRole_Id in ('B43275A8-C675-43C4-A0CF-CC8DBE1EFE77','E3DAA6BA-9613-41D7-8BF7-C6815E521F34')


SELECT a.*
FROM InsuranceApplicationRoleItem a
INNER JOIN InsuranceApplicationItem b on (a.InsuranceApplicationItem_Id = b.Id)
where a.InsuranceApplicationRole_Id in ('','')

---===
SELECT InsuranceApplicationRoleItem_Id,InsuranceApplicationItem_Id,*
FROM PolicyItemPremium a
INNER JOIN PremiumSchedule b on (a.PremiumSchedule_Id = b.Id)
where InsuranceApplication_Id = ''


SELECT InsuranceApplicationRoleItem_Id,InsuranceApplicationItem_Id,*
FROM PolicyItemPremium a
INNER JOIN PremiumSchedule b on (a.PremiumSchedule_Id = b.Id)
where InsuranceApplication_Id = ''

SELECT InsuranceApplicationRoleItem_Id,InsuranceApplicationItem_Id,*
FROM PolicyItemPremium a
where a.PremiumSchedule_Id = '96B5F7A3-1278-4EFD-A727-D50424898DB5'

select * from InsuranceApplicationRoleItem where InsuranceApplicationRole_Id = '55C332F8-E717-464E-B869-0437CE15A967'
