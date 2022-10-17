# --- Inserção clientes através do procedure de cadastro de cliente
#	cadastrarCliente( Nome, Telefone, Email )

call cadastrarCliente('Guilherme de Camargo', '+5519998554477', 'Guilherme.de.Camargo@email.com');
call cadastrarCliente('Lucas Silva', '+5518997225544', 'Lucas.Silva@email.com');
call cadastrarCliente('Aline Paes', '+5544981505050', 'Aline.Paes@email.com');
call cadastrarCliente('Silvana Ferreira', '+5544992266533', 'Silvana.Ferreira@email.com');
call cadastrarCliente('Gustavo Junqueira', '+5518996552211', 'Gustavo.Junqueira@email.com');
call cadastrarCliente('Alef Pereira', '+5518997744112', 'Alef.Pereira@email.com');
call cadastrarCliente('Fagner Almeida', '+5511995663322', 'Fagner.Almeida@email.com');
call cadastrarCliente('Danilo Melchiore', '+5545998877441', 'Danilo.Melchiore@email.com');
call cadastrarCliente('Lais Pagani', '+5516998566998', 'Lais.Pagani@email.com');
call cadastrarCliente('Marcio Luchesi', '+5516982255463', 'Marcio.Luchesi@email.com');

# --- Inserção de endereços através do procedure de cadastro de endereço
#	cadastrarEndereço( idCliente, UF, Cidade, CEP, Logradouro)

call cadastrarEndereco(3, 'MG', 'Belo Horizonte', '30130005', 'Avenida Afonso Pena');
call cadastrarEndereco(2, 'DF', 'Brasília', '71020631', 'QE 11 Área Especial C');
call cadastrarEndereco(4, 'MS', 'Campo Grande', '79002290', 'Rua da Imprensa');
call cadastrarEndereco(1, 'SP', 'São Paulo', '03318000', 'Rua Serra de Bragança');
call cadastrarEndereco(1, 'SP', 'São Paulo', '04545005', 'Rua das Fiandeiras');
call cadastrarEndereco(11, 'PA', 'Belém', '66055260', 'Avenida Governador José Malcher');
call cadastrarEndereco(8, 'MS', 'Campo Grande', '79002290', 'Rua da Imprensa');
call cadastrarEndereco(5, 'PI', 'Teresina', '64000290', 'Rua Arlindo Nogueira');
call cadastrarEndereco(9, 'SP', 'São Paulo', '03318000', 'Rua Serra de Bragança');
call cadastrarEndereco(6, 'CE', 'Fortaleza', '60170001', 'Avenida Desembargador Moreira');
call cadastrarEndereco(7, 'RS', 'Rio Grande', '96204040', 'Avenida Almirante Maximiano Fonseca');
call cadastrarEndereco(9, 'SP', 'Jundiaí', '13216000', 'Avenida São João');

# --- inserção de fabricantes de produtos 

insert into fabricantes ( nome ) values
	('LG'),
    ('Samsung'),
    ('Apple'),
    ('Lenovo'),
    ('Stillo'),
    ('Hering'),
    ('Electrolux'),
    ('Wilson'),
    ('Adidas'),
    ('JBL'),
    ('Marabraz'),
    ('Mobly'),
    ('Siena'),
    ('Pirelli');

# inserção de categorias de produtos 

insert into categorias ( nome ) values
	('Eletrodomésticos'),
    ('Smartphones'),
    ('TV e Vídeo'),
    ('Informática'),
    ('Bebês'),
    ('Móveis'),
    ('Audio'),
    ('Esportes e Lazer'),
    ('Beleza'),
    ('Automotivo');
    
# --- Inserção de Produtos através do procedure de cadastro de produto
# cadastrarProduto( idCategoria, idFabricante, descrição, valor unitário, estoque)

call cadastrarProduto(3, 2, 'TV LED 60"', 3990, 76);
call cadastrarProduto(3, 1, 'TV LED 42"', 1999, 52);
call cadastrarProduto(3, 2, 'Home Theater 400W', 1090, 55);
call cadastrarProduto(6, 13, 'Guarda-roupa casal', 1200, 35);
call cadastrarProduto(6, 12, 'Guarda-roupa solteiro', 799, 45);
call cadastrarProduto(6, 12, 'Sofá retrátil', 1799, 47);
call cadastrarProduto(6, 11, 'Sofá 3 lugares', 1599, 52);
call cadastrarProduto(1, 7, 'Liquidificador 500W', 180, 52);
call cadastrarProduto(1, 1, 'Air Fryer 20L', 379, 48);
call cadastrarProduto(9, 9, 'Camiseta Vermelha', 99, 88);
call cadastrarProduto(9, 6, 'Calça Jeans', 129, 28);
call cadastrarProduto(5, 5, 'Carrinho de Bebê', 399, 45);
call cadastrarProduto(2, 3, 'Iphone 13', 4599, 84);
call cadastrarProduto(2, 2, 'Smarthpone android', 3299, 98);
call cadastrarProduto(8, 8, 'Raquete Tênis', 899, 43);
call cadastrarProduto(8, 9, 'Bola de futebol', 189, 34);
call cadastrarProduto(10, 14, 'Pneu automotivo', 299, 62);
call cadastrarProduto(7, 1, 'Caixa de som', 349, 44);
call cadastrarProduto(4, 4, 'Notebook i5', 4890, 43);

# --- Inserção de transportadoras

insert into transportadoras ( nome ) values
	('ASAP Log'),
    ('Azul Cargo Express'),
    ('B2Log'),
    ('Brasspress'),
    ('DHL'),
    ('Correios'),
    ('FedEx'),
    ('JadLog'),
    ('Loggi'),
    ('TNT'),
    ('Total Express');

# Utilização do procedure de criação de pedidos para popular tabela
# criarPedido( idTransportadora, idCliente )

call criarPedido(5, 1);
call criarPedido(3, 2);
call criarPedido(7, 3);
call criarPedido(5, 4);
call criarPedido(1, 5);
call criarPedido(2, 6);
call criarPedido(9, 7);
call criarPedido(8, 8);
call criarPedido(4, 9);
call criarPedido(2, 10);
call criarPedido(2, 1);
call criarPedido(2, 2);
call criarPedido(2, 1);
call criarPedido(2, 5);

# --- Adicionar itens ao carrinho
#	add_Carrinho( idProduto, idPedido, quantidade )

call add_Carrinho(1, 1, 1);
call add_Carrinho(3, 1, 1);
call add_Carrinho(13, 1, 1);

call add_Carrinho(10, 2, 3);
call add_Carrinho(11, 2, 2);
call add_Carrinho(7, 3, 2);
call add_Carrinho(3, 4, 1);
call add_Carrinho(12, 5, 1);
call add_Carrinho(9, 6, 2);
call add_Carrinho(1, 8, 2);
call add_Carrinho(2, 9, 2);
call add_Carrinho(6, 10, 2);
call add_Carrinho(5, 11, 2);
call add_Carrinho(3, 12, 1);
call add_Carrinho(8, 13, 4);
call add_Carrinho(3, 14, 3);
call add_Carrinho(1, 14, 3);