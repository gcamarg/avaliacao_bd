# --- Removendo item do carrinho
#	remover_Carrinho( idProduto, idPedido )

call remover_Carrinho(1,1);
call remover_Carrinho(7,3);

# --- Atualizar cadastro do cliente baseado em email. obs: campos vazios '' mantem informação atual.
#	atualizarCliente( novoNome, novoTelefone, emailCliente )

call atualizarCliente('Aline Sobral Paes', '+5544981505050', 'Aline.Paes@email.com');

# --- Atualiza informações do produto, exceto estoque. obs: campos vazios '' ou valor 0 mantem as informações atuais
#	alterarProduto( idProduto, novaDescrição, novoValor ) 
call alterarProduto(5, 'Guarda-roupa com espelho', 1299);

# --- Remover Cliente (Cuidado com o erro)
#	removerCliente(email)

call removerCliente('Guilherme.de.Camargo@email.com');

# --- Remover Endereço (esse nao tem erro)
#	removerEndereco( idEndereço, idCliente)

call removerEndereco(8, 1);