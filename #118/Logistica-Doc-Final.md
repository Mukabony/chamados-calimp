

# Módulo de Logística - Calimp

## Visão Geral e Objetivo do Módulo

O **Módulo de Logística da Calimp** tem como propósito gerenciar o ciclo de entregas dos pedidos de venda, desde o planejamento das rotas de distribuição até o acompanhamento da execução e possíveis reentregas. Esse módulo é utilizado principalmente pela equipe de logística/expedição – incluindo planejadores de rota e conferentes – e pelos responsáveis pelas entregas (motoristas ou transportadoras parceiras). A importância do módulo é elevada no contexto operacional: ele garante que os pedidos faturados sejam entregues aos clientes de forma eficiente e controlada, fornecendo visibilidade sobre o status de cada entrega e assegurando a qualidade do serviço de distribuição. Em suma, o módulo conecta as áreas de vendas e distribuição, **otimizando rotas**, **monitorando entregas em tempo real** e **tratando exceções** (falhas na entrega, devoluções) para manter altos níveis de satisfação do cliente e cumprimento de prazos.

## Estrutura de Dados e Relacionamentos

A base de dados do módulo de Logística é composta por diversas tabelas que registram as informações de roteirização e entrega. As principais entidades incluem os roteiros de entrega (rotas planejadas), os itens/entregas contidos em cada roteiro (pedidos a serem entregues) e as ocorrências de entrega (tentativas realizadas, sucesso ou insucesso). A seguir descrevemos as tabelas-chave, seus campos mais relevantes e os relacionamentos entre elas:

### Tabela **LOG\_ROTEIRO** (Roteiros de Entrega)

Esta tabela armazena os **roteiros de entrega** planejados, ou seja, cada rota/distribuição programada em uma data. Cada registro corresponde a um roteiro (viagem) que agrupa várias entregas a serem realizadas por um veículo/motorista em um determinado período. Campos principais incluem:

```sql
CREATE TABLE LOG_ROTEIRO (
    ID_ROTEIRO       INT          PRIMARY KEY,   -- Identificador único do roteiro
    DT_ROTEIRO       DATE         NOT NULL,      -- Data prevista da rota de entrega
    ID_MOTORISTA     INT          NOT NULL,      -- Referência ao motorista/entregador (cód. funcionário ou parceiro)
    ID_VEICULO       INT          NULL,          -- Referência ao veículo utilizado na rota
    STATUS           VARCHAR(20)  NOT NULL,      -- Status do roteiro (ex.: PLANEJADO, EM ROTA, CONCLUIDO, etc.)
    QT_ENTREGAS      INT          NOT NULL,      -- Quantidade total de entregas previstas no roteiro
    ID_ORDEM_CARGA   INT          NULL,          -- Chave para Ordem de Carga (no ERP Sankhya, se aplicável)
    OBSERVACAO       VARCHAR(255) NULL           -- Observações gerais sobre o roteiro
    -- ... outros campos ...
);
```

* **Chave primária:** `ID_ROTEIRO` identifica univocamente cada roteiro.
* **Chaves estrangeiras e relacionamentos:** `ID_MOTORISTA` e `ID_VEICULO` referenciam, respectivamente, o cadastro de Motoristas (funcionários ou parceiros logísticos) e Veículos da frota (caso exista tabela ou cadastro de veículos). O campo `ID_ORDEM_CARGA` armazena o identificador da *Ordem de Carga* correspondente no sistema ERP (Sankhya), indicando o vínculo entre o roteiro planejado e o documento de expedição/faturamento gerado. Cada **LOG\_ROTEIRO** possui vários registros associados na tabela de entregas (relação 1\:N com LOG\_ENTREGA).

### Tabela **LOG\_ENTREGA** (Entregas/Pedidos no Roteiro)

Armazena as **entregas individuais** (pedidos) que compõem cada roteiro. Cada registro representa um pedido de cliente incluído no roteiro para entrega. Campos principais incluem:

```sql
CREATE TABLE LOG_ENTREGA (
    ID_ENTREGA    INT    PRIMARY KEY,    -- Identificador único da entrega (item do roteiro)
    ID_ROTEIRO    INT    NOT NULL,       -- Roteiro ao qual esta entrega pertence (FK para LOG_ROTEIRO)
    ID_PEDIDO     INT    NOT NULL,       -- Referência ao pedido/nota fiscal de venda no ERP (Núm. único)
    DESTINATARIO  VARCHAR(100) NOT NULL, -- Nome do cliente ou destinatário
    ENDERECO      VARCHAR(255) NOT NULL, -- Endereço de entrega (extraído do pedido)
    SEQUENCIA     INT    NOT NULL,       -- Ordem sequencial da entrega na rota
    STATUS_ENT    VARCHAR(20) NOT NULL,  -- Status da entrega (PENDENTE, ENTREGUE, NÃO ENTREGUE, etc.)
    TENTATIVAS    INT    NOT NULL,       -- Número de tentativas já realizadas (inicialmente 0)
    DT_ENTREGUE   DATETIME NULL,         -- Data/hora em que a entrega foi concluída (se ENTREGUE)
    MOTIVO_NAO_ENT VARCHAR(100) NULL     -- Motivo da não-entrega (caso falha, opcional)
    -- ... outros campos ...
);
```

* **Chave primária:** `ID_ENTREGA` identifica cada item de entrega. Opcionalmente, poderia ser composta por `(ID_ROTEIRO, SEQUENCIA)` caso a lógica opte por chave composta, mas aqui consideramos um identificador único simples para cada entrega.
* **Chaves estrangeiras:** `ID_ROTEIRO` é **FK** que liga a entrega ao seu roteiro pai em **LOG\_ROTEIRO**. Assim, todas as entregas com o mesmo `ID_ROTEIRO` pertencem à mesma rota/viagem. Além disso, o campo `ID_PEDIDO` refere-se ao identificador do pedido de venda ou nota fiscal correspondente no ERP Sankhya (geralmente o número único da nota, garantindo o vínculo com os sistemas de venda/estoque). Esse relacionamento permite obter detalhes do pedido original (produtos, valor, etc.) a partir do módulo de logística.
* **Relacionamento com ocorrências:** cada entrega pode ter múltiplas ocorrências de tentativa de entrega registradas na tabela **LOG\_OCORRENCIA** (relação 1\:N, detalhada a seguir). O campo `TENTATIVAS` em LOG\_ENTREGA pode armazenar o número de tentativas já realizadas para controle rápido. Campos como `STATUS_ENT` e `DT_ENTREGUE` refletem o resultado final (se entregue com sucesso, por exemplo, `STATUS_ENT = 'ENTREGUE'` e `DT_ENTREGUE` preenchido com a data/hora da conclusão).

### Tabela **LOG\_OCORRENCIA** (Ocorrências de Entrega / Tentativas)

Registra as **ocorrências** de entrega, ou seja, cada tentativa realizada para entregar um determinado pedido. Essa tabela detalha o histórico de tentativas para entregas que não foram concluídas na primeira vez. Campos principais incluem:

```sql
CREATE TABLE LOG_OCORRENCIA (
    ID_OCORRENCIA  INT          PRIMARY KEY,   -- Identificador da ocorrência (tentativa)
    ID_ENTREGA     INT          NOT NULL,      -- Referência à entrega tentada (FK para LOG_ENTREGA)
    NUM_OCORRENCIA INT          NOT NULL,      -- Número sequencial da tentativa para aquela entrega (1ª, 2ª, ...)
    DT_TENTATIVA   DATETIME     NOT NULL,      -- Data e hora em que a tentativa ocorreu
    ENTREGUE       CHAR(1)      NOT NULL,      -- Indicador de sucesso ( 'S' = entregue, 'N' = não entregue )
    OBSERVACAO     VARCHAR(255) NULL           -- Observação/motivo da falha (ex.: "Destinatário ausente")
    -- ... outros campos ...
);
```

* **Chave primária:** `ID_OCORRENCIA` é o identificador único de cada tentativa registrada. (Em alguns projetos, poderia-se usar chave composta `(ID_ENTREGA, NUM_OCORRENCIA)` para garantir unicidade por entrega, porém aqui um ID singular simplifica referências).
* **Chave estrangeira:** `ID_ENTREGA` referencia o item em **LOG\_ENTREGA** ao qual a tentativa se refere. Assim, todas as ocorrências com o mesmo `ID_ENTREGA` correspondem às múltiplas tentativas daquele pedido.
* **Relações e lógica:** Para cada entrega não realizada na primeira tentativa, o sistema gera um registro em LOG\_OCORRENCIA com `ENTREGUE = 'N'` e detalha a data/hora e possivelmente o motivo (em `OBSERVACAO`). Caso a entrega tenha sucesso, registra-se uma ocorrência com `ENTREGUE = 'S'`. O campo `NUM_OCORRENCIA` indica quantas vezes aquela entrega já foi tentada (1 para primeira tentativa, 2 para segunda, etc.), auxiliando no controle de reentregas. As informações daqui alimentam o status consolidado em **LOG\_ENTREGA** (por exemplo, se existe ao menos uma ocorrência entregue com sucesso, o `STATUS_ENT` da entrega é atualizado para ENTREGUE). Se todas as tentativas falharam, o `STATUS_ENT` permanece como **NÃO ENTREGUE** e o pedido pode ser reprogramado em outro roteiro.

**Demais tabelas de apoio:** Além das três tabelas principais acima, o módulo pode se integrar a cadastros existentes no ERP, reutilizando informações de **clientes** (destinatários), **parceiros de transporte** e **funcionários**:

* Os dados de destinatário e endereço vêm do cadastro de parceiros/clientes do ERP (não duplicados no módulo, apenas referenciados em LOG\_ENTREGA).
* Motoristas podem ser cadastrados como funcionários ou parceiros (transportadores); o `ID_MOTORISTA` em LOG\_ROTEIRO apontaria para o identificador correspondente na base de pessoas/funcionários.
* Veículos podem ser gerenciados via uma tabela de frota própria ou via um cadastro genérico. Caso haja tabela de veículos separada, `ID_VEICULO` seria FK para essa tabela (contendo placa, tipo de veículo, etc.).

**Relacionamentos gerais entre tabelas do módulo:** Em resumo, o relacionamento forma uma hierarquia:

* **LOG\_ROTEIRO** (roteiro) – relação 1\:N – **LOG\_ENTREGA** (entregas pertencentes ao roteiro).
* **LOG\_ENTREGA** (entrega) – relação 1\:N – **LOG\_OCORRENCIA** (tentativas dessa entrega).

Adicionalmente, há relações lógicas com tabelas externas ao módulo:

* **LOG\_ROTEIRO** *n*:*1* **Ordem de Carga/Expedição (ERP)**: cada roteiro idealmente corresponde a uma Ordem de Carga no ERP (ou documento de expedição consolidado). Esse vínculo é pelo campo `ID_ORDEM_CARGA`.
* **LOG\_ENTREGA** \*1:*1* **Pedido/Nota Fiscal (ERP)**: cada entrega refere-se a um pedido de venda específico (um para um). Assim, a entrega não é uma entidade autônoma, mas um espelho do pedido dentro do roteiro de logística.
* **LOG\_ROTEIRO** \*n:*1* **Motorista (cadastro)** e \*n:*1* **Veículo (cadastro)**: o roteiro designa um motorista e possivelmente um veículo, associados via IDs a cadastros mestras.

Esses relacionamentos garantem a integridade e possibilitam **joins** úteis para relatórios: por exemplo, é possível relacionar um roteiro com todos os dados dos pedidos e clientes através de `LOG_ENTREGA -> Pedidos/Clientes`, permitindo análises completas (como quais clientes foram atendidos em cada rota, etc.). A lógica de negócio do módulo assegura que **uma entrega não exista sem um roteiro associado** e que **uma ocorrência de entrega não exista sem uma entrega associada**, mantendo consistência referencial (as FK geralmente estão definidas com *ON DELETE CASCADE* para ocorrências, de modo que ao excluir ou reajustar uma entrega, suas tentativas associadas sejam automaticamente tratadas).

## Procedimentos e Funções Principais

O módulo de Logística envolve **procedures (procedimentos armazenados)** no banco de dados e possivelmente **funções** que implementam a lógica operacional, automatizando etapas do processo de entrega. A seguir, destacamos os principais procedimentos e seu papel, bem como como cada um interage com as tabelas descritas:

* **PROC\_MONTAR\_ROTEIRO** – *Montagem de Roteiro*: Este procedimento é responsável por **criar um novo roteiro de entrega** a partir dos pedidos pendentes. Normalmente é invocado quando o usuário seleciona um conjunto de pedidos para expedição (pela tela de *Planejamento de Entrega* no Sankhya, equivalente à montagem de roteiro). A procedure realiza várias ações em sequência:

  * Geração de um novo registro em **LOG\_ROTEIRO** com data, motorista/veículo designados e status inicial (*PLANEJADO* ou *ABERTO*).
  * Inserção de múltiplos registros em **LOG\_ENTREGA** – um para cada pedido selecionado – vinculados ao novo `ID_ROTEIRO`. Os dados de endereço, destinatário e outros detalhes são copiados do pedido de venda original. Inicialmente, cada entrega inserida fica com `STATUS_ENT = 'PENDENTE'` e `TENTATIVAS = 0`.
  * Cálculo da sequência de entregas na rota: pode ordenar as entregas de forma otimizada (por exemplo, por região ou ordem manual definida pelo usuário). A sequence (`SEQUENCIA`) é atribuída a cada **LOG\_ENTREGA** inserida.
  * Atualização de contadores, como `QT_ENTREGAS` no registro do roteiro, para refletir quantos itens há na rota.
  * **Dependências**: Esta procedure alimenta diretamente as tabelas **LOG\_ROTEIRO** e **LOG\_ENTREGA**. Ela pode chamar também funções de geolocalização ou cálculo de distância se houver otimização de rota (por exemplo, integração com API de mapas para ordenar as entregas – ver seção de Integrações). Caso algum pedido já estivesse em outro roteiro ou não esteja apto a ser roteirizado (ex.: já faturado fora do planejamento), a procedure pula ou registra erro conforme a lógica de negócio.

* **PROC\_APROVAR\_ROTEIRO** – *Aprovação/Confirmação do Roteiro*: Após montar o roteiro, esta procedure realiza a **confirmação do roteiro para expedição**. Em muitos casos, a montagem e aprovação podem ocorrer numa mesma ação, mas conceitualmente:

  * Valida se o roteiro está completo e consistente (por exemplo, verifica se todas as entregas possuem nota fiscal pronta para emissão).
  * Realiza a **integração com o ERP** Sankhya para gerar os documentos fiscais ou de expedição correspondentes. Isso pode envolver chamadas a funções internas do ERP ou serviços: por exemplo, gerar as **Notas de Remessa/Faturamento** para cada entrega (caso ainda não tenham sido emitidas), ou gerar uma **Ordem de Carga** consolidando as entregas do roteiro. Muitas vezes, cada pedido já está faturado individualmente; então a aprovação pode simplesmente consolidar a rota e registrar no ERP o agrupamento (populando o campo `ID_ORDEM_CARGA` em **LOG\_ROTEIRO** com o código retornado do ERP).
  * Alterar o `STATUS` do roteiro em **LOG\_ROTEIRO** de *PLANEJADO* para *EM ROTA* (ou *APROVADO*), indicando que o roteiro saiu para entrega. Pode também preencher efetivamente o campo `ID_ORDEM_CARGA`.
  * Dependências: essa procedure lê dados de **LOG\_ROTEIRO** e **LOG\_ENTREGA** (montados previamente) e interage com tabelas do ERP (pedidos/notas). Ela pode atualizar as mesmas tabelas de roteiro e entrega (por exemplo, marcar `STATUS_ENT` de todos como "EM ROTA" ou similar). É comum que essa etapa seja iniciada a partir da *tela Sankhya de Planejamento de Entrega (Tela oficial do ERP)* ao clicar em “aprovar” ou “liberar notas”.

* **PROC\_APONTAR\_ENTREGA** – *Apontamento de Entregas*: Este é o procedimento que **registra o resultado das entregas** realizadas em campo. Pode ser executado entrega por entrega, conforme o motorista retorna ou envia informações, ou em lote após finalizar o roteiro. As funções típicas incluem:

  * Receber como entrada a identificação do pedido ou entrega e um status de resultado (entregue com sucesso, ou não entregue com motivo).
  * Inserir um registro em **LOG\_OCORRENCIA** correspondente à tentativa realizada. Exemplo: se for a primeira tentativa de entrega de um dado `ID_ENTREGA`, insere-se `NUM_OCORRENCIA = 1`, `ENTREGUE = 'S'` ou 'N' conforme o caso, `DT_TENTATIVA` = data/hora atual e `OBSERVACAO` preenchido se houve falha (ex.: "Cliente ausente no local").
  * Atualizar a tabela **LOG\_ENTREGA**: incrementar o contador `TENTATIVAS`, e ajustar o `STATUS_ENT`. Se `ENTREGUE = 'S'`, então marcar `STATUS_ENT = 'ENTREGUE'` e gravar `DT_ENTREGUE`. Se `ENTREGUE = 'N'`, manter ou mudar status para *PENDENTE* ou *NÃO ENTREGUE*, conforme a lógica definida, indicando que será necessária reentrega. Também em caso de falha, possivelmente armazenar o motivo em `MOTIVO_NAO_ENT` para referência rápida.
  * Dependências: atualiza **LOG\_OCORRENCIA** (sempre cria um novo registro) e **LOG\_ENTREGA**. Pode também atualizar **LOG\_ROTEIRO**: por exemplo, se *todas* as entregas de um roteiro foram apontadas (seja entregues ou não entregues), então a procedure pode sinalizar o roteiro como **CONCLUÍDO** ou **FECHADO** no seu `STATUS`. Nesse caso, ela verificaria quantas entregas do roteiro estão pendentes e, ao finalizar a última tentativa, ajustaria o status do roteiro. Além disso, essa procedure potencialmente interage com o ERP para dar baixa nas entregas: se entregue, pode registrar a confirmação de entrega na nota fiscal (por exemplo, liberando a fatura para financeiro); se não entregue, pode sinalizar no ERP a pendência (mas esse detalhe depende de configuração fora do escopo imediato do módulo).

* **PROC\_REAGENDAR\_REENTREGA** – *Reprogramação de Reentrega*: Em algumas implementações, pode haver uma rotina específica para tratar pedidos não entregues e **programar uma reentrega**. Esse procedimento varre entregas com falha em roteiros concluídos e as recoloca em aberto para um próximo roteiro:

  * Identifica todas as entregas marcadas como *NÃO ENTREGUE* em roteiros já finalizados (ou seja, itens que após o apontamento ficaram pendentes).
  * Para cada entrega pendente, pode executar duas ações dependendo do design do sistema:

    1. **Reabrir no mesmo roteiro**: Alterar o status do roteiro para reaberto/prorrogado e permitir uma nova tentativa no mesmo (caso o roteiro seja prolongado para o dia seguinte, por exemplo). Essa abordagem é menos comum.
    2. **Migrar para novo roteiro**: Remover ou clonar as entregas pendentes para um **novo LOG\_ROTEIRO** em data futura. Uma forma prática é considerar que o usuário simplesmente fará uma nova *montagem de roteiro* no dia seguinte e incluirá esses pedidos novamente. Ainda assim, um procedimento pode automatizar isso criando um roteiro de reentrega automaticamente.
  * Em sistemas manuais, essa rotina pode ser substituída por ações do usuário via tela: por exemplo, o usuário abre a tela de planejamento de entrega e insere os pedidos não entregues em um novo planejamento. Mas caso seja automático, esta procedure cuidaria da reatribuição.
  * Dependências: pode inserir novos **LOG\_ROTEIRO** e atualizar **LOG\_ENTREGA** existentes (ou criar novas entregas espelhadas). Também pode gerar notificações ou relatórios de pendências. Importante: se o sistema opta por não duplicar o registro de entrega, a mesma entrada de **LOG\_ENTREGA** permanece e será associada a outro roteiro via atualização de `ID_ROTEIRO` – embora essa prática complique o histórico. Mais comum é deixar o registro no roteiro original marcado como não entregue e criar um **novo registro** de entrega para a reentrega. Entretanto, como essa funcionalidade não está totalmente detalhada nos dados disponíveis, a implementação exata pode variar (ver seção de *Gaps*).

* **Outros procedimentos de apoio**: O módulo pode incluir outras SPs auxiliares, como por exemplo:

  * *PROC\_CALCULA\_KPI\_LOG* – para calcular e atualizar periodicamente indicadores (quantos % entregues, média de tempo, etc., gravando talvez em tabelas de resumo).
  * *Triggers* ou procedures de integração – e.g., uma trigger após inserção em **LOG\_ENTREGA** que automaticamente reserva estoque ou verifica se a nota fiscal existe, etc., ou uma procedure para imprimir os documentos de rota (romaneio).
  * *PROC\_CANCELA\_ROTEIRO* – para eventualmente cancelar um roteiro (por ex, em caso de erro na montagem ou imprevisto antes da saída), que removeria os registros ou marcaria-os como cancelados, liberando os pedidos para outro roteiro. Isso exigiria remoção/cancelamento das entregas e possivelmente anulação das notas fiscais emitidas no ERP.

Cada uma dessas procedures tem seu momento de execução dentro do fluxo operacional (detalhado na próxima seção) e interage com as tabelas do módulo conforme descrito. A correta sequência e dependência entre elas garante que os dados fiquem consistentes – por exemplo, não se pode apontar entregas (`PROC_APONTAR_ENTREGA`) de um roteiro que não foi aprovado para saída, nem aprovar um roteiro (`PROC_APROVAR_ROTEIRO`) sem tê-lo montado com entregas.

## Fluxos de Processos Operacionais

Nesta seção, detalhamos os principais **processos operacionais** suportados pelo módulo de Logística, incluindo a montagem de roteiros, a gestão/execução das entregas propriamente dita, o tratamento de reentregas e outras etapas relevantes. Cada processo corresponde geralmente a um conjunto de ações do usuário nas telas do sistema (Sankhya) e às procedures no backend descritas acima.

### Montagem de Roteiro (Planejamento de Entrega)

A **montagem de roteiro** é o processo inicial onde os pedidos de venda são agrupados em uma rota de entrega. Na prática, o usuário (coordenador de logística) acessa a tela de *Planejamento de Entrega* do ERP Sankhya (tela oficial de montagem de rotas) – que aqui representa a funcionalidade de selecionar pedidos e montar um roteiro. Os passos típicos são:

1. **Seleção de pedidos pendentes:** o sistema lista todos os pedidos prontos para expedição (por exemplo, pedidos faturados ou liberados, ainda não entregues). O usuário filtra por data, região ou prioridade e seleciona aqueles que farão parte da rota. *(Na Sankhya, isso corresponde a escolher notas na tela de Planejamento de Entrega, possivelmente filtrando por empresa, período, etc.)*
2. **Definição de recursos:** o usuário informa qual será o **motorista** responsável e, se aplicável, o **veículo** utilizado. Também define a data/hora de saída prevista e outras observações pertinentes ao roteiro.
3. **Geração do roteiro:** ao confirmar, o sistema cria o roteiro no módulo de logística. Internamente, isso aciona a `PROC_MONTAR_ROTEIRO`, que insere o registro em **LOG\_ROTEIRO** e os respectivos itens em **LOG\_ENTREGA** para cada pedido selecionado. Na interface do ERP, o roteiro agora aparece com um número/código gerado e status inicial (ex.: "Em Edição" ou "Planejado").
4. **Sequenciamento das paradas:** dependendo das funcionalidades disponíveis, o usuário pode ajustar a **ordem das entregas** no roteiro. Por exemplo, ordenando pela rota otimizada (caso haja integração com mapas, o sistema pode sugerir uma sequência ideal) ou manualmente reordenando. Essa sequência será registrada no campo `SEQUENCIA` de **LOG\_ENTREGA**.
5. **Revisão do roteiro:** o usuário verifica se todos os pedidos necessários estão incluídos, se as informações de endereço estão corretas e se a carga total faz sentido (ex.: volume de mercadoria compatível com o veículo). Ajustes podem ser feitos nessa fase, incluindo remover ou adicionar pedidos antes da confirmação final.

Ao término da montagem, o roteiro está **planejado porém não ainda confirmado**. Nenhuma mercadoria foi fisicamente liberada neste ponto – trata-se de um planejamento virtual. Esse processo corresponde inteiramente à preparação dos dados nas tabelas (**LOG\_ROTEIRO** e **LOG\_ENTREGA**) antes da expedição.

*Tela de referência:* **Planejamento de Entrega** do Sankhya (módulo Comercial > Rotinas) – esta é a interface onde ocorre a montagem de roteiro, referenciada geralmente pelo código da tela do ERP. É aqui que os usuários interagem para executar os passos acima.

### Aprovação e Saída para Entrega (Início da Rota)

Uma vez que o roteiro está montado e revisado, o próximo passo é **aprovar/iniciar a rota de entrega**. Operacionalmente, isso significa autorizar a saída do veículo com as mercadorias e emitir os documentos fiscais necessários. Os principais subpassos incluem:

* **Emissão de documentos fiscais:** se ainda não tiverem sido emitidas, este é o momento de gerar as **notas fiscais de remessa** ou de saída para os itens do roteiro. Em muitos casos, os pedidos já vêm faturados do módulo de vendas; se assim for, cada entrega já possui uma nota fiscal vinculada (`ID_PEDIDO` apontando para uma nota). Alternativamente, se o processo da empresa prevê faturar *após* planejar a rota, então a aprovação do roteiro disparará a emissão em lote dessas notas fiscais. De qualquer forma, o sistema ERP garante que cada entrega tenha um documento fiscal legal antes de sair para transporte.
* **Geração da Ordem de Carga:** o ERP Sankhya utiliza o conceito de **Ordem de Carga** (ou conhecimento de transporte interno) para consolidar entregas. Ao aprovar o roteiro, o sistema cria essa ordem (um código único) relacionando todas as notas do roteiro. Esse código é registrado em `ID_ORDEM_CARGA` na tabela **LOG\_ROTEIRO** para referência. A Ordem de Carga serve como identificação fiscal/logística da rota (usada em filtros e no apontamento de entrega posteriormente).
* **Separação e conferência:** fora do sistema, mas no fluxo físico, a equipe de expedição separa os produtos de cada pedido e carrega o veículo de acordo com o roteiro. O módulo de logística pode imprimir um **Romaneio de Carga** ou lista de entregas para auxiliar na conferência. Esse romaneio é essencialmente um relatório listando todas as entregas (pedidos, clientes, endereços, volumes) do roteiro, que o motorista leva consigo.
* **Mudança de status:** no momento em que tudo está pronto e o veículo sai da empresa, o roteiro é marcado como **EM ROTA** (ou *Em Entrega*). Isso é refletido no campo `STATUS` de **LOG\_ROTEIRO**. As entregas em **LOG\_ENTREGA** também podem ser atualizadas para um status intermediário como "SAIU PARA ENTREGA". Essa mudança de status geralmente é automática na aprovação do roteiro via `PROC_APROVAR_ROTEIRO`.
* **Início da contagem de tempo:** se o sistema rastreia tempo de rota, pode gravar o horário de saída efetivo. Esse dado pode ser armazenado em **LOG\_ROTEIRO** (ex.: campos de horário de saída e previsão de retorno) para cálculo de indicadores posteriormente.

*Neste ponto, do ponto de vista do sistema, o roteiro está ativo.* As tabelas contêm os dados necessários, e os documentos fiscais estão emitidos no ERP. O motorista tem em mãos as notas fiscais e o romaneio (impressos ou em aplicativo) e inicia as entregas conforme a sequência planejada.

### Execução e Gestão das Entregas

Durante a execução da rota, o principal processo é **realizar as entregas** em si e registrar seus resultados. O módulo de logística apoia esse acompanhamento em tempo quase real ou posterior, dependendo das ferramentas disponíveis (pode haver integração com aplicativo móvel ou o registro pode ocorrer quando o motorista retorna):

* **Entrega bem-sucedida:** Para cada parada onde a entrega é realizada com sucesso (cliente recebeu os produtos, nota fiscal assinada, etc.), deve-se registrar a conclusão:

  * Se houver um **aplicativo móvel** integrado: o motorista confirma a entrega no app, que envia a informação diretamente para o sistema (atualizando o status no banco). Caso contrário, o motorista traz de volta os comprovantes e um usuário do escritório faz o apontamento manual.
  * A confirmação insere uma ocorrência em **LOG\_OCORRENCIA** com `ENTREGUE = 'S'` e registra data/hora. Como é a última (e única necessária) ocorrência daquela entrega, a mesma já é definitiva.
  * O registro aciona a `PROC_APONTAR_ENTREGA`, que atualiza o `STATUS_ENT` para **ENTREGUE** e coloca a data real da entrega (`DT_ENTREGUE`). Esse status pode ser imediatamente visível em dashboards ou consultas, permitindo que atendimento ao cliente informe a entrega realizada.
  * Opcionalmente, pode-se registrar alguma observação (ex.: "Entregue a recepcionista do condomínio").

* **Tentativa de entrega fracassada:** Em casos nos quais não se consegue entregar (exemplos: cliente ausente, endereço incorreto, veículo impedido de acessar a área, etc.), a ocorrência é registrada como falha:

  * O motorista ou usuário registra a **não entrega**, selecionando ou digitando um motivo (por exemplo, "Destinatário ausente" ou código predefinido se houver tabela de motivos de insucesso).
  * A `PROC_APONTAR_ENTREGA` insere uma **LOG\_OCORRENCIA** com `ENTREGUE = 'N'`, incrementando o contador de tentativas. O `STATUS_ENT` da entrega permanece *PENDENTE* ou muda para um status específico como *AGUARDANDO REENTREGA*. O campo `MOTIVO_NAO_ENT` em **LOG\_ENTREGA** pode ser preenchido com a descrição do motivo, para fácil referência.
  * Nenhuma data de entrega é preenchida ainda, já que não houve conclusão. O sistema agora reflete que aquele pedido não foi entregue e precisará de nova tentativa. No dashboard de acompanhamento do dia, essa entrega apareceria como *pendente reentrega*.
  * Importante: se ainda restam outras entregas no roteiro, o motorista prossegue para as próximas. A falha em uma entrega não cancela o roteiro.

* **Comunicação em tempo real:** Caso haja integração online (por exemplo, o motorista utiliza um aplicativo com internet móvel), os status podem ser atualizados ao longo do dia no sistema. Isso permite que a equipe de logística acompanhe a rota em andamento, vendo quais entregas já foram concluídas e quais estão pendentes. Se não houver tal integração, o apontamento é realizado retrospectivamente, quando o veículo retorna.

* **Atualização do roteiro:** Ao longo da execução, cada vez que uma entrega é apontada (com sucesso ou falha), a quantidade de entregas pendentes no roteiro diminui. Quando *todas* as entregas de um roteiro receberam apontamento (S ou N), o sistema poderá marcar automaticamente o **fechamento do roteiro**:

  * Se pelo menos uma entrega ficou não entregue, o roteiro pode ficar com um status final especial, como **CONCLUÍDO C/ PENDÊNCIAS**.
  * Se todas foram entregues, status **CONCLUÍDO** (ou *Finalizado*).
  * Um campo de resumo no **LOG\_ROTEIRO** (não exemplificado acima, mas possível) poderia registrar quantas entregas foram efetivamente realizadas vs planejadas.

Durante essa fase de execução, a área de logística lida também com imprevistos: por exemplo, se um veículo quebrar ou se um cliente ligar pedindo alteração. Essas situações geralmente são tratadas manualmente (reagendamento ou troca de roteiro emergencial), mas podem gerar alterações no módulo: ex., remanejar uma entrega para outro roteiro se o original não puder completar – o que seria feito via cancelamento parcial de um roteiro e inclusão em outro.

*Tela de referência:* **Apontamento de Entrega** do Sankhya (módulo Comercial > Rotinas) – essa tela permite selecionar a Ordem de Carga/roteiro e inserir ocorrências de entrega. Cada linha representando um item de entrega tem campos para indicar se foi entregue, data/hora e observações. Essa é a interface típica para o processo de apontamento manual.

### Reentrega (Nova Tentativa de Entrega)

**Reentrega** refere-se ao processo de tentar novamente entregar pedidos que falharam na primeira passagem. Esse é um ponto crítico para assegurar que todos os pedidos sejam eventualmente finalizados ou retornados. O módulo de logística trata reentregas da seguinte maneira:

* Após um roteiro ser concluído com entregas pendentes (não entregues), esses pedidos permanecem marcados como pendentes no sistema (no seu registro de **LOG\_ENTREGA**, `STATUS_ENT` não indica sucesso). Eles também terão pelo menos uma ocorrência registrada indicando a tentativa anterior.
* No planejamento do próximo dia (ou na próxima rota possível), a equipe de logística **inclui os pedidos pendentes em um novo roteiro**. Isso pode ser feito manualmente: na tela de Planejamento de Entrega, filtrando por pedidos não entregues e criando um novo roteiro de reentrega. O sistema facilita ao mostrar que aqueles pedidos já tiveram tentativas anteriores (possivelmente exibindo o número de tentativas ou a situação "Reentrega").
* Ao montar o novo roteiro de reentrega, duas abordagens podem ocorrer dependendo da implementação do sistema:

  1. **Entregas permanecem no mesmo registro:** O sistema pode reutilizar o mesmo registro de **LOG\_ENTREGA** e simplesmente associá-lo a um novo `ID_ROTEIRO`. Isso exigiria atualizar o campo de FK (o que não é comum, pois quebraria o histórico do roteiro anterior). É mais provável que essa não seja a abordagem utilizada devido à integridade referencial já que a entrega estava vinculada ao roteiro antigo.
  2. **Nova entrada de entrega:** O sistema cria um *novo* registro em **LOG\_ENTREGA** para o novo roteiro, apontando para o mesmo `ID_PEDIDO`. Neste caso, o pedido X que falhou no roteiro 10, agora reaparece no roteiro 12 como um novo item. Para fins de controle, pode haver um vínculo lógico dizendo que o item do roteiro 12 é uma reentrega do item do roteiro 10. Essa relação, se necessária, poderia ser explicitada via um campo (ex: `ID_ENTREGA_ORIGINAL`) ou simplesmente deduzida pelo mesmo `ID_PEDIDO`.
* Em ambos os casos, o registro de **LOG\_OCORRENCIA** anterior permanece como histórico. Na segunda tentativa, quando a entrega for finalmente realizada, uma nova ocorrência será criada e o pedido então marcado como entregue.
* É importante salientar que *não há duplicação de nota fiscal*: a mesma nota emitida inicialmente continua válida para a reentrega, a menos que um processo de devolução/faturamento novamente seja acionado. Normalmente, empresas tentam a reentrega com a mesma nota fiscal dentro de um certo prazo. O sistema deve garantir que essas notas em aberto permaneçam disponíveis para nova saída.
* **Processo automatizado (se previsto):** Caso a empresa deseje automatizar a criação de roteiros de reentrega, o procedimento `PROC_REAGENDAR_REENTREGA` (mencionado anteriormente) pode ser agendado para rodar no fim do dia. Ele criaria automaticamente novos roteiros para o dia seguinte contendo todas as entregas pendentes do dia atual, atribuindo a um motorista padrão ou sinalizando para planejamento. Se isso não for implementado, cabe ao usuário manualmente replanejar as entregas pendentes.
* **Atualização de tentativas:** Cada vez que um pedido vai para reentrega, o contador de tentativas (`TENTATIVAS` em LOG\_ENTREGA) é atualizado. Isso permite monitorar quantas vezes foi necessário tentar entregar aquele pedido. Políticas internas podem decidir, por exemplo, que após 2 ou 3 tentativas sem sucesso, o pedido retorna ao centro de distribuição para contato com o cliente ou cancelamento. Nesse caso, uma entrega com tentativas excedidas pode ter um status final definido como **DEVOLVIDO** ou **CANCELADO**, retirando-o do fluxo de novas reentregas.
* **Retorno ao estoque (devolução):** Se após as tentativas combinadas o pedido não pôde ser entregue e é cancelado, o módulo de logística deve se articular com o ERP para tratar a devolução: isto pode envolver entrada de estoque dos produtos de volta e cancelamento da nota fiscal original. Esses passos geralmente são externos ao módulo de logística (feitos via processos de devolução no ERP), mas são consequência de um fluxo de entrega mal-sucedido. Do ponto de vista dos dados logísticos, aquele registro de entrega pode ser marcado com um status final *DEVOLVIDO* e não mais considerado pendente de entrega.

Em suma, a reentrega garante uma **segunda passagem estruturada** para pedidos não atendidos, evitando que itens fiquem esquecidos. O sistema de logística fornece visibilidade de quais pedidos estão nessa condição e suporta sua reprogramação em novas rotas até uma resolução (entrega ou retorno).

### Fechamento e Controle Final do Roteiro

Após todas as entregas de um roteiro terem algum desfecho (entregues ou não entregues), procede-se ao **fechamento** desse roteiro no sistema:

* O fechamento consolida os resultados: o sistema pode calcular automaticamente quantas entregas foram bem sucedidas e quantas falharam. Esses dados podem ser gravados em campos de controle ou ao menos ser obtidos via consulta/relatório.
* Nenhuma ação adicional é necessária no banco de dados além de marcar o `STATUS` do **LOG\_ROTEIRO** como **CONCLUÍDO** (ou similar). Isso serve para indicar que não haverá mais movimentações naquele roteiro. Idealmente, a tela de apontamento de entrega do Sankhya marca a ordem de carga como finalizada.
* Em termos de integração, ao fechar o roteiro, pode-se notificar o módulo de vendas ou financeiro caso haja implicações (por ex., liberar a comissão do vendedor se dependia da confirmação da entrega, ou sinalizar para faturamento que aquele ciclo terminou).
* **Indicadores de desempenho** são atualizados ou calculados com base no roteiro concluído: por exemplo, tempo total do roteiro (diferença entre hora de saída e hora de finalização), percentual de sucesso, etc., que alimentarão os KPIs.

Nesse ponto, o ciclo de vida do roteiro se encerra no módulo de logística, e qualquer entrega pendente remanescente teria sido transferida para outro roteiro (reentrega) ou cancelada. Todo o histórico permanece registrado nas tabelas, permitindo auditoria posterior.

## Relatórios e Dashboards Disponíveis

O módulo de Logística da Calimp gera informações valiosas que são utilizadas em relatórios operacionais e gerenciais. A seguir estão alguns **relatórios e dashboards** importantes derivados dos dados do módulo:

* **Relatório de Roteiros Pendentes/Em Aberto:** lista todos os roteiros que ainda não foram concluídos, mostrando data de saída, motorista responsável, número de entregas pendentes e percentual já entregue. Esse relatório ajuda a supervisão a acompanhar rotas em andamento ou atrasadas.
* **Relatório de Entregas Não Realizadas:** foca nas entregas que falharam. Apresenta para cada pedido não entregue: cliente, endereço, data da tentativa, motivo da não entrega e previsão de reentrega (se já programada). Auxilia a identificar gargalos ou motivos recorrentes de falhas.
* **Romaneio de Carga (lista de entregas por roteiro):** um relatório operacional utilizado pelo motorista contendo todos os detalhes do roteiro. Além de servir no campo, ao retornar pode ser conferido para verificar se todas as entregas foram efetuadas ou justificar as pendências. Geralmente inclui campos como assinatura do cliente, observações, etc., e pode ser emitido via sistema a partir das tabelas do módulo.
* **Dashboard de Acompanhamento Diário:** um painel que mostra, em tempo real ou próximo disso, o progresso das entregas do dia. Exemplos de métricas exibidas: quantos roteiros já saíram, quantos estão em trânsito, quantos já fechados; número de entregas concluídas vs pendentes naquele dia; destaque para entregas atrasadas ou críticas. Esse dashboard consolida informações de **LOG\_ROTEIRO** (status) e **LOG\_ENTREGA**.
* **Relatório de Performance por Motorista/Veículo:** consolida dados de entregas realizadas por cada motorista em um período. Itens como número de roteiros realizados, % de entregas concluídas na primeira tentativa, média de entregas por dia, ocorrências de falhas. Permite avaliar eficiência individual e da frota.
* **Relatório de Tempo de Entrega e Atrasos:** cruzando horários planejados vs realizados (se o sistema captar horas), este relatório mostra a duração de cada roteiro, identifica roteiros que demoraram além do previsto e calcula o tempo médio por entrega. Isso pode apontar necessidade de ajustes de planejamento ou problemas operacionais.
* **Dashboard de KPIs Logísticos:** (ver seção seguinte) possivelmente um painel gerencial mensal com indicadores chaves – taxa de sucesso, reentregas, etc. – comparando com metas.

Muitos desses relatórios podem ser obtidos via consultas SQL sobre as tabelas do módulo integradas com tabelas do ERP. Por exemplo, um relatório customizado pode juntar **LOG\_ENTREGA** com o cadastro de clientes para listar informações de cidade/região, permitindo ver desempenho por região. O importante é que o módulo provê os dados estruturados para tais análises.

Vale notar que alguns relatórios (especialmente operacionais como romaneio e acompanhamento diário) podem estar implementados diretamente nas telas do ERP (Sankhya), exibindo as informações de **LOG\_ROTEIRO** e **LOG\_ENTREGA** filtradas. Outros, como dashboards gerenciais, podem ser realizados via ferramentas de BI extraindo dados dessas tabelas periodicamente.

## KPIs Operacionais Relacionados

A utilização eficaz do módulo de Logística possibilita o acompanhamento de diversos **Indicadores de Performance (KPIs)** ligados à distribuição. Alguns dos principais KPIs monitorados incluem:

* **Taxa de Entrega na Primeira Tentativa:** porcentagem de entregas concluídas com sucesso na primeira visita ao cliente. Este KPI é calculado como = (número de entregas entregues de primeira / total de entregas realizadas) \* 100. Uma taxa alta indica eficiência na roteirização e qualidade de informação de endereço/cliente.
* **Índice de Reentregas:** mede a parcela de pedidos que exigiram pelo menos uma reentrega. Relacionado ao anterior, pode ser medido como = (número de entregas com 2ª tentativa ou mais / total de entregas) \* 100. Uma taxa elevada acende alerta para problemas de logística ou qualidade de dados (endereços errados, clientes ausentes com frequência, etc.).
* **Lead Time de Entrega (Tempo Médio de Entrega):** tempo médio desde a saída do depósito até a efetiva entrega no cliente. Pode ser medido por roteiro ou por pedido. Por exemplo, média de horas por roteiro, ou média de horas por entrega (considerando cada parada). Esse indicador ajuda a entender se as rotas estão equilibradas e qual o tempo de ciclo de entrega.
* **Entregas Realizadas vs. Planejadas:** número de entregas realmente feitas no período comparado ao número de entregas planejadas/incluídas nos roteiros. Isso mostra eficiência diária; se há muitas não realizadas, pode indicar saturação da rota ou imprevistos.
* **Quantidade de Entregas por Rota:** métrica operacional que avalia quantos pedidos em média são entregues por roteiro (ou por veículo) por dia. Relaciona-se com produtividade da frota.
* **Tempo Médio de Roteiro:** duração média de um roteiro (desde saída até retorno). Esse KPI auxilia no planejamento de janelas de entrega e utilização da frota. Valores muito altos sugerem rotas extensas ou lentas (possivelmente precisam ser subdivididas).
* **Percentual de Roteiros Concluídos no Prazo:** se houver horário alvo de retorno ou de conclusão, pode-se medir quantos roteiros retornam conforme previsto. Esse indicador avalia a pontualidade global da operação.
* **Satisfação do Cliente com Entrega:** embora seja qualitativo e capturado possivelmente via pesquisas externas, o módulo de logística influencia esse KPI. Entregas no prazo e completas resultam em melhor satisfação.

Os KPIs acima são acompanhados através dos dados capturados no módulo: por exemplo, os campos de data/hora de saída e entrega permitem calcular tempos; os status e ocorrências distinguem primeira ou segunda tentativa. Caso o sistema registre esses KPIs automaticamente, pode haver tabelas ou funções específicas para consolidá-los diariamente. Do contrário, extrações para uma planilha ou BI calculam-nos a partir das tabelas **LOG\_ROTEIRO**, **LOG\_ENTREGA** e **LOG\_OCORRENCIA**.

A monitoração regular desses indicadores permite à Calimp **identificar oportunidades de melhoria** na logística, como rotas que poderiam ser reorganizadas, necessidades de treinamento de motoristas (se uma equipe apresenta mais falhas que outra) ou investimentos em atualização de endereços de clientes para reduzir reentregas.

## Sequenciamento de Processos e Dependências

Para compreender claramente como as partes do módulo interagem, a seguir é apresentado o **sequenciamento típico dos processos** e as dependências entre procedures, tabelas e etapas operacionais:

1. **Inserção de Pedidos no Sistema de Vendas:** *(Pré-requisito, fora do módulo de logística)* – O ciclo inicia com pedidos de venda sendo criados e faturados no ERP Sankhya (módulo Comercial). Uma vez faturados, esses pedidos tornam-se **elegíveis para entrega**. Dependência: os pedidos devem estar disponíveis (status apropriado no ERP) para serem capturados na logística. Nenhuma tabela do módulo de logística é afetada aqui ainda.
2. **Planejamento/Montagem do Roteiro:** – O usuário de logística seleciona pedidos e executa a montagem (via tela de Planejamento de Entrega). Isso aciona a `PROC_MONTAR_ROTEIRO`.
   **Dependências e efeitos:** `PROC_MONTAR_ROTEIRO` lê a lista de pedidos elegíveis do ERP (consulta nas tabelas de pedidos/notas do Sankhya) e então **insere** registros em **LOG\_ROTEIRO** (1 registro) e **LOG\_ENTREGA** (vários registros, um por pedido).
   **Sequência:** Esse é o primeiro ponto de entrada de dados no módulo. A procedure deve ser executada antes de qualquer outra do fluxo, pois cria as bases para as próximas etapas. Se esta etapa não ocorre ou falha, não há roteiro para aprovar nem entregas para apontar.
3. **Aprovação do Roteiro e Geração de Documentos:** – Ao confirmar o roteiro para expedição, a `PROC_APROVAR_ROTEIRO` é chamada.
   **Dependências:** requer que o roteiro tenha sido montado (passo 2 completo) e que os pedidos estejam prontos para emissão de documentos.
   **Efeitos:** `PROC_APROVAR_ROTEIRO` **atualiza** o registro em **LOG\_ROTEIRO** (ex.: define `STATUS = 'EM ROTA'`, preenche `ID_ORDEM_CARGA`). Ela também interage com o ERP: para cada entrega em **LOG\_ENTREGA**, pode chamar rotinas do ERP para emitir notas ou simplesmente validar que as notas existem. Após sucesso, o ERP gera um registro de Ordem de Carga e retorna seu ID, que é salvo.
   **Sequência:** Esta procedure deve ocorrer após a montagem; é logicamente dependente dos dados gerados no passo 2. Somente após a aprovação é que as entregas podem sair do armazém.
4. **Execução das Entregas / Apontamento:** – Durante e após a rota, para cada entrega tenta-se atualizar seu status via `PROC_APONTAR_ENTREGA`.
   **Dependências:** exige que o roteiro esteja em andamento ou concluído e que os registros **LOG\_ENTREGA** existam (passo 2), e tipicamente que a Ordem de Carga esteja definida (passo 3), pois na tela de apontamento seleciona-se a ordem correspondente.
   **Efeitos:** cada chamada de `PROC_APONTAR_ENTREGA` **insere** um novo registro em **LOG\_OCORRENCIA** e **atualiza** o correspondente **LOG\_ENTREGA** (campos `STATUS_ENT`, `TENTATIVAS`, etc.). Pode também atualizar **LOG\_ROTEIRO** indiretamente quando encerra o último item.
   **Sequência:** essas chamadas podem ocorrer iterativamente, na medida em que as entregas são realizadas. A última entrega apontada possivelmente dispara a conclusão do roteiro. Essa procedure depende logicamente do roteiro ter sido aprovado (embora tecnicamente registros poderiam ser inseridos antes da aprovação, isso não faria sentido no fluxo – o sistema normalmente bloqueia apontamentos em roteiros não liberados).
5. **Fechamento do Roteiro:** – O fechamento em si pode ser implícito (ocorre quando todas entregas são apontadas) ou explícito (usuário aciona um comando de fechar rota).
   **Dependências:** requer que todas as entregas do roteiro tenham algum apontamento (realizado via step 4).
   **Efeitos:** `STATUS` em **LOG\_ROTEIRO** é alterado para *CONCLUÍDO*. Se houver uma procedure dedicada, ela poderia ser chamada aqui (por ex., `PROC_FECHA_ROTEIRO` que verifica completude e fecha). Caso contrário, a própria `PROC_APONTAR_ENTREGA` final ou um trigger poderia fazer isso automaticamente.
   **Sequência:** passo final do fluxo normal de um roteiro; ocorre após todos os apontamentos.
6. **Identificação de Pendências e Reentrega:** – Após o fechamento, caso existam entregas não realizadas (`STATUS_ENT` pendente em algum registro de **LOG\_ENTREGA**), inicia-se o sub-fluxo de reentrega.
   **Dependências:** roteiro original concluído com pendências.
   **Efeitos:** pode acionar `PROC_REAGENDAR_REENTREGA` (se automatizada) ou depender de nova montagem manual (voltando ao passo 2, agora com esses pedidos pendentes). Em ambos os casos, novos registros de **LOG\_ROTEIRO**/**LOG\_ENTREGA** serão gerados para as reentregas. Note que o pedido original continua existindo, portanto o sistema evita duplicidade conferindo que não se crie entrega duplicada sem necessidade – normalmente filtra pedidos já entregues ou já em outro roteiro.
   **Sequência:** esse passo alimenta um *novo ciclo* (volta ao passo 2 com um novo roteiro). A dependência fundamental é que há um registro de entrega não entregue marcando a necessidade de reentrega.
7. **Atualização de KPIs e Logs:** – Em paralelo ou ao término do dia, rotinas de consolidação podem ser executadas.
   **Dependências:** precisam dos dados de entrega atualizados (passos 4-6 completos ou em andamento).
   **Efeitos:** cálculos de KPIs, geração de relatórios finais do dia, ou backup de logs. Muitas empresas rodam, por exemplo, no final do expediente, um procedimento que coleta dados de todos roteiros do dia e salva em uma tabela de histórico diário resumido (usada para dashboards). Isso poderia ser uma procedure que faz SELECTs em **LOG\_ROTEIRO/ENTREGA/OCORRENCIA** e INSERT em alguma tabela de KPIs agregados. Embora não seja um passo "operacional" visível, é uma dependência para a camada de BI/relatórios.

Em termos de **ordem de execução**, os procedimentos apresentam dependências bem definidas:

* `PROC_MONTAR_ROTEIRO` → (dados para) `PROC_APROVAR_ROTEIRO` → (depois, paralelamente) múltiplas execuções de `PROC_APONTAR_ENTREGA` → eventual `PROC_REAGENDAR_REENTREGA` se necessário.

Cada procedure popula ou lê determinadas tabelas, e muitas vezes subsequentes procedures esperam que campos específicos tenham sido preenchidos pelos anteriores (por exemplo, `PROC_APONTAR_ENTREGA` espera que `ID_ROTEIRO` tenha uma Ordem de Carga associada para permitir seleção na interface, ou que as notas fiscais existam).

Além disso, **sequenciamento transacional**: geralmente, a montagem do roteiro e aprovação podem ocorrer dentro de uma mesma transação se acionadas juntas, mas costumam ser separadas para permitir revisão. Já o apontamento de entregas ocorre transação por transação por entrega (ou lote, dependendo da interface). É importante que falhas em uma etapa não corrompam dados das outras – por isso há integridade referencial forte e muitas vezes validações no código das procedures (ex.: não deixar aprovar roteiro sem entregas, não deixar apontar entrega que já foi entregue etc.).

Esse mapa de dependências garante que o processo flua corretamente. Em caso de qualquer interrupção (por exemplo, se a procedure de montagem falhar no meio), o sistema deve possibilitar correção (rollback da transação, nenhuma tabela fica parcialmente preenchida). Da mesma forma, se um apontamento falha (ex.: erro de usuário), deve ser possível refazer sem comprometimento dos dados.

## Gaps e Oportunidades de Melhoria

Durante a análise do módulo de Logística, foram identificados alguns **gaps** (lacunas de informação ou funcionalidades não claras) e pontos de atenção. Abaixo listamos esses gaps juntamente com sugestões de melhoria para cada um, visando aprimorar tanto o entendimento do sistema quanto sua performance e usabilidade:

* **Gap:** Falta de **documentação detalhada do processo de reentrega** – não está completamente claro, nos dados fornecidos, como o sistema decide pela criação de um novo roteiro de reentrega ou reutilização do registro original, e como se dá a interação com o faturamento em caso de múltiplas tentativas. **Sugestão:** Documentar formalmente o fluxo de reentrega, incluindo exemplos de uso (por exemplo, “Pedido X falhou no Roteiro 10 e foi reagendado no Roteiro 12”) e definir claramente as regras de negócio (quantas tentativas antes de devolução, quem autoriza cancelamento). Envolver tanto a equipe funcional quanto técnica para mapear este processo e inserir comentários no código das procedures pertinentes para referência futura.

* **Gap:** **Campos e tabelas sem descrição funcional** – Alguns campos nas tabelas (por exemplo, `MOTIVO_NAO_ENT` em **LOG\_ENTREGA** ou certos status possíveis) não possuem descrição no material, deixando dúvidas sobre seus possíveis valores e uso. **Sugestão:** Elaborar um dicionário de dados do módulo Logística, listando cada tabela, campo, tipo de dado e uma descrição do seu significado e domínio de valores. Isso melhorará o entendimento técnico e auxiliará na manutenção. Publicar esse dicionário internamente, possivelmente anexando-o a este documento.

* **Gap:** **Procedures sem visibilidade do código ou não documentadas** – Foram mencionados procedimentos (como `PROC_REAGENDAR_REENTREGA` ou triggers de integração) cujo funcionamento não está claro, possivelmente por não haver documentação ou comentários no código fonte disponível. **Sugestão:** Realizar um *code review* das principais procedures do módulo e adicionar comentários explicando a lógica de cada bloco, especialmente em partes complexas como critérios de seleção de pedidos ou integração com ERP. Se possível, criar uma documentação técnica anexa com fluxogramas simplificados de cada procedure. Isso facilita o trabalho de futuros desenvolvedores e reduz a dependência de conhecimento tácito.

* **Gap:** **Integração com ERP e impacto financeiro pouco esclarecidos** – Não há detalhes de como o módulo lida com a atualização do ERP em casos como devolução de mercadoria (pedido não entregue) ou mesmo confirmação de entrega para fins financeiros. Por exemplo, permanece a dúvida se o sistema registra automaticamente uma devolução após X dias sem entrega ou se notifica o financeiro para crédito. **Sugestão:** Mapear todas as integrações do módulo de logística com outros módulos (Vendas, Financeiro, Estoque) e documentar as responsabilidades. Por exemplo: "Ao marcar uma entrega como não entregue e cancelar o pedido, o responsável deve efetuar a devolução no ERP manualmente" – se for manual, registrar esse procedimento operacional. Se for automático, documentar qual rotina cuida disso. A melhoria aqui é evitar **zonas cinzentas** de responsabilidade entre módulos, garantindo que para cada cenário (entrega feita, entrega falhou) haja um procedimento definido e conhecido.

* **Gap:** **Ausência de indicadores de performance automatizados** – Embora os KPIs tenham sido identificados, não está claro se há ferramentas ou queries prontas para obtê-los diretamente do banco. Isso pode levar a análises manuais demoradas. **Sugestão:** Desenvolver **dashboards integrados** ou relatórios dentro do próprio ERP que calculem esses KPIs diariamente. Por exemplo, criar uma tela ou relatório Sankhya que mostre a % de entregas na primeira tentativa no mês corrente, extraindo os dados de LOG\_OCORRENCIA. Alternativamente, gerar uma rotina em SQL ou BI para compilar esses números periodicamente. Automatizar a coleta de KPIs melhora o acompanhamento e torna mais rápida a identificação de problemas na operação.

* **Gap:** **Possíveis problemas de performance em rotas com muitos registros** – Se um roteiro contiver um número muito grande de entregas (por exemplo, dezenas ou centenas de pedidos), é preciso avaliar se as procedures estão eficientes. Não há indicação de índices além das PKs, e consultas filtrando por status ou por motorista podem ficar lentas em alto volume. **Sugestão:** Fazer uma análise de performance no banco: garantir que há índices nas colunas usadas para filtro e junção (por ex., índice em `ID_ROTEIRO` dentro de **LOG\_ENTREGA** e em `ID_ENTREGA` dentro de **LOG\_OCORRENCIA**). Verificar também se procedures como `PROC_MONTAR_ROTEIRO` utilizam cursores ou loops desnecessários – possivelmente refatorar para operações em lote (set-based). Se identificado gargalo, implementar melhorias como índices adicionais ou otimização de SQL (ex.: junções com tabelas do ERP usando views otimizadas).

* **Gap:** **Funcionalidades adicionais não implementadas** – Durante o levantamento, percebemos oportunidades de funcionalidades não exploradas, como rastreamento de posição do veículo em tempo real, notificações automáticas para clientes, entre outras, que não são mencionadas na documentação atual. **Sugestão:** Avaliar a viabilidade de integrar **tecnologia de rastreamento/GPS** ao módulo (por exemplo, capturando coordenadas via aplicativo do motorista para mostrar progresso do roteiro no mapa). Implementar também **notificações proativas** ao cliente (via e-mail/SMS) informando status da entrega – isso aproveitaria os dados de LOG\_ENTREGA e melhoraria a percepção de serviço. Embora sejam melhorias de escopo maior, vale registrá-las como evolução possível alinhada às melhores práticas de logística.

Em resumo, as melhorias propostas buscam **preencher lacunas de documentação**, **esclarecer processos obscuros**, e **potencializar o módulo** tanto em termos de entendimento quanto de funcionalidades e desempenho. Abordar esses pontos tornará o módulo de Logística da Calimp mais robusto, transparente e eficaz no suporte à operação diária. Cada gap resolvido contribuirá para reduzir erros operacionais, facilitar treinamentos de novos usuários e melhorar os indicadores logísticos da empresa como um todo.
