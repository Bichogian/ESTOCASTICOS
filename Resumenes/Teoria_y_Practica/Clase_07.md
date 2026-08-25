# Clase 7 - Teoria + practica + Python

[Volver al indice general](../Res+Pra.md)

Esta guia cruza la teoria de la Clase 7 con el notebook de ADF/DFGLS. El
objetivo central es aprender a decidir si una serie es estacionaria, si necesita
diferenciarse y como interpretar tests de raiz unitaria.

La clase tambien introduce operador de rezagos, condiciones de estacionariedad
en AR/MA/ARMA, impulso-respuesta y una primera idea de cointegracion. La
`Ejercitacion 7` por nombre trata VAR y causalidad de Granger; por contenido
corresponde mejor al bloque de Clase 8, asi que queda senalada como puente.

El recorrido de cada tema es:

```text
microteoria -> en Python lo hacemos asi -> salida del ejemplo -> que significa -> idea para recordar
```

## Archivos que vamos a usar

| Tipo | Archivo | Para que se usa |
|---|---|---|
| Teoria | `Clases/MIA103_Clase_7_.pdf` | Estacionariedad, ADF, DFGLS, rezagos, raices, ARMA, impulso-respuesta y cointegracion inicial |
| Python | `Codigos/MIA103_2026_Clase_07_Ejemplo_ADF_DFGLS.ipynb` | Aplicacion ADF/DFGLS al precio del trigo |
| Datos | `Bases de Datos MIA103/wheat.xlsx` | Precio mensual del trigo `wheat_srw` y `wheat_hrw` |
| Practica puente | `Practicas/MIA103_Ejer_7_.pdf` | VAR y causalidad de Granger; se trabajara con Clase 8 |

## Que notebook usamos para cada tema

| Paso | Tema | Notebook o material |
|---:|---|---|
| 1 | Estacionariedad debil y fuerte | PDF Clase 7 |
| 2 | I(0), I(1) y diferencias | PDF Clase 7 |
| 3 | ADF y raiz unitaria | PDF y notebook ADF/DFGLS |
| 4 | Componentes deterministicas y rezagos | PDF y notebook ADF/DFGLS |
| 5 | Ejemplo con log-precio del trigo | Notebook ADF/DFGLS |
| 6 | Regresion auxiliar del ADF | Notebook ADF/DFGLS |
| 7 | DFGLS | PDF y notebook ADF/DFGLS |
| 8 | Operador de rezagos | PDF Clase 7 |
| 9 | Condiciones de estacionariedad en AR, MA y ARMA | PDF Clase 7 |
| 10 | Media y varianza de AR/ARMA | PDF Clase 7 |
| 11 | Impulso-respuesta | PDF Clase 7 |
| 12 | Cointegracion inicial | PDF Clase 7 |

---

## 1. Estacionariedad debil

### Microresumen teorico

Un proceso `y_t` es debilmente estacionario si cumple:

```text
E(y_t) = mu < infinito para todo t
Var(y_t) = sigma^2 < infinito para todo t
Cov(y_t, y_{t-j}) = gamma_j para todo t y j
```

Esto significa:

- la media no cambia con el tiempo;
- la varianza no cambia con el tiempo;
- la autocovarianza depende solo de la distancia entre observaciones, no de la
  fecha exacta.

Cuando un proceso es estacionario, decimos que es integrado de orden cero:

```text
y_t ~ I(0)
```

### Que significa

Una serie estacionaria puede subir y bajar, pero lo hace alrededor de una
estructura estable. No tiene una media que se mueva permanentemente, ni una
varianza que crezca sin limite.

Esto es clave porque muchos modelos de series temporales, como ARMA, se piensan
para procesos estacionarios.

### Idea para recordar

Estacionario no significa quieto. Significa que sus propiedades probabilisticas
basicas no dependen del calendario.

---

## 2. Estacionariedad fuerte

### Microresumen teorico

Un proceso es estrictamente o fuertemente estacionario si la distribucion conjunta
de:

```text
{y_t, y_{t+j1}, y_{t+j2}, ..., y_{t+jn}}
```

depende solo de las distancias temporales:

```text
j1, j2, ..., jn
```

y no del momento `t`.

Si un proceso es estrictamente estacionario y tiene segundos momentos finitos,
entonces tambien es debilmente estacionario.

### Que significa

La estacionariedad fuerte exige estabilidad de toda la distribucion conjunta, no
solo de media, varianza y autocovarianzas. Es mas exigente.

En el curso normalmente trabajamos con estacionariedad debil porque alcanza para
ACF, ARMA y muchos resultados practicos.

### Idea para recordar

La estacionariedad fuerte implica la debil si hay varianza finita. La debil no
necesariamente implica la fuerte.

---

## 3. I(0), I(1) y diferencias

### Microresumen teorico

Si `y_t` es estacionaria:

```text
y_t ~ I(0)
```

Si `y_t` no es estacionaria, pero su primera diferencia si lo es:

```text
Delta y_t = y_t - y_{t-1}
Delta y_t ~ I(0)
```

entonces:

```text
y_t ~ I(1)
```

Si la primera diferencia tampoco es estacionaria, podria ser necesario tomar una
segunda diferencia:

```text
Delta(Delta y_t)
```

En la practica, muchas series economicas y financieras suelen ser `I(0)` o
`I(1)`.

### Que significa

Diferenciar cambia la pregunta:

- En niveles miramos el valor de la serie.
- En diferencias miramos el cambio.
- En logaritmos, la diferencia del log se interpreta aproximadamente como tasa
  de crecimiento o retorno logaritmico.

Por ejemplo:

```text
Delta ln(P_t) = ln(P_t) - ln(P_{t-1})
```

es el retorno logaritmico.

### Idea para recordar

Si el log-precio es `I(1)`, el retorno logaritmico puede ser `I(0)`.

---

## 4. Por que importa el orden de integracion

### Microresumen teorico

Antes de relacionar variables de series de tiempo, hay que revisar su orden de
integracion.

La clase insiste en esto porque queremos relacionar variables con ordenes de
integracion compatibles.

### Que significa

Si se mezclan series no estacionarias sin cuidado, se puede obtener una regresion
aparentemente buena pero falsa:

```text
R^2 alto
t significativos
relacion economica inexistente
```

Eso es una regresion espuria.

Si dos variables son `I(1)`, se puede pensar en una relacion en niveles solo si
estan cointegradas. Si no lo estan, normalmente se trabaja con diferencias.

### Idea para recordar

En series temporales, antes de estimar hay que preguntar: `I(0)` o `I(1)`?

---

## 5. Test Dickey-Fuller y ADF

### Microresumen teorico

Partimos de un AR(1):

```text
y_t = rho y_{t-1} + epsilon_t
```

Queremos testear:

```text
H0: rho = 1       raiz unitaria, no estacionaria
HA: rho < 1       estacionaria
```

Restando `y_{t-1}`:

```text
y_t - y_{t-1} = rho y_{t-1} - y_{t-1} + epsilon_t
Delta y_t = (rho - 1)y_{t-1} + epsilon_t
```

Definimos:

```text
gamma = rho - 1
```

Entonces:

```text
Delta y_t = gamma y_{t-1} + epsilon_t
H0: gamma = 0
HA: gamma < 0
```

### ADF

El Dickey-Fuller aumentado agrega rezagos de la variable dependiente para remover
autocorrelacion residual:

```text
Delta y_t = c + gamma y_{t-1} + d t
            + beta_1 Delta y_{t-1}
            + beta_2 Delta y_{t-2}
            + ...
            + beta_p Delta y_{t-p}
            + epsilon_t
```

La hipotesis sigue siendo:

```text
H0: gamma = 0       raiz unitaria
HA: gamma < 0       estacionaria
```

### Que significa

Los rezagos de `Delta y_t` no se agregan porque sean el foco teorico principal,
sino para limpiar autocorrelacion en los residuos del test.

Si queda autocorrelacion residual, los valores criticos del ADF no serian
confiables.

### Idea para recordar

ADF no testea si la serie "se ve con tendencia". Testea si hay raiz unitaria.

---

## 6. Valores criticos especiales

### Microresumen teorico

El estadistico ADF se parece a un estadistico `t` porque sale del coeficiente de
`y_{t-1}` en la regresion auxiliar. Pero bajo la hipotesis nula de raiz unitaria
no sigue una distribucion t convencional.

Por eso se usan valores criticos Dickey-Fuller.

### Como leerlo

El test es unilateral hacia la izquierda:

```text
valores criticos negativos
estadistico muy negativo -> evidencia contra raiz unitaria
```

Regla:

- Si el estadistico ADF es mas negativo que el valor critico, rechazamos `H0`.
- Si el p-value es menor que el nivel de significancia, rechazamos `H0`.
- Si rechazamos `H0`, hay evidencia de estacionariedad.
- Si no rechazamos `H0`, no probamos raiz unitaria; simplemente no encontramos
  evidencia suficiente contra ella.

### Error frecuente

No hay que comparar el estadistico ADF con la tabla t usual.

### Idea para recordar

ADF usa una regresion auxiliar, pero su estadistico tiene tabla propia.

---

## 7. Componentes deterministicas

### Microresumen teorico

El ADF puede incluir distintos componentes deterministas:

```text
sin constante
con constante
con constante y tendencia lineal
con constante, tendencia lineal y tendencia cuadratica
```

En `statsmodels`:

```python
regression="n"    # sin constante ni tendencia
regression="c"    # constante
regression="ct"   # constante y tendencia lineal
regression="ctt"  # constante, tendencia lineal y cuadratica
```

### Que significa

La especificacion debe parecerse al comportamiento de la serie:

- Si fluctua alrededor de cero, podria usarse sin constante.
- Si fluctua alrededor de una media distinta de cero, conviene constante.
- Si muestra tendencia deterministica, conviene constante y tendencia.

Pero cuidado: una serie con raiz unitaria y una serie con tendencia
deterministica pueden verse muy parecidas.

### Idea para recordar

La eleccion de constante/tendencia no es decorativa: cambia la regresion auxiliar
y los valores criticos.

---

## 8. Tendencia deterministica vs raiz unitaria

### Microresumen teorico

Una serie con tendencia deterministica puede escribirse como:

```text
y_t = beta t + epsilon_t
```

Entonces:

```text
E(y_t) = beta t
```

La media depende del tiempo, por lo que la serie no es estacionaria.

Pero no es lo mismo que una serie `I(1)`.

### Como estacionarizar cada una

Si la serie es `I(1)`:

```text
tomar primeras diferencias
```

Si la serie es `I(0)` alrededor de una tendencia deterministica:

```text
estimar la tendencia y quedarse con los residuos
```

Es decir, correr:

```text
y_t = alpha + beta t + residuo_t
```

y analizar los residuos.

### Que significa

En el primer caso, los shocks tienen efectos persistentes. En el segundo, los
shocks son transitorios alrededor de una tendencia deterministica.

### Idea para recordar

Raiz unitaria y tendencia deterministica pueden parecerse en un grafico, pero se
corrigen de manera distinta.

---

## 9. Seleccion de rezagos en ADF

### Microresumen teorico

La cantidad de rezagos `p` en el ADF importa.

Si usamos pocos rezagos:

```text
puede quedar autocorrelacion residual
```

Si usamos demasiados:

```text
perdemos poder estadistico
```

Ng y Perron sugieren:

1. Elegir una cota superior `pmax`.
2. Estimar ADF con `pmax`.
3. Mirar el estadistico t del ultimo rezago de `Delta y_t`.
4. Si `|t| >= 1.6`, quedarse con `pmax`.
5. Si no, reducir un rezago y repetir.

Schwert propone:

```text
pmax = floor(12 * (T/100)^(1/4))
```

En `statsmodels`, si no se fija `maxlag`, usa una regla automatica para el maximo
de rezagos. Tambien permite seleccionar con:

```python
autolag="AIC"
autolag="BIC"
autolag="t-stat"
autolag=None
```

### Idea para recordar

No elegimos rezagos para conseguir el p-value que nos gusta. Los elegimos para
que el test este bien especificado.

---

## 10. Ejemplo practico: precio del trigo

### Objetivo

El notebook pregunta:

```text
El precio del trigo es estacionario o necesitamos diferenciarlo?
```

La base usada es:

```text
Bases de Datos MIA103/wheat.xlsx
```

con precios mensuales desde 1980M01 hasta 2021M09.

### En Python lo hacemos asi

El notebook carga:

```python
df = pd.read_excel('wheat.xlsx')
```

Desde la raiz del repositorio conviene usar:

```python
df = pd.read_excel('Bases de Datos MIA103/wheat.xlsx')
```

Luego convierte la columna de fecha:

```python
inicio = pd.to_datetime(df["yearmm"].iloc[0], format="%YM%m")

df["date"] = pd.period_range(
    start=inicio,
    periods=len(df),
    freq="M"
)

df = df.set_index("date")
```

Convierte el precio a numerico:

```python
df["wheat_srw"] = pd.to_numeric(df["wheat_srw"], errors="coerce")
```

Calcula log-precio:

```python
df_log_ws = np.log(df["wheat_srw"])
```

y retorno logaritmico:

```python
df["dlws"] = df_log_ws.diff()
```

### Salida inicial

La base empieza asi:

```text
yearmm    wheat_srw   wheat_hrw
1980M01     169.71      175.63
1980M02     170.49      172.70
1980M03     162.40      163.51
1980M04     155.80      156.53
1980M05     156.20      161.30
```

Los primeros retornos logaritmicos son:

```text
1980-02     0.004586
1980-03    -0.048614
1980-04    -0.041489
1980-05     0.002564
```

### Que significa

El precio en niveles es un valor. El log-precio permite mirar variaciones
proporcionales. La diferencia del log-precio es el retorno logaritmico mensual.

La pregunta de integracion se responde en dos pasos:

1. Testear el log-precio en niveles.
2. Si no rechazamos raiz unitaria, testear la primera diferencia.

### Idea para recordar

Para precios financieros o de commodities suele ser natural que el nivel sea
`I(1)` y el retorno sea `I(0)`, pero hay que testearlo.

---

## 11. ADF sobre retornos logaritmicos

### En Python

```python
from statsmodels.tsa.stattools import adfuller

y = df["dlws"].dropna()

test = adfuller(
    y,
    regression="c",
    autolag="t-stat"
)
```

### Salida del notebook

```text
Estadistico ADF : -8.2930
p-valor         : 0.0000
Rezagos         : 8
Observaciones   : 491
Valores criticos:
  1%:  -3.4437
  5%:  -2.8674
  10%: -2.5699
```

### Que significa

El estadistico `-8.2930` es mucho mas negativo que los valores criticos. El
p-value es practicamente cero. Por lo tanto, rechazamos:

```text
H0: hay raiz unitaria
```

Conclusion: los retornos logaritmicos del trigo son estacionarios segun este ADF.

### Idea para recordar

Cuando rechazamos la raiz unitaria en los retornos, tenemos evidencia de que
`Delta log(P_t)` es `I(0)`.

---

## 12. Regresion auxiliar del ADF

### Microresumen teorico

La regresion auxiliar con constante y tendencia es:

```text
Delta y_t = c + beta t + gamma y_{t-1}
            + sum_{i=1}^{p} phi_i Delta y_{t-i}
            + epsilon_t
```

El coeficiente importante para el test es:

```text
gamma
```

El estadistico ADF es el estadistico asociado a `gamma`.

### En Python

El notebook usa:

```python
test_adf = adfuller(
    y,
    regression="c",
    autolag="t-stat",
    regresults=True
)
```

Con `regresults=True`, `statsmodels` permite mirar la regresion auxiliar.

Tambien la reconstruye manualmente:

```python
dy = y.diff()

X = pd.DataFrame({
    "const": 1.0,
    "trend": t,
    "y_lag1": y.shift(1),
})

for i in range(1, k_lags + 1):
    X[f"dy_lag{i}"] = dy.shift(i)

res = sm.OLS(Y_ols, X_ols).fit()
```

### Salida clave con constante y tendencia

```text
Coeficiente de y_{t-1}: -1.0765914429181938
Estadistico asociado:   -8.329124154425488
```

### Que significa

Ese estadistico coincide con el ADF para la especificacion correspondiente.
Pero no debe interpretarse con tabla t convencional.

### Idea para recordar

El ADF sale de una regresion OLS, pero su distribucion bajo H0 no es la t usual.

---

## 13. Comparacion de configuraciones ADF

### Salida del notebook

El notebook compara varias configuraciones para los retornos logaritmicos:

```text
maxlag  regression  autolag   ADF        p_value       lags
17      c           t-stat   -8.2930    4.21e-13       8
17      ct          t-stat   -8.3291    1.24e-11       8
17      ctt         t-stat   -8.3365    5.04e-11       8
17      n           t-stat   -8.2966    6.90e-14       8
None    c           AIC      -8.2930    4.21e-13       8
None    c           BIC     -18.7245    2.03e-30       0
```

### Que significa

Todas las configuraciones rechazan raiz unitaria para los retornos. La conclusion
es robusta: `Delta log(P_t)` parece estacionaria.

Pero cambian los rezagos y los valores exactos. Esto muestra que la especificacion
importa.

### Idea para recordar

Cuando varias especificaciones razonables llevan a la misma conclusion, la
evidencia es mas convincente.

---

## 14. Procedimiento completo para determinar orden de integracion

### Paso 1: ADF en niveles

El notebook aplica ADF al log-precio:

```python
x = df_log_ws.dropna()

test_adf = adfuller(
    x,
    regression="ct",
    autolag="t-stat",
    regresults=True
)
```

Salida clave:

```text
Estadistico ADF: -3.1031
p-valor:          0.1055
Valores criticos:
  1%:  -3.9773
  5%:  -3.4195
  10%: -3.1323
```

### Interpretacion

Con un nivel de significancia de 10%, el p-value `0.1055` es apenas mayor que
`0.10`, por lo que no rechazamos la nula de raiz unitaria.

Ademas, en la regresion auxiliar la tendencia deterministica aparece
significativa:

```text
p-value de la tendencia aproximado: 0.009
```

Esto sugiere que en niveles el log-precio tiene tendencia, pero el ADF no alcanza
a rechazar raiz unitaria.

### Paso 2: ADF en primeras diferencias

Si no rechazamos raiz unitaria en niveles, miramos:

```python
y = x.diff().dropna()
```

ADF con constante y tendencia:

```text
Estadistico ADF: -8.3291
p-valor:          0.0000
```

La tendencia deterministica en diferencias no resulta significativa:

```text
p-value tendencia aproximado: 0.416
```

Entonces se repite sin tendencia:

```python
adfuller(y, regression="c", autolag="t-stat", regresults=True)
```

Salida:

```text
Estadistico ADF: -8.2930
p-valor:          0.0000
```

### Conclusion

El log-precio del trigo no rechaza raiz unitaria en niveles, pero sus primeras
diferencias si rechazan raiz unitaria.

Entonces:

```text
log(P_t) ~ I(1)
Delta log(P_t) ~ I(0)
```

### Idea para recordar

Orden de integracion se decide probando niveles y, si hace falta, diferencias.
No alcanza con mirar un solo test aislado.

---

## 15. DFGLS

### Microresumen teorico

DFGLS es un test de raiz unitaria propuesto por Elliott, Rothenberg y Stock. Es
similar al Dickey-Fuller, pero primero remueve componentes deterministas mediante
una transformacion GLS.

La hipotesis nula sigue siendo:

```text
H0: la serie contiene raiz unitaria
```

La alternativa:

```text
HA: la serie es debilmente estacionaria
```

### En Python

El notebook usa la biblioteca `arch`:

```python
from arch.unitroot import DFGLS
```

Con constante:

```python
DFGLS(y, trend="c", method="t-stat")
```

Con constante y tendencia:

```python
DFGLS(y, trend="ct", method="t-stat")
```

### Salidas del notebook

DFGLS en niveles, con constante y tendencia:

```text
Test Statistic: -2.129
P-value:         0.242
Lags:            9
Critical Values: -3.45 (1%), -2.89 (5%), -2.60 (10%)
```

No rechaza raiz unitaria en niveles.

DFGLS en diferencias con constante y tendencia:

```text
Test Statistic: -7.970
P-value:         0.000
Lags:            8
```

Rechaza raiz unitaria.

DFGLS en diferencias con constante:

```text
Test Statistic: -8.224
P-value:         0.000
Lags:            8
```

Tambien rechaza raiz unitaria.

### Que significa

DFGLS confirma la lectura del ADF: el log-precio del trigo se comporta como
`I(1)` y sus retornos logaritmicos como `I(0)`.

### Idea para recordar

DFGLS se usa como contraste alternativo o chequeo de robustez. No cambia la
pregunta, cambia la forma de construir el test.

---

## 16. Operador de rezagos

### Microresumen teorico

El operador de rezagos `L` desplaza una serie un periodo hacia atras:

```text
L x_t = x_{t-1}
L^2 x_t = x_{t-2}
L^k x_t = x_{t-k}
```

La primera diferencia puede escribirse:

```text
Delta y_t = y_t - y_{t-1} = (1-L)y_t
```

Un AR(p):

```text
y_t = rho_1 y_{t-1} + rho_2 y_{t-2} + ... + rho_p y_{t-p} + epsilon_t
```

se escribe:

```text
y_t(1 - rho_1 L - rho_2 L^2 - ... - rho_p L^p) = epsilon_t
```

Definimos:

```text
A(L) = 1 - rho_1 L - rho_2 L^2 - ... - rho_p L^p
```

Entonces:

```text
y_t A(L) = epsilon_t
```

### Idea para recordar

El operador `L` permite escribir modelos con muchos rezagos de forma compacta.

---

## 17. Raices y estacionariedad en AR

### AR(1)

Un AR(1):

```text
y_t(1 - rho L) = epsilon_t
```

es estacionario si:

```text
|rho| < 1
```

Equivalentemente, la raiz de:

```text
1 - rho z = 0
```

debe estar fuera del circulo unitario:

```text
|z| > 1
```

### AR(2)

Para:

```text
y_t = rho_1 y_{t-1} + rho_2 y_{t-2} + epsilon_t
```

el polinomio es:

```text
1 - rho_1 z - rho_2 z^2 = 0
```

El proceso es estacionario si todas las raices estan afuera del circulo unitario.

### Ejemplo del PDF

```text
y_t = 0.75 y_{t-1} - 0.25 y_{t-2} + epsilon_t
```

Polinomio:

```text
1 - 0.75 z + 0.25 z^2 = 0
```

Las raices son complejas y tienen modulo:

```text
2
```

Como `2 > 1`, estan fuera del circulo unitario y el AR(2) es estacionario.

### Idea para recordar

Para AR(p), estacionariedad exige que las raices del polinomio AR esten fuera
del circulo unitario.

---

## 18. Estacionariedad en MA y ARMA

### MA(q)

Un MA(q):

```text
y_t = theta_1 epsilon_{t-1}
      + theta_2 epsilon_{t-2}
      + ...
      + theta_q epsilon_{t-q}
      + epsilon_t
```

es estacionario si los coeficientes `theta_i` son finitos.

Intuicion: es una combinacion finita de shocks i.i.d.; por eso no acumula shocks
infinitamente como un random walk.

### ARMA(p,q)

Un ARMA(p,q):

```text
y_t = rho_1 y_{t-1} + ... + rho_p y_{t-p}
      + theta_1 epsilon_{t-1} + ... + theta_q epsilon_{t-q}
      + epsilon_t
```

puede escribirse:

```text
y_t A(L) = B(L) epsilon_t
```

donde:

```text
A(L) = 1 - rho_1 L - ... - rho_p L^p
B(L) = 1 + theta_1 L + ... + theta_q L^q
```

El ARMA es estacionario si la parte MA tiene coeficientes finitos y las raices de
la parte AR estan fuera del circulo unitario.

### Idea para recordar

La estacionariedad de un ARMA la manda la parte AR.

---

## 19. Media y varianza de un AR(1) con constante

### Microresumen teorico

Si:

```text
y_t = c + rho y_{t-1} + epsilon_t
```

y el proceso es estacionario, entonces:

```text
E(y_t) = E(y_{t-1}) = mu
```

Tomando esperanza:

```text
mu = c + rho mu
mu(1-rho) = c
mu = c / (1-rho)
```

La varianza es:

```text
Var(y_t) = sigma_epsilon^2 / (1-rho^2)
```

La constante cambia la media, pero no cambia la condicion de estacionariedad ni
la formula de varianza alrededor de la media.

### ARMA general

Para:

```text
y_t = c + rho_1 y_{t-1} + ... + rho_p y_{t-p}
      + theta_1 epsilon_{t-1} + ... + theta_q epsilon_{t-q}
      + epsilon_t
```

si es estacionario:

```text
E(y_t) = c / (1 - sum_{j=1}^{p} rho_j)
```

### Idea para recordar

En un AR estacionario, la constante determina la media de largo plazo.

---

## 20. Invertibilidad e impulso-respuesta

### Microresumen teorico

Un ARMA estacionario puede escribirse como:

```text
y_t = c* + G(L) epsilon_t
```

donde:

```text
G(L) = B(L) A(L)^(-1)
```

Si la parte MA es invertible, tambien puede escribirse como un AR infinito.

### Shock e impulso-respuesta

Si introducimos un shock de una unidad en el periodo `t`, los coeficientes:

```text
G(L) = 1 + g_1 L + g_2 L^2 + ...
```

dicen cuanto afecta ese shock a:

```text
y_t, y_{t+1}, y_{t+2}, ...
```

La funcion:

```text
g_s
```

se llama funcion de impulso-respuesta. Mide el efecto del shock sobre `y_{t+s}`.

La suma:

```text
G(1) = 1 + g_1 + g_2 + ...
```

es el efecto de largo plazo del shock.

### Mean lag y median lag

El `mean lag` mide un tiempo promedio ponderado de respuesta:

```text
Mean lag = [sum i g_i] / [sum g_i] = G(1)^(-1) G'(1)
```

El `median lag` mide el tiempo hasta que se incorpora la mitad del efecto de largo
plazo.

### Ejemplo del PDF

Para:

```text
y_t = 0.03 + 0.75 y_{t-1} - 0.25 y_{t-2}
      + epsilon_t + 0.5 epsilon_{t-1}
```

el PDF plantea:

```text
A(L) = 1 - 0.75L + 0.25L^2
B(L) = 1 + 0.5L
G(L) = A(L)^(-1) B(L)
```

Los primeros coeficientes son:

```text
g_1 = 1.25
g_2 = 11/16
g_3 = 13/64
g_4 = -5/256
```

El efecto de largo plazo del ejemplo es `3`, el mean lag es `0.833` y el median
lag es `0.4`.

### Idea para recordar

Impulso-respuesta traduce un shock de hoy en efectos dinamicos futuros.

---

## 21. Cointegracion inicial

### Microresumen teorico

Supongamos dos series:

```text
y_t ~ I(1)
x_t ~ I(1)
```

Estimamos:

```text
y_t = alpha + beta x_t + u_t
```

Si los residuos estimados:

```text
e_t = y_t - alphahat - betahat x_t
```

son estacionarios, entonces `y_t` y `x_t` estan cointegradas.

### Que significa

Aunque las dos series sean no estacionarias individualmente, existe una
combinacion lineal estacionaria. Eso significa que comparten una tendencia
estocastica comun.

En finanzas, el residuo puede interpretarse como un spread. Si ese spread es
estacionario, revierte a su media.

### Lectura economica

Cointegracion es dependencia de largo plazo. No dice que sepamos exactamente
donde estaran los precios en el futuro, pero si una relacion estable entre ellos.

### Idea para recordar

Dos series `I(1)` pueden moverse mucho, pero si estan cointegradas no se separan
indefinidamente.

---

## 22. Practica 7 como puente a Clase 8

### Que pide el archivo `MIA103_Ejer_7_.pdf`

La ejercitacion pide investigar, con la base `Precios_y_Dinero.xlsx`, si una
mayor tasa de crecimiento de la base monetaria causa en sentido de Granger una
mayor tasa de inflacion.

Pide:

- plantear un VAR;
- elegir cantidad de rezagos con criterio optimo;
- verificar estabilidad del VAR;
- testear causalidad de Granger;
- usar nivel de significancia del 10%.

### Por que lo dejamos para Clase 8

Aunque el archivo se llama Ejercitacion 7, el contenido es VAR y causalidad de
Granger, que en el mapa del curso corresponde a Clase 8.

Para Clase 7, la practica natural es determinar orden de integracion con ADF y
DFGLS. Para Clase 8, esta ejercitacion va a ser central.

### Idea para recordar

Antes de VAR/Granger conviene tener clara Clase 7: estacionariedad e integracion.
Un VAR estable normalmente se trabaja con variables estacionarias o con el
tratamiento adecuado si son `I(1)`.

---

## 23. Checklist de Clase 7

Al terminar esta clase deberias poder explicar:

1. Que significa estacionariedad debil.
2. Diferencia entre estacionariedad debil y fuerte.
3. Que significa que una serie sea `I(0)`.
4. Que significa que una serie sea `I(1)`.
5. Por que diferenciar cambia la pregunta economica.
6. Que testea el ADF.
7. Por que la hipotesis nula del ADF es raiz unitaria.
8. Por que el estadistico ADF no usa tabla t convencional.
9. Para que sirven los rezagos en el ADF.
10. Como elegir entre constante, tendencia o ninguna.
11. Diferencia entre tendencia deterministica y raiz unitaria.
12. Como decidir el orden de integracion con niveles y diferencias.
13. Que muestra el ejemplo del trigo.
14. Que agrega DFGLS respecto del ADF.
15. Como funciona el operador de rezagos.
16. Que condicion de raices hace estacionario a un AR(p).
17. Por que un MA(q) es estacionario si sus coeficientes son finitos.
18. Que rol cumple la parte AR en la estacionariedad de un ARMA.
19. Que es una funcion impulso-respuesta.
20. Que significa cointegracion como relacion de largo plazo.

## Observaciones tecnicas antes de ejecutar

- El notebook carga `wheat.xlsx` como si estuviera en el directorio actual. Desde
  la raiz del repositorio conviene usar `Bases de Datos MIA103/wheat.xlsx`.
- Para ejecutar el notebook se necesitan `statsmodels`, `openpyxl` y, para
  DFGLS, `arch`.
- El notebook instala `arch` con `pip install arch`; si se trabaja localmente,
  conviene instalar dependencias antes de correrlo.
- Los resultados numericos del ADF guardados en el notebook indican que
  `log(wheat_srw)` es `I(1)` y `Delta log(wheat_srw)` es `I(0)`.
- La `Ejercitacion 7` de VAR/Granger queda reservada para el bloque de Clase 8,
  porque ahi encaja conceptualmente.
