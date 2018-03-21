print '*** แก้ไขวันที่ออกกรมธรรม์ และวันที่โอนกรมธรรม์ ***'
select * from policy
where pol_yr = '18' and pol_br = '108' and pol_pre = '520' and pol_no in ('000006')

select * from his_policy
where pol_yr = '18' and pol_br = '108' and pol_pre = '520' and pol_no in ('000006')

UPDATE his_policy
SET net_premium = 14492,
	stamp_per =0.4,
	stamp =58,
	total_premium = 14550,
	comm_per =27.82,
	comm = 4031.67,
	comm_fix_per = 18,
	comm_add_per = 8,
	comm_vat_per = 1.8,
	total_comm_per = 27.82,
	comm_cal_vat_per = 26,
	comm_before_vat_per = 26
where pol_yr = '18' and pol_br = '108' and pol_pre = '520' and pol_no in ('000006')

update policy
set		issue_date = '2018-03-12 13:09:42.537', 
			approve_datetime = '2018-03-12 13:09:42.537', 
			tr_datetime = '2018-03-12 13:09:42.537' ,
			agreement_date = '2018-03-12 13:09:42.537'
where pol_yr = '18' and pol_br = '108' and pol_pre = '520' and pol_no in ('000006')
update his_policy
set			issue_date = '2018-03-12 13:09:42.537', 
			approve_datetime = '2018-03-12 13:09:42.537', 
			tr_datetime = '2018-03-12 13:09:42.537' ,
			agreement_date = '2018-03-12 13:09:42.537'
where pol_yr = '18' and pol_br = '108' and pol_pre = '520' and pol_no in ('000006')

print '*** กรณีตัดชำระเบี้ยแล้ว ***'
select issue_date,approve_date,* from financedb.dbo.debit_policy
where pol_yr = '18' and pol_br = '108' and pol_pre = '520' and pol_no in ('000001')

update financedb.dbo.debit_policy
set issue_date = '2017-01-16 13:13:18.240', 
			approve_date = '2017-01-16 13:13:18.240'
where pol_yr = '18' and pol_br = '181' and pol_pre = '520' and pol_no in ('000006')




select issue_date, approve_datetime, tr_datetime, agreement_date,* from policy
where pol_yr = '18' and pol_br = '181' and pol_pre = '520' and pol_no in ('000014','000015','000016','000017','000006')