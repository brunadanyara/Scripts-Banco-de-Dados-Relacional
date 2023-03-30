-- liquibase formatted sql
-- item(s): [condicaopagamento]
-- changeset bruna.danyara:1 dbms:postgresql
-- CONDICAO PAGAMENTO POR EMPRESA Postgres
INSERT INTO condicaopagamento (idempresa, nome, aprazo , utilizadatafixa, diafixo ,numeroparcelas ,contagemdiasuteis , comentrada , vencimentolivre,codigo)
	(SELECT c.idempresa ,'condicao default para opcao compra',2,0,0,1,0,0,1,
       (select coalesce((SELECT max(sequenciaatual) FROM controlesequencia cs WHERE cs.classe = 'CondicaoPagamento' AND cs.campo = 'codigo' AND cs.expressao = '[empresa='||c.idempresa||']'), (select max(cond.codigo) from condicaopagamento cond),0)+1 AS codigo)
FROM condicaopagamento c
JOIN empresa e ON e.id = c.idempresa
WHERE c.aprazo = 1 AND c.systemdeleted = 0
AND NOT EXISTS (select 1 from condicaopagamento where nome = 'condicao default para opcao compra')
AND ( EXISTS (select 1 from opcaocompra oc join filial on filial.id = oc.idfilialcadastro and filial.idempresa = e.id where oc.idcondicaopagamento is null limit 1)
   OR EXISTS (select 1 from contratoagricolacompra c where c.idempresa = e.id limit 1)));
-- rollback ;

-- liquibase formatted sql
-- item(s): [condicaopagamento]
-- changeset bruna.danyara:2 dbms:oracle
-- CONDICAO PAGAMENTO POR EMPRESA Oracle
INSERT INTO condicaopagamento (idempresa, nome, aprazo , utilizadatafixa, diafixo ,numeroparcelas ,contagemdiasuteis , comentrada , vencimentolivre,codigo)
	(SELECT c.idempresa ,'condicao default para opcao compra',2,0,0,1,0,0,1,
       (select coalesce((SELECT max(sequenciaatual) FROM controlesequencia cs WHERE cs.classe = 'CondicaoPagamento' AND cs.campo = 'codigo' AND cs.expressao = '[empresa='||c.idempresa||']'), (select max(cond.codigo) from condicaopagamento cond),0)+1 AS codigo FROM dual)
FROM condicaopagamento c
JOIN empresa e ON e.id = c.idempresa
WHERE c.aprazo = 1 AND c.systemdeleted = 0
AND NOT EXISTS (select 1 from condicaopagamento where nome = 'condicao default para opcao compra' AND ROWNUM = 1)
AND ( EXISTS (select 1 from opcaocompra oc join filial on filial.id = oc.idfilialcadastro and filial.idempresa = e.id where oc.idcondicaopagamento is null AND ROWNUM = 1)
   OR EXISTS (select 1 from contratoagricolacompra c where c.idempresa = e.id AND ROWNUM = 1)));
-- rollback ;

-- liquibase formatted sql
-- item(s): [controlesequencia]
-- changeset bruna.danyara:3
-- UPDATE SEQUENCE codigo
UPDATE controlesequencia SET sequenciaatual =
(SELECT max(c.codigo) as codigo
FROM condicaopagamento c
WHERE c.idempresa = cast( replace((replace(controlesequencia.expressao, '[empresa=', '')) , ']', '') as int))
WHERE ID IN
(   SELECT cs.id
    FROM controlesequencia cs
    JOIN(select c.idempresa, max(c.codigo) as codigo
            from condicaopagamento c group by c.idempresa
            ) cond on cond.idempresa = cast( replace((replace(cs.expressao, '[empresa=', '')) , ']', '') as int)
    WHERE cs.classe = 'CondicaoPagamento'
    AND cs.campo = 'codigo'
    AND cs.sequenciaatual <> cond.codigo );
-- rollback ;

-- liquibase formatted sql
-- item(s): [prazocondicaopagamento]
-- changeset bruna.danyara:4
-- PRAZO CONDICAO PAGAMENTO
INSERT INTO prazocondicaopagamento (idcondicaopagamento, parcela, numerodias)
	((SELECT c.id,1,20 FROM condicaopagamento c WHERE c.nome = 'condicao default para opcao compra'
	AND NOT EXISTS (select * from prazocondicaopagamento p join condicaopagamento cond on cond.id = p.idcondicaopagamento
	WHERE cond.nome = 'condicao default para opcao compra' and cond.systemdeleted = 0 and p.systemdeleted = 0)));
-- rollback ;

-- liquibase formatted sql
-- item(s): [opcaocompra]
-- changeset bruna.danyara:5
-- UPDATE opcao de compra sem condicao pagamento
UPDATE opcaocompra
SET idcondicaopagamento =
( SELECT DISTINCT c.id FROM filial f
JOIN opcaocompra o ON o.idfilialcadastro = f.id
JOIN condicaopagamento c ON c.idempresa = f.idempresa
WHERE  c.nome = 'condicao default para opcao compra'
AND c.idempresa = f.idempresa
AND c.systemdeleted = 0)
WHERE idcondicaopagamento IS NULL;
-- rollback ;

-- liquibase formatted sql
-- item(s): [itemcontratoagricolacompra]
-- changeset bruna.danyara:6
-- UPDATE item contrato de compra sem condicao pagamento
UPDATE itemcontratoagricolacompra
SET idcondicaopagamento =
(SELECT DISTINCT c.id FROM itemcontratoagricolacompra i
JOIN contratoagricolacompra con on con.id = i.idcontratoagricolacompra
JOIN condicaopagamento c ON c.idempresa = con.idempresa
WHERE c.nome = 'condicao default para opcao compra'
AND c.idempresa = con.idempresa
AND c.systemdeleted = 0)
 WHERE idcondicaopagamento IS NULL;
-- rollback ;
