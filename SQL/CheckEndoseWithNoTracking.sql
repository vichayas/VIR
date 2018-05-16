select VIB_EndosCode,DescriptionTH
from Endorsement where Id in
(
	select distinct EndorsementType_Id
	from ApplicantEndorsementItem a
	inner join Agreement b on (a.ApplicantEndorsement_Id = b.Id and b.CurrentApprovalResult = 2)
	where a.Id not in(
	select distinct ApplicantEndorsementItem_Id
	from ApplicantEndorsementTracking where ApplicantEndorsementItem_Id is not NULL
	)
)
order by VIB_EndosCode
