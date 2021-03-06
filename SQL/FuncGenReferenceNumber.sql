USE [VIS_DB]
GO
/****** Object:  UserDefinedFunction [dbo].[GenReferenceNumber]    Script Date: 12/25/2017 10:10:05 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER FUNCTION  [dbo].[GenReferenceNumber] (@runningNumber INTEGER, @IsPol BIT, @IsVat BIT,@BranchCode VARCHAR(3),@subclass VARCHAR(3),@yearAD VARCHAR(3),@OwnedId VARCHAR(3))
RETURNS VARCHAR(30)
AS  

BEGIN
		DECLARE @Type1 VARCHAR(4)
		DECLARE @LenrunNo int = LEN(@runningNumber)
		if (@IsVat = 1 and @IsPol = 1)
			SET @Type1 = 'END'
		else if (@IsVat = 1)
			SET @Type1 = 'VAT'
		else if(@IsPol = 1)
			SET @Type1 = 'POL'
		else
			SET @Type1 = 'RCP'
		
		If @OwnedId is NULL
			SET @OwnedId = '00'

		if( @LenrunNo = 1)
			 RETURN CONCAT(@yearAD,@BranchCode,'/',@Type1,'/',@OwnedId,'000',@runningNumber,'-',@subclass);
		else if ( @LenrunNo = 2)
			 RETURN CONCAT(@yearAD,@BranchCode,'/',@Type1,'/',@OwnedId,'00',@runningNumber,'-',@subclass);
		else if ( @LenrunNo = 3)
			 RETURN CONCAT(@yearAD,@BranchCode,'/',@Type1,'/',@OwnedId,'0',@runningNumber,'-',@subclass);
		else if ( @LenrunNo = 4)
			 RETURN CONCAT(@yearAD,@BranchCode,'/',@Type1,'/',@OwnedId,@runningNumber,'-',@subclass);
		-- else if ( @LenrunNo = 5)
		-- 	 RETURN CONCAT(@yearAD,@BranchCode,'/',@Type1,'/0',@runningNumber,'-',@subclass);
		-- else if ( @LenrunNo = 6)
		-- 	 RETURN CONCAT(@yearAD,@BranchCode,'/',@Type1,'/',@runningNumber,'-',@subclass);
		
		RETURN CONCAT(@yearAD,@BranchCode,'/',@Type1,'/000001','-',@subclass);
END