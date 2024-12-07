-- create database fluxo_caixa;
-- use fluxo_caixa;

create table conta(
    id_conta int primary key identity(1,1),
    des_descricao varchar(100),
	  des_banco varchar(100),
    num_agencia int,
    num_conta int
);

create table plano(
	  id_plano int primary key identity(1,1),
    des_descricao varchar(100),
    tp_cartao varchar(50) check (lower(trim(tp_cartao)) in ('crédito', 'débito'))
);

CREATE TABLE lancamentos (
    id_lancamento INT IDENTITY(1,1) PRIMARY KEY,
    id_conta INT NOT NULL, 
    CONSTRAINT FK_lancamentos_conta FOREIGN KEY (id_conta) REFERENCES conta(id_conta)
);

CREATE TABLE categorias (
    id_categoria INT PRIMARY KEY IDENTITY(1,1),
    nome_categoria VARCHAR(100) NOT NULL,
    descricao_categoria VARCHAR(255)
);

-- Transactions Table
CREATE TABLE transacoes (
    id_transacao INT PRIMARY KEY IDENTITY(1,1),
    id_lancamento INT NOT NULL,
    id_categoria INT,
    valor DECIMAL(18, 2) NOT NULL, -- Transaction amount
    tipo_transacao CHAR(1) CHECK (tipo_transacao IN ('C', 'D')), -- 'C' for Credit, 'D' for Debit
    data_transacao DATETIME DEFAULT GETDATE(),
    CONSTRAINT FK_transacoes_lancamentos FOREIGN KEY (id_lancamento) REFERENCES lancamentos(id_lancamento),
    CONSTRAINT FK_transacoes_categorias FOREIGN KEY (id_categoria) REFERENCES categorias(id_categoria)
);

CREATE TABLE auditoria (
    id_auditoria INT PRIMARY KEY IDENTITY(1,1),
    tabela_alterada VARCHAR(100) NOT NULL, -- Table name
    id_registro_alterado INT NOT NULL, -- ID of the modified record
    acao VARCHAR(50) NOT NULL, -- Action: INSERT, UPDATE, DELETE
    usuario VARCHAR(100) NOT NULL, -- User making the change
    data_alteracao DATETIME DEFAULT GETDATE()
);

/*
-- Example Trigger for Auditing Changes on Lancamentos
CREATE TRIGGER trg_audit_lancamentos
ON lancamentos
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    IF EXISTS (SELECT * FROM INSERTED)
    BEGIN
        INSERT INTO auditoria (tabela_alterada, id_registro_alterado, acao, usuario)
        SELECT 'lancamentos', id_lancamento, 'INSERT', SYSTEM_USER FROM INSERTED;
    END
    IF EXISTS (SELECT * FROM DELETED)
    BEGIN
        INSERT INTO auditoria (tabela_alterada, id_registro_alterado, acao, usuario)
        SELECT 'lancamentos', id_lancamento, 'DELETE', SYSTEM_USER FROM DELETED;
    END
END;
*/