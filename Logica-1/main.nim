import jsffi, jscore

when not defined(js):
  {.error: "This module only works on the JavaScript platform".}

type
    Coord = tuple[x: int, y: int]
    TuplaMaxMix = tuple
        max: float
        min: float
    #Biomas = enum Floresta, Deserto, Geleira, Planalto, Pântano, FlorestaTropical
    Bioma = object
        strRepr: cstring
        requisitos: RequisitosBioma
    CaracteristicaBioma = tuple
        temperatura: float
        umidade: float
    RequisitosBioma = tuple
        temperatura: TuplaMaxMix
        umidade: TuplaMaxMix
    Raio = object
        bioma: Bioma
        coordenada: Coord

func jsStr(s: int): cstring {.importjs: "(#).toString()".}
func `//`(s1, s2: int): int {.importjs: "Math.floor(#/#)".}

const biomas = [
    Bioma(strRepr: "Floresta", requisitos: (temperatura: (0.4, 0.8), umidade: (0.6, 1.0))),
    Bioma(strRepr: "Deserto", requisitos: (temperatura: (0.7, 1.0), umidade: (0.0, 0.4))),
    Bioma(strRepr: "Geleira", requisitos: (temperatura: (0.0, 0.3), umidade: (0.6, 1.0))),
    Bioma(strRepr: "Planalto", requisitos: (temperatura: (0.4, 0.7), umidade: (0.0, 0.4))),
    Bioma(strRepr: "Pântano", requisitos: (temperatura: (0.3, 0.6), umidade: (0.4, 0.8))),
    Bioma(strRepr: "FlorestaTropical", requisitos: (temperatura: (0.6, 1.0), umidade: (0.8, 1.0)))
];

func `$`(coord: Coord): cstring =
    result = "(" & coord.x.jsStr() & "," & coord.y.jsStr() & ")"

func comporta(tupla: TuplaMaxMix, valor: float): bool =
    return tupla.min > valor and tupla.max <= valor

func comporta(bioma: Bioma, caracteristica: CaracteristicaBioma): bool =
    return bioma.requisitos.temperatura.comporta(caracteristica.temperatura) and
           bioma.requisitos.umidade.comporta(caracteristica.umidade)
        

proc coord2bioma(coord: Coord): (Raio, bool) =
    let 
        coordBiomaCache {.global.} = newJsAssoc[cstring, (CaracteristicaBioma, Raio)]()
        offsetadaCoord: Coord = (coord.x + 40, coord.y + 40)
        posRaioDaCoordenada = (offsetadaCoord.x // 80, offsetadaCoord.y // 80)

    if not coordBiomaCache[$posRaioDaCoordenada].isUndefined:
        return (coordBiomaCache[$posRaioDaCoordenada][1], false)

    while true:
        let caracteristicaBiomaAleatoria = (Math.random(), Math.random())
        for bioma in biomas:
            if bioma.comporta caracteristicaBiomaAleatoria:
                let raio = Raio(bioma: bioma, coordenada: posRaioDaCoordenada)
                coordBiomaCache[$posRaioDaCoordenada] = (caracteristicaBiomaAleatoria, raio)
                return (raio, true)

var personagem: Coord

discard coord2bioma personagem

proc andar(quant: int, direção: cstring): array[2, cstring] {.exportc.} =
    case direção
        of "cima":
            personagem.y -= quant
        of "baixo":
            personagem.y += quant
        of "esquerda":
            personagem.x -= quant
        of "direita":
            personagem.x += quant
        else:
            discard

    let 
        (raioAtual, ehNovo) = coord2bioma personagem
        mensagemBiomaNovo = (if ehNovo:
            "Novo raio - ".cstring & raioAtual.bioma.strRepr & " - ".cstring & $raioAtual.coordenada
            else: "")
        mensagemLogAndar = "Mov - " & $personagem & " - " & raioAtual.bioma.strRepr
         
    return [mensagemLogAndar, mensagemBiomaNovo]