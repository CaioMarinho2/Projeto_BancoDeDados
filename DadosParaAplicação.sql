-- ==========================================
-- BANCO DE DADOS - LOCADORA DE VEICULOS
-- Caio Marinho dos Reis
-- Maria Fernanda Galdino de Oliveira
-- ==========================================

DROP DATABASE IF EXISTS locadora_veiculos;
CREATE DATABASE locadora_veiculos;
USE locadora_veiculos;

-- ==========================================
-- TABELA USUARIO
-- ==========================================

CREATE TABLE usuario (
    id_usuario INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    senha VARCHAR(255) NOT NULL,
    telefone VARCHAR(20),
    rua VARCHAR(100),
    numero VARCHAR(20),
    bairro VARCHAR(100),
    cidade VARCHAR(100),
    estado CHAR(2),
    cep VARCHAR(10),
    documento VARCHAR(20) UNIQUE NOT NULL,
    tipo_documento ENUM('CPF','CNPJ') NOT NULL,
    data_cadastro DATE DEFAULT (CURRENT_DATE)
);

-- ==========================================
-- ESPECIALIZACAO USUARIO
-- ==========================================

CREATE TABLE locatario (
    id_usuario INT PRIMARY KEY,
    cnh VARCHAR(20) NOT NULL,
    FOREIGN KEY (id_usuario)
        REFERENCES usuario(id_usuario)
        ON DELETE CASCADE
);

CREATE TABLE locador (
    id_usuario INT PRIMARY KEY,
    FOREIGN KEY (id_usuario)
        REFERENCES usuario(id_usuario)
        ON DELETE CASCADE
);

-- ==========================================
-- VEICULO
-- ==========================================

CREATE TABLE veiculo (
    id_veiculo INT AUTO_INCREMENT PRIMARY KEY,
    placa VARCHAR(10) UNIQUE NOT NULL,
    modelo VARCHAR(100) NOT NULL,
    ano INT CHECK (ano BETWEEN 2010 AND 2026),
    cor VARCHAR(50),
    categoria ENUM('Economico','Luxo'),
    tipo_combustivel ENUM(
        'Gasolina',
        'Alcool',
        'Diesel',
        'Flex',
        'Eletrico'
    ),
    valor_diaria DECIMAL(10,2) CHECK (valor_diaria > 0),
    disponivel BOOLEAN DEFAULT TRUE
);

CREATE TABLE carro (
    id_veiculo INT PRIMARY KEY,
    qtd_portas INT CHECK (qtd_portas IN (2,3,4)),
    FOREIGN KEY (id_veiculo)
        REFERENCES veiculo(id_veiculo)
        ON DELETE CASCADE
);

CREATE TABLE moto (
    id_veiculo INT PRIMARY KEY,
    cilindradas INT CHECK (cilindradas > 0),
    FOREIGN KEY (id_veiculo)
        REFERENCES veiculo(id_veiculo)
        ON DELETE CASCADE
);

-- ==========================================
-- ACESSORIO
-- ==========================================

CREATE TABLE acessorio (
    id_acessorio INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100),
    descricao TEXT
);

-- ==========================================
-- CATALOGO
-- ==========================================

CREATE TABLE catalogo (
    id_catalogo INT AUTO_INCREMENT PRIMARY KEY,
    id_locador INT NOT NULL,
    nome VARCHAR(100),
    cidade VARCHAR(100),
    estado CHAR(2),
    data_atualizacao DATE,
    FOREIGN KEY (id_locador)
        REFERENCES locador(id_usuario)
        ON DELETE CASCADE
);

-- ==========================================
-- ALUGUEL
-- ==========================================

CREATE TABLE aluguel (
    id_aluguel INT AUTO_INCREMENT PRIMARY KEY,
    id_locador INT,
    id_locatario INT,
    id_veiculo INT,
    data_reserva DATE,
    data_retirada DATE,
    data_prevista_devolucao DATE,
    data_devolucao_real DATE,
    status ENUM(
        'Reservado',
        'Ativo',
        'Concluido',
        'Cancelado'
    ),
    valor_total DECIMAL(10,2),

    FOREIGN KEY (id_locador)
        REFERENCES locador(id_usuario),

    FOREIGN KEY (id_locatario)
        REFERENCES locatario(id_usuario),

    FOREIGN KEY (id_veiculo)
        REFERENCES veiculo(id_veiculo)
);

-- ==========================================
-- CONTRATO
-- ==========================================

CREATE TABLE contrato (
    id_contrato INT AUTO_INCREMENT PRIMARY KEY,
    id_aluguel INT UNIQUE,
    numero_contrato VARCHAR(50) UNIQUE,
    data_emissao DATE,
    validade DATE,
    termos TEXT,
    assinatura_locatario VARCHAR(255),
    assinatura_locador VARCHAR(255),
    FOREIGN KEY (id_aluguel)
        REFERENCES aluguel(id_aluguel)
        ON DELETE CASCADE
);

-- ==========================================
-- PAGAMENTO
-- ==========================================

CREATE TABLE pagamento (
    id_pagamento INT AUTO_INCREMENT PRIMARY KEY,
    id_aluguel INT,
    forma_pagamento ENUM(
        'PIX',
        'Cartao',
        'Boleto',
        'Dinheiro'
    ),
    data_pagamento DATE,
    valor DECIMAL(10,2),
    status ENUM(
        'Pendente',
        'Pago',
        'Estornado'
    ),
    num_transacao VARCHAR(100),

    FOREIGN KEY (id_aluguel)
        REFERENCES aluguel(id_aluguel)
        ON DELETE CASCADE
);

-- ==========================================
-- MULTA
-- ==========================================

CREATE TABLE multa (
    id_multa INT AUTO_INCREMENT PRIMARY KEY,
    id_aluguel INT,
    motivo VARCHAR(255),
    valor DECIMAL(10,2),
    status_pagamento ENUM(
        'Pendente',
        'Pago'
    ),
    data_aplicacao DATE,

    FOREIGN KEY (id_aluguel)
        REFERENCES aluguel(id_aluguel)
        ON DELETE CASCADE
);

-- ==========================================
-- RETIRADA
-- ==========================================

CREATE TABLE retirada (
    id_retirada INT AUTO_INCREMENT PRIMARY KEY,
    id_aluguel INT UNIQUE,
    data_hora DATETIME,
    codigo_retirada VARCHAR(50) UNIQUE,
    confirmacao BOOLEAN DEFAULT FALSE,

    FOREIGN KEY (id_aluguel)
        REFERENCES aluguel(id_aluguel)
        ON DELETE CASCADE
);

-- ==========================================
-- DEVOLUCAO
-- ==========================================

CREATE TABLE devolucao (
    id_devolucao INT AUTO_INCREMENT PRIMARY KEY,
    id_aluguel INT UNIQUE,
    data_hora DATETIME,
    codigo_devolucao VARCHAR(50) UNIQUE,
    confirmacao BOOLEAN DEFAULT FALSE,
    observacoes TEXT,

    FOREIGN KEY (id_aluguel)
        REFERENCES aluguel(id_aluguel)
        ON DELETE CASCADE
);

-- ==========================================
-- FOTO DEVOLUCAO (ENTIDADE FRACA)
-- ==========================================

CREATE TABLE foto_devolucao (
    id_foto INT,
    id_devolucao INT,
    caminho_foto VARCHAR(255),
    descricao TEXT,

    PRIMARY KEY (id_foto,id_devolucao),

    FOREIGN KEY (id_devolucao)
        REFERENCES devolucao(id_devolucao)
        ON DELETE CASCADE
);

-- ==========================================
-- VEICULO ACESSORIO (N:N)
-- ==========================================

CREATE TABLE veiculo_acessorio (
    id_veiculo INT,
    id_acessorio INT,

    PRIMARY KEY(id_veiculo,id_acessorio),

    FOREIGN KEY (id_veiculo)
        REFERENCES veiculo(id_veiculo)
        ON DELETE CASCADE,

    FOREIGN KEY (id_acessorio)
        REFERENCES acessorio(id_acessorio)
        ON DELETE CASCADE
);

-- ==========================================
-- AVALIACAO
-- ==========================================

CREATE TABLE avaliacao (
    id_avaliacao INT AUTO_INCREMENT PRIMARY KEY,
    id_locatario INT,
    id_veiculo INT,
    nota INT CHECK (nota BETWEEN 1 AND 5),
    comentario TEXT,
    data_avaliacao DATE DEFAULT (CURRENT_DATE),

    FOREIGN KEY (id_locatario)
        REFERENCES locatario(id_usuario)
        ON DELETE CASCADE,

    FOREIGN KEY (id_veiculo)
        REFERENCES veiculo(id_veiculo)
        ON DELETE CASCADE
);

-- ==========================================
-- INDICA (AUTORRELACIONAMENTO)
-- ==========================================

CREATE TABLE indica (
    id_indicante INT,
    id_indicado INT,
    data_indicacao DATE DEFAULT (CURRENT_DATE),

    PRIMARY KEY(id_indicante,id_indicado),

    FOREIGN KEY (id_indicante)
        REFERENCES usuario(id_usuario)
        ON DELETE CASCADE,

    FOREIGN KEY (id_indicado)
        REFERENCES usuario(id_usuario)
        ON DELETE CASCADE,

    CHECK(id_indicante <> id_indicado)
);

-- ==========================================
-- POPULACAO USUARIO
-- ==========================================

INSERT INTO usuario
(nome,email,senha,telefone,rua,numero,bairro,cidade,estado,cep,documento,tipo_documento)
VALUES
('Joao Silva','joao@email.com','123456','11999990001','Rua A','10','Centro','Sao Paulo','SP','01000-000','11111111111','CPF'),
('Maria Souza','maria@email.com','123456','11999990002','Rua B','20','Centro','Sao Paulo','SP','01000-001','22222222222','CPF'),
('Pedro Santos','pedro@email.com','123456','11999990003','Rua C','30','Centro','Campinas','SP','13000-000','33333333333','CPF'),
('Ana Costa','ana@email.com','123456','11999990004','Rua D','40','Centro','Campinas','SP','13000-001','44444444444','CPF'),
('Lucas Lima','lucas@email.com','123456','11999990005','Rua E','50','Centro','Santos','SP','11000-000','55555555555','CPF'),
('Carla Alves','carla@email.com','123456','11999990006','Rua F','60','Centro','Santos','SP','11000-001','66666666666','CPF'),
('Bruno Rocha','bruno@email.com','123456','11999990007','Rua G','70','Centro','Rio de Janeiro','RJ','20000-000','77777777777','CPF'),
('Fernanda Melo','fernanda@email.com','123456','11999990008','Rua H','80','Centro','Rio de Janeiro','RJ','20000-001','88888888888','CPF'),
('Ricardo Dias','ricardo@email.com','123456','11999990009','Rua I','90','Centro','Belo Horizonte','MG','30000-000','99999999999','CPF'),
('Juliana Martins','juliana@email.com','123456','11999990010','Rua J','100','Centro','Belo Horizonte','MG','30000-001','10101010101','CPF');

INSERT INTO locatario VALUES
(1,'12345678901'),
(2,'12345678902'),
(3,'12345678903'),
(4,'12345678904'),
(5,'12345678905');

INSERT INTO locador VALUES
(6),
(7),
(8),
(9),
(10);

-- ==========================================
-- POPULACAO VEICULO
-- ==========================================

INSERT INTO veiculo
(placa,modelo,ano,cor,categoria,tipo_combustivel,valor_diaria,disponivel)
VALUES
('ABC1A11','HB20',2022,'Prata','Economico','Flex',120,TRUE),
('DEF2B22','Onix',2023,'Branco','Economico','Flex',130,TRUE),
('GHI3C33','Corolla',2024,'Preto','Luxo','Flex',250,TRUE),
('JKL4D44','Civic',2023,'Cinza','Luxo','Gasolina',260,TRUE),
('MNO5E55','Creta',2025,'Branco','Luxo','Flex',280,TRUE),
('PQR6F66','CG 160',2022,'Vermelha','Economico','Flex',80,TRUE),
('STU7G77','Fazer 250',2023,'Azul','Economico','Gasolina',100,TRUE),
('VWX8H88','MT-03',2024,'Preta','Luxo','Gasolina',150,TRUE);

INSERT INTO carro VALUES
(1,4),
(2,4),
(3,4),
(4,4),
(5,4);

INSERT INTO moto VALUES
(6,160),
(7,250),
(8,321);

-- ==========================================
-- ACESSORIOS
-- ==========================================

INSERT INTO acessorio(nome,descricao)
VALUES
('GPS','Navegacao'),
('Cadeirinha','Criancas'),
('Som Premium','Audio'),
('Suporte Celular','Suporte'),
('Carregador USB','USB'),
('Capacete Extra','Moto'),
('Baul Moto','Moto'),
('Alarme','Seguranca'),
('Sensor Re','Estacionamento'),
('Camera Veicular','Camera');

INSERT INTO veiculo_acessorio VALUES
(1,1),
(1,5),
(2,1),
(2,9),
(3,3),
(3,10),
(4,3),
(5,8),
(6,6),
(7,7);

-- ==========================================
-- CATALOGO
-- ==========================================

INSERT INTO catalogo
(id_locador,nome,cidade,estado,data_atualizacao)
VALUES
(6,'Catalogo SP','Sao Paulo','SP','2026-06-01'),
(7,'Catalogo RJ','Rio de Janeiro','RJ','2026-06-01'),
(8,'Catalogo MG','Belo Horizonte','MG','2026-06-01'),
(9,'Catalogo Santos','Santos','SP','2026-06-01'),
(10,'Catalogo Campinas','Campinas','SP','2026-06-01');

-- ==========================================
-- ALUGUEIS
-- ==========================================

INSERT INTO aluguel
(id_locador,id_locatario,id_veiculo,data_reserva,data_retirada,data_prevista_devolucao,data_devolucao_real,status,valor_total)
VALUES
(6,1,1,'2026-06-01','2026-06-02','2026-06-05','2026-06-05','Concluido',360),
(7,2,2,'2026-06-03','2026-06-04','2026-06-07','2026-06-07','Concluido',390),
(8,3,3,'2026-06-05','2026-06-06','2026-06-09','2026-06-09','Concluido',750),
(9,4,4,'2026-06-07','2026-06-08','2026-06-11',NULL,'Ativo',780),
(10,5,5,'2026-06-08','2026-06-09','2026-06-12',NULL,'Ativo',840);

-- ==========================================
-- CONTRATOS
-- ==========================================

INSERT INTO contrato
(id_aluguel,numero_contrato,data_emissao,validade,termos,assinatura_locatario,assinatura_locador)
VALUES
(1,'CTR001','2026-06-01','2026-06-05','Contrato de locacao','ass1.png','ass6.png'),
(2,'CTR002','2026-06-03','2026-06-07','Contrato de locacao','ass2.png','ass7.png'),
(3,'CTR003','2026-06-05','2026-06-09','Contrato de locacao','ass3.png','ass8.png'),
(4,'CTR004','2026-06-07','2026-06-11','Contrato de locacao','ass4.png','ass9.png'),
(5,'CTR005','2026-06-08','2026-06-12','Contrato de locacao','ass5.png','ass10.png');

-- ==========================================
-- PAGAMENTOS
-- ==========================================

INSERT INTO pagamento
(id_aluguel,forma_pagamento,data_pagamento,valor,status,num_transacao)
VALUES
(1,'PIX','2026-06-01',360,'Pago','TX001'),
(2,'Cartao','2026-06-03',390,'Pago','TX002'),
(3,'PIX','2026-06-05',750,'Pago','TX003'),
(4,'Boleto','2026-06-07',780,'Pendente','TX004'),
(5,'PIX','2026-06-08',840,'Pago','TX005');

-- ==========================================
-- MULTAS
-- ==========================================

INSERT INTO multa
(id_aluguel,motivo,valor,status_pagamento,data_aplicacao)
VALUES
(2,'Atraso na devolucao',50,'Pago','2026-06-08'),
(3,'Combustivel abaixo do acordado',80,'Pendente','2026-06-10');

-- ==========================================
-- RETIRADAS
-- ==========================================

INSERT INTO retirada
(id_aluguel,data_hora,codigo_retirada,confirmacao)
VALUES
(1,'2026-06-02 09:00:00','RET001',TRUE),
(2,'2026-06-04 09:00:00','RET002',TRUE),
(3,'2026-06-06 09:00:00','RET003',TRUE),
(4,'2026-06-08 09:00:00','RET004',TRUE),
(5,'2026-06-09 09:00:00','RET005',TRUE);

-- ==========================================
-- DEVOLUCOES
-- ==========================================

INSERT INTO devolucao
(id_aluguel,data_hora,codigo_devolucao,confirmacao,observacoes)
VALUES
(1,'2026-06-05 18:00:00','DEV001',TRUE,'Sem avarias'),
(2,'2026-06-07 18:00:00','DEV002',TRUE,'Atraso de uma hora'),
(3,'2026-06-09 18:00:00','DEV003',TRUE,'Necessita limpeza');

-- ==========================================
-- FOTOS DEVOLUCAO
-- ==========================================

INSERT INTO foto_devolucao
VALUES
(1,1,'foto1.jpg','Lateral direita'),
(2,1,'foto2.jpg','Frente'),
(1,2,'foto3.jpg','Traseira'),
(1,3,'foto4.jpg','Painel');

-- ==========================================
-- AVALIACOES
-- ==========================================

INSERT INTO avaliacao
(id_locatario,id_veiculo,nota,comentario)
VALUES
(1,1,5,'Excelente'),
(2,2,4,'Muito bom'),
(3,3,5,'Perfeito'),
(4,4,4,'Confortavel'),
(5,5,5,'Recomendo');

-- ==========================================
-- INDICACOES
-- ==========================================

INSERT INTO indica
(id_indicante,id_indicado,data_indicacao)
VALUES
(1,2,'2026-05-01'),
(2,3,'2026-05-05'),
(3,4,'2026-05-10'),
(4,5,'2026-05-15');

-- ==========================================
-- CONSULTAS PARA TESTE
-- ==========================================

SELECT * FROM veiculo WHERE disponivel = TRUE;

SELECT * FROM aluguel WHERE status = 'Ativo';

SELECT v.modelo, a.nota
FROM avaliacao a
JOIN veiculo v
ON a.id_veiculo = v.id_veiculo;

SELECT SUM(valor) AS total_recebido
FROM pagamento
WHERE status = 'Pago';

SELECT v.modelo, ac.nome
FROM veiculo v
JOIN veiculo_acessorio va
ON v.id_veiculo = va.id_veiculo
JOIN acessorio ac
ON va.id_acessorio = ac.id_acessorio;