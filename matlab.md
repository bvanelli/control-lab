---
permalink: matlab/
title: Biblioteca Matlab
title_icon: fas fa-terminal
body_color: orange
type: doc
updated: 2018-06-02
description: Documentação das bibliotecas do MATLAB.
---

# Introdução

Esse artigo é uma pequena introdução de como conectar o Arduino e o MATLAB para poder utilizar a praticidade do Arduino junto com a capacidade computacional do MATLAB em tempo real.

Em primeiro lugar, é necessário dizer que boa parte dessa interface é baseada no [já existente suporte do MATLAB para Arduino desenvolvido pela Mathworks](https://www.mathworks.com/hardware-support/arduino-matlab.html). O código do MATLAB em si é baseado no existente interpretador de comandos [Firmata](https://github.com/firmata/arduino). Caso você esteja procurando uma implementação de uma biblioteca equivalente para Octave, a alternativa open-source do Matlab, procure o projeto [Molorius/Arduino-Octave](https://github.com/Molorius/Arduino-Octave).

A figura a seguir ilustra o funcionamento da biblioteca Firmata.

![firmata](/control-lab/assets/images/matlab/firmata.svg)

# Biblioteca MATLAB

Se você já possui algum conhecimento em Arduino, achará fácil se adequar à sintaxe do MATLAB, que é equivalente. Aqui descreveremos apenas alguns comandos básicos que serão utilidos nos experimentos. Para referência completa, acesse [a documentação própria disponibilizada pela Mathworks](https://www.mathworks.com/help/supportpkg/arduinoio/functionlist.html).

## Iniciando Conexão

Para iniciar conexão, basta chamar o construtor, e opcionalmente a porta, modelo da placa e bibliotecas auxiliares.

{% highlight python %}
a = arduino;
a = arduino('COM9', 'UNO');
a = arduino('COM9', 'UNO', 'Libraries', 'PaulStoffregen/OneWire');
{% endhighlight %}

## Lendo valores digitais

Basta chamar a função `readDigitalPin` em qualquer uma das formas abaixo. O valor de retorno `var` será 0 ou 1 para os equivalentes **LOW** ou **HIGH** de tensão.

{% highlight python %}
val = readDigitalPin(a, 'D13');
val = a.readDigitalPin('D13');
{% endhighlight %}

## Escrevendo valores digitais

Basta chamar a função `writeDigitalPin` em qualquer uma das formas abaixo, fornecendo 0 ou 1 para os valores **LOW** ou **HIGH** de tensão.

{% highlight python %}
writeDigitalPin(a, 'D13', 1);
a.writeDigitalPin('D13', 1);
{% endhighlight %}

## Lendo valores analógicos

Para ler valores analógicos, basta chamar a função `readVoltage` com uma das portas analógicas. O retorno é um valor `val` que varia entre 0 e a tensão de operação da placa, geralmente 5 V.

{% highlight python %}
val = readVoltage(a, 'A0');
val = a.readVoltage('A0');
{% endhighlight %}

## Escrevendo valores PWM

Há duas funções que fazer a escrita dos valores PWM, a `writePWMVoltage`, que varia entre 0 e a tensão da placa (5 V), e `writePWMDutyCycle`, que varia entre 0 e 1. As seguintes chamadas são equivalentes.

{% highlight python %}
writePWMVoltage(a, 'D9', 2.5);
a.writePWMVoltage('A0', 2.5);
writePWMDutyCycle(a, 'D9', 0.5);
a.writePWMDutyCycle('D9', 0.5);
{% endhighlight %}

# Biblioteca do control-lab

Para simplificar as coisas, utilizamos uma versão modificada baseada na do Arduino. Ela já foi pensada para incluir o sensor de temperatura. Para instanciar a classe, é necessário chamar o seu construtor que deriva da classe principal do Arduino.

{% highlight python %}
# parâmetros: control_arduino(porta, placa, portaPWM, portaSensor, sample_rate)
a = control_arduino('COM9', 'UNO', 'D9', 'A0', 1);
{% endhighlight %}

Se tudo correr bem, você já poderá ler a temperatura do sensor:

{% highlight python %}
t = a.getOneWireTemperature();
{% endhighlight %}

Para escrever na porta, substituímos a função `writePWMVoltage` e `writePWMDutyCycle` para escreverem o valor inverso. Isso é necessário porque ambas os atuadores das duas plantas são inversores (sinal de saída máximo com entrada mínima e vice-versa).

{% highlight python %}
a.writePWMDutyCycle(1); # escreve valor mínimo de duty cycle na porta especificada na inicalização
a.writePWMDutyCycle(0); # escreve valor máximo de duty cycle na porta especificada na inicalização
{% endhighlight %}

Também foi escrito uma toolbox para realizar as mesmas ações no simulink, com o objetivo de ler valor de temperatura e escrever valor de PWM. Abaixo estão os 3 blocos funcionais para isso:

<img src="/control-lab/assets/images/matlab/blocos.png" style="width: 100%;"/>

# Portas Disponíveis

As seguintes portas estão disponíveis para o Arduino UNO.

| Tipo          | Portas                            |
|---------------|-----------------------------------|
| Digital       | `'D0'` a `'D13'`                  |
| Analógica     | `'A0'` a `'A5'`                   |
| PWM (1000 Hz) |  `'D5'` e `'D6'`                  |
| PWM (500 Hz)  | `'D3'`, `'D9'`, `'D10'` e `'D11'` |

# Exemplos

## Blink

Para reproduzir o código de *blink* no Matlab-Arduino, basta executar o seguinte script com um Arduino UNO conectado pela USB. Se tudo estiver instalado corretamente, o LED na porta 13 do Arduino deve piscar cada 1 segundo.

{% highlight python %}
a = arduino;

while true
    a.writeDigitalPin('D13', 1);
    pause(1);    
    a.writeDigitalPin('D13', 0);
    pause(1);
end
{% endhighlight %}
