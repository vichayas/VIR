                                    select 
                                  an.LicenseNumber as [LicenseNumber]
                                  ,pr.Id as [PartyRole_Id]
                                                  ,pr.Code
                                                  ,pr.Party_Id as [Party_Id]
                                  ,acr.InsuranceBrokerId as [InsuranceBrokerId]
                                                  ,acr.Id
                                  ,an.Id as [AgentNumber_Id]
                                                  ,acr.NetTotal,
                                                  iai.Id
                           from AgentCommissionRate as acr with(nolock)
                                  inner join PartyRole as pr
                                         on pr.Id = acr.InsuranceAgentId
                                               -- and (pr.Discriminator = N'InsuranceAgent' and pr.Code = '04764')
                                                and (acr.Discriminator = N'AgentTotalCommissionRate')
                                  inner join InsuranceBranchAvailabilty as iba with(nolock)
                                         on acr.Id = iba.AgentTotalCommissionRate_Id
                                  inner join AgentCommissionRateAvailability as acra with(nolock)
                                         on acr.Id = acra.AgentCommissionRate_Id
                                                and (acr.BranchId = '0E56AE73-6C23-408F-9B1E-EBA3573BF7F5')
                                                and (acr.ThruDate is null)
                                                  inner join PartyRole p2 on (p2.Party_Id = pr.Party_Id)
                                                  inner join InsuranceApplicationItem iai on (p2.InsuranceApplication_Id = iai.InsuranceApplication_Id)
                                  left join AgentNumber as an with(nolock)
                                         on an.InsuranceSale_Id is not null
                                                and (an.InsuranceSale_Id = acr.InsuranceBrokerId)
                                                and (an.Discriminator = N'InsuranceSaleLicense')
                                                and (an.ThruDate is null)
                           where acra.InsuranceProductCategory_Id = 'C4862E59-A6BE-4019-B803-4155AA3778F6' and acr.NetTotal = 19.26 and acr.Tax=18
                                                      and iai.TotalBeforeFee = 511.02 and InsuranceApplicationItemType_Id like 'F89579DB-7C44-409F-8D50-A0061D29D04E'
                                       select * from ProductCategory where Code = '515'

                                    

                                      -- begin tran
                                      -- update AgentCommissionRate 
                                      -- set ThruDate = '2016-08-01 00:00:00.000'
                                      -- where Id in
                                      -- (
                                                --'7F5934DC-E8CB-4800-AD84-1302A0611A57',
                                                --'5867C6C6-54EF-45D4-9150-B3DC0C09F1D0'
                                      -- )

                                      -- commit

                                       select * from PartyRole where Id = '45CFEDE8-3299-4816-BF71-F0C0569A5B37'

                                       select top 1 * from PartyRole where Party_Id = '5ADF5C2C-2672-40A6-9703-6A97E22619B8'

                                          select * from AgentCommissionRate where Id in
                                       (
                                                '7F5934DC-E8CB-4800-AD84-1302A0611A57',
                                                '3DF4A613-305E-446B-8CD5-73957A588413',
                                                '5867C6C6-54EF-45D4-9150-B3DC0C09F1D0'
                                       )

                                        select b.* 
                                          from PartyRole a
                                          inner join InsuranceApplication b on (a.InsuranceApplication_Id = b.Id)
                                          where Party_Id = '5ADF5C2C-2672-40A6-9703-6A97E22619B8'
                                          and b.InsuranceProductCategoryId = 'C4862E59-A6BE-4019-B803-4155AA3778F6' 

                                          select TotalBeforeFee,* from InsuranceApplicationItem where Id in ('64BE32AD-810D-486C-9E78-53153FAF4CF5','E9B34038-7CD5-4EF7-AE8C-A76CFE46B690')

                                       select b.TotalBeforeFee, b.* from Agreement a 
                                       inner join InsuranceApplicationItem b on (a.InsuranceApplication_Id = b.InsuranceApplication_Id)
                                       where a.ReferenceNumber = '18181/POL/090726-515'
                                       and InsuranceApplicationItemType_Id like 'F89579DB-7C44-409F-8D50-A0061D29D04E'

                                       select TotalBeforeFee, * from InsuranceApplicationItem where InsuranceApplication_Id = 'EA7551A3-0F68-43F7-B0CB-9604DEE2135E'and InsuranceApplicationItemType_Id like 'F89579DB-7C44-409F-8D50-A0061D29D04E'
                                       
                                       select * from AgentCommission where Premium_Id = 'C029316F-B9EE-487C-8176-5AB10E735776'
                                       union
                                       select * from AgentCommission where Premium_Id = '64BE32AD-810D-486C-9E78-53153FAF4CF5'

                                       UPDATE AgentCommission
                                       SET TotalAmount = 98.42,
                                                SubTotalAmount = 91.9836,
                                                RateAmount = 19.26 
                                       WHERE Id ='03E026BE-ACF2-4639-A72D-D28E7C21687E'

                                       exec sp_fkeys InsuranceApplicationItem

                                       select * from AgentCommissionRate 

-------------------------------------------
       select top 1
                                  an.LicenseNumber as [LicenseNumber]
                                  ,pr.Id as [PartyRole_Id]
                                  ,acr.InsuranceBrokerId as [InsuranceBrokerId]
                                  ,an.Id as [AgentNumber_Id]
                           into #get_agent
                           from AgentCommissionRate as acr with(nolock)
                                  inner join PartyRole as pr
                                         on pr.Id = acr.InsuranceAgentId
                                                and (pr.Discriminator = N'InsuranceAgent' and pr.Code = @agent_code)
                                                and (acr.Discriminator = N'AgentTotalCommissionRate')
                                  inner join InsuranceBranchAvailabilty as iba with(nolock)
                                         on acr.Id = iba.AgentTotalCommissionRate_Id
                                  inner join AgentCommissionRateAvailability as acra with(nolock)
                                         on acr.Id = acra.AgentCommissionRate_Id
                                                and (acr.BranchId = @branch_id)
                                                and (acr.ThruDate is null)
                                  left join AgentNumber as an with(nolock)
                                         on an.InsuranceSale_Id is not null
                                                and (an.InsuranceSale_Id = acr.InsuranceBrokerId)
                                                and (an.Discriminator = N'InsuranceSaleLicense')
                                                and (an.ThruDate is null)
                                  inner join #get_category as tmp
                                         on acra.InsuranceProductCategory_Id = tmp.Id
                           where acra.InsuranceProductCategory_Id = tmp.Id 


 
