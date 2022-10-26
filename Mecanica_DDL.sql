/* UFPEL
 * PBD - Projeto de Banco de Dados
 * Eduardo de Figueiredo Costa - 20102202 
 * Script de criação da Mecanica
 * Utilização dentro do mysql (source Mecanica_DDL.sql)
 */

-- Deleta a base de dados mecanica se existir;
-- DROP DATABASE IF EXISTS mecanica;

-- Cria a base de dados mecanica
CREATE DATABASE mecanica
-- Caractenres ASCII
DEFAULT CHARACTER SET utf8mb4
DEFAULT COLLATE utf8mb4_general_ci;
-- Coloca a base de dados mecanica em uso
USE mecanica;

-- Cria a tabela cliente
CREATE TABLE cliente (
	cpfcnpj int							NOT NULL,
    `nome` varchar(25)					NOT NULL,
    telefone varchar(12)				NOT NULL,
    `endereco` varchar(30)				NOT NULL,
    tipo enum('Fisico', 'Juridico')		NOT NULL,
    dataNascimento date					NOT NULL
)default charset = utf8mb4;
-- Adiciona a chave primaria da tabela cliente
ALTER TABLE cliente ADD PRIMARY KEY (cpfcnpj);

-- Super entidade
CREATE TABLE colaborador (
	cpfColab int						NOT NULL,
    `nome` varchar(25)					NOT NULL,
    funcao varchar(20)					NOT NULL,
    dataNasc date						NOT NULL,
    telefone varchar(12)				NOT NULL,
    salario decimal(6,2)				NOT NULL,
    `endereco` varchar(30)				NOT NULL
)default charset = utf8mb4;
ALTER TABLE colaborador ADD PRIMARY KEY (cpfcolab);

-- Sub entidade
CREATE TABLE auxiliar (
	cpfColab int						NOT NULL,
    dataInicio date						NOT NULL,
    dataFim date						DEFAULT 0,
    service varchar(15)					NOT NULL
);
ALTER TABLE auxiliar ADD FOREIGN KEY (cpfColab) REFERENCES colaborador(cpfColab);

-- Sub entidade
CREATE TABLE mecanico (
	cpfColab int						NOT NULL,
    especializa enum('carro', 'moto')	NOT NULL
);
ALTER TABLE mecanico ADD FOREIGN KEY (cpfColab) REFERENCES colaborador(cpfColab);

-- Sub entidade
CREATE TABLE vendedor (
	cpfColab int						 NOT NULL
);
ALTER TABLE vendedor ADD FOREIGN KEY (cpfColab) REFERENCES colaborador(cpfColab);

-- Entidadde associativa:
CREATE TABLE atendidopor (
	cpfcnpj int 						NOT NULL,
    cpfColab int 						NOT NULL
);
ALTER TABLE atendidopor ADD FOREIGN KEY (cpfcnpj) REFERENCES cliente(cpfcnpj);
ALTER TABLE atendidopor ADD FOREIGN KEY (cpfColab) REFERENCES colaborador(cpfColab);

CREATE TABLE automovel (
	placa varchar(9) 					NOT NULL,
    tipo enum('carro', 'moto')			NOT NULL,
    cor varchar(8)						NOT NULL,
    marca varchar(12)					NOT NULL,
    modelo varchar(12)					NOT NULL,
    ano year							NOT NULL,
    cpfcnpj	int							NOT NULL
);
ALTER TABLE automovel ADD PRIMARY KEY (placa);
ALTER TABLE automovel ADD FOREIGN KEY (cpfcnpj) REFERENCES cliente(cpfcnpj);

CREATE TABLE conserto (
-- Ex codConserto: "A00000001' - "A99999999" - "B00000000"
	codConserto char(9)					NOT NULL, 
	dataCon date						NOT NULL,
    comissao decimal(7,2)				NOT NULL,
    valTot decimal(7,2)					NOT NULL,
    `descProblem` varchar(30)			NOT NULL,
    placa varchar(9) 					NOT NULL
)default charset = utf8mb4;
ALTER TABLE conserto ADD PRIMARY KEY (codCOnserto);
ALTER TABLE conserto ADD FOREIGN KEY (placa) REFERENCES automovel(placa);

-- Entidadde associativa:
CREATE TABLE efetua (
	cpfColab int 						NOT NULL, 
    codConserto char(9) 				NOT NULL
);
ALTER TABLE efetua ADD FOREIGN KEY (cpfColab) REFERENCES colaborador(cpfColab);
ALTER TABLE efetua ADD FOREIGN KEY (codConserto) REFERENCES conserto(codConserto);

CREATE TABLE venda (
	notaFiscal int						NOT NULL,
    cpfColab int						NOT NULL,
    cpfcnpj int							NOT NULL,
    dataVen date						NOT NULL,
    comissao decimal(7,2)				NOT NULL,
    valor decimal (7,2)					NOT NULL
);
ALTER TABLE venda ADD PRIMARY KEY (notaFiscal);
ALTER TABLE venda ADD FOREIGN KEY (cpfColab) REFERENCES colaborador(cpfColab);
ALTER TABLE venda ADD FOREIGN KEY (cpfcnpj) REFERENCES cliente(cpfcnpj);

CREATE TABLE fornecedor (
	cnpjForne int						NOT NULL,
    `nome` varchar(25)					NOT NULL,
    cidade varchar(20)					NOT NULL,
    estado varchar(20)					NOT NULL,
    cep int								NOT NULL,
    endereco varchar(30)				NOT NULL
)default charset = utf8mb4;
ALTER TABLE fornecedor ADD PRIMARY KEY (cnpjForne);

CREATE TABLE estoque (
-- EX identPrateleira: "A00"-"Z99"
	identPrateleira char(3)				NOT NULL,
    lote int							NOT NULL,
    numeroProdutos int					DEFAULT 0
);
ALTER TABLE estoque ADD PRIMARY KEY (identPrateleira);

CREATE TABLE produto (
	codProduto varchar(10)				NOT NULL,
    cor	varchar(8)						NOT NULL,
    valUnitario decimal(7,2)			NOT NULL,
    marca varchar (12)					NOT NULL,
    tamanho enum('P','M','G','U')		NOT NULL,
    tipo enum('peca', 'equipamento')	NOT NULL,
    modelo varchar(12),
    ano year,
    identPrateleira char(3)				NOT NULL,
    cnpjForne int						NOT NULL		
);
ALTER TABLE produto ADD PRIMARY KEY (codProduto);
ALTER TABLE produto ADD FOREIGN KEY (identPrateleira) REFERENCES estoque(identPrateleira);
ALTER TABLE produto ADD FOREIGN KEY (cnpjForne) REFERENCES fornecedor(cnpjForne);

CREATE TABLE item (
	codItem int							NOT NULL,
    notaFiscal int						NOT NULL,
    codProduto varchar(10)				NOT NULL
);
ALTER TABLE item ADD PRIMARY KEY (codItem);
ALTER TABLE item ADD FOREIGN KEY (notaFiscal) REFERENCES venda(notaFiscal);
ALTER TABLE item ADD FOREIGN KEY (codProduto) REFERENCES produto(codProduto);

-- Entidade associativa:
CREATE TABLE e_da (
	notaFiscal int 						NOT NULL,
    codItem int							NOT NULL,
    qtd tinyint							NOT NULL
);
ALTER TABLE e_da ADD FOREIGN KEY (notaFiscal) REFERENCES venda(notaFiscal);
ALTER TABLE e_da ADD FOREIGN KEY (codItem) REFERENCES item(codItem);