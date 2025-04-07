CREATE DATABASE DBurger;
GO

USE DBurger;
GO

-- DB_ESTADO
CREATE TABLE DB_ESTADO (
    SG_ESTADO CHAR(2) PRIMARY KEY,
    NM_ESTADO VARCHAR(30)
);

-- DB_CIDADE
CREATE TABLE DB_CIDADE (
    CD_CIDADE INT PRIMARY KEY,
    SG_ESTADO CHAR(2),
    NM_CIDADE VARCHAR(60),
    CD_IBGE INT,
    NR_DDD INT,
    FOREIGN KEY (SG_ESTADO) REFERENCES DB_ESTADO(SG_ESTADO)
);

-- DB_BAIRRO
CREATE TABLE DB_BAIRRO (
    CD_BAIRRO INT PRIMARY KEY,
    CD_CIDADE INT,
    NM_BAIRRO VARCHAR(45),
    NM_ZONA_BAIRRO VARCHAR(20),
    FOREIGN KEY (CD_CIDADE) REFERENCES DB_CIDADE(CD_CIDADE)
);

-- DB_LOGRADOURO
CREATE TABLE DB_LOGRADOURO (
    CD_LOGRADOURO INT PRIMARY KEY,
    CD_BAIRRO INT,
    NM_LOGRADOURO VARCHAR(160),
    NR_CEP INT,
    FOREIGN KEY (CD_BAIRRO) REFERENCES DB_BAIRRO(CD_BAIRRO)
);

-- DB_CLIENTE
CREATE TABLE DB_CLIENTE (
    NR_CLIENTE INT PRIMARY KEY,
    NM_CLIENTE VARCHAR(160) UNIQUE,
    QT_ESTRELAS INT,
    VL_MEDIO_COMPRA DECIMAL(10,2),
    ST_CLIENTE CHAR(1),
    DS_EMAIL VARCHAR(100),
    NR_TELEFONE VARCHAR(20)
);

-- DB_CLI_FISICA
CREATE TABLE DB_CLI_FISICA (
    NR_CLIENTE INT PRIMARY KEY,
    DT_NASCIMENTO DATE,
    FL_SEXO_BIOLOGICO CHAR(1),
    DS_GENERO VARCHAR(100),
    NR_CPF VARCHAR(14),
    FOREIGN KEY (NR_CLIENTE) REFERENCES DB_CLIENTE(NR_CLIENTE)
);

-- DB_CLI_JURIDICA
CREATE TABLE DB_CLI_JURIDICA (
    NR_CLIENTE INT PRIMARY KEY,
    DT_FUNDACAO DATE,
    NR_CNPJ VARCHAR(20),
    NR_INSCR_EST VARCHAR(15),
    FOREIGN KEY (NR_CLIENTE) REFERENCES DB_CLIENTE(NR_CLIENTE)
);

-- DB_LOJA
CREATE TABLE DB_LOJA (
    NR_LOJA INT PRIMARY KEY,
    NM_LOJA VARCHAR(100),
    DT_INAUGURACAO DATE
);

-- DB_DEPTO
CREATE TABLE DB_DEPTO (
    CD_DEPTO INT PRIMARY KEY,
    NM_DEPTO VARCHAR(100),
    NR_LOJA INT,
    ST_DEPTO CHAR(1),
    FOREIGN KEY (NR_LOJA) REFERENCES DB_LOJA(NR_LOJA)
);

-- DB_CARGO
CREATE TABLE DB_CARGO (
    CD_CARGO INT PRIMARY KEY,
    CD_DEPTO INT,
    DS_CARGO VARCHAR(50),
    ST_CARGO CHAR(1),
    FOREIGN KEY (CD_DEPTO) REFERENCES DB_DEPTO(CD_DEPTO)
);

-- DB_FUNCIONARIO
CREATE TABLE DB_FUNCIONARIO (
    CD_FUNCIONARIO INT PRIMARY KEY,
    CD_GERENTE INT,
    CD_CARGO INT NOT NULL,
    NM_FUNCIONARIO VARCHAR(160),
    DT_NASCIMENTO DATE NOT NULL,
    FL_SEXO_BIOLOGICO CHAR(1),
    DS_GENERO VARCHAR(100),
    VL_SALARIO_FAMILIA DECIMAL(10,2),
    VL_SALARIO_BRUTO DECIMAL(10,2),
    QT_TOT_DEPENDENTE INT,
    ST_FUNC CHAR(1),
    NR_PERC_COMISSAO DECIMAL(5,2),
    DT_CADASTRAMENTO DATE,
    DT_DESLIGAMENTO DATE,
    FT_FUNCIONARIO VARBINARY(MAX),
    FOREIGN KEY (CD_GERENTE) REFERENCES DB_FUNCIONARIO(CD_FUNCIONARIO),
    FOREIGN KEY (CD_CARGO) REFERENCES DB_CARGO(CD_CARGO)
);

-- DB_END_FUNC
CREATE TABLE DB_END_FUNC (
    CD_FUNCIONARIO INT,
    CD_LOGRADOURO INT,
    NR_END INT,
    DS_COMPLEMENTO_END VARCHAR(80),
    DT_INICIO DATE NOT NULL,
    DT_TERMINO DATE,
    ST_END CHAR(1) NOT NULL,
    PRIMARY KEY (CD_FUNCIONARIO, CD_LOGRADOURO),
    FOREIGN KEY (CD_FUNCIONARIO) REFERENCES DB_FUNCIONARIO(CD_FUNCIONARIO),
    FOREIGN KEY (CD_LOGRADOURO) REFERENCES DB_LOGRADOURO(CD_LOGRADOURO)
);

-- DB_END_LOJA
CREATE TABLE DB_END_LOJA (
    CD_LOJA_END INT PRIMARY KEY,
    NR_LOJA INT,
    CD_LOGRADOURO INT,
    NR_END INT,
    DS_COMPLEMENTO_END VARCHAR(80),
    DT_INICIO DATE NOT NULL,
    DT_TERMINO DATE,
    ST_END CHAR(1) NOT NULL,
    FOREIGN KEY (NR_LOJA) REFERENCES DB_LOJA(NR_LOJA),
    FOREIGN KEY (CD_LOGRADOURO) REFERENCES DB_LOGRADOURO(CD_LOGRADOURO)
);

-- DB_END_CLI
CREATE TABLE DB_END_CLI (
    NR_CLIENTE INT,
    CD_LOGRADOURO_CLI INT,
    NR_END INT,
    DS_COMPLEMENTO_END VARCHAR(80),
    DT_INICIO DATE,
    DT_TERMINO DATE,
    ST_END CHAR(1),
    PRIMARY KEY (NR_CLIENTE, CD_LOGRADOURO_CLI),
    FOREIGN KEY (NR_CLIENTE) REFERENCES DB_CLIENTE(NR_CLIENTE),
    FOREIGN KEY (CD_LOGRADOURO_CLI) REFERENCES DB_LOGRADOURO(CD_LOGRADOURO)
);

-- DB_FORMA_PAGAMENTO
CREATE TABLE DB_FORMA_PAGAMENTO (
    CD_FORMA_PAGTO INT PRIMARY KEY,
    DS_FORMA_PAGTO VARCHAR(30),
    ST_FORMA_PAGTO CHAR(1)
);

-- DB_PEDIDO
CREATE TABLE DB_PEDIDO (
    NR_LOJA INT,
    NR_PEDIDO INT,
    CD_FORMA_PAGTO INT,
    NR_CLIENTE INT,
    CD_LOGRADOURO_CLI INT,
    CD_FUNC_ATD INT,
    CD_FUNC_MOTOBOY INT,
    DT_PEDIDO DATE,
    DT_PREV_ENTREGA DATE,
    VL_TOT_PEDIDO DECIMAL(10,2),
    ST_PEDIDO CHAR(1),
    PRIMARY KEY (NR_LOJA, NR_PEDIDO),
    FOREIGN KEY (NR_LOJA) REFERENCES DB_LOJA(NR_LOJA),
    FOREIGN KEY (CD_FORMA_PAGTO) REFERENCES DB_FORMA_PAGAMENTO(CD_FORMA_PAGTO),
    FOREIGN KEY (NR_CLIENTE, CD_LOGRADOURO_CLI) REFERENCES DB_END_CLI(NR_CLIENTE, CD_LOGRADOURO_CLI),
    FOREIGN KEY (CD_FUNC_ATD) REFERENCES DB_FUNCIONARIO(CD_FUNCIONARIO),
    FOREIGN KEY (CD_FUNC_MOTOBOY) REFERENCES DB_FUNCIONARIO(CD_FUNCIONARIO)
);

-- DB_CATEGORIA_PROD
CREATE TABLE DB_CATEGORIA_PROD (
    CD_CATEGORIA_PROD INT PRIMARY KEY,
    DS_CATEGORIA_PROD VARCHAR(100),
    ST_CATEGORIA_PROD CHAR(1)
);

-- DB_SUB_CATEGORIA_PROD
CREATE TABLE DB_SUB_CATEGORIA_PROD (
    CD_SUB_CATEGORIA_PROD INT PRIMARY KEY,
    CD_CATEGORIA_PROD INT,
    DS_SUB_CATEGORIA_PROD VARCHAR(100),
    ST_SUB_CATEGORIA_PROD CHAR(1),
    FOREIGN KEY (CD_CATEGORIA_PROD) REFERENCES DB_CATEGORIA_PROD(CD_CATEGORIA_PROD)
);

-- DB_PRODUTO
CREATE TABLE DB_PRODUTO (
    CD_PRODUTO INT PRIMARY KEY,
    CD_SUB_CATEGORIA_PROD INT,
    DS_PRODUTO VARCHAR(80),
    VL_UNITARIO DECIMAL(8,2),
    TP_EMBALAGEM VARCHAR(15),
    ST_PRODUTO CHAR(1),
    VL_PERC_LUCRO DECIMAL(8,2),
    DS_COMPLETA VARCHAR(4000),
    FOREIGN KEY (CD_SUB_CATEGORIA_PROD) REFERENCES DB_SUB_CATEGORIA_PROD(CD_SUB_CATEGORIA_PROD)
);

-- DB_PRODUTO_IMAGEM
CREATE TABLE DB_PRODUTO_IMAGEM (
    CD_PRODUTO INT,
    NR_SEQUENCIA INT,
    IM_PRODUTO VARBINARY(MAX),
    TP_IMAGEM_PRODUTO VARCHAR(10),
    DS_PATH_IMAGEM VARCHAR(500),
    PRIMARY KEY (NR_SEQUENCIA, CD_PRODUTO),
    FOREIGN KEY (CD_PRODUTO) REFERENCES DB_PRODUTO(CD_PRODUTO)
);

-- DB_PRODUTO_LOJA
CREATE TABLE DB_PRODUTO_LOJA (
    CD_PRODUTO_LOJA INT PRIMARY KEY,
    NR_LOJA INT,
    CD_PRODUTO INT,
    DT_CADASTRO DATE,
    ST_ATUAL CHAR(1),
    FOREIGN KEY (NR_LOJA) REFERENCES DB_LOJA(NR_LOJA),
    FOREIGN KEY (CD_PRODUTO) REFERENCES DB_PRODUTO(CD_PRODUTO)
);

-- DB_ITEM_PEDIDO
CREATE TABLE DB_ITEM_PEDIDO (
    NR_LOJA INT,
    NR_PEDIDO INT,
    NR_ITEM INT,
    CD_PRODUTO_LOJA INT,
    QT_PEDIDO DECIMAL(8,2),
    VL_UNITARIO DECIMAL(8,2),
    VL_LUCRO_LIQUIDO DECIMAL(8,2),
    ST_ITEM_PEDIDO CHAR(1),
    PRIMARY KEY (NR_PEDIDO, NR_LOJA, NR_ITEM),
    FOREIGN KEY (NR_LOJA, NR_PEDIDO) REFERENCES DB_PEDIDO(NR_LOJA, NR_PEDIDO),
    FOREIGN KEY (CD_PRODUTO_LOJA) REFERENCES DB_PRODUTO_LOJA(CD_PRODUTO_LOJA)
);

-- DB_FATURAMENTO_PRODUTO
CREATE TABLE DB_FATURAMENTO_PRODUTO (
    NR_ANO_MES INT,
    CD_PRODUTO INT,
    QT_PRD_VENDIDOS DECIMAL(10,2),
    VL_TOT_PRD_VENDIDOS DECIMAL(10,2),
    VL_LUCRO_PRODUTO DECIMAL(10,2),
    PRIMARY KEY (CD_PRODUTO, NR_ANO_MES),
    FOREIGN KEY (CD_PRODUTO) REFERENCES DB_PRODUTO(CD_PRODUTO)
);
