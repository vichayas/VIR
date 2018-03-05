

Declare @RefNo varchar(50) = '18502/APP/000390-511'
DECLARE @yearAD varchar(3) = LEFT(@RefNo,2)
Declare @Subclass varchar(3) = RIGHT(@RefNo,3)
Declare @BranchCode varchar(3) = RIGHT(LEFT(@RefNo,5),3)
Declare @Type varchar(3) = RIGHT(LEFT(@RefNo,9),3)
Declare @BranchId uniqueidentifier
Declare @PremiumSchedule_Id uniqueidentifier
Declare @PolicyItemPremiumTarget_Id uniqueidentifier

print @Type
print @BranchCode
print @yearAD
print @Subclass



DECLARE @PaymentRoleId varchar(50)
select 
@PaymentRoleId = f.Id
from Agreement a
left join PremiumSchedule b on (a.InsuranceApplication_Id = b.InsuranceApplication_Id)
left join PolicyItemPremium k on (b.Id = k.PremiumSchedule_Id)
left join PaymentApplication c on (b.Id = c.PremiumSchedule_Id)
left join Payment d on (c.Payment_Id = d.Id)
left join PaymentRole f on (f.Payment_Id = d.Id)
left join PolicyItemPremium e on (b.Id = e.PremiumSchedule_Id)
left join CompanyRegistration comReg on (f.CompanyRegistration_Id = comReg.Id)
where a.ReferenceNumber = @RefNo 



UPDATE PaymentRole
SET PartyRole_Id = '9686EAF0-1570-4BE0-BF0D-28BCC559CF7B',
	[Type_Id]    = a.[Type_Id],
	Party_Id = a.Party_Id,
	PartyClassificationTH_Id = c.Id,
	PartyClassificationEN_Id = d.Id,
	OrganizationName_Id = b.Id,
	CompanyRegistration_Id = f.Id,
	ContactMechanism_Id = g.ContactMechanism_Id
From PartyRole a 
left join OrganizationName b on (a.Party_Id = b.Organization_Id and b.ThruDate is NULL)
left join PartyClassification c on (a.Party_Id = c.Party_Id and c.SequencePartyType = 1 and c.Party_Id is not null and c.ThruDate is not null)
left join PartyClassification d on (a.Party_Id = d.Party_Id and d.SequencePartyType = 2 and d.Party_Id is not null and d.ThruDate is not null)
left join CompanyRegistration f on (a.Party_Id = f.Organization_Id and f.[Type_Id] = 'F8E30A8A-00DE-4A77-AD47-10CF35F923F4' and f.ThruDate is null) --�Ţ�����������
left join InsuranceApplicationRoleContactMechanism g on (a.Id = g.InsuranceApplicationRole_Id  and g.ShowOnPolicy = 1 and (g.ContactMechanismPurposeType_Id = '636B3BA8-9158-4AEE-A669-5B2F2D7DC5BB' or g.ContactMechanismPurposeType_Id = 'E3A26D7E-94C2-439F-9B8A-A644078304B2')) --�Ѵ�������/㺡ӡѺ����
left join DependencyContextItem j on (j.DependencyContextId = a.InsuranceApplication_Id and (f.Id = j.DependencyContextItemId))
where a.Id = '9686EAF0-1570-4BE0-BF0D-28BCC559CF7B' 
and PaymentRole.Id = @PaymentRoleId

select a.Id as AgreementId,comReg.RegistrationNumber,p.CurrentNameTH,a.InsuranceApplication_Id, b.Id as PremiumScheduleId, c.Id as PaymentApplication, 
d.ReferenceNumber, d.Id as PaymentId, d.Discriminator,
f.Id as PaymentRole_Id, e.Id as PolicyItemPremiumId,
k.Id as PolicyItemPremium_Id,comReg.RegistrationNumber
from Agreement a
left join PremiumSchedule b on (a.InsuranceApplication_Id = b.InsuranceApplication_Id)
left join PolicyItemPremium k on (b.Id = k.PremiumSchedule_Id)
left join PaymentApplication c on (b.Id = c.PremiumSchedule_Id)
left join Payment d on (c.Payment_Id = d.Id)
left join PaymentRole f on (f.Payment_Id = d.Id)
left join PolicyItemPremium e on (b.Id = e.PremiumSchedule_Id)
left join CompanyRegistration comReg on (f.CompanyRegistration_Id = comReg.Id)
left join Party p on (f.Party_Id = p.Id)
where a.ReferenceNumber = @RefNo 

