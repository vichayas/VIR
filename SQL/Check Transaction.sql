exec sp_who2

select * from sys.dm_tran_active_transactions 
ROLLBACK TRANSACTION VIS2MAMA

DBCC OPENTRAN