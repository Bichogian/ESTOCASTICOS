# Resumen teoria - Modelado Estocastico hasta Clase 8

Este apunte es el resumen teorico central del curso. La idea no es repetir cada
notebook, sino dejar claro que significa cada concepto, como se interpreta, que
supuestos hay detras y que errores conviene evitar al resolver ejercicios o leer
salidas de Python.

Las guias de `Resumenes/Teoria_y_Practica/` bajan estos conceptos a codigo,
salidas numericas y practicas. Este archivo funciona como el mapa teorico de
fondo.

## Mapa general de clases

| Etapa | Material teorico | Codigo / practica | Temas principales |
|---|---|---|---|
| Intro | Sin PDF especifico | `Clase_00_Intro_practica` | Python, pandas, graficos, lectura de archivos y simulacion |
| Clase 1 | `MIA103_Clase_1.pdf` | `Clase_01_01`, `Clase_01_02_Mixtura`, Ejer 1 | Retornos, momentos, normalidad, Jarque-Bera y mixturas |
| Clase 2 | `MIA103_Clase_2.pdf` | `Clase_02_*`, Ejer 2 | PBI, crecimiento, logs, tendencia, ciclo, media movil y HP |
| Clase 3 | `MIA103_Clase_3.pdf` | `Clase_03*`, Ejer 3 | Regresion simple, MCO, supuestos, inferencia, CAPM |
| Clases 4 y 5 | `MIA103_Clase_4.pdf` | `Clase_04_*`, Ejer 4 | Regresion multiple, dummies, interacciones, matrices, multicolinealidad y heterocedasticidad |
| Clase 6 | `MIA103_Clase_6.pdf` | `Clase_06_ARMA`, Ejer 5 | Ruido blanco, AR, MA, ARMA, ACF y PACF |
| Clase 7 | `MIA103_Clase_7_.pdf` | `Clase_07_ADF_DFGLS`, Ejer 7 | Estacionariedad, raices unitarias, ADF, DFGLS, integracion |
| Clase 8 | `MIA103_Clase_8_VAR_.pdf` | Sin notebook VAR especifico | VAR, estabilidad, autovalores, Granger y puente a cointegracion |

## Como estudiar este apunte

Una forma eficiente de leer el material es:

```text
definicion -> formula -> intuicion -> interpretacion -> supuesto -> alerta
```

En econometria, muchas equivocaciones no vienen de no saber calcular, sino de
interpretar mal que se calculo. Por eso, para cada tema conviene poder responder:

1. Que objeto teorico estoy mirando.
2. Que representa economicamente o estadisticamente.
3. Que supuesto necesito para usarlo como inferencia valida.
4. Que significa rechazar o no rechazar una hipotesis.
5. Que no puedo concluir aunque el resultado parezca fuerte.

---

# Clase 1 - Retornos, distribuciones y momentos

## 1. Precios y retornos

Un precio `P_t` es un nivel. Por si solo, el precio no dice cuanto gano o perdio
un activo entre dos fechas. Para medir variaciones relativas usamos retornos.

El retorno simple neto es:

```text
R_t = (P_t - P_{t-1}) / P_{t-1}
    = P_t / P_{t-1} - 1
```

El retorno bruto simple es:

```text
1 + R_t = P_t / P_{t-1}
```

Si `R_t = 0.03`, el activo subio 3%. Si `R_t = -0.03`, bajo 3%.

El retorno logaritmico es:

```text
r_t = ln(P_t / P_{t-1})
    = ln(P_t) - ln(P_{t-1})
    = Delta ln(P_t)
```

La relacion entre ambos es:

```text
r_t = ln(1 + R_t)
R_t = exp(r_t) - 1
```

Para retornos chicos:

```text
ln(1 + R_t) ~= R_t
```

## 2. Como interpretar retorno simple y logaritmico

El retorno simple es la medida mas directa de ganancia en plata. Si invierto 100
y termino con 110, gane 10%.

El retorno logaritmico es especialmente util para series temporales porque suma
en el tiempo:

```text
r_1 + r_2 + ... + r_T = ln(P_T / P_0)
```

En cambio, los retornos simples se acumulan multiplicando:

```text
1 + R_acum = (1 + R_1)(1 + R_2)...(1 + R_T)
```

Lectura importante:

- Para variaciones diarias chicas, simple y logaritmico son casi iguales.
- Para variaciones grandes, la diferencia importa.
- Los log-retornos castigan mas las caidas que las subas simetricas en retorno
  simple.
- En modelos y series financieras suele preferirse el log-retorno por su
  aditividad.
- Para comunicar performance economica directa, el retorno simple es mas
  intuitivo.

Ejemplo conceptual:

```text
Suba simple de 25%:     ln(1.25) =  0.2231
Caida simple de 25%:    ln(0.75) = -0.2877
```

La caida pesa mas en logaritmos porque perder 25% requiere una suba posterior de
33.33% para volver al punto inicial.

## 3. Distribuciones y momentos

Una distribucion describe como se reparten los posibles valores de una variable.
En este curso aparece mucho la pregunta: "los datos se parecen a una normal?"

La normal es importante porque:

- es simetrica;
- queda caracterizada por media y varianza;
- aparece como aproximacion en muchos resultados asintoticos;
- permite inferencia exacta en algunos modelos bajo supuestos fuertes.

Pero muchas series financieras no son normales: suelen tener colas mas pesadas,
asimetria y eventos extremos mas frecuentes.

Los momentos resumen caracteristicas de la distribucion:

| Momento | Pregunta que responde | Interpretacion |
|---|---|---|
| Media | Donde esta el centro? | Retorno promedio o nivel esperado |
| Varianza | Cuanto se dispersa? | Riesgo cuadratico alrededor de la media |
| Desvio estandar | Cuanto se aleja en unidad original? | Volatilidad |
| Asimetria | Que cola pesa mas? | Riesgo inclinado a subas o caidas extremas |
| Curtosis | Que tan pesadas son las colas? | Frecuencia relativa de valores extremos |

La media no alcanza para hablar de riesgo. Dos activos pueden tener igual media y
volatilidades completamente distintas. El desvio tampoco alcanza si las colas son
muy pesadas.

## 4. Asimetria y curtosis

La asimetria mide si la distribucion esta balanceada alrededor de su centro.

```text
Asimetria = 0      distribucion simetrica
Asimetria > 0      cola derecha mas marcada
Asimetria < 0      cola izquierda mas marcada
```

En finanzas, una asimetria negativa suele ser preocupante porque indica que hay
perdidas extremas relativamente mas importantes.

La curtosis total de una normal es 3. El exceso de curtosis se define como:

```text
Exceso de curtosis = curtosis total - 3
```

Entonces:

```text
Normal: exceso de curtosis = 0
```

Si una serie tiene exceso de curtosis positivo, tiene colas mas pesadas que la
normal. Eso significa que valores extremos aparecen con mas frecuencia de la que
predeciria una normal con la misma media y varianza.

## 5. Estandarizacion y QQ plot

Estandarizar una variable significa restarle la media y dividir por el desvio:

```text
Z = (X - media) / desvio
```

Despues de estandarizar, cada observacion se lee como cantidad de desvios
estandar respecto de la media. Si `Z = -2`, la observacion esta dos desvios por
debajo del promedio.

El QQ plot compara cuantiles observados contra cuantiles teoricos de una
distribucion, generalmente la normal.

Como leerlo:

- Si los puntos siguen aproximadamente la recta, la normal puede ser una
  aproximacion razonable.
- Si los puntos se alejan en las puntas, hay problemas en las colas.
- Si se curvan de forma sistematica, puede haber asimetria o diferencia de
  curtosis.

El QQ plot es visual. Ayuda a diagnosticar, pero no reemplaza un test formal.

## 6. Jarque-Bera

Jarque-Bera testea normalidad usando asimetria y curtosis.

```text
H0: la distribucion es compatible con normalidad
HA: la distribucion no es compatible con normalidad
```

El estadistico es:

```text
JB = n/6 * [S^2 + (K - 3)^2/4]
```

donde `S` es la asimetria y `K` la curtosis total.

Interpretacion del p-value:

- Si `p-value < alpha`, rechazamos normalidad.
- Si `p-value >= alpha`, no rechazamos normalidad.
- No rechazar no prueba que la serie sea normal.
- Rechazar no dice automaticamente si el problema viene de asimetria, curtosis o
  ambas; hay que mirar los momentos.

Error comun: decir "el p-value es la probabilidad de que H0 sea verdadera". No.
El p-value mide que tan raro seria observar un estadistico tan extremo si H0
fuera cierta.

## 7. Mixturas de normales

Una mixtura combina distribuciones con pesos que suman uno. Por ejemplo:

```text
X ~ 0.75 N(0,1) + 0.25 N(-1.5,4)
```

Esto significa:

- con probabilidad 0.75 la observacion viene de la primera normal;
- con probabilidad 0.25 viene de la segunda normal.

No significa sumar dos variables normales. La densidad de la mixtura es:

```text
f_mix(x) = 0.75 f_1(x) + 0.25 f_2(x)
```

Las mixturas son utiles porque muestran que una distribucion puede parecer
"normal por partes" y aun asi tener colas pesadas, asimetria o varios grupos.

Interpretacion importante: una mixtura puede representar cambios de regimen. En
finanzas, por ejemplo, dias tranquilos y dias turbulentos pueden venir de
distribuciones distintas.

---

# Clase 2 - PBI, crecimiento, logs, tendencia y ciclo

## 1. PBI nominal y PBI real

El PBI mide el valor de los bienes y servicios finales producidos en una economia
durante un periodo.

El PBI nominal usa precios corrientes:

```text
PBI nominal_t = suma_i P_{i,t} Q_{i,t}
```

Puede aumentar porque:

- se produce mas;
- suben los precios;
- ocurren ambas cosas.

El PBI real usa precios de un periodo base:

```text
PBI real_t = suma_i P_{i,0} Q_{i,t}
```

La idea es mantener precios fijos para medir cantidades. Por eso, cuando
hablamos de crecimiento economico, usamos PBI real.

## 2. Crecimiento simple, acumulado y promedio

El crecimiento simple entre dos periodos es:

```text
g_t = PBI_t / PBI_{t-1} - 1
```

El crecimiento acumulado entre un inicio y un final es:

```text
1 + g_acum = PBI_final / PBI_inicial
```

Si queremos una tasa constante equivalente por periodo:

```text
1 + g_prom = (PBI_final / PBI_inicial)^(1/n)
```

o:

```text
g_prom = (PBI_final / PBI_inicial)^(1/n) - 1
```

La tasa logaritmica promedio es:

```text
g_log = [ln(PBI_final) - ln(PBI_inicial)] / n
```

Para tasas chicas:

```text
g_log ~= g_prom
```

Alerta clave: crecimiento acumulado y crecimiento promedio anual no son lo
mismo. Si el PBI se multiplica por 2 en 20 anos, el acumulado es 100%, pero la
tasa anual equivalente es mucho menor.

## 3. Por que usar logaritmos

Aplicar logaritmos convierte cocientes en diferencias:

```text
ln(PBI_t / PBI_{t-1}) = ln(PBI_t) - ln(PBI_{t-1})
```

Esto facilita la lectura de crecimiento. En un grafico de `ln(PBI)`, una
pendiente aproximadamente constante se interpreta como una tasa de crecimiento
aproximadamente constante.

Como mirar un grafico en logs:

- Una recta ascendente sugiere crecimiento porcentual estable.
- Una pendiente mas empinada sugiere mayor crecimiento porcentual.
- Una curva que se aplana sugiere desaceleracion.
- Desvios respecto de la tendencia sugieren ciclos.

El logaritmo comprime niveles altos y permite comparar cambios proporcionales.

## 4. Tendencia y ciclo

La clase propone descomponer:

```text
y_t = y_t^g + y_t^c
```

donde:

- `y_t` es el logaritmo del PBI observado;
- `y_t^g` es la tendencia;
- `y_t^c` es el ciclo.

Entonces:

```text
y_t^c = y_t - y_t^g
```

Si `y_t^c > 0`, la economia esta por encima de la tendencia estimada. Si
`y_t^c < 0`, esta por debajo.

Interpretacion delicada: el ciclo no se observa directamente. Depende de como se
estime la tendencia. No existe "el" ciclo unico sin elegir antes un metodo.

## 5. Tendencia deterministica

Una forma simple de tendencia es:

```text
y_t = alpha + beta t + u_t
```

Si `y_t` esta en logs, `beta` se interpreta aproximadamente como tasa de
crecimiento tendencial.

La tendencia estimada es:

```text
y_t^g = alphahat + betahat t
```

El ciclo es:

```text
y_t^c = y_t - y_t^g
```

Ventaja: es simple y facil de interpretar.

Limite: impone una tendencia lineal en logs, es decir, una tasa de crecimiento de
largo plazo constante. Puede ser demasiado rigida para economias con cambios de
regimen.

## 6. Media movil centrada

Una media movil centrada suaviza la serie usando observaciones cercanas. Con una
ventana de `2n+1`:

```text
y_t^g = promedio(y_{t-n}, ..., y_t, ..., y_{t+n})
```

Si la ventana es de 11 anos, usa 5 anos antes, el actual y 5 despues.

Como interpretarla:

- La tendencia queda mas suave que la serie original.
- Una ventana mas grande suaviza mas, pero puede borrar fluctuaciones relevantes.
- Se pierden observaciones al principio y al final porque falta informacion para
  centrar la ventana.

La media movil es intuitiva, pero no surge de un modelo economico profundo: es un
filtro estadistico.

## 7. Filtro Hodrick-Prescott

El filtro HP elige una tendencia que resuelve un balance:

```text
min suma_t (y_t - y_t^g)^2
    + lambda * suma_t [(y_{t+1}^g - y_t^g) - (y_t^g - y_{t-1}^g)]^2
```

La primera parte quiere que la tendencia este cerca de la serie. La segunda
parte penaliza cambios bruscos en la pendiente de la tendencia.

El parametro `lambda` controla suavidad:

- `lambda` chico: tendencia mas pegada a los datos.
- `lambda` grande: tendencia mas suave.

Interpretacion: HP no descubre una verdad oculta; construye una tendencia bajo
un criterio de suavidad. Por eso, al usarlo, siempre hay que mencionar el
`lambda`.

## 8. Como pensar tendencia y ciclo en examenes

Cuando aparezca una serie macro:

1. Preguntar si esta en nivel o en log.
2. Si se habla de crecimiento, mirar diferencias logaritmicas o tasas.
3. Si se habla de ciclo, identificar el metodo usado para sacar tendencia.
4. Interpretar el ciclo como brecha respecto de esa tendencia, no como recesion
   automaticamente.
5. Recordar que distintos filtros pueden dar ciclos distintos.

---

# Clase 3 - Regresion lineal simple

## 1. Modelo poblacional

El modelo de regresion lineal simple es:

```text
y_i = alpha + beta x_i + u_i
```

Donde:

- `y_i` es la variable dependiente;
- `x_i` es la variable explicativa;
- `alpha` es el intercepto poblacional;
- `beta` es la pendiente poblacional;
- `u_i` es el error poblacional.

La media condicional modelada es:

```text
E(y_i | x_i) = alpha + beta x_i
```

`beta` mide cuanto cambia en promedio `y` cuando `x` aumenta una unidad.

Lectura clave: la regresion simple mide una relacion condicional al modelo. No
demuestra causalidad por si sola.

## 2. Error y residuo

El error poblacional es:

```text
u_i = y_i - E(y_i | x_i)
```

No se observa porque no conocemos la recta poblacional.

Despues de estimar:

```text
yhat_i = alphahat + betahat x_i
e_i = y_i - yhat_i
```

`e_i` es el residuo observable.

Diferencia conceptual:

- `u_i`: error verdadero no observado.
- `e_i`: residuo estimado con la muestra.

No conviene usar ambos como sinonimos. Muchas propiedades teoricas son sobre
`u_i`, mientras que las salidas de Python muestran `e_i`.

## 3. Minimos Cuadrados Ordinarios

MCO elige `alphahat` y `betahat` para minimizar:

```text
RSS = suma_i (y_i - a - b x_i)^2
```

La solucion es:

```text
betahat = suma_i (x_i - xbar)(y_i - ybar) / suma_i (x_i - xbar)^2
alphahat = ybar - betahat xbar
```

Tambien:

```text
betahat = Covhat(X,Y) / Varhat(X)
```

Interpretacion:

- Si `X` e `Y` covarian positivamente, la pendiente estimada es positiva.
- Si `X` casi no varia, el denominador es chico y la pendiente es dificil de
  estimar con precision.
- MCO minimiza error cuadratico dentro de la muestra, no garantiza causalidad.

## 4. Ecuaciones normales

Con intercepto, MCO cumple:

```text
suma_i e_i = 0
suma_i x_i e_i = 0
```

Esto implica:

- la media de los residuos es cero;
- los residuos son ortogonales a `x`;
- la recta estimada pasa por `(xbar, ybar)`.

Alerta importante: que los residuos sean ortogonales a `x` en la muestra es una
propiedad mecanica de MCO. No prueba que el error poblacional sea exogeno.

## 5. Sumas de cuadrados y R cuadrado

Con intercepto:

```text
TSS = ESS + RSS
```

Donde:

```text
TSS = suma_i (y_i - ybar)^2
ESS = suma_i (yhat_i - ybar)^2
RSS = suma_i (y_i - yhat_i)^2
```

El coeficiente de determinacion es:

```text
R^2 = ESS/TSS = 1 - RSS/TSS
```

En regresion simple con intercepto:

```text
R^2 = Corr(X,Y)^2
```

Como leerlo:

- `R^2` mide ajuste dentro de la muestra.
- No mide causalidad.
- No prueba que los errores estandar sean validos.
- No garantiza buen pronostico fuera de muestra.

## 6. Supuesto de exogeneidad e insesgadez

El supuesto central para interpretar MCO como estimador insesgado es:

```text
E(u_i | x_i) = 0
```

Significa que, dado `x_i`, el error no tiene una parte sistematica pendiente.
Todo lo que queda en `u_i` no debe estar correlacionado de forma relevante con
`x_i`.

Si esto se cumple:

```text
E(betahat) = beta
E(alphahat) = alpha
```

Si falta una variable relevante que afecta a `y` y esta correlacionada con `x`,
esa variable queda dentro de `u`. Entonces `x` queda correlacionada con el error
y aparece sesgo por variable omitida.

Esta es una de las ideas mas importantes del curso: MCO siempre da una recta,
pero no siempre da una interpretacion causal o insesgada.

## 7. Homocedasticidad y no autocorrelacion

Los supuestos clasicos agregan:

```text
Var(u_i | x_i) = sigma^2
Cov(u_i, u_j | X) = 0 para i != j
```

Homocedasticidad significa que la varianza del error es constante. No
autocorrelacion significa que los errores de distintas observaciones no se
mueven sistematicamente juntos.

En cross-section, la heterocedasticidad es frecuente. En series de tiempo, la
autocorrelacion es especialmente importante.

## 8. Varianza de la pendiente y precision

Bajo los supuestos clasicos:

```text
Var(betahat | X) = sigma^2 / suma_i (x_i - xbar)^2
```

La pendiente se estima con mas precision cuando:

- el error tiene menor varianza;
- `x` tiene mas dispersion;
- hay mas informacion util en la muestra.

Intuicion: si todos los `x_i` son casi iguales, no vemos como cambia `y` cuando
cambia `x`. Entonces estimar la pendiente es dificil.

## 9. Gauss-Markov

El teorema de Gauss-Markov dice que, bajo los supuestos del modelo lineal
clasico, MCO es BLUE o MELI:

```text
Best Linear Unbiased Estimator
Mejor Estimador Lineal Insesgado
```

"Mejor" significa menor varianza dentro de la clase de estimadores lineales e
insesgados.

No significa:

- que MCO sea perfecto;
- que sea causal;
- que tenga menor varianza que cualquier estimador no lineal;
- que la normalidad sea necesaria para ser BLUE.

## 10. Normalidad e inferencia

Para tests exactos en muestras finitas suele agregarse:

```text
u_i | X ~ N(0, sigma^2)
```

Entonces podemos usar estadisticos `t` para hipotesis sobre coeficientes.

Para:

```text
H0: beta = beta_0
HA: beta != beta_0
```

el estadistico es:

```text
t = (betahat - beta_0) / se(betahat)
```

Lectura:

- Si `|t|` es grande, la estimacion esta lejos de la hipotesis en unidades de
  error estandar.
- Si el `p-value` es chico, rechazamos H0.
- Si no rechazamos, no probamos que H0 sea verdadera.

## 11. Intervalos de confianza

Un intervalo al 95% tiene forma:

```text
betahat +/- t_critico * se(betahat)
```

Interpretacion correcta: si repitieramos el procedimiento muchas veces, el 95%
de los intervalos construidos asi contendria el parametro verdadero.

Interpretacion practica: valores dentro del intervalo son razonablemente
compatibles con la muestra al nivel elegido.

## 12. Prediccion

Hay que distinguir:

- intervalo de confianza para la media condicional;
- intervalo de prediccion para una observacion individual.

La prediccion individual es mas incierta porque incluye:

1. incertidumbre sobre la media estimada;
2. variabilidad propia del error individual.

Por eso la banda de prediccion siempre es mas ancha que la banda para la media.

---

# Clases 4 y 5 - Regresion multiple y problemas del modelo

## 1. Modelo multiple

El modelo multiple es:

```text
y_i = beta_0 + beta_1 x_{1i} + ... + beta_{k-1} x_{k-1,i} + u_i
```

MCO elige todos los coeficientes simultaneamente para minimizar:

```text
RSS = suma_i e_i^2
```

La diferencia con regresion simple no es solo agregar variables. Cambia la
interpretacion de cada coeficiente.

## 2. Interpretacion ceteris paribus

`beta_j` mide el cambio esperado en `y` cuando `x_j` aumenta una unidad,
manteniendo constantes las demas variables incluidas.

Esto significa que cada coeficiente es un efecto parcial, no una relacion bruta.

Ejemplo conceptual:

```text
PRECIO = beta_0 + beta_1 LOTE + beta_2 BANOS + u
```

`beta_1` no compara simplemente casas con lotes grandes contra casas con lotes
chicos. Compara casas que difieren en lote, manteniendo fija la cantidad de
banos incluida en el modelo.

Alerta: "mantener constante" es una operacion estadistica del modelo. No
significa que en la realidad encontremos facilmente dos unidades identicas salvo
por una variable.

## 3. Coeficiente parcial como residuo contra residuo

Una forma profunda de entender regresion multiple:

Para interpretar `beta_1` en un modelo con `x_1` y `x_2`:

1. Regresar `y` contra `x_2` y guardar los residuos.
2. Regresar `x_1` contra `x_2` y guardar los residuos.
3. Regresar el residuo de `y` contra el residuo de `x_1`.

El coeficiente obtenido coincide con `beta_1` del modelo multiple.

Intuicion: el coeficiente de `x_1` usa la parte de `x_1` que no esta explicada
por los otros controles.

Esto explica por que agregar controles puede cambiar mucho una pendiente.

## 4. Tests t individuales

Para cada coeficiente:

```text
t = (betahat_j - beta_{j,0}) / se(betahat_j)
```

En general se testea:

```text
H0: beta_j = 0
HA: beta_j != 0
```

Interpretacion:

- Rechazar `H0` sugiere que la variable aporta informacion individualmente,
  condicionando en las demas.
- No rechazar puede deberse a que el efecto es pequeno, a poca muestra, a mucho
  ruido o a multicolinealidad.
- Significatividad estadistica no implica importancia economica.

## 5. Test F y restricciones conjuntas

El test F evalua una o varias restricciones lineales al mismo tiempo.

```text
H0: R beta = r
```

Una formula comun es:

```text
F = [(RRSS - URSS)/q] / [URSS/(n-k)]
```

Donde:

- `RRSS`: RSS del modelo restringido;
- `URSS`: RSS del modelo no restringido;
- `q`: cantidad de restricciones;
- `k`: cantidad de parametros en el modelo no restringido.

Como leerlo:

- Si imponer las restricciones empeora mucho el ajuste, `RRSS - URSS` sera
  grande y el F sera grande.
- Un p-value chico lleva a rechazar las restricciones.
- El F global de una regresion suele testear que todas las pendientes sean cero.

Idea clave: variables individualmente no significativas pueden ser
conjuntamente significativas.

## 6. R cuadrado y R cuadrado ajustado

En regresion multiple, agregar variables nunca aumenta el RSS. Por eso el
`R^2` comun nunca baja cuando agregamos regresores.

El `R^2` ajustado penaliza cantidad de parametros:

```text
R2_ajustado = 1 - [RSS/(n-k)] / [TSS/(n-1)]
```

Como interpretarlo:

- `R^2` mide ajuste bruto dentro de muestra.
- `R^2 ajustado` ayuda a comparar modelos con distinta cantidad de variables.
- Ninguno prueba causalidad.
- Ninguno reemplaza teoria economica ni diagnosticos.

## 7. Variables dummy

Una dummy toma valores 0 o 1.

```text
y = beta_0 + beta_1 D + u
```

Si `D=0`:

```text
E(y|D=0) = beta_0
```

Si `D=1`:

```text
E(y|D=1) = beta_0 + beta_1
```

Entonces `beta_1` mide la diferencia respecto de la categoria base.

Si hay una variable categorica con `m` categorias y el modelo tiene intercepto,
se incluyen `m-1` dummies. La categoria omitida es la base.

Si incluimos todas las dummies mas intercepto, aparece multicolinealidad
perfecta porque las dummies suman uno.

## 8. Interacciones

Una interaccion permite que el efecto de una variable dependa de otra.

```text
y = beta_0 + beta_1 x + beta_2 D + beta_3 (xD) + u
```

Si `D=0`:

```text
E(y|x,D=0) = beta_0 + beta_1 x
```

Si `D=1`:

```text
E(y|x,D=1) = (beta_0 + beta_2) + (beta_1 + beta_3)x
```

Entonces:

- `beta_1`: efecto de `x` cuando `D=0`;
- `beta_3`: diferencia en el efecto de `x` cuando `D=1`;
- `beta_2`: diferencia entre grupos cuando `x=0`.

Si `x=0` no tiene sentido, conviene centrar `x` para que `beta_2` sea
interpretable en un valor relevante de `x`.

Alerta: con interacciones, los coeficientes principales no se leen de forma
aislada.

## 9. Notacion matricial

El modelo general se escribe:

```text
y = X beta + u
```

Donde:

- `y` es `n x 1`;
- `X` es `n x k`;
- `beta` es `k x 1`;
- `u` es `n x 1`.

El estimador MCO es:

```text
betahat = (X'X)^(-1) X'y
```

Existe una solucion unica si `X` tiene rango completo. Es decir, ninguna columna
de `X` puede escribirse como combinacion lineal exacta de otras.

Bajo supuestos clasicos:

```text
Var(betahat | X) = sigma^2 (X'X)^(-1)
```

## 10. Matrices de proyeccion

La matriz de proyeccion es:

```text
P = X(X'X)^(-1)X'
```

Entonces:

```text
yhat = Py
```

La matriz residual es:

```text
M = I - P
e = My
```

Interpretacion geometrica:

- `yhat` es la parte de `y` que vive en el espacio generado por las columnas de
  `X`;
- `e` es la parte de `y` que queda fuera de ese espacio;
- `yhat` y `e` son ortogonales.

Esta geometria ayuda a entender por que MCO es una proyeccion.

## 11. Multicolinealidad perfecta

Hay multicolinealidad perfecta cuando una columna de `X` es combinacion lineal
exacta de otras.

Ejemplos:

- incluir una variable dos veces;
- incluir todas las dummies de una categoria mas intercepto;
- crear una variable que sea suma exacta de otras incluidas.

Consecuencia:

```text
X'X no es invertible
```

No hay una unica solucion para los coeficientes. El modelo no puede separar
efectos porque la informacion esta duplicada exactamente.

## 12. Multicolinealidad alta

Hay multicolinealidad alta cuando regresores estan muy correlacionados, pero no
de manera perfecta.

No impide estimar, pero infla varianzas. En el caso de dos regresores:

```text
Var(betahat_1 | X) = sigma^2 / [S_11 (1-r_12^2)]
```

Si `|r_12|` se acerca a 1, entonces `1-r_12^2` se acerca a 0 y la varianza de la
pendiente crece.

Sintomas posibles:

- `R^2` alto;
- F global significativo;
- varios t individuales bajos;
- coeficientes sensibles al agregar o quitar variables;
- signos raros o inestables.

Pero esos sintomas no son prueba automatica. Conviene mirar correlaciones, VIF,
numero de condicion y sentido economico.

Idea clave: la multicolinealidad alta no sesga MCO si la exogeneidad se cumple.
El problema es la precision.

## 13. Heterocedasticidad

Homocedasticidad:

```text
Var(u_i | X) = sigma^2
```

Heterocedasticidad:

```text
Var(u_i | X) = sigma_i^2
```

La varianza del error cambia entre observaciones.

Consecuencias si se mantiene `E(u|X)=0`:

- los coeficientes MCO pueden seguir siendo insesgados y consistentes;
- MCO deja de ser eficiente;
- los errores estandar convencionales son incorrectos;
- los t, F, p-values e intervalos pueden ser invalidos.

La heterocedasticidad es, ante todo, un problema de inferencia.

## 14. Errores robustos

Los errores robustos corrigen la matriz de varianzas y covarianzas sin cambiar
los coeficientes MCO.

Lectura:

- mismos `betahat`;
- diferentes errores estandar;
- diferentes t, p-values e intervalos.

No solucionan todo. No hacen que los errores sean homocedasticos ni vuelven MCO
eficiente. Solo vuelven la inferencia mas robusta frente a heterocedasticidad.

## 15. Tests de heterocedasticidad

Todos parten de:

```text
H0: homocedasticidad
HA: heterocedasticidad
```

### White

Regresa residuos cuadrados sobre explicativas, cuadrados e interacciones.

Ventaja: es general.

Limite: puede consumir muchos grados de libertad.

### Breusch-Pagan

Relaciona residuos cuadrados con variables que podrian explicar la varianza.

Ventaja: mas parsimonioso.

Limite: exige elegir variables relevantes para la varianza.

### Goldfeld-Quandt

Ordena por una variable sospechosa, separa grupos y compara varianzas.

Ventaja: intuitivo si se sospecha que la varianza crece con una variable.

Limite: depende del ordenamiento elegido.

## 16. WLS, GLS y FGLS

Si conocemos la estructura de la varianza, podemos mejorar eficiencia usando
ponderaciones.

WLS minimiza:

```text
suma_i w_i e_i^2
```

con:

```text
w_i = 1/sigma_i^2
```

Observaciones mas ruidosas reciben menor peso.

GLS permite una matriz general de varianzas y covarianzas:

```text
Var(u|X) = Omega
```

FGLS estima esa estructura primero y luego aplica GLS.

Decision practica:

- Si no conozco bien la varianza: errores robustos.
- Si puedo modelar bien la varianza: WLS/GLS/FGLS puede ganar eficiencia.
- Pesos mal elegidos pueden empeorar la estimacion.

## 17. Consistencia

Un estimador es consistente si:

```text
plim(betahat) = beta
```

Es decir, al crecer la muestra, se acerca al parametro verdadero.

En forma matricial:

```text
betahat = beta + (X'X)^(-1)X'u
```

Para que el segundo termino desaparezca asintoticamente necesitamos que la
covarianza muestral entre regresores y errores tienda a cero y que haya variacion
suficiente en `X`.

Diferencia:

- Insesgamiento: propiedad de esperanza en muestra finita.
- Consistencia: propiedad de limite cuando `n` crece.

---

# Clase 6 - Series de tiempo, ruido blanco, AR, MA y ARMA

## 1. Que cambia en series de tiempo

En series de tiempo las observaciones tienen orden:

```text
t = 1, 2, ..., T
```

Ese orden importa. El valor pasado puede informar sobre el presente y el futuro.

En cross-section muchas veces pensamos en observaciones independientes. En series
de tiempo, la dependencia temporal es parte central del objeto de estudio.

Una pregunta tipica deja de ser solo "que explica a `y`?" y pasa a ser tambien:

```text
como depende y_t de su propio pasado y de shocks pasados?
```

## 2. Ruido blanco

Un ruido blanco debil `epsilon_t` cumple:

```text
E(epsilon_t) = 0
Var(epsilon_t) = sigma_epsilon^2
Cov(epsilon_t, epsilon_{t-j}) = 0 para j != 0
```

Interpretacion:

- no tiene media sistematica;
- tiene varianza constante;
- no tiene autocorrelacion.

Ruido blanco no significa que cada observacion sea normal. La normalidad es un
supuesto adicional.

Si ademas las observaciones son independientes, se habla de ruido blanco fuerte.

En modelos de series, el objetivo suele ser transformar la serie en una dinamica
explicada mas un residuo que parezca ruido blanco. Si queda autocorrelacion en
residuos, todavia hay estructura temporal no modelada.

## 3. Autocovarianza y autocorrelacion

La autocovarianza de rezago `j` es:

```text
gamma_j = Cov(y_t, y_{t-j})
```

La autocorrelacion es:

```text
rho_j = gamma_j / gamma_0
```

Mide cuanto se parece la serie a su propio pasado.

Como mirar la ACF:

- autocorrelaciones altas en rezagos chicos indican persistencia;
- decaimiento lento puede sugerir raiz unitaria o alta persistencia;
- cortes bruscos pueden sugerir procesos MA;
- barras fuera de bandas sugieren autocorrelaciones estadisticamente relevantes.

## 4. Proceso AR(1)

Un AR(1) es:

```text
y_t = c + rho y_{t-1} + epsilon_t
```

El presente depende del pasado inmediato mas una innovacion.

Si `|rho| < 1`, el proceso es estacionario. Su media incondicional es:

```text
mu = c / (1-rho)
```

Restando la media:

```text
y_t - mu = rho (y_{t-1} - mu) + epsilon_t
```

Interpretacion de `rho`:

- `rho` cerca de 0: poca persistencia.
- `rho` positivo y alto: shocks se disipan lentamente.
- `rho` negativo: alternancia parcial entre signos.
- `rho = 1`: random walk, shock permanente.

La ACF teorica de un AR(1) estacionario decae geometricamente:

```text
rho_j = rho^j
```

## 5. AR(p)

Un AR(p) es:

```text
y_t = c + phi_1 y_{t-1} + ... + phi_p y_{t-p} + epsilon_t
```

El presente depende de varios rezagos propios.

La idea no es que "mas rezagos siempre es mejor". Muchos rezagos consumen grados
de libertad y pueden sobreajustar. Pocos rezagos pueden dejar autocorrelacion en
residuos.

La PACF suele ayudar: para un AR(p), la PACF tiende a cortar despues de `p`,
mientras la ACF decae.

## 6. MA(1) y MA(q)

Un MA(1) es:

```text
y_t = mu + epsilon_t + theta epsilon_{t-1}
```

El presente depende del shock actual y del shock anterior.

Un MA(q):

```text
y_t = mu + epsilon_t + theta_1 epsilon_{t-1}
      + ... + theta_q epsilon_{t-q}
```

Interpretacion: los shocks tienen efecto transitorio durante una cantidad finita
de periodos.

Para un MA(q), la ACF teorica corta despues de `q`, mientras la PACF suele
decaer.

## 7. ARMA(p,q)

Un ARMA combina dinamica autorregresiva y medias moviles:

```text
y_t = c + phi_1 y_{t-1} + ... + phi_p y_{t-p}
      + epsilon_t + theta_1 epsilon_{t-1} + ... + theta_q epsilon_{t-q}
```

Interpretacion:

- parte AR: persistencia por rezagos de la propia variable;
- parte MA: efecto de shocks pasados.

En ARMA, ACF y PACF suelen decaer sin corte limpio. Por eso se usan como guia,
no como receta absoluta.

## 8. ACF y PACF como herramientas de lectura

La ACF pregunta:

```text
cuanto se parece y_t a y_{t-j}?
```

La PACF pregunta:

```text
cuanto aporta y_{t-j} despues de controlar por los rezagos 1,...,j-1?
```

Reglas orientativas:

| Proceso | ACF | PACF |
|---|---|---|
| AR(p) | Decae | Corta en p |
| MA(q) | Corta en q | Decae |
| ARMA(p,q) | Decae | Decae |

En muestras reales hay ruido muestral. No se espera un patron perfecto.

## 9. Estacionariedad en Clase 6

Aunque la estacionariedad se profundiza en Clase 7, aparece ya en ARMA.

Un modelo ARMA estacionario tiene:

- media constante;
- varianza constante;
- autocovarianzas que dependen del rezago, no del momento calendario.

Si una serie no es estacionaria, ajustar un ARMA en niveles puede ser incorrecto.
En ese caso luego aparece ARIMA: se diferencia la serie para lograr
estacionariedad y se modela la dinamica estacionaria.

## 10. Lectura practica para Clase 6

Cuando veas una serie:

```text
grafico -> ACF/PACF -> estacionariedad -> elegir AR/MA/ARMA -> revisar residuos
```

Un buen modelo no es solo el que tiene coeficientes significativos. Tambien debe
dejar residuos sin estructura temporal importante.

---

# Clase 7 - Estacionariedad, raices unitarias, ADF y DFGLS

## 1. Estacionariedad debil

Un proceso `y_t` es debilmente estacionario si:

```text
E(y_t) = mu
Var(y_t) = sigma^2
Cov(y_t, y_{t-j}) = gamma_j
```

La media y la varianza son constantes, y la autocovarianza depende solo del
rezago `j`, no de la fecha `t`.

Interpretacion: la serie puede fluctuar, pero lo hace alrededor de una estructura
estable.

## 2. Por que importa

Muchos resultados de series temporales suponen estacionariedad. Si una serie no
es estacionaria:

- medias y varianzas muestrales pueden ser inestables;
- autocorrelaciones pueden decaer muy lentamente;
- regresiones en niveles pueden ser espurias;
- shocks pueden tener efectos permanentes.

Antes de modelar, hay que entender el orden de integracion.

## 3. I(0), I(1) y diferencias

Una serie estacionaria es `I(0)`.

Una serie es `I(1)` si no es estacionaria en niveles, pero su primera diferencia
si lo es:

```text
Delta y_t = y_t - y_{t-1}
```

Si `y_t` esta en logaritmos:

```text
Delta ln(y_t)
```

se interpreta aproximadamente como crecimiento.

Alerta: diferenciar cambia la pregunta. En niveles pregunto por relaciones de
largo plazo; en diferencias pregunto por cambios de corto plazo.

## 4. Random walk y raiz unitaria

Un random walk es:

```text
y_t = y_{t-1} + epsilon_t
```

Cada shock se acumula permanentemente. Por eso la varianza crece con el tiempo y
el proceso no es estacionario.

Un AR(1):

```text
y_t = rho y_{t-1} + epsilon_t
```

tiene raiz unitaria si:

```text
rho = 1
```

El contraste de raiz unitaria busca distinguir alta persistencia estacionaria de
no estacionariedad.

## 5. Tendencia deterministica vs raiz unitaria

Una serie trend-stationary puede escribirse como:

```text
y_t = alpha + beta t + u_t
```

con `u_t` estacionario. Se estacionariza quitando la tendencia.

Una serie difference-stationary necesita diferenciarse:

```text
Delta y_t
```

Visualmente pueden parecerse. Conceptualmente son distintas:

- en tendencia deterministica, los shocks son transitorios alrededor de la
  tendencia;
- con raiz unitaria, los shocks son persistentes/permanentes.

Confundirlas lleva a modelos incorrectos.

## 6. Test Dickey-Fuller y ADF

Para:

```text
y_t = rho y_{t-1} + epsilon_t
```

se testea:

```text
H0: rho = 1      raiz unitaria
HA: rho < 1      estacionariedad
```

Restando `y_{t-1}`:

```text
Delta y_t = gamma y_{t-1} + epsilon_t
```

donde:

```text
gamma = rho - 1
```

Entonces:

```text
H0: gamma = 0
HA: gamma < 0
```

El ADF agrega rezagos de `Delta y_t` para limpiar autocorrelacion:

```text
Delta y_t = c + gamma y_{t-1}
            + a_1 Delta y_{t-1} + ... + a_p Delta y_{t-p}
            + epsilon_t
```

Puede incluir constante y tendencia deterministica segun el caso.

## 7. Valores criticos especiales

El estadistico ADF se parece a un t, pero no sigue una distribucion t usual bajo
la nula de raiz unitaria.

Por eso se usan valores criticos Dickey-Fuller.

Lectura:

- Estadistico mas negativo que el valor critico: rechazamos raiz unitaria.
- p-value chico: rechazamos raiz unitaria.
- No rechazar no prueba que haya raiz unitaria; puede faltar poder.

## 8. Elegir constante, tendencia y rezagos

La especificacion del ADF importa.

Opciones comunes:

- sin constante ni tendencia;
- con constante;
- con constante y tendencia.

Regla conceptual:

- Si la serie fluctua alrededor de cero, podria no necesitar constante.
- Si fluctua alrededor de una media distinta de cero, usar constante.
- Si muestra tendencia clara, considerar constante y tendencia.

Los rezagos de diferencias se agregan para que los residuos del test no tengan
autocorrelacion.

Pocos rezagos: test mal calibrado.

Muchos rezagos: menor poder.

Schwert propone un maximo:

```text
pmax = floor(12 * (T/100)^(1/4))
```

Tambien se usan AIC/BIC o procedimientos tipo Ng-Perron.

## 9. DFGLS

DFGLS es una variante del test de raiz unitaria que remueve componentes
deterministicos mediante GLS antes del contraste.

La motivacion es mejorar poder frente al ADF en ciertos contextos.

Interpretacion basica:

- H0 sigue siendo raiz unitaria.
- HA sigue siendo estacionariedad.
- La lectura del estadistico y valores criticos es similar en espiritu, aunque
  con tablas propias.

## 10. Operador de rezagos

El operador `L` rezaga una serie:

```text
L y_t = y_{t-1}
L^k y_t = y_{t-k}
```

La primera diferencia:

```text
Delta y_t = y_t - y_{t-1} = (1-L)y_t
```

Un AR(p):

```text
(1 - phi_1 L - ... - phi_p L^p)y_t = epsilon_t
```

El operador permite escribir modelos compactamente y analizar raices del
polinomio autorregresivo.

## 11. Regresion espuria

Si dos variables son `I(1)` y no estan cointegradas, una regresion en niveles
puede dar:

- `R^2` alto;
- t aparentemente significativos;
- residuos persistentes;
- relacion economica falsa.

Esto es regresion espuria.

Flujo correcto:

```text
graficar -> testear integracion -> decidir niveles/diferencias -> estimar -> diagnosticar
```

Si las variables son `I(0)`, se puede trabajar en niveles. Si son `I(1)` y no
cointegradas, normalmente se trabaja en diferencias. Si son `I(1)` y
cointegradas, se usa un modelo con correccion de errores.

---

# Clase 8 - VAR, estabilidad, Granger y cointegracion inicial

## 1. Que es un VAR

Un VAR modela varias variables endogenas simultaneamente. Cada variable depende
de sus propios rezagos y de los rezagos de las demas.

Si `y_t` es un vector `k x 1`, un VAR(p) es:

```text
y_t = m + A_1 y_{t-1} + A_2 y_{t-2}
      + ... + A_p y_{t-p} + epsilon_t
```

Cada `A_i` es una matriz `k x k`.

El error `epsilon_t` es ruido blanco vectorial:

```text
E(epsilon_t) = 0
E(epsilon_t epsilon_s') = Omega si t=s
E(epsilon_t epsilon_s') = 0 si t!=s
```

Los shocks pueden estar correlacionados contemporaneamente entre ecuaciones, pero
no serialmente.

## 2. VAR(1) con dos variables

Un VAR(1) simple:

```text
y_{1t} = m_1 + a_11 y_{1,t-1} + a_12 y_{2,t-1} + e_{1t}
y_{2t} = m_2 + a_21 y_{1,t-1} + a_22 y_{2,t-1} + e_{2t}
```

Lectura:

- `a_11`: efecto del rezago propio de `y_1` sobre `y_1`;
- `a_12`: efecto del rezago de `y_2` sobre `y_1`;
- `a_21`: efecto del rezago de `y_1` sobre `y_2`;
- `a_22`: efecto del rezago propio de `y_2` sobre `y_2`.

En un VAR, no hay una unica variable dependiente privilegiada. Todas las
variables del sistema son endogenas.

## 3. Estimacion ecuacion por ecuacion

Si todas las ecuaciones tienen los mismos regresores rezagados, el VAR puede
estimarse por MCO ecuacion por ecuacion.

La dificultad no es estimar una ecuacion, sino interpretar el sistema dinamico:

- estabilidad;
- rezagos relevantes;
- causalidad de Granger;
- respuesta a shocks;
- pronostico.

## 4. Estabilidad y autovalores

En un VAR(1):

```text
y_t = m + A y_{t-1} + epsilon_t
```

la estabilidad depende de los autovalores de `A`.

Si todos los autovalores tienen modulo menor que 1, el sistema es estable:

- shocks se disipan;
- existe media de largo plazo;
- el proceso es estacionario.

Si algun autovalor tiene modulo igual a 1, hay raiz unitaria en el sistema:

- los shocks pueden tener efectos permanentes;
- puede haber variables `I(1)`;
- puede aparecer cointegracion.

## 5. Diagonalizacion e intuicion

Si se puede diagonalizar la matriz:

```text
A = C Lambda C^{-1}
```

podemos transformar el sistema para pensar en combinaciones lineales que se
comportan como AR(1):

```text
z_t = C^{-1} y_t
z_t = m* + Lambda z_{t-1} + eta_t
```

Cada autovalor indica persistencia de una direccion del sistema.

Lectura:

- autovalor chico: ajuste rapido;
- autovalor cerca de 1: alta persistencia;
- autovalor igual a 1: componente no estacionario.

## 6. Cointegracion como idea inicial

Puede ocurrir que dos variables sean `I(1)` individualmente, pero una combinacion
lineal sea `I(0)`.

```text
y_t y x_t son I(1)
y_t - beta x_t es I(0)
```

Entonces hay cointegracion: existe una relacion de largo plazo que une las
series.

Interpretacion economica: las variables pueden moverse mucho en niveles, pero no
se separan indefinidamente. El desvio respecto de la relacion de largo plazo es
estacionario.

Clase 8 introduce esta idea como puente hacia VECM/Johansen.

## 7. Forma de correccion de errores

Para un VAR(1), se puede escribir:

```text
Delta y_t = m - Pi y_{t-1} + epsilon_t
```

La matriz `Pi` contiene informacion sobre relaciones de largo plazo.

Si `Pi` tiene rango reducido, se puede factorizar:

```text
Pi = alpha beta'
```

Donde:

- `beta' y_{t-1}` representa relaciones de cointegracion;
- `alpha` representa velocidades de ajuste.

Idea: si ayer el sistema estaba lejos de su relacion de largo plazo, hoy algunas
variables ajustan para corregir parte de ese desequilibrio.

## 8. Causalidad de Granger

`x_t` causa en sentido de Granger a `y_t` si los rezagos de `x_t` ayudan a
predecir `y_t` mas alla de los rezagos de `y_t`.

En un VAR:

```text
y_t = ... + a_1 x_{t-1} + ... + a_p x_{t-p} + ...
```

El test evalua:

```text
H0: a_1 = a_2 = ... = a_p = 0
```

Si se rechaza, los rezagos de `x` aportan informacion predictiva para `y`.

Alerta fundamental: Granger no es causalidad estructural. No demuestra mecanismo
economico profundo ni causalidad en sentido experimental. Es causalidad
predictiva temporal.

## 9. Seleccion de rezagos en VAR

Elegir `p` importa:

- pocos rezagos dejan autocorrelacion residual;
- demasiados rezagos consumen grados de libertad y sobreajustan.

Se suelen usar criterios de informacion:

```text
AIC, BIC/SC, HQ
```

Pero la decision tambien debe mirar diagnosticos de residuos y sentido economico.

## 10. Flujo para VAR

Antes de estimar un VAR:

1. Graficar las series.
2. Evaluar estacionariedad y orden de integracion.
3. Si son `I(0)`, VAR en niveles puede ser razonable.
4. Si son `I(1)`, evaluar cointegracion.
5. Si hay cointegracion, pensar en VECM.
6. Elegir rezagos.
7. Estimar.
8. Revisar estabilidad y residuos.
9. Interpretar Granger, pronosticos o respuestas a shocks con cuidado.

---

# Guia de lectura rapida por tema

## Cuando veo una salida de regresion

Mirar en este orden:

1. Que variable dependiente se esta explicando.
2. Que variables estan incluidas y cual es la categoria base si hay dummies.
3. Como se interpreta cada coeficiente ceteris paribus.
4. Errores estandar, t y p-values para inferencia individual.
5. F global o tests conjuntos si la pregunta es grupal.
6. `R^2` y `R^2 ajustado` como ajuste, no como causalidad.
7. Diagnosticos: multicolinealidad, heterocedasticidad, autocorrelacion.
8. Si los datos son temporales, revisar estacionariedad antes de confiar en
   regresiones en niveles.

## Cuando veo un p-value

Recordar:

```text
p-value chico -> rechazo H0
p-value grande -> no rechazo H0
```

No rechazo no es aceptacion. Un p-value grande puede aparecer por falta de
potencia, muestra chica, errores estandar grandes o efecto realmente pequeno.

## Cuando veo un coeficiente

Preguntar:

- En que unidades esta `y`?
- En que unidades esta `x`?
- Es nivel, log, tasa o dummy?
- Hay otras variables controladas?
- Hay interacciones que cambian la lectura?
- El coeficiente es estadisticamente preciso?
- Es economicamente relevante?

## Cuando veo datos de series de tiempo

Pensar:

```text
niveles o logs?
estacionaria o no?
I(0) o I(1)?
hay tendencia?
hay autocorrelacion?
los residuos parecen ruido blanco?
```

Si hay no estacionariedad, no conviene correr regresiones en niveles sin pensar
en cointegracion.

## Decision rapida por tipo de problema

Para precios financieros:

```text
precios -> log(precios) -> retornos -> momentos -> normalidad -> colas
```

Para variables macro:

```text
niveles -> logs -> crecimiento -> tendencia/ciclo -> estacionariedad
```

Para regresion cross-section:

```text
MCO -> interpretar coeficientes -> t/F/R2 -> diagnosticos -> robustez
```

Para series univariadas:

```text
grafico -> ACF/PACF -> estacionariedad -> AR/MA/ARMA/ARIMA -> residuos
```

Para varias series:

```text
integracion -> VAR si I(0) -> cointegracion/VECM si I(1) -> Granger/forecast
```

## Errores conceptuales frecuentes

- Confundir retorno simple con retorno logaritmico.
- Decir que un p-value es la probabilidad de que H0 sea verdadera.
- Interpretar `R^2` como causalidad.
- Creer que residuos ortogonales a `X` prueban exogeneidad.
- Leer coeficientes multiples como relaciones brutas y no ceteris paribus.
- Incluir todas las dummies junto con intercepto.
- Interpretar coeficientes principales sin mirar interacciones.
- Creer que multicolinealidad alta sesga MCO.
- Pensar que heterocedasticidad cambia automaticamente los coeficientes MCO.
- Usar errores convencionales cuando hay heterocedasticidad fuerte.
- Ajustar ARMA a una serie no estacionaria sin diferenciar o testear.
- Confundir tendencia deterministica con raiz unitaria.
- Tomar causalidad de Granger como causalidad economica estructural.

## Checklist antes de pasar a ejercicios

Antes de resolver practicas y examenes, deberias poder explicar sin mirar:

1. Por que los log-retornos se suman y los simples se componen.
2. Que significan media, varianza, asimetria y curtosis.
3. Como se lee Jarque-Bera y que no dice.
4. Por que tendencia y ciclo dependen del filtro usado.
5. Que minimiza MCO.
6. Cual es la diferencia entre error y residuo.
7. Que supuesto sostiene la insesgadez de MCO.
8. Que significa BLUE/MELI.
9. Como se lee un t, un p-value, un intervalo y un F.
10. Que significa ceteris paribus.
11. Como se interpretan dummies e interacciones.
12. Por que aparece multicolinealidad perfecta y que hace la alta.
13. Que problema genera la heterocedasticidad y como ayudan errores robustos.
14. Que es ruido blanco.
15. Como distinguir intuitivamente AR, MA y ARMA.
16. Que significa estacionariedad y por que importa.
17. Que testea ADF y por que sus valores criticos son especiales.
18. Que es regresion espuria.
19. Que representa un VAR.
20. Que significa causalidad de Granger.
