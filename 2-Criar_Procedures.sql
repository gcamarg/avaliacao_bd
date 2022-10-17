# --- TRIGGER que debita quantidade do item adicionado ao pedido do estoque e grava log
DELIMITER $$
create trigger add_item after insert
on itens for each row
begin
	update produtos set estoque = estoque - NEW.quantidade;
    call criarLog(NEW.produto_id, concat('Foi debitado ', NEW.quantidade,
			' unidade do estoque do produto ', (select descricao from produtos where id = NEW.produto_id),' de id=', NEW.produto_id));
end$$
DELIMITER ;

# --- TRIGGER que adiciona a quantidade do item deletado do pedido ao estoque e grava log
DELIMITER $$
create trigger deletar_item after delete
on itens for each row
begin
	update produtos set estoque = estoque + OLD.quantidade;
    call criarLog(OLD.produto_id, concat('Foi adicionado ', OLD.quantidade,
			'unidade ao estoque do produto ', (select descricao from produtos where id = OLD.produto_id),' de id=', OLD.produto_id));
end$$
DELIMITER ;

# --- PROCEDURE para criação de pedido
DELIMITER $$
create procedure criarPedido(in idTransportadora int, in idCliente int)
begin
	insert into pedidos ( transportadora_id, cliente_id, data_pedido, valorTotal ) values
				(idTransportadora, idCliente, now(), 0);
end $$
DELIMITER 

# --- PROCEDURE adição de produto ao carrinho/pedido
DELIMITER $$
create procedure add_Carrinho(in idProduto int, in idPedido int, in quantidade int)
begin
	declare valor float;
    set valor = (select valorUnitario from produtos where id = idProduto);
	insert into itens ( produto_id, pedido_id, quantidade, valorUnitario, valorTotal ) values 
		( idProduto, idPedido, quantidade, valor, (valor * quantidade) );
	update pedidos set valorTotal = (valorTotal + (valor * quantidade)) where id = idPedido;
end $$
DELIMITER ;

# --- PROCEDURE remoção de produto ao carrinho/pedido
DELIMITER $$
create procedure remover_Carrinho(in idProduto int, in idPedido int)
begin
	declare valor float;
    set valor = (select valorTotal from itens where produto_id = idProduto and pedido_id = idPedido);
	delete from itens where produto_id = idProduto and pedido_id = idPedido;
	update pedidos set valorTotal = (valorTotal - valor) where id = idPedido;
end $$
DELIMITER ;

# --- PROCEDURE criação de log
DELIMITER $$
create procedure criarLog(in idProduto int, in mensagem varchar(150))
begin
	insert into log ( produto_id, datahora, descricao ) values
		(idProduto, now(), mensagem);
end $$
DELIMITER ;

# ----------------------------------- Cadastro Cliente --------------------------------------

# --- PROCEDURE de validação de email
DELIMITER $$
create procedure validarEmailCliente(in emailCliente varchar(50), out validacao boolean, out msg varchar(100))
begin
	if (select count(email) from clientes where email=emailCliente) > 0 then
		set msg =  'Email já existe';
	elseif length(emailCliente) > 10 then
		if length(emailCliente) - length(replace(emailCliente, '@', '')) = 1 then
			set validacao = true;
		else
			set msg =  'Email deve ter um único @';
            set validacao = false;
		end if;
	else
		set msg =  'Email muito curto';
        set validacao = false;
	end if;
end $$
DELIMITER ;

# --- PROCEDURE de validação de nome
DELIMITER $$
create procedure validarNomeCliente(in nomeCliente varchar(60), out validacao boolean, out msg varchar(100))
begin
	if length(nomeCliente) between 5 and 60 then
		set validacao = true;
	else
		set validacao = false;
		set msg = 'Nome deve possuir entre 5 e 60 letras';
	end if;
end $$
DELIMITER ;

# --- PROCEDURE de validação de telefone
DELIMITER $$
create procedure validartelefoneCliente(in telefoneCliente varchar(14), out validacao boolean, out msg varchar(100))
begin
	if length(telefoneCliente) < 14 then
		set validacao = false;
        set msg = 'Telefone deve ter 14 digitos';
	else
		set validacao = true;
	end if;
end $$
DELIMITER ;

# --- PROCEDURE de cadastro de novo cliente
DELIMITER $$
create procedure cadastrarCliente (in nomeCliente varchar(60), in telefoneCliente varchar(14), in emailCliente varchar(50))
begin
	declare validacao boolean default false;
    declare msg varchar(100) default '';
    call validarEmailCliente( emailCliente, validacao, msg);
    if validacao then
		call validarNomeCliente( nomeCliente, validacao, msg);
        if validacao then
			call validarTelefoneCliente( telefoneCliente, validacao, msg);
            if validacao then
				insert into clientes ( nome, telefone, email) values 
					( nomeCliente, telefoneCliente, emailCliente);
				set msg = 'Cliente cadastrado com sucesso!';
			end if;
		end if;
	end if;
    select msg;
end $$
DELIMITER ;

# --- PROCEDURE de alteração de cliente existente (exceto email)
DELIMITER $$
create procedure atualizarCliente (in novoNome varchar(60), in novoTelefone varchar(14), in emailCliente varchar(50))
begin
	declare validacao boolean default false;
    declare msg varchar(100) default '';
    if length(novoNome) = 0 then
		set novoNome = (select nome from clientes where email = emailCliente);
	end if;
    if length(novoTelefone) = 0 then
		set novoTelefone = (select telefone from clientes where email = emailCliente);
	end if;
	call validarNomeCliente( novoNome, validacao, msg);
	if validacao then
		call validarTelefoneCliente( novoTelefone, validacao, msg);
		if validacao then
			update clientes set  nome = novoNome, telefone = novoTelefone where email = emailCliente;
			set msg = 'Cliente atualizado com sucesso!';
		end if;
	end if;
    select msg;
end $$
DELIMITER ;

# --- PROCEDURE de remoçao de cliente
DELIMITER $$
create procedure removerCliente (in emailCliente varchar(50))
begin
    declare msg varchar(100) default '';
	delete from clientes where email = emailCliente;
    select msg;
end $$
DELIMITER ;

# ----------------------------------- Cadastro Produto ---------------------------------------------------
# --- PROCEDURE validação descrição do produto
DELIMITER $$
create procedure validarDescricao(in descricao varchar(80), out validacao boolean, out msg varchar(100))
begin
	if length(descricao) between 5 and 80 then
		set validacao = true;
	else
		set validacao = false;
		set msg = 'Descrição deve possuir entre 5 e 80 letras';
	end if;
end $$
DELIMITER ;

# --- PROCEDURE de cadastro de novo produto
DELIMITER $$
create procedure cadastrarProduto ( in idCategoria int, in idFabricante int, in descricaoProduto varchar(80), in valorUnitario float, in estoque int)
begin
	declare validacao boolean default false;
    declare msg varchar(100) default '';
    if (select count(nome) from categorias where id = idCategoria) > 0 then
		if (select count(nome) from fabricantes where id = idFabricante) > 0 then
			call validarDescricao( descricaoProduto, validacao, msg);
			if validacao then
				if valorUnitario > 0 then
					insert into produtos ( categoria_id, fabricante_id, descricao, valorUnitario, estoque ) values
											(idCategoria, idFabricante, descricaoProduto, valorUnitario, estoque);
					call criarLog(last_insert_id(), concat('Cadastro do produto ', descricaoProduto,
											' realizada. Id = ', last_insert_id(), '. Estoque = ', estoque));
					set msg = 'Produto cadastrado com sucesso!';
				else
					set msg = 'Valor unitário não pode ser 0';
				end if;
			end if;
		else 
			set msg = 'Fabricante não existe.';
        end if;
	else
		set msg = 'Categoria não existe.';
	end if;
    select msg;
end $$
DELIMITER ;

# --- PROCEDURE de alteração produto
DELIMITER $$
create procedure alterarProduto ( in idProduto int, in novaDescricao varchar(80), in novoValor float)
begin
	declare validacao boolean default false;
    declare msg varchar(100) default '';
    if length(novaDescricao) = 0 then
		set novaDescricao = (select descricao from produtos where id = idProduto);
	end if;
    if novoValor <= 0 then
		set novoValor = (select valorUnitario from produtos where id = idProduto);
	end if;
	call validarDescricao( novaDescricao, validacao, msg);
	if validacao then
		call criarLog(idProduto, concat('Alteração da descrição de: "', (select descricao from produtos where id = idProduto),
				'" para: "', novaDescricao, '" e valor de: " ', (select valorUnitario from produtos where id = idProduto), '" para: "', novoValor));
		update produtos set descricao = novaDescricao, valorUnitario = novoValor where id = idProduto;
		set msg = 'Produto alterado com sucesso!';
	end if;
    select msg;
end $$
DELIMITER ;

# ----------------------------------- Cadastro Endereço -------------------------------------------------------------------

# --- PROCEDURE validar endereço
DELIMITER $$
create procedure validarEndereco (in estado varchar(2), in cidade varchar(45), in cep varchar(10), in logradouro varchar(60), out validacao boolean, out msg varchar(100))
begin
    declare cepLimpo varchar(10) default '';
    set cepLimpo = replace(cep, "-", "");
	if length(estado) = 2 then
		if length(cepLimpo) = 8 then
			if length(cidade) between 2 and 45 then            
				if length(logradouro) between 5 and 60 then
					set validacao = true;
				else
					set validacao = false;
                    set msg = 'Logradouro deve conter entre 5 e 60 caracteres';
                end if;
			else 
				set validacao = false;
				set msg = 'Cidade deve conter entre 3 e 45 caracteres';
			end if;
        else 
			set validacao = false;
			set msg = 'CEP no formato incorreto.';
		end if;
    else
		set validacao = false;
		set msg = 'Sigla do estado deve possuir 2 letras.';
    end if;
    select msg;
end $$
DELIMITER ;


# --- PROCEDURE cadastro de endereço de cliente
DELIMITER $$
create procedure cadastrarEndereco (in idCliente int, in novoEstado varchar(2), in novaCidade varchar(45), in novoCep varchar(10), in novoLogradouro varchar(60) )
begin
	declare validacao boolean default false;
    declare msg varchar(100) default '';
    if (select count(nome) from clientes where id = idCliente) = 1 then
		call validarEndereco( novoEstado, novaCidade, novoCep, novoLogradouro, validacao, msg);
		if validacao then
			insert into enderecos ( cliente_id, estado, cidade, cep, logradouro ) values
				( idCliente, novoEstado, novaCidade, replace(novoCep, "-", ""), novoLogradouro );
			set msg = 'Endereço cadastrado';
		end if;
	else
		set msg = 'Cliente não encontrado.';
	end if;
    select msg;
end $$
DELIMITER ;

# --- PROCEDURE de remoçao de endereco
DELIMITER $$
create procedure removerEndereco (in idEndereco int, in idCliente int)
begin
    declare msg varchar(100) default '';
    if (select count(*) from enderecos where idEndereco = id and idCliente = cliente_id) <> 1 then
		set msg = 'Endereço não encontrado.';
	else
		delete from enderecos 
			where id = idEndereco 
			and cliente_id = idCliente;
		set msg = 'Endereco deletado com sucesso.';
	end if;
    select msg;
end $$
DELIMITER ;
