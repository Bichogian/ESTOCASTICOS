# Consignas del examen

## Ejercicio 1

Sean $X_i \sim N(\mu_i, \sigma_i^2)$, $i = 1, 2$, donde $X_1 \sim N(-1, 16)$ y $X_2 \sim N(-1, 4)$ dos variables aleatorias con distribucion normal. Usted decide mezclarlas con pesos $0.25$ y $0.75$ respectivamente. De modo que la funcion de densidad (pdf) de la mixtura sera:

$$
f(x) = 0.25 \varphi_1(x) + 0.75 \varphi_2(x)
$$

donde

$$
\varphi_1(x) = \frac{1}{\sqrt{32\pi}} e^{-\frac{(x+1)^2}{32}}
$$

y donde

$$
\varphi_2(x) = \frac{1}{\sqrt{8\pi}} e^{-\frac{(x+1)^2}{8}}
$$

a. Grafique la pdf de la mixtura para valores del soporte de la variable aleatoria entre -15 y 15 con deltas de 0.1.

b. Solamente observando el grafico, puede afirmar si esta mixtura es asimetrica? Explique.

c. Calcule la media, la varianza, el coeficiente de asimetria y el de curtosis de la mixtura. Recuerde que esto requiere calcular varios momentos de la variable aleatoria, que, en definitiva, son integrales.

d. Es la mixtura leptocurtica? Responda en funcion al valor que obtuvo en el inciso anterior y ademas muestre en un grafico la pdf de la mixtura del grafico anterior y la pdf de una normal con la misma media y varianza que la mixtura. En cada una de las colas, cual de estas dos pdf's toma un mayor valor? Muestre los valores de ambas en las colas.

e. Genere 2000 valores aleatorios de esta mixtura y uselos para graficar un QQ-Plot. Muestre que valores uso y el QQ-Plot que obtuvo. Use la semilla 103.

## Ejercicio 2

En el archivo de datos sinteticos `tasas_macro.xlsx` se encuentran, con frecuencia mensual y para el periodo enero de 2004 a diciembre de 2025, dos series financieras simuladas: `spread`, el spread de tasas de interes (diferencia entre la tasa larga y la tasa corta, en %), y `d_short`, el cambio mensual de la tasa de interes de corto plazo (en puntos porcentuales). La variable `mes` identifica el periodo. Usando estos datos, se pide:

a. Grafique conjuntamente ambas series y determine el orden de integracion de cada una mediante el test de Dickey-Fuller aumentado (ADF), seleccionando la cantidad de rezagos con el criterio de Schwarz (BIC). Son estacionarias? Justifique cada paso.

b. Seleccione la cantidad de rezagos del VAR con algun criterio de informacion, estime el VAR resultante y verifique que el sistema sea estable y que sus residuos no presenten autocorrelacion.

c. Analice la causalidad de Granger en ambas direcciones: el spread de tasas ayuda a anticipar el cambio de la tasa corta? y al reves? Plantee el test, reporte el estadistico y su p-value en cada direccion, y concluya. Que lectura economica le daria al resultado en terminos de la informacion de expectativas sobre la tasa de interes?

## Ejercicio 3

Sea

$$
y_t = 1.2y_{t-1} - 0.32y_{t-2} + \varepsilon_t + 0.75\varepsilon_{t-1}
$$

donde $\varepsilon_t$ es un proceso de ruido blanco con $E(\varepsilon_t) = 0$ y $Var(\varepsilon_t) = \sigma_\varepsilon^2 < \infty$.

a. Es este proceso debilmente estacionario? Es invertible? Muestre claramente que cuentas realiza para responder las preguntas.

b. Indique los primeros 5 valores de la funcion impulso-respuesta de esta serie $y_t$.
