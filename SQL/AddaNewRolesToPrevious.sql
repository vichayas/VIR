select * from Agreement where ReferenceNumber = '18181/END/000008-520'
select * 
from PartyRole 
where InsuranceApplication_Id = 'D5DED73D-E058-464D-AF6C-A8BC360DAC11' and -- Endorse
Party_Id is not null and
[Type_Id] is not null 

---================== Insurpolicy

select * from Agreement where ReferenceNumber = '18181/POL/000005-520'
select * 
from PartyRole 
where InsuranceApplication_Id = 'DCAB27EB-C824-456E-AA44-83AB17DA402C' and --Insurpolicy
Party_Id is not null and
[Type_Id] is not null 
and Party_Id = 'cae7a555-38f8-4038-94b0-c2f450011d7f'

---================== BaseInsurancePolicy
select * from Agreement where InsuranceApplication_Id = '64e2844f-62fc-4785-aa9c-6f7726975d39' 
select * 
from PartyRole 
where InsuranceApplication_Id = '64e2844f-62fc-4785-aa9c-6f7726975d39' and --BaseInsurancePolicy
Party_Id is not null and
[Type_Id] is not null and
Party_Id = 'cae7a555-38f8-4038-94b0-c2f450011d7f'

select * from Party where Id = 'cae7a555-38f8-4038-94b0-c2f450011d7f'

--============ Find the people not in B
select * 
INTO #PartyRole
from PartyRole 
where InsuranceApplication_Id = 'DCAB27EB-C824-456E-AA44-83AB17DA402C' and --Insurpolicy
Party_Id is not null and
[Type_Id] is not null
and Party_Id not in 
(
select Party_Id 
from PartyRole 
where InsuranceApplication_Id = '64e2844f-62fc-4785-aa9c-6f7726975d39' and --BaseInsurancePolicy
Party_Id is not null
)


Update #PartyRole
SET Id = newId() ,
InsuranceApplication_Id = '64e2844f-62fc-4785-aa9c-6f7726975d39'

select * 
from #PartyRole a
UNION
select * 
from PartyRole 
where InsuranceApplication_Id = '64e2844f-62fc-4785-aa9c-6f7726975d39' and --BaseInsurancePolicy
Party_Id is not null
order by SequenceNo
--================== End

--================== InsertData To #InsuranceApplicationItem
drop table  #InsuranceApplicationItem
drop table  #InsuranceApplicationItem_Map

select c.*
INTO #InsuranceApplicationItem
from InsuranceApplicationRoleItem a
inner join PartyRole b on (a.InsuranceApplicationRole_Id = b.Id)
inner join InsuranceApplicationItem c on (a.InsuranceApplicationItem_Id = c.Id)
where b.InsuranceApplication_Id = 'DCAB27EB-C824-456E-AA44-83AB17DA402C'
and Party_Id  not in 
(
select Party_Id 
from PartyRole 
where InsuranceApplication_Id = '64e2844f-62fc-4785-aa9c-6f7726975d39' and --BaseInsurancePolicy
Party_Id is not null
)

select c.Id as Id, newId() as NewId, c.Discriminator
INTO #InsuranceApplicationItem_Map
from InsuranceApplicationRoleItem a
inner join PartyRole b on (a.InsuranceApplicationRole_Id = b.Id)
inner join InsuranceApplicationItem c on (a.InsuranceApplicationItem_Id = c.Id)
where b.InsuranceApplication_Id = 'DCAB27EB-C824-456E-AA44-83AB17DA402C'
and Party_Id  not in 
(
select Party_Id 
from PartyRole 
where InsuranceApplication_Id = '64e2844f-62fc-4785-aa9c-6f7726975d39' and --BaseInsurancePolicy
Party_Id is not null
)

select * 
from #InsuranceApplicationItem
where Discriminator = 'InsuranceApplicationItem'


select * 
from #InsuranceApplicationItem
where Discriminator = 'InsuranceApplicationPackageItem'



DECLARE @parentId uniqueidentifier 
select @parentId = [NewId] from #InsuranceApplicationItem_Map where Discriminator = 'InsuranceApplicationItem'

Update #InsuranceApplicationItem
SET Id = @parentId,
InsuranceApplication_Id = NULL,
Parent_Id = NULL
where Discriminator = 'InsuranceApplicationItem' 

Update #InsuranceApplicationItem 
SET Id = a.[NewId],
Parent_Id = @parentId,
InsuranceApplication_Id = '64e2844f-62fc-4785-aa9c-6f7726975d39' 
FROM #InsuranceApplicationItem_Map a
WHERE #InsuranceApplicationItem.Id = a.Id
AND a.Discriminator = 'InsuranceApplicationPackageItem' 



--================== End

select a.*
from InsuranceApplicationRoleItem a
inner join PartyRole b on (a.InsuranceApplicationRole_Id = b.Id)
inner join InsuranceApplicationItem c on (a.InsuranceApplicationItem_Id = c.Id)
where b.InsuranceApplication_Id = 'DCAB27EB-C824-456E-AA44-83AB17DA402C'
order by SequenceNo, InsuranceApplicationRole_Id
--================== InsertData To #InsuranceApplicationRoleItem
select a.*
INTO #InsuranceApplicationRoleItem
from InsuranceApplicationRoleItem a
inner join PartyRole b on (a.InsuranceApplicationRole_Id = b.Id)
inner join InsuranceApplicationItem c on (a.InsuranceApplicationItem_Id = c.Id)
where b.InsuranceApplication_Id = 'DCAB27EB-C824-456E-AA44-83AB17DA402C'
and Party_Id not in 
(
select Party_Id 
from PartyRole 
where InsuranceApplication_Id = '64e2844f-62fc-4785-aa9c-6f7726975d39' and --BaseInsurancePolicy
Party_Id is not null
)

select * from #InsuranceApplicationRoleItem

Update #InsuranceApplicationRoleItem
SET Id = newId(),
InsuranceApplicationRole_Id = c.Id
FROM PartyRole a
INNER JOIN #PartyRole c on (a.Party_Id = c.Party_Id)
WHERE #InsuranceApplicationRoleItem.InsuranceApplicationRole_Id = a.Id 
and a.Party_Id in 
(
	select b.Party_Id
	from InsuranceApplicationRoleItem a
	inner join PartyRole b on (a.InsuranceApplicationRole_Id = b.Id)
	inner join InsuranceApplicationItem c on (a.InsuranceApplicationItem_Id = c.Id)
	where b.InsuranceApplication_Id = 'DCAB27EB-C824-456E-AA44-83AB17DA402C'
	and Party_Id not in 
	(
		select Party_Id 
		from PartyRole 
		where InsuranceApplication_Id = '64e2844f-62fc-4785-aa9c-6f7726975d39' and --BaseInsurancePolicy
		Party_Id is not null
	)
)

Update #InsuranceApplicationRoleItem
SET InsuranceApplicationItem_Id = a.[NewId]
FROM #InsuranceApplicationItem_Map a
WHERE #InsuranceApplicationRoleItem.InsuranceApplicationItem_Id = a.Id

drop table #InsuranceApplicationRoleItem
--================== End
select b.SequenceNo, count(1)
from #InsuranceApplicationRoleItem a
inner join #PartyRole b on (a.InsuranceApplicationRole_Id = b.Id)
inner join #InsuranceApplicationItem c on (a.InsuranceApplicationItem_Id = c.Id)
where b.InsuranceApplication_Id = '64e2844f-62fc-4785-aa9c-6f7726975d39' 
group by SequenceNo
order by SequenceNo


select b.SequenceNo, count(1)
from InsuranceApplicationRoleItem a
inner join PartyRole b on (a.InsuranceApplicationRole_Id = b.Id)
inner join InsuranceApplicationItem c on (a.InsuranceApplicationItem_Id = c.Id)
where b.InsuranceApplication_Id = '64e2844f-62fc-4785-aa9c-6f7726975d39'
group by SequenceNo
order by SequenceNo



select b.SequenceNo, count(1)
from InsuranceApplicationRoleItem a
inner join PartyRole b on (a.InsuranceApplicationRole_Id = b.Id)
inner join InsuranceApplicationItem c on (a.InsuranceApplicationItem_Id = c.Id)
where b.InsuranceApplication_Id = 'DCAB27EB-C824-456E-AA44-83AB17DA402C'
group by SequenceNo
order by SequenceNo


begin tran

INSERT INTO PartyRole
select * from #PartyRole

INSERT INTO InsuranceApplicationItem
select * from #InsuranceApplicationItem

INSERT INTO InsuranceApplicationRoleItem
select * from #InsuranceApplicationRoleItem

rollback
--commit

select *
from #InsuranceApplicationRoleItem
where Id not in 
(
select a.Id
from #InsuranceApplicationRoleItem a
inner join #PartyRole b on (a.InsuranceApplicationRole_Id = b.Id)
inner join #InsuranceApplicationItem c on (a.InsuranceApplicationItem_Id = c.Id)
where b.InsuranceApplication_Id = '64e2844f-62fc-4785-aa9c-6f7726975d39' 
)

select * from #PartyRole where Id = '931AFE20-1909-4968-8DCF-A71C0A109C1C'
select * from InsuranceApplicationItem where Id ='37FCEF37-FFE2-4931-BE15-4A33B4574DFF'
select * from #InsuranceApplicationItem where Id = '0C547F9D-E530-4FD4-97E9-8FEE12C1E1452'
select * from #InsuranceApplicationItem_Map where [NewId] = '0C547F9D-E530-4FD4-97E9-8FEE12C1E145'

select b.SequenceNo, count(1)
from InsuranceApplicationRoleItem a
inner join PartyRole b on (a.InsuranceApplicationRole_Id = b.Id)
inner join InsuranceApplicationItem c on (a.InsuranceApplicationItem_Id = c.Id)
where b.InsuranceApplication_Id = 'DCAB27EB-C824-456E-AA44-83AB17DA402C'
group by SequenceNo
order by SequenceNo

select a.*
from InsuranceApplicationRoleItem a
inner join PartyRole b on (a.InsuranceApplicationRole_Id = b.Id)
inner join InsuranceApplicationItem c on (a.InsuranceApplicationItem_Id = c.Id)
where b.InsuranceApplication_Id = 'DCAB27EB-C824-456E-AA44-83AB17DA402C'
order by SequenceNo


select * 
from InsuranceApplicationItem
WHERE InsuranceApplication_Id = 'DCAB27EB-C824-456E-AA44-83AB17DA402C' --Insurpolicy