# 🔧 Sistema de Gerenciamento de Oficina Mecânica

## 🧩 Descrição do Desafio

Este projeto foi desenvolvido como parte de um desafio de **modelagem de banco de dados**.  
O objetivo é criar **um esquema conceitual do zero**, com base em uma **narrativa descritiva de uma oficina mecânica**, contemplando as entidades, atributos e relacionamentos necessários para o **controle e gerenciamento de ordens de serviço (OS)**.

O esquema foi elaborado com base em boas práticas de **modelagem conceitual (DER)**, utilizando **entidades fortes, fracas, relacionamentos N:N e atributos derivados** quando necessário.

---

## 📖 Narrativa do Projeto

> O sistema deve controlar e gerenciar a execução de ordens de serviço (OS) em uma oficina mecânica.  
> Clientes levam veículos à oficina para conserto ou revisão periódica.  
> Cada veículo é designado a uma equipe de mecânicos que identifica os serviços a serem executados e preenche uma OS com data de entrega.  
> A partir da OS, calcula-se o valor de cada serviço, consultando uma tabela de referência de mão de obra.  
> O valor das peças também compõe a OS.  
> O cliente autoriza a execução dos serviços, e a mesma equipe realiza os trabalhos.  
> Mecânicos possuem código, nome, endereço e especialidade.  
> Cada OS possui número, data de emissão, valor, status e data prevista para conclusão.

---

## 🧠 Esquema Conceitual — Descrição das Entidades e Relacionamentos

### 🧍 Cliente
- **Atributos:** idCliente, nome, telefone, endereço  
- **Relacionamentos:**
  - Possui um ou mais **Veículos**  
  - Autoriza uma ou mais **Ordens de Serviço**

---

### 🚗 Veículo
- **Atributos:** idVeiculo, placa, modelo, marca, ano  
- **Relacionamentos:**
  - Pertence a um **Cliente**  
  - Está associado a uma **Ordem de Serviço**

---

### 🧾 Ordem de Serviço (OS)
- **Atributos:** idOS, data_emissao, data_conclusao, valor_total, status  
- **Relacionamentos:**
  - Referente a um **Veículo**  
  - É executada por uma **Equipe de Mecânicos**  
  - Contém vários **Serviços** e **Peças**  
  - É autorizada por um **Cliente**

---

### 🧰 Equipe
- **Atributos:** idEquipe, nomeEquipe (opcional)  
- **Relacionamentos:**
  - É composta por vários **Mecânicos**  
  - Realiza várias **Ordens de Serviço**

---

### 🧑‍🔧 Mecânico
- **Atributos:** idMecanico, nome, endereço, especialidade  
- **Relacionamentos:**
  - Pertence a uma **Equipe**  
  - Pode participar de várias **Ordens de Serviço** (via equipe)

---

### ⚙️ Serviço
- **Atributos:** idServico, descricao, valorReferencia  
- **Relacionamentos:**
  - Está associado a várias **Ordens de Serviço**  
  - Seu valor é consultado na **tabela de referência de mão de obra**

---

### 🪛 Peça
- **Atributos:** idPeca, descricao, valorUnitario  
- **Relacionamentos:**
  - Pode estar em várias **Ordens de Serviço**

---

### 📋 OS_Serviço (associação N:N)
- **Atributos:** quantidade, valorUnitario, subtotal  
- **Relacionamentos:**
  - Liga **Ordem de Serviço** e **Serviço**

---

### 📦 OS_Peça (associação N:N)
- **Atributos:** quantidade, valorUnitario, subtotal  
- **Relacionamentos:**
  - Liga **Ordem de Serviço** e **Peça**

---

## 🧮 Regras e Observações do Modelo

1. **Um cliente** pode ter **vários veículos**, mas cada veículo pertence a **um único cliente**.  
2. Cada **ordem de serviço** é aberta para **um veículo** específico.  
3. **Serviços** e **peças** podem ser reutilizados em várias OS.  
4. O **valor total da OS** é calculado a partir da soma de serviços e peças.  
5. Uma **equipe** pode executar várias OS, e cada equipe é formada por vários mecânicos.  
6. O **status** da OS pode ser: "Aberta", "Em execução", "Concluída" ou "Cancelada".

---

## 🧭 Modelo Conceitual (Visão Simplificada)

```text
CLIENTE (1,N)───< VEÍCULO (1,1)───< ORDEM_DE_SERVIÇO >───(N,N) SERVIÇO
                                         │
                                         ├───(N,N) PEÇA
                                         │
                                         └───(N,1) EQUIPE >───(1,N) MECÂNICO
