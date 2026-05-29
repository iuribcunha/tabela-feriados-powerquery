// Função: FeriadosBrasileiros
// Descrição: Retorna uma tabela com todos os feriados do ano informado,
//            incluindo feriados nacionais, estaduais/municipais e móveis (baseados na Páscoa).
// Parâmetro: y (number) - Ano de referência (ex: 2025)
// Retorno:   Table com colunas [Data, Feriado]
(y as number) => 
let 
    // =========================================================
    // CÁLCULO DA PÁSCOA — Algoritmo Anônimo Gregoriano
    // Fonte: https://en.wikipedia.org/wiki/Date_of_Easter
    // Determina o domingo de Páscoa para o ano y.
    // =========================================================

    a = Number.Mod(y, 19),              // Posição do ano no ciclo de Metônico (19 anos)
    b = Number.RoundDown(y / 100),      // Século
    c = Number.Mod(y, 100),             // Ano dentro do século
    d = Number.RoundDown(b / 4),        // Quociente da correção secular
    e = Number.Mod(b, 4),               // Resto da correção secular
    f = Number.RoundDown((b + 8) / 25), // Correção do ciclo lunar
    g = Number.RoundDown((b - f + 1) / 3), // Ajuste adicional do ciclo lunar
    h = Number.Mod((19 * a + b - d - g + 15), 30), // Lua cheia eclesiástica (epacta)
    i = Number.RoundDown(c / 4),        // Quociente do ajuste bissexto do século
    k = Number.Mod(c, 4),               // Resto do ajuste bissexto do século
    l = Number.Mod((32 + 2 * e + 2 * i - h - k), 7), // Dia da semana do domingo após a lua cheia
    m = Number.RoundDown((a + 11 * h + 22 * l) / 451), // Correção final do calendário
    n = Number.RoundDown((h + l - 7 * m + 114) / 31),  // Mês da Páscoa
    o = Number.Mod((h + l - 7 * m + 114), 31),          // Dia da Páscoa (base 0)
    pascoa = #date(y, n, o + 1),        // Data final da Páscoa (+1 pois o dia é base 0)

    // =========================================================
    // FERIADOS MUNICIPAIS / ESTADUAIS
    // Ajuste esta lista conforme o município ou estado desejado.
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
        [Data = Date.AddDays(pascoa, -47), Feriado = "Carnaval"],          // 47 dias antes da Páscoa
        [Data = Date.AddDays(pascoa, -2),  Feriado = "Paixão de Cristo"],  // Sexta-Feira Santa
        [Data = pascoa,                    Feriado = "Domingo de Páscoa"],
        [Data = Date.AddDays(pascoa, 60),  Feriado = "Corpus Christi"]     // 60 dias após a Páscoa
    },

    // =========================================================
    // RESULTADO FINAL
    // Une as três listas e converte em tabela [Data, Feriado]
    // =========================================================
    Resultado = Table.FromRecords(
        Feriados_Municipais_Estaduais & Feriados_Nacionais & Feriados_Moveis
    )

in 
    Resultado
