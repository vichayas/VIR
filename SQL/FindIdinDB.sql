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
		--and c.name='ModifiedDate'
		and c.max_length = 16
		and c.name like 'Id'
order by table_name



set @item=0

create table #tablename (t_name nvarchar(100),c_name nvarchar(100))

print 'start:'+ CONVERT(char(19),getdate(),121)

open curtablename
fetch next from curtablename into @t_name,@c_name
while(@@FETCH_STATUS=0)
begin

	set @sql='insert into #tablename select Name = '''+@t_name +''',C_NAME = '''+@c_name +''' from ['+@t_name +'] with (nolock) where '+@c_name+' = ''2e7d8ae9-ca4f-46ae-97c1-d5060ac1e2e2'''
	execute sp_executesql @sql;
	print @sql
	/*execute sp_executesql @sql,N'@cDate nvarchar(19), @curdate nvarchar(8),@cnt int OUTPUT',@cDate,@curdate,@cnt OUTPUT	
	if @cnt>0
		begin
			set @item=@item+1
			print CONVERT(char(19),getdate(),121)+','+convert(char(3),@item)+'->ok :'+@t_name
			insert into #tablename(t_name,t_date) values(@t_name, @cDate)
			set @cnt=0
		end
	else
		begin
			
			set @item=@item+1
			print CONVERT(char(19),getdate(),121)+','+convert(char(3),@item)+'->ng :' +@t_name
			set @cnt=0
		end				
	*/
	fetch next from curtablename into @t_name,@c_name		

end
close curtablename
deallocate curtablename

print 'end:'+ CONVERT(char(19),getdate(),121)

select * from #tablename with (nolock) group by t_name,c_name order by t_name desc
drop table #tablename