-- Trigger para Atualizar o Saldo da Conta ao Inserir uma Transação
CREATE TRIGGER trg_atualizar_saldo_transacao
ON transacoes
AFTER INSERT
AS
BEGIN
    DECLARE @id_conta INT, @valor DECIMAL(18, 2), @tipo_transacao CHAR(1);

    -- Obtém os valores inseridos na transação
    SELECT @id_conta = l.id_conta, @valor = t.valor, @tipo_transacao = t.tipo_transacao
    FROM inserted i
    JOIN lancamentos l ON i.id_lancamento = l.id_lancamento
    JOIN transacoes t ON i.id_transacao = t.id_transacao;

    -- Atualiza o saldo da conta, dependendo do tipo da transação
    IF @tipo_transacao = 'C'
    BEGIN
        -- Crédito, soma o valor ao saldo
        UPDATE conta
        SET saldo = saldo + @valor
        WHERE id_conta = @id_conta;
    END
    ELSE IF @tipo_transacao = 'D'
    BEGIN
        -- Débito, subtrai o valor do saldo
        UPDATE conta
        SET saldo = saldo - @valor
        WHERE id_conta = @id_conta;
    END
END;

-- Trigger para Registrar Auditoria ao Atualizar a Conta
CREATE TRIGGER trg_auditoria_atualizar_conta
ON conta
AFTER UPDATE
AS
BEGIN
    DECLARE @id_conta INT, @usuario VARCHAR(100);

    -- Obtém os valores da atualização
    SELECT @id_conta = id_conta FROM inserted;
    SELECT @usuario = SYSTEM_USER; -- Obtém o usuário do SQL Server

    -- Insere uma nova auditoria
    INSERT INTO auditoria (tabela_alterada, id_registro_alterado, acao, usuario)
    VALUES ('conta', @id_conta, 'UPDATE', @usuario);
END;

-- Trigger para Registrar Auditoria ao Inserir uma Nova Transação
CREATE TRIGGER trg_auditoria_inserir_transacao
ON transacoes
AFTER INSERT
AS
BEGIN
    DECLARE @id_transacao INT, @usuario VARCHAR(100);

    -- Obtém o ID da transação inserida
    SELECT @id_transacao = id_transacao FROM inserted;
    SELECT @usuario = SYSTEM_USER; -- Obtém o usuário do SQL Server

    -- Insere uma nova auditoria
    INSERT INTO auditoria (tabela_alterada, id_registro_alterado, acao, usuario)
    VALUES ('transacoes', @id_transacao, 'INSERT', @usuario);
END;

-- Trigger para Verificar Saldo Antes de Realizar um Saque
CREATE TRIGGER trg_verificar_saldo_saque
ON movimentacoes
AFTER INSERT
AS
BEGIN
    DECLARE @id_conta INT, @valor DECIMAL(18, 2), @tipo_movimentacao CHAR(1);
    DECLARE @saldo_atual DECIMAL(18, 2);

    -- Obtém os dados do saque ou depósito
    SELECT @id_conta = id_conta, @valor = valor, @tipo_movimentacao = tipo_movimentacao
    FROM inserted;

    -- Verifica se a movimentação é um saque
    IF @tipo_movimentacao = 'S'
    BEGIN
        -- Obtém o saldo atual da conta
        SELECT @saldo_atual = saldo FROM conta WHERE id_conta = @id_conta;

        -- Se o saldo for insuficiente, lança um erro
        IF @saldo_atual < @valor
        BEGIN
            RAISERROR('Saldo insuficiente para realizar o saque.', 16, 1);
            ROLLBACK TRANSACTION;
        END
    END
END;

-- Trigger para Atualizar o Status das Parcelas Após o Pagamento
CREATE TRIGGER trg_atualizar_status_parcela
ON parcelas
AFTER UPDATE
AS
BEGIN
    DECLARE @id_parcela INT, @data_pagamento DATE, @status_parcela CHAR(1);

    -- Obtém os valores da atualização
    SELECT @id_parcela = id_parcela, @data_pagamento = data_pagamento, @status_parcela = status_parcela
    FROM inserted;

    -- Se a data de pagamento for preenchida e o status for "Aberta", atualiza o status para "Paga"
    IF @data_pagamento IS NOT NULL AND @status_parcela = 'A'
    BEGIN
        UPDATE parcelas
        SET status_parcela = 'P'
        WHERE id_parcela = @id_parcela;
    END
END;

-- Trigger para Atualizar o Saldo das Contas Após uma Transferência
CREATE TRIGGER trg_atualizar_saldo_transferencia
ON transferencias
AFTER INSERT
AS
BEGIN
    DECLARE @id_conta_origem INT, @id_conta_destino INT, @valor_transferencia DECIMAL(18, 2);

    -- Obtém os dados da transferência
    SELECT @id_conta_origem = id_conta_origem, @id_conta_destino = id_conta_destino, @valor_transferencia = valor_transferencia
    FROM inserted;

    -- Atualiza os saldos das contas
    UPDATE conta
    SET saldo = saldo - @valor_transferencia
    WHERE id_conta = @id_conta_origem;

    UPDATE conta
    SET saldo = saldo + @valor_transferencia
    WHERE id_conta = @id_conta_destino;
END;
