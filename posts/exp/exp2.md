---
permalink: exp2/
title: Experimento 2
title_icon: fas fa-puzzle-piece
body_color: green
updated: 2018-06-07
type: exp
description: Controle de um sistema térmico baseado em resistência.
---

<div class="callout-block callout-danger">
  <div class="icon-holder">
  <i class="fa fa-exclamation-triangle"></i>
  </div><!--//icon-holder-->
  <div class="content">
  <h4 class="callout-title">Atenção</h4>
  <p>Esse experimento realiza experimentos em um controlador de fase, e por isso lida com alta-tensão. Tome muito cuidado ao montar o circuito e realizando medições para evitar risco de morte.</p>
  </div><!--//content-->
</div><!--//callout-block-->


# Introdução

Esse experimento realiza o controle em malha fechada do sistema modelado no [primeiro experimento](/control-lab/exp1/), utilizando as bibliotecas no Simulink para controle por Matlab em tempo real.

# Problema de controle

Monte o sistema [de acordo com a documentação da planta](/control-lab/planta1/) e projete um controlador proporcional que garanta erro nulo ao degrau para as especificações dadas. Lembre-se de testar o seu modelo na simulação antes de partir para o sistema real.

As especificações são as seguintes:

- A planta deve iniciar em temperatura ambiente.
- O primeiro degrau ocorre em 30 segundos, e a temperatura deve ser elevada até o valor de 40 ºC, onde deve permanecer por 200 segundos. **É importante não apresentar overshoot.**
- No próximo passo, a temperatura é elevada para 60 ºC através de uma rampa de temperatura como inclinação igual à metade do valor nominal máximo (no nosso caso, o modelo do processo é **0.12/s**, então a rampa desejada é **0.06/s**).
- Após a referência atingir 60 ºC, um degrau leva o valor para 80 ºC onde ele permanece por 200 segundos e a simulação é terminada.

# Perguntas

**1)** O controle proporcional foi capaz de satisfazer todas as especificações? Porque?

**2)** Quais os problemas de se utilizar um controlador proporcional? Um controlador PI seria melhor nessa situação?

**3)** Que melhorias poderiam ser feitas no sistema completo para melhorar a resposta?

**Boa sorte!**
