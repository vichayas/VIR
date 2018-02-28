--
--list table schema
--
/*
select
	schema_name(t.schema_id) as schema_name 
	,object_name(c.object_id) as table_name 
	,c.column_id
    ,c.name as column_name
    ,y.name as data_type
    ,c.max_length
    ,case when c.is_nullable=0 then '' else 'y' end as allow_null
    ,case when c.is_identity=1 then 'y' else '' end as is_identity
from sys.columns c
    join sys.tables t on c.object_id = t.object_id
    JOIN sys.types y ON y.user_type_id = c.user_type_id
WHERE t.[is_ms_shipped] = 0 
	--and c.name='createddate'
order by t.name,c.column_id
*/


declare @curdate nvarchar(8)
--yyyymmdd
set @curdate=CONVERT(char(8),getdate(),112)
--set @curdate='20171012'


declare @s_name nvarchar(100)
declare @t_name nvarchar(100)
declare @c_name nvarchar(100)

declare @item int
declare @cnt int
declare @cDate nvarchar(19)
declare @sql nvarchar(max)

declare curtablename cursor local fast_forward for
select distinct
	object_name(c.object_id) as table_name 
	,c.name as column_name
from sys.columns c
    join sys.tables t on c.object_id = t.object_id
    JOIN sys.types y ON y.user_type_id = c.user_type_id
WHERE t.[is_ms_shipped] = 0
		and c.name not in ('ModifiedDate','CreatedDate')
		and c.max_length = 8
		and c.[precision] = 23
		and c.name like '%Date'
order by table_name



set @item=0

create table #tablename (t_name nvarchar(100),c_name nvarchar(100))

print 'start:'+ CONVERT(char(19),getdate(),121)

open curtablename
fetch next from curtablename into @t_name,@c_name
while(@@FETCH_STATUS=0)
begin

	set @sql='insert into #tablename select Name = '''+@t_name +''',C_NAME = '''+@c_name +''' from ['+@t_name +'] with (nolock) where  CONVERT(varchar(4),'+@c_name+',121) > 2020'
	execute sp_executesql @sql;
	print @sql

	fetch next from curtablename into @t_name,@c_name		

end
close curtablename
deallocate curtablename

print 'end:'+ CONVERT(char(19),getdate(),121)

select * from #tablename with (nolock) group by t_name,c_name order by t_name desc
drop table #tablename


