select *
 from InsuranceApplication with (nolock) 
 where convert(char(16),ModifiedDate,121)>'20171218 10:20' 
 AND convert(char(15),CreatedDate,121)!='2017-12-18 10:2'  

 select CreatedDate, ModifiedDate
 from InsuranceApplication with (nolock) 
 where convert(char(16),ModifiedDate,121)>'20171218 10:20' 
 AND convert(char(15),CreatedDate,121)!='2017-12-18  10:2'  


 --select top 5 * from InsuranceApplication where convert(char(16),ModifiedDate,121)>'20171217 07:00' 

 --select Name = 'Agreement', TDate = convert(char(19),max(ModifiedDate),121), count(1) from [Agreement] with (nolock) where convert(char(16),ModifiedDate,121)>'20171217 14:00' AND convert(char(13),CreatedDate,121)!='2017-12-17 14:1'  group by convert(char(8),ModifiedDate,112) having convert(char(8),ModifiedDate,112)='20171217' and max(ModifiedDate) > 0