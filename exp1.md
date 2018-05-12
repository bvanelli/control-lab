---
permalink: exp1/
title: Experimento 1
title_icon: icon_puzzle_alt
body_color: blue
updated: 2018-05-12
type: exp
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

## Modelagem da Subida

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

E como podemos ver, essa modelagem está muito próxima da resposta real do sistema:

<img src="/control-lab/assets/images/exp1/response.png" style="width: 60%;"/>

## Modelagem da Descida

Não é incomum termos que modelar, além do impacto do degrau no sistema, o impacto do degrau negativo. No entanto, como o sistema é térmico, não é possível aplicar um sinal de controle negativo apenas com a resistência: seria necessário um outro atuador como ventiladores para aumentar a troca térmica do sistema. 

No entanto, podemos considerar o sistema sem atuação e ver como que a temperatura decai com o passar do tempo. Obtemos um modelo empírico desse cenário, já que é difícil modelar as trocas de calor para um objeto tão irregular como uma panela. Por simplicidade, a aproximação também foi feita usando um sistema integrador.

<img src="/control-lab/assets/images/exp1/free_response.png" style="width: 60%;"/>

O que equivale a uma função de transferência:

$$P(s) = -\frac{0.01014}{s}$$

Pode-se observar que o sistema em questão apresenta uma resposta de descida muito mais lenta que a resposta de subida. Isso implica que o controlador projetado não deve possuir overshoot, já que o tempo de resposta da descida é aproximadamente 10 vezes maior que a subida.

## Modelagem do Sensor de Temperatura

TODO

## Modelagem do Atuador

O atuador altera o ângulo de disparo de acordo com a tensão de entrada, mas como a onda é senoidal, a potência entregue na carga não é linear. Isso faz com que tenhamos que modelar o atuador também para melhor aplicar a ação de controle.

<p>A equação que define a tensão de saída de acordo com um ângulo de disparo \( \alpha \) é:</p>

$$V_{o,rms} = V_{rms} \cdot \sqrt{1 - \frac{\alpha}{\pi} + \frac{\sin(2\alpha)}{2\pi}}$$

E a potência entregue à carga é:

$$P = \frac{V_{o,rms}^2}{R} = \frac{V_{rms}^2}{R} \left( 1 - \frac{\alpha}{\pi} + \frac{\sin(2\alpha)}{2\pi} \right)$$

Como estamos assumindo que o valor da entrada U'(t) varia de 0 a 1, podemos então achar a função que define o atuador:

$$U(t) = 1 - U'(t) + \frac{\sin(2 \cdot \pi \cdot U'(t))}{2\pi}$$

Por fim, o gráfico mostra a resposta em potência dado um ângulo de disparo.

<img src="/control-lab/assets/images/exp1/actuator.png" style="width: 60%;"/>
