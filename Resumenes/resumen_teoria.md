# Resumen teoria - Modelado Estocastico hasta Clase 8

Este resumen cubre la teoria disponible en la carpeta `Clases` hasta la Clase 8. En la carpeta no aparece un PDF de Clase 5; por eso el orden observado es Clase 1, 2, 3, 4, 6, 7 y 8. El apunte de `Pronosticos` y los materiales de Clase 9 quedan fuera del nucleo "hasta Clase 8", salvo como continuidad natural de ARIMA/VAR.

## Clase 1 - Retornos, distribuciones y momentos

El curso empieza con retornos financieros y medicion de riesgo. Si `P_t` es el precio de un activo en el momento `t`, el retorno simple neto es:

```text
R_t = (P_t - P_{t-1}) / P_{t-1} = P_t / P_{t-1} - 1
```

El retorno bruto simple es `1 + R_t = P_t / P_{t-1}`. Es el que refleja directamente cuanto se gana o pierde en plata.

El retorno logaritmico es:

```text
r_t = ln(P_t / P_{t-1}) = ln(P_t) - ln(P_{t-1}) = Delta ln(P_t)
```

La relacion central es:

```text
r_t = ln(1 + R_t) ~= R_t
```

La aproximacion es buena cuando los retornos son chicos. Para retornos grandes, la diferencia importa: los retornos negativos quedan mas negativos en logaritmos y los positivos quedan mas chicos que en retornos simples. Esto es relevante al mirar riesgo de cola izquierda.

Una ventaja practica del retorno logaritmico es que se suma en el tiempo. Si se tienen retornos logaritmicos diarios `r_1, ..., r_5`, entonces:

```text
r_1 + r_2 + ... + r_5 = ln(P_5 / P_0)
```

En cambio, los retornos simples se componen multiplicativamente:

```text
1 + R_acum = (1 + R_1)(1 + R_2)...(1 + R_T)
```

La clase tambien repasa distribuciones, especialmente la normal, y momentos:

- Media: centro de la distribucion.
- Varianza: dispersion alrededor de la media.
- Desvio estandar: raiz cuadrada de la varianza.
- Asimetria: mide si una cola pesa mas que la otra.
- Curtosis: mide peso de colas y concentracion relativa. En exceso, la normal tiene curtosis igual a 0.

Estandarizar una variable consiste en restarle su media y dividir por su desvio:

```text
Z = (X - mu) / sigma
```

Si `X` tiene media `mu` y varianza `sigma^2`, entonces `Z` tiene media 0 y varianza 1. Esto permite comparar variables en escalas distintas.

## Clase 2 - Crecimiento, escala logaritmica, tendencia y ciclo

La Clase 2 trabaja con variables macroeconomicas, especialmente PBI real. El PBI nominal valua cantidades del periodo con precios del mismo periodo. El PBI real valua cantidades del periodo con precios de un ano base, por eso busca medir cantidades producidas sin contaminarse por inflacion.

La tasa de crecimiento simple del PBI real es:

```text
g_t = PBI_t / PBI_{t-1} - 1
```

Para crecimiento acumulado:

```text
1 + g_acum = PBI_final / PBI_inicial
```

Y si se quiere una tasa promedio por periodo:

```text
1 + g_acum = (1 + g)^n
```

Cuando la serie esta en logaritmos, la pendiente entre dos puntos aproxima la tasa de crecimiento promedio. La diferencia logaritmica:

```text
ln(PBI_t) - ln(PBI_{t-1})
```

aproxima el crecimiento porcentual cuando los cambios son chicos.

La serie en logaritmos se descompone como:

```text
y_t = y_t^g + y_t^c
```

donde `y_t^g` es la tendencia y `y_t^c` es el ciclo.

Tres formas de separar tendencia y ciclo:

1. Tendencia deterministica lineal: se ajusta una recta al logaritmo de la serie. El ciclo son los desvios respecto de esa recta.
2. Media movil centrada: suaviza la serie promediando observaciones alrededor de cada fecha. Cuanto mas grande la ventana, mas suave la tendencia, pero se pierde mas informacion en extremos.
3. Filtro Hodrick-Prescott: elige una tendencia que balancea dos objetivos: que el ciclo sea chico y que la tendencia sea suave. El parametro `lambda` controla cuan suave es la tendencia.

La idea conceptual: una serie macro puede moverse por crecimiento de largo plazo y por fluctuaciones transitorias. La tendencia busca capturar lo persistente; el ciclo, lo transitorio.

## Clase 3 - Regresion lineal simple e inferencia

El modelo de regresion lineal simple busca explicar `y_i` usando `x_i`:

```text
y_i = alpha + beta x_i + u_i
```

Los observables son `y_i` y `x_i`. Los no observables son `alpha`, `beta` y `u_i`. El error `u_i` es la diferencia entre `y_i` y su esperanza condicional modelada.

El valor predicho por la recta estimada es:

```text
yhat_i = alphahat + betahat x_i
```

El residuo es:

```text
e_i = y_i - yhat_i
```

MCO, o minimos cuadrados ordinarios, elige `alphahat` y `betahat` minimizando:

```text
S(a,b) = sum_i (y_i - a - b x_i)^2
```

Las ecuaciones normales implican:

```text
sum_i e_i = 0
sum_i e_i x_i = 0
```

Los estimadores son:

```text
betahat = sum_i (x_i - xbar)(y_i - ybar) / sum_i (x_i - xbar)^2
alphahat = ybar - betahat xbar
```

Tambien:

```text
betahat = Covhat(X,Y) / Varhat(X)
```

Por eso el signo de `betahat` coincide con el signo de la covarianza muestral entre `X` e `Y`.

La descomposicion de suma de cuadrados es:

```text
TSS = ESS + RSS
```

donde:

- `TSS`: variabilidad total de `Y`.
- `ESS`: parte explicada por el modelo.
- `RSS`: parte residual no explicada.

El coeficiente de determinacion es:

```text
R^2 = ESS / TSS
```

Con intercepto, `R^2` esta entre 0 y 1. En regresion simple, coincide con la correlacion entre `X` e `Y` al cuadrado.

### Supuestos e insesgadez

El primer supuesto central es:

```text
E(u_i) = 0
```

Bajo este supuesto, MCO es insesgado:

```text
E(betahat) = beta
E(alphahat) = alpha
```

Luego se introduce:

```text
Var(u_i) = sigma^2        homocedasticidad
Cov(u_i, u_j) = 0         no autocorrelacion, i != j
```

Con estos supuestos se calculan las varianzas de los estimadores. Para la pendiente:

```text
Var(betahat) = sigma^2 / sum_i (x_i - xbar)^2
```

La intuicion: si `X` tiene mas variabilidad, es mas facil estimar la pendiente; si el error tiene mas varianza, es mas dificil.

### Gauss-Markov

El teorema de Gauss-Markov dice que, bajo los supuestos del modelo lineal clasico, los estimadores MCO son MELI/BLUE: mejores estimadores lineales insesgados. "Mejor" significa menor varianza dentro de la clase de estimadores lineales e insesgados.

### Normalidad e inferencia

Para hacer tests exactos en muestras finitas se agrega normalidad:

```text
u_i ~ N(0, sigma^2)
```

Con normalidad, los estimadores tambien tienen distribucion normal y se pueden construir estadisticos `t` para testear hipotesis sobre parametros.

Un test tipico es:

```text
H0: beta = 0
HA: beta != 0
```

El estadistico es:

```text
t = (betahat - beta_0) / se(betahat)
```

Se rechaza `H0` si el estadistico cae en la region critica o si el `p-value` es menor que el nivel de significatividad elegido.

## Clase 4 - Regresion multiple, tests F, dummies y problemas de especificacion

La regresion multiple agrega mas variables explicativas:

```text
y_i = alpha + beta_1 x_{1i} + beta_2 x_{2i} + u_i
```

El valor predicho es:

```text
yhat_i = alphahat + betahat_1 x_{1i} + betahat_2 x_{2i}
```

MCO sigue minimizando la suma de residuos cuadrados. Las ecuaciones normales implican que los residuos suman cero y son ortogonales a cada regresor incluido.

La interpretacion de `beta_j` cambia: mide el efecto parcial de `x_j` sobre `y`, manteniendo constantes las demas variables del modelo.

### Multicolinealidad

Hay multicolinealidad perfecta cuando una variable explicativa puede escribirse como combinacion lineal exacta de otras. En ese caso no se pueden estimar los parametros porque no hay una unica forma de atribuir efectos.

Hay multicolinealidad alta cuando los regresores estan muy correlacionados. No necesariamente impide estimar, pero aumenta las varianzas de los estimadores y por lo tanto agranda los errores estandar. Esto puede producir coeficientes individualmente no significativos aunque el modelo tenga buen ajuste global.

Senales practicas:

- `R^2` alto con varios `t` bajos.
- Coeficientes sensibles al agregar/quitar variables.
- Correlaciones altas entre regresores.

### Test F

El test F sirve para restricciones conjuntas. Por ejemplo:

```text
H0: beta_1 = beta_2 = 0
```

Compara el RSS del modelo restringido contra el RSS del modelo no restringido:

```text
F = ((RRSS - URSS) / q) / (URSS / (n - k - 1))
```

donde `q` es la cantidad de restricciones. Si el estadistico es grande, las restricciones empeoran mucho el ajuste, entonces se rechaza `H0`.

El F global que reportan los softwares suele testear si todos los coeficientes de pendientes son cero.

### Variables dummy

Una variable dummy toma valores 0 o 1 y representa categorias. Si se incluye una dummy en una regresion con intercepto, el coeficiente mide la diferencia de intercepto respecto de la categoria base.

Hay que evitar la trampa de las dummies: si una variable categorica tiene `m` categorias y el modelo tiene intercepto, se incluyen `m - 1` dummies. Incluir todas genera multicolinealidad perfecta.

### Notacion matricial

La regresion multiple puede escribirse como:

```text
y = X beta + u
```

El estimador MCO matricial es:

```text
betahat = (X'X)^(-1) X'y
```

Existe si `X'X` es invertible, lo que requiere que no haya multicolinealidad perfecta.

### Heterocedasticidad

La homocedasticidad exige:

```text
Var(u_i) = sigma^2
```

Si la varianza cambia entre observaciones, hay heterocedasticidad. MCO puede seguir siendo insesgado si `E(u_i)=0`, pero deja de ser MELI y los errores estandar convencionales quedan mal calculados.

Tests principales:

- White: se regresan residuos cuadrados en las X, sus cuadrados y productos cruzados. Bajo `H0` de homocedasticidad, `n R^2` converge a chi-cuadrado.
- Goldfeld-Quandt: ordena por una variable sospechada de generar heterocedasticidad, separa grupos extremos y compara RSS.
- Breusch-Pagan: relaciona residuos cuadrados escalados con variables sospechadas de explicar la varianza.

Si se rechaza homocedasticidad, se deben usar errores robustos o metodos tipo GLS/FGLS segun el caso.

## Clase 6 - Introduccion a series de tiempo, ruido blanco, AR, MA y ARMA

En series de tiempo las observaciones tienen orden natural:

```text
t = 1, 2, ..., T
```

La autocorrelacion se vuelve central. En una regresion con series de tiempo:

```text
y_t = alpha + beta x_t + u_t
```

es plausible que `u_t` este correlacionado con `u_{t-1}`, `u_{t-2}`, etc. El problema es que la matriz de varianzas y covarianzas de errores tiene demasiadas covarianzas para estimarlas libremente. Por eso se reparametrizan los errores con estructuras simples.

### Ruido blanco

Un ruido blanco debil `epsilon_t` cumple:

```text
E(epsilon_t) = 0
Var(epsilon_t) = sigma_epsilon^2
Cov(epsilon_t, epsilon_{t-j}) = 0 para j != 0
```

Si ademas hay independencia, se habla de ruido blanco fuerte.

### Procesos autorregresivos

Un AR(1):

```text
u_t = rho u_{t-1} + epsilon_t
```

Un AR(p):

```text
u_t = rho_1 u_{t-1} + ... + rho_p u_{t-p} + epsilon_t
```

La intuicion: el valor actual depende de sus propios rezagos mas una innovacion.

### Procesos de medias moviles

Un MA(1):

```text
u_t = theta epsilon_{t-1} + epsilon_t
```

Un MA(q):

```text
u_t = epsilon_t + theta_1 epsilon_{t-1} + ... + theta_q epsilon_{t-q}
```

La intuicion: el valor actual depende de shocks presentes y pasados.

### ARMA

Un ARMA(p,q) combina rezagos de la variable y rezagos de shocks:

```text
u_t = rho_1 u_{t-1} + ... + rho_p u_{t-p}
      + epsilon_t + theta_1 epsilon_{t-1} + ... + theta_q epsilon_{t-q}
```

La ACF y PACF ayudan a diagnosticar la estructura:

- AR(p): la PACF suele cortar despues de `p`; la ACF decae.
- MA(q): la ACF suele cortar despues de `q`; la PACF decae.
- ARMA: ambas suelen decaer sin corte claro.

## Clase 7 - Estacionariedad, raices unitarias, ADF, DFGLS y operador de rezagos

Un proceso `y_t` es debilmente estacionario si:

```text
E(y_t) = mu
Var(y_t) = sigma^2
Cov(y_t, y_{t-j}) = gamma_j
```

La media y varianza son constantes, y las autocovarianzas dependen solo del rezago `j`, no del momento `t`.

Si un proceso es estacionario, es `I(0)`. Si no es estacionario pero su primera diferencia si lo es, entonces es `I(1)`:

```text
Delta y_t = y_t - y_{t-1}
```

La primera tarea en series de tiempo es identificar el orden de integracion. Es importante relacionar variables con ordenes compatibles.

### ADF

Para un AR(1):

```text
y_t = rho y_{t-1} + epsilon_t
```

se testea:

```text
H0: rho = 1      raiz unitaria, no estacionaria
HA: rho < 1      estacionaria
```

Restando `y_{t-1}`:

```text
Delta y_t = (rho - 1) y_{t-1} + epsilon_t
```

El test ADF agrega constante, tendencia y rezagos de `Delta y_t` para remover autocorrelacion:

```text
Delta y_t = c + (rho - 1)y_{t-1} + d t + rezagos + epsilon_t
```

Los valores criticos no son los de una `t` convencional porque bajo la nula la serie es no estacionaria.

### Tendencia deterministica vs raiz unitaria

No es lo mismo:

```text
y_t = beta t + epsilon_t
```

que una serie `I(1)`. En el primer caso, se estacionariza quitando la tendencia deterministica estimada. En el segundo, se estacionariza tomando diferencias.

### Seleccion de rezagos en ADF

Si se eligen pocos rezagos, puede quedar autocorrelacion residual y el test queda mal calibrado. Si se eligen demasiados, baja el poder del test. Ng-Perron sugiere partir de un maximo y reducir si el ultimo rezago no es relevante. Schwert sugiere:

```text
pmax = floor(12 * (T/100)^(1/4))
```

Tambien pueden usarse criterios como AIC o Schwarz/BIC.

### DFGLS

DFGLS es un test de raiz unitaria similar al ADF, pero usa una transformacion GLS para remover componentes deterministicas antes del contraste. Suele tener mejor poder en algunos contextos.

### Operador de rezagos

El operador `L` rezaga:

```text
L x_t = x_{t-1}
L^k x_t = x_{t-k}
```

La diferencia se escribe:

```text
Delta y_t = (1 - L)y_t
```

Un AR(p):

```text
y_t(1 - rho_1 L - ... - rho_p L^p) = epsilon_t
```

Para AR(1), la condicion de estacionariedad es `|rho| < 1`, equivalente a que la raiz del polinomio quede fuera del circulo unitario.

## Clase 8 - VAR, autovalores, cointegracion inicial y causalidad de Granger

Un VAR extiende los modelos autorregresivos a varias variables. Si `y_t` es un vector `k x 1`, un VAR(p) es:

```text
y_t = m + A_1 y_{t-1} + A_2 y_{t-2} + ... + A_p y_{t-p} + epsilon_t
```

Cada `A_i` es una matriz `k x k`. El vector de errores `epsilon_t` es ruido blanco vectorial:

```text
E(epsilon_t) = 0
E(epsilon_t epsilon_s') = Omega si t = s, 0 si t != s
```

Los errores no estan correlacionados serialmente, aunque pueden estar correlacionados contemporaneamente entre ecuaciones.

En un VAR(1) con dos variables:

```text
y_1t = m_1 + a_11 y_1,t-1 + a_12 y_2,t-1 + epsilon_1t
y_2t = m_2 + a_21 y_1,t-1 + a_22 y_2,t-1 + epsilon_2t
```

Cada variable depende de sus propios rezagos y de los rezagos de las demas.

El comportamiento dinamico depende de los autovalores de la matriz `A`. Si se diagonaliza:

```text
z_t = C^{-1} y_t
z_t = m* + Lambda z_{t-1} + eta_t
```

el sistema se transforma en procesos AR(1) desacoplados.

Casos:

- Si todos los autovalores tienen modulo menor a 1, las variables son `I(0)` y vuelven a un equilibrio de largo plazo.
- Si un autovalor es 1 y otro tiene modulo menor a 1, las variables pueden ser `I(1)` pero existir una combinacion lineal `I(0)`: aparece la idea de cointegracion.
- Si hay autovalores unitarios repetidos sin suficientes autovectores, pueden aparecer procesos `I(2)`.

La forma de correccion de errores aparece al escribir:

```text
Delta y_t = m - Pi y_{t-1} + epsilon_t
```

Cuando `Pi` tiene rango reducido, puede factorizarse en vectores que representan velocidades de ajuste y relaciones de cointegracion. En Clase 8 esto aparece como intuicion y puente hacia modelos VEC.

### Causalidad de Granger

`x_t` causa en el sentido de Granger a `y_t` si los rezagos de `x_t` ayudan a explicar `y_t` mas alla de la informacion contenida en los rezagos de `y_t`.

Es una nocion estadistica de poder predictivo, no causalidad estructural o causalidad economica profunda.

## Capa de profundizacion teorica

Esta seccion agrega una lectura mas conceptual de los mismos temas. La idea es tener no solo "que formula usar", sino tambien por que aparece, que supuesto sostiene cada resultado y donde suelen aparecer errores.

### 1. Retornos: por que existen dos definiciones

El retorno simple es natural para medir ganancia economica:

```text
R_t = P_t / P_{t-1} - 1
```

Si una inversion sube de 100 a 110, el retorno simple es 10%. Si baja de 100 a 90, es -10%. Esta es la metrica mas directa para performance.

El retorno logaritmico se usa porque convierte productos en sumas:

```text
r_t = ln(1 + R_t)
```

Si quiero acumular muchos periodos, el retorno bruto simple exige multiplicar:

```text
P_T / P_0 = (1 + R_1)(1 + R_2)...(1 + R_T)
```

Tomando logaritmos:

```text
ln(P_T / P_0) = r_1 + r_2 + ... + r_T
```

Por eso los log-retornos son tan comodos en series financieras. La desventaja es interpretativa: el retorno logaritmico no es exactamente el porcentaje de plata ganada. Para cambios chicos son casi iguales, pero para cambios grandes no.

Una idea importante para riesgo: los log-retornos penalizan mas las caidas que las subas equivalentes. Por ejemplo, `ln(0.75)` tiene mayor magnitud negativa que `ln(1.25)` positiva. Eso vuelve a los log-retornos utiles cuando importa la cola izquierda.

### 2. Momentos: que informacion agrega cada uno

La media resume centro, pero no riesgo. Dos activos pueden tener la misma media y volatilidades muy distintas.

La varianza mide dispersion promedio cuadratica. Como eleva al cuadrado, castiga fuerte observaciones alejadas. El desvio estandar vuelve a la unidad original.

La asimetria dice si la distribucion tiene cola mas pesada a un lado. En finanzas, asimetria negativa suele ser preocupante: implica posibilidad de perdidas grandes aun si la media es razonable.

La curtosis mide peso de colas. Una curtosis alta implica mas observaciones extremas que una normal. Por eso una distribucion con igual media y varianza que una normal puede ser mucho mas riesgosa si tiene exceso de curtosis positivo.

Jarque-Bera combina asimetria y curtosis para testear normalidad. Si se rechaza normalidad, no significa que el modelo sea inutil, pero si alerta que inferencia exacta basada en normalidad puede ser fragil.

### 3. Tendencia y ciclo: no son objetos observados

En macroeconomia se habla de tendencia y ciclo como si fueran cosas visibles, pero en realidad son una descomposicion construida:

```text
y_t = tendencia_t + ciclo_t
```

Distintos metodos producen distintas tendencias:

- Una tendencia lineal impone crecimiento constante en logaritmos.
- Una media movil deja que la tendencia cambie lentamente, pero depende de la ventana.
- HP filter elige una tendencia suave resolviendo un problema de optimizacion.

El ciclo no "existe" independientemente del metodo: es lo que queda luego de definir tendencia. Esto importa en examenes y analisis empirico: siempre hay que decir como se extrajo el ciclo.

En series en logaritmos, diferencias aproximan tasas de crecimiento:

```text
Delta ln(y_t) ~= tasa de crecimiento
```

Por eso muchas series macro se grafican y modelan en logaritmos.

### 4. MCO: que minimiza y que no promete

MCO minimiza residuos cuadrados:

```text
sum e_i^2
```

Eso garantiza el mejor ajuste lineal dentro de la muestra segun ese criterio. Pero no garantiza automaticamente causalidad, ni que los errores estandar sean validos, ni que el modelo este bien especificado.

El estimador de pendiente en regresion simple:

```text
betahat = Covhat(X,Y) / Varhat(X)
```

explica por que `beta` depende de la covariacion entre `X` e `Y`, escalada por la variabilidad de `X`. Si `X` casi no varia, estimar su efecto es dificil.

Para insesgadez, el supuesto profundo no es normalidad sino exogeneidad:

```text
E(u_i | X_i) = 0
```

En las notas aparece como `E(u_i)=0` con `X` tratada como dada. La lectura econometrica mas fuerte es que el error no debe estar sistematicamente relacionado con los regresores.

Si falta una variable relevante correlacionada con `X`, el error absorbe esa variable y `X` queda correlacionada con el error. Ahi aparece sesgo por variable omitida.

### 5. Error estandar vs coeficiente

El coeficiente mide magnitud estimada. El error estandar mide incertidumbre de esa estimacion.

Un coeficiente puede ser economicamente grande pero estadisticamente impreciso si su error estandar es grande. El estadistico `t` combina ambas cosas:

```text
t = estimacion / error estandar
```

Por eso multicolinealidad no necesariamente cambia mucho los coeficientes, pero puede inflar errores estandar y hacer que los `t` caigan.

### 6. R^2 no es causalidad ni validez

`R^2` mide proporcion de variabilidad de `Y` explicada dentro de la muestra. No dice:

- que el modelo sea causal;
- que no haya sesgo;
- que el modelo pronostique bien fuera de muestra;
- que los errores estandar sean correctos.

En series de tiempo no estacionarias, incluso puede aparecer un `R^2` alto en una regresion espuria. Por eso estacionariedad y orden de integracion se vuelven tan importantes mas adelante.

### 7. Regresion multiple: interpretacion "ceteris paribus"

En regresion multiple:

```text
y_i = alpha + beta_1 x_{1i} + beta_2 x_{2i} + u_i
```

`beta_1` mide el cambio esperado en `y` ante un cambio en `x_1`, manteniendo fijo `x_2`. Esa frase "manteniendo fijo" es lo que distingue regresion multiple de simple.

Si `x_1` y `x_2` estan correlacionadas, agregar `x_2` puede cambiar mucho `betahat_1`, porque ahora `x_1` solo recibe la parte de variacion que no esta compartida con `x_2`.

Una forma intuitiva de pensar el coeficiente parcial es:

1. Limpiar `x_1` de lo que explica `x_2`.
2. Limpiar `y` de lo que explica `x_2`.
3. Regresar el residuo de `y` contra el residuo de `x_1`.

Eso es equivalente a MCO multiple y ayuda a entender el efecto parcial.

### 8. Multicolinealidad: problema de informacion, no de sesgo

La multicolinealidad perfecta impide estimar porque dos columnas de `X` contienen la misma informacion lineal. `X'X` no se puede invertir.

La multicolinealidad alta no rompe MCO, pero reduce precision. El modelo tiene dificultad para separar que parte del efecto pertenece a cada variable. Por eso:

- el `R^2` puede ser alto;
- el F global puede ser significativo;
- los `t` individuales pueden ser bajos.

La solucion no es automatica. A veces se acepta si el objetivo es prediccion; si el objetivo es interpretar coeficientes individuales, puede ser grave.

### 9. Heterocedasticidad: el problema esta en la inferencia

Con heterocedasticidad:

```text
Var(u_i | X_i) = sigma_i^2
```

Si la exogeneidad se mantiene, MCO puede seguir siendo insesgado. El problema es que las formulas usuales de varianza de los estimadores dejan de ser validas.

Consecuencia: los `t`, `p-values` e intervalos de confianza convencionales pueden estar mal.

Respuestas practicas:

- usar errores estandar robustos;
- modelar la varianza y usar WLS/GLS/FGLS;
- revisar si la forma funcional esta mal especificada.

White es general pero puede perder poder si hay muchos terminos. Breusch-Pagan es mas dirigido. Goldfeld-Quandt sirve si hay una variable por la cual sospechamos que crece la varianza.

### 10. Series de tiempo: dependencia temporal como objeto central

En datos cross-section, muchas veces se empieza suponiendo independencia entre observaciones. En series de tiempo, el pasado informa sobre el presente. Esa dependencia es justamente lo que queremos modelar.

Un ruido blanco no es "cualquier ruido": debe tener media cero, varianza constante y no autocorrelacion. Es el bloque basico que queda luego de modelar toda la estructura temporal sistematica.

Un AR(1):

```text
y_t = rho y_{t-1} + epsilon_t
```

es estacionario si `|rho| < 1`. Si `rho` esta cerca de 1, los shocks son muy persistentes. Si `rho = 1`, el proceso es random walk:

```text
y_t = y_{t-1} + epsilon_t
```

En un random walk, los shocks tienen efecto permanente y la varianza crece con el horizonte. Por eso no es estacionario.

### 11. ACF y PACF: lectura practica

La ACF responde: cuanto se parece la serie a sus propios rezagos.

La PACF responde: cuanto aporta un rezago especifico despues de controlar por los rezagos anteriores.

Regla orientativa:

- AR(p): PACF corta en `p`, ACF decae.
- MA(q): ACF corta en `q`, PACF decae.
- ARMA(p,q): ACF y PACF decaen.

No es una regla mecanica perfecta, pero ayuda a elegir modelos candidatos.

### 12. Raiz unitaria: por que no alcanza mirar el grafico

Una serie con tendencia deterministica y una serie con raiz unitaria pueden verse parecidas. Pero se estacionarizan distinto:

- Tendencia deterministica: se remueve estimando una tendencia.
- Raiz unitaria: se toman diferencias.

Confundirlas cambia todo el analisis. Si diferencias una serie trend-stationary, podes eliminar informacion de largo plazo innecesariamente. Si solo sacas tendencia a una serie con raiz unitaria, puede seguir siendo no estacionaria.

ADF testea raiz unitaria. Bajo la nula, la distribucion del estadistico no es una `t` convencional. Por eso hay valores criticos especiales.

### 13. Orden de integracion y regresion espuria

Si dos variables son `I(1)` y no estan cointegradas, una regresion en niveles puede mostrar alto `R^2` y t-statistics aparentemente significativos aunque no haya relacion real. Eso es regresion espuria.

Por eso el flujo correcto en series temporales es:

```text
graficar -> testear raiz unitaria -> decidir niveles/diferencias -> estimar -> diagnosticar residuos
```

Si las variables son `I(0)`, se puede trabajar en niveles. Si son `I(1)` y no cointegradas, normalmente se trabaja con diferencias. Si son `I(1)` y cointegradas, aparece el modelo de correccion de errores.

### 14. VAR: sistema dinamico, no una sola ecuacion

Un VAR trata todas las variables como endogenas. Cada variable depende de sus propios rezagos y de los rezagos de las demas.

La estabilidad del VAR depende de autovalores. Si el sistema es estable, los shocks se disipan. Si hay autovalores unitarios, los shocks pueden tener efectos permanentes.

Granger causality pregunta si los rezagos de una variable mejoran el pronostico de otra. No prueba causalidad estructural. Es una nocion de contenido predictivo.

La idea de cointegracion que aparece en Clase 8 es clave: puede haber variables individualmente no estacionarias, pero una combinacion lineal estacionaria. Eso significa que hay una relacion de largo plazo que ata a las series entre si.

### 15. Guia de decision rapida

Para datos financieros de precios:

```text
precios -> log(precios) -> retornos logaritmicos -> analizar distribucion/volatilidad
```

Para variables macro en niveles:

```text
niveles -> logs -> tendencia/ciclo o test de raiz unitaria -> diferencias si I(1)
```

Para regresion cross-section:

```text
MCO -> interpretar coeficientes -> revisar t/F/R^2 -> diagnosticar multicolinealidad y heterocedasticidad
```

Para series de tiempo univariadas:

```text
graficar -> ACF/PACF -> estacionariedad -> AR/MA/ARMA/ARIMA -> diagnostico de residuos
```

Para varias series temporales:

```text
testear integracion -> VAR si I(0) -> Johansen/VECM si I(1) cointegradas -> Granger/forecast/diagnosticos
```
