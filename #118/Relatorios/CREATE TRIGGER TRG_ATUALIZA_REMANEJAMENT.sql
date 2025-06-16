use SANKHYA_TESTE
GO

CREATE TRIGGER  TRG_ATUALIZA_REMANEJAMENTO 
ON sankhya.AD_ROTEIROENTREGA
AFTER INSERT
AS                      
BEGIN
    -- Declaração de variáveis
    DECLARE @NumUnico  INT, @IdRoteiro INT, @DtRoteiro DATETIME
    
    -- Obter informações do novo registro inserido
    SELECT @NumUnico = NUNOTA, @IdRoteiro = ID, @DtRoteiro = DTROTEIRO
    FROM INSERTED
    
    -- Atualizar registros anteriores do mesmo pedido que não foram entregues
    UPDATE sankhya.AD_ROTEIROENTREGA
    SET DATAREMANEJAMENTO = GETDATE()
    WHERE NUNOTA = @NumUnico
      AND DTENTREGACLIENTE IS NULL
      AND (ID <> @IdRoteiro OR DTROTEIRO <> @DtRoteiro)
      AND DATAREMANEJAMENTO IS NULL
END 