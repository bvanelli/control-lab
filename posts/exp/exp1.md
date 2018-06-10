---
permalink: exp1/
title: Experimento 1
title_icon: fas fa-puzzle-piece
body_color: blue
updated: 2018-06-02
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

Não é incomum termos que modelar, além do impacto do degrau no sistema, o impacto do degrau negativo. No entanto, como o sistema é térmico, não é possível aplicar um sinal de controle negativo apenas com a resistência: seria necessário um outro atuador para melhorar a troca térmica do sistema. 

No entanto, podemos considerar o sistema sem atuação e ver como que a temperatura decai com o passar do tempo. Obtemos um modelo empírico desse cenário, já que é difícil modelar as trocas de calor para um objeto tão irregular como uma panela. Por simplicidade, a aproximação também foi feita usando um sistema integrador.

<img src="/control-lab/assets/images/exp1/free_response.png" style="width: 60%;"/>

O que equivale a uma função de transferência:

$$P(s) = -\frac{0.01014}{s}$$

Pode-se observar que o sistema em questão apresenta uma resposta de descida muito mais lenta que a resposta de subida. Isso implica que o controlador projetado não deve possuir overshoot, já que o tempo de resposta da descida é aproximadamente 10 vezes maior que a subida.

## Modelagem do Sensor de Temperatura

A modelagem do sensor de temperatura foi simplificada para possuir uma dinâmica de primeira ordem. Como o sensor apresentou uma resposta com **t<sub>5%</sub> = 15 s** em alguns testes realizados, a dinâmica foi estimada como a função de transferência a seguir:

$$G_{sensor} = \frac{1}{5s + 1}$$

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

# Modelo Completo

Com base nos modelos obtidos anteriormente, pode-se obter um modelo completo da planta. Foi feito um bloco com o modelo no simulink para testar os possíveis controladores no sistema.

<div class="card" style="width: 100%;">
  <img class="card-img-top" src="/control-lab/assets/images/exp1/simulink-matlab.png" style="width: 95%" alt="Card image cap">
  <div class="card-body" style="margin-bottom: 2rem;">
    <p class="card-text">Baixe o modelo no Simulink para utilizar no MATLAB.</p>
    <a href="https://github.com/bvanelli/control-lab/raw/master/models/modelo1.slx" target="_blank" class="btn btn-primary">Baixar modelo</a>
  </div>
</div>

# Projetando o Controlador

Uma das vantagens de um sistema térmico é que seu controle é simplificado devido tanto à dinâmica mais lenta quanto à menor complexidade. O sistema modelado é um integrador (**1/s**), que não só garante erro nulo em malha fechada para o degrau como pode ser facilmente controlado com a técnica On/Off, onde o atuador é apenas ligado e desligado. Abaixo está o diagrama de blocos para medir a resposta ao degrau do sistema.

<img src="/control-lab/assets/images/exp1/simulink-degrau.png" style="width: 60%;"/>

Utilizando o modelo de Matlab, vamos observar a resposta do sistema em malha aberta ao degrau.

<img src="/control-lab/assets/images/exp1/step.png" style="width: 60%;"/>

O controle pode ser feito como mostra a figura a seguir. Note que é necessário zerar os offsets de temperatura na realimentação porque o sistema deve ser linearizado (ou seja, quando a entrada é zero, a saída é zero, que equivale à temperatura ambiente). Escolheu-se 23 ºC porque é a temperatura média em Blumenau/SC, mas você pode alterar ou mesmo usar o primeiro valor de medição de temperatura como base.

<img src="/control-lab/assets/images/exp1/simulink-controle.png" style="width: 60%;"/>

## Controle On/Off

O controle on/off consiste em aplicar sinal de controle máximo ou mínimo caso a planta esteja abaixo ou acima do setpoint, respectivamente. A Figura a seguir mostra o resultado desse tipo de controle. Note que o sinal é brusco e isso reflete em overshoots na saída, já que o sistema possui atraso.

<img src="/control-lab/assets/images/exp1/onoff.png" style="width: 100%;"/>

## Controle proporcional

O controle proporcional é melhor empregado nessas situações porque possibilita uma ação de controle mais suave, fazendo com que a resposta possua menor erro em relação à referência.

<img src="/control-lab/assets/images/exp1/proporcional.png" style="width: 100%;"/>

# Conclusão

Nesse experimento vimos a modelagem e simulação de um sistema físico real, passo que é muito importate no controle de processos. O próximo experimento consistirá em implementar o controlador para o mesmo sistema utilizando os módulos montados na [documentação da planta térmica 1](/control-lab/planta1).
