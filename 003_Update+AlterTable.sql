-- liquibase formatted sql
-- item(s): [pedidoVenda]
-- changeset bruna.danyara:1
-- MODIFICANDO TIPO CAMPOS OM

--PEDIDO ORIGEM = TMP AND TMP = NULL
 UPDATE
	pedidovenda
SET
	valorcotacao = valorcotacaotemp,
	valorliquidocotacao = valorliquidocotacaotemp,
	valorcotacaosugerido = valorcotacaosugeridotemp,
	valorcotacaoindexadorvinculado = valorcotacaoindexadorvinculadotemp,
	precoalvo = precoalvotemp,
	valortotalpedidooutrasmoedas = valortotalpedidooutrasmoedastemp,
	valortotalpedidocalcsemdescom = valortotalpedidocalcsemdescomtemp,
	valortotalpedidocalccomdescom = valortotalpedidocalccomdescomtemp,
	valorcotacaotemp = null,
	valorliquidocotacaotemp = null,
	valorcotacaosugeridotemp = null,
	valorcotacaoindexadorvinculadotemp = null,
	precoalvotemp = null,
	valortotalpedidooutrasmoedastemp = null,
	valortotalpedidocalcsemdescomtemp = null,
	valortotalpedidocalccomdescomtemp = null;
-- rollback ;

-- liquibase formatted sql
-- item(s): [itemPedidoVenda]
-- changeset bruna.danyara:2
-- MODIFICANDO TIPO CAMPOS OM

-- ITEM ORIGEM = TMP AND TMP = NULL
 UPDATE
	itempedidovenda
SET
	valorunitariooutrasmoedas = valorunitariooutrasmoedastemp,
	valortotaloutrasmoedas = valortotaloutrasmoedastemp,
	valortotalitemcalcsemrateioom = valortotalitemcalcsemrateioomtemp,
	valortotalitemcalccomdescom = valortotalitemcalccomdescomtemp,
	valorbrutoitemcalcom = valorbrutoitemcalcomtemp,
	valortotalitemcalcom = valortotalitemcalcomtemp,
	valortotalfaturadoom = valortotalfaturadoomtemp,
	valortotalbaixadoom = valortotalbaixadoomtemp,
	valorsaldoom = valorsaldoomtemp,
	valorunitariooutrasmoedastemp = null,
	valortotaloutrasmoedastemp = null,
	valortotalitemcalcsemrateioomtemp = null,
	valortotalitemcalccomdescomtemp = null,
	valorbrutoitemcalcomtemp = null,
	valortotalitemcalcomtemp = null,
	valortotalfaturadoomtemp = null,
	valortotalbaixadoomtemp = null,
	valorsaldoomtemp = null;
-- rollback ;

-- liquibase formatted sql
-- item(s): [parcelaPedidoVenda]
-- changeset bruna.danyara:3
-- MODIFICANDO TIPO CAMPOS OM

-- ITEM ORIGEM = TMP AND TMP = NULL
UPDATE parcelapedidovenda SET valorparcelaom = valorparcelaomtemp, valorparcelaomtemp = null;
-- rollback ;

-- liquibase formatted sql
-- item(s): [precoalvovigencia]
-- changeset bruna.danyara:4
-- MODIFICANDO TIPO CAMPOS OM Postgres

UPDATE precoalvovigencia SET preco = precotemp, precotemp = null;

-- rollback ;

-- liquibase formatted sql
-- item(s): [precoalvovigencia]
-- changeset bruna.danyara:5 dbms:postgresql
-- MODIFICANDO TIPO CAMPOS OM Postgres
-- ITEM TMP = ORIGEM AND ORIGEM = NULL
ALTER TABLE precoalvovigencia ALTER COLUMN preco SET NOT NULL;
-- rollback ;

-- liquibase formatted sql
-- item(s): [precoalvovigencia]
-- changeset bruna.danyara:6 dbms:oracle
-- MODIFICANDO TIPO CAMPOS OM Oracle
-- ITEM TMP = ORIGEM AND ORIGEM = NULL
ALTER TABLE precoalvovigencia MODIFY preco NOT NULL;
-- rollback ;
