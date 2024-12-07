-- Stored Procedure para Inserir uma Nova Transação
CREATE PROCEDURE sp_inserir_transacao (
    @id_lancamento INT,
    @id_categoria INT,
    @valor DECIMAL(18, 2),
    @tipo_transacao CHAR(1),
    @data_transacao DATETIME
)
AS
BEGIN
    INSERT INTO transacoes (id_lancamento, id_categoria, valor, tipo_transacao, data_transacao)
    VALUES (@id_lancamento, @id_categoria, @valor, @tipo_transacao, @data_transacao);
END;
EXEC sp_inserir_transacao 1, 1, 5000.00, 'C', '2024-12-01'; 

-- Stored Procedure para Atualizar o Saldo de uma Conta
CREATE PROCEDURE sp_calcular_saldo_conta (
    @id_conta INT
)
AS
BEGIN
    DECLARE @saldo DECIMAL(18, 2);

    -- Calcular saldo
    SELECT @saldo = SUM(CASE WHEN tipo_transacao = 'C' THEN valor ELSE -valor END)
    FROM transacoes t
    JOIN lancamentos l ON t.id_lancamento = l.id_lancamento
    WHERE l.id_conta = @id_conta;

    -- Retornar o saldo
    SELECT @saldo AS saldo;
END;
EXEC sp_calcular_saldo_conta 1;

-- Stored Procedure para Registrar um Saque ou Depósito
CREATE PROCEDURE sp_registrar_movimentacao (
    @id_conta INT,
    @tipo_movimentacao CHAR(1),  -- 'S' para Saque, 'D' para Depósito
    @valor DECIMAL(18, 2)
)
AS
BEGIN
    -- Inserir movimentação
    INSERT INTO movimentacoes (id_conta, tipo_movimentacao, valor)
    VALUES (@id_conta, @tipo_movimentacao, @valor);

    -- Atualizar o saldo da conta
    IF @tipo_movimentacao = 'D'
    BEGIN
        -- Depósito, soma o valor
        UPDATE conta
        SET saldo = saldo + @valor
        WHERE id_conta = @id_conta;
    END
    ELSE IF @tipo_movimentacao = 'S'
    BEGIN
        -- Saque, subtrai o valor
        UPDATE conta
        SET saldo = saldo - @valor
        WHERE id_conta = @id_conta;
    END
END;
EXEC sp_registrar_movimentacao 1, 'D', 500.00;  
EXEC sp_registrar_movimentacao 1, 'S', 200.00;  

-- Stored Procedure para Registrar uma Transferência entre Contas
CREATE PROCEDURE sp_registrar_transferencia (
    @id_conta_origem INT,
    @id_conta_destino INT,
    @valor_transferencia DECIMAL(18, 2)
)
AS
BEGIN
    -- Registrar a transferência na tabela de transferências
    INSERT INTO transferencias (id_conta_origem, id_conta_destino, valor_transferencia, data_transferencia)
    VALUES (@id_conta_origem, @id_conta_destino, @valor_transferencia, GETDATE());

    -- Atualizar os saldos das contas
    UPDATE conta
    SET saldo = saldo - @valor_transferencia
    WHERE id_conta = @id_conta_origem;

    UPDATE conta
    SET saldo = saldo + @valor_transferencia
    WHERE id_conta = @id_conta_destino;
END;
EXEC sp_registrar_transferencia 1, 2, 1000.00; 

-- Stored Procedure para Registrar uma Parcela de uma Transação
CREATE PROCEDURE sp_registrar_parcela (
    @id_transacao INT,
    @valor_parcela DECIMAL(18, 2),
    @data_vencimento DATE,
    @status_parcela CHAR(1) -- 'A' para Aberta, 'P' para Paga
)
AS
BEGIN
    -- Inserir parcela
    INSERT INTO parcelas (id_transacao, valor_parcela, data_vencimento, status_parcela)
    VALUES (@id_transacao, @valor_parcela, @data_vencimento, @status_parcela);
END;
EXEC sp_registrar_parcela 1, 1000.00, '2024-12-15', 'A';  

-- Stored Procedure para Registrar uma Alteração na Auditoria
CREATE PROCEDURE sp_registrar_auditoria (
    @tabela_alterada VARCHAR(100),
    @id_registro_alterado INT,
    @acao VARCHAR(50),
    @usuario VARCHAR(100)
)
AS
BEGIN
    INSERT INTO auditoria (tabela_alterada, id_registro_alterado, acao, usuario, data_alteracao)
    VALUES (@tabela_alterada, @id_registro_alterado, @acao, @usuario, GETDATE());
END;
EXEC sp_registrar_auditoria 'transacoes', 1, 'INSERT', 'admin';  -- Exemplo para registrar uma inserção na tabela de transações
