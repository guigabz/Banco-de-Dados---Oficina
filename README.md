# 🔧 Sistema de Gerenciamento de Oficina Mecânica

## 🧩 Descrição do Projeto

Este projeto foi desenvolvido como parte de um desafio de **modelagem de banco de dados relacional**, com o objetivo de criar **um esquema conceitual completo** para uma **oficina mecânica**.  

O sistema visa representar o **processo de controle e gerenciamento de ordens de serviço (OS)**, abrangendo desde o cadastro de clientes e veículos até a execução de serviços e utilização de peças.  

O modelo foi elaborado segundo boas práticas de **modelagem conceitual (DER)**, utilizando **entidades fortes, fracas, relacionamentos N:N e atributos derivados** quando apropriado.

---

## 📖 Narrativa do Sistema

> O sistema de gerenciamento de oficina deve controlar e acompanhar todas as etapas de uma **ordem de serviço (OS)**.  
>  
> Os clientes levam seus veículos para conserto ou revisão periódica. Cada veículo é atribuído a uma equipe de mecânicos responsável por identificar os serviços necessários e preencher uma OS, incluindo a **data prevista de conclusão**.  
>  
> O valor da OS é composto pela **mão de obra (serviços)** e pelo **custo das peças** utilizadas. Após o cliente autorizar os serviços, a equipe designada executa o trabalho.  
>  
> Cada mecânico possui informações pessoais e uma **especialidade**, e as OSs possuem **número, data de emissão, valor total, status e previsão de conclusão**.

---

## 🧠 Esquema Conceitual — Entidades e Relacionamentos

### 🧍 Cliente
- **Atributos:** `idCliente`, `nome`, `telefone`, `endereco`
- **Relacionamentos:**
  - Possui um ou mais **Veículos**
  - Autoriza uma ou mais **Ordens de Serviço**

---

### 🚗 Veículo
- **Atributos:** `idVeiculo`, `placa`, `modelo`, `marca`, `ano`
- **Relacionamentos:**
  - Pertence a um **Cliente**
  - Está vinculado a uma **Ordem de Serviço**

---

### 🧾 Ordem de Serviço (OS)
- **Atributos:** `idOS`, `data_emissao`, `data_conclusao`, `valor_total`, `status`
- **Relacionamentos:**
  - Associada a um **Cliente**
  - Relacionada a um **Veículo**
  - Executada por uma **Equipe**
  - Contém múltiplos **Serviços** e **Peças**

---

### 🧰 Equipe
- **Atributos:** `idEquipe`, `nomeEquipe`
- **Relacionamentos:**
  - Composta por vários **Mecânicos**
  - Responsável por várias **Ordens de Serviço**

---

### 🧑‍🔧 Mecânico
- **Atributos:** `idMecanico`, `nome`, `endereco`, `especialidade`
- **Relacionamentos:**
  - Pertence a uma **Equipe**
  - Pode atuar em várias **Ordens de Serviço** (via equipe)

---

### ⚙️ Serviço
- **Atributos:** `idServico`, `descricao`, `valorReferencia`
- **Relacionamentos:**
  - Associado a várias **Ordens de Serviço**
  - Consultado na tabela de **referência de mão de obra**

---

### 🪛 Peça
- **Atributos:** `idPeca`, `descricao`, `valorUnitario`
- **Relacionamentos:**
  - Pode ser utilizada em várias **Ordens de Serviço**

---

### 📋 OS_Serviço (Associação N:N)
- **Atributos:** `quantidade`, `valorUnitario`, `subtotal`
- **Relacionamentos:**
  - Liga **Ordem de Serviço** e **Serviço**

---

### 📦 OS_Peça (Associação N:N)
- **Atributos:** `quantidade`, `valorUnitario`, `subtotal`
- **Relacionamentos:**
  - Liga **Ordem de Serviço** e **Peça**

---

## 🧮 Regras e Observações do Modelo

1. Um **cliente** pode possuir **vários veículos**, mas cada veículo pertence a apenas **um cliente**.  
2. Cada **ordem de serviço** é criada para um único **veículo**.  
3. **Serviços** e **peças** podem ser reutilizados em diversas OS.  
4. O **valor total** da OS é calculado pela soma dos **serviços e peças** associados.  
5. Uma **equipe** pode executar diversas OS, sendo formada por vários **mecânicos**.  
6. O campo **status** da OS pode assumir os valores:  
   - `"Aberta"`  
   - `"Em execução"`  
   - `"Concluída"`  
   - `"Cancelada"`

---

## 🧭 Modelo Conceitual (Visão Simplificada)


CLIENTE (1,N)───< VEÍCULO (1,1)───< ORDEM_DE_SERVIÇO >───(N,N) SERVIÇO
                                         │
                                         ├───(N,N) PEÇA
                                         │
                                         └───(N,1) EQUIPE >───(1,N) MECÂNICO
🧱 Extensões Possíveis

Implementação do modelo lógico e físico em MySQL.

Criação de triggers para atualização automática do valor total da OS.

Uso de views para geração de relatórios (ex: faturamento por equipe).

Desenvolvimento de stored procedures para abertura e fechamento de OS.

🧑‍💻 Autor

Guilherme Gabriel - https://github.com/guigabz
```text
📚 Projeto acadêmico — Modelagem de Banco de Dados Relacional
🗓️ Ano: 2025
🛠️ Linguagem: SQL / MySQL
