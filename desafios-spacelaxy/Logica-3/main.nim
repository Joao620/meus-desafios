import jsffi, jscore, jsconsole

type 
    IdCelula = cstring
    Celula = object
        id: IdCelula
        temperatura: int
        pressao: int
        atividadeBiologica: int
        pulsosEnergeticos: seq[int]
    Risco {.exportc.} = enum alto, medio, baixo
    ResultadoAnalise = object
        total: int
        niveis: array[Risco, seq[IdCelula]]
        descartadas: seq[IdCelula]

proc media(lista: seq[int]): int =
    if lista.len == 0:
        return 0
    var sum = 0
    for num in lista:
        sum += num
    return Math.floor(sum / lista.len)

proc viva(celula: Celula): bool =
    return 
        celula.temperatura > 50 and
        celula.pressao > 40     and
        celula.atividadeBiologica > 70 and
        celula.pulsosEnergeticos.media > 10

proc nivelRisco(lista: seq[int]): Risco =
    var 
        ultimoPulso = lista[0]
        ultimaDiferenca = 0

    for pulso in lista:
        let diferenca = pulso - ultimoPulso

        if diferenca >= 15:
            return Risco.alto
        elif diferenca < ultimaDiferenca:
            return Risco.baixo

        ultimaDiferenca = diferenca
        ultimoPulso = pulso

    return Risco.medio

proc analisar(celulas: seq[Celula]): ResultadoAnalise {.exportc.} =
    result.total = celulas.len
    for umaCelula in celulas:
        if umaCelula.viva:
            let risco = nivelRisco umaCelula.pulsosEnergeticos
            result.niveis[risco].add(umaCelula.id)
        else:
            result.descartadas.add umaCelula.id