Declare @RefNo varchar(50) = '17502/APP/000995-511'
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
print @PremiumSchedule_Id

print @InsuranceApplication_Id
select * from PaymentRole where Id =@PaymentRole_Id

select b.DescriptionTH, c.NameTH, e.Address1, a.Id, b.Id,c.Id,D.id,e.Id
from PaymentRole a
left join Party b on (b.Id = a.Party_Id)
left join OrganizationName c on (c.Organization_Id = a.Party_Id and c.ThruDate is null)
left join DependencyContextItem d on (d.DependencyContextItemId = c.Id)
left join ContactMechanism e on (e.Id = a.ContactMechanism_Id)
where a.Id = @PaymentRole_Id  and d.DependencyContextId = @InsuranceApplication_Id

select * 
from DependencyContextItem
where DependencyContextId = '853D4FE8-9843-471F-9A0F-759B847B51C5'

UPDATE DependencyContextItem
SET DependencyContextItemId = 'FF9B3740-3FD1-44F8-82D1-616DC2794242' --Regis
WHERE Id = 'BBD292E4-51DE-4C40-B40D-6A4AE7807160'
UPDATE DependencyContextItem
SET DependencyContextItemId = '254CDB4A-088F-4375-A534-1C7193F8D365' --Name
WHERE Id = '8CA5FC97-A112-49D2-A61D-CE1DF126CFDE'

UPDATE PaymentRole
SET PartyClassificationTH_Id = 'F974D1E9-6F2A-494E-BF49-E1FDFDB71937',
	PartyClassificationEN_Id = 'F974D1E9-6F2A-494E-BF49-E1FDFDB71937'
WHERE Id = @PaymentRole_Id


select PartyClassificationTH_Id,PartyClassificationEN_Id,* from PaymentRole where Id = @PaymentRole_Id



--UPDATE PaymentRole
--SET PartyRole_Id = 'B43275A8-C675-43C4-A0CF-CC8DBE1EFE77'
--WHERE Id = '4199BD92-E30C-4278-B30B-07F2E90341E2'
--===== ตาก แม่สอด
select * from PartyRole where InsuranceApplication_Id = '06390EFB-68DC-45E0-AFCA-6EC4FF2EF162'
select * from Party where Id = '418A4E21-F28B-4F1B-BC3A-93A365976C4B'
select * from OrganizationName where Organization_Id = '418A4E21-F28B-4F1B-BC3A-93A365976C4B'
select * from OrganizationName where NameEN like '%อีซูซุตากฮกอันตึ๊ง%'

UPDATE OrganizationName
SET NameTH = 'อีซูซุตากฮกอันตึ๊ง จำกัด (สาขาแม่สอด)',
	NameEN = 'อีซูซุตากฮกอันตึ๊ง จำกัด (สาขาแม่สอด)'
WHERE Id = '24D40654-65DB-49EF-998F-AFD9D363850E'

select * from PartyClassification where Party_Id = '418A4E21-F28B-4F1B-BC3A-93A365976C4B'
select * from PartyType where Id in ('42C2835A-AD94-413F-B9AF-052958EF79E5','A21DB751-1867-460D-A2D5-DA1717B3348F')
select * from Part
--===== สุโขไทย 00002
select * from PartyRole where InsuranceApplication_Id = '853D4FE8-9843-471F-9A0F-759B847B51C5'
select * from Party where Id = 'E8B4AC8D-58C0-4206-8A7F-45B3DED7C414'
select b.ReferenceNumber, a.*
from PartyRole a
inner join Agreement b on (a.InsuranceApplication_Id = b.InsuranceApplication_Id)
where Party_Id = '7D8967DC-27BB-41C3-BF1C-8A70E5834022' and b.Discriminator = 'InsurancePolicy'
order by b.ReferenceNumber
--Organisation 635257F0-E16A-48A8-A300-7EE7D688710D
--Register E08CCB78-4946-4E90-990B-21BE7E53A60A
--Classification A21DB751-1867-460D-A2D5-DA1717B3348F

--UPDATE PaymentRole
--SET Party_Id = '7D8967DC-27BB-41C3-BF1C-8A70E5834022',
--	OrganizationName_Id = '635257F0-E16A-48A8-A300-7EE7D688710D',
--	CompanyRegistration_Id = 'E08CCB78-4946-4E90-990B-21BE7E53A60A',
--	PartyClassificationTH_Id = '22098931-879D-40BE-8632-1959BDBB159D',
--	PartyClassificationEN_Id = '22098931-879D-40BE-8632-1959BDBB159D'
--WHERE PartyRole_Id in ('E6EDF1A4-7BF5-4D8B-9568-706C27209615',
--			'3216C1F5-864C-45AC-A51B-51F7BC8EE590',
--			'178A9023-876E-4512-BBA8-2A23D1E9BA7A',
--			'AAD42DCA-3FA3-4CDA-AD38-1515E7D4E2C2')


select *
FROM PaymentRole
WHERE PartyRole_Id in ('E6EDF1A4-7BF5-4D8B-9568-706C27209615',
			'3216C1F5-864C-45AC-A51B-51F7BC8EE590',
			'178A9023-876E-4512-BBA8-2A23D1E9BA7A',
			'AAD42DCA-3FA3-4CDA-AD38-1515E7D4E2C2')

--UPDATE PartyRole
--SET Party_Id = '7D8967DC-27BB-41C3-BF1C-8A70E5834022'
--WHERE Id in ('E6EDF1A4-7BF5-4D8B-9568-706C27209615',
--			'3216C1F5-864C-45AC-A51B-51F7BC8EE590',
--			'178A9023-876E-4512-BBA8-2A23D1E9BA7A',
--			'AAD42DCA-3FA3-4CDA-AD38-1515E7D4E2C2')
select * from CompanyRegistration where Organization_Id = '7D8967DC-27BB-41C3-BF1C-8A70E5834022'
select * from OrganizationName where Organization_Id = '7D8967DC-27BB-41C3-BF1C-8A70E5834022'
select * from OrganizationName where NameEN like '%สุโขทัยฮกอันตึ๊ง (1978)%' and ThruDate is NULL
select * from PartyClassification where Party_Id = '7D8967DC-27BB-41C3-BF1C-8A70E5834022'
select * from PartyType where Id in ('A21DB751-1867-460D-A2D5-DA1717B3348F','CEBAC138-BE95-42E8-842E-838417445BC9')


--====== พิษณุโลก


select * from PartyRole where InsuranceApplication_Id = '84CA745E-BDEC-4AAD-8C1B-7E28065622AD'
select * from Party where Id = '955B59C8-0236-4007-B13C-7A37AD2E5EAE'
select * from CompanyRegistration where Organization_Id = 'B297E7E4-BB49-4C3B-884F-33B33E5913D7'
select * from OrganizationName where Organization_Id = 'B297E7E4-BB49-4C3B-884F-33B33E5913D7'
select * from OrganizationName where NameEN like '%อีซูซุพิษณุโลกฮกอันตึ๊ง%' and ThruDate is NULL
select * from PartyClassification where Party_Id = 'B297E7E4-BB49-4C3B-884F-33B33E5913D7'
select * from PartyType where Id in ('9F117FAD-07F9-468A-BC2B-13353FA07212','42C2835A-AD94-413F-B9AF-052958EF79E5')

select * from PaymentRole where Id = 'B00FD252-C3ED-4455-8E67-928B579939BB' --1000 
select * from PaymentRole where Id = '3E82A67D-D597-4D78-ACEA-C33497A32DB0' --999
select * from PaymentRole where Id = '08E55846-5BE2-4379-B251-5414BF6CA4D5'--995
select * from CompanyRegistration where Organization_Id = '955B59C8-0236-4007-B13C-7A37AD2E5EAE' and ThruDate is null

--UPDATE PaymentRole
--SET CompanyRegistration_Id = '68A0C48F-25AF-4884-94FD-75FC8680AE36'
-- where Id = 'B00FD252-C3ED-4455-8E67-928B579939BB' 

 
--UPDATE PaymentRole
--SET CompanyRegistration_Id = '68A0C48F-25AF-4884-94FD-75FC8680AE36'
-- where Id = '3E82A67D-D597-4D78-ACEA-C33497A32DB0' 

select * from OrganizationName where Id = '91CB1516-6596-401C-B18F-E4EEB1761EF3'
--UPDATE PaymentRole
--SET OrganizationName_Id = '91CB1516-6596-401C-B18F-E4EEB1761EF3',
--	ContactMechanism_Id = '4492C38A-595F-475D-8441-DFECBE613DB4'
-- where Id = 'B00FD252-C3ED-4455-8E67-928B579939BB' 

--NameTH	NameEN
--อีซูซุพิษณุโลกฮกอันตึ๊ง จำกัด	อีซูซุพิษณุโลกฮกอันตึ๊ง จำกัด 
UPDATE OrganizationName
SET NameTH = 'อีซูซุพิษณุโลกฮกอันตึ๊ง จำกัด (สาขาสี่แยกอินโดจีน)',
	NameEN = 'อีซูซุพิษณุโลกฮกอันตึ๊ง จำกัด (สาขาสี่แยกอินโดจีน)'
WHERE Id = 'A3D0DBC0-B57B-49F1-9A9C-A7D2ACBC4F6E'

-- อุตรดิตย์ 
select * from PartyRole where InsuranceApplication_Id = '84CA745E-BDEC-4AAD-8C1B-7E28065622AD'
select * from Party where Id = 'B297E7E4-BB49-4C3B-884F-33B33E5913D7'

select * from PartyRole where Party_Id =  'B297E7E4-BB49-4C3B-884F-33B33E5913D7'


select * from Agreement where InsuranceApplication_Id = '57AE5852-E38C-4AA1-A32F-45722CB3B3FB'
select * from Agreement where ReferenceNumber = '17502/POL/001004-511'
select * from Agreement where ReferenceNumber = '17502/POL/001005-511'
select * from Agreement where ReferenceNumber = '17502/POL/001010-511'
select * from Agreement where ReferenceNumber = '17502/POL/001034-511'
select * from Agreement where ReferenceNumber = '17502/POL/001036-511'
select * from Agreement where ReferenceNumber = '17502/POL/001048-511'
select * from InsuranceApplicationRoleItem where InsuranceApplicationRole_Id = 'EAF9EE80-343C-45E5-96B9-C66BEAF1421F'
select * from InsuranceApplicationRoleContactMechanism where InsuranceApplicationRole_Id = 'EAF9EE80-343C-45E5-96B9-C66BEAF1421F'
/*
print @AgreementId
UPDATE PartyRole
SET Party_Id = 'E6EDF1A4-7BF5-4D8B-9568-706C27209615'
WHERE Id = 'A7259B95-612A-4BDF-9723-C40FE7B81291'

--select * from OrganizationName where Organization_Id = 'E5802500-983B-4ECC-9DCF-ACF2159DBAD4'

UPDATE PaymentRole
SET Party_Id =  'E8B4AC8D-58C0-4206-8A7F-45B3DED7C414',
PartyRole_Id = 'E6EDF1A4-7BF5-4D8B-9568-706C27209615'
WHERE Id = 'A7259B95-612A-4BDF-9723-C40FE7B81291'

select * 
from DependencyContextItem
where DependencyContextId = '853D4FE8-9843-471F-9A0F-759B847B51C5'

UPDATE DependencyContextItem
SET DependencyContextItemId = 'FF9B3740-3FD1-44F8-82D1-616DC2794242' --Regis
WHERE Id = 'BBD292E4-51DE-4C40-B40D-6A4AE7807160'
UPDATE DependencyContextItem
SET DependencyContextItemId = '254CDB4A-088F-4375-A534-1C7193F8D365' --Name
WHERE Id = '8CA5FC97-A112-49D2-A61D-CE1DF126CFDE'
 
select b.DescriptionTH, c.NameTH
from PaymentRole a
inner join Party b on (b.Id = a.Party_Id)
inner join OrganizationName c on (c.Organization_Id = a.Party_Id)
inner join DependencyContextItem d on (d.DependencyContextItemId = c.Id)
where a.Id = 'DE71BE98-8A8F-4D2D-A8A8-77DD8F4062C2'

select
	a.[Type_Id],
	 a.Party_Id,
	c.Id,
	 d.Id,
	b.Id,
	f.Id,
	g.ContactMechanism_Id
From PartyRole a 
left join OrganizationName b on (a.Party_Id = b.Organization_Id and b.ThruDate is NULL)
left join PartyClassification c on (a.Party_Id = c.Party_Id and c.SequencePartyType = 1 and c.Party_Id is not null)
left join PartyClassification d on (a.Party_Id = d.Party_Id and d.SequencePartyType = 2 and d.Party_Id is not null)
left join CompanyRegistration f on (a.Party_Id = f.Organization_Id and f.[Type_Id] = 'F8E30A8A-00DE-4A77-AD47-10CF35F923F4') --�Ţ�����������
left join InsuranceApplicationRoleContactMechanism g on (a.Id = g.InsuranceApplicationRole_Id  and g.ShowOnPolicy = 1 and (g.ContactMechanismPurposeType_Id = '636B3BA8-9158-4AEE-A669-5B2F2D7DC5BB' or g.ContactMechanismPurposeType_Id = 'E3A26D7E-94C2-439F-9B8A-A644078304B2')) --�Ѵ�������/㺡ӡѺ����
left join DependencyContextItem j on (j.DependencyContextId = a.InsuranceApplication_Id and (f.Id = j.DependencyContextItemId))
where a.Id = '6C79DDE7-5C80-4285-9D0D-9F487E6CAF11'



select * from PaymentRole where Id = '2D1643ED-EEFE-4B63-BE4B-342861B5F840'


select * from Agreement where ReferenceNumber = '17502/POL/000995-511'
select * from Agreement where InsuranceApplication_Id = '44C2F6D4-9A4A-4A9D-BC92-0585FA6681AB'  
select * 
from DependencyContextItem
where DependencyContextId = '44C2F6D4-9A4A-4A9D-BC92-0585FA6681AB' 
select * 
from DependencyContextItem
where DependencyContextId =  '787D77EE-CE1D-40DA-A272-BA26812015E4'

--select *
--INTO #DependencyContextItem
--from DependencyContextItem
--where Id = '11684176-2CF8-499F-82A7-DE478E9814B1'

--UPDATE #DependencyContextItem
--SET DependencyContextId = '4FE16BA3-256B-4BBB-9E57-6E9F4EDE0D91' ,
--	Id = newId()

--INSERT INTO DependencyContextItem
--SELECT * FROM #DependencyContextItem

select a.Id,a.Party_Id,a.DescriptionTH,c.* from PartyRole a
inner join InsuranceApplicationRoleItem b on (a.Id = b.InsuranceApplicationRole_Id)
inner join InsuranceApplicationRoleContactMechanism c on (c.InsuranceApplicationRole_Id = a.Id)
where InsuranceApplication_Id = '4FE16BA3-256B-4BBB-9E57-6E9F4EDE0D91'
and Type_Id in ( '1E283A60-C34A-4CE5-AA05-BA79F89B7174', '1634B132-4285-4D54-87A9-6A3770A0AD2D')


select a.Id,a.Party_Id,a.DescriptionTH,b.InsuranceApplicationItem_Id,c.* from PartyRole a
inner join InsuranceApplicationRoleItem b on (a.Id = b.InsuranceApplicationRole_Id)
inner join InsuranceApplicationRoleContactMechanism c on (c.InsuranceApplicationRole_Id = a.Id)
where InsuranceApplication_Id = '787D77EE-CE1D-40DA-A272-BA26812015E4'
and Type_Id in ( '1E283A60-C34A-4CE5-AA05-BA79F89B7174', '1634B132-4285-4D54-87A9-6A3770A0AD2D')

select * 
from DependencyContextItem
where DependencyContextId = '4FE16BA3-256B-4BBB-9E57-6E9F4EDE0D91'

select * from Party where Id = '955B59C8-0236-4007-B13C-7A37AD2E5EAE'
select * from ContactMechanism where Id = '4492C38A-595F-475D-8441-DFECBE613DB4'
select * from PartyRole where InsuranceApplication_Id = '4FE16BA3-256B-4BBB-9E57-6E9F4EDE0D91'
select * from InsuranceApplicationRoleContactMechanism where InsuranceApplicationRole_Id = '56EDDA5A-3F04-41D6-A400-703E53A17E49'
select * from PartyRole where Id =  '56EDDA5A-3F04-41D6-A400-703E53A17E49'
select * from ContactMechanism where Id in ('89825E40-5B01-4F33-BC68-B70C5BE6C086','461170AD-82F9-4F9B-866C-FFF4D788A72D')

SELECT *
INTO #RoleMacanism
FROM InsuranceApplicationRoleContactMechanism
WHERE Id = '42987DD1-F1AE-446C-BEC3-E1DD75896506'

UPDATE #RoleMacanism
SET Id = newId(),
	InsuranceApplicationRole_Id = '55C332F8-E717-464E-B869-0437CE15A967'

--INSERT INTO InsuranceApplicationRoleContactMechanism
--SELECT * FROM #RoleMacanism

UPDATE InsuranceApplicationRoleContactMechanism
SET ContactMechanism_Id = '7BEF0AA5-406E-45C7-A7FE-8293D75F8429'
WHERE Id =  '4987F047-C6DA-44F4-9496-716B00D3E6A8'

select * from PartyRole where Id = 'E3DAA6BA-9613-41D7-8BF7-C6815E521F34'

UPDATE PartyRole
SET IsVatPerson = 0
WHERE Id = 'E3DAA6BA-9613-41D7-8BF7-C6815E521F34'

--select * from ContactMechanismPurposeType where Id = '636B3BA8-9158-4AEE-A669-5B2F2D7DC5BB'


update insuranceapplicationroleitem
set ispayment = 0,
paymentmethodtype_id = null,
sequence = null
where id = 'CCD34153-8173-4D65-8CD8-62D5EF910ED6'



UPDATE InsuranceApplicationRoleContactMechanism
SET ShowOnPolicy = 1
WHERE Id = '42987DD1-F1AE-446C-BEC3-E1DD75896506'




*/