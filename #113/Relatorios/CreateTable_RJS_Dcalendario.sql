-- Cria��o da tabela

CREATE TABLE sankhya.RJS_DCALENDARIO (
    DATA DATE PRIMARY KEY,
    DIA_SEMANA VARCHAR(20),
    MES INT,
    ANO INT,
    FINAL_DE_SEMANA BIT
);

-- Definir domingo como primeiro dia da semana (opcional)
SET DATEFIRST 7;

-- Declara��o da vari�vel de data
DECLARE @data DATE = '20240101';

-- Loop de inser��o
WHILE @data <= '20301231'
BEGIN
    INSERT INTO sankhya.RJS_DCALENDARIO (
        DATA,
        DIA_SEMANA,
        MES,
        ANO,
        FINAL_DE_SEMANA
    )
    VALUES (
        @data,
        FORMAT(@data, 'dddd', 'pt-BR'),         -- Nome do dia em portugu�s
        MONTH(@data),
        YEAR(@data),
        CASE 
            WHEN DATEPART(WEEKDAY, @data) IN (1, 7) THEN 1  -- Domingo ou S�bado
            ELSE 0 
        END
    );

    -- Pr�ximo dia
    SET @data = DATEADD(DAY, 1, @data);
END;


USE SANKHYA_PRODUCAO select * from sankhya.RJS_DCALENDARIO