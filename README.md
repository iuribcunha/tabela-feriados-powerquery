# Feriados Brasileiros - Power Query (M Language)

> Função que retorna uma tabela com todos os feriados de um determinado ano, incluindo feriados nacionais, estaduais/municipais e móveis (calculados com base na Páscoa).

---

## Sumário

1. [Visão Geral](#visão-geral)
2. [Parâmetro e Retorno](#parâmetro-e-retorno)
3. [Algoritmo da Páscoa](#algoritmo-da-páscoa)
4. [Feriados Fixos](#feriados-fixos)
5. [Feriados Móveis](#feriados-móveis)
6. [Resultado Final](#resultado-final)
7. [Como Usar](#como-usar)
8. [Como Personalizar](#como-personalizar)
9. [Código Completo Comentado](#código-completo-comentado)

---

## Visão Geral

O código é uma **função anônima** escrita em **M Language** (Power Query), compatível com Power BI e Excel. Ela recebe um ano como entrada e devolve uma tabela com duas colunas:

| Coluna   | Tipo   | Descrição                        |
|----------|--------|----------------------------------|
| `Data`   | `date` | Data do feriado                  |
| `Feriado`| `text` | Nome/descrição do feriado        |

A função é dividida em quatro blocos principais:

```
Cálculo da Páscoa → Feriados Municipais/Estaduais → Feriados Nacionais → Feriados Móveis
```

---

## Parâmetro e Retorno

```powerquery
(y as number) => ...
```

| Item       | Detalhe                                  |
|------------|------------------------------------------|
| Parâmetro  | `y` - ano de 4 dígitos (ex: `2025`)      |
| Retorno    | `Table` com colunas `[Data, Feriado]`    |

---

## Algoritmo da Páscoa

A Páscoa é um feriado móvel calculado com base no **Algoritmo Anônimo Gregoriano**, conforme documentado na [Wikipedia - Date of Easter](https://en.wikipedia.org/wiki/Date_of_Easter).

O algoritmo determina o **primeiro domingo após a primeira lua cheia** que ocorre depois do equinócio de março (21 de março).

### Variáveis do Cálculo

| Variável | Expressão | Significado |
|----------|-----------|-------------|
| `a` | `y mod 19` | Posição do ano no **Ciclo de Metônico** (ciclo lunar de 19 anos) |
| `b` | `⌊y / 100⌋` | Número do século |
| `c` | `y mod 100` | Ano dentro do século |
| `d` | `⌊b / 4⌋` | Correção secular dos anos bissextos |
| `e` | `b mod 4` | Resto da correção secular |
| `f` | `⌊(b + 8) / 25⌋` | Correção do ciclo lunar secular |
| `g` | `⌊(b − f + 1) / 3⌋` | Ajuste adicional do ciclo lunar |
| `h` | `(19a + b − d − g + 15) mod 30` | **Epacta** - dia da lua cheia eclesiástica |
| `i` | `⌊c / 4⌋` | Correção bissexta do ano corrente |
| `k` | `c mod 4` | Resto da correção bissexta |
| `l` | `(32 + 2e + 2i − h − k) mod 7` | Dia da semana do domingo seguinte à lua cheia |
| `m` | `⌊(a + 11h + 22l) / 451⌋` | Correção final do calendário gregoriano |
| `n` | `⌊(h + l − 7m + 114) / 31⌋` | **Mês** da Páscoa |
| `o` | `(h + l − 7m + 114) mod 31` | **Dia** da Páscoa (base 0, por isso `o + 1`) |

### Data Final

```powerquery
pascoa = #date(y, n, o + 1)
```

> ⚠️ O `+ 1` é necessário porque `o` é calculado em base zero (0 = dia 1 do mês).

---

## Feriados Fixos

### Nacionais

Datas definidas por lei federal, válidas em todo o território brasileiro:

| Data        | Feriado                        |
|-------------|--------------------------------|
| 01 de Janeiro | Ano Novo                     |
| 21 de Abril  | Tiradentes                    |
| 01 de Maio   | Dia do Trabalho               |
| 07 de Setembro | Dia da Independência        |
| 12 de Outubro | Nossa Senhora Aparecida      |
| 02 de Novembro | Finados                     |
| 15 de Novembro | Proclamação da República    |
| 20 de Novembro | Consciência Negra           |
| 25 de Dezembro | Natal                       |

### Municipais / Estaduais

Esta seção deve ser **personalizada** conforme o município ou estado de interesse. No código original, está configurado para São Paulo (SP):

| Data        | Feriado                              | Abrangência |
|-------------|--------------------------------------|-------------|
| 09 de Julho | Revolução Constitucionalista de 1932 | Estado de SP |

---

## Feriados Móveis

Calculados como deslocamento em dias a partir da data da Páscoa:

| Feriado            | Deslocamento       | Como cai            |
|--------------------|--------------------|---------------------|
| Carnaval           | Páscoa − 47 dias   | Segunda-feira Gorda |
| Paixão de Cristo   | Páscoa − 2 dias    | Sexta-Feira Santa   |
| Domingo de Páscoa  | Páscoa + 0 dias    | Domingo             |
| Corpus Christi     | Páscoa + 60 dias   | Quinta-feira        |

> 💡 Tecnicamente, o Carnaval não é feriado nacional por lei — mas é amplamente tratado como ponto facultativo. O código o inclui por conveniência.

---

## Resultado Final

As três listas são concatenadas com `&` e convertidas em tabela:

```powerquery
Resultado = Table.FromRecords(
    Feriados_Municipais_Estaduais & Feriados_Nacionais & Feriados_Moveis
)
```

A tabela resultante tem o seguinte formato:

| Data       | Feriado                        |
|------------|--------------------------------|
| 01/01/2025 | Ano Novo                       |
| 03/03/2025 | Carnaval                       |
| 18/04/2025 | Paixão de Cristo               |
| 20/04/2025 | Domingo de Páscoa              |
| 21/04/2025 | Tiradentes                     |
| ...        | ...                            |

---

## Como Usar

### No Power BI

1. Abra o **Power Query Editor**
2. Crie uma **nova consulta em branco**
3. Cole o código e renomeie para `FeriadosBrasileiros`
4. Para chamar a função com um ano específico:

```powerquery
= FeriadosBrasileiros(2025)
```

5. Para gerar feriados de múltiplos anos, use `List.Generate` ou invoque a função a partir de uma tabela de anos

### No Excel (Power Query)

1. Acesse **Dados → Obter Dados → Editor do Power Query**
2. Siga os mesmos passos acima

---

## Como Personalizar

### Adicionar feriado municipal

```powerquery
Feriados_Municipais_Estaduais = {
    [Data = #date(y, 07, 09), Feriado = "Revolução Constitucionalista"], // SP
    [Data = #date(y, 01, 25), Feriado = "Aniversário de São Paulo"]      // Município de SP
},
```

### Adicionar coluna de Tipo

Para facilitar filtros posteriores, você pode incluir uma coluna `Tipo`:

```powerquery
Feriados_Nacionais = {
    [Data = #date(y, 01, 01), Feriado = "Ano Novo", Tipo = "Nacional"],
    ...
},
Feriados_Moveis = {
    [Data = pascoa, Feriado = "Domingo de Páscoa", Tipo = "Móvel"],
    ...
},
```

### Filtrar apenas dias úteis

Após gerar a tabela, você pode cruzar com um calendário para marcar dias úteis:

```powerquery
= Table.AddColumn(Resultado, "EhUtil", each 
    if Date.DayOfWeek([Data], Day.Monday) >= 5 then false else true
)
```

---

## Código Completo Comentado

```powerquery
// Função: FeriadosBrasileiros
// Descrição : Retorna uma tabela com todos os feriados do ano informado,
//             incluindo nacionais, estaduais/municipais e móveis (baseados na Páscoa).
// Parâmetro : y (number) — Ano de referência (ex: 2025)
// Retorno   : Table com colunas [Data, Feriado]
(y as number) => 
let 
    // =========================================================
    // CÁLCULO DA PÁSCOA — Algoritmo Anônimo Gregoriano
    // Fonte: https://en.wikipedia.org/wiki/Date_of_Easter
    // =========================================================

    a = Number.Mod(y, 19),                     // Posição no Ciclo de Metônico
    b = Number.RoundDown(y / 100),             // Século
    c = Number.Mod(y, 100),                    // Ano dentro do século
    d = Number.RoundDown(b / 4),               // Correção secular dos bissextos
    e = Number.Mod(b, 4),                      // Resto da correção secular
    f = Number.RoundDown((b + 8) / 25),        // Correção do ciclo lunar secular
    g = Number.RoundDown((b - f + 1) / 3),     // Ajuste adicional do ciclo lunar
    h = Number.Mod((19 * a + b - d - g + 15), 30), // Epacta (lua cheia eclesiástica)
    i = Number.RoundDown(c / 4),               // Correção bissexta do ano corrente
    k = Number.Mod(c, 4),                      // Resto da correção bissexta
    l = Number.Mod((32 + 2 * e + 2 * i - h - k), 7), // Dia da semana após a lua cheia
    m = Number.RoundDown((a + 11 * h + 22 * l) / 451), // Correção final gregoriana
    n = Number.RoundDown((h + l - 7 * m + 114) / 31),  // Mês da Páscoa
    o = Number.Mod((h + l - 7 * m + 114), 31),          // Dia da Páscoa (base 0)
    pascoa = #date(y, n, o + 1),               // +1 porque o dia é calculado em base 0

    // =========================================================
    // FERIADOS MUNICIPAIS / ESTADUAIS
    // Ajuste conforme o município ou estado desejado.
    // =========================================================
    Feriados_Municipais_Estaduais = {
        [Data = #date(y, 07, 09), Feriado = "Revolução Constitucionalista"] // SP
    },

    // =========================================================
    // FERIADOS NACIONAIS — Datas fixas definidas por lei federal
    // =========================================================
    Feriados_Nacionais = {
        [Data = #date(y, 01, 01), Feriado = "Ano Novo"],
        [Data = #date(y, 04, 21), Feriado = "Tiradentes"],
        [Data = #date(y, 05, 01), Feriado = "Dia do Trabalho"],
        [Data = #date(y, 09, 07), Feriado = "Dia da Independência"],
        [Data = #date(y, 10, 12), Feriado = "Nossa Sra. Aparecida"],
        [Data = #date(y, 11, 02), Feriado = "Finados"],
        [Data = #date(y, 11, 15), Feriado = "Proclamação da República"],
        [Data = #date(y, 11, 20), Feriado = "Consciência Negra"],
        [Data = #date(y, 12, 25), Feriado = "Natal"]
    },

    // =========================================================
    // FERIADOS MÓVEIS — Calculados com base na data da Páscoa
    // =========================================================
    Feriados_Moveis = {
        [Data = Date.AddDays(pascoa, -47), Feriado = "Carnaval"],         // 47 dias antes
        [Data = Date.AddDays(pascoa, -2),  Feriado = "Paixão de Cristo"], // Sexta-Feira Santa
        [Data = pascoa,                    Feriado = "Domingo de Páscoa"],
        [Data = Date.AddDays(pascoa, 60),  Feriado = "Corpus Christi"]    // 60 dias depois
    },

    // =========================================================
    // RESULTADO — Une as listas e converte em tabela [Data, Feriado]
    // =========================================================
    Resultado = Table.FromRecords(
        Feriados_Municipais_Estaduais & Feriados_Nacionais & Feriados_Moveis
    )

in 
    Resultado
```

---

*Fonte do algoritmo da Páscoa: [Wikipedia — Date of Easter](https://en.wikipedia.org/wiki/Date_of_Easter)*
