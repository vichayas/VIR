DECLARE @ReferenceNO nvarchar(30) = '18304/APP/000069-511'

DECLARE @APE_ID uniqueidentifier
DECLARE @ApprovalKey nvarchar(10)
DECLARE @ApprovalTrackingId uniqueidentifier
DECLARE @ApprovalTrackingItemId uniqueidentifier

select @APE_ID = a.Id, @ApprovalKey = a.CurrentApprovalKey, @ApprovalTrackingItemId = a.CurrentApprovalTrackingItemId
from Agreement a
where ReferenceNumber = @ReferenceNO
and CurrentApprovalResult = 1

IF(@APE_ID is not NULL and (@ApprovalKey is null or @ApprovalTrackingItemId is null))
BEGIN
	SELECT @ApprovalTrackingId = Id
	from ApprovalTracking
	where TokenId = @APE_ID

	SELECT @ApprovalKey = ApprovalKey, @ApprovalTrackingItemId = Id
	FROM ApprovalTrackingItem
	WHERE ApprovalTracking_Id = @ApprovalTrackingId

	UPDATE Agreement
	SET CurrentApprovalKey = @ApprovalKey,
		CurrentApprovalTrackingItemId = @ApprovalTrackingItemId
	WHERE Id = @APE_ID

END