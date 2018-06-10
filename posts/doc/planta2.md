---
permalink: planta2/
title: Planta Térmica 2
title_icon: far fa-snowflake
body_color: blue
type: doc
updated: 2018-05-29
description: Documentação da planta refrigeradora acionada por peltier.
---

# Introdução

O objetivo desse experimento é criar uma planta refrigeradora acionada por peltier. O esquemático da planta a ser criada pode ser vista na figura a seguir.

<img src="/control-lab/assets/images/planta2/planta.png" style="width: 50%;"/>

A placa peltier é um dispositivo muito interessante que é capaz de criar um diferencial de temperatura quando submetida à um diferencial de tensão na entrada. Ela é composta da junção de dois semicondutores, um que retira calor e um que dissipa calor. Sendo assim, a placa pode ser utilizada tanto para aquecer quanto para esfriar, bastando inverter a direção. Como é muito mais fácil aquecer com resistências, a placa peltier possui muito uso retirando calor, sendo utilizada em minicoolers, bebedouros de pequeno porte, etc.

![peltier](/control-lab/assets/images/planta2/peltier.svg)

Infelizmente, devido ao funcionamento, essa placa não aceita entrada PWM para controlar a corrente que passa por ela. Sendo assim, para controlar a potência da placa é necessário um circuito de acionamento que fornece uma tensão DC para a carga.

# Projeto do Controlador

## Entrada para o Arduino

Assim como o experimento da [planta térmica 1](/control-lab/planta1), essa também utilizará um filtro com optoacoplador para retificar a componente DC do sinal PWM do Arduino.

<img src="/control-lab/assets/images/planta2/ref.png" style="width: 80%;"/>

## Controlando a tensão

Para controlar a tensão, vamos utilizar um transistor NPN e um amplificador operacional em uma configuração engenhosa. Como a tensão nas portas inversoras e não-inversoras do AMPOP são em teoria iguais, utilizamos o sinal de referência em uma das portas e a tensão em cima da carga em outra. Assim, o AMPOP irá alterar a tensão de saída, na base do transistor, para tentar igualar as duas!

O circuito final pode ser observado a seguir.

<div class="card bg-light mb-3" style="width: 100%;">
  <img class="card-img-top" src="/control-lab/assets/images/planta2/completo.png" style="width: 95%" alt="Card image cap">
  <div class="card-body" style="margin-bottom: 2rem;">
    <p class="card-text">Baixe os arquivos do projeto no Eagle (esquemáticos e PCB).</p>
    <a href="https://github.com/bvanelli/control-lab/tree/master/schematics/voltage-control" target="_blank" class="btn btn-primary">Baixar projeto</a>
  </div>
</div>

## Design da PCB

O design da PCB foi feito para auxiliar a soldagem dos componentes na placa ilhada 15x15. Caso você pretenda personalizar sua PCB, baixe o projeto no Eagle e altere livremente.

<img src="/control-lab/assets/images/planta2/pcb.png" style="width: 60%;"/>

Para realizar as trilhas de topo, em vermelho, utilize jumpers de um ponto ao outro ou faça a PCB em duas camadas.

## Lista de componentes (BOM)

Abaixo selecionamos uma lista de componentes utilizada no nosso projeto, bem como um link para compra para referência visual.

- [Ampop TL072](http://proesi.com.br/tl072-circuito-integrado-dip-8.html)
- [Optoacoplador 4N35.](http://proesi.com.br/4n35-acoplador-optico.html)
- [Transistor TIP41C](http://proesi.com.br/tip41-c-transistor.html)
- [3 Bornes KRE 2T](http://proesi.com.br/catalog/product/view/id/5722/s/borne-kre-2t-azul-perfil-baixo-espacamento-5-08mm/)
- [Resistor 560R](http://proesi.com.br/resistor-carbono-cr25-1-4w-560r.html)
- [Resistor 1k](http://proesi.com.br/catalog/product/view/id/5958/s/resistor-precis-o-1-1-4w-1k/)
- [Resistor 100k](http://proesi.com.br/catalog/product/view/id/6133/s/resistor-precisao-1-1-4w-100k/)
- [Capacitor 1u](http://proesi.com.br/capacitor-eletrolitico-1uf-50v-105.html)

# Circuito Final

As fotos do circuito final podem ser observados na figura a seguir. Note que esse circuito não respeita exatamente os esquemáticos e organização da placa projetados aqui (infelizmente) porque foi projetada para um outro projeto, mas possui o mesmo funcionamento.

<img src="/control-lab/assets/images/planta2/circuito-cima.jpg" style="width: 50%;"/>
<img src="/control-lab/assets/images/planta2/circuito-baixo.jpg" style="width: 50%;"/>

# Medição de temperatura

Para medir a temperatura, vamos utilizar um sensor de temperatura já à prova d'água chamado [DS18b20](http://proesi.com.br/catalog/product/view/id/7183/s/sensor-de-temperatura-a-prova-d-agua-ds18b20/).

<img src="/control-lab/assets/images/planta2/sensor.jpg" style="width: 50%;"/>

De acordo com o datasheet, é necessário apenas um pullup para ligar o sensor, que é feito com um resistor qualquer (10k&Omega;, por exemplo) entre o pino de entrada e o 5V do Arduino. A figura a seguir mostra como conectar o sensor. Note que a cor dos fios do diagrama é igual ao do sensor com case.

<img src="/control-lab/assets/images/planta2/ds18b20.png" style="width: 50%;"/>

# Peças de fixação da peltier

TODO: Peças de projeto do Rômulo

# Montagem do Sistema

A peltier foi fixada entre os dissipadores de calor utilizando as peças impressas na impressora 3D. Foi cortado um quadrado em uma caixa de isopor para garantir o isolamento térmico do lado frio da peltier. Um cooler 40X40X10 mm foi fixado para melhorar a troca térmica no lado quente.

<img src="/control-lab/assets/images/planta2/geladeira.jpg" style="width: 50%;"/>

O sensor foi fixado diretamente no dissipador. Porque iremos controlar a tensão em cima do dissipador e não no ambiente interno do isopor? Porque o tempo de assentamento do sistema interno é muito alto e não poderia ser realizado em tempo hábil. Além disso, a malha interna apresenta uma dinâmica muito mais interessante do ponto de vista de controle.

<img src="/control-lab/assets/images/planta2/sensor-final.jpg" style="width: 50%;"/>


