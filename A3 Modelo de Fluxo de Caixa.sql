 CREATE DATABASE FLUXO_CAIXA;
 USE FLUXO_CAIXA;


CREATE TABLE pessoas (
    id_pessoa INT PRIMARY KEY IDENTITY(1,1),
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(100),
    telefone VARCHAR(15)
);


CREATE TABLE enderecos (
    id_endereco INT PRIMARY KEY IDENTITY(1,1),
    id_pessoa INT NOT NULL,
    logradouro VARCHAR(150),
    numero VARCHAR(10),
    complemento VARCHAR(50),
    bairro VARCHAR(50),
    cidade VARCHAR(50),
    estado CHAR(2),
    cep VARCHAR(10),
    CONSTRAINT FK_enderecos_pessoas FOREIGN KEY (id_pessoa) REFERENCES pessoas(id_pessoa)
);


CREATE TABLE plano (
    id_plano INT PRIMARY KEY IDENTITY(1,1),
    des_descricao VARCHAR(100),
    tp_cartao VARCHAR(50) CHECK (LOWER(TRIM(tp_cartao)) IN ('crédito', 'débito'))
);


CREATE TABLE conta (
    id_conta INT PRIMARY KEY IDENTITY(1,1),
    id_pessoa INT NOT NULL,
    id_plano INT,
    des_descricao VARCHAR(100),
    des_banco VARCHAR(100),
    num_agencia INT,
    num_conta INT,
    CONSTRAINT FK_conta_pessoas FOREIGN KEY (id_pessoa) REFERENCES pessoas(id_pessoa),
    CONSTRAINT FK_conta_plano FOREIGN KEY (id_plano) REFERENCES plano(id_plano)
);



CREATE TABLE categorias (
    id_categoria INT PRIMARY KEY IDENTITY(1,1),
    nome_categoria VARCHAR(100) NOT NULL,
    descricao_categoria VARCHAR(255)
);


CREATE TABLE lancamentos (
    id_lancamento INT PRIMARY KEY IDENTITY(1,1),
    id_conta INT NOT NULL,
    CONSTRAINT FK_lancamentos_conta FOREIGN KEY (id_conta) REFERENCES conta(id_conta)
);


CREATE TABLE transacoes (
    id_transacao INT PRIMARY KEY IDENTITY(1,1),
    id_lancamento INT NOT NULL,
    id_categoria INT,
    valor DECIMAL(18, 2) NOT NULL,
    tipo_transacao CHAR(1) CHECK (tipo_transacao IN ('C', 'D')),
    data_transacao DATETIME DEFAULT GETDATE(),
    CONSTRAINT FK_transacoes_lancamentos FOREIGN KEY (id_lancamento) REFERENCES lancamentos(id_lancamento),
    CONSTRAINT FK_transacoes_categorias FOREIGN KEY (id_categoria) REFERENCES categorias(id_categoria)
);


CREATE TABLE parcelas (
    id_parcela INT PRIMARY KEY IDENTITY(1,1),
    id_transacao INT NOT NULL,
    valor_parcela DECIMAL(18, 2) NOT NULL,
    data_vencimento DATETIME NOT NULL,
    data_pagamento DATETIME,
    status_parcela CHAR(1) CHECK (status_parcela IN ('P', 'A')), -- 'P' for Paid, 'A' for Active
    CONSTRAINT FK_parcelas_transacoes FOREIGN KEY (id_transacao) REFERENCES transacoes(id_transacao)
);


CREATE TABLE transferencias (
    id_transferencia INT PRIMARY KEY IDENTITY(1,1),
    id_conta_origem INT NOT NULL,
    id_conta_destino INT NOT NULL,
    valor_transferencia DECIMAL(18, 2) NOT NULL,
    data_transferencia DATETIME DEFAULT GETDATE(),
    CONSTRAINT FK_transferencias_conta_origem FOREIGN KEY (id_conta_origem) REFERENCES conta(id_conta),
    CONSTRAINT FK_transferencias_conta_destino FOREIGN KEY (id_conta_destino) REFERENCES conta(id_conta)
);


CREATE TABLE movimentacoes (
    id_movimentacao INT PRIMARY KEY IDENTITY(1,1),
    id_conta INT NOT NULL,
    tipo_movimentacao CHAR(1) CHECK (tipo_movimentacao IN ('S', 'D')), 
    valor DECIMAL(18, 2) NOT NULL,
    data_movimentacao DATETIME DEFAULT GETDATE(),
    CONSTRAINT FK_movimentacoes_conta FOREIGN KEY (id_conta) REFERENCES conta(id_conta)
);


CREATE TABLE auditoria (
    id_auditoria INT PRIMARY KEY IDENTITY(1,1),
    tabela_alterada VARCHAR(50) NOT NULL,
    id_registro_alterado INT NOT NULL,
    acao VARCHAR(50) NOT NULL, 
    usuario VARCHAR(100) NOT NULL, 
    data_alteracao DATETIME DEFAULT GETDATE(),
    id_conta INT NULL,
    id_pessoa INT NULL,
    id_plano INT NULL,
    CONSTRAINT FK_auditoria_conta FOREIGN KEY (id_conta) REFERENCES conta(id_conta),
    CONSTRAINT FK_auditoria_pessoas FOREIGN KEY (id_pessoa) REFERENCES pessoas(id_pessoa),
    CONSTRAINT FK_auditoria_plano FOREIGN KEY (id_plano) REFERENCES plano(id_plano)
);
