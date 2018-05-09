---
permalink: /exp1/
title: Experimento 1
title_icon: icon_puzzle_alt
body_color: blue
updated: 2018-05-09
description: Modelagem e implicações dos controladores para um sistema térmico.
---

<!-- Include MathJax to render LaTeX -->

<script type="text/x-mathjax-config">
  MathJax.Hub.Config({
    tex2jax: {
      inlineMath: [ ["\\(","\\)"] ],
      processEscapes: true
    }
  });
</script>
<script type="text/javascript" async
  src="https://cdnjs.cloudflare.com/ajax/libs/mathjax/2.7.4/MathJax.js?config=TeX-MML-AM_CHTML" async>
</script>

# Introdução

O primeiro experimento realizado será em um sistema térmico do tipo aquecedor, com uma resistência de potência fixa ligada à rede elétrica. O controle é realizado por um módulo gradador, que corta a onda senoidal e aplica apenas parte dela na carga. Esse experimento tem o objetivo de ajudar o aluno a modelar e simular um sistema térmico, projetar o controlador e finalmente realizar o controle no sistema físico.

# Modelagem

Os sistemas térmicos possuem modelagem simplificada graças à natureza do processo: são geralmente processos lentos, lineares e sem muitas perturbações. Outro ponto importante nesse sistema térmico é que os coeficientes são fáceis de se obter, como calor específico da água e potência do atuador. O primeiro passo é obter a equação básica do processo:

$$Q = c \cdot m \cdot (T_2 - T_1)$$

onde:

$$Q = \text{Quantidade de Energia} \\ 
  c = \text{Calor Específico}\\
  m = \text{Massa} \\
  T_2 = \text{Temperatura Final} \\
  T_1 = \text{Temperatura Inicial}$$

<p>
A equação pode ser reescrita facilmente sabendo que \(Q = P \cdot t\), onde P é a potência do atuador e t o tempo. Também podemos fazer \(\Delta T = T_2 - T_1\) para simplificar os termos:
</p> 

$$P \cdot t = c \cdot m \cdot \Delta T$$

Rearranjando os termos:

$$\frac{\Delta T}{t} = \frac{P}{m \cdot c}$$

O que equivale a dizer:

$$\frac{dT}{dt} = \frac{P}{m \cdot c}$$

Aplicando a transformada de Laplace e resolvendo o sistema:

$$T(s) = \frac{P}{m \cdot c} \cdot \frac{1}{s}$$

Uma das principais preocupações de um aluno de Controle e Automação é que a modelagem não bate com os valores reais, e com razão: a modelagem nunca leva em conta todos os parâmetros do processo. Mas nesse caso, a modelagem está bem próxima dos valores obtidos empiricamente:

$$T(s) = \frac{1000}{2 \cdot 4186} \cdot \frac{1}{s} = \frac{0.12}{s}$$




