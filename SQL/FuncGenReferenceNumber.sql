USE [VIS_DB]
GO
/****** Object:  UserDefinedFunction [dbo].[GenReferenceNumber]    Script Date: 12/25/2017 10:10:05 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION  [dbo].[GenReferenceNumber] (@runningNumber INTEGER, @IsPol INTEGER, @IsVat INTEGER,@BranchCode VARCHAR(3),@subclass VARCHAR(3))
RETURNS VARCHAR(30)
AS  

BEGIN
		DECLARE @Type1 VARCHAR(4)
		DECLARE @LenrunNo int = LEN(@runningNumber)
		if(@IsPol = 1)
			SET @Type1 = 'POL'
		else if (@IsVat = 1)
			SET @Type1 = 'VAT'
		else
			SET @Type1 = 'RCP'
		if( @LenrunNo = 1)
			 RETURN CONCAT('17',@BranchCode,'/',@Type1,'/00000',@runningNumber,'-',@subclass);
		else if ( @LenrunNo = 2)
			 RETURN CONCAT('17',@BranchCode,'/',@Type1,'/0000',@runningNumber,'-',@subclass);
		else if ( @LenrunNo = 3)
			 RETURN CONCAT('17',@BranchCode,'/',@Type1,'/000',@runningNumber,'-',@subclass);
		else if ( @LenrunNo = 4)
			 RETURN CONCAT('17',@BranchCode,'/',@Type1,'/00',@runningNumber,'-',@subclass);
		else if ( @LenrunNo = 5)
			 RETURN CONCAT('17',@BranchCode,'/',@Type1,'/0',@runningNumber,'-',@subclass);
		else if ( @LenrunNo = 6)
			 RETURN CONCAT('17',@BranchCode,'/',@Type1,'/',@runningNumber,'-',@subclass);
		
		RETURN CONCAT('17',@BranchCode,'/',@Type1,'/000001','-',@subclass);
END