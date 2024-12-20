MANUAL DE USO - MODELO DE FLUXO DE CAIXA

Este é o manual de uso para o modelo de fluxo de caixa implementado em SQL Server. A seguir, descrevemos a estrutura do banco de dados, bem como os passos para populá-lo com dados de teste.

### 1. Estrutura do Banco de Dados:

O modelo contém várias tabelas inter-relacionadas, conforme descrito abaixo:

1. **pessoas**: Contém informações sobre os indivíduos cadastrados no sistema.
    - Campos: id_pessoa (PK), nome, email, telefone.

2. **enderecos**: Relacionado com a tabela pessoas para armazenar os endereços.
    - Campos: id_endereco (PK), id_pessoa (FK), logradouro, numero, complemento, bairro, cidade, estado, cep.

3. **plano**: Armazena os tipos de planos bancários (ex: crédito, débito).
    - Campos: id_plano (PK), des_descricao, tp_cartao.

4. **conta**: Armazena informações sobre as contas bancárias dos usuários.
    - Campos: id_conta (PK), id_pessoa (FK), id_plano (FK), des_descricao, des_banco, num_agencia, num_conta.

5. **categorias**: Define categorias para transações (ex: Salário, Lazer, Alimentação).
    - Campos: id_categoria (PK), nome_categoria, descricao_categoria.

6. **lancamentos**: Registra os lançamentos financeiros associados a uma conta.
    - Campos: id_lancamento (PK), id_conta (FK).

7. **transacoes**: Armazena as transações realizadas, incluindo créditos e débitos.
    - Campos: id_transacao (PK), id_lancamento (FK), id_categoria (FK), valor, tipo_transacao, data_transacao.

8. **parcelas**: Registra as parcelas associadas a transações.
    - Campos: id_parcela (PK), id_transacao (FK), valor_parcela, data_vencimento, data_pagamento, status_parcela.

9. **transferencias**: Registra as transferências entre contas.
    - Campos: id_transferencia (PK), id_conta_origem (FK), id_conta_destino (FK), valor_transferencia, data_transferencia.

10. **movimentacoes**: Registra as movimentações de saque e depósito em contas.
    - Campos: id_movimentacao (PK), id_conta (FK), tipo_movimentacao, valor, data_movimentacao.

11. **auditoria**: Armazena os registros de auditoria, para rastrear alterações nas tabelas.
    - Campos: id_auditoria (PK), tabela_alterada, id_registro_alterado, acao, usuario, data_alteracao, id_conta (FK), id_pessoa (FK), id_plano (FK).

---

### 2. Inserindo Dados de Teste

Abaixo estão os exemplos de inserção de dados para cada tabela. Certifique-se de rodar as instruções de inserção na ordem correta para garantir a integridade dos dados.

#### 2.1 Inserindo dados em pessoas:
sql
INSERT INTO pessoas (nome, email, telefone)
VALUES 
    ('João Silva', 'joao.silva@example.com', '123456789'),
    ('Maria Oliveira', 'maria.oliveira@example.com', '987654321'),
    ('Pedro Costa', 'pedro.costa@example.com', '555555555');


#### 2.2 Inserindo dados em enderecos:
sql
INSERT INTO enderecos (id_pessoa, logradouro, numero, complemento, bairro, cidade, estado, cep)
VALUES
    (1, 'Rua A', '123', 'Apto 101', 'Centro', 'São Paulo', 'SP', '01001000'),
    (2, 'Av. B', '456', 'Bloco 3', 'Vila Nova', 'Rio de Janeiro', 'RJ', '20020000'),
    (3, 'Rua C', '789', NULL, 'Jardim', 'Belo Horizonte', 'MG', '30030000');


#### 2.3 Inserindo dados em plano:
sql
INSERT INTO plano (des_descricao, tp_cartao)
VALUES 
    ('Plano Ouro', 'crédito'),
    ('Plano Prata', 'débito');


#### 2.4 Inserindo dados em conta:
sql
INSERT INTO conta (id_pessoa, id_plano, des_descricao, des_banco, num_agencia, num_conta)
VALUES
    (1, 1, 'Conta Corrente João', 'Banco do Brasil', 1234, 567890),
    (2, 2, 'Conta Corrente Maria', 'Itaú', 5678, 123456),
    (3, 1, 'Conta Corrente Pedro', 'Santander', 9101, 112233);


#### 2.5 Inserindo dados em categorias:
sql
INSERT INTO categorias (nome_categoria, descricao_categoria)
VALUES 
    ('Salário', 'Rendimentos mensais de trabalho'),
    ('Lazer', 'Despesas com entretenimento'),
    ('Alimentação', 'Despesas com compras no supermercado');


#### 2.6 Inserindo dados em lancamentos:
sql
INSERT INTO lancamentos (id_conta)
VALUES
    (1),  -- Conta de João
    (2),  -- Conta de Maria
    (3);  -- Conta de Pedro


#### 2.7 Inserindo dados em transacoes:
sql
INSERT INTO transacoes (id_lancamento, id_categoria, valor, tipo_transacao, data_transacao)
VALUES
    (1, 1, 5000.00, 'C', '2024-12-01'),
    (2, 3, 200.00, 'D', '2024-12-02'),
    (3, 2, 150.00, 'D', '2024-12-03');


#### 2.8 Inserindo dados em parcelas:
sql
INSERT INTO parcelas (id_transacao, valor_parcela, data_vencimento, status_parcela)
VALUES
    (1, 5000.00, '2024-12-10', 'A'),
    (2, 100.00, '2024-12-15', 'A'),
    (3, 50.00, '2024-12-20', 'P');


#### 2.9 Inserindo dados em transferencias:
sql
INSERT INTO transferencias (id_conta_origem, id_conta_destino, valor_transferencia, data_transferencia)
VALUES
    (1, 2, 1000.00, '2024-12-04'),
    (2, 3, 500.00, '2024-12-05');


#### 2.10 Inserindo dados em movimentacoes:
sql
INSERT INTO movimentacoes (id_conta, tipo_movimentacao, valor)
VALUES
    (1, 'D', 300.00),  -- Depósito
    (2, 'S', 150.00),  -- Saque
    (3, 'S', 100.00);  -- Saque


#### 2.11 Inserindo dados em auditoria:
sql
INSERT INTO auditoria (tabela_alterada, id_registro_alterado, acao, usuario)
VALUES
    ('pessoas', 1, 'INSERT', 'admin'),
    ('conta', 2, 'UPDATE', 'admin'),
    ('transacoes', 3, 'DELETE', 'admin');


---

### 3. Consultas de Exemplos:

- **Consulta de saldo de contas:**
sql
SELECT c.id_conta, c.des_descricao, SUM(t.valor) AS saldo
FROM conta c
JOIN lancamentos l ON c.id_conta = l.id_conta
JOIN transacoes t ON l.id_lancamento = t.id_lancamento
GROUP BY c.id_conta, c.des_descricao;


- **Consulta de auditoria:**
sql
SELECT * FROM auditoria WHERE tabela_alterada = 'transacoes' AND acao = 'DELETE';


---

### 4. Considerações Finais:

- Para garantir a integridade referencial entre as tabelas, é importante inserir os dados na ordem indicada no manual.
- As consultas de exemplo são apenas sugestões, podendo ser adaptadas conforme as necessidades do seu fluxo de caixa.

---

Com isso, você tem um guia básico de como utilizar e popular o banco de dados para gerenciar o fluxo de caixa!

