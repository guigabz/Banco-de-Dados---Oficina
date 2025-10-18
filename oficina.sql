-- ==========================================================
-- DATABASE CREATION
-- ==========================================================
CREATE DATABASE IF NOT EXISTS oficina;
USE oficina;

-- ==========================================================
-- TABLE: CLIENTE
-- ==========================================================
CREATE TABLE Cliente (
    idCliente INT AUTO_INCREMENT PRIMARY KEY,
    Nome VARCHAR(45) NOT NULL,
    Telefone VARCHAR(15) UNIQUE,
    Endereco VARCHAR(100) DEFAULT 'Not Informed'
);

-- ==========================================================
-- TABLE: VEICULO
-- ==========================================================
CREATE TABLE Veiculo (
    idVeiculo INT AUTO_INCREMENT PRIMARY KEY,
    Modelo VARCHAR(45) NOT NULL,
    Placa VARCHAR(10) UNIQUE NOT NULL,
    Ano INT DEFAULT 2020,
    Marca VARCHAR(45) NOT NULL,
    idCliente INT NOT NULL,
    FOREIGN KEY (idCliente) REFERENCES Cliente(idCliente)
);

CREATE INDEX idx_veiculo_cliente ON Veiculo(idCliente);

-- ==========================================================
-- TABLE: EQUIPE
-- ==========================================================
CREATE TABLE Equipe (
    idEquipe INT AUTO_INCREMENT PRIMARY KEY,
    Nome_Equipe VARCHAR(45) NOT NULL UNIQUE
);

-- ==========================================================
-- TABLE: MECANICO
-- ==========================================================
CREATE TABLE Mecanico (
    idMecanico INT AUTO_INCREMENT PRIMARY KEY,
    Nome VARCHAR(45) NOT NULL,
    Endereco VARCHAR(100),
    Especialidade ENUM('Motor', 'Freios', 'Elétrica', 'Suspensão', 'Pintura') DEFAULT 'Motor',
    idEquipe INT NOT NULL,
    FOREIGN KEY (idEquipe) REFERENCES Equipe(idEquipe)
);

CREATE INDEX idx_mecanico_equipe ON Mecanico(idEquipe);

-- ==========================================================
-- TABLE: SERVICO
-- ==========================================================
CREATE TABLE Servico (
    idServico INT AUTO_INCREMENT PRIMARY KEY,
    Descricao VARCHAR(45) NOT NULL,
    ValorReferencia DECIMAL(10,2) NOT NULL CHECK (ValorReferencia >= 0)
);

-- ==========================================================
-- TABLE: PECA
-- ==========================================================
CREATE TABLE Peca (
    idPeca INT AUTO_INCREMENT PRIMARY KEY,
    Descricao VARCHAR(45) NOT NULL,
    ValorUnitario DECIMAL(10,2) NOT NULL CHECK (ValorUnitario >= 0)
);

-- ==========================================================
-- TABLE: ORDEM DE SERVIÇO
-- ==========================================================
CREATE TABLE OrdemServico (
    idOS INT AUTO_INCREMENT PRIMARY KEY,
    DataEmissao DATE DEFAULT (CURRENT_DATE),
    DataConclusao DATE,
    ValorTotal DECIMAL(10,2) DEFAULT 0,
    Status ENUM('Aberta', 'Em Andamento', 'Concluída', 'Cancelada') DEFAULT 'Aberta',
    idCliente INT NOT NULL,
    idVeiculo INT NOT NULL,
    idEquipe INT NOT NULL,
    FOREIGN KEY (idCliente) REFERENCES Cliente(idCliente),
    FOREIGN KEY (idVeiculo) REFERENCES Veiculo(idVeiculo),
    FOREIGN KEY (idEquipe) REFERENCES Equipe(idEquipe)
);

CREATE INDEX idx_ordem_cliente ON OrdemServico(idCliente);
CREATE INDEX idx_ordem_status ON OrdemServico(Status);

-- ==========================================================
-- TABLE: OS_SERVICO
-- ==========================================================
CREATE TABLE OS_Servico (
    idOS INT NOT NULL,
    idServico INT NOT NULL,
    Quantidade INT DEFAULT 1,
    ValorUnitario DECIMAL(10,2) DEFAULT 0,
    SubTotal DECIMAL(10,2) GENERATED ALWAYS AS (Quantidade * ValorUnitario) STORED,
    PRIMARY KEY (idOS, idServico),
    FOREIGN KEY (idOS) REFERENCES OrdemServico(idOS),
    FOREIGN KEY (idServico) REFERENCES Servico(idServico)
);

-- ==========================================================
-- TABLE: OS_PECA
-- ==========================================================
CREATE TABLE OS_Peca (
    idOS INT NOT NULL,
    idPeca INT NOT NULL,
    Quantidade DECIMAL(10,2) DEFAULT 1,
    ValorUnitario DECIMAL(10,2) DEFAULT 0,
    SubTotal DECIMAL(10,2) GENERATED ALWAYS AS (Quantidade * ValorUnitario) STORED,
    PRIMARY KEY (idOS, idPeca),
    FOREIGN KEY (idOS) REFERENCES OrdemServico(idOS),
    FOREIGN KEY (idPeca) REFERENCES Peca(idPeca)
);

-- ==========================================================
-- INSERT TEST DATA
-- ==========================================================
INSERT INTO Cliente (Nome, Telefone, Endereco)
VALUES ('Lucas Pereira', '11988887777', 'Rua das Flores, 45'),
       ('Ana Silva', '11999990000', 'Av. Paulista, 1000');

INSERT INTO Veiculo (Modelo, Placa, Ano, Marca, idCliente)
VALUES ('Civic', 'ABC1234', 2022, 'Honda', 1),
       ('Corolla', 'XYZ9876', 2021, 'Toyota', 2);

INSERT INTO Equipe (Nome_Equipe)
VALUES ('Equipe Alfa'), ('Equipe Beta');

INSERT INTO Mecanico (Nome, Endereco, Especialidade, idEquipe)
VALUES ('Carlos Souza', 'Rua 1', 'Motor', 1),
       ('Paulo Ramos', 'Rua 2', 'Elétrica', 2);

INSERT INTO Servico (Descricao, ValorReferencia)
VALUES ('Troca de óleo', 150.00),
       ('Alinhamento', 120.00),
       ('Revisão completa', 500.00);

INSERT INTO Peca (Descricao, ValorUnitario)
VALUES ('Filtro de óleo', 50.00),
       ('Pastilha de freio', 200.00);

INSERT INTO OrdemServico (DataConclusao, ValorTotal, Status, idCliente, idVeiculo, idEquipe)
VALUES ('2025-10-15', 650.00, 'Concluída', 1, 1, 1),
       (NULL, 0, 'Aberta', 2, 2, 2);

INSERT INTO OS_Servico (idOS, idServico, Quantidade, ValorUnitario)
VALUES (1, 1, 1, 150.00), (1, 3, 1, 500.00);

INSERT INTO OS_Peca (idOS, idPeca, Quantidade, ValorUnitario)
VALUES (1, 1, 1, 50.00);

-- ==========================================================
-- ADVANCED QUERIES (BUSINESS QUESTIONS)
-- ==========================================================

-- 1. Which orders are currently open and their clients?
SELECT os.idOS, c.Nome AS Client, v.Placa, os.Status
FROM OrdemServico os
JOIN Cliente c ON os.idCliente = c.idCliente
JOIN Veiculo v ON os.idVeiculo = v.idVeiculo
WHERE os.Status = 'Aberta'
ORDER BY os.DataEmissao DESC;

-- 2. What is the total revenue per team (including parts and services)?
SELECT e.Nome_Equipe,
       SUM(COALESCE(os.ValorTotal, 0)) AS Total_Revenue
FROM OrdemServico os
JOIN Equipe e ON os.idEquipe = e.idEquipe
GROUP BY e.idEquipe
HAVING SUM(os.ValorTotal) > 0
ORDER BY Total_Revenue DESC;

-- 3. Which services were performed most frequently?
SELECT s.Descricao, COUNT(*) AS Times_Performed
FROM OS_Servico oss
JOIN Servico s ON oss.idServico = s.idServico
GROUP BY s.idServico
ORDER BY Times_Performed DESC;

-- 4. Calculate the average value of completed orders
SELECT ROUND(AVG(ValorTotal), 2) AS Avg_Completed_Value
FROM OrdemServico
WHERE Status = 'Concluída';

-- 5. List mechanics and their teams ordered by specialty
SELECT m.Nome, m.Especialidade, e.Nome_Equipe
FROM Mecanico m
JOIN Equipe e ON m.idEquipe = e.idEquipe
ORDER BY m.Especialidade;

-- 6. Show clients who spent more than R$500
SELECT c.Nome, SUM(os.ValorTotal) AS Total_Spent
FROM OrdemServico os
JOIN Cliente c ON os.idCliente = c.idCliente
GROUP BY c.idCliente
HAVING Total_Spent > 500
ORDER BY Total_Spent DESC;

-- 7. Derived attribute: calculate total parts + services per OS
SELECT os.idOS,
       (SELECT SUM(SubTotal) FROM OS_Servico WHERE idOS = os.idOS) +
       (SELECT SUM(SubTotal) FROM OS_Peca WHERE idOS = os.idOS) AS Calculated_Total
FROM OrdemServico os;

