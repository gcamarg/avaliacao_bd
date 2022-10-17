# --- VIEW que apresenta visão mais detalhada do estoque
create view vEstoque as
	select f.nome as 'Fabricante', c.nome as 'Categoria', p.descricao, format(p.valorUnitario, 2), p.estoque,  format(p.estoque * p.valorUnitario, 2) as 'Valor Total'
    from produtos p
    left join categorias c on c.id = p.categoria_id
    left join fabricantes f on f.id = p.fabricante_id;

# --- VIEW que exibe LOG de eventos
create view vLogs as
	select f.nome as 'Fabricante', p.descricao as 'Produto', l.*
    from produtos p
    right join log l on l.produto_id = p.id
    left join fabricantes f on f.id = p.fabricante_id;

# --- View mais detalhada dos pedidos, ordenados por data
create view vPedido as 
	select pdo.id as pedido, pdo.data_pedido as 'Data', p.descricao as 'Produto', f.nome as 'Fabricante', i.quantidade as 'Quantidade',
		format(i.valorUnitario, 2) as 'Valor Unitário', format(i.valorTotal, 2) as 'Total [R$]', c.nome as 'Cliente'
	from itens i
    inner join produtos p on p.id = i.produto_id
    inner join fabricantes f on f.id = p.fabricante_id
    inner join pedidos pdo on pdo.id = i.pedido_id
    inner join clientes c on c.id = pdo.cliente_id
    order by pdo.data_pedido desc;

# --- VIEW listagem dos cliente por valor gasto
create view vListarValorGasto as
	select c.nome as 'Cliente', count(pdo.cliente_id) as '# de compras', sum(pdo.valorTotal) as 'Valor Total'
        from clientes c
        inner join pedidos pdo on pdo.cliente_id = c.id
		group by c.nome
        order by sum(pdo.valorTotal) desc;

# --- VIEW listagem dos clientes ordenado por cidade
create view vListarPorCidade as
	select e.cidade as 'Cidade', e.estado as 'Estado', c.nome as 'Cliente' 
    from enderecos e
    inner join clientes c on c.id = e.cliente_id
    order by e.cidade asc;


# --- Exemplo execução das views

select * from vEstoque;

select * from vLogs;

select * from vPedido;
select * from vPedido where pedido = 1;

select * from vListarValorGasto;

select * from vListarPorCidade;


