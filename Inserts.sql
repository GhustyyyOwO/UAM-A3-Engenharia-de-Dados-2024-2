-- Inserting into pessoas
INSERT INTO pessoas (nome, email, telefone)
VALUES 
    ('João Silva', 'joao.silva@example.com', '123456789'),
    ('Maria Oliveira', 'maria.oliveira@example.com', '987654321'),
    ('Pedro Costa', 'pedro.costa@example.com', '555555555');

-- Inserting into enderecos
INSERT INTO enderecos (id_pessoa, logradouro, numero, complemento, bairro, cidade, estado, cep)
VALUES
    (1, 'Rua A', '123', 'Apto 101', 'Centro', 'São Paulo', 'SP', '01001000'),
    (2, 'Av. B', '456', 'Bloco 3', 'Vila Nova', 'Rio de Janeiro', 'RJ', '20020000'),
    (3, 'Rua C', '789', NULL, 'Jardim', 'Belo Horizonte', 'MG', '30030000');

-- Inserting into plano
INSERT INTO plano (des_descricao, tp_cartao)
VALUES 
    ('Plano Ouro', 'crédito'),
    ('Plano Prata', 'débito');

-- Inserting into conta
INSERT INTO conta (id_pessoa, id_plano, des_descricao, des_banco, num_agencia, num_conta)
VALUES
    (1, 1, 'Conta Corrente João', 'Banco do Brasil', 1234, 567890),
    (2, 2, 'Conta Corrente Maria', 'Itaú', 5678, 123456),
    (3, 1, 'Conta Corrente Pedro', 'Santander', 9101, 112233);

-- Inserting into categorias
INSERT INTO categorias (nome_categoria, descricao_categoria)
VALUES 
    ('Salário', 'Rendimentos mensais de trabalho'),
    ('Lazer', 'Despesas com entretenimento'),
    ('Alimentação', 'Despesas com compras no supermercado');

-- Inserting into lancamentos
INSERT INTO lancamentos (id_conta)
VALUES
    (1),  -- Conta de João
    (2),  -- Conta de Maria
    (3);  -- Conta de Pedro

-- Inserting into transacoes
INSERT INTO transacoes (id_lancamento, id_categoria, valor, tipo_transacao, data_transacao)
VALUES
    (1, 1, 5000.00, 'C', '2024-12-01'),
    (2, 3, 200.00, 'D', '2024-12-02'),
    (3, 2, 150.00, 'D', '2024-12-03');

-- Inserting into parcelas
INSERT INTO parcelas (id_transacao, valor_parcela, data_vencimento, status_parcela)
VALUES
    (1, 5000.00, '2024-12-10', 'A'),
    (2, 100.00, '2024-12-15', 'A'),
    (3, 50.00, '2024-12-20', 'P');

-- Inserting into transferencias
INSERT INTO transferencias (id_conta_origem, id_conta_destino, valor_transferencia, data_transferencia)
VALUES
    (1, 2, 1000.00, '2024-12-04'),
    (2, 3, 500.00, '2024-12-05');

-- Inserting into movimentacoes
INSERT INTO movimentacoes (id_conta, tipo_movimentacao, valor)
VALUES
    (1, 'D', 300.00),  -- Depósito
    (2, 'S', 150.00),  -- Saque
    (3, 'S', 100.00);  -- Saque

-- Inserting into auditoria
INSERT INTO auditoria (tabela_alterada, id_registro_alterado, acao, usuario)
VALUES
    ('pessoas', 1, 'INSERT', 'admin'),
    ('conta', 2, 'UPDATE', 'admin'),
    ('transacoes', 3, 'DELETE', 'admin');
