select * 
from NavigationMenu
where Id = '4c7ffad0-428f-437c-8f3c-cd4b7042ddd2'

select * from UserProfile where Id = 'c5150561-9a88-45b1-baed-aad771015cff' --anchaleet
select * from UserProfile where DescriptionTH = 'chanapasu'

-------
select * from UserGroupMembership
select *
from NavigationMenuAccessibility a
inner join UserGroupMembership b on (a.UserGroup_Id = b.UserGroup_Id)
where b.UserProfile_Id = 'c5150561-9a88-45b1-baed-aad771015cff'
and a.ControllerAction_Id = 'd12c37b0-59a7-45cb-a9ed-bd345595723d' -- Find policy

--select * from UserGroup where Id = '209A40B6-AA40-41C0-96DB-AF7918748F07'

select a.*
from NavigationMenuUsage a
inner join ApprovalKey b on (a.Id = b.NavigationMenuUsage_Id)
where NavigationMenuAccessibility_Id = 'C69E2284-2D8C-406A-B23E-1BFD889C664A'



select top 1 b.*
into #ApprovalKey002
from NavigationMenuUsage a
inner join ApprovalKey b on (a.Id = b.NavigationMenuUsage_Id)
where NavigationMenuAccessibility_Id = 'C69E2284-2D8C-406A-B23E-1BFD889C664A'

UPDATE #ApprovalKey002
SET Id = newId(),
	[Key] = 'AP002',
	NavigationMenuUsage_Id = '91808DE4-E806-4334-B13B-96AD88547519'
insert into ApprovalKey
select * from #ApprovalKey002

drop table #ApprovalKey002
---------------------- Create Application

select *
from NavigationMenuAccessibility a
inner join UserGroupMembership b on (a.UserGroup_Id = b.UserGroup_Id)
where b.UserProfile_Id = 'c5150561-9a88-45b1-baed-aad771015cff'
and a.ControllerAction_Id = 'a2d1ed6b-401e-45e5-9372-83797ae7bb2d' -- Create policy

select * 
from NavigationMenuAccessibility
where UserProfile_Id = '0879bad2-5d3e-4416-9991-3d3c866074d7'
and ControllerAction_Id = 'a2d1ed6b-401e-45e5-9372-83797ae7bb2d'


select * 
into #NavigationMenuAccessibility
from NavigationMenuAccessibility
where UserProfile_Id = '0879bad2-5d3e-4416-9991-3d3c866074d7'
and ControllerAction_Id = 'a2d1ed6b-401e-45e5-9372-83797ae7bb2d'
--select * from UserGroup where Id = '209A40B6-AA40-41C0-96DB-AF7918748F07'


select top 1 a.*
into #NavigationMenuUsage
from NavigationMenuUsage a
left join ApprovalKey b on (a.Id = b.NavigationMenuUsage_Id)
where NavigationMenuAccessibility_Id = 'A364EC9F-FDC7-4C41-AF5D-82431F041D7A'

UPDATE #NavigationMenuAccessibility
SET ID = '455B5A47-D98B-4DA5-BFC8-34C4A40E46F5',
	UserProfile_Id =  'c5150561-9a88-45b1-baed-aad771015cff'

UPDATE #NavigationMenuUsage
SET Id = 'EB7DDF21-6687-4AF1-A48E-9C83AFA53E97',
	NavigationMenuAccessibility_Id = '455B5A47-D98B-4DA5-BFC8-34C4A40E46F5'
	
select * from #NavigationMenuUsage
select * from #NavigationMenuAccessibility
--select b.*
--into #ApprovalKey002
--from NavigationMenuUsage a
--inner join ApprovalKey b on (a.Id = b.NavigationMenuUsage_Id)
--where NavigationMenuAccessibility_Id = 'DFFE628F-8B22-4A38-8B83-664B30A08082'
select * from #ApprovalKey002
UPDATE #ApprovalKey002
SET Id = newId(),
	[Key] = 'AP002',
	NavigationMenuUsage_Id = 'EB7DDF21-6687-4AF1-A48E-9C83AFA53E97'


insert into NavigationMenuAccessibility
select * from #NavigationMenuAccessibility
insert into NavigationMenuUsage
select * from #NavigationMenuUsage
insert into ApprovalKey
select * from #ApprovalKey002

---------------------- Create Application

select *
from NavigationMenuAccessibility a
inner join UserGroupMembership b on (a.UserGroup_Id = b.UserGroup_Id)
where b.UserProfile_Id = 'c5150561-9a88-45b1-baed-aad771015cff'
and a.ControllerAction_Id = 'a2d1ed6b-401e-45e5-9372-83797ae7bb2d' -- Create policy

select * 
from NavigationMenuAccessibility
where UserProfile_Id = '0879bad2-5d3e-4416-9991-3d3c866074d7'
and ControllerAction_Id = '9304d57a-253e-431d-aa3f-ad315576b2eb'


select * 
--into #NavigationMenuAccessibility
from NavigationMenuAccessibility
where UserProfile_Id = '0879bad2-5d3e-4416-9991-3d3c866074d7'
and ControllerAction_Id = '9304d57a-253e-431d-aa3f-ad315576b2eb'
--select * from UserGroup where Id = '209A40B6-AA40-41C0-96DB-AF7918748F07'


select top 2 b.*
--into #NavigationMenuUsage
from NavigationMenuUsage a
left join ApprovalKey b on (a.Id = b.NavigationMenuUsage_Id)
where NavigationMenuAccessibility_Id = 'DFF015C5-FB26-49A8-8B38-0BF098E81136'

UPDATE #NavigationMenuAccessibility
SET ID = newId(),
	UserProfile_Id =  'c5150561-9a88-45b1-baed-aad771015cff',
	ControllerAction_Id = '9304d57a-253e-431d-aa3f-ad315576b2eb'

UPDATE #NavigationMenuUsage
SET Id = newId(),
	NavigationMenuAccessibility_Id = '3298FCA1-3D84-47D4-BDBC-2F925D4F644F'
	
select * from #NavigationMenuUsage
select * from #NavigationMenuAccessibility
--select b.*
--into #ApprovalKey002
--from NavigationMenuUsage a
--inner join ApprovalKey b on (a.Id = b.NavigationMenuUsage_Id)
--where NavigationMenuAccessibility_Id = 'DFFE628F-8B22-4A38-8B83-664B30A08082'
select * from #ApprovalKey002
UPDATE #ApprovalKey002
SET Id = newId(),
	[Key] = 'AP002',
	NavigationMenuUsage_Id = 'C5985232-11A0-4D5F-B1ED-C924244B5AFE'


insert into NavigationMenuAccessibility
select * from #NavigationMenuAccessibility
insert into NavigationMenuUsage
select * from #NavigationMenuUsage
insert into ApprovalKey
select * from #ApprovalKey002


select * from ControllerAction where Id = '9304d57a-253e-431d-aa3f-ad315576b2eb'


---------------------- Create Endorse ment


select * 
from NavigationMenuAccessibility
where UserProfile_Id = '0879bad2-5d3e-4416-9991-3d3c866074d7'
and ControllerAction_Id = 'e83bde65-bf79-4d0e-b968-b5bee9ab9b9a'


select * 
--into #NavigationMenuAccessibility
from NavigationMenuAccessibility
where UserProfile_Id = '0879bad2-5d3e-4416-9991-3d3c866074d7'
and ControllerAction_Id = '9304d57a-253e-431d-aa3f-ad315576b2eb'
--select * from UserGroup where Id = '209A40B6-AA40-41C0-96DB-AF7918748F07'


select top 2 b.*
--into #NavigationMenuUsage
from NavigationMenuUsage a
left join ApprovalKey b on (a.Id = b.NavigationMenuUsage_Id)
where NavigationMenuAccessibility_Id = 'DFF015C5-FB26-49A8-8B38-0BF098E81136'

UPDATE #NavigationMenuAccessibility
SET ID = newId(),
	UserProfile_Id =  'c5150561-9a88-45b1-baed-aad771015cff',
	ControllerAction_Id = 'e83bde65-bf79-4d0e-b968-b5bee9ab9b9a'

UPDATE #NavigationMenuUsage
SET Id = newId(),
	NavigationMenuAccessibility_Id = 'CEA79D55-0403-42E7-8327-1442D575D9FD'
	
select * from #NavigationMenuUsage
select * from #NavigationMenuAccessibility
--select b.*
--into #ApprovalKey002
--from NavigationMenuUsage a
--inner join ApprovalKey b on (a.Id = b.NavigationMenuUsage_Id)
--where NavigationMenuAccessibility_Id = 'DFFE628F-8B22-4A38-8B83-664B30A08082'
select * from #ApprovalKey002
UPDATE #ApprovalKey002
SET Id = newId(),
	[Key] = 'AP002',
	NavigationMenuUsage_Id = 'D21F18FC-CBD3-4985-AB6E-A697B2E3C874'


insert into NavigationMenuAccessibility
select * from #NavigationMenuAccessibility
insert into NavigationMenuUsage
select * from #NavigationMenuUsage
insert into ApprovalKey
select * from #ApprovalKey002

---------------------- New Endorsement


select * 
from NavigationMenuAccessibility
where UserProfile_Id = '0879bad2-5d3e-4416-9991-3d3c866074d7'
and ControllerAction_Id = 'affb003d-45da-45c0-8191-c5b983164ce0'


select * 
--into #NavigationMenuAccessibility
from NavigationMenuAccessibility
where UserProfile_Id = '0879bad2-5d3e-4416-9991-3d3c866074d7'
and ControllerAction_Id = 'affb003d-45da-45c0-8191-c5b983164ce0'
--select * from UserGroup where Id = '209A40B6-AA40-41C0-96DB-AF7918748F07'


select top 3 b.*
--into #NavigationMenuUsage
from NavigationMenuUsage a
left join ApprovalKey b on (a.Id = b.NavigationMenuUsage_Id)
where NavigationMenuAccessibility_Id = '088BCEFB-4615-414D-8C5D-8402E945ED3A'

UPDATE #NavigationMenuAccessibility
SET ID = newId(),
	UserProfile_Id =  'c5150561-9a88-45b1-baed-aad771015cff',
	ControllerAction_Id = 'e83bde65-bf79-4d0e-b968-b5bee9ab9b9a'

UPDATE #NavigationMenuUsage
SET Id = newId(),
	NavigationMenuAccessibility_Id = 'CEA79D55-0403-42E7-8327-1442D575D9FD'
	
select * from #NavigationMenuUsage
select * from #NavigationMenuAccessibility
--select b.*
--into #ApprovalKey002
--from NavigationMenuUsage a
--inner join ApprovalKey b on (a.Id = b.NavigationMenuUsage_Id)
--where NavigationMenuAccessibility_Id = 'DFFE628F-8B22-4A38-8B83-664B30A08082'
select * from #ApprovalKey002
UPDATE #ApprovalKey002
SET Id = newId(),
	[Key] = 'AP002',
	NavigationMenuUsage_Id = 'D21F18FC-CBD3-4985-AB6E-A697B2E3C874'


insert into NavigationMenuAccessibility
select * from #NavigationMenuAccessibility
insert into NavigationMenuUsage
select * from #NavigationMenuUsage
insert into ApprovalKey
select * from #ApprovalKey002
