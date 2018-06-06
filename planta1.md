---
permalink: planta1/
title: Planta Térmica 1
title_icon: fa fa-thermometer-half
body_color: red
type: doc
updated: 2018-05-29
description: Documentação da planta tipo caldeira acionada por resistência.
---

<div class="callout-block callout-danger">
  <div class="icon-holder">
  <i class="fa fa-exclamation-triangle"></i>
  </div><!--//icon-holder-->
  <div class="content">
  <h4 class="callout-title">Atenção</h4>
  <p>Esse experimento realiza a construção de um controlador de fase, e por isso lida com alta-tensão. Tome muito cuidado ao construir o circuito e realizando medições para evitar risco de morte.</p>
  </div><!--//content-->
</div><!--//callout-block-->

# Introdução

O objetivo é criar uma planta térmica controlada utilizando uma resistência e um sistema de medição.

<img src="/control-lab/assets/images/planta1/planta.png" style="width: 50%;"/>

Para realizar o controle da planta térmica desse experimento, vamos construir um controlador de fase para acionar e controlar uma resistência. Um controlador de fase é um circuito que varia o ângulo de disparo em uma onda senoidal de forma a aplicar apenas parte da tensão da rede na carga. Com isso, pode-se variar a tensão RMS na carga.

![](/control-lab/assets/images/planta1/angle.gif)

# Projeto do controlador

## Descrição do TCA 785

Para isso, vamos utilizar um controlador pronto de fase chamado TCA 785. O jeito como o TCA 785 funciona é criando uma rampa utilizando o capacitor C<sub>10</sub> e o resistor R<sub>9</sub>. Essa rampa então é comparada com o valor de referência V<sub>11</sub> e quando os valores são iguais um pulso é enviado para acionar o triac. Assim, variando a tensão de referência, pode-se alterar o ângulo de disparo.

<div class="row">
<div class="col-sm-3"><img src="/control-lab/assets/images/planta1/tca785.png" /></div>
<div class="col-sm-6"><img src="/control-lab/assets/images/planta1/tca-intern.png" /></div>
</div>

Embora o circuito integrado tenha 16 entradas e saídas (DIP16), apenas algumas são necessárias. São elas:

- **GND**: ground comum do circuito.
- **V<sub>SYNC</sub>**: sinal senoidal para sincronização com a frequência e fase da rede.
- **I**: entrada que ativa o circuito integrado.
- **V<sub>S</sub>**: tensão de alimentação de 8V a 18V.
- **Q<sub>1</sub> e Q<sub>2</sub>**: pulsos de saída para comando do triac.
- **L**: habilita pulso de acionamento longo.
- **C<sub>12</sub>**: define largura do pulso de acionamento longo.
- **V<sub>11</sub>**: tensão de referência.
- **C<sub>10</sub>**: capacitor de rampa.
- **R<sub>9</sub>**: resistor de rampa.

## Retificador para alimentação

Para evitar ter que adicionar uma fonte extra de alimentação, e assim evitar eventuais problemas de curto circuito (acredite, eles vão acontecer), iremos utilizar a própria entrada da rede para alimentar o TCA 785. Para tal, basta construir um retificador de meia onda com diodo zener regulador de tensão e capacitor para filtro.

<img src="/control-lab/assets/images/planta1/retificador.png" style="width: 60%;"/>

## Entrada para Arduino

O Arduino deve gerar um sinal de tensão de referência para o CI, e também deve ser isolado galvanicamente do outro circuito. Para isso, utilizamos um optoacoplador 4N35. Como o sinal de saída ainda é um sinal PWM, também foi adicionado um filtro RC para obter a componente DC do sinal.

<img src="/control-lab/assets/images/planta1/ref.png" style="width: 90%;"/>

## Circuito Completo

O circuito completo foi montado se baseando então no circuito de exemplo presente [no datasheet](http://www.farnell.com/datasheets/1836360.pdf) do TCA 785.

<div class="card bg-light mb-3" style="width: 100%;">
  <img class="card-img-top" src="/control-lab/assets/images/planta1/completo.png" style="width: 95%" alt="Card image cap">
  <div class="card-body" style="margin-bottom: 2rem;">
    <p class="card-text">Baixe os arquivos do projeto no Eagle (esquemáticos e PCB).</p>
    <a href="https://github.com/bvanelli/control-lab/tree/master/schematics/phase-control" target="_blank" class="btn btn-primary">Baixar projeto</a>
  </div>
</div>

## Design da PCB

O design da PCB foi feito para auxiliar a soldagem dos componentes na placa ilhada 15x15. Caso você pretenda personalizar sua PCB, baixe o projeto no Eagle e altere livremente.

<img src="/control-lab/assets/images/planta1/pcb.png" style="width: 90%;"/>

Note que a PCB da figura apresenta 3 camadas. A azul, que deve ser soldada normalmente por baixo da placa, e as trilhas vermelhas e verde, que são jumpers que ligam um ponto ao outro.

## Lista de componentes (BOM)

Abaixo selecionamos uma lista de componentes utilizada no nosso projeto, bem como um link para compra para referência visual.

<!--Retificador -->
- [Resistor 4.7k 10W.](http://proesi.com.br/resistor-de-fio-10w-4k7.html)
- [Capacitor 470u.](http://proesi.com.br/capacitor-eletrolitico-470uf-35v-105.html)
- [Capacitor 470n.](http://proesi.com.br/capacitor-multicamada-470n-50v.html)
- [Zener 15V 5W.](http://proesi.com.br/diodo-zener-5w-1n5352-15v.html)
- [5 Diodos 1N4004.](http://proesi.com.br/1n4004-diodo.html)
- [2 Porta fusíveis](http://proesi.com.br/porta-fusivel-para-placa-as-06-5x20-905.html)
- [Fusível AG20 10A](http://proesi.com.br/fusivel-de-vidro-ag20-5x20-10a.html)
- [Fusível AG20 0.1A](http://proesi.com.br/fusivel-de-vidro-ag20-5x20-0-1a.html)
<!--Filtro Arduino -->
- [Optoacoplador 4N35.](http://proesi.com.br/4n35-acoplador-optico.html)
- [Soquete 6 pinos.](http://proesi.com.br/soquete-estampado-6-pinos.html)
- [Resistor 560R](http://proesi.com.br/resistor-carbono-cr25-1-4w-560r.html)
- [2 Resistores 10k](http://proesi.com.br/catalog/product/view/id/6127/s/resistor-precisao-1-1-4w-10k/)
- [Resistor 33k](http://proesi.com.br/resistor-carbono-cr25-1-4w-33k.html)
- [Capacitor 1u](http://proesi.com.br/capacitor-eletrolitico-1uf-50v-105.html)
- [3 Bornes KRE 2T](http://proesi.com.br/catalog/product/view/id/5722/s/borne-kre-2t-azul-perfil-baixo-espacamento-5-08mm/)
<!--TCA785 -->
- [TCA 785.](http://proesi.com.br/tca785-circuito-integrado.html)
- [Soquete 16 pinos.](http://proesi.com.br/soquete-estampado-16-pinos.html)
- [Resistor 220k 1W](http://proesi.com.br/resistor-carbono-1w-220k.html)
- [Resistor 22k](http://proesi.com.br/catalog/product/view/id/6130/s/resistor-precisao-1-1-4w-22k/)
- [Trimpot 200k](http://proesi.com.br/trimpot-3296-w-204-25-voltas-200k.html)
- [Capacitor 27n](http://proesi.com.br/capacitor-poliester-27nf-27k-63v-0-027-63v.html)
- [Capacitor 1n](http://proesi.com.br/capacitor-poliester-1nf-1k-63v-0-001-63v.html)
<!-- Acionamento -->
- [Resistor 220R](http://proesi.com.br/catalog/product/view/id/6119/s/resistor-precisao-1-1-4w-220r/)
- [Triac BTA16](http://proesi.com.br/bta16-600-tic246-triac-16a-600v.html)

## Circuito final

O circuito final pode ser observado nas figuras a seguir.

<img src="/control-lab/assets/images/planta1/circuito-cima.jpg" style="width: 50%;"/>
<img src="/control-lab/assets/images/planta1/circuito-baixo.jpg" style="width: 50%;"/>

# Medição de temperatura

Para medir a temperatura, vamos utilizar um sensor de temperatura já à prova d'água chamado [DS18b20](http://proesi.com.br/catalog/product/view/id/7183/s/sensor-de-temperatura-a-prova-d-agua-ds18b20/).

<img src="/control-lab/assets/images/planta1/sensor.jpg" style="width: 50%;"/>

De acordo com [o datasheet](https://datasheets.maximintegrated.com/en/ds/DS18B20.pdf), é necessário apenas um pullup para ligar o sensor, que é feito com um resistor qualquer (10k&Omega;, por exemplo) entre o pino de entrada e o 5V do Arduino. A figura a seguir mostra como conectar o sensor. Note que a cor dos fios do diagrama é igual ao do sensor com case.

<img src="/control-lab/assets/images/planta1/ds18b20.png" style="width: 50%;"/>
