use SANKHYA_TESTE
GO

SELECT
CASE WHEN (AD_ROTEIROENTREGA.TIPMOV= 'V') THEN
(SELECT NF.NUMNOTA FROM sankhya.TGFCAB NF
WHERE NF.NUNOTA= AD_ROTEIROENTREGA.NUNOTA)
ELSE (SELECT NF.NUMNOTA FROM sankhya.TGFCAB NF WHERE NF.NUNOTA=
(SELECT TOP(1) TGFVAR.NUNOTA
FROM sankhya.TGFVAR WHERE NUNOTAORIG= AD_ROTEIROENTREGA.NUNOTA)) END AS 'N_NOTA',
CASE WHEN (AD_ROTEIROENTREGA.TIPMOV= 'V') THEN
(SELECT NF.DTNEG FROM sankhya.TGFCAB NF
WHERE NF.NUNOTA= AD_ROTEIROENTREGA.NUNOTA)
ELSE (SELECT NF.DTNEG FROM sankhya.TGFCAB NF WHERE NF.NUNOTA=
(SELECT TOP(1) TGFVAR.NUNOTA
FROM sankhya.TGFVAR WHERE NUNOTAORIG= AD_ROTEIROENTREGA.NUNOTA)) END AS 'DT_EMISSAO',
AD_ROTEIROENTREGA.DTROTEIRO AS 'DT_ROTEIRO',
AD_ROTEIROENTREGA.PREVENTREGA AS 'PREV_ENTREGA',
AD_ROTEIROENTREGA.DTTRANSPORTADORA AS 'DT_ENTREGA_TRANSPORTADORA',
ISNULL(TGFPAR.AD_PZOTRANSPORTE,0) AS 'PZO_ENTREGA',
((CASE WHEN (AD_ROTEIROENTREGA.DTTRANSPORTADORA IS NULL)
THEN AD_ROTEIROENTREGA.DTROTEIRO ELSE AD_ROTEIROENTREGA.DTTRANSPORTADORA END)
+ ISNULL(TGFPAR.AD_PZOTRANSPORTE,0)) AS 'DT_PREVISTA_CLIENTE',
CONVERT(INT,(CONVERT(DATETIME,CONVERT(DATE,GETDATE())) -
((CASE WHEN (AD_ROTEIROENTREGA.DTTRANSPORTADORA IS NULL)
THEN AD_ROTEIROENTREGA.DTROTEIRO ELSE AD_ROTEIROENTREGA.DTTRANSPORTADORA END)
+ ISNULL(TGFPAR.AD_PZOTRANSPORTE,0)))) AS 'DIAS_ATRASO',
CONVERT(DATETIME,CONVERT(DATE,GETDATE())) AS 'DT_HOJE',
'VCTO_BOLETO'= (SELECT TOP(1) TGFFIN.DTVENC FROM sankhya.TGFFIN
WHERE TGFFIN.NUNOTA= (CASE WHEN (AD_ROTEIROENTREGA.TIPMOV= 'V') THEN
(SELECT NF.NUNOTA FROM sankhya.TGFCAB NF
WHERE NF.NUNOTA= AD_ROTEIROENTREGA.NUNOTA)
ELSE (SELECT NF.NUNOTA FROM sankhya.TGFCAB NF WHERE NF.NUNOTA=
(SELECT TOP(1) TGFVAR.NUNOTA
FROM sankhya.TGFVAR WHERE NUNOTAORIG= AD_ROTEIROENTREGA.NUNOTA)) END)
ORDER BY TGFFIN.DTVENC),
LTRIM(RTRIM(AD_ROTEIROENTREGA.PARCEIRO)) AS 'PARCEIRO',
'REPRESENTANTE'= (SELECT LTRIM(RTRIM(V.APELIDO))+' - '+CONVERT(VARCHAR,V.CODVEND)
FROM sankhya.TGFVEN V WHERE V.CODVEND= TGFCAB.CODVEND),
LTRIM(RTRIM(AD_ROTEIROENTREGA.TRANSPORTADORA)) AS 'TRANSPORTADORA',
(REPLACE(REPLACE(LTRIM(RTRIM(CONVERT(VARCHAR(MAX),AD_ROTEIROENTREGA.OBSERVACAO)))
, CHAR(13) + CHAR(10), ''), CHAR (10), '')) AS 'OBSERVACAO'

FROM sankhya.AD_ROTEIROENTREGA
JOIN sankhya.TGFCAB ON (sankhya.AD_ROTEIROENTREGA.NUNOTA= sankhya.TGFCAB.NUNOTA)
JOIN sankhya.TGFPAR ON (sankhya.TGFCAB.CODPARC= sankhya.TGFPAR.CODPARC)

WHERE CONVERT(DATE,AD_ROTEIROENTREGA.DTROTEIRO) >= '01/06/2024'
AND CONVERT(DATE,AD_ROTEIROENTREGA.DTROTEIRO) < CONVERT(DATE,GETDATE())
AND AD_ROTEIROENTREGA.DTENTREGACLIENTE IS NULL
AND (CONVERT(INT,(CONVERT(DATETIME,CONVERT(DATE,GETDATE())) -
((CASE WHEN (AD_ROTEIROENTREGA.DTTRANSPORTADORA IS NULL) THEN AD_ROTEIROENTREGA.DTROTEIRO ELSE AD_ROTEIROENTREGA.DTTRANSPORTADORA END)
+ ISNULL(TGFPAR.AD_PZOTRANSPORTE,0))))) > 0

ORDER BY 8 DESC, 1