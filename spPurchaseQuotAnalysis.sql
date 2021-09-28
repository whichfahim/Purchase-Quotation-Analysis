ALTER PROC [dbo].[spPurchaseQuotAnalysis]	
(
	@requisitionNo varchar(15)
) AS
BEGIN
	--DECLARE @requisitionNo AS VARCHAR(15) 
	--SET @requisitionNo='SQ01332019'
	SELECT DISTINCT
		PRD.PURCREQNO,
		PQ.PURCQUOTDATE,
		PRD.CODE,
		
		--####ITEM####--
		(CASE 
			WHEN O.ITEMNAME IS NOT NULL THEN O.ITEMNAME 
			WHEN R.ITEMNAME IS NOT NULL THEN R.ITEMNAME 
			WHEN M.[NAME] IS NOT NULL THEN ( M.[NAME] + ' & MODEL: ' +M.MODEL ) 
			ELSE S.[NAME] 
		END) AS ITEM,
		
		--####QUANTITY####--
		CAST(PRD.QTY AS INT) AS QTY,

		--####UNIT OF MEASURE####--
		(CASE 
			WHEN 
			O.ITEMNAME IS NOT NULL THEN SO.STRVAL 
			WHEN 
			R.ITEMNAME IS NOT NULL THEN SR.STRVAL 
			WHEN 
			M.[NAME] IS NOT NULL THEN 'SET' 
			ELSE 
			SS.STRVAL 
		END) AS UoM,

		--#### LAST PURCHASE DETAILS ####--
		[dbo].[fnLastPurcVendorPurcRequ](PRD.CODE,PR.PURCREQDATE) AS lastPurcVendor,
		[dbo].[fnLastPurcDatePurcRequNew](PRD.CODE,PR.PURCREQDATE,PR.REQFOR) AS lastPurcDate,
		[dbo].[fnLastPurcQtyPurcRequNew](PRD.CODE,PR.PURCREQDATE,PR.REQFOR) AS lastPurcQty,
		[dbo].[fnLastPurcPricePurcRequ](PRD.CODE,PR.PURCREQDATE) AS lastPurcPrice,
		CONCAT
		   ('Vendor: ',[dbo].[fnLastPurcVendorPurcRequ](PRD.CODE,PR.PURCREQDATE),
			', Date: ',[dbo].[fnLastPurcDatePurcRequNew](PRD.CODE,PR.PURCREQDATE,PR.REQFOR),
			', Qty: ', [dbo].[fnLastPurcQtyPurcRequNew](PRD.CODE,PR.PURCREQDATE,PR.REQFOR),
			', Price: ',[dbo].[fnLastPurcPricePurcRequ](PRD.CODE,PR.PURCREQDATE)) 
		as lastPurcDetails,

		--#### SUPPLIER ####--
		PQ.VENDCODE,
		CONVERT(varchar(50),decryptbypassphrase('icg_developer2009@kol', C.CUSTNAME)) AS VENDOR,
		

		--#### QUOTATION NUMBER ####--
		PQD.PURCQUOTNO,

		--#### PHONE ####--
		CONVERT(varchar(50),decryptbypassphrase('icg_developer2009@kol', C.PHONE)) AS PHONE,
		--CONVERT(varchar(50),decryptbypassphrase('icg_developer2009@kol', PurcQuotationDetails.RATE)) AS RATE,

		--#### RATE ####--
		ROUND(CONVERT(varchar(50),decryptbypassphrase('icg_developer2009@kol', PQD.RATE)), 1 ) AS RATE,

		--#### VALUE ####--
		PRD.QTY*(CONVERT(varchar(50),decryptbypassphrase('icg_developer2009@kol', PQD.RATE))) AS [VALUE],

		--#### TOTAL ####--
		--SUM(PRD.QTY*(CONVERT(varchar(50),decryptbypassphrase('icg_developer2009@kol', PQD.RATE) ))) OVER() AS [Total] 

		--#### REMARKS ####--
		PQ.REMK

	FROM
		PurchaseRequ PR
		INNER JOIN PurchaseRequDetails PRD ON PRD.PURCREQNO=PR.PURCREQNO
		INNER JOIN PurcQuotationDetails PQD ON PQD.PURCREQNO=PRD.PURCREQNO AND PQD.CODE=PRD.CODE
		INNER JOIN PurcQuotation PQ ON PQD.PURCQUOTNO=PQ.PURCQUOTNO
		
		LEFT JOIN OtherItems O ON PRD.CODE=O.CODE 
		LEFT JOIN RawMaterials R ON PRD.CODE=R.CODE 
		LEFT JOIN Machines M ON PRD.CODE = M.CODE  
		LEFT JOIN SpareParts S ON PRD.CODE=S.CODE 
		LEFT JOIN Machines M1 ON PRD.MCH_CODE = M1.CODE 

		LEFT JOIN Strings SO ON O.UOM=SO.IID 
		LEFT JOIN Strings SR ON R.UOM=SR.IID 
		LEFT JOIN Strings SS ON S.UOM=SS.IID 
		
		LEFT JOIN Customers C ON PQ.VENDCODE=C.CODE
		
		--INNER JOIN GRN G ON C.CODE=G.VENDCODE 
		--INNER JOIN GRNdetails GD ON G.GRNNO=GD.GRNNO 
		--INNER JOIN ImportLCDetails ILD ON G.RECEDREFNO=ILD.LCREQNO
		--INNER JOIN ProformaInvoiceDetails PID ON PID.PINO=ILD.PURCPINO
		--INNER JOIN PurcOrder PO ON PID.ORDERNO=PO.PURCORDNO
		--INNER JOIN PurcOrderDetails POD ON PO.PURCORDNO=POD.PURCORDNO
		

	WHERE --COUNT(PQ.VENDCODE)>1 AND
		  PRD.PURCREQNO=@requisitionNo 
	ORDER BY ITEM
	
END
