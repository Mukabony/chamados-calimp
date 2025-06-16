## Solicitação de Adequações no Sistema de Acompanhamento de Roteiro

### Contexto
Na tela de acompanhamento de roteiro, frequentemente é necessário remanejar notas fiscais para outro roteiro, principalmente quando a entrega não é concluída conforme o planejado.

### Requisitos

1. **Criação de Coluna “Data de Remanejamento”**
   - Incluir uma nova coluna chamada **Data de Remanejamento** na tela de acompanhamento de roteiro.
   - Esta data deve ser registrada automaticamente sempre que um pedido for incluído manualmente em um roteiro, caso o mesmo já conste em um roteiro de dias anteriores.
   - **Observação:** Não deve ser permitida a edição manual dessa data pelo usuário.

2. **Ajuste no Relatório de Entregas Atrasadas**
   - Notas fiscais que possuírem uma **Data de Remanejamento** registrada não devem ser consideradas como pendentes nos relatórios de entrega atrasada.
   - Elas devem ser consideradas apenas na data em que o remanejamento foi gravado.

---

## Informações Técnicas Relevantes (Tabela AD_ROTEIRO)

Abaixo estão os principais pontos do documento `sankhya_AD_ROTEIRO.md` que serão úteis para a solução deste chamado:

### Estrutura da Tabela `AD_ROTEIRO`
- **Campos principais:**
  - `ID` (int, parte da chave primária)
  - `DTROTEIRO` (datetime, parte da chave primária)
  - `STATUS` (varchar(10))
  - `ENTREGUE` (varchar(10))
  - `DTCRIACAO` (datetime)
- Esses campos mostram onde adicionar a nova coluna `DATA_REMANEJAMENTO` para controlar a data de remanejamento de notas fiscais.

### Relacionamentos e Uso
- **Relacionamento com `AD_ROTEIROENTREGA`:** Importante para implementar o controle de remanejamento.
- **Usado por Telas Customizadas:** Tela 9999990075 (Roteiro) e Gadget 256 (Entregas x Notas) utilizam esta tabela, indicando onde a nova coluna e regras devem ser aplicadas.

### Relatórios e Consultas
- **Exemplo de Query SQL:** O documento traz exemplos de consultas utilizadas nos relatórios, que servirão de base para ajustar a lógica de exclusão de notas remanejadas dos relatórios de atrasos.

### Considerações Técnicas
- **Chave primária composta:** Alterações devem respeitar a PK (`ID`, `DTROTEIRO`).
- **Modelo permite inclusão de novos campos** sem impacto em constraints além da PK.

### Resumo do que aproveitar
- Adicionar a coluna `DATA_REMANEJAMENTO` na tabela `AD_ROTEIRO`.
- Atualizar a tela customizada (9999990075) para exibir a nova coluna, bloqueando edição manual.
- Modificar as queries dos relatórios (especialmente as do Gadget 256) para considerar a nova regra de exclusão de notas fiscais remanejadas dos relatórios de atraso.
- Usar o relacionamento com `AD_ROTEIROENTREGA` para identificar notas/pedidos remanejados.