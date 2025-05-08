# Protocolo Leviatã
História: O protocolo Leviatã foi desenvolvido para monitorar e classificar o risco das células submersas de um submarino avançado que explora águas profundas. As células são responsáveis por manter a estabilidade do submarino, e você foi definido como o responsável para criar um sistema que analisa as condições das células e classifica de acordo com níveis de risco. Fodástico!

Antes de ir para análise, precisamos classificar as células com algumas regras. Caso ela não passe nas regras, elas são descartadas. Inclusive, você tem que deixar o log de todas as células descartadas no final do algoritmo. As regras são:
    A temperatura tem que ser maior que 50 graus.
    A pressão tem que ser maior que 40 bar.
    A atividade biológica tem que ser maior que 70%.
    A média de variação dos pulsos energéticos tem que ser maior que 10 unidades (média aritmética).


As células podem ser classificadas em níveis de risco, que são:
  * Nível 3, colapso iminente - Classificada como esse nível caso ela tenha 3 pulsos consecutivos, onde cada pulso é maior que o anterior. Por exemplo, 10, 15, 20, e somente caso tenha também pelo menos um salto gigantesco entre dois pulsos consecutivos (diferença maior que 15 unidades). Exemplo: de 10 para 25.
  
  * Nível 2, instabilidade crítica - Classificada como esse nível caso tenha um crescimento consecutivo dos pulsos, assim como no nível 3, mas sem um salto gigantesco entre os pulsos. Além disso, a média dos pulsos tem que ser maior que 20 unidades.
  
  * Nível 1, anomalia detectada - Classificada como esse nível caso os pulsos sigam um padrão não comum, por exemplo, subida-descida-subida e vice-versa.


O sistema precisa mostrar um log no final que segue esse modelo: (total = número de células analisadas, e o resto está fácil de entender e não tem por que explicar mais)

{
  "total": 5,
  "niveis": {
    "3": ["A1", "C2"],
    "2": ["E5"],
    "1": ["B3"]
  },
  "descartadas": ["A2"]
}

Você tem que usar o file system para carregar esse JSON com os dados iniciais e processar eles logo depois. Para ver o arquivo JSON inicial, só clicar bem aqui!

# Eu!
Cara, bem simples, dá pra fazer de maneira interativa permitindo a modificação do JSON na página, mas não sei se quero fazer isso. Não seria muito dificil tho. 

Sobre os dados, vou precisar lidar como ele todo no javascript, vamos ver como dá pra fazer. 