DECLARE
    @table_name     SYSNAME,
    @table_schema   SYSNAME,
    @sql_string     VARCHAR(2000)

DECLARE tables_cur CURSOR FOR select t.TABLE_SCHEMA, t.TableName  FROM (
											SELECT 
												it.TABLE_SCHEMA,
												t.NAME AS TableName,
												i.name as indexName,
												p.[Rows],
												sum(a.total_pages) as TotalPages, 
												sum(a.used_pages) as UsedPages, 
												sum(a.data_pages) as DataPages,
												(sum(a.total_pages) * 8) / 1024 as TotalSpaceMB, 
												(sum(a.used_pages) * 8) / 1024 as UsedSpaceMB, 
												(sum(a.data_pages) * 8) / 1024 as DataSpaceMB
											FROM 
												sys.tables t
											INNER JOIN      
												sys.indexes i ON t.OBJECT_ID = i.object_id
											INNER JOIN 
												sys.partitions p ON i.object_id = p.OBJECT_ID AND i.index_id = p.index_id
											INNER JOIN 
												sys.allocation_units a ON p.partition_id = a.container_id
											INNER JOIN 
												INFORMATION_SCHEMA.TABLES it on (t.name = it.TABLE_NAME)
											INNER JOIN 
												 sys.columns co  ON (co.object_id = t.object_id)
											WHERE 
												t.NAME NOT LIKE '_endorse%' AND
												i.OBJECT_ID > 255 AND   
												i.index_id <= 1 AND
												it.TABLE_TYPE = 'BASE TABLE' AND
												co.name in ('Modifiedusername','CreatedDate','ModifiedDate')
											GROUP BY 
												it.TABLE_SCHEMA,t.NAME, i.object_id, i.index_id, i.name, p.[Rows]
									)  t
									where t.rows > 0
									order by t.TableName

DECLARE @username varchar(50) = 'vichayas'
DECLARE @DateTime varchar(50) = '2018-02-13 14:25:00'

OPEN tables_cur

FETCH NEXT FROM tables_cur INTO @table_schema, @table_name

WHILE (@@FETCH_STATUS = 0)
BEGIN
    SET @sql_string =
              'IF EXISTS (SELECT TOP 1 ModifiedDate FROM ' + QUOTENAME(@table_schema) + '.' + QUOTENAME(@table_name) + ' WHERE Modifiedusername like ''%'+@username+'%'' and (CreatedDate > convert(datetime, '''+@DateTime+''',20) or ModifiedDate > convert(datetime, '''+@DateTime+''',20))) ' +
              'BEGIN ' +
                     'SELECT * INTO _endorse6_' + CONVERT(NVARCHAR(100), @table_name) + ' FROM ' + QUOTENAME(@table_schema) + '.' + QUOTENAME(@table_name) + ' WHERE Modifiedusername like ''%'+@username+'%'' and (CreatedDate > convert(datetime, '''+@DateTime+''',20) or ModifiedDate > convert(datetime, '''+@DateTime+''',20)) ' +
              'END'

    EXECUTE(@sql_string)

       PRINT CONVERT(NVARCHAR(100), @table_name)

       DBCC FREEPROCCACHE WITH NO_INFOMSGS
       DBCC DROPCLEANBUFFERS WITH NO_INFOMSGS

    FETCH NEXT FROM tables_cur INTO @table_schema, @table_name
END

CLOSE tables_cur

DEALLOCATE tables_cur
