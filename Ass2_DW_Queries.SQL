-- PART 8 - QUERIES
-- 8.1
SELECT DWD.DAYNAME AS WEEKDAY, SUM (DWS.QTY * DWS.SALEPRICE) AS "TOTAL SALES"
FROM DWDATE DWD INNER JOIN DWSALE DWS ON DWD.DATEKEY = DWS.SALE_DWDATEID
GROUP BY DAYNAME
ORDER BY "TOTAL SALES" DESC;
/
-- 8.2
SELECT DWC.CUSTCATNAME, SUM(DWS.QTY * DWS.SALEPRICE) AS "TOTAL SALES"
FROM DWCUST DWC INNER JOIN DWSALE DWS ON DWC.DWCUSTID = DWS.DWCUSTID
GROUP BY CUSTCATNAME
ORDER BY "TOTAL SALES" ASC;
/
-- 8.3
SELECT DWP.PRODMANUNAME, SUM(DWS.QTY * DWS.SALEPRICE) AS "TOTAL QTY SOLD"
FROM DWPROD DWP INNER JOIN DWSALE DWS ON DWP.DWPRODID = DWS.DWPRODID
GROUP BY PRODMANUNAME
ORDER BY "TOTAL QTY SOLD" DESC;
/
-- 8.4
SELECT * FROM
    (SELECT DWC.DWCUSTID, DWC.FIRSTNAME, DWC.SURNAME, SUM(DWS.QTY * DWS.SALEPRICE) AS "TOTAL SALES",
    RANK() OVER (ORDER BY SUM(DWS.QTY * DWS.SALEPRICE) DESC) AS QTY_RANK
    FROM DWCUST DWC INNER JOIN DWSALE DWS ON DWS.DWCUSTID = DWC.DWCUSTID
    GROUP BY DWC.DWCUSTID, DWC.FIRSTNAME, DWC.SURNAME
    ORDER BY "TOTAL SALES" DESC)
WHERE ROWNUM <= 10;
/
-- 8.5
SELECT * FROM 
    (SELECT DWP.DWPRODID, DWP.PRODNAME, SUM(DWS.QTY * DWS.SALEPRICE) AS "TOTAL SALES",
    RANK() OVER (ORDER BY SUM(DWS.QTY * DWS.SALEPRICE) ASC) AS QTY_RANK
    FROM DWPROD DWP INNER JOIN DWSALE DWS ON DWS.DWPRODID = DWP.DWPRODID
    GROUP BY DWP.DWPRODID, DWP.PRODNAME
    )
WHERE ROWNUM <= 10
ORDER BY "TOTAL SALES" ASC;
/
-- 8.6
SELECT * FROM 
    (SELECT * FROM (SELECT DWC.STATE, DWC.CITY, SUM(DWS.QTY * DWS.SALEPRICE) AS "TOTAL SALES",
    ROW_NUMBER() OVER (PARTITION BY STATE ORDER BY STATE, SUM(DWS.QTY * DWS.SALEPRICE) DESC ) AS STATE_RANK
    FROM DWCUST DWC INNER JOIN DWSALE DWS ON DWS.DWCUSTID = DWC.DWCUSTID
    GROUP BY DWC.STATE, DWC.CITY)
    )
WHERE STATE_RANK = 1
ORDER BY STATE ASC;



