<?xml version="1.0" encoding="utf-16"?>
<ShowPlanXML xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" Version="1.539" Build="15.0.2130.3" xmlns="http://schemas.microsoft.com/sqlserver/2004/07/showplan">
  <BatchSequence>
    <Batch>
      <Statements>
        <StmtUseDb StatementCompId="1" StatementId="1" StatementText="use SANKHYA_TESTE&#xD;&#xA;" StatementType="USE DATABASE" RetrievedFromCache="false" Database="[SANKHYA_TESTE]" />
      </Statements>
    </Batch>
    <Batch>
      <Statements>
        <StmtSimple StatementCompId="1" StatementEstRows="24138.2" StatementId="1" StatementOptmLevel="FULL" CardinalityEstimationModelVersion="120" StatementSubTreeCost="256.617" StatementText="&#xD;&#xA;SELECT&#xD;&#xA;CASE WHEN (sankhya.AD_ROTEIROENTREGA.TIPMOV= 'V') THEN&#xD;&#xA;(SELECT NF.NUMNOTA FROM sankhya.TGFCAB NF&#xD;&#xA;WHERE NF.NUNOTA= sankhya.AD_ROTEIROENTREGA.NUNOTA)&#xD;&#xA;ELSE (SELECT NF.NUMNOTA FROM sankhya.TGFCAB NF WHERE NF.NUNOTA=&#xD;&#xA;(SELECT TOP(1) sankhya.TGFVAR.NUNOTA&#xD;&#xA;FROM sankhya.TGFVAR WHERE NUNOTAORIG= sankhya.AD_ROTEIROENTREGA.NUNOTA)) END AS 'N_NOTA',&#xD;&#xA;CASE WHEN (sankhya.AD_ROTEIROENTREGA.TIPMOV= 'V') THEN&#xD;&#xA;(SELECT NF.DTNEG FROM sankhya.TGFCAB NF&#xD;&#xA;WHERE NF.NUNOTA= sankhya.AD_ROTEIROENTREGA.NUNOTA)&#xD;&#xA;ELSE (SELECT NF.DTNEG FROM sankhya.TGFCAB NF WHERE NF.NUNOTA=&#xD;&#xA;(SELECT TOP(1) sankhya.TGFVAR.NUNOTA&#xD;&#xA;FROM sankhya.TGFVAR WHERE NUNOTAORIG= sankhya.AD_ROTEIROENTREGA.NUNOTA)) END&#xD;&#xA;AS 'DT_EMISSAO',&#xD;&#xA;sankhya.AD_ROTEIROENTREGA.DTROTEIRO AS 'DT_ROTEIRO',&#xD;&#xA;sankhya.AD_ROTEIROENTREGA.PREVENTREGA AS 'PREV_ENTREGA',&#xD;&#xA;sankhya.AD_ROTEIROENTREGA.DTTRANSPORTADORA AS 'DT_ENTREGA_TRANSPORTADORA',&#xD;&#xA;ISNULL(sankhya.TGFPAR.AD_PZOTRANSPORTE,0) AS 'PZO_ENTREGA',&#xD;&#xA;((CASE WHEN (sankhya.AD_ROTEIROENTREGA.DTTRANSPORTADORA IS NULL)&#xD;&#xA;THEN sankhya.AD_ROTEIROENTREGA.DTROTEIRO ELSE sankhya.AD_ROTEIROENTREGA.DTTRANSPORTADORA END)&#xD;&#xA;+ ISNULL(sankhya.TGFPAR.AD_PZOTRANSPORTE,0)) AS 'DT_PREVISTA_CLIENTE',&#xD;&#xA;CONVERT(INT,(CONVERT(DATETIME,CONVERT(DATE,GETDATE())) -&#xD;&#xA;((CASE WHEN (sankhya.AD_ROTEIROENTREGA.DTTRANSPORTADORA IS NULL)&#xD;&#xA;THEN sankhya.AD_ROTEIROENTREGA.DTROTEIRO ELSE sankhya.AD_ROTEIROENTREGA.DTTRANSPORTADORA END)&#xD;&#xA;+ ISNULL(sankhya.TGFPAR.AD_PZOTRANSPORTE,0)))) AS 'DIAS_ATRASO',&#xD;&#xA;CONVERT(DATETIME,CONVERT(DATE,GETDATE())) AS 'DT_HOJE',&#xD;&#xA;LTRIM(RTRIM(sankhya.AD_ROTEIROENTREGA.PARCEIRO)) AS 'PARCEIRO',&#xD;&#xA;'REPRESENTANTE'= (SELECT LTRIM(RTRIM(V.APELIDO))+' - '+CONVERT(VARCHAR,V.CODVEND)&#xD;&#xA;FROM sankhya.TGFVEN V WHERE V.CODVEND= sankhya.TGFCAB.CODVEND),&#xD;&#xA;LTRIM(RTRIM(sankhya.AD_ROTEIROENTREGA.TRANSPORTADORA)) AS 'TRANSPORTADORA',&#xD;&#xA;(REPLACE(REPLACE(LTRIM(RTRIM(CONVERT(VARCHAR(MAX),sankhya.AD_ROTEIROENTREGA.OBSERVACAO)))&#xD;&#xA;, CHAR(13) + CHAR(10), ''), CHAR (10), '')) AS 'OBSERVACAO'&#xD;&#xA;&#xD;&#xA;FROM sankhya.AD_ROTEIROENTREGA&#xD;&#xA;JOIN sankhya.TGFCAB ON (sankhya.AD_ROTEIROENTREGA.NUNOTA= sankhya.TGFCAB.NUNOTA)&#xD;&#xA;JOIN sankhya.TGFPAR ON (sankhya.TGFCAB.CODPARC= sankhya.TGFPAR.CODPARC)&#xD;&#xA;&#xD;&#xA;WHERE CONVERT(DATE,sankhya.AD_ROTEIROENTREGA.DTROTEIRO) &gt;= '01/06/2024'&#xD;&#xA;AND CONVERT(DATE,sankhya.AD_ROTEIROENTREGA.DTROTEIRO) &lt; CONVERT(DATE,GETDATE())&#xD;&#xA;AND sankhya.AD_ROTEIROENTREGA.DTENTREGACLIENTE IS NULL&#xD;&#xA;AND (CONVERT(INT,(CONVERT(DATETIME,CONVERT(DATE,GETDATE())) -&#xD;&#xA;((CASE WHEN (sankhya.AD_ROTEIROENTREGA.DTTRANSPORTADORA IS NULL) THEN sankhya.AD_ROTEIROENTREGA.DTROTEIRO ELSE sankhya.AD_ROTEIROENTREGA.DTTRANSPORTADORA END)&#xD;&#xA;+ ISNULL(sankhya.TGFPAR.AD_PZOTRANSPORTE,0))))) &gt;= 5&#xD;&#xA;&#xD;&#xA;ORDER BY 8 DESC, 1" StatementType="SELECT" QueryHash="0x14CCA25B77E0E0FA" QueryPlanHash="0x29131DE67A4A854D" RetrievedFromCache="true" SecurityPolicyApplied="false">
          <StatementSetOptions ANSI_NULLS="true" ANSI_PADDING="true" ANSI_WARNINGS="true" ARITHABORT="true" CONCAT_NULL_YIELDS_NULL="true" NUMERIC_ROUNDABORT="false" QUOTED_IDENTIFIER="true" />
          <QueryPlan CachedPlanSize="296" CompileTime="51" CompileCPU="48" CompileMemory="4696">
            <ThreadStat Branches="4" />
            <Warnings>
              <PlanAffectingConvert ConvertIssue="Cardinality Estimate" Expression="CONVERT(varchar(30),[V].[CODVEND],0)" />
              <PlanAffectingConvert ConvertIssue="Cardinality Estimate" Expression="CONVERT(varchar(max),[SANKHYA_TESTE].[sankhya].[AD_ROTEIROENTREGA].[OBSERVACAO],0)" />
            </Warnings>
            <MemoryGrantInfo SerialRequiredMemory="3584" SerialDesiredMemory="472688" GrantedMemory="0" MaxUsedMemory="0" />
            <OptimizerHardwareDependentProperties EstimatedAvailableMemoryGrant="349525" EstimatedPagesCached="262144" EstimatedAvailableDegreeOfParallelism="6" MaxCompileMemory="24563848" />
            <OptimizerStatsUsage>
              <StatisticsInfo Database="[SANKHYA_TESTE]" Schema="[sankhya]" Table="[TGFCAB]" Statistics="[TGFCAB_I05]" ModificationCount="0" SamplingPercent="3.4383" LastUpdate="2025-06-04T04:10:35.51" />
              <StatisticsInfo Database="[SANKHYA_TESTE]" Schema="[sankhya]" Table="[TGFCAB]" Statistics="[FMC_INDEX_2016927_8362]" ModificationCount="0" SamplingPercent="4.02827" LastUpdate="2025-06-04T04:10:31.53" />
              <StatisticsInfo Database="[SANKHYA_TESTE]" Schema="[sankhya]" Table="[AD_ROTEIROENTREGA]" Statistics="[_WA_Sys_00000013_73AC79C3]" ModificationCount="1" SamplingPercent="27.6935" LastUpdate="2025-06-04T04:10:05.87" />
              <StatisticsInfo Database="[SANKHYA_TESTE]" Schema="[sankhya]" Table="[TGFVAR]" Statistics="[PK_TGFVAR]" ModificationCount="0" SamplingPercent="7.36123" LastUpdate="2025-06-04T04:18:43.04" />
              <StatisticsInfo Database="[SANKHYA_TESTE]" Schema="[sankhya]" Table="[AD_ROTEIROENTREGA]" Statistics="[IDX_N_AD_ROTEIROENTREGA_15B19]" ModificationCount="1" SamplingPercent="27.4714" LastUpdate="2025-06-04T04:09:59.44" />
              <StatisticsInfo Database="[SANKHYA_TESTE]" Schema="[sankhya]" Table="[TGFCAB]" Statistics="[FMC_INDEX_TGFCAB_13849]" ModificationCount="0" SamplingPercent="3.78182" LastUpdate="2025-06-04T04:10:31.89" />
              <StatisticsInfo Database="[SANKHYA_TESTE]" Schema="[sankhya]" Table="[TGFCAB]" Statistics="[IDX_TGFCAB_LANDIX_1]" ModificationCount="0" SamplingPercent="3.74261" LastUpdate="2025-06-04T04:10:34.56" />
              <StatisticsInfo Database="[SANKHYA_TESTE]" Schema="[sankhya]" Table="[TGFCAB]" Statistics="[IDX_N_TGFCAB_E91E0]" ModificationCount="0" SamplingPercent="3.4383" LastUpdate="2025-06-04T04:10:34.45" />
              <StatisticsInfo Database="[SANKHYA_TESTE]" Schema="[sankhya]" Table="[TGFCAB]" Statistics="[TGFCAB_I10]" ModificationCount="0" SamplingPercent="3.4383" LastUpdate="2025-06-04T04:10:35.83" />
              <StatisticsInfo Database="[SANKHYA_TESTE]" Schema="[sankhya]" Table="[TGFCAB]" Statistics="[IDX_TGFCAB_LANDIX_4]" ModificationCount="0" SamplingPercent="3.4383" LastUpdate="2025-06-04T04:10:34.89" />
              <StatisticsInfo Database="[SANKHYA_TESTE]" Schema="[sankhya]" Table="[TGFCAB]" Statistics="[IDX_N_TGFCAB_19543]" ModificationCount="0" SamplingPercent="4.02827" LastUpdate="2025-06-04T04:10:32.65" />
              <StatisticsInfo Database="[SANKHYA_TESTE]" Schema="[sankhya]" Table="[TGFCAB]" Statistics="[TGFCAB_I02]" ModificationCount="0" SamplingPercent="4.23243" LastUpdate="2025-06-04T04:10:35.24" />
              <StatisticsInfo Database="[SANKHYA_TESTE]" Schema="[sankhya]" Table="[TGFCAB]" Statistics="[IDX_N_TGFCAB_001]" ModificationCount="0" SamplingPercent="3.72158" LastUpdate="2025-06-04T04:10:32.22" />
              <StatisticsInfo Database="[SANKHYA_TESTE]" Schema="[sankhya]" Table="[TGFCAB]" Statistics="[TGFCAB_I_FAT_OS]" ModificationCount="0" SamplingPercent="3.78182" LastUpdate="2025-06-04T04:10:35.16" />
              <StatisticsInfo Database="[SANKHYA_TESTE]" Schema="[sankhya]" Table="[TGFCAB]" Statistics="[FMC_INDEX_TGFCAB_13991]" ModificationCount="0" SamplingPercent="4.23243" LastUpdate="2025-06-04T04:10:32.03" />
              <StatisticsInfo Database="[SANKHYA_TESTE]" Schema="[sankhya]" Table="[TGFCAB]" Statistics="[TGFCAB_NUREM]" ModificationCount="0" SamplingPercent="3.4383" LastUpdate="2025-06-04T04:10:36.76" />
              <StatisticsInfo Database="[SANKHYA_TESTE]" Schema="[sankhya]" Table="[AD_ROTEIROENTREGA]" Statistics="[IDX_N_AD_ROTEIROENTREGA_5307A]" ModificationCount="1" SamplingPercent="23.2069" LastUpdate="2025-06-04T04:09:59.7" />
              <StatisticsInfo Database="[SANKHYA_TESTE]" Schema="[sankhya]" Table="[TGFCAB]" Statistics="[IDX_N_TGFCAB_003]" ModificationCount="0" SamplingPercent="3.58039" LastUpdate="2025-06-04T04:10:32.36" />
              <StatisticsInfo Database="[SANKHYA_TESTE]" Schema="[sankhya]" Table="[AD_ROTEIROENTREGA]" Statistics="[IDX_N_AD_ROTEIROENTREGA_4E38C]" ModificationCount="1" SamplingPercent="27.4714" LastUpdate="2025-06-04T04:09:59.66" />
              <StatisticsInfo Database="[SANKHYA_TESTE]" Schema="[sankhya]" Table="[TGFCAB]" Statistics="[TGFCAB_I03]" ModificationCount="0" SamplingPercent="3.56573" LastUpdate="2025-06-04T04:10:35.43" />
              <StatisticsInfo Database="[SANKHYA_TESTE]" Schema="[sankhya]" Table="[TGFCAB]" Statistics="[TGFCAB_I01]" ModificationCount="0" SamplingPercent="3.73635" LastUpdate="2025-06-04T04:10:35.2" />
              <StatisticsInfo Database="[SANKHYA_TESTE]" Schema="[sankhya]" Table="[AD_ROTEIROENTREGA]" Statistics="[_WA_Sys_00000015_73AC79C3]" ModificationCount="1" SamplingPercent="27.4714" LastUpdate="2025-06-04T04:10:05.91" />
              <StatisticsInfo Database="[SANKHYA_TESTE]" Schema="[sankhya]" Table="[TGFCAB]" Statistics="[TGFCAB_I08]" ModificationCount="0" SamplingPercent="3.4383" LastUpdate="2025-06-04T04:10:35.64" />
              <StatisticsInfo Database="[SANKHYA_TESTE]" Schema="[sankhya]" Table="[TGFCAB]" Statistics="[IDX_TGFCAB_LANDIX_3]" ModificationCount="0" SamplingPercent="3.61575" LastUpdate="2025-06-04T04:10:34.79" />
              <StatisticsInfo Database="[SANKHYA_TESTE]" Schema="[sankhya]" Table="[AD_ROTEIROENTREGA]" Statistics="[PK_AD_ROTEIROENTREGA]" ModificationCount="1" SamplingPercent="23.2069" LastUpdate="2025-06-04T04:09:59.28" />
              <StatisticsInfo Database="[SANKHYA_TESTE]" Schema="[sankhya]" Table="[TGFCAB]" Statistics="[FMC_INDEX_TGFCAB_13893]" ModificationCount="0" SamplingPercent="3.78182" LastUpdate="2025-06-04T04:10:31.96" />
              <StatisticsInfo Database="[SANKHYA_TESTE]" Schema="[sankhya]" Table="[TGFVEN]" Statistics="[PK_TGFVEN]" ModificationCount="0" SamplingPercent="100" LastUpdate="2025-06-04T04:18:44.12" />
              <StatisticsInfo Database="[SANKHYA_TESTE]" Schema="[sankhya]" Table="[TGFCAB]" Statistics="[FMC_index__42]" ModificationCount="0" SamplingPercent="3.4383" LastUpdate="2025-06-04T04:10:31.38" />
              <StatisticsInfo Database="[SANKHYA_TESTE]" Schema="[sankhya]" Table="[TGFCAB]" Statistics="[FMC_index_TGFCAB_4731]" ModificationCount="0" SamplingPercent="4.0751" LastUpdate="2025-06-04T04:10:32.12" />
              <StatisticsInfo Database="[SANKHYA_TESTE]" Schema="[sankhya]" Table="[TGFCAB]" Statistics="[IDX_N_TGFCAB_1EA8D]" ModificationCount="0" SamplingPercent="3.74261" LastUpdate="2025-06-04T04:10:32.74" />
              <StatisticsInfo Database="[SANKHYA_TESTE]" Schema="[sankhya]" Table="[TGFCAB]" Statistics="[IDX_N_TGFCAB_D90C2]" ModificationCount="0" SamplingPercent="100" LastUpdate="2025-06-04T04:10:34.18" />
              <StatisticsInfo Database="[SANKHYA_TESTE]" Schema="[sankhya]" Table="[TGFCAB]" Statistics="[TGFCAB_I24]" ModificationCount="0" SamplingPercent="3.58039" LastUpdate="2025-06-04T04:10:36.07" />
              <StatisticsInfo Database="[SANKHYA_TESTE]" Schema="[sankhya]" Table="[TGFCAB]" Statistics="[FMC_INDEX_TGFCAB_13840]" ModificationCount="0" SamplingPercent="3.74261" LastUpdate="2025-06-04T04:10:31.78" />
              <StatisticsInfo Database="[SANKHYA_TESTE]" Schema="[sankhya]" Table="[TGFCAB]" Statistics="[IDX_N_TGFCAB_D36FF]" ModificationCount="0" SamplingPercent="3.58039" LastUpdate="2025-06-04T04:10:33.05" />
              <StatisticsInfo Database="[SANKHYA_TESTE]" Schema="[sankhya]" Table="[TGFCAB]" Statistics="[IDX_N_TGFCAB_006]" ModificationCount="0" SamplingPercent="4.02827" LastUpdate="2025-06-04T04:10:32.6" />
              <StatisticsInfo Database="[SANKHYA_TESTE]" Schema="[sankhya]" Table="[AD_ROTEIROENTREGA]" Statistics="[IDX_N_AD_ROTEIROENTREGA_0B427]" ModificationCount="1" SamplingPercent="27.6935" LastUpdate="2025-06-04T04:09:59.37" />
              <StatisticsInfo Database="[SANKHYA_TESTE]" Schema="[sankhya]" Table="[TGFCAB]" Statistics="[IDX_N_TGFCAB_002]" ModificationCount="0" SamplingPercent="3.73635" LastUpdate="2025-06-04T04:10:32.28" />
              <StatisticsInfo Database="[SANKHYA_TESTE]" Schema="[sankhya]" Table="[TGFCAB]" Statistics="[TGFCAB_IDX_001]" ModificationCount="0" SamplingPercent="3.1124" LastUpdate="2025-06-04T04:10:36.68" />
              <StatisticsInfo Database="[SANKHYA_TESTE]" Schema="[sankhya]" Table="[TGFCAB]" Statistics="[FMC_INDEX_2016927_8315]" ModificationCount="0" SamplingPercent="4.02827" LastUpdate="2025-06-04T04:10:31.47" />
              <StatisticsInfo Database="[SANKHYA_TESTE]" Schema="[sankhya]" Table="[AD_ROTEIROENTREGA]" Statistics="[_WA_Sys_0000000F_73AC79C3]" ModificationCount="1" SamplingPercent="24.4824" LastUpdate="2025-06-04T04:10:05.54" />
              <StatisticsInfo Database="[SANKHYA_TESTE]" Schema="[sankhya]" Table="[TGFCAB]" Statistics="[IDX_N_TGFCAB_005]" ModificationCount="0" SamplingPercent="3.33088" LastUpdate="2025-06-04T04:10:32.55" />
              <StatisticsInfo Database="[SANKHYA_TESTE]" Schema="[sankhya]" Table="[TGFVAR]" Statistics="[TGFVAR_I01]" ModificationCount="0" SamplingPercent="8.16174" LastUpdate="2025-06-04T04:18:43.39" />
              <StatisticsInfo Database="[SANKHYA_TESTE]" Schema="[sankhya]" Table="[TGFCAB]" Statistics="[TGFCAB_I25]" ModificationCount="0" SamplingPercent="3.4383" LastUpdate="2025-06-04T04:10:36.15" />
              <StatisticsInfo Database="[SANKHYA_TESTE]" Schema="[sankhya]" Table="[TGFCAB]" Statistics="[IDX_N_TGFCAB_8001D]" ModificationCount="0" SamplingPercent="3.73635" LastUpdate="2025-06-04T04:10:32.77" />
              <StatisticsInfo Database="[SANKHYA_TESTE]" Schema="[sankhya]" Table="[TGFCAB]" Statistics="[TGFCAB_I028]" ModificationCount="0" SamplingPercent="3.4383" LastUpdate="2025-06-04T04:10:35.31" />
              <StatisticsInfo Database="[SANKHYA_TESTE]" Schema="[sankhya]" Table="[TGFCAB]" Statistics="[TGFCAB_I23]" ModificationCount="0" SamplingPercent="3.4383" LastUpdate="2025-06-04T04:10:36.02" />
              <StatisticsInfo Database="[SANKHYA_TESTE]" Schema="[sankhya]" Table="[TGFCAB]" Statistics="[TGFCAB_I38]" ModificationCount="0" SamplingPercent="3.4383" LastUpdate="2025-06-04T04:10:36.61" />
              <StatisticsInfo Database="[SANKHYA_TESTE]" Schema="[sankhya]" Table="[AD_ROTEIROENTREGA]" Statistics="[_WA_Sys_00000002_73AC79C3]" ModificationCount="1" SamplingPercent="27.4714" LastUpdate="2025-06-04T04:09:59.74" />
              <StatisticsInfo Database="[SANKHYA_TESTE]" Schema="[sankhya]" Table="[TGFCAB]" Statistics="[TGFCAB_I33]" ModificationCount="0" SamplingPercent="3.4383" LastUpdate="2025-06-04T04:10:36.31" />
              <StatisticsInfo Database="[SANKHYA_TESTE]" Schema="[sankhya]" Table="[AD_ROTEIROENTREGA]" Statistics="[_WA_Sys_00000003_73AC79C3]" ModificationCount="1" SamplingPercent="23.2069" LastUpdate="2025-06-04T04:09:59.77" />
              <StatisticsInfo Database="[SANKHYA_TESTE]" Schema="[sankhya]" Table="[TGFCAB]" Statistics="[TGFCAB_I06]" ModificationCount="0" SamplingPercent="3.1091" LastUpdate="2025-06-04T04:10:35.56" />
              <StatisticsInfo Database="[SANKHYA_TESTE]" Schema="[sankhya]" Table="[TGFCAB]" Statistics="[FMC_INDEX_2016927_8364]" ModificationCount="0" SamplingPercent="3.36919" LastUpdate="2025-06-04T04:10:31.65" />
              <StatisticsInfo Database="[SANKHYA_TESTE]" Schema="[sankhya]" Table="[TGFCAB]" Statistics="[TGFCAB_I37]" ModificationCount="0" SamplingPercent="3.83013" LastUpdate="2025-06-04T04:10:36.54" />
              <StatisticsInfo Database="[SANKHYA_TESTE]" Schema="[sankhya]" Table="[TGFCAB]" Statistics="[IDX_N_TGFCAB_A753D]" ModificationCount="0" SamplingPercent="3.4383" LastUpdate="2025-06-04T04:10:32.92" />
              <StatisticsInfo Database="[SANKHYA_TESTE]" Schema="[sankhya]" Table="[TGFCAB]" Statistics="[IDX_TGFCAB_LANDIX_2]" ModificationCount="0" SamplingPercent="3.4383" LastUpdate="2025-06-04T04:10:34.65" />
              <StatisticsInfo Database="[SANKHYA_TESTE]" Schema="[sankhya]" Table="[TGFCAB]" Statistics="[TGFCAB_I11]" ModificationCount="0" SamplingPercent="3.84832" LastUpdate="2025-06-04T04:10:35.87" />
              <StatisticsInfo Database="[SANKHYA_TESTE]" Schema="[sankhya]" Table="[TGFCAB]" Statistics="[IDX_N_TGFCAB_E3B5B]" ModificationCount="0" SamplingPercent="4.02827" LastUpdate="2025-06-04T04:10:34.28" />
              <StatisticsInfo Database="[SANKHYA_TESTE]" Schema="[sankhya]" Table="[TGFCAB]" Statistics="[PK_TGFCAB]" ModificationCount="0" SamplingPercent="3.84832" LastUpdate="2025-06-04T04:10:31.15" />
              <StatisticsInfo Database="[SANKHYA_TESTE]" Schema="[sankhya]" Table="[AD_ROTEIROENTREGA]" Statistics="[IDX_N_AD_ROTEIROENTREGA_2C944]" ModificationCount="1" SamplingPercent="24.4824" LastUpdate="2025-06-04T04:09:59.61" />
              <StatisticsInfo Database="[SANKHYA_TESTE]" Schema="[sankhya]" Table="[TGFCAB]" Statistics="[TGFCAB_I09]" ModificationCount="0" SamplingPercent="3.42898" LastUpdate="2025-06-04T04:10:35.7" />
              <StatisticsInfo Database="[SANKHYA_TESTE]" Schema="[sankhya]" Table="[TGFCAB]" Statistics="[IDX_N_TGFCAB_CDE19]" ModificationCount="0" SamplingPercent="3.4383" LastUpdate="2025-06-04T04:10:33" />
              <StatisticsInfo Database="[SANKHYA_TESTE]" Schema="[sankhya]" Table="[TGFCAB]" Statistics="[TGFCAB_I34]" ModificationCount="0" SamplingPercent="3.4383" LastUpdate="2025-06-04T04:10:36.39" />
              <StatisticsInfo Database="[SANKHYA_TESTE]" Schema="[sankhya]" Table="[TGFCAB]" Statistics="[IDX_N_TGFCAB_004]" ModificationCount="0" SamplingPercent="4.02827" LastUpdate="2025-06-04T04:10:32.45" />
              <StatisticsInfo Database="[SANKHYA_TESTE]" Schema="[sankhya]" Table="[TGFPAR]" Statistics="[PK_TGFPAR]" ModificationCount="0" SamplingPercent="40.0052" LastUpdate="2025-06-04T04:18:37.23" />
              <StatisticsInfo Database="[SANKHYA_TESTE]" Schema="[sankhya]" Table="[TGFCAB]" Statistics="[TGFCAB_I30]" ModificationCount="0" SamplingPercent="3.24505" LastUpdate="2025-06-04T04:10:36.21" />
              <StatisticsInfo Database="[SANKHYA_TESTE]" Schema="[sankhya]" Table="[TGFCAB]" Statistics="[TGFCAB_I22]" ModificationCount="0" SamplingPercent="3.4383" LastUpdate="2025-06-04T04:10:35.95" />
              <StatisticsInfo Database="[SANKHYA_TESTE]" Schema="[sankhya]" Table="[TGFCAB]" Statistics="[IDX_TGFCAB_LANDIX_5]" ModificationCount="0" SamplingPercent="3.74261" LastUpdate="2025-06-04T04:10:35.01" />
              <StatisticsInfo Database="[SANKHYA_TESTE]" Schema="[sankhya]" Table="[TGFCAB]" Statistics="[IDX_TGFCAB_LANDIX_6]" ModificationCount="0" SamplingPercent="3.4383" LastUpdate="2025-06-04T04:10:35.1" />
            </OptimizerStatsUsage>
            <TraceFlags IsCompileTime="true">
              <TraceFlag Value="3226" Scope="Global" />
            </TraceFlags>
            <RelOp AvgRowSize="4243" EstimateCPU="1.33811" EstimateIO="0" EstimateRebinds="0" EstimateRewinds="0" EstimatedExecutionMode="Row" EstimateRows="24138.2" LogicalOp="Gather Streams" NodeId="0" Parallel="true" PhysicalOp="Parallelism" EstimatedTotalSubtreeCost="256.617">
              <OutputList>
                <ColumnReference Database="[SANKHYA_TESTE]" Schema="[sankhya]" Table="[AD_ROTEIROENTREGA]" Column="DTROTEIRO" />
                <ColumnReference Database="[SANKHYA_TESTE]" Schema="[sankhya]" Table="[AD_ROTEIROENTREGA]" Column="PREVENTREGA" />
                <ColumnReference Database="[SANKHYA_TESTE]" Schema="[sankhya]" Table="[AD_ROTEIROENTREGA]" Column="DTTRANSPORTADORA" />
                <ColumnReference Column="Expr1013" />
                <ColumnReference Column="Expr1021" />
                <ColumnReference Column="Expr1022" />
                <ColumnReference Column="Expr1023" />
                <ColumnReference Column="Expr1024" />
                <ColumnReference Column="Expr1025" />
                <ColumnReference Column="Expr1026" />
                <ColumnReference Column="Expr1029" />
                <ColumnReference Column="Expr1030" />
                <ColumnReference Column="Expr1031" />
              </OutputList>
              <Parallelism>
                <OrderBy>
                  <OrderByColumn Ascending="false">
                    <ColumnReference Column="Expr1024" />
                  </OrderByColumn>
                  <OrderByColumn Ascending="true">
                    <ColumnReference Column="Expr1013" />
                  </OrderByColumn>
                </OrderBy>
                <RelOp AvgRowSize="4243" EstimateCPU="0.268861" EstimateIO="0.00187688" EstimateRebinds="0" EstimateRewinds="0" EstimatedExecutionMode="Row" EstimateRows="24138.2" LogicalOp="Sort" NodeId="1" Parallel="true" PhysicalOp="Sort" EstimatedTotalSubtreeCost="255.279">
                  <OutputList>
                    <ColumnReference Database="[SANKHYA_TESTE]" Schema="[sankhya]" Table="[AD_ROTEIROENTREGA]" Column="DTROTEIRO" />
                    <ColumnReference Database="[SANKHYA_TESTE]" Schema="[sankhya]" Table="[AD_ROTEIROENTREGA]" Column="PREVENTREGA" />
                    <ColumnReference Database="[SANKHYA_TESTE]" Schema="[sankhya]" Table="[AD_ROTEIROENTREGA]" Column="DTTRANSPORTADORA" />
                    <ColumnReference Column="Expr1013" />
                    <ColumnReference Column="Expr1021" />
                    <ColumnReference Column="Expr1022" />
                    <ColumnReference Column="Expr1023" />
                    <ColumnReference Column="Expr1024" />
                    <ColumnReference Column="Expr1025" />
                    <ColumnReference Column="Expr1026" />
                    <ColumnReference Column="Expr1029" />
                    <ColumnReference Column="Expr1030" />
                    <ColumnReference Column="Expr1031" />
                  </OutputList>
                  <MemoryFractions Input="0.269058" Output="1" />
                  <Sort Distinct="false">
                    <OrderBy>
                      <OrderByColumn Ascending="false">
                        <ColumnReference Column="Expr1024" />
                      </OrderByColumn>
                      <OrderByColumn Ascending="true">
                        <ColumnReference Column="Expr1013" />
                      </OrderByColumn>
                    </OrderBy>
                    <RelOp AvgRowSize="4243" EstimateCPU="0.000402304" EstimateIO="0" EstimateRebinds="0" EstimateRewinds="0" EstimatedExecutionMode="Row" EstimateRows="24138.2" LogicalOp="Compute Scalar" NodeId="2" Parallel="true" PhysicalOp="Compute Scalar" EstimatedTotalSubtreeCost="255.008">
                      <OutputList>
                        <ColumnReference Database="[SANKHYA_TESTE]" Schema="[sankhya]" Table="[AD_ROTEIROENTREGA]" Column="DTROTEIRO" />
                        <ColumnReference Database="[SANKHYA_TESTE]" Schema="[sankhya]" Table="[AD_ROTEIROENTREGA]" Column="PREVENTREGA" />
                        <ColumnReference Database="[SANKHYA_TESTE]" Schema="[sankhya]" Table="[AD_ROTEIROENTREGA]" Column="DTTRANSPORTADORA" />
                        <ColumnReference Column="Expr1013" />
                        <ColumnReference Column="Expr1021" />
                        <ColumnReference Column="Expr1022" />
                        <ColumnReference Column="Expr1023" />
                        <ColumnReference Column="Expr1024" />
                        <ColumnReference Column="Expr1025" />
                        <ColumnReference Column="Expr1026" />
                        <ColumnReference Column="Expr1029" />
                        <ColumnReference Column="Expr1030" />
                        <ColumnReference Column="Expr1031" />
                      </OutputList>
                      <ComputeScalar>
                        <DefinedValues>
                          <DefinedValue>
                            <ColumnReference Column="Expr1013" />
                            <ScalarOperator ScalarString="CASE WHEN [SANKHYA_TESTE].[sankhya].[AD_ROTEIROENTREGA].[TIPMOV]='V' THEN [SANKHYA_TESTE].[sankhya].[TGFCAB].[NUMNOTA] as [NF].[NUMNOTA] ELSE [Expr1039] END">
                              <IF>
                                <Condition>
                                  <ScalarOperator>
                                    <Compare CompareOp="EQ">
                                      <ScalarOperator>
                                        <Identifier>
                                          <ColumnReference Database="[SANKHYA_TESTE]" Schema="[sankhya]" Table="[AD_ROTEIROENTREGA]" Column="TIPMOV" />
                                        </Identifier>
                                      </ScalarOperator>
                                      <ScalarOperator>
                                        <Const ConstValue="'V'" />
                                      </ScalarOperator>
                                    </Compare>
                                  </ScalarOperator>
                                </Condition>
                                <Then>
                                  <ScalarOperator>
                                    <Identifier>
                                      <ColumnReference Database="[SANKHYA_TESTE]" Schema="[sankhya]" Table="[TGFCAB]" Alias="[NF]" Column="NUMNOTA" />
                                    </Identifier>
                                  </ScalarOperator>
                                </Then>
                                <Else>
                                  <ScalarOperator>
                                    <Identifier>
                                      <ColumnReference Column="Expr1039" />
                                    </Identifier>
                                  </ScalarOperator>
                                </Else>
                              </IF>
                            </ScalarOperator>
                          </DefinedValue>
                          <DefinedValue>
                            <ColumnReference Column="Expr1021" />
                            <ScalarOperator ScalarString="CASE WHEN [SANKHYA_TESTE].[sankhya].[AD_ROTEIROENTREGA].[TIPMOV]='V' THEN [SANKHYA_TESTE].[sankhya].[TGFCAB].[DTNEG] as [NF].[DTNEG] ELSE [Expr1041] END">
                              <IF>
                                <Condition>
                                  <ScalarOperator>
                                    <Compare CompareOp="EQ">
                                      <ScalarOperator>
                                        <Identifier>
                                          <ColumnReference Database="[SANKHYA_TESTE]" Schema="[sankhya]" Table="[AD_ROTEIROENTREGA]" Column="TIPMOV" />
                                        </Identifier>
                                      </ScalarOperator>
                                      <ScalarOperator>
                                        <Const ConstValue="'V'" />
                                      </ScalarOperator>
                                    </Compare>
                                  </ScalarOperator>
                                </Condition>
                                <Then>
                                  <ScalarOperator>
                                    <Identifier>
                                      <ColumnReference Database="[SANKHYA_TESTE]" Schema="[sankhya]" Table="[TGFCAB]" Alias="[NF]" Column="DTNEG" />
                                    </Identifier>
                                  </ScalarOperator>
                                </Then>
                                <Else>
                                  <ScalarOperator>
                                    <Identifier>
                                      <ColumnReference Column="Expr1041" />
                                    </Identifier>
                                  </ScalarOperator>
                                </Else>
                              </IF>
                            </ScalarOperator>
                          </DefinedValue>
                          <DefinedValue>
                            <ColumnReference Column="Expr1023" />
                            <ScalarOperator ScalarString="[Expr1042]+[Expr1043]">
                              <Arithmetic Operation="ADD">
                                <ScalarOperator>
                                  <Identifier>
                                    <ColumnReference Column="Expr1042" />
                                  </Identifier>
                                </ScalarOperator>
                                <ScalarOperator>
                                  <Identifier>
                                    <ColumnReference Column="Expr1043" />
                                  </Identifier>
                                </ScalarOperator>
                              </Arithmetic>
                            </ScalarOperator>
                          </DefinedValue>
                          <DefinedValue>
                            <ColumnReference Column="Expr1024" />
                            <ScalarOperator ScalarString="CONVERT(int,CONVERT(datetime,CONVERT(date,getdate(),0),0)-([Expr1042]+[Expr1043]),0)">
                              <Convert DataType="int" Style="0" Implicit="false">
                                <ScalarOperator>
                                  <Arithmetic Operation="SUB">
                                    <ScalarOperator>
                                      <Identifier>
                                        <ColumnReference Column="ConstExpr1034">
                                          <ScalarOperator>
                                            <Convert DataType="datetime" Style="0" Implicit="false">
                                              <ScalarOperator>
                                                <Convert DataType="date" Style="0" Implicit="false">
                                                  <ScalarOperator>
                                                    <Intrinsic FunctionName="getdate" />
                                                  </ScalarOperator>
                                                </Convert>
                                              </ScalarOperator>
                                            </Convert>
                                          </ScalarOperator>
                                        </ColumnReference>
                                      </Identifier>
                                    </ScalarOperator>
                                    <ScalarOperator>
                                      <Arithmetic Operation="ADD">
                                        <ScalarOperator>
                                          <Identifier>
                                            <ColumnReference Column="Expr1042" />
                                          </Identifier>
                                        </ScalarOperator>
                                        <ScalarOperator>
                                          <Identifier>
                                            <ColumnReference Column="Expr1043" />
                                          </Identifier>
                                        </ScalarOperator>
                                      </Arithmetic>
                                    </ScalarOperator>
                                  </Arithmetic>
                                </ScalarOperator>
                              </Convert>
                            </ScalarOperator>
                          </DefinedValue>
                          <DefinedValue>
                            <ColumnReference Column="Expr1025" />
                            <ScalarOperator ScalarString="CONVERT(datetime,CONVERT(date,getdate(),0),0)">
                              <Identifier>
                                <ColumnReference Column="ConstExpr1035">
                                  <ScalarOperator>
                                    <Convert DataType="datetime" Style="0" Implicit="false">
                                      <ScalarOperator>
                                        <Convert DataType="date" Style="0" Implicit="false">
                                          <ScalarOperator>
                                            <Intrinsic FunctionName="getdate" />
                                          </ScalarOperator>
                                        </Convert>
                                      </ScalarOperator>
                                    </Convert>
                                  </ScalarOperator>
                                </ColumnReference>
                              </Identifier>
                            </ScalarOperator>
                          </DefinedValue>
                          <DefinedValue>
                            <ColumnReference Column="Expr1029" />
                            <ScalarOperator ScalarString="[Expr1028]">
                              <Identifier>
                                <ColumnReference Column="Expr1028" />
                              </Identifier>
                            </ScalarOperator>
                          </DefinedValue>
                          <DefinedValue>
                            <ColumnReference Column="Expr1031" />
                            <ScalarOperator ScalarString="replace(replace([Expr1044],'&#xD;&#xA;',CONVERT_IMPLICIT(varchar(max),'',0)),'&#xA;',CONVERT_IMPLICIT(varchar(max),'',0))">
                              <Intrinsic FunctionName="replace">
                                <ScalarOperator>
                                  <Intrinsic FunctionName="replace">
                                    <ScalarOperator>
                                      <Identifier>
                                        <ColumnReference Column="Expr1044" />
                                      </Identifier>
                                    </ScalarOperator>
                                    <ScalarOperator>
                                      <Const ConstValue="'&#xD;&#xA;'" />
                                    </ScalarOperator>
                                    <ScalarOperator>
                                      <Identifier>
                                        <ColumnReference Column="ConstExpr1037">
                                          <ScalarOperator>
                                            <Convert DataType="varchar(max)" Length="2147483647" Style="0" Implicit="true">
                                              <ScalarOperator>
                                                <Const ConstValue="''" />
                                              </ScalarOperator>
                                            </Convert>
                                          </ScalarOperator>
                                        </ColumnReference>
                                      </Identifier>
                                    </ScalarOperator>
                                  </Intrinsic>
                                </ScalarOperator>
                                <ScalarOperator>
                                  <Const ConstValue="'&#xA;'" />
                                </ScalarOperator>
                                <ScalarOperator>
                                  <Identifier>
                                    <ColumnReference Column="ConstExpr1036">
                                      <ScalarOperator>
                                        <Convert DataType="varchar(max)" Length="2147483647" Style="0" Implicit="true">
                                          <ScalarOperator>
                                            <Const ConstValue="''" />
                                          </ScalarOperator>
                                        </Convert>
                                      </ScalarOperator>
                                    </ColumnReference>
                                  </Identifier>
                                </ScalarOperator>
                              </Intrinsic>
                            </ScalarOperator>
                          </DefinedValue>
                        </DefinedValues>
                        <RelOp AvgRowSize="4253" EstimateCPU="0.0557397" EstimateIO="0" EstimateRebinds="0" EstimateRewinds="0" EstimatedExecutionMode="Row" EstimateRows="24138.2" LogicalOp="Right Outer Join" NodeId="3" Parallel="true" PhysicalOp="Hash Match" EstimatedTotalSubtreeCost="255.008">
                          <OutputList>
                            <ColumnReference Database="[SANKHYA_TESTE]" Schema="[sankhya]" Table="[AD_ROTEIROENTREGA]" Column="DTROTEIRO" />
                            <ColumnReference Database="[SANKHYA_TESTE]" Schema="[sankhya]" Table="[AD_ROTEIROENTREGA]" Column="PREVENTREGA" />
                            <ColumnReference Database="[SANKHYA_TESTE]" Schema="[sankhya]" Table="[AD_ROTEIROENTREGA]" Column="TIPMOV" />
                            <ColumnReference Database="[SANKHYA_TESTE]" Schema="[sankhya]" Table="[AD_ROTEIROENTREGA]" Column="DTTRANSPORTADORA" />
                            <ColumnReference Database="[SANKHYA_TESTE]" Schema="[sankhya]" Table="[TGFCAB]" Alias="[NF]" Column="NUMNOTA" />
                            <ColumnReference Database="[SANKHYA_TESTE]" Schema="[sankhya]" Table="[TGFCAB]" Alias="[NF]" Column="DTNEG" />
                            <ColumnReference Column="Expr1022" />
                            <ColumnReference Column="Expr1026" />
                            <ColumnReference Column="Expr1028" />
                            <ColumnReference Column="Expr1030" />
                            <ColumnReference Column="Expr1039" />
                            <ColumnReference Column="Expr1041" />
                            <ColumnReference Column="Expr1042" />
                            <ColumnReference Column="Expr1043" />
                            <ColumnReference Column="Expr1044" />
                          </OutputList>
                          <MemoryFractions Input="0.000956581" Output="0.000699205" />
                          <Hash>
                            <DefinedValues />
                            <HashKeysBuild>
                              <ColumnReference Database="[SANKHYA_TESTE]" Schema="[sankhya]" Table="[TGFVEN]" Alias="[V]" Column="CODVEND" />
                            </HashKeysBuild>
                            <HashKeysProbe>
                              <ColumnReference Database="[SANKHYA_TESTE]" Schema="[sankhya]" Table="[TGFCAB]" Column="CODVEND" />
                            </HashKeysProbe>
                            <RelOp AvgRowSize="54" EstimateCPU="3.83333E-06" EstimateIO="0" EstimateRebinds="0" EstimateRewinds="0" EstimatedExecutionMode="Row" EstimateRows="230" LogicalOp="Compute Scalar" NodeId="4" Parallel="true" PhysicalOp="Compute Scalar" EstimatedTotalSubtreeCost="0.0430697">
                              <OutputList>
                                <ColumnReference Database="[SANKHYA_TESTE]" Schema="[sankhya]" Table="[TGFVEN]" Alias="[V]" Column="CODVEND" />
                                <ColumnReference Column="Expr1028" />
                              </OutputList>
                              <ComputeScalar>
                                <DefinedValues>
                                  <DefinedValue>
                                    <ColumnReference Column="Expr1028" />
                                    <ScalarOperator ScalarString="ltrim(rtrim([SANKHYA_TESTE].[sankhya].[TGFVEN].[APELIDO] as [V].[APELIDO]))+' - '+CONVERT(varchar(30),[SANKHYA_TESTE].[sankhya].[TGFVEN].[CODVEND] as [V].[CODVEND],0)">
                                      <Arithmetic Operation="ADD">
                                        <ScalarOperator>
                                          <Arithmetic Operation="ADD">
                                            <ScalarOperator>
                                              <Intrinsic FunctionName="ltrim">
                                                <ScalarOperator>
                                                  <Intrinsic FunctionName="rtrim">
                                                    <ScalarOperator>
                                                      <Identifier>
                                                        <ColumnReference Database="[SANKHYA_TESTE]" Schema="[sankhya]" Table="[TGFVEN]" Alias="[V]" Column="APELIDO" />
                                                      </Identifier>
                                                    </ScalarOperator>
                                                  </Intrinsic>
                                                </ScalarOperator>
                                              </Intrinsic>
                                            </ScalarOperator>
                                            <ScalarOperator>
                                              <Const ConstValue="' - '" />
                                            </ScalarOperator>
                                          </Arithmetic>
                                        </ScalarOperator>
                                        <ScalarOperator>
                                          <Convert DataType="varchar" Length="30" Style="0" Implicit="false">
                                            <ScalarOperator>
                                              <Identifier>
                                                <ColumnReference Database="[SANKHYA_TESTE]" Schema="[sankhya]" Table="[TGFVEN]" Alias="[V]" Column="CODVEND" />
                                              </Identifier>
                                            </ScalarOperator>
                                          </Convert>
                                        </ScalarOperator>
                                      </Arithmetic>
                                    </ScalarOperator>
                                  </DefinedValue>
                                </DefinedValues>
                                <RelOp AvgRowSize="59" EstimateCPU="0.0299012" EstimateIO="0" EstimateRebinds="0" EstimateRewinds="0" EstimatedExecutionMode="Row" EstimateRows="230" LogicalOp="Distribute Streams" NodeId="5" Parallel="true" PhysicalOp="Parallelism" EstimatedTotalSubtreeCost="0.0430658">
                                  <OutputList>
                                    <ColumnReference Database="[SANKHYA_TESTE]" Schema="[sankhya]" Table="[TGFVEN]" Alias="[V]" Column="CODVEND" />
                                    <ColumnReference Database="[SANKHYA_TESTE]" Schema="[sankhya]" Table="[TGFVEN]" Alias="[V]" Column="APELIDO" />
                                  </OutputList>
                                  <Parallelism PartitioningType="Hash">
                                    <PartitionColumns>
                                      <ColumnReference Database="[SANKHYA_TESTE]" Schema="[sankhya]" Table="[TGFVEN]" Alias="[V]" Column="CODVEND" />
                                    </PartitionColumns>
                                    <RelOp AvgRowSize="59" EstimateCPU="0.00041" EstimateIO="0.0127546" EstimateRebinds="0" EstimateRewinds="0" EstimatedExecutionMode="Row" EstimateRows="230" EstimatedRowsRead="230" LogicalOp="Clustered Index Scan" NodeId="6" Parallel="false" PhysicalOp="Clustered Index Scan" EstimatedTotalSubtreeCost="0.0131646" TableCardinality="230">
                                      <OutputList>
                                        <ColumnReference Database="[SANKHYA_TESTE]" Schema="[sankhya]" Table="[TGFVEN]" Alias="[V]" Column="CODVEND" />
                                        <ColumnReference Database="[SANKHYA_TESTE]" Schema="[sankhya]" Table="[TGFVEN]" Alias="[V]" Column="APELIDO" />
                                      </OutputList>
                                      <IndexScan Ordered="false" ForcedIndex="false" ForceScan="false" NoExpandHint="false" Storage="RowStore">
                                        <DefinedValues>
                                          <DefinedValue>
                                            <ColumnReference Database="[SANKHYA_TESTE]" Schema="[sankhya]" Table="[TGFVEN]" Alias="[V]" Column="CODVEND" />
                                          </DefinedValue>
                                          <DefinedValue>
                                            <ColumnReference Database="[SANKHYA_TESTE]" Schema="[sankhya]" Table="[TGFVEN]" Alias="[V]" Column="APELIDO" />
                                          </DefinedValue>
                                        </DefinedValues>
                                        <Object Database="[SANKHYA_TESTE]" Schema="[sankhya]" Table="[TGFVEN]" Index="[PK_TGFVEN]" Alias="[V]" IndexKind="Clustered" Storage="RowStore" />
                                      </IndexScan>
                                    </RelOp>
                                  </Parallelism>
                                </RelOp>
                              </ComputeScalar>
                            </RelOp>
                            <RelOp AvgRowSize="4212" EstimateCPU="1.2311" EstimateIO="0" EstimateRebinds="0" EstimateRewinds="0" EstimatedExecutionMode="Row" EstimateRows="24138.2" LogicalOp="Repartition Streams" NodeId="7" Parallel="true" PhysicalOp="Parallelism" EstimatedTotalSubtreeCost="254.909">
                              <OutputList>
                                <ColumnReference Database="[SANKHYA_TESTE]" Schema="[sankhya]" Table="[AD_ROTEIROENTREGA]" Column="DTROTEIRO" />
                                <ColumnReference Database="[SANKHYA_TESTE]" Schema="[sankhya]" Table="[AD_ROTEIROENTREGA]" Column="PREVENTREGA" />
                                <ColumnReference Database="[SANKHYA_TESTE]" Schema="[sankhya]" Table="[AD_ROTEIROENTREGA]" Column="TIPMOV" />
                                <ColumnReference Database="[SANKHYA_TESTE]" Schema="[sankhya]" Table="[AD_ROTEIROENTREGA]" Column="DTTRANSPORTADORA" />
                                <ColumnReference Database="[SANKHYA_TESTE]" Schema="[sankhya]" Table="[TGFCAB]" Column="CODVEND" />
                                <ColumnReference Database="[SANKHYA_TESTE]" Schema="[sankhya]" Table="[TGFCAB]" Alias="[NF]" Column="NUMNOTA" />
                                <ColumnReference Database="[SANKHYA_TESTE]" Schema="[sankhya]" Table="[TGFCAB]" Alias="[NF]" Column="DTNEG" />
                                <ColumnReference Column="Expr1022" />
                                <ColumnReference Column="Expr1026" />
                                <ColumnReference Column="Expr1030" />
                                <ColumnReference Column="Expr1039" />
                                <ColumnReference Column="Expr1041" />
                                <ColumnReference Column="Expr1042" />
                                <ColumnReference Column="Expr1043" />
                                <ColumnReference Column="Expr1044" />
                              </OutputList>
                              <Parallelism PartitioningType="Hash">
                                <PartitionColumns>
                                  <ColumnReference Database="[SANKHYA_TESTE]" Schema="[sankhya]" Table="[TGFCAB]" Column="CODVEND" />
                                </PartitionColumns>
                                <RelOp AvgRowSize="4212" EstimateCPU="0.0168163" EstimateIO="0" EstimateRebinds="0" EstimateRewinds="0" EstimatedExecutionMode="Row" EstimateRows="24138.2" LogicalOp="Left Outer Join" NodeId="8" Parallel="true" PhysicalOp="Nested Loops" EstimatedTotalSubtreeCost="253.678">
                                  <OutputList>
                                    <ColumnReference Database="[SANKHYA_TESTE]" Schema="[sankhya]" Table="[AD_ROTEIROENTREGA]" Column="DTROTEIRO" />
                                    <ColumnReference Database="[SANKHYA_TESTE]" Schema="[sankhya]" Table="[AD_ROTEIROENTREGA]" Column="PREVENTREGA" />
                                    <ColumnReference Database="[SANKHYA_TESTE]" Schema="[sankhya]" Table="[AD_ROTEIROENTREGA]" Column="TIPMOV" />
                                    <ColumnReference Database="[SANKHYA_TESTE]" Schema="[sankhya]" Table="[AD_ROTEIROENTREGA]" Column="DTTRANSPORTADORA" />
                                    <ColumnReference Database="[SANKHYA_TESTE]" Schema="[sankhya]" Table="[TGFCAB]" Column="CODVEND" />
                                    <ColumnReference Database="[SANKHYA_TESTE]" Schema="[sankhya]" Table="[TGFCAB]" Alias="[NF]" Column="NUMNOTA" />
                                    <ColumnReference Database="[SANKHYA_TESTE]" Schema="[sankhya]" Table="[TGFCAB]" Alias="[NF]" Column="DTNEG" />
                                    <ColumnReference Column="Expr1022" />
                                    <ColumnReference Column="Expr1026" />
                                    <ColumnReference Column="Expr1030" />
                                    <ColumnReference Column="Expr1039" />
                                    <ColumnReference Column="Expr1041" />
                                    <ColumnReference Column="Expr1042" />
                                    <ColumnReference Column="Expr1043" />
                                    <ColumnReference Column="Expr1044" />
                                  </OutputList>
                                  <NestedLoops Optimized="false">
                                    <PassThru>
                                      <ScalarOperator ScalarString="[SANKHYA_TESTE].[sankhya].[AD_ROTEIROENTREGA].[TIPMOV]='V'">
                                        <Compare CompareOp="EQ">
                                          <ScalarOperator>
                                            <Identifier>
                                              <ColumnReference Database="[SANKHYA_TESTE]" Schema="[sankhya]" Table="[AD_ROTEIROENTREGA]" Column="TIPMOV" />
                                            </Identifier>
                                          </ScalarOperator>
                                          <ScalarOperator>
                                            <Const ConstValue="'V'" />
                                          </ScalarOperator>
                                        </Compare>
                                      </ScalarOperator>
                                    </PassThru>
                                    <OuterReferences>
                                      <ColumnReference Database="[SANKHYA_TESTE]" Schema="[sankhya]" Table="[AD_ROTEIROENTREGA]" Column="NUNOTA" />
                                    </OuterReferences>
                                    <RelOp AvgRowSize="4208" EstimateCPU="0.0168163" EstimateIO="0" EstimateRebinds="0" EstimateRewinds="0" EstimatedExecutionMode="Row" EstimateRows="24138.2" LogicalOp="Left Outer Join" NodeId="9" Parallel="true" PhysicalOp="Nested Loops" EstimatedTotalSubtreeCost="173.616">
                                      <OutputList>
                                        <ColumnReference Database="[SANKHYA_TESTE]" Schema="[sankhya]" Table="[AD_ROTEIROENTREGA]" Column="DTROTEIRO" />
                                        <ColumnReference Database="[SANKHYA_TESTE]" Schema="[sankhya]" Table="[AD_ROTEIROENTREGA]" Column="NUNOTA" />
                                        <ColumnReference Database="[SANKHYA_TESTE]" Schema="[sankhya]" Table="[AD_ROTEIROENTREGA]" Column="PREVENTREGA" />
                                        <ColumnReference Database="[SANKHYA_TESTE]" Schema="[sankhya]" Table="[AD_ROTEIROENTREGA]" Column="TIPMOV" />
                                        <ColumnReference Database="[SANKHYA_TESTE]" Schema="[sankhya]" Table="[AD_ROTEIROENTREGA]" Column="DTTRANSPORTADORA" />
                                        <ColumnReference Database="[SANKHYA_TESTE]" Schema="[sankhya]" Table="[TGFCAB]" Column="CODVEND" />
                                        <ColumnReference Database="[SANKHYA_TESTE]" Schema="[sankhya]" Table="[TGFCAB]" Alias="[NF]" Column="NUMNOTA" />
                                        <ColumnReference Database="[SANKHYA_TESTE]" Schema="[sankhya]" Table="[TGFCAB]" Alias="[NF]" Column="DTNEG" />
                                        <ColumnReference Column="Expr1022" />
                                        <ColumnReference Column="Expr1026" />
                                        <ColumnReference Column="Expr1030" />
                                        <ColumnReference Column="Expr1039" />
                                        <ColumnReference Column="Expr1042" />
                                        <ColumnReference Column="Expr1043" />
                                        <ColumnReference Column="Expr1044" />
                                      </OutputList>
                                      <NestedLoops Optimized="false">
                                        <PassThru>
                                          <ScalarOperator ScalarString="IsFalseOrNull [SANKHYA_TESTE].[sankhya].[AD_ROTEIROENTREGA].[TIPMOV]='V'">
                                            <Logical Operation="IsFalseOrNull">
                                              <ScalarOperator>
                                                <Compare CompareOp="EQ">
                                                  <ScalarOperator>
                                                    <Identifier>
                                                      <ColumnReference Database="[SANKHYA_TESTE]" Schema="[sankhya]" Table="[AD_ROTEIROENTREGA]" Column="TIPMOV" />
                                                    </Identifier>
                                                  </ScalarOperator>
                                                  <ScalarOperator>
                                                    <Const ConstValue="'V'" />
                                                  </ScalarOperator>
                                                </Compare>
                                              </ScalarOperator>
                                            </Logical>
                                          </ScalarOperator>
                                        </PassThru>
                                        <OuterReferences>
                                          <ColumnReference Database="[SANKHYA_TESTE]" Schema="[sankhya]" Table="[AD_ROTEIROENTREGA]" Column="NUNOTA" />
                                        </OuterReferences>
                                        <RelOp AvgRowSize="4200" EstimateCPU="0.0168163" EstimateIO="0" EstimateRebinds="0" EstimateRewinds="0" EstimatedExecutionMode="Row" EstimateRows="24138.2" LogicalOp="Left Outer Join" NodeId="10" Parallel="true" PhysicalOp="Nested Loops" EstimatedTotalSubtreeCost="134.672">
                                          <OutputList>
                                            <ColumnReference Database="[SANKHYA_TESTE]" Schema="[sankhya]" Table="[AD_ROTEIROENTREGA]" Column="DTROTEIRO" />
                                            <ColumnReference Database="[SANKHYA_TESTE]" Schema="[sankhya]" Table="[AD_ROTEIROENTREGA]" Column="NUNOTA" />
                                            <ColumnReference Database="[SANKHYA_TESTE]" Schema="[sankhya]" Table="[AD_ROTEIROENTREGA]" Column="PREVENTREGA" />
                                            <ColumnReference Database="[SANKHYA_TESTE]" Schema="[sankhya]" Table="[AD_ROTEIROENTREGA]" Column="TIPMOV" />
                                            <ColumnReference Database="[SANKHYA_TESTE]" Schema="[sankhya]" Table="[AD_ROTEIROENTREGA]" Column="DTTRANSPORTADORA" />
                                            <ColumnReference Database="[SANKHYA_TESTE]" Schema="[sankhya]" Table="[TGFCAB]" Column="CODVEND" />
                                            <ColumnReference Database="[SANKHYA_TESTE]" Schema="[sankhya]" Table="[TGFCAB]" Alias="[NF]" Column="NUMNOTA" />
                                            <ColumnReference Column="Expr1022" />
                                            <ColumnReference Column="Expr1026" />
                                            <ColumnReference Column="Expr1030" />
                                            <ColumnReference Column="Expr1039" />
                                            <ColumnReference Column="Expr1042" />
                                            <ColumnReference Column="Expr1043" />
                                            <ColumnReference Column="Expr1044" />
                                          </OutputList>
                                          <NestedLoops Optimized="false">
                                            <PassThru>
                                              <ScalarOperator ScalarString="[SANKHYA_TESTE].[sankhya].[AD_ROTEIROENTREGA].[TIPMOV]='V'">
                                                <Compare CompareOp="EQ">
                                                  <ScalarOperator>
                                                    <Identifier>
                                                      <ColumnReference Database="[SANKHYA_TESTE]" Schema="[sankhya]" Table="[AD_ROTEIROENTREGA]" Column="TIPMOV" />
                                                    </Identifier>
                                                  </ScalarOperator>
                                                  <ScalarOperator>
                                                    <Const ConstValue="'V'" />
                                                  </ScalarOperator>
                                                </Compare>
                                              </ScalarOperator>
                                            </PassThru>
                                            <OuterReferences>
                                              <ColumnReference Database="[SANKHYA_TESTE]" Schema="[sankhya]" Table="[AD_ROTEIROENTREGA]" Column="NUNOTA" />
                                            </OuterReferences>
                                            <RelOp AvgRowSize="4196" EstimateCPU="0.0168163" EstimateIO="0" EstimateRebinds="0" EstimateRewinds="0" EstimatedExecutionMode="Row" EstimateRows="24138.2" LogicalOp="Left Outer Join" NodeId="11" Parallel="true" PhysicalOp="Nested Loops" EstimatedTotalSubtreeCost="54.6101">
                                              <OutputList>
                                                <ColumnReference Database="[SANKHYA_TESTE]" Schema="[sankhya]" Table="[AD_ROTEIROENTREGA]" Column="DTROTEIRO" />
                                                <ColumnReference Database="[SANKHYA_TESTE]" Schema="[sankhya]" Table="[AD_ROTEIROENTREGA]" Column="NUNOTA" />
                                                <ColumnReference Database="[SANKHYA_TESTE]" Schema="[sankhya]" Table="[AD_ROTEIROENTREGA]" Column="PREVENTREGA" />
                                                <ColumnReference Database="[SANKHYA_TESTE]" Schema="[sankhya]" Table="[AD_ROTEIROENTREGA]" Column="TIPMOV" />
                                                <ColumnReference Database="[SANKHYA_TESTE]" Schema="[sankhya]" Table="[AD_ROTEIROENTREGA]" Column="DTTRANSPORTADORA" />
                                                <ColumnReference Database="[SANKHYA_TESTE]" Schema="[sankhya]" Table="[TGFCAB]" Column="CODVEND" />
                                                <ColumnReference Database="[SANKHYA_TESTE]" Schema="[sankhya]" Table="[TGFCAB]" Alias="[NF]" Column="NUMNOTA" />
                                                <ColumnReference Column="Expr1022" />
                                                <ColumnReference Column="Expr1026" />
                                                <ColumnReference Column="Expr1030" />
                                                <ColumnReference Column="Expr1042" />
                                                <ColumnReference Column="Expr1043" />
                                                <ColumnReference Column="Expr1044" />
                                              </OutputList>
                                              <NestedLoops Optimized="false">
                                                <PassThru>
                                                  <ScalarOperator ScalarString="IsFalseOrNull [SANKHYA_TESTE].[sankhya].[AD_ROTEIROENTREGA].[TIPMOV]='V'">
                                                    <Logical Operation="IsFalseOrNull">
                                                      <ScalarOperator>
                                                        <Compare CompareOp="EQ">
                                                          <ScalarOperator>
                                                            <Identifier>
                                                              <ColumnReference Database="[SANKHYA_TESTE]" Schema="[sankhya]" Table="[AD_ROTEIROENTREGA]" Column="TIPMOV" />
                                                            </Identifier>
                                                          </ScalarOperator>
                                                          <ScalarOperator>
                                                            <Const ConstValue="'V'" />
                                                          </ScalarOperator>
                                                        </Compare>
                                                      </ScalarOperator>
                                                    </Logical>
                                                  </ScalarOperator>
                                                </PassThru>
                                                <OuterReferences>
                                                  <ColumnReference Database="[SANKHYA_TESTE]" Schema="[sankhya]" Table="[AD_ROTEIROENTREGA]" Column="NUNOTA" />
                                                </OuterReferences>
                                                <RelOp AvgRowSize="4192" EstimateCPU="0.094372" EstimateIO="0" EstimateRebinds="0" EstimateRewinds="0" EstimatedExecutionMode="Row" EstimateRows="24138.2" LogicalOp="Inner Join" NodeId="12" Parallel="true" PhysicalOp="Hash Match" EstimatedTotalSubtreeCost="20.3908">
                                                  <OutputList>
                                                    <ColumnReference Database="[SANKHYA_TESTE]" Schema="[sankhya]" Table="[AD_ROTEIROENTREGA]" Column="DTROTEIRO" />
                                                    <ColumnReference Database="[SANKHYA_TESTE]" Schema="[sankhya]" Table="[AD_ROTEIROENTREGA]" Column="NUNOTA" />
                                                    <ColumnReference Database="[SANKHYA_TESTE]" Schema="[sankhya]" Table="[AD_ROTEIROENTREGA]" Column="PREVENTREGA" />
                                                    <ColumnReference Database="[SANKHYA_TESTE]" Schema="[sankhya]" Table="[AD_ROTEIROENTREGA]" Column="TIPMOV" />
                                                    <ColumnReference Database="[SANKHYA_TESTE]" Schema="[sankhya]" Table="[AD_ROTEIROENTREGA]" Column="DTTRANSPORTADORA" />
                                                    <ColumnReference Database="[SANKHYA_TESTE]" Schema="[sankhya]" Table="[TGFCAB]" Column="CODVEND" />
                                                    <ColumnReference Column="Expr1022" />
                                                    <ColumnReference Column="Expr1026" />
                                                    <ColumnReference Column="Expr1030" />
                                                    <ColumnReference Column="Expr1042" />
                                                    <ColumnReference Column="Expr1043" />
                                                    <ColumnReference Column="Expr1044" />
                                                  </OutputList>
                                                  <MemoryFractions Input="0.0458925" Output="0.0335448" />
                                                  <Hash>
                                                    <DefinedValues />
                                                    <HashKeysBuild>
                                                      <ColumnReference Database="[SANKHYA_TESTE]" Schema="[sankhya]" Table="[TGFPAR]" Column="CODPARC" />
                                                    </HashKeysBuild>
                                                    <HashKeysProbe>
                                                      <ColumnReference Database="[SANKHYA_TESTE]" Schema="[sankhya]" Table="[TGFCAB]" Column="CODPARC" />
                                                    </HashKeysProbe>
                                                    <ProbeResidual>
                                                      <ScalarOperator ScalarString="[SANKHYA_TESTE].[sankhya].[TGFPAR].[CODPARC]=[SANKHYA_TESTE].[sankhya].[TGFCAB].[CODPARC] AND CONVERT(int,CONVERT(datetime,CONVERT(date,getdate(),0),0)-([Expr1042]+[Expr1043]),0)&gt;=(5)">
                                                        <Logical Operation="AND">
                                                          <ScalarOperator>
                                                            <Compare CompareOp="EQ">
                                                              <ScalarOperator>
                                                                <Identifier>
                                                                  <ColumnReference Database="[SANKHYA_TESTE]" Schema="[sankhya]" Table="[TGFPAR]" Column="CODPARC" />
                                                                </Identifier>
                                                              </ScalarOperator>
                                                              <ScalarOperator>
                                                                <Identifier>
                                                                  <ColumnReference Database="[SANKHYA_TESTE]" Schema="[sankhya]" Table="[TGFCAB]" Column="CODPARC" />
                                                                </Identifier>
                                                              </ScalarOperator>
                                                            </Compare>
                                                          </ScalarOperator>
                                                          <ScalarOperator>
                                                            <Compare CompareOp="GE">
                                                              <ScalarOperator>
                                                                <Convert DataType="int" Style="0" Implicit="false">
                                                                  <ScalarOperator>
                                                                    <Arithmetic Operation="SUB">
                                                                      <ScalarOperator>
                                                                        <Identifier>
                                                                          <ColumnReference Column="ConstExpr1033">
                                                                            <ScalarOperator>
                                                                              <Convert DataType="datetime" Style="0" Implicit="false">
                                                                                <ScalarOperator>
                                                                                  <Convert DataType="date" Style="0" Implicit="false">
                                                                                    <ScalarOperator>
                                                                                      <Intrinsic FunctionName="getdate" />
                                                                                    </ScalarOperator>
                                                                                  </Convert>
                                                                                </ScalarOperator>
                                                                              </Convert>
                                                                            </ScalarOperator>
                                                                          </ColumnReference>
                                                                        </Identifier>
                                                                      </ScalarOperator>
                                                                      <ScalarOperator>
                                                                        <Arithmetic Operation="ADD">
                                                                          <ScalarOperator>
                                                                            <Identifier>
                                                                              <ColumnReference Column="Expr1042" />
                                                                            </Identifier>
                                                                          </ScalarOperator>
                                                                          <ScalarOperator>
                                                                            <Identifier>
                                                                              <ColumnReference Column="Expr1043" />
                                                                            </Identifier>
                                                                          </ScalarOperator>
                                                                        </Arithmetic>
                                                                      </ScalarOperator>
                                                                    </Arithmetic>
                                                                  </ScalarOperator>
                                                                </Convert>
                                                              </ScalarOperator>
                                                              <ScalarOperator>
                                                                <Const ConstValue="(5)" />
                                                              </ScalarOperator>
                                                            </Compare>
                                                          </ScalarOperator>
                                                        </Logical>
                                                      </ScalarOperator>
                                                    </ProbeResidual>
                                                    <RelOp AvgRowSize="23" EstimateCPU="0.000258133" EstimateIO="0" EstimateRebinds="0" EstimateRewinds="0" EstimatedExecutionMode="Row" EstimateRows="15488" LogicalOp="Compute Scalar" NodeId="13" Parallel="true" PhysicalOp="Compute Scalar" EstimatedTotalSubtreeCost="2.90363">
                                                      <OutputList>
                                                        <ColumnReference Database="[SANKHYA_TESTE]" Schema="[sankhya]" Table="[TGFPAR]" Column="CODPARC" />
                                                        <ColumnReference Column="Expr1022" />
                                                        <ColumnReference Column="Expr1043" />
                                                      </OutputList>
                                                      <ComputeScalar>
                                                        <DefinedValues>
                                                          <DefinedValue>
                                                            <ColumnReference Column="Expr1022" />
                                                            <ScalarOperator ScalarString="isnull([SANKHYA_TESTE].[sankhya].[TGFPAR].[AD_PZOTRANSPORTE],(0))">
                                                              <Intrinsic FunctionName="isnull">
                                                                <ScalarOperator>
                                                                  <Identifier>
                                                                    <ColumnReference Database="[SANKHYA_TESTE]" Schema="[sankhya]" Table="[TGFPAR]" Column="AD_PZOTRANSPORTE" />
                                                                  </Identifier>
                                                                </ScalarOperator>
                                                                <ScalarOperator>
                                                                  <Const ConstValue="(0)" />
                                                                </ScalarOperator>
                                                              </Intrinsic>
                                                            </ScalarOperator>
                                                          </DefinedValue>
                                                          <DefinedValue>
                                                            <ColumnReference Column="Expr1043" />
                                                            <ScalarOperator ScalarString="CONVERT_IMPLICIT(datetime,isnull([SANKHYA_TESTE].[sankhya].[TGFPAR].[AD_PZOTRANSPORTE],(0)),0)">
                                                              <Convert DataType="datetime" Style="0" Implicit="true">
                                                                <ScalarOperator>
                                                                  <Intrinsic FunctionName="isnull">
                                                                    <ScalarOperator>
                                                                      <Identifier>
                                                                        <ColumnReference Database="[SANKHYA_TESTE]" Schema="[sankhya]" Table="[TGFPAR]" Column="AD_PZOTRANSPORTE" />
                                                                      </Identifier>
                                                                    </ScalarOperator>
                                                                    <ScalarOperator>
                                                                      <Const ConstValue="(0)" />
                                                                    </ScalarOperator>
                                                                  </Intrinsic>
                                                                </ScalarOperator>
                                                              </Convert>
                                                            </ScalarOperator>
                                                          </DefinedValue>
                                                        </DefinedValues>
                                                        <RelOp AvgRowSize="15" EstimateCPU="0.0366448" EstimateIO="0" EstimateRebinds="0" EstimateRewinds="0" EstimatedExecutionMode="Row" EstimateRows="15488" LogicalOp="Repartition Streams" NodeId="14" Parallel="true" PhysicalOp="Parallelism" EstimatedTotalSubtreeCost="2.90338">
                                                          <OutputList>
                                                            <ColumnReference Database="[SANKHYA_TESTE]" Schema="[sankhya]" Table="[TGFPAR]" Column="CODPARC" />
                                                            <ColumnReference Database="[SANKHYA_TESTE]" Schema="[sankhya]" Table="[TGFPAR]" Column="AD_PZOTRANSPORTE" />
                                                          </OutputList>
                                                          <Parallelism PartitioningType="Hash">
                                                            <PartitionColumns>
                                                              <ColumnReference Database="[SANKHYA_TESTE]" Schema="[sankhya]" Table="[TGFPAR]" Column="CODPARC" />
                                                            </PartitionColumns>
                                                            <RelOp AvgRowSize="15" EstimateCPU="0.00286563" EstimateIO="2.86387" EstimateRebinds="0" EstimateRewinds="0" EstimatedExecutionMode="Row" EstimateRows="15488" EstimatedRowsRead="15488" LogicalOp="Clustered Index Scan" NodeId="15" Parallel="true" PhysicalOp="Clustered Index Scan" EstimatedTotalSubtreeCost="2.86673" TableCardinality="15488">
                                                              <OutputList>
                                                                <ColumnReference Database="[SANKHYA_TESTE]" Schema="[sankhya]" Table="[TGFPAR]" Column="CODPARC" />
                                                                <ColumnReference Database="[SANKHYA_TESTE]" Schema="[sankhya]" Table="[TGFPAR]" Column="AD_PZOTRANSPORTE" />
                                                              </OutputList>
                                                              <IndexScan Ordered="false" ForcedIndex="false" ForceScan="false" NoExpandHint="false" Storage="RowStore">
                                                                <DefinedValues>
                                                                  <DefinedValue>
                                                                    <ColumnReference Database="[SANKHYA_TESTE]" Schema="[sankhya]" Table="[TGFPAR]" Column="CODPARC" />
                                                                  </DefinedValue>
                                                                  <DefinedValue>
                                                                    <ColumnReference Database="[SANKHYA_TESTE]" Schema="[sankhya]" Table="[TGFPAR]" Column="AD_PZOTRANSPORTE" />
                                                                  </DefinedValue>
                                                                </DefinedValues>
                                                                <Object Database="[SANKHYA_TESTE]" Schema="[sankhya]" Table="[TGFPAR]" Index="[PK_TGFPAR]" IndexKind="Clustered" Storage="RowStore" />
                                                              </IndexScan>
                                                            </RelOp>
                                                          </Parallelism>
                                                        </RelOp>
                                                      </ComputeScalar>
                                                    </RelOp>
                                                    <RelOp AvgRowSize="4184" EstimateCPU="1.21595" EstimateIO="0" EstimateRebinds="0" EstimateRewinds="0" EstimatedExecutionMode="Row" EstimateRows="24138.2" LogicalOp="Repartition Streams" NodeId="16" Parallel="true" PhysicalOp="Parallelism" EstimatedTotalSubtreeCost="17.3928">
                                                      <OutputList>
                                                        <ColumnReference Database="[SANKHYA_TESTE]" Schema="[sankhya]" Table="[AD_ROTEIROENTREGA]" Column="DTROTEIRO" />
                                                        <ColumnReference Database="[SANKHYA_TESTE]" Schema="[sankhya]" Table="[AD_ROTEIROENTREGA]" Column="NUNOTA" />
                                                        <ColumnReference Database="[SANKHYA_TESTE]" Schema="[sankhya]" Table="[AD_ROTEIROENTREGA]" Column="PREVENTREGA" />
                                                        <ColumnReference Database="[SANKHYA_TESTE]" Schema="[sankhya]" Table="[AD_ROTEIROENTREGA]" Column="TIPMOV" />
                                                        <ColumnReference Database="[SANKHYA_TESTE]" Schema="[sankhya]" Table="[AD_ROTEIROENTREGA]" Column="DTTRANSPORTADORA" />
                                                        <ColumnReference Database="[SANKHYA_TESTE]" Schema="[sankhya]" Table="[TGFCAB]" Column="CODPARC" />
                                                        <ColumnReference Database="[SANKHYA_TESTE]" Schema="[sankhya]" Table="[TGFCAB]" Column="CODVEND" />
                                                        <ColumnReference Column="Expr1026" />
                                                        <ColumnReference Column="Expr1030" />
                                                        <ColumnReference Column="Expr1042" />
                                                        <ColumnReference Column="Expr1044" />
                                                      </OutputList>
                                                      <Parallelism PartitioningType="Hash">
                                                        <PartitionColumns>
                                                          <ColumnReference Database="[SANKHYA_TESTE]" Schema="[sankhya]" Table="[TGFCAB]" Column="CODPARC" />
                                                        </PartitionColumns>
                                                        <RelOp AvgRowSize="4184" EstimateCPU="8.5894" EstimateIO="0" EstimateRebinds="0" EstimateRewinds="0" EstimatedExecutionMode="Row" EstimateRows="24138.2" LogicalOp="Inner Join" NodeId="17" Parallel="true" PhysicalOp="Hash Match" EstimatedTotalSubtreeCost="16.1768">
                                                          <OutputList>
                                                            <ColumnReference Database="[SANKHYA_TESTE]" Schema="[sankhya]" Table="[AD_ROTEIROENTREGA]" Column="DTROTEIRO" />
                                                            <ColumnReference Database="[SANKHYA_TESTE]" Schema="[sankhya]" Table="[AD_ROTEIROENTREGA]" Column="NUNOTA" />
                                                            <ColumnReference Database="[SANKHYA_TESTE]" Schema="[sankhya]" Table="[AD_ROTEIROENTREGA]" Column="PREVENTREGA" />
                                                            <ColumnReference Database="[SANKHYA_TESTE]" Schema="[sankhya]" Table="[AD_ROTEIROENTREGA]" Column="TIPMOV" />
                                                            <ColumnReference Database="[SANKHYA_TESTE]" Schema="[sankhya]" Table="[AD_ROTEIROENTREGA]" Column="DTTRANSPORTADORA" />
                                                            <ColumnReference Database="[SANKHYA_TESTE]" Schema="[sankhya]" Table="[TGFCAB]" Column="CODPARC" />
                                                            <ColumnReference Database="[SANKHYA_TESTE]" Schema="[sankhya]" Table="[TGFCAB]" Column="CODVEND" />
                                                            <ColumnReference Column="Expr1026" />
                                                            <ColumnReference Column="Expr1030" />
                                                            <ColumnReference Column="Expr1042" />
                                                            <ColumnReference Column="Expr1044" />
                                                          </OutputList>
                                                          <MemoryFractions Input="0.953151" Output="0.696698" />
                                                          <Hash>
                                                            <DefinedValues />
                                                            <HashKeysBuild>
                                                              <ColumnReference Database="[SANKHYA_TESTE]" Schema="[sankhya]" Table="[AD_ROTEIROENTREGA]" Column="NUNOTA" />
                                                            </HashKeysBuild>
                                                            <HashKeysProbe>
                                                              <ColumnReference Database="[SANKHYA_TESTE]" Schema="[sankhya]" Table="[TGFCAB]" Column="NUNOTA" />
                                                            </HashKeysProbe>
                                                            <RelOp AvgRowSize="4178" EstimateCPU="1.2104" EstimateIO="0" EstimateRebinds="0" EstimateRewinds="0" EstimatedExecutionMode="Row" EstimateRows="24138.2" LogicalOp="Bitmap Create" NodeId="18" Parallel="true" PhysicalOp="Bitmap" EstimatedTotalSubtreeCost="5.14155">
                                                              <OutputList>
                                                                <ColumnReference Database="[SANKHYA_TESTE]" Schema="[sankhya]" Table="[AD_ROTEIROENTREGA]" Column="DTROTEIRO" />
                                                                <ColumnReference Database="[SANKHYA_TESTE]" Schema="[sankhya]" Table="[AD_ROTEIROENTREGA]" Column="NUNOTA" />
                                                                <ColumnReference Database="[SANKHYA_TESTE]" Schema="[sankhya]" Table="[AD_ROTEIROENTREGA]" Column="PREVENTREGA" />
                                                                <ColumnReference Database="[SANKHYA_TESTE]" Schema="[sankhya]" Table="[AD_ROTEIROENTREGA]" Column="TIPMOV" />
                                                                <ColumnReference Database="[SANKHYA_TESTE]" Schema="[sankhya]" Table="[AD_ROTEIROENTREGA]" Column="DTTRANSPORTADORA" />
                                                                <ColumnReference Column="Expr1026" />
                                                                <ColumnReference Column="Expr1030" />
                                                                <ColumnReference Column="Expr1042" />
                                                                <ColumnReference Column="Expr1044" />
                                                              </OutputList>
                                                              <Bitmap>
                                                                <DefinedValues>
                                                                  <DefinedValue>
                                                                    <ColumnReference Column="Bitmap1050" />
                                                                  </DefinedValue>
                                                                </DefinedValues>
                                                                <HashKeys>
                                                                  <ColumnReference Database="[SANKHYA_TESTE]" Schema="[sankhya]" Table="[AD_ROTEIROENTREGA]" Column="NUNOTA" />
                                                                </HashKeys>
                                                                <RelOp AvgRowSize="4178" EstimateCPU="1.2104" EstimateIO="0" EstimateRebinds="0" EstimateRewinds="0" EstimatedExecutionMode="Row" EstimateRows="24138.2" LogicalOp="Repartition Streams" NodeId="19" Parallel="true" PhysicalOp="Parallelism" EstimatedTotalSubtreeCost="5.14155">
                                                                  <OutputList>
                                                                    <ColumnReference Database="[SANKHYA_TESTE]" Schema="[sankhya]" Table="[AD_ROTEIROENTREGA]" Column="DTROTEIRO" />
                                                                    <ColumnReference Database="[SANKHYA_TESTE]" Schema="[sankhya]" Table="[AD_ROTEIROENTREGA]" Column="NUNOTA" />
                                                                    <ColumnReference Database="[SANKHYA_TESTE]" Schema="[sankhya]" Table="[AD_ROTEIROENTREGA]" Column="PREVENTREGA" />
                                                                    <ColumnReference Database="[SANKHYA_TESTE]" Schema="[sankhya]" Table="[AD_ROTEIROENTREGA]" Column="TIPMOV" />
                                                                    <ColumnReference Database="[SANKHYA_TESTE]" Schema="[sankhya]" Table="[AD_ROTEIROENTREGA]" Column="DTTRANSPORTADORA" />
                                                                    <ColumnReference Column="Expr1026" />
                                                                    <ColumnReference Column="Expr1030" />
                                                                    <ColumnReference Column="Expr1042" />
                                                                    <ColumnReference Column="Expr1044" />
                                                                  </OutputList>
                                                                  <Parallelism PartitioningType="Hash">
                                                                    <PartitionColumns>
                                                                      <ColumnReference Database="[SANKHYA_TESTE]" Schema="[sankhya]" Table="[AD_ROTEIROENTREGA]" Column="NUNOTA" />
                                                                    </PartitionColumns>
                                                                    <RelOp AvgRowSize="4189" EstimateCPU="0.00310592" EstimateIO="0" EstimateRebinds="0" EstimateRewinds="0" EstimatedExecutionMode="Row" EstimateRows="24138.2" LogicalOp="Compute Scalar" NodeId="20" Parallel="true" PhysicalOp="Compute Scalar" EstimatedTotalSubtreeCost="3.8945">
                                                                      <OutputList>
                                                                        <ColumnReference Database="[SANKHYA_TESTE]" Schema="[sankhya]" Table="[AD_ROTEIROENTREGA]" Column="DTROTEIRO" />
                                                                        <ColumnReference Database="[SANKHYA_TESTE]" Schema="[sankhya]" Table="[AD_ROTEIROENTREGA]" Column="NUNOTA" />
                                                                        <ColumnReference Database="[SANKHYA_TESTE]" Schema="[sankhya]" Table="[AD_ROTEIROENTREGA]" Column="PREVENTREGA" />
                                                                        <ColumnReference Database="[SANKHYA_TESTE]" Schema="[sankhya]" Table="[AD_ROTEIROENTREGA]" Column="TIPMOV" />
                                                                        <ColumnReference Database="[SANKHYA_TESTE]" Schema="[sankhya]" Table="[AD_ROTEIROENTREGA]" Column="DTTRANSPORTADORA" />
                                                                        <ColumnReference Column="Expr1026" />
                                                                        <ColumnReference Column="Expr1030" />
                                                                        <ColumnReference Column="Expr1042" />
                                                                        <ColumnReference Column="Expr1044" />
                                                                      </OutputList>
                                                                      <ComputeScalar>
                                                                        <DefinedValues>
                                                                          <DefinedValue>
                                                                            <ColumnReference Column="Expr1026" />
                                                                            <ScalarOperator ScalarString="ltrim(rtrim([SANKHYA_TESTE].[sankhya].[AD_ROTEIROENTREGA].[PARCEIRO]))">
                                                                              <Intrinsic FunctionName="ltrim">
                                                                                <ScalarOperator>
                                                                                  <Intrinsic FunctionName="rtrim">
                                                                                    <ScalarOperator>
                                                                                      <Identifier>
                                                                                        <ColumnReference Database="[SANKHYA_TESTE]" Schema="[sankhya]" Table="[AD_ROTEIROENTREGA]" Column="PARCEIRO" />
                                                                                      </Identifier>
                                                                                    </ScalarOperator>
                                                                                  </Intrinsic>
                                                                                </ScalarOperator>
                                                                              </Intrinsic>
                                                                            </ScalarOperator>
                                                                          </DefinedValue>
                                                                          <DefinedValue>
                                                                            <ColumnReference Column="Expr1030" />
                                                                            <ScalarOperator ScalarString="ltrim(rtrim([SANKHYA_TESTE].[sankhya].[AD_ROTEIROENTREGA].[TRANSPORTADORA]))">
                                                                              <Intrinsic FunctionName="ltrim">
                                                                                <ScalarOperator>
                                                                                  <Intrinsic FunctionName="rtrim">
                                                                                    <ScalarOperator>
                                                                                      <Identifier>
                                                                                        <ColumnReference Database="[SANKHYA_TESTE]" Schema="[sankhya]" Table="[AD_ROTEIROENTREGA]" Column="TRANSPORTADORA" />
                                                                                      </Identifier>
                                                                                    </ScalarOperator>
                                                                                  </Intrinsic>
                                                                                </ScalarOperator>
                                                                              </Intrinsic>
                                                                            </ScalarOperator>
                                                                          </DefinedValue>
                                                                          <DefinedValue>
                                                                            <ColumnReference Column="Expr1042" />
                                                                            <ScalarOperator ScalarString="CASE WHEN [SANKHYA_TESTE].[sankhya].[AD_ROTEIROENTREGA].[DTTRANSPORTADORA] IS NULL THEN [SANKHYA_TESTE].[sankhya].[AD_ROTEIROENTREGA].[DTROTEIRO] ELSE [SANKHYA_TESTE].[sankhya].[AD_ROTEIROENTREGA].[DTTRANSPORTADORA] END">
                                                                              <IF>
                                                                                <Condition>
                                                                                  <ScalarOperator>
                                                                                    <Compare CompareOp="IS">
                                                                                      <ScalarOperator>
                                                                                        <Identifier>
                                                                                          <ColumnReference Database="[SANKHYA_TESTE]" Schema="[sankhya]" Table="[AD_ROTEIROENTREGA]" Column="DTTRANSPORTADORA" />
                                                                                        </Identifier>
                                                                                      </ScalarOperator>
                                                                                      <ScalarOperator>
                                                                                        <Const ConstValue="NULL" />
                                                                                      </ScalarOperator>
                                                                                    </Compare>
                                                                                  </ScalarOperator>
                                                                                </Condition>
                                                                                <Then>
                                                                                  <ScalarOperator>
                                                                                    <Identifier>
                                                                                      <ColumnReference Database="[SANKHYA_TESTE]" Schema="[sankhya]" Table="[AD_ROTEIROENTREGA]" Column="DTROTEIRO" />
                                                                                    </Identifier>
                                                                                  </ScalarOperator>
                                                                                </Then>
                                                                                <Else>
                                                                                  <ScalarOperator>
                                                                                    <Identifier>
                                                                                      <ColumnReference Database="[SANKHYA_TESTE]" Schema="[sankhya]" Table="[AD_ROTEIROENTREGA]" Column="DTTRANSPORTADORA" />
                                                                                    </Identifier>
                                                                                  </ScalarOperator>
                                                                                </Else>
                                                                              </IF>
                                                                            </ScalarOperator>
                                                                          </DefinedValue>
                                                                          <DefinedValue>
                                                                            <ColumnReference Column="Expr1044" />
                                                                            <ScalarOperator ScalarString="ltrim(rtrim(CONVERT(varchar(max),[SANKHYA_TESTE].[sankhya].[AD_ROTEIROENTREGA].[OBSERVACAO],0)))">
                                                                              <Intrinsic FunctionName="ltrim">
                                                                                <ScalarOperator>
                                                                                  <Intrinsic FunctionName="rtrim">
                                                                                    <ScalarOperator>
                                                                                      <Convert DataType="varchar(max)" Length="2147483647" Style="0" Implicit="false">
                                                                                        <ScalarOperator>
                                                                                          <Identifier>
                                                                                            <ColumnReference Database="[SANKHYA_TESTE]" Schema="[sankhya]" Table="[AD_ROTEIROENTREGA]" Column="OBSERVACAO" />
                                                                                          </Identifier>
                                                                                        </ScalarOperator>
                                                                                      </Convert>
                                                                                    </ScalarOperator>
                                                                                  </Intrinsic>
                                                                                </ScalarOperator>
                                                                              </Intrinsic>
                                                                            </ScalarOperator>
                                                                          </DefinedValue>
                                                                        </DefinedValues>
                                                                        <RelOp AvgRowSize="222" EstimateCPU="0.0341912" EstimateIO="3.8572" EstimateRebinds="0" EstimateRewinds="0" EstimatedExecutionMode="Row" EstimateRows="24138.2" EstimatedRowsRead="186355" LogicalOp="Clustered Index Scan" NodeId="21" Parallel="true" PhysicalOp="Clustered Index Scan" EstimatedTotalSubtreeCost="3.89139" TableCardinality="186355">
                                                                          <OutputList>
                                                                            <ColumnReference Database="[SANKHYA_TESTE]" Schema="[sankhya]" Table="[AD_ROTEIROENTREGA]" Column="DTROTEIRO" />
                                                                            <ColumnReference Database="[SANKHYA_TESTE]" Schema="[sankhya]" Table="[AD_ROTEIROENTREGA]" Column="NUNOTA" />
                                                                            <ColumnReference Database="[SANKHYA_TESTE]" Schema="[sankhya]" Table="[AD_ROTEIROENTREGA]" Column="PREVENTREGA" />
                                                                            <ColumnReference Database="[SANKHYA_TESTE]" Schema="[sankhya]" Table="[AD_ROTEIROENTREGA]" Column="PARCEIRO" />
                                                                            <ColumnReference Database="[SANKHYA_TESTE]" Schema="[sankhya]" Table="[AD_ROTEIROENTREGA]" Column="TRANSPORTADORA" />
                                                                            <ColumnReference Database="[SANKHYA_TESTE]" Schema="[sankhya]" Table="[AD_ROTEIROENTREGA]" Column="TIPMOV" />
                                                                            <ColumnReference Database="[SANKHYA_TESTE]" Schema="[sankhya]" Table="[AD_ROTEIROENTREGA]" Column="OBSERVACAO" />
                                                                            <ColumnReference Database="[SANKHYA_TESTE]" Schema="[sankhya]" Table="[AD_ROTEIROENTREGA]" Column="DTTRANSPORTADORA" />
                                                                          </OutputList>
                                                                          <IndexScan Ordered="false" ForcedIndex="false" ForceScan="false" NoExpandHint="false" Storage="RowStore">
                                                                            <DefinedValues>
                                                                              <DefinedValue>
                                                                                <ColumnReference Database="[SANKHYA_TESTE]" Schema="[sankhya]" Table="[AD_ROTEIROENTREGA]" Column="DTROTEIRO" />
                                                                              </DefinedValue>
                                                                              <DefinedValue>
                                                                                <ColumnReference Database="[SANKHYA_TESTE]" Schema="[sankhya]" Table="[AD_ROTEIROENTREGA]" Column="NUNOTA" />
                                                                              </DefinedValue>
                                                                              <DefinedValue>
                                                                                <ColumnReference Database="[SANKHYA_TESTE]" Schema="[sankhya]" Table="[AD_ROTEIROENTREGA]" Column="PREVENTREGA" />
                                                                              </DefinedValue>
                                                                              <DefinedValue>
                                                                                <ColumnReference Database="[SANKHYA_TESTE]" Schema="[sankhya]" Table="[AD_ROTEIROENTREGA]" Column="PARCEIRO" />
                                                                              </DefinedValue>
                                                                              <DefinedValue>
                                                                                <ColumnReference Database="[SANKHYA_TESTE]" Schema="[sankhya]" Table="[AD_ROTEIROENTREGA]" Column="TRANSPORTADORA" />
                                                                              </DefinedValue>
                                                                              <DefinedValue>
                                                                                <ColumnReference Database="[SANKHYA_TESTE]" Schema="[sankhya]" Table="[AD_ROTEIROENTREGA]" Column="TIPMOV" />
                                                                              </DefinedValue>
                                                                              <DefinedValue>
                                                                                <ColumnReference Database="[SANKHYA_TESTE]" Schema="[sankhya]" Table="[AD_ROTEIROENTREGA]" Column="OBSERVACAO" />
                                                                              </DefinedValue>
                                                                              <DefinedValue>
                                                                                <ColumnReference Database="[SANKHYA_TESTE]" Schema="[sankhya]" Table="[AD_ROTEIROENTREGA]" Column="DTTRANSPORTADORA" />
                                                                              </DefinedValue>
                                                                            </DefinedValues>
                                                                            <Object Database="[SANKHYA_TESTE]" Schema="[sankhya]" Table="[AD_ROTEIROENTREGA]" Index="[PK_AD_ROTEIROENTREGA]" IndexKind="Clustered" Storage="RowStore" />
                                                                            <Predicate>
                                                                              <ScalarOperator ScalarString="[SANKHYA_TESTE].[sankhya].[AD_ROTEIROENTREGA].[DTENTREGACLIENTE] IS NULL AND CONVERT(date,[SANKHYA_TESTE].[sankhya].[AD_ROTEIROENTREGA].[DTROTEIRO],0)&gt;='2024-01-06' AND CONVERT(date,[SANKHYA_TESTE].[sankhya].[AD_ROTEIROENTREGA].[DTROTEIRO],0)&lt;CONVERT(date,getdate(),0)">
                                                                                <Logical Operation="AND">
                                                                                  <ScalarOperator>
                                                                                    <Compare CompareOp="IS">
                                                                                      <ScalarOperator>
                                                                                        <Identifier>
                                                                                          <ColumnReference Database="[SANKHYA_TESTE]" Schema="[sankhya]" Table="[AD_ROTEIROENTREGA]" Column="DTENTREGACLIENTE" />
                                                                                        </Identifier>
                                                                                      </ScalarOperator>
                                                                                      <ScalarOperator>
                                                                                        <Const ConstValue="NULL" />
                                                                                      </ScalarOperator>
                                                                                    </Compare>
                                                                                  </ScalarOperator>
                                                                                  <ScalarOperator>
                                                                                    <Compare CompareOp="GE">
                                                                                      <ScalarOperator>
                                                                                        <Convert DataType="date" Style="0" Implicit="false">
                                                                                          <ScalarOperator>
                                                                                            <Identifier>
                                                                                              <ColumnReference Database="[SANKHYA_TESTE]" Schema="[sankhya]" Table="[AD_ROTEIROENTREGA]" Column="DTROTEIRO" />
                                                                                            </Identifier>
                                                                                          </ScalarOperator>
                                                                                        </Convert>
                                                                                      </ScalarOperator>
                                                                                      <ScalarOperator>
                                                                                        <Const ConstValue="'2024-01-06'" />
                                                                                      </ScalarOperator>
                                                                                    </Compare>
                                                                                  </ScalarOperator>
                                                                                  <ScalarOperator>
                                                                                    <Compare CompareOp="LT">
                                                                                      <ScalarOperator>
                                                                                        <Convert DataType="date" Style="0" Implicit="false">
                                                                                          <ScalarOperator>
                                                                                            <Identifier>
                                                                                              <ColumnReference Database="[SANKHYA_TESTE]" Schema="[sankhya]" Table="[AD_ROTEIROENTREGA]" Column="DTROTEIRO" />
                                                                                            </Identifier>
                                                                                          </ScalarOperator>
                                                                                        </Convert>
                                                                                      </ScalarOperator>
                                                                                      <ScalarOperator>
                                                                                        <Identifier>
                                                                                          <ColumnReference Column="ConstExpr1032">
                                                                                            <ScalarOperator>
                                                                                              <Convert DataType="date" Style="0" Implicit="false">
                                                                                                <ScalarOperator>
                                                                                                  <Intrinsic FunctionName="getdate" />
                                                                                                </ScalarOperator>
                                                                                              </Convert>
                                                                                            </ScalarOperator>
                                                                                          </ColumnReference>
                                                                                        </Identifier>
                                                                                      </ScalarOperator>
                                                                                    </Compare>
                                                                                  </ScalarOperator>
                                                                                </Logical>
                                                                              </ScalarOperator>
                                                                            </Predicate>
                                                                          </IndexScan>
                                                                        </RelOp>
                                                                      </ComputeScalar>
                                                                    </RelOp>
                                                                  </Parallelism>
                                                                </RelOp>
                                                              </Bitmap>
                                                            </RelOp>
                                                            <RelOp AvgRowSize="17" EstimateCPU="0.582166" EstimateIO="0" EstimateRebinds="0" EstimateRewinds="0" EstimatedExecutionMode="Row" EstimateRows="879708" LogicalOp="Repartition Streams" NodeId="22" Parallel="true" PhysicalOp="Parallelism" EstimatedTotalSubtreeCost="2.44586">
                                                              <OutputList>
                                                                <ColumnReference Database="[SANKHYA_TESTE]" Schema="[sankhya]" Table="[TGFCAB]" Column="NUNOTA" />
                                                                <ColumnReference Database="[SANKHYA_TESTE]" Schema="[sankhya]" Table="[TGFCAB]" Column="CODPARC" />
                                                                <ColumnReference Database="[SANKHYA_TESTE]" Schema="[sankhya]" Table="[TGFCAB]" Column="CODVEND" />
                                                              </OutputList>
                                                              <Parallelism PartitioningType="Hash">
                                                                <PartitionColumns>
                                                                  <ColumnReference Database="[SANKHYA_TESTE]" Schema="[sankhya]" Table="[TGFCAB]" Column="NUNOTA" />
                                                                </PartitionColumns>
                                                                <RelOp AvgRowSize="17" EstimateCPU="0.161306" EstimateIO="1.70238" EstimateRebinds="0" EstimateRewinds="0" EstimatedExecutionMode="Row" EstimateRows="879708" EstimatedRowsRead="879708" LogicalOp="Index Scan" NodeId="23" Parallel="true" PhysicalOp="Index Scan" EstimatedTotalSubtreeCost="1.86369" TableCardinality="879708">
                                                                  <OutputList>
                                                                    <ColumnReference Database="[SANKHYA_TESTE]" Schema="[sankhya]" Table="[TGFCAB]" Column="NUNOTA" />
                                                                    <ColumnReference Database="[SANKHYA_TESTE]" Schema="[sankhya]" Table="[TGFCAB]" Column="CODPARC" />
                                                                    <ColumnReference Database="[SANKHYA_TESTE]" Schema="[sankhya]" Table="[TGFCAB]" Column="CODVEND" />
                                                                  </OutputList>
                                                                  <IndexScan Ordered="false" ForcedIndex="false" ForceSeek="false" ForceScan="false" NoExpandHint="false" Storage="RowStore">
                                                                    <DefinedValues>
                                                                      <DefinedValue>
                                                                        <ColumnReference Database="[SANKHYA_TESTE]" Schema="[sankhya]" Table="[TGFCAB]" Column="NUNOTA" />
                                                                      </DefinedValue>
                                                                      <DefinedValue>
                                                                        <ColumnReference Database="[SANKHYA_TESTE]" Schema="[sankhya]" Table="[TGFCAB]" Column="CODPARC" />
                                                                      </DefinedValue>
                                                                      <DefinedValue>
                                                                        <ColumnReference Database="[SANKHYA_TESTE]" Schema="[sankhya]" Table="[TGFCAB]" Column="CODVEND" />
                                                                      </DefinedValue>
                                                                    </DefinedValues>
                                                                    <Object Database="[SANKHYA_TESTE]" Schema="[sankhya]" Table="[TGFCAB]" Index="[IDX_N_TGFCAB_8001D]" IndexKind="NonClustered" Storage="RowStore" />
                                                                    <Predicate>
                                                                      <ScalarOperator ScalarString="PROBE([Bitmap1050],[SANKHYA_TESTE].[sankhya].[TGFCAB].[NUNOTA],N'[IN ROW]')">
                                                                        <Intrinsic FunctionName="PROBE">
                                                                          <ScalarOperator>
                                                                            <Identifier>
                                                                              <ColumnReference Column="Bitmap1050" />
                                                                            </Identifier>
                                                                          </ScalarOperator>
                                                                          <ScalarOperator>
                                                                            <Identifier>
                                                                              <ColumnReference Database="[SANKHYA_TESTE]" Schema="[sankhya]" Table="[TGFCAB]" Column="NUNOTA" />
                                                                            </Identifier>
                                                                          </ScalarOperator>
                                                                          <ScalarOperator>
                                                                            <Const ConstValue="N'[IN ROW]'" />
                                                                          </ScalarOperator>
                                                                        </Intrinsic>
                                                                      </ScalarOperator>
                                                                    </Predicate>
                                                                  </IndexScan>
                                                                </RelOp>
                                                              </Parallelism>
                                                            </RelOp>
                                                          </Hash>
                                                        </RelOp>
                                                      </Parallelism>
                                                    </RelOp>
                                                  </Hash>
                                                </RelOp>
                                                <RelOp AvgRowSize="11" EstimateCPU="0.879966" EstimateIO="16.9929" EstimateRebinds="24137.2" EstimateRewinds="0.00706072" EstimatedExecutionMode="Row" EstimateRows="1" LogicalOp="Eager Spool" NodeId="24" Parallel="true" PhysicalOp="Index Spool" EstimatedTotalSubtreeCost="34.1928">
                                                  <OutputList>
                                                    <ColumnReference Database="[SANKHYA_TESTE]" Schema="[sankhya]" Table="[TGFCAB]" Alias="[NF]" Column="NUMNOTA" />
                                                  </OutputList>
                                                  <Spool>
                                                    <SeekPredicateNew>
                                                      <SeekKeys>
                                                        <Prefix ScanType="EQ">
                                                          <RangeColumns>
                                                            <ColumnReference Database="[SANKHYA_TESTE]" Schema="[sankhya]" Table="[TGFCAB]" Alias="[NF]" Column="NUNOTA" />
                                                          </RangeColumns>
                                                          <RangeExpressions>
                                                            <ScalarOperator ScalarString="[SANKHYA_TESTE].[sankhya].[AD_ROTEIROENTREGA].[NUNOTA]">
                                                              <Identifier>
                                                                <ColumnReference Database="[SANKHYA_TESTE]" Schema="[sankhya]" Table="[AD_ROTEIROENTREGA]" Column="NUNOTA" />
                                                              </Identifier>
                                                            </ScalarOperator>
                                                          </RangeExpressions>
                                                        </Prefix>
                                                      </SeekKeys>
                                                    </SeekPredicateNew>
                                                    <RelOp AvgRowSize="15" EstimateCPU="0.967836" EstimateIO="1.26979" EstimateRebinds="0" EstimateRewinds="0" EstimatedExecutionMode="Row" EstimateRows="879708" EstimatedRowsRead="879708" LogicalOp="Index Scan" NodeId="25" Parallel="true" PhysicalOp="Index Scan" EstimatedTotalSubtreeCost="2.23763" TableCardinality="879708">
                                                      <OutputList>
                                                        <ColumnReference Database="[SANKHYA_TESTE]" Schema="[sankhya]" Table="[TGFCAB]" Alias="[NF]" Column="NUNOTA" />
                                                        <ColumnReference Database="[SANKHYA_TESTE]" Schema="[sankhya]" Table="[TGFCAB]" Alias="[NF]" Column="NUMNOTA" />
                                                      </OutputList>
                                                      <IndexScan Ordered="false" ForcedIndex="false" ForceSeek="false" ForceScan="false" NoExpandHint="false" Storage="RowStore">
                                                        <DefinedValues>
                                                          <DefinedValue>
                                                            <ColumnReference Database="[SANKHYA_TESTE]" Schema="[sankhya]" Table="[TGFCAB]" Alias="[NF]" Column="NUNOTA" />
                                                          </DefinedValue>
                                                          <DefinedValue>
                                                            <ColumnReference Database="[SANKHYA_TESTE]" Schema="[sankhya]" Table="[TGFCAB]" Alias="[NF]" Column="NUMNOTA" />
                                                          </DefinedValue>
                                                        </DefinedValues>
                                                        <Object Database="[SANKHYA_TESTE]" Schema="[sankhya]" Table="[TGFCAB]" Index="[TGFCAB_I01]" Alias="[NF]" TableReferenceId="1" IndexKind="NonClustered" Storage="RowStore" />
                                                      </IndexScan>
                                                    </RelOp>
                                                  </Spool>
                                                </RelOp>
                                              </NestedLoops>
                                            </RelOp>
                                            <RelOp AvgRowSize="11" EstimateCPU="4.8E-07" EstimateIO="0" EstimateRebinds="24137.2" EstimateRewinds="0.00706072" EstimatedExecutionMode="Row" EstimateRows="1" LogicalOp="Assert" NodeId="26" Parallel="true" PhysicalOp="Assert" EstimatedTotalSubtreeCost="80.0382">
                                              <OutputList>
                                                <ColumnReference Column="Expr1039" />
                                              </OutputList>
                                              <Assert StartupExpression="false">
                                                <RelOp AvgRowSize="19" EstimateCPU="1.1E-06" EstimateIO="0" EstimateRebinds="24137.2" EstimateRewinds="0.00706072" EstimatedExecutionMode="Row" EstimateRows="1" LogicalOp="Aggregate" NodeId="27" Parallel="true" PhysicalOp="Stream Aggregate" EstimatedTotalSubtreeCost="80.0267">
                                                  <OutputList>
                                                    <ColumnReference Column="Expr1038" />
                                                    <ColumnReference Column="Expr1039" />
                                                  </OutputList>
                                                  <StreamAggregate>
                                                    <DefinedValues>
                                                      <DefinedValue>
                                                        <ColumnReference Column="Expr1038" />
                                                        <ScalarOperator ScalarString="Count(*)">
                                                          <Aggregate AggType="countstar" Distinct="false" />
                                                        </ScalarOperator>
                                                      </DefinedValue>
                                                      <DefinedValue>
                                                        <ColumnReference Column="Expr1039" />
                                                        <ScalarOperator ScalarString="ANY([SANKHYA_TESTE].[sankhya].[TGFCAB].[NUMNOTA] as [NF].[NUMNOTA])">
                                                          <Aggregate AggType="ANY" Distinct="false">
                                                            <ScalarOperator>
                                                              <Identifier>
                                                                <ColumnReference Database="[SANKHYA_TESTE]" Schema="[sankhya]" Table="[TGFCAB]" Alias="[NF]" Column="NUMNOTA" />
                                                              </Identifier>
                                                            </ScalarOperator>
                                                          </Aggregate>
                                                        </ScalarOperator>
                                                      </DefinedValue>
                                                    </DefinedValues>
                                                    <RelOp AvgRowSize="11" EstimateCPU="4.18E-06" EstimateIO="0" EstimateRebinds="24137.2" EstimateRewinds="0.00706072" EstimatedExecutionMode="Row" EstimateRows="1" LogicalOp="Inner Join" NodeId="28" Parallel="true" PhysicalOp="Nested Loops" EstimatedTotalSubtreeCost="80.0001">
                                                      <OutputList>
                                                        <ColumnReference Database="[SANKHYA_TESTE]" Schema="[sankhya]" Table="[TGFCAB]" Alias="[NF]" Column="NUMNOTA" />
                                                      </OutputList>
                                                      <NestedLoops Optimized="false">
                                                        <OuterReferences>
                                                          <ColumnReference Database="[SANKHYA_TESTE]" Schema="[sankhya]" Table="[TGFVAR]" Column="NUNOTA" />
                                                        </OuterReferences>
                                                        <RelOp AvgRowSize="11" EstimateCPU="1E-07" EstimateIO="0" EstimateRebinds="24137.2" EstimateRewinds="0.00706072" EstimatedExecutionMode="Row" EstimateRows="1" LogicalOp="Top" NodeId="29" Parallel="true" PhysicalOp="Top" EstimatedTotalSubtreeCost="4.15511">
                                                          <OutputList>
                                                            <ColumnReference Database="[SANKHYA_TESTE]" Schema="[sankhya]" Table="[TGFVAR]" Column="NUNOTA" />
                                                          </OutputList>
                                                          <Top RowCount="false" IsPercent="false" WithTies="false">
                                                            <TopExpression>
                                                              <ScalarOperator ScalarString="(1)">
                                                                <Const ConstValue="(1)" />
                                                              </ScalarOperator>
                                                            </TopExpression>
                                                            <RelOp AvgRowSize="11" EstimateCPU="0.000220377" EstimateIO="0.003125" EstimateRebinds="24137.2" EstimateRewinds="0.00706072" EstimatedExecutionMode="Row" EstimateRows="1" EstimateRowsWithoutRowGoal="57.6154" EstimatedRowsRead="57.6154" LogicalOp="Index Seek" NodeId="30" Parallel="true" PhysicalOp="Index Seek" EstimatedTotalSubtreeCost="4.1527" TableCardinality="2531510">
                                                              <OutputList>
                                                                <ColumnReference Database="[SANKHYA_TESTE]" Schema="[sankhya]" Table="[TGFVAR]" Column="NUNOTA" />
                                                              </OutputList>
                                                              <IndexScan Ordered="true" ScanDirection="FORWARD" ForcedIndex="false" ForceSeek="false" ForceScan="false" NoExpandHint="false" Storage="RowStore">
                                                                <DefinedValues>
                                                                  <DefinedValue>
                                                                    <ColumnReference Database="[SANKHYA_TESTE]" Schema="[sankhya]" Table="[TGFVAR]" Column="NUNOTA" />
                                                                  </DefinedValue>
                                                                </DefinedValues>
                                                                <Object Database="[SANKHYA_TESTE]" Schema="[sankhya]" Table="[TGFVAR]" Index="[TGFVAR_I01]" TableReferenceId="1" IndexKind="NonClustered" Storage="RowStore" />
                                                                <SeekPredicates>
                                                                  <SeekPredicateNew>
                                                                    <SeekKeys>
                                                                      <Prefix ScanType="EQ">
                                                                        <RangeColumns>
                                                                          <ColumnReference Database="[SANKHYA_TESTE]" Schema="[sankhya]" Table="[TGFVAR]" Column="NUNOTAORIG" />
                                                                        </RangeColumns>
                                                                        <RangeExpressions>
                                                                          <ScalarOperator ScalarString="[SANKHYA_TESTE].[sankhya].[AD_ROTEIROENTREGA].[NUNOTA]">
                                                                            <Identifier>
                                                                              <ColumnReference Database="[SANKHYA_TESTE]" Schema="[sankhya]" Table="[AD_ROTEIROENTREGA]" Column="NUNOTA" />
                                                                            </Identifier>
                                                                          </ScalarOperator>
                                                                        </RangeExpressions>
                                                                      </Prefix>
                                                                    </SeekKeys>
                                                                  </SeekPredicateNew>
                                                                </SeekPredicates>
                                                              </IndexScan>
                                                            </RelOp>
                                                          </Top>
                                                        </RelOp>
                                                        <RelOp AvgRowSize="11" EstimateCPU="0.0001581" EstimateIO="0.003125" EstimateRebinds="24137.2" EstimateRewinds="0.00706072" EstimatedExecutionMode="Row" EstimateRows="1" EstimatedRowsRead="1" LogicalOp="Clustered Index Seek" NodeId="31" Parallel="true" PhysicalOp="Clustered Index Seek" EstimatedTotalSubtreeCost="75.7441" TableCardinality="879708">
                                                          <OutputList>
                                                            <ColumnReference Database="[SANKHYA_TESTE]" Schema="[sankhya]" Table="[TGFCAB]" Alias="[NF]" Column="NUMNOTA" />
                                                          </OutputList>
                                                          <IndexScan Ordered="true" ScanDirection="FORWARD" ForcedIndex="false" ForceSeek="false" ForceScan="false" NoExpandHint="false" Storage="RowStore">
                                                            <DefinedValues>
                                                              <DefinedValue>
                                                                <ColumnReference Database="[SANKHYA_TESTE]" Schema="[sankhya]" Table="[TGFCAB]" Alias="[NF]" Column="NUMNOTA" />
                                                              </DefinedValue>
                                                            </DefinedValues>
                                                            <Object Database="[SANKHYA_TESTE]" Schema="[sankhya]" Table="[TGFCAB]" Index="[PK_TGFCAB]" Alias="[NF]" TableReferenceId="2" IndexKind="Clustered" Storage="RowStore" />
                                                            <SeekPredicates>
                                                              <SeekPredicateNew>
                                                                <SeekKeys>
                                                                  <Prefix ScanType="EQ">
                                                                    <RangeColumns>
                                                                      <ColumnReference Database="[SANKHYA_TESTE]" Schema="[sankhya]" Table="[TGFCAB]" Alias="[NF]" Column="NUNOTA" />
                                                                    </RangeColumns>
                                                                    <RangeExpressions>
                                                                      <ScalarOperator ScalarString="[SANKHYA_TESTE].[sankhya].[TGFVAR].[NUNOTA]">
                                                                        <Identifier>
                                                                          <ColumnReference Database="[SANKHYA_TESTE]" Schema="[sankhya]" Table="[TGFVAR]" Column="NUNOTA" />
                                                                        </Identifier>
                                                                      </ScalarOperator>
                                                                    </RangeExpressions>
                                                                  </Prefix>
                                                                </SeekKeys>
                                                              </SeekPredicateNew>
                                                            </SeekPredicates>
                                                          </IndexScan>
                                                        </RelOp>
                                                      </NestedLoops>
                                                    </RelOp>
                                                  </StreamAggregate>
                                                </RelOp>
                                                <Predicate>
                                                  <ScalarOperator ScalarString="CASE WHEN [Expr1038]&gt;(1) THEN (0) ELSE NULL END">
                                                    <IF>
                                                      <Condition>
                                                        <ScalarOperator>
                                                          <Compare CompareOp="GT">
                                                            <ScalarOperator>
                                                              <Identifier>
                                                                <ColumnReference Column="Expr1038" />
                                                              </Identifier>
                                                            </ScalarOperator>
                                                            <ScalarOperator>
                                                              <Const ConstValue="(1)" />
                                                            </ScalarOperator>
                                                          </Compare>
                                                        </ScalarOperator>
                                                      </Condition>
                                                      <Then>
                                                        <ScalarOperator>
                                                          <Const ConstValue="(0)" />
                                                        </ScalarOperator>
                                                      </Then>
                                                      <Else>
                                                        <ScalarOperator>
                                                          <Const ConstValue="NULL" />
                                                        </ScalarOperator>
                                                      </Else>
                                                    </IF>
                                                  </ScalarOperator>
                                                </Predicate>
                                              </Assert>
                                            </RelOp>
                                          </NestedLoops>
                                        </RelOp>
                                        <RelOp AvgRowSize="15" EstimateCPU="0.879966" EstimateIO="19.9591" EstimateRebinds="24137.2" EstimateRewinds="0.00706072" EstimatedExecutionMode="Row" EstimateRows="1" LogicalOp="Eager Spool" NodeId="32" Parallel="true" PhysicalOp="Index Spool" EstimatedTotalSubtreeCost="38.9169">
                                          <OutputList>
                                            <ColumnReference Database="[SANKHYA_TESTE]" Schema="[sankhya]" Table="[TGFCAB]" Alias="[NF]" Column="DTNEG" />
                                          </OutputList>
                                          <Spool>
                                            <SeekPredicateNew>
                                              <SeekKeys>
                                                <Prefix ScanType="EQ">
                                                  <RangeColumns>
                                                    <ColumnReference Database="[SANKHYA_TESTE]" Schema="[sankhya]" Table="[TGFCAB]" Alias="[NF]" Column="NUNOTA" />
                                                  </RangeColumns>
                                                  <RangeExpressions>
                                                    <ScalarOperator ScalarString="[SANKHYA_TESTE].[sankhya].[AD_ROTEIROENTREGA].[NUNOTA]">
                                                      <Identifier>
                                                        <ColumnReference Database="[SANKHYA_TESTE]" Schema="[sankhya]" Table="[AD_ROTEIROENTREGA]" Column="NUNOTA" />
                                                      </Identifier>
                                                    </ScalarOperator>
                                                  </RangeExpressions>
                                                </Prefix>
                                              </SeekKeys>
                                            </SeekPredicateNew>
                                            <RelOp AvgRowSize="19" EstimateCPU="0.967836" EstimateIO="1.65794" EstimateRebinds="0" EstimateRewinds="0" EstimatedExecutionMode="Row" EstimateRows="879708" EstimatedRowsRead="879708" LogicalOp="Index Scan" NodeId="33" Parallel="true" PhysicalOp="Index Scan" EstimatedTotalSubtreeCost="2.62578" TableCardinality="879708">
                                              <OutputList>
                                                <ColumnReference Database="[SANKHYA_TESTE]" Schema="[sankhya]" Table="[TGFCAB]" Alias="[NF]" Column="NUNOTA" />
                                                <ColumnReference Database="[SANKHYA_TESTE]" Schema="[sankhya]" Table="[TGFCAB]" Alias="[NF]" Column="DTNEG" />
                                              </OutputList>
                                              <IndexScan Ordered="false" ForcedIndex="false" ForceSeek="false" ForceScan="false" NoExpandHint="false" Storage="RowStore">
                                                <DefinedValues>
                                                  <DefinedValue>
                                                    <ColumnReference Database="[SANKHYA_TESTE]" Schema="[sankhya]" Table="[TGFCAB]" Alias="[NF]" Column="NUNOTA" />
                                                  </DefinedValue>
                                                  <DefinedValue>
                                                    <ColumnReference Database="[SANKHYA_TESTE]" Schema="[sankhya]" Table="[TGFCAB]" Alias="[NF]" Column="DTNEG" />
                                                  </DefinedValue>
                                                </DefinedValues>
                                                <Object Database="[SANKHYA_TESTE]" Schema="[sankhya]" Table="[TGFCAB]" Index="[TGFCAB_I02]" Alias="[NF]" TableReferenceId="3" IndexKind="NonClustered" Storage="RowStore" />
                                              </IndexScan>
                                            </RelOp>
                                          </Spool>
                                        </RelOp>
                                      </NestedLoops>
                                    </RelOp>
                                    <RelOp AvgRowSize="15" EstimateCPU="4.8E-07" EstimateIO="0" EstimateRebinds="24137.2" EstimateRewinds="0.00706072" EstimatedExecutionMode="Row" EstimateRows="1" LogicalOp="Assert" NodeId="34" Parallel="true" PhysicalOp="Assert" EstimatedTotalSubtreeCost="80.0382">
                                      <OutputList>
                                        <ColumnReference Column="Expr1041" />
                                      </OutputList>
                                      <Assert StartupExpression="false">
                                        <RelOp AvgRowSize="23" EstimateCPU="1.1E-06" EstimateIO="0" EstimateRebinds="24137.2" EstimateRewinds="0.00706072" EstimatedExecutionMode="Row" EstimateRows="1" LogicalOp="Aggregate" NodeId="35" Parallel="true" PhysicalOp="Stream Aggregate" EstimatedTotalSubtreeCost="80.0267">
                                          <OutputList>
                                            <ColumnReference Column="Expr1040" />
                                            <ColumnReference Column="Expr1041" />
                                          </OutputList>
                                          <StreamAggregate>
                                            <DefinedValues>
                                              <DefinedValue>
                                                <ColumnReference Column="Expr1040" />
                                                <ScalarOperator ScalarString="Count(*)">
                                                  <Aggregate AggType="countstar" Distinct="false" />
                                                </ScalarOperator>
                                              </DefinedValue>
                                              <DefinedValue>
                                                <ColumnReference Column="Expr1041" />
                                                <ScalarOperator ScalarString="ANY([SANKHYA_TESTE].[sankhya].[TGFCAB].[DTNEG] as [NF].[DTNEG])">
                                                  <Aggregate AggType="ANY" Distinct="false">
                                                    <ScalarOperator>
                                                      <Identifier>
                                                        <ColumnReference Database="[SANKHYA_TESTE]" Schema="[sankhya]" Table="[TGFCAB]" Alias="[NF]" Column="DTNEG" />
                                                      </Identifier>
                                                    </ScalarOperator>
                                                  </Aggregate>
                                                </ScalarOperator>
                                              </DefinedValue>
                                            </DefinedValues>
                                            <RelOp AvgRowSize="15" EstimateCPU="4.18E-06" EstimateIO="0" EstimateRebinds="24137.2" EstimateRewinds="0.00706072" EstimatedExecutionMode="Row" EstimateRows="1" LogicalOp="Inner Join" NodeId="36" Parallel="true" PhysicalOp="Nested Loops" EstimatedTotalSubtreeCost="80.0001">
                                              <OutputList>
                                                <ColumnReference Database="[SANKHYA_TESTE]" Schema="[sankhya]" Table="[TGFCAB]" Alias="[NF]" Column="DTNEG" />
                                              </OutputList>
                                              <NestedLoops Optimized="false">
                                                <OuterReferences>
                                                  <ColumnReference Database="[SANKHYA_TESTE]" Schema="[sankhya]" Table="[TGFVAR]" Column="NUNOTA" />
                                                </OuterReferences>
                                                <RelOp AvgRowSize="11" EstimateCPU="1E-07" EstimateIO="0" EstimateRebinds="24137.2" EstimateRewinds="0.00706072" EstimatedExecutionMode="Row" EstimateRows="1" LogicalOp="Top" NodeId="37" Parallel="true" PhysicalOp="Top" EstimatedTotalSubtreeCost="4.15511">
                                                  <OutputList>
                                                    <ColumnReference Database="[SANKHYA_TESTE]" Schema="[sankhya]" Table="[TGFVAR]" Column="NUNOTA" />
                                                  </OutputList>
                                                  <Top RowCount="false" IsPercent="false" WithTies="false">
                                                    <TopExpression>
                                                      <ScalarOperator ScalarString="(1)">
                                                        <Const ConstValue="(1)" />
                                                      </ScalarOperator>
                                                    </TopExpression>
                                                    <RelOp AvgRowSize="11" EstimateCPU="0.000220377" EstimateIO="0.003125" EstimateRebinds="24137.2" EstimateRewinds="0.00706072" EstimatedExecutionMode="Row" EstimateRows="1" EstimateRowsWithoutRowGoal="57.6154" EstimatedRowsRead="57.6154" LogicalOp="Index Seek" NodeId="38" Parallel="true" PhysicalOp="Index Seek" EstimatedTotalSubtreeCost="4.1527" TableCardinality="2531510">
                                                      <OutputList>
                                                        <ColumnReference Database="[SANKHYA_TESTE]" Schema="[sankhya]" Table="[TGFVAR]" Column="NUNOTA" />
                                                      </OutputList>
                                                      <IndexScan Ordered="true" ScanDirection="FORWARD" ForcedIndex="false" ForceSeek="false" ForceScan="false" NoExpandHint="false" Storage="RowStore">
                                                        <DefinedValues>
                                                          <DefinedValue>
                                                            <ColumnReference Database="[SANKHYA_TESTE]" Schema="[sankhya]" Table="[TGFVAR]" Column="NUNOTA" />
                                                          </DefinedValue>
                                                        </DefinedValues>
                                                        <Object Database="[SANKHYA_TESTE]" Schema="[sankhya]" Table="[TGFVAR]" Index="[TGFVAR_I01]" TableReferenceId="2" IndexKind="NonClustered" Storage="RowStore" />
                                                        <SeekPredicates>
                                                          <SeekPredicateNew>
                                                            <SeekKeys>
                                                              <Prefix ScanType="EQ">
                                                                <RangeColumns>
                                                                  <ColumnReference Database="[SANKHYA_TESTE]" Schema="[sankhya]" Table="[TGFVAR]" Column="NUNOTAORIG" />
                                                                </RangeColumns>
                                                                <RangeExpressions>
                                                                  <ScalarOperator ScalarString="[SANKHYA_TESTE].[sankhya].[AD_ROTEIROENTREGA].[NUNOTA]">
                                                                    <Identifier>
                                                                      <ColumnReference Database="[SANKHYA_TESTE]" Schema="[sankhya]" Table="[AD_ROTEIROENTREGA]" Column="NUNOTA" />
                                                                    </Identifier>
                                                                  </ScalarOperator>
                                                                </RangeExpressions>
                                                              </Prefix>
                                                            </SeekKeys>
                                                          </SeekPredicateNew>
                                                        </SeekPredicates>
                                                      </IndexScan>
                                                    </RelOp>
                                                  </Top>
                                                </RelOp>
                                                <RelOp AvgRowSize="15" EstimateCPU="0.0001581" EstimateIO="0.003125" EstimateRebinds="24137.2" EstimateRewinds="0.00706072" EstimatedExecutionMode="Row" EstimateRows="1" EstimatedRowsRead="1" LogicalOp="Clustered Index Seek" NodeId="39" Parallel="true" PhysicalOp="Clustered Index Seek" EstimatedTotalSubtreeCost="75.7441" TableCardinality="879708">
                                                  <OutputList>
                                                    <ColumnReference Database="[SANKHYA_TESTE]" Schema="[sankhya]" Table="[TGFCAB]" Alias="[NF]" Column="DTNEG" />
                                                  </OutputList>
                                                  <IndexScan Ordered="true" ScanDirection="FORWARD" ForcedIndex="false" ForceSeek="false" ForceScan="false" NoExpandHint="false" Storage="RowStore">
                                                    <DefinedValues>
                                                      <DefinedValue>
                                                        <ColumnReference Database="[SANKHYA_TESTE]" Schema="[sankhya]" Table="[TGFCAB]" Alias="[NF]" Column="DTNEG" />
                                                      </DefinedValue>
                                                    </DefinedValues>
                                                    <Object Database="[SANKHYA_TESTE]" Schema="[sankhya]" Table="[TGFCAB]" Index="[PK_TGFCAB]" Alias="[NF]" TableReferenceId="4" IndexKind="Clustered" Storage="RowStore" />
                                                    <SeekPredicates>
                                                      <SeekPredicateNew>
                                                        <SeekKeys>
                                                          <Prefix ScanType="EQ">
                                                            <RangeColumns>
                                                              <ColumnReference Database="[SANKHYA_TESTE]" Schema="[sankhya]" Table="[TGFCAB]" Alias="[NF]" Column="NUNOTA" />
                                                            </RangeColumns>
                                                            <RangeExpressions>
                                                              <ScalarOperator ScalarString="[SANKHYA_TESTE].[sankhya].[TGFVAR].[NUNOTA]">
                                                                <Identifier>
                                                                  <ColumnReference Database="[SANKHYA_TESTE]" Schema="[sankhya]" Table="[TGFVAR]" Column="NUNOTA" />
                                                                </Identifier>
                                                              </ScalarOperator>
                                                            </RangeExpressions>
                                                          </Prefix>
                                                        </SeekKeys>
                                                      </SeekPredicateNew>
                                                    </SeekPredicates>
                                                  </IndexScan>
                                                </RelOp>
                                              </NestedLoops>
                                            </RelOp>
                                          </StreamAggregate>
                                        </RelOp>
                                        <Predicate>
                                          <ScalarOperator ScalarString="CASE WHEN [Expr1040]&gt;(1) THEN (0) ELSE NULL END">
                                            <IF>
                                              <Condition>
                                                <ScalarOperator>
                                                  <Compare CompareOp="GT">
                                                    <ScalarOperator>
                                                      <Identifier>
                                                        <ColumnReference Column="Expr1040" />
                                                      </Identifier>
                                                    </ScalarOperator>
                                                    <ScalarOperator>
                                                      <Const ConstValue="(1)" />
                                                    </ScalarOperator>
                                                  </Compare>
                                                </ScalarOperator>
                                              </Condition>
                                              <Then>
                                                <ScalarOperator>
                                                  <Const ConstValue="(0)" />
                                                </ScalarOperator>
                                              </Then>
                                              <Else>
                                                <ScalarOperator>
                                                  <Const ConstValue="NULL" />
                                                </ScalarOperator>
                                              </Else>
                                            </IF>
                                          </ScalarOperator>
                                        </Predicate>
                                      </Assert>
                                    </RelOp>
                                  </NestedLoops>
                                </RelOp>
                              </Parallelism>
                            </RelOp>
                          </Hash>
                        </RelOp>
                      </ComputeScalar>
                    </RelOp>
                  </Sort>
                </RelOp>
              </Parallelism>
            </RelOp>
          </QueryPlan>
        </StmtSimple>
      </Statements>
    </Batch>
  </BatchSequence>
</ShowPlanXML>