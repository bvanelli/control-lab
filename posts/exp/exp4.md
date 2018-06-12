---
permalink: exp4/
title: Experimento 4
title_icon: fas fa-puzzle-piece
body_color: orange
updated: 2018-06-07
type: exp
description: Controle de um sistema térmico baseado em peltier.
---

{% include tex.html %}

# Introdução

Esse experimento realiza o controle em malha fechada do sistema modelado no [terceiro experimento](/control-lab/exp3/), utilizando as bibliotecas no Simulink para controle por Matlab em tempo real.

# Problema de controle

Monte o sistema [de acordo com a documentação da planta](/control-lab/planta2/) e projete um controlador partindo do modelo de segunda ordem da planta. Ele poderá ser feito por qualquer método de controle visto em aula, mas é preferível alocação de polos. A planta aproximada é:

$$G = \frac{-0.011224 \cdot (s+0.004795)}{(s^2 + 0.01121s + 6.293 \cdot 10^{-5})}$$

Vamos te poupar alguns cliques!

```python
G = tf([-0.01122 -5.381e-05], [1 0.01121 6.293e-05]);
```

As especificações são as seguintes:

- A planta deve iniciar em temperatura ambiente.
- O overshoot máximo é de **5%**.
- Erro nulo para referência degrau.
- Tempo de assentamento menor ou igual à metade da malha aberta (**~250 s**).

# Perguntas

**1)** Qual a ordem mínima para satisfazer o problema de controle? É possível solucionar com apenas um controlador PI?

**2)** Devido às características de malha aberta, aparece um zero dominante na resposta em malha fechada. Verifique a necessidade de adição de um filtro de referência. É possível melhorar a reposta?

**3)** Porque não é possível satisfazer as condições de overshoot dadas nas especificações para a planta nominal? 

**Boa sorte!**
