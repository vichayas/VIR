SELECT DISTINCT 
O.name SP_Name,T.name Table_Name,c.name Field_Name
FROM sys.sysdepends D 
JOIN sys.sysobjects O ON O.id = D.id
JOIN sys.sysobjects T ON T.id = D.depid
JOIN sys.columns C ON C.column_id=d.depnumber
and C.object_id=D.depID
WHERE O.xtype = 'P' and O.name = 'AppToPolicy_New'