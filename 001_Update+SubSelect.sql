-- liquibase formatted sql
-- item(s): [ItemDocFatProduto]
-- changeset bruna.danyara:1
-- Update Registros na column idprodutocontaestoque
update itemdocfatproduto set idprodutocontaestoque = (
select pce.id
from itemdocfatproduto idfp
join itemdocumentofaturamento idf on idf.id = idfp.id and idf.systemdeleted = 0
join documentofaturamento df on df.id = idf.iddocumentofaturamento and df.systemdeleted = 0
join configoperacaointerna coi on coi.id = idf.idconfigoperacaointerna and coi.systemdeleted = 0 and coi.atualizaestoque = 1
join produtocontaestoque pce on pce.idproduto = idfp.idproduto and pce.systemdeleted = 0
and df.datamovimento between pce.iniciovigencia and coalesce(pce.fimvigencia, to_date('99991231','YYYYMMDD'))
where idfp.id = itemdocfatproduto.id
)
where idprodutocontaestoque is null
and exists
(select 1
from itemdocumentofaturamento idf
join configoperacaointerna coi on coi.id = idf.idconfigoperacaointerna and coi.systemdeleted = 0 and coi.atualizaestoque = 1
where idf.id = itemdocfatproduto.id and idf.systemdeleted = 0
)
;
-- rollback ;