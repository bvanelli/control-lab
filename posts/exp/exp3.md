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

Para inserir um degrau no sistema, montamos o sistema de peltier como [demonstrado na documentação da planta](/control-lab/planta2/). Utilizamos uma fonte de tensão de **10V@3A** como degrau no sistema. A tensão foi mantida constante durante todo o experimento mas a corrente variou devido às características internas da peltier.

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
Como só é de interesse a resposta ao degrau, vamos desconsiderar as primeiras 100 amostras. Como o sample time **Ts** é igual à 1, não iremos precisar dos dados de tempo.

```python
saida = dados.temperature(100:end);
```

Todo sistema linear apresenta ponto de equilíbrio no zero, então será preciso linearizar o sistema. Para isto, basta remover o valor de offset:

```python
saida = saida - saida(1);
```

Vamos também normalizar em relação ao degrau de entrada para obter a resposta ao degrau unitário:

```python
saida = saida/10;
plot(saida);
```

Já é possível inferir que o ganho do sistema é aproximadamente **-0.875**. É necessário agora aproximá-lo por uma função de transferência ou modelo no espaço de estados.

<img src="/control-lab/assets/images/exp3/step-norm.png" style="width: 80%;"/>



