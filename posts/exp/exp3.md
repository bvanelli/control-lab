---
permalink: exp3/
title: Experimento 3
title_icon: fas fa-puzzle-piece
body_color: purple
updated: 2018-06-10
type: exp
description: Modelagem de um sistema térmico baseado em peltier à partir da resposta ao degrau.
---

# Introdução

[No experimento passado](/control-lab/exp2/) foi relizado o controle em malha fechada da planta térmica, que é muito mais simples e por isso pode ser modelado matematicamente. Para outros sistemas térmicos, a modelagem não é tão direta porque a saída depende de vários fatores. 

No caso da peltier, a modelagem é mais complicada e depende da resistência térmica de todos os dissipadores de calor e da placa peltier, além de suas respectivas capacidades térmicas, parâmetros difícieis de obter matematicamente. Para uma modelagem mais detalhada nessa linha de raciocínio, veja [este artigo](http://citeseerx.ist.psu.edu/viewdoc/download?doi=10.1.1.741.5453&rep=rep1&type=pdf).

Esse experimento parte pra outra abordagem, que é a identificação dos parâmetros do sistema através de testes com degrau. A dinâmica é então medida e podemos utilizar curvas que melhor se aproximam do sistema real.

# Teste com o degrau

Para inserir um degrau no sistema, montamos o sistema de peltier como [demonstrado na documentação da planta](/control-lab/planta2/). Utilizamos uma fonte de tensão de **12V@3A** como degrau no sistema, utilizando o circuito descrito. É importante fazer a identificação com o circuito pois ele adiciona uma resistência do transistor que diminui a corrente da peltier. A tensão foi mantida constante durante todo o experimento mas a corrente variou devido às características internas da peltier.

O gráfico da temperatura e os dados brutos do experimento podem ser vistos abaixo.

<div class="card bg-light mb-3" style="width: 100%;">
  <img class="card-img-top" src="/control-lab/assets/images/exp3/step.png" style="width: 95%" alt="Card image cap">
  <div class="card-body" style="margin-bottom: 2rem;">
    <p class="card-text">Baixe os dados brutos da resposta ao degrau.</p>
    <a href="https://github.com/bvanelli/control-lab/raw/master/data/exp3.mat" target="_blank" class="btn btn-primary">Baixar dados</a>
  </div>
</div>

# Tratamento de dados

Para realizar a identificação do sistema, primeiro é preciso tratar os dados. Importe os dados utilizando a função `load`:

```python
load('exp3.mat')
dados
```

Vamos fazer um plot da resposta ao degrau. Pode-se observar que o degrau é aplicado em 100 segundos e o sistema reage diminuindo a temperatura. Já é notável que o ganho do sistema é negativo e ele possui no mínimo dinâmica de segunda ordem.

```python
plot(dados.time, dados.temperature); hold on;
plot(dados.time, dados.input)
```

Como o sample time **Ts** é igual à 1, não iremos precisar dos dados de tempo.

```python
saida = dados.temperature;
```

Todo sistema linear apresenta ponto de equilíbrio no zero, então será preciso linearizar o sistema. Para isto, basta remover o valor de offset:

```python
saida = saida - saida(1);
```

Vamos também normalizar em relação ao degrau de entrada para obter a resposta ao degrau unitário. Como sabemos que o degrau aplicado pelo Arduino é de 5V, vamos modelar o sistema em torno desse valor para evitar conversões.

```python
saida = saida/5;
plot(saida);
```

Já é possível inferir que o ganho do sistema é aproximadamente **-3.5**. É necessário agora aproximá-lo por uma função de transferência ou modelo no espaço de estados.

<img src="/control-lab/assets/images/exp3/step-norm.png" style="width: 80%;"/>

# Aproximação por tfest

Como o sistema tem ordem elevada, métodos empíricos como Ziegler-Nichols, Hagglund, Nishikawa e Sundaresan não funcionam pois predizem modelos de primeira ordem.

Uma alternativa é usar métodos numéricos que melhor se adequam aos dados. Pode-se, por exemplo, utilizar a função `tfest` que estima o melhor modelo dada a ordem do sistema. Primeiro, é necessário criar uma variável que contém os dados do modelo:

```python
Ts = 1;
tsaida = saida;
tentrada = dados.input/5;
data = iddata(tsaida, tentrada, Ts);
```

É recomendado adicionar alguns zeros antes do degrau pela documentação da função (que os dados já possuem). Podemos inicialmente estimar um sistema de três polos e um zero, baseando-se na resposta desejada.

```python
G = tfest(data, 3, 1)
```

O resultado aparenta ser bastante bom:

```

G =

  From input "u1" to output "y1":
            -0.001096 s - 1.629e-05
  -------------------------------------------
  s^3 + 0.04304 s^2 + 0.0008624 s + 4.763e-06

Continuous-time identified transfer function.

Parameterization:
   Number of poles: 3   Number of zeros: 1
   Number of free coefficients: 5
   Use "tfdata", "getpvec", "getcov" for parameters and their uncertainties.

Status:
Estimated using TFEST on time domain data "data".
Fit to estimation data: 99.15% (simulation focus)
FPE: 7.844e-05, MSE: 7.639e-05

```

Pode-se observar que o matching é quase perfeito dos dois sistemas (aproximação e real), mas a ordem ainda pode ser reduzida sem muita perda de informação (note que as constantes do numerador e denominador são muito pequenas).

<img src="/control-lab/assets/images/exp3/comparacao.png" style="width: 80%;"/>

# Aproximação de segunda ordem ordem

Muitas vezes, para facilitar o projeto do controlador é necessário reduzir a ordem do sistema. Pode-se obter também um modelo reduzido, mas que não vai ser tão realista. Nesse caso, o modelo de segunda ordem se adequa bastante pois a dinâmica é mais simples, mas para sistemas mais complexos, o ideal é obter o menor modelo possível para controle.

```python
G = tfest(data, 2, 0)
```

Que dá como resultado uma aproximação pior mas com ordem reduzida.

```
G =
 
           -0.001532
  ---------------------------
  s^2 + 0.04669 s + 0.0004554

Fit to estimation data: 97.09% (simulation focus)
``` 

<img src="/control-lab/assets/images/exp3/comparacao2.png" style="width: 80%;"/>

# Modelo Completo

Com base nos modelos obtidos anteriormente, pode-se obter um modelo completo da planta. Foi feito um bloco com o modelo no simulink para testar os possíveis controladores no sistema.

<div class="card" style="width: 100%;">
  <img class="card-img-top" src="/control-lab/assets/images/exp3/simulink-matlab.png" style="width: 95%" alt="Card image cap">
  <div class="card-body" style="margin-bottom: 2rem;">
    <p class="card-text">Baixe o modelo no Simulink para utilizar no MATLAB.</p>
    <a href="https://github.com/bvanelli/control-lab/raw/master/models/modelo2.slx" target="_blank" class="btn btn-primary">Baixar modelo</a>
  </div>
</div>

# Conclusão

Esse experimento realizou a identificação de um modelo a partir da resposta ao degrau. O próximo experimento abordará o projeto e implementação do controlador para o sistema utilizando a aproximação obtida.
