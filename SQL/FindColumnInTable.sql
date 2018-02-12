use VIS_DB

select db_name() as database_name
    ,table_name = sysobjects.name
    ,column_name = syscolumns.name
    ,datatype = systypes.name
    ,length = syscolumns.length
       ,sysobjects.xtype
from sysobjects
inner join syscolumns on sysobjects.id = syscolumns.id
inner join systypes on syscolumns.xtype = systypes.xtype
where --sysobjects.xtype = 'U' and
syscolumns.name like 'paid%date'  --and systypes.name = 'nvarchar' and 
--sysobjects.name like '%Cover%'
--syscolumns.length <  4
order by sysobjects.name
    ,syscolumns.colid
