(y as number) => 
let 
    /* Fonte: https://en.wikipedia.org/wiki/Date_of_Easter */
    a = Number.Mod(y, 19),
    b = Number.RoundDown(y / 100),
    c = Number.Mod(y, 100),
    d = Number.RoundDown(b / 4),
    e = Number.Mod(b, 4),
    f = Number.RoundDown((b + 8) / 25),
    g = Number.RoundDown((b - f + 1) / 3),
    h = Number.Mod((19 * a + b - d - g + 15), 30),
    i = Number.RoundDown(c / 4),
    k = Number.Mod(c, 4),
    l = Number.Mod((32 + 2 * e + 2 * i - h - k), 7),
    m = Number.RoundDown((a + 11 * h + 22 * l) / 451),
    n = Number.RoundDown((h + l - 7 * m + 114) / 31),
    o = Number.Mod((h + l - 7 * m + 114), 31),
    pascoa = #date(y, n, o + 1),

    /* Feriados Municipais/Estaduais (Mês, Dia) */ 
    Feriados_Municipais_Estaduais = {
        [Data = #date(y, 07, 09), Feriado = "Revolução Constitucionalista"]
    },

    /* Feriados Nacionais (Mês, Dia) */ 
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

    /* Feriados Móveis */
    Feriados_Moveis = {
        [Data = Date.AddDays(pascoa, -47), Feriado = "Carnaval"],
        [Data = Date.AddDays(pascoa, -2), Feriado = "Paixão de Cristo"], 
        [Data = pascoa, Feriado = "Domingo de Páscoa"],
        [Data = Date.AddDays(pascoa, 60), Feriado = "Corpus Christi"]  
    },

    Resultado = Table.FromRecords( Feriados_Municipais_Estaduais & Feriados_Nacionais & Feriados_Moveis )     
in 
    Resultado
