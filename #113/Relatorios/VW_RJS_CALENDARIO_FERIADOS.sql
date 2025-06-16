CREATE OR ALTER VIEW sankhya.VW_RJS_CALENDARIO_FERIADOS AS

--************************************************************************
-- Data de criacao: 16/06/2025		Criado por: Wellington Albuquerque
-- Observacao: View criada para ser usada nos relatorios que calculam dias uteis e atrasos desconsiderando feriados e final de semana
--************************************************************************

SELECT
    C.DATA,
    C.DIA_SEMANA,
    C.MES,
    C.ANO,
    C.FINAL_DE_SEMANA,
    F.DESCRFERIADO,
    F.NACIONAL,
    F.CODUF,
    F.CODCID
FROM sankhya.RJS_DCALENDARIO C
LEFT JOIN sankhya.TSIFER F
    ON F.DTFERIADO = C.DATA



	select * from sankhya.VW_RJS_CALENDARIO_FERIADOS