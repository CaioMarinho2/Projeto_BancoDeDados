CREATE DATABASE locadora_veiculos;
USE locadora_veiculos;

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

CREATE TABLE acessorio (
    id_acessorio INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100),
    descricao TEXT
);

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