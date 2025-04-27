--Items

SELECT 
		I.heID IID,
		I.heCode, 
		I.heName AS Item,
		I.heRefNumber,
		AC.heName AS LogisticCategory,
		MU.heName AS Monada,
		VT.heName AS FPA,
		S.heID AS SID,
		S.heName AS Supplier,
		BR.heName AS Brand,
		CNTR.heName AS Country,
		CI1.heName AS Category1,
		CI2.heName AS Category2
FROM heItems I
LEFT JOIN heItemAccCategories AC ON AC.heID = I.heIAccID
LEFT JOIN heSuppliers S ON S.heID = I.heSPLRID
LEFT JOIN heVATClasses VT ON VT.heID = I.heVTCLID
LEFT JOIN heMeasurementUnits MU ON MU.heID = I.heAmsntID
LEFT JOIN heBrands BR ON BR.heID = I.heBRNDID
LEFT JOIN heCountries CNTR ON CNTR.heID = I.heCNTRID
LEFT JOIN heCategoriesItem CI1 ON CI1.heID = I.heCat01ID
LEFT JOIN heCategoriesItem CI2 ON CI2.heID = I.heCat02ID
WHERE I.heCompID = @$System$CurCompany AND I.heType = '0'
@$UserPart1$

---------------------------------------------------------------------------------------

--Items (with Balance)

SELECT 	I.heCode ,
		I.heName,
		I.heID,
		I.heDetailedDescr,
		CI1.heName AS CAT1,
		CI2.heName AS CAT2,
		BR.heName AS BRAND,
		S.heName AS SPLR,
		S.heID AS SPLRID,
		ISNULL(A.BAL,0) AS BALANCE
FROM heItems I
LEFT Join (
sELECT HEITEMID,SUM(HEABALANCE) AS BAL 
FROM heItemAccumulators A  
WHERE YEAR(A.HEDATE)=YEAR(@$System$CurFiscalYearStart) 
GROUP BY HEITEMID
) A ON A.heItemID = I.heID
LEFT JOIN heBrands BR On I.heBrndID = BR.heID 
LEFT JOIN heCategoriesItem CI1 ON I.heCat01ID = CI1.heID
LEFT JOIN heCategoriesItem CI2 ON I.heCat02ID = CI2.heID
LEFT JOIN heSuppliers S ON I.heSplrID = S.heID
WHERE I.heCompID=@$System$CurCompany AND I.HETYPE=0
@$UserPart1$

---------------------------------------------------------------------------------------

--Items (with Balance, even Row Numbers)

SELECT * FROM(
SELECT 
	ROW_NUMBER() OVER (ORDER BY I.heName) AS RowNum,
	I.heCode AS Code,
	I.heName AS Name,
	ISNULL(A.BAL, 0) AS Balance
FROM heItems I
LEFT JOIN (
	SELECT HEITEMID, SUM(HEABALANCE) AS BAL 
	FROM heItemAccumulators A  
	WHERE YEAR(A.HEDATE) = YEAR(@$System$CurFiscalYearStart) 
	GROUP BY HEITEMID
) A ON A.HEITEMID = I.heID
WHERE I.heCompID = @$System$CurCompany AND I.HETYPE = 0
) AS ItemData
WHERE RowNum % 2 = 0

---------------------------------------------------------------------------------------

--Receipt

SELECT
	DE.heID AS DocID,
	FT.heName AS Name,  
	DE.heDocNum AS Number, 
	DE.heDocCode AS Code, 
	DE.heRefDocCode AS ReCode, 
	DE.heOfficialDate AS Date,
	CU.heName AS Customer,
	CU.heID AS CustomerID,
	A1.heName AS Seller,
	A2.heName AS Agent,
	A1.heID AS SellerID,
	A2.heID AS AgentID,
	FL.heTValue AS Value,
	CASE FL.heLineType
		WHEN 0 THEN 'Cash'
		WHEN 1 THEN 'CreditCard'
		WHEN 2 THEN 'Bank'
		WHEN 3 THEN 'Bank Account'
		ELSE CR.heName
	END AS Payment
FROM heFinDocTypes FT
LEFT JOIN heFinancialEntries FE ON  FT.heID = FE.heFndtID 
LEFT JOIN heDocEntries DE ON FE.heDentID = DE.heID 
LEFT JOIN heFentLines FL ON FE.heID = FL.heFentID
LEFT JOIN heCustomers CU ON CU.heID = FE.heCSTMID
LEFT JOIN heAgents A1 ON FL.heAgntID = A1.heID 
LEFT JOIN heAgents A2 ON FL.heCollAgntID = A2.heID
LEFT JOIN heCreditCards CR ON  FL.heCrcrID = CR.heID
WHERE DE.heDcsrType = 3 AND FT.heCompID = @$System$CurCompany
@$UserPart1$
AND ((@$Parameter01$ IS  NOT NULL AND DE.HEOFFICIALDATE>=@$Parameter01$) OR @$Parameter01$ IS NULL)
AND ((@$Parameter02$ IS  NOT NULL AND DE.HEOFFICIALDATE<=@$Parameter02$) OR @$Parameter02$ IS NULL)

---------------------------------------------------------------------------------------

--Sale's Document

SELECT 
    E.HEDOCCODE,
	E.HEREFNUMBER,
    E.HEOFFICIALDATE,
    E.HEISPRINTED,
    S.HECODE AS SeriesCode,
    S.HENAME AS SeriesName,
    CU.HENAME AS CustomerName,
    P.HENAME AS PaymentMethodName,
	DT.HEITEMSALLOWED AS Items
FROM HEDOCENTRIES E
INNER JOIN HEDOCSERIES S ON E.HEDCSRID = S.HEID
INNER JOIN HECOMMERCIALENTRIES C ON E.HEID = C.HEDENTID
INNER JOIN HECUSTOMERBRANCHES CB ON C.HESHIPTOCSTMID = CB.HECSTMID 
    AND C.HESHIPTOCSBRID = CB.HEID 
    AND C.HECOMPID = CB.HECOMPID
INNER JOIN HECUSTOMERS CU ON CB.HECSTMID = CU.HEID 
    AND CB.HECOMPID = CU.HECOMPID
INNER JOIN HEPAYMENTMETHODS P ON P.HEID = C.HEPMMTID
INNER JOIN HECOMMDOCTYPES DT ON DT.HECOMPID = C.HECOMPID
	And DT.HEID = C.HECMDTID
WHERE E.HECOMPID = @$System$CurCompany AND E.HEDCSRTYPE = '0'
@$UserPart1$

---------------------------------------------------------------------------------------

--Customers

SELECT 
    HEC.HECODE, 
    HEC.HENAME,
    HEC.HEID,
    HEC.HETRACID,
    heProfessions.HENAME AS ProfessionName
FROM heCustomers HEC
INNER JOIN heTraders ON HEC.heTrdrID = heTraders.heID
INNER JOIN heContacts ON heTraders.heCntcID = heContacts.heID
INNER JOIN heProfessions ON heContacts.hePrfsID = heProfessions.heID
WHERE HEC.HECOMPID=@$System$CurCompany
@$UserPart1$

---------------------------------------------------------------------------------------

--Customers and Suppliers (grouping)

SELECT * FROM(
SELECT
    COALESCE(heCustomers.heCode, heSuppliers.heCode) AS Code,
    COALESCE(heCustomers.heName, heSuppliers.heName) AS Name,
    CASE
        WHEN heCustomers.heCode IS NOT NULL AND heCustomers.heName IS NOT NULL THEN 'Customer'
        WHEN heSuppliers.heCode IS NOT NULL AND heSuppliers.heName IS NOT NULL THEN 'Supplier'
        ELSE NULL
    END AS Type
FROM heTraderFinData TRDR
LEFT JOIN heCustomerBranches ON TRDR.heTrbrID = heCustomerBranches.heTrBrID 
AND TRDR.heCstmID = heCustomerBranches.heCstmID 
AND TRDR.heTrdrID = heCustomerBranches.heTrdrID 
LEFT JOIN heCustomers ON heCustomerBranches.heCstmID = heCustomers.heID 
LEFT JOIN heSupplierBranches ON TRDR.heTrbrID = heSupplierBranches.heTrBrID 
AND TRDR.heSplrID = heSupplierBranches.heSplrID 
AND TRDR.heTrdrID = heSupplierBranches.heTrdrID 
LEFT JOIN heSuppliers ON heSupplierBranches.heSplrID = heSuppliers.heID
INNER JOIN heCompanyBranches ON TRDR.heCmbrID = heCompanyBranches.heID
WHERE heCompanyBranches.heCompID = @$System$CurCompany
@$UserPart1$
) AS Combined
@$WUserPart1$

---------------------------------------------------------------------------------------

--Customer's Address

SELECT 
		CSTM.heName AS Name,
		ISNULL(CT.HENAME,TRBR.heCity) AS CITY, 
		TRBR.heStreet, 
		TRBR.hePrefecture, 
		TRBR.heStreetNumber, 
		TRBR.hePostalCode, 
		CNTR.heName 
From heCustomers CSTM
INNER JOIN HECUSTOMERBRANCHES CSBR ON CSTM.HEID=CSBR.HECSTMID
INNER JOIN heTraderBranches TRBR ON CSBR.HETRBRID = TRBR.heID AND TRBR.HEPRIMARY=1 
LEFT JOIN HECITIES CT ON TRBR.HECITIID=CT.HEID
LEFT JOIN heCountries CNTR ON TRBR.heCntrID = CNTR.heID
WHERE CSTM.heCompID = @$System$CurCompany

---------------------------------------------------------------------------------------

--Items' Quantity

select HENAME,sum(qty) as qty from (
SELECT 
	D.HEID AS DOCID,
	I.HEID AS ITEMID,
	CU.HEID AS CUSID,
	I.HENAME,
	D.HEDOCCODE AS DOCCODE,
	D.HEOFFICIALDATE AS DOCDATE,
	CU.HENAME AS CUSTOMERNAME,
	ITETRN.HESALQTYSIGN*CL.HEAQTY AS QTY,
	WH.HENAME AS WAREHOUSE

FROM HEDOCENTRIES D
INNER JOIN HECOMMERCIALENTRIES C ON C.HEDENTID = D.HEID
INNER JOIN HECENTLINES CL ON CL.HEDENTID = D.HEID
INNER JOIN HEITEMTRANS ITETRN ON ITETRN.HECENLID=CL.HEID
INNER JOIN HECOMPWAREHOUSES WH On C.HECBWHID = WH.HEID
INNER JOIN HECUSTOMERS CU ON C.HEBILLCSTMID = CU.HEID 
INNER JOIN HEITEMS I ON CL.HEITEMID = I.HEID

WHERE D.HECOMPID = @$System$CurCompany AND ITETRN.HESALQTYSIGN<>0
@$UserPart1$
) vv
group by 
HENAME

---------------------------------------------------------------------------------------

--Sales

SELECT 
		DE.heID AS EntryID,
		DE.heRefNumber AS RefNumber,
		DS.heName AS Name,
		DE.heDocCode AS Code,
		DE.heDocNum AS Number,
		CU.heID AS CustomerID,
		CU.heName AS Customer,
		TB.heName AS CustomerBranch,
		DE.heOfficialDate AS Date,
		CB.heName AS CompanyBranch,
		WH.heName AS Warehouse,
		PM.heName AS Payment,
		I.heID AS ItemID,
		I.heName AS Item,
		CL.heAQTY AS Quantity,
		CL.hePrice AS Price,
		CL.heTGrossval AS Before,
		CL.heBGrossVATVal AS FPAValue,
		CL.heTTotalVal AS Total,
		ISNULL(A.BAL,0) AS BALANCE
FROM heDocEntries DE

LEFT JOIN heDocSeries DS ON DS.heID = DE.heDCSRID
LEFT JOIN heCompanyBranches CB ON CB.heID = DE.heCMBRID
LEFT JOIN heCommercialEntries CE ON CE.heDentID = DE.heID
LEFT JOIN heCompWarehouses WH ON WH.heID = CE.heCBWHID
LEFT JOIN heCustomers CU ON CU.heID = CE.heBillCSTMID
LEFT JOIN heCustomerBranches CUB ON CUB.heID = CE.heBillCSBRID
LEFT JOIN heTraders TR ON TR.heID = CU.heTrdrID
LEFT JOIN heTraderBranches TB ON CUB.heTrBrID = TB.heID
LEFT JOIN hePaymentMethods PM ON PM.heID = CE.hePmmtID
LEFT JOIN heCentLines CL ON CL.heCentID = CE.heID
LEFT JOIN heItems I ON I.heID = CL.heItemID

LEFT JOIN (
SELECT HEITEMID,SUM(HEABALANCE) AS BAL 
FROM heItemAccumulators A  
WHERE YEAR(A.HEDATE)=YEAR(@$System$CurFiscalYearStart) 
GROUP BY HEITEMID
) A ON A.heItemID = I.heID

WHERE DE.heCompID = @$System$CurCompany
@$UserPart1$

---------------------------------------------------------------------------------------

--Top Customers

SELECT TOP(10)
		C.heName AS Name, 
		A.heBTurnover AS Total
FROM heTraderAccumulators A
INNER JOIN heCustomerBranches B ON A.heTrbrID = B.heTrBrID AND A.heCstmID = B.heCstmID AND A.heTrdrID = B.heTrdrID 
INNER JOIN heCustomers C ON B.heCstmID = C.heID
WHERE C.heCompID = @$System$CurCompany
ORDER BY Total DESC

---------------------------------------------------------------------------------------

--Filters

SELECT TOP 100 HEID,ITEMCODE,ITEMNAME,SALESAQTY FROM (
select 
[ITTR].[HEITEMID], 
[ITEMS].[HEID],
[ITEMS].[HECODE] [ITEMCODE], 
[ITEMS].[HENAME] [ITEMNAME], 
Sum(Ittr.heSalQtySign  * Ittr.heAQty) [SALESAQTY], 
Sum(Ittr.heBilledSalQtySign * Ittr.heAQty)  [BILLEDAQTY], 
Sum(ITTR.HEPENDSALORDERQTYSIGN  * ITTR.HEAPENDSALORDERQTY) [PENDAQTY], 
Sum(Ittr.heSalValSign  * Ittr.heSalValue) [SALESVALUE]
 
from [HEITEMTRANS] [ITTR] 
inner join [HEITEMS] [ITEMS] 
on ([ITTR].[HEITEMID] = [ITEMS].[HEID]) 
inner join [HECOMMERCIALENTRIES] [CENT] 
on ([ITTR].[HECENTID] = [CENT].[HEID]) 
inner join [HECUSTOMERS] [CSTM] 
on ([CENT].[HEBILLCSTMID] = [CSTM].[HEID])
 
where (([ITEMS].[HEKIND] = 0 or [ITEMS].[HEKIND] =3) and ([ITEMS].[HETYPE] =0 or [ITEMS].[HETYPE] = 1)) 
AND ITTR.HECOMPID=@$System$CurCompany
AND ITTR.HEDATE>=DATEADD(month, -4, GETDATE())
@$UserPart1$
group by [ITTR].[HEITEMID],[ITEMS].[HECODE], [ITEMS].[HENAME], [ITEMS].[HEID]
having Sum(Ittr.heSalQtySign  * Ittr.heAQty) <>0
) VV
ORDER BY SALESAQTY DESC