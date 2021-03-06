SELECT * 
    FROM sys.dm_tran_active_transactions tat 
        INNER JOIN sys.dm_exec_requests er ON tat.transaction_id = er.transaction_id
        CROSS APPLY sys.dm_exec_sql_text(er.sql_handle)