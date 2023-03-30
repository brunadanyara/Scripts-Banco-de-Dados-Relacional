-- liquibase formatted sql
-- item(s): [DocumentoFaturamento]
-- changeset bruna.danyara:1
-- Update DACUMENTOFATURAMENTO column TIPOPESSOAASSOCIADO
UPDATE documentofaturamento doc SET tipopessoaassociado = CASE
WHEN doc.id in (select docfat.id from documentofaturamento docfat
join local loc on loc.id = docfat.idlocal
join pessoa pess on pess.id = loc.idpessoa
join associado asso on asso.idpessoa = pess.id 
join eventoassociado eve on eve.idassociado = asso.id 
where 
docfat.systemdeleted = 0
and eve.tipoevento = 1
and (docfat.datahoraemissao between eve.iniciovigencia and eve.fimvigencia 
or docfat.datahoraemissao >= eve.iniciovigencia and eve.fimvigencia is null)) THEN 1
ELSE 2 END
WHERE
doc.systemdeleted = 0
AND doc.tipopessoaassociado is null;
-- rollback ;

-- changeset bruna.danyara:2
-- Update MovimentoEstoque column TIPOPESSOAASSOCIADO
UPDATE movimentoestoque mov SET tipopessoaassociado = CASE
WHEN mov.iditemdocfatproduto in  (select item.id from itemdocumentofaturamento item
join documentofaturamento docfat on docfat.id = item.iddocumentofaturamento
join local loc on loc.id = docfat.idlocal
join pessoa pess on pess.id = loc.idpessoa
join associado asso on asso.idpessoa = pess.id 
join eventoassociado eve on eve.idassociado = asso.id 
where 
docfat.systemdeleted = 0
and eve.tipoevento = 1
and (docfat.datahoraemissao between eve.iniciovigencia and eve.fimvigencia 
or docfat.datahoraemissao >= eve.iniciovigencia and eve.fimvigencia is null)) THEN 1
ELSE 2 END 
WHERE
mov.tipopessoaassociado is null
AND mov.systemdeleted = 0;
-- rollback ;
