USE SANKHYA_TESTE;
GO

-- CTE 1: DadosBase - Replicar os JOINs principais e os filtros iniciais da WHERE clause
-- Isso garante que começamos com o conjunto base de linhas que se qualificam pelos JOINs e filtros iniciais.
WITH DadosBase AS (
    SELECT
        RE.NUNOTA,
        RE.TIPMOV,
        RE.DTROTEIRO,
        RE.PREVENTREGA,
        RE.DTTRANSPORTADORA,
        RE.DTENTREGACLIENTE,
        RE.PARCEIRO,
        RE.TRANSPORTADORA,
        RE.OBSERVACAO,
        CAB.NUNOTA AS CAB_NUNOTA, -- NUNOTA da TGFCAB, usado para o JOIN principal
        CAB.CODVEND,
        PAR.CODPARC,
        ISNULL(PAR.AD_PZOTRANSPORTE, 0) AS PZO_ENTREGA_PAR -- Mantém o nome original do campo para compatibilidade
    FROM
        sankhya.AD_ROTEIROENTREGA AS RE
    JOIN
        sankhya.TGFCAB AS CAB ON RE.NUNOTA = CAB.NUNOTA
    JOIN
        sankhya.TGFPAR AS PAR ON CAB.CODPARC = PAR.CODPARC
    WHERE
        CONVERT(DATE, RE.DTROTEIRO) >= '01/06/2024' -- Manter o formato original para evitar alteração de linhas
        AND CONVERT(DATE, RE.DTROTEIRO) < CONVERT(DATE, GETDATE())
        AND RE.DTENTREGACLIENTE IS NULL
),
-- CTE 2: CalculosData - Isolar os cálculos de datas exatamente como na query original
-- E aplicar o filtro final de DIAS_ATRASO. Isso é CRÍTICO para manter as 832 linhas.
CalculosData AS (
    SELECT
        DB.NUNOTA,
        DB.TIPMOV,
        DB.DTROTEIRO,
        DB.PREVENTREGA,
        DB.DTTRANSPORTADORA,
        DB.PARCEIRO,
        DB.TRANSPORTADORA,
        DB.OBSERVACAO,
        DB.CODVEND,
        DB.PZO_ENTREGA_PAR,
        DB.CAB_NUNOTA, -- Passar a NUNOTA da TGFCAB principal
        -- Cálculo de DT_PREVISTA_CLIENTE exatamente como na original
        ((CASE WHEN (DB.DTTRANSPORTADORA IS NULL) THEN DB.DTROTEIRO ELSE DB.DTTRANSPORTADORA END)
         + DB.PZO_ENTREGA_PAR) AS DT_PREVISTA_CLIENTE_CALC,
        -- Cálculo de DIAS_ATRASO exatamente como na original
        CONVERT(INT, (CONVERT(DATETIME, CONVERT(DATE, GETDATE())) -
                      ((CASE WHEN (DB.DTTRANSPORTADORA IS NULL) THEN DB.DTROTEIRO ELSE DB.DTTRANSPORTADORA END)
                       + DB.PZO_ENTREGA_PAR))) AS DIAS_ATRASO_CALC
    FROM
        DadosBase AS DB
    WHERE
        CONVERT(INT, (CONVERT(DATETIME, CONVERT(DATE, GETDATE())) -
                      ((CASE WHEN (DB.DTTRANSPORTADORA IS NULL) THEN DB.DTROTEIRO ELSE DB.DTTRANSPORTADORA END)
                       + DB.PZO_ENTREGA_PAR))) >= 5 -- Filtro final de DIAS_ATRASO
),
-- CTE 3: DetalhesNotas - Lidar com N_NOTA e DT_EMISSAO usando OUTER APPLY para simular as subconsultas
-- Isso permite a flexibilidade de retornar NULL sem descartar a linha, e o otimizador pode lidar com OUTER APPLY diferente.
DetalhesNotas AS (
    SELECT
        CD.NUNOTA,
        CD.TIPMOV,
        CD.DTROTEIRO,
        CD.PREVENTREGA,
        CD.DTTRANSPORTADORA,
        CD.PARCEIRO,
        CD.TRANSPORTADORA,
        CD.OBSERVACAO,
        CD.CODVEND,
        CD.PZO_ENTREGA_PAR,
        CD.DT_PREVISTA_CLIENTE_CALC,
        CD.DIAS_ATRASO_CALC,
        -- N_NOTA e DT_EMISSAO via OUTER APPLY para simular a subconsulta condicional
        COALESCE(NotaV.NUMNOTA, NotaOutras.NUMNOTA) AS N_NOTA,
        COALESCE(NotaV.DTNEG, NotaOutras.DTNEG) AS DT_EMISSAO
    FROM
        CalculosData AS CD
    OUTER APPLY (
        -- Para TIPMOV = 'V'
        SELECT CAB.NUMNOTA, CAB.DTNEG
        FROM sankhya.TGFCAB AS CAB
        WHERE CAB.NUNOTA = CD.NUNOTA AND CD.TIPMOV = 'V'
    ) AS NotaV
    OUTER APPLY (
        -- Para TIPMOV <> 'V'
        SELECT CAB.NUMNOTA, CAB.DTNEG
        FROM sankhya.TGFCAB AS CAB
        WHERE CAB.NUNOTA = (SELECT TOP(1) VAR.NUNOTA FROM sankhya.TGFVAR AS VAR WHERE VAR.NUNOTAORIG = CD.NUNOTA)
    ) AS NotaOutras
),
-- CTE 4: DadosFinais - Lidar com a subconsulta de REPRESENTANTE via OUTER APPLY
DadosFinais AS (
    SELECT
        DN.NUNOTA,
        DN.TIPMOV,
        DN.DTROTEIRO,
        DN.PREVENTREGA,
        DN.DTTRANSPORTADORA,
        DN.PARCEIRO,
        DN.TRANSPORTADORA,
        DN.OBSERVACAO,
        DN.CODVEND, -- CODVEND vem da TGFCAB principal do roteiro
        DN.PZO_ENTREGA_PAR,
        DN.DT_PREVISTA_CLIENTE_CALC,
        DN.DIAS_ATRASO_CALC,
        DN.N_NOTA,
        DN.DT_EMISSAO,
        LTRIM(RTRIM(VEN.APELIDO)) + ' - ' + CONVERT(VARCHAR, VEN.CODVEND) AS REPRESENTANTE -- Construção da string do representante
    FROM
        DetalhesNotas AS DN
    OUTER APPLY (
        SELECT V.APELIDO, V.CODVEND
        FROM sankhya.TGFVEN AS V
        WHERE V.CODVEND = DN.CODVEND
    ) AS VEN
)
-- Consulta Final: Seleção dos campos e ORDER BY
SELECT
    DF.N_NOTA AS 'N_NOTA',
    DF.DT_EMISSAO AS 'DT_EMISSAO',
    DF.DTROTEIRO AS 'DT_ROTEIRO',
    DF.PREVENTREGA AS 'PREV_ENTREGA',
    DF.DTTRANSPORTADORA AS 'DT_ENTREGA_TRANSPORTADORA',
    DF.PZO_ENTREGA_PAR AS 'PZO_ENTREGA',
    DF.DT_PREVISTA_CLIENTE_CALC AS 'DT_PREVISTA_CLIENTE',
    DF.DIAS_ATRASO_CALC AS 'DIAS_ATRASO',
    CONVERT(DATE, GETDATE()) AS 'DT_HOJE',
    LTRIM(RTRIM(DF.PARCEIRO)) AS 'PARCEIRO',
    DF.REPRESENTANTE AS 'REPRESENTANTE',
    LTRIM(RTRIM(DF.TRANSPORTADORA)) AS 'TRANSPORTADORA',
    REPLACE(REPLACE(LTRIM(RTRIM(CONVERT(VARCHAR(MAX), DF.OBSERVACAO))), CHAR(13) + CHAR(10), ''), CHAR(10), '') AS 'OBSERVACAO'
FROM
    DadosFinais AS DF
ORDER BY
    DF.DIAS_ATRASO_CALC DESC, DF.N_NOTA;