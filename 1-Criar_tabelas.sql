create table categorias (
	id int primary key auto_increment,
    nome varchar(45)
);

create table fabricantes (
	id int primary key auto_increment,
    nome varchar(45)    
);

create table produtos (
	id int primary key auto_increment,
    categoria_id int,
    fabricante_id int,
    descricao varchar(80),
    valorUnitario float,
    estoque int,
    constraint fk_categoria foreign key (categoria_id)
    references categorias(id),
    constraint fk_fabricante foreign key (fabricante_id)
    references fabricantes(id)
);

create table clientes (
	id int primary key auto_increment,
    nome varchar(60),
    telefone varchar(14),
    email varchar(60)
);

create table enderecos (
	id int primary key auto_increment,
    cliente_id int,
    estado varchar(2),
    cidade varchar(45),
    cep varchar(8),
    logradouro varchar(60),
    constraint fk_cliente foreign key (cliente_id)
    references clientes(id)
);

create table transportadoras (
	id int primary key auto_increment,
    nome varchar(45)
);

create table pedidos (
	id int primary key auto_increment,
    cliente_id int,
    transportadora_id int,
    data_pedido datetime,
    valorTotal float,
    constraint fk_cliente2 foreign key (cliente_id)
    references clientes(id),
    constraint fk_transportadora foreign key (transportadora_id)
    references transportadoras(id)
);

create table itens (
	produto_id int,
    pedido_id int,
	quantidade int,
    valorUnitario float,
    valorTotal float,
    constraint fk_produto foreign key (produto_id)
    references produtos(id),
    constraint fk_pedido foreign key (pedido_id)
    references pedidos(id)
);

create table log (
    produto_id int,
    datahora datetime,
    descricao varchar(150),
    constraint fk_produto2 foreign key (produto_id)
    references produtos(id)
);