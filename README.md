# 📅 Calculadora de Feriados em Power Query (M)

Este repositório contém uma função em **Power Query (linguagem M)** que gera automaticamente os **feriados nacionais, estaduais/municipais e móveis** do Brasil para qualquer ano.

A função utiliza o **Algoritmo Gregoriano Anônimo** para calcular a data da Páscoa, a partir da qual são determinados feriados móveis como **Carnaval, Paixão de Cristo** e **Corpus Christi**.

---

## ✨ Funcionalidades
- 📌 Cálculo da data da **Páscoa** para qualquer ano.  
- 📌 Inclusão de **feriados nacionais fixos**.  
- 📌 Inclusão de **feriados estaduais/municipais** (exemplo: Revolução Constitucionalista – SP).  
- 📌 Cálculo de **feriados móveis** dependentes da Páscoa.  
- 📌 Retorno em formato de **tabela estruturada** pronta para uso no Power BI ou Excel.  

---

## 📂 Estrutura do Projeto
- `tabela_feriados_power_query.m` → contém a função em linguagem **M**.  
- `README.md` → documentação e exemplos de uso.  

---

## 🚀 Como Usar

### 1. Importar no Power Query
1. Abra o **Power Query** no Excel ou Power BI.  
2. Crie uma **nova consulta nula (em branco)**.
3. Clique com o botão direito sobre ela e vá em "Editor avançado"
4. Copie o conteúdo do arquivo [`tabela_feriados_power_query.m`](./tabela_feriados_power_query.m) e cole no editor avançado.  
5. Dê um nome à função (ex: `Feriados`).  

### 2. Executar a Função
Após clicar em OK, digite o ano que deseja obter as daras.

📖 Referências
- [Wikipedia – Date of Easter](https://en.wikipedia.org/wiki/Date_of_Easter)
- [Lei nº 662/1949 – Feriados Nacionais no Brasil](https://www.planalto.gov.br/ccivil_03/leis/l0662.htm)

### ⚠️ IMPORTANTE
1. Os formatos de datas devem seguir o padrão **MÊS, DIA**.  
   - Exemplo: `07, 09` → **09 de Julho**

2. Para adicionar novos feriados, insira manualmente dentro do código utilizando a mesma estrutura:  
   ```m
   [Data = #date(y, 11, 20), Feriado = "Consciência Negra"],
   [Data = #date(y, 04, 21), Feriado = "Tiradentes"]
   ```

3. Atenção com as vírgulas:
Todos os itens da lista devem terminar com vírgula, exceto o último.
Exemplo correto:
  ```m
  [Data = #date(y, 01, 01), Feriado = "Ano Novo"],
  [Data = #date(y, 04, 21), Feriado = "Tiradentes"]
  ```
Se faltar uma vírgula no meio, ou se houver vírgula após o último item, ocorrerá erro no código.

