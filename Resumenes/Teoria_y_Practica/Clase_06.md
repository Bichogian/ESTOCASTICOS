# Clase 6 - Teoria + practica + Python

[← Volver al indice general](../Res+Pra.md)

Esta guia cruza la teoria de la Clase 6 con el notebook de procesos
autorregresivos/ARMA y la Ejercitacion 5. El eje de la clase es entender como se
modela la dependencia temporal: cuando los errores o una serie no son
independientes en el tiempo, necesitamos representar esa dependencia con pocos
parametros.

El recorrido de cada tema es:

```text
microteoria -> en Python lo hacemos asi -> que significa -> idea para recordar
```

## Archivos que vamos a usar

| Tipo | Archivo | Para que se usa |
|---|---|---|
| Teoria | `Clases/MIA103_Clase_6.pdf` | Reparametrizacion de errores, ruido blanco, AR, MA, ARMA, autocovarianza, ACF, PACF y Durbin-Watson |
| Python | `Codigos/MIA103_2026_Clase_06_Procesos_autorregresivos_ARMA.ipynb` | Simulacion de ruido blanco, AR(1), AR(2), MA, ARMA y graficos ACF/PACF |
| Practica | `Practicas/MIA103_Ejer_5_.pdf` | Simulacion manual en Excel/Python de ruido blanco, AR(1), shocks y random walk |
| Solucion Python | `Practicas/MIA103_2026_Clase_06_Resolución_Ejercitación_5.ipynb` | Resolucion en Python de la Ejercitacion 5 |

## Que notebook usamos para cada tema

| Paso | Tema | Notebook o archivo |
|---:|---|---|
| 1 | Introduccion a series de tiempo y matriz de errores | PDF Clase 6 |
| 2 | Ruido blanco | PDF y notebook `Clase_06_Procesos_autorregresivos_ARMA` |
| 3 | AR(1), AR(2), AR(p) | PDF, notebook de clase y Ejercitacion 5 |
| 4 | MA(1), MA(2), MA(q) | PDF y notebook de clase |
| 5 | ARMA(p,q) | PDF y notebook de clase |
| 6 | Random walk, IMA y ARIMA | PDF y Ejercitacion 5 |
| 7 | AR(1) como MA infinito | PDF Clase 6 |
| 8 | Autocovarianza y autocorrelacion | PDF Clase 6 |
| 9 | ACF y PACF | PDF, notebook de clase y Ejercitacion 5 |
| 10 | Durbin-Watson | PDF Clase 6 |
| 11 | Shock en AR(1) y velocidad de retorno | Ejercitacion 5 |

---

## 1. Por que series de tiempo es distinto

### Microresumen teorico

En una serie de tiempo las observaciones tienen un orden natural:

```text
t = 1, 2, ..., T
```

Por eso dejamos de usar `i` como subindice y usamos `t`. La observacion de hoy
puede estar relacionada con la de ayer, la de anteayer, etc.

Si partimos de una regresion:

```text
y_t = alpha + beta x_t + u_t
```

el supuesto clasico que empieza a estar en peligro es la no autocorrelacion de
los errores:

```text
Cov(u_t, u_s) = 0 si t != s
```

En series temporales es bastante natural que este supuesto falle. Un shock no
siempre desaparece instantaneamente: puede arrastrarse durante varios periodos.

### Que significa

La dependencia temporal no es un detalle tecnico. Es parte del fenomeno que
queremos estudiar. Si los errores estan autocorrelacionados, la matriz de
varianzas y covarianzas ya no es simplemente `sigma^2 I`.

En general:

```text
Omega =
[
Var(u_1)      Cov(u_1,u_2)  ... Cov(u_1,u_T)
Cov(u_2,u_1)  Var(u_2)      ... Cov(u_2,u_T)
...
Cov(u_T,u_1)  Cov(u_T,u_2)  ... Var(u_T)
]
```

Con `T` observaciones hay:

```text
T varianzas
T(T-1)/2 covarianzas
T(T+1)/2 elementos distintos en total
```

Eso es imposible de estimar libremente con solo `T` datos. Por eso la clase
introduce reparametrizaciones: estructuras simples para describir muchas
covarianzas con pocos parametros.

### Idea para recordar

En series de tiempo no podemos estimar una covarianza distinta para cada par de
fechas. Necesitamos imponer estructura: ruido blanco, AR, MA, ARMA, etc.

---

## 2. Ruido blanco

### Microresumen teorico

Un proceso `epsilon_t` es ruido blanco debil si cumple:

```text
E(epsilon_t) = 0 para todo t
Var(epsilon_t) = sigma_epsilon^2 para todo t
Cov(epsilon_t, epsilon_{t-j}) = 0 para j != 0
```

Esto significa:

- media cero;
- varianza constante;
- ausencia de autocorrelacion.

Si, ademas de no estar autocorrelacionado, el proceso es independiente en el
tiempo, se habla de ruido blanco fuerte.

### En Python lo hacemos asi

Notebook: `MIA103_2026_Clase_06_Procesos_autorregresivos_ARMA.ipynb`.

```python
np.random.seed(42)

T = 500
epsilon = np.random.normal(loc=0, scale=1, size=T)

plt.plot(epsilon)
plt.title('Simulación de Ruido Blanco')
```

En la practica se generan 100 observaciones:

```python
n = 100
aleatorios = np.random.standard_normal(n)
```

### Que significa

El ruido blanco es el bloque basico de los modelos de series temporales. Es lo
que queda cuando ya no hay estructura sistematica por explicar.

No hay que confundir:

- ruido blanco: no autocorrelacion, media cero, varianza constante;
- normalidad: forma de la distribucion marginal;
- independencia: condicion mas fuerte que no autocorrelacion.

Un ruido blanco puede no ser normal. Y un proceso normal en cada periodo podria
tener autocorrelacion, en cuyo caso no seria ruido blanco.

### Idea para recordar

Cuando un modelo de series esta bien especificado, sus residuos deberian parecer
ruido blanco. Si los residuos todavia tienen autocorrelacion, falta dinamica por
modelar.

---

## 3. Procesos autorregresivos AR

### Microresumen teorico

Un proceso autorregresivo usa rezagos de la propia variable para explicar su
valor actual.

Un AR(1) es:

```text
u_t = rho u_{t-1} + epsilon_t
```

Un AR(2):

```text
u_t = rho_1 u_{t-1} + rho_2 u_{t-2} + epsilon_t
```

Un AR(p):

```text
u_t = rho_1 u_{t-1} + rho_2 u_{t-2}
      + ... + rho_p u_{t-p} + epsilon_t
```

`epsilon_t` siempre representa ruido blanco.

### Que significa

En un AR, el presente depende del pasado de la misma serie. Si `rho` es positivo,
un valor alto tiende a ser seguido por valores altos. Si `rho` es negativo, puede
haber alternancia: valores positivos tienden a ser seguidos por valores negativos
y viceversa.

En un AR(1):

- `rho = 0`: no hay persistencia; queda ruido blanco.
- `0 < rho < 1`: persistencia positiva y retorno gradual.
- `rho` cercano a 1: alta persistencia.
- `rho = 1`: random walk.
- `rho < 0`: comportamiento oscilante.

### En Python lo hacemos manualmente

La practica define:

```python
def proceso_ar(rho, y_prev, error):
    return rho * y_prev + error

def simular_proceso_ar(rho, n, errores):
    y = np.zeros(n)
    y[0] = errores[0]
    for i in range(1, n):
        y[i] = proceso_ar(rho, y[i-1], errores[i])
    return y
```

Y genera dos AR(1):

```python
ar_0_5 = simular_proceso_ar(0.5, n, aleatorios)
ar_0_9 = simular_proceso_ar(0.9, n, aleatorios)
```

### Que significa

Ambos usan exactamente los mismos shocks `epsilon_t`. La diferencia es cuanto se
arrastra cada shock por el parametro `rho`.

Con `rho = 0.5`, el impacto se reduce rapido:

```text
shock, 0.5*shock, 0.5^2*shock, 0.5^3*shock, ...
```

Con `rho = 0.9`, el impacto cae mucho mas lento:

```text
shock, 0.9*shock, 0.9^2*shock, 0.9^3*shock, ...
```

### Idea para recordar

`rho` mide persistencia. Cuanto mas cerca de 1, mas memoria tiene la serie.

---

## 4. AR(1) estacionario: media, varianza y persistencia

### Microresumen teorico

Para:

```text
u_t = rho u_{t-1} + epsilon_t
```

si:

```text
|rho| < 1
```

el proceso es estacionario.

Como `epsilon_t` tiene media cero, la media de `u_t` es cero:

```text
E(u_t) = 0
```

La varianza teorica es:

```text
Var(u_t) = sigma_epsilon^2 / (1 - rho^2)
```

### Que significa

La varianza del AR(1) es mayor que la varianza del ruido blanco cuando `rho` es
distinto de cero. Esto ocurre porque los shocks se acumulan parcialmente.

Si `rho` aumenta, `1-rho^2` baja y la varianza sube. Por eso un AR(1) con
`rho=0.9` suele verse mucho mas persistente y amplio que uno con `rho=0.5`.

### Burn-in en simulaciones

El notebook aclara que si se fuerza:

```text
u_0 = epsilon_0
```

la primera observacion tiene varianza `sigma^2`, pero la varianza estacionaria
teorica deberia ser:

```text
sigma^2 / (1-rho^2)
```

Por eso los simuladores profesionales suelen usar `burn-in`: generan
observaciones iniciales que se descartan para que la serie simulada arranque mas
cerca de su distribucion estacionaria.

### Idea para recordar

En un AR(1) estacionario los shocks no desaparecen inmediatamente, pero tampoco
son permanentes. Se disipan a una velocidad gobernada por `rho`.

---

## 5. AR(1) como MA infinito

### Microresumen teorico

La clase demuestra que un AR(1) estacionario puede escribirse como un MA infinito.

Partimos de:

```text
u_t = rho u_{t-1} + epsilon_t
```

Reemplazando hacia atras:

```text
u_t = epsilon_t + rho epsilon_{t-1}
      + rho^2 epsilon_{t-2}
      + rho^3 epsilon_{t-3} + ...
```

En forma compacta:

```text
u_t = sum_{j=0}^{infinito} rho^j epsilon_{t-j}
```

Esto requiere que:

```text
|rho| < 1
```

para que los pesos `rho^j` se vayan achicando.

### Que significa

Un AR(1) puede pensarse como una memoria infinita de shocks pasados, pero con
pesos decrecientes. El shock actual entra con peso 1, el de ayer con peso `rho`,
el de anteayer con `rho^2`, y asi sucesivamente.

Esto explica por que:

- si `rho=0.5`, la memoria cae rapido;
- si `rho=0.9`, la memoria cae lento;
- si `rho=1`, la memoria no cae y el proceso deja de ser estacionario.

### Idea para recordar

AR(1) estacionario = suma infinita de shocks pasados con pesos que se achican.

---

## 6. Procesos de medias moviles MA

### Microresumen teorico

Un MA usa shocks presentes y shocks pasados para explicar el valor actual.

Un MA(1):

```text
u_t = theta epsilon_{t-1} + epsilon_t
```

Un MA(2):

```text
u_t = theta_1 epsilon_{t-1}
      + theta_2 epsilon_{t-2}
      + epsilon_t
```

Un MA(q):

```text
u_t = theta_1 epsilon_{t-1}
      + theta_2 epsilon_{t-2}
      + ... + theta_q epsilon_{t-q}
      + epsilon_t
```

### Que significa

En un MA(q), un shock afecta a la serie durante una cantidad finita de periodos.
Pasado el rezago `q`, ese shock ya no aparece directamente.

Esto contrasta con un AR(1), donde el shock puede seguir afectando infinitamente,
aunque cada vez menos si el proceso es estacionario.

### En Python lo hacemos manualmente

Para MA(1):

```python
theta1 = 0.8
y_ma1 = np.zeros(n)
y_ma1[0] = epsilon[0]

for i in range(1, n):
    y_ma1[i] = epsilon[i] + theta1 * epsilon[i - 1]
```

Con `statsmodels`:

```python
ar_params_base = np.array([1])
ma1_params = np.array([1, theta1])
ma1_process = ArmaProcess(ar_params_base, ma1_params)
uma1 = ma1_process.generate_sample(nsample=T)
```

### Idea para recordar

AR usa rezagos de la variable. MA usa rezagos de los shocks.

---

## 7. ARMA

### Microresumen teorico

Un ARMA combina parte autorregresiva y parte de medias moviles.

Un ARMA(1,1):

```text
u_t = rho u_{t-1} + theta epsilon_{t-1} + epsilon_t
```

Un ARMA(p,q):

```text
u_t = rho_1 u_{t-1} + ... + rho_p u_{t-p}
      + theta_1 epsilon_{t-1} + ... + theta_q epsilon_{t-q}
      + epsilon_t
```

### Que significa

La parte AR captura persistencia por rezagos de la serie. La parte MA captura
efectos de shocks pasados que entran directamente.

En datos reales, muchas series no son AR puro ni MA puro. ARMA permite combinar
ambos mecanismos.

### En Python

En `statsmodels`, un proceso ARMA se simula con dos arreglos:

```python
ar_params_arma = np.array([1, -rho])
ma_params_arma = np.array([1, theta1])

proceso_arma = ArmaProcess(ar_params_arma, ma_params_arma)
y_arma = proceso_arma.generate_sample(500)
```

Alerta: en la parte AR, `statsmodels` pide los signos invertidos. Si el modelo es:

```text
u_t = 0.7 u_{t-1} + epsilon_t
```

se ingresa:

```python
ar = np.array([1, -0.7])
```

La parte MA se ingresa con el signo directo:

```python
ma = np.array([1, theta])
```

### Idea para recordar

En la notacion ARMA(p,q), `p` cuenta rezagos de la variable y `q` cuenta rezagos
del shock.

---

## 8. Random walk, IMA y ARIMA

### Random walk

Un random walk es un caso particular de AR(1) con:

```text
rho = 1
```

Entonces:

```text
u_t = u_{t-1} + epsilon_t
```

### Que significa

Cada shock tiene efecto permanente. Si hoy aparece un shock positivo, el nivel
de la serie queda desplazado hacia arriba para siempre, salvo que futuros shocks
lo compensen.

Por eso el random walk no revierte a una media fija. No es estacionario.

### IMA

Un IMA(1) aparece cuando la primera diferencia es MA(1):

```text
Delta u_t = u_t - u_{t-1}
Delta u_t = theta epsilon_{t-1} + epsilon_t
```

### ARIMA

Un ARIMA(p,1,q) significa que la primera diferencia de la serie sigue un
ARMA(p,q):

```text
Delta u_t es ARMA(p,q)
```

Por ejemplo, ARIMA(1,1,1):

```text
Delta u_t = rho Delta u_{t-1}
            + theta epsilon_{t-1}
            + epsilon_t
```

### Idea para recordar

ARMA se usa para series estacionarias. ARIMA aparece cuando hay que diferenciar
para lograr estacionariedad.

---

## 9. Autocovarianza y autocorrelacion

### Microresumen teorico

La funcion de autocovarianza es:

```text
gamma_s = Cov(u_t, u_{t-s})
```

La funcion de autocorrelacion es:

```text
rho_s = Corr(u_t, u_{t-s}) = gamma_s / gamma_0
```

`gamma_0` es la varianza de la serie.

La clase supone estacionariedad para que estas funciones dependan solo del
rezago `s`, no del momento exacto `t`.

### MA(1)

Si:

```text
u_t = theta epsilon_{t-1} + epsilon_t
```

entonces:

```text
gamma_0 = (1 + theta^2) sigma_epsilon^2
gamma_1 = theta sigma_epsilon^2
gamma_s = 0 para s >= 2
```

Y:

```text
rho_1 = theta / (1 + theta^2)
rho_s = 0 para s >= 2
```

### MA(2)

Si:

```text
u_t = theta_1 epsilon_{t-1}
      + theta_2 epsilon_{t-2}
      + epsilon_t
```

entonces:

```text
gamma_0 = (1 + theta_1^2 + theta_2^2) sigma_epsilon^2
gamma_1 = theta_1(1 + theta_2) sigma_epsilon^2
gamma_2 = theta_2 sigma_epsilon^2
gamma_s = 0 para s >= 3
```

En general, para un MA(q), la ACF se corta despues del rezago `q`.

### AR(1)

Si:

```text
u_t = rho u_{t-1} + epsilon_t
```

con `|rho| < 1`, entonces:

```text
gamma_0 = sigma_epsilon^2 / (1-rho^2)
gamma_s = rho^s gamma_0
```

La autocorrelacion es:

```text
rho_s = rho^s
```

### Idea para recordar

La ACF de un MA(q) corta. La ACF de un AR(1) decae geometricamente.

---

## 10. ACF y PACF

### Microresumen teorico

La ACF mide correlacion entre la serie y sus rezagos:

```text
Corr(u_t, u_{t-s})
```

La PACF mide la correlacion parcial con un rezago despues de controlar por los
rezagos intermedios.

La clase explica la PACF como coeficientes de regresiones sucesivas:

```text
u_t contra u_{t-1}                         -> PACF rezago 1
u_t contra u_{t-1}, u_{t-2}                -> PACF rezago 2
u_t contra u_{t-1}, u_{t-2}, u_{t-3}       -> PACF rezago 3
```

En cada caso se mira el coeficiente del rezago mas lejano.

### Regla practica

| Proceso | ACF | PACF |
|---|---|---|
| AR(p) | Decae gradualmente | Corta despues de p |
| MA(q) | Corta despues de q | Decae gradualmente |
| ARMA(p,q) | Decae gradualmente | Decae gradualmente |

### En Python

```python
from statsmodels.graphics.tsaplots import plot_acf, plot_pacf

plot_acf(serie, lags=20)
plot_pacf(serie, lags=20)
```

El notebook compara:

```python
series = {
    'AR(1)': simular_proceso(ar1_params, ma_params_base, n),
    'AR(2)': simular_proceso(ar2_params, ma_params_base, n),
    'MA(1)': simular_proceso(ar_params_base, ma1_params, n),
    'MA(4)': simular_proceso(ar_params_base, theta_ma4, n),
    'ARMA(1,1)': y_arma,
}
```

y para cada serie grafica:

```text
serie temporal | ACF | PACF
```

### Que significa

ACF y PACF no son tests magicos, son diagnosticos visuales. En muestras finitas
hay ruido, por eso los cortes no siempre son perfectos. Sirven para elegir
modelos candidatos, no para cerrar una conclusion sin revisar residuos.

### Idea para recordar

ACF mira memoria total con cada rezago. PACF mira el aporte propio de un rezago
despues de descontar los anteriores.

---

## 11. Durbin-Watson

### Microresumen teorico

Durbin-Watson testea autocorrelacion de orden 1 en residuos de una regresion MCO.

El estadistico es:

```text
DW = sum_{t=2}^{T} (e_t - e_{t-1})^2 / sum_{t=1}^{T} e_t^2
```

Siempre esta entre 0 y 4.

Lectura aproximada:

```text
DW cerca de 2   -> no hay autocorrelacion AR(1) evidente
DW cerca de 0   -> autocorrelacion positiva
DW cerca de 4   -> autocorrelacion negativa
```

La decision formal usa valores criticos `dL` y `dU`, que dependen de `T` y de la
cantidad de pendientes del modelo.

### Reglas del PDF

Si `DW < 2`:

- si `DW < dL`, se rechaza no autocorrelacion y se concluye autocorrelacion
  positiva;
- si `dL < DW < dU`, el test es inconcluso;
- si `DW > dU`, no se rechaza no autocorrelacion.

Si `DW > 2`, se usa:

```text
4 - DW
```

y se compara de forma analoga para detectar autocorrelacion negativa.

### Idea para recordar

Durbin-Watson mira autocorrelacion de primer orden en residuos de una regresion,
no identifica automaticamente todo tipo de dependencia temporal.

---

## 12. Ejercitacion 5 - Simulacion de AR(1)

### Que pide la practica

La ejercitacion pide:

1. Generar 100 observaciones de ruido blanco normal estandar.
2. Usar esos shocks para construir:

```text
y_t = 0.5 y_{t-1} + epsilon_t
y_t = 0.9 y_{t-1} + epsilon_t
```

3. Graficar ruido blanco y ambos AR(1).
4. Repetir simulaciones.
5. Discutir media cero y reversion a la media.
6. Estimar `rho` por MCO sin constante.
7. Graficar ACF y PACF.
8. Introducir un shock igual a 3.
9. Comparar con random walk.
10. Probar valores de `rho` cercanos a 1, mayores a 1 y negativos.

### Construccion en Python

```python
n = 100
aleatorios = np.random.standard_normal(n)

ar_0_5 = simular_proceso_ar(0.5, n, aleatorios)
ar_0_9 = simular_proceso_ar(0.9, n, aleatorios)

df = pd.DataFrame({
    'white_noise': aleatorios,
    'AR(1)0.5': ar_0_5,
    'AR(1)0.9': ar_0_9
})
```

### Que deberia verse en el grafico

El ruido blanco oscila alrededor de cero sin memoria clara.

El AR(1) con `rho=0.5` tambien oscila alrededor de cero, pero muestra algo de
persistencia. Luego de un shock, vuelve relativamente rapido.

El AR(1) con `rho=0.9` muestra mucha mas persistencia. Se aleja mas tiempo de la
media y vuelve mas lento.

### Por que tienen media cero

Si:

```text
y_t = rho y_{t-1} + epsilon_t
```

y `E(epsilon_t)=0`, para un AR(1) estacionario sin constante:

```text
E(y_t) = rho E(y_{t-1}) + 0
```

En estacionariedad `E(y_t)=E(y_{t-1})=mu`, entonces:

```text
mu = rho mu
(1-rho)mu = 0
mu = 0 si rho != 1
```

Si hubiera una constante:

```text
y_t = c + rho y_{t-1} + epsilon_t
```

la media estacionaria seria:

```text
mu = c / (1-rho)
```

### Idea para recordar

La media cero no sale de que el grafico "parezca centrado"; sale de la ecuacion y
de que el ruido blanco tiene esperanza cero.

---

## 13. Estimar el AR(1) por MCO

### Microresumen teorico

Si el proceso es:

```text
y_t = rho y_{t-1} + u_t
```

podemos estimar `rho` regresando `y_t` contra `y_{t-1}` sin constante.

### En Python

```python
df["AR(1)0.5_lag"] = df["AR(1)0.5"].shift(1)
df["AR(1)0.9_lag"] = df["AR(1)0.9"].shift(1)
df_reg = df.dropna()

X_05 = df_reg[["AR(1)0.5_lag"]]
y_05 = df_reg["AR(1)0.5"]
modelo_05 = sm.OLS(y_05, X_05).fit()

X_09 = df_reg[["AR(1)0.9_lag"]]
y_09 = df_reg["AR(1)0.9"]
modelo_09 = sm.OLS(y_09, X_09).fit()
```

### Que significa

La estimacion no va a dar exactamente `0.5` y `0.9` porque tenemos una muestra
finita de shocks aleatorios. Pero deberia acercarse razonablemente, sobre todo
si aumentamos el tamaño muestral.

No se agrega constante porque el proceso simulado no tiene constante y su media
teorica es cero.

### Idea para recordar

Estimar un AR(1) es muy parecido a una regresion de la serie contra su rezago,
pero la interpretacion es dinamica: el coeficiente mide persistencia temporal.

---

## 14. Introducir un shock

### Que hace la practica

La practica cambia una observacion del ruido blanco:

```python
aleatorios_shock = aleatorios.copy()
aleatorios_shock[14] = 3
```

Luego vuelve a generar:

```python
ar_0_5_shock = simular_proceso_ar(0.5, n, aleatorios_shock)
ar_0_9_shock = simular_proceso_ar(0.9, n, aleatorios_shock)
```

### Que significa

El shock entra en el periodo 15. A partir de ahi, afecta el AR(1) no solo en ese
periodo, sino tambien en los siguientes.

En `rho=0.5`, el efecto cae rapido:

```text
3, 1.5, 0.75, 0.375, ...
```

En `rho=0.9`, cae lento:

```text
3, 2.7, 2.43, 2.187, ...
```

### Idea para recordar

La diferencia entre `rho=0.5` y `rho=0.9` se ve muy claro con shocks: ambos
retornan a la media si `|rho|<1`, pero uno vuelve mucho mas lento.

---

## 15. Random walk en la practica

### Construccion

La practica pide cambiar `rho` a 1:

```python
random_walk = simular_proceso_ar(1, n, aleatorios)
```

Entonces:

```text
y_t = y_{t-1} + epsilon_t
```

### Que deberia verse

El random walk no vuelve sistematicamente a cero. Puede alejarse durante mucho
tiempo porque cada shock se suma al nivel acumulado.

No tiene media constante en el mismo sentido estacionario que un AR(1) con
`|rho|<1`. Los shocks son permanentes.

### Comparacion

| Proceso | Retorna a media? | Persistencia del shock |
|---|---|---|
| Ruido blanco | No necesita retornar: no tiene memoria | Ninguna |
| AR(1), rho=0.5 | Si | Baja |
| AR(1), rho=0.9 | Si, pero lento | Alta |
| Random walk, rho=1 | No en sentido estacionario | Permanente |

### Idea para recordar

`rho=1` es la frontera critica. Pasamos de shocks transitorios a shocks
permanentes.

---

## 16. Valores de rho cercanos a 1, mayores a 1 y negativos

### Rho cercano a 1

Si:

```text
rho = 0.95, 0.97, 0.99
```

el proceso todavia puede ser estacionario, pero es extremadamente persistente.
En muestras cortas puede parecer casi un random walk.

### Rho mayor a 1

Si:

```text
rho = 1.01, 1.05
```

el proceso es explosivo. Los shocks no solo persisten: se amplifican.

### Rho negativo

Si:

```text
rho = -0.5, -0.9, -0.99
```

el proceso alterna signos. Un valor positivo tiende a ser seguido por uno
negativo, y viceversa. Si el valor absoluto esta cerca de 1, la alternancia es
persistente.

### Idea para recordar

La estacionariedad de un AR(1) depende de `|rho|<1`, no solamente de `rho<1`.

---

## 17. Checklist de Clase 6

Al terminar esta clase deberias poder explicar:

1. Por que en series temporales preocupa la autocorrelacion de errores.
2. Por que no podemos estimar libremente toda la matriz `Omega`.
3. Que significa reparametrizar los errores.
4. Que condiciones definen un ruido blanco debil.
5. La diferencia entre ruido blanco debil, fuerte y normalidad.
6. Que es un AR(1), AR(2) y AR(p).
7. Que mide `rho` en un AR(1).
8. Por que `|rho|<1` implica estacionariedad en AR(1).
9. Como se calcula la varianza teorica de un AR(1).
10. Por que un AR(1) estacionario puede escribirse como MA infinito.
11. Que es un MA(1), MA(2) y MA(q).
12. Por que la ACF de un MA(q) corta despues de `q`.
13. Que combina un ARMA(p,q).
14. Que es un random walk y por que no revierte a la media.
15. Que significa ARIMA(p,1,q).
16. Como leer ACF y PACF.
17. Que detecta Durbin-Watson.
18. Que ocurre con un shock cuando `rho=0.5` frente a `rho=0.9`.
19. Que pasa cuando `rho` se acerca a 1, supera 1 o es negativo.

## Observaciones tecnicas antes de ejecutar

- La practica original pide hacerlo en Excel, pero la resolucion Python reproduce
  la misma logica con arrays y DataFrames.
- La practica no fija semilla antes de generar `aleatorios`, por lo que los
  numeros exactos pueden cambiar entre ejecuciones.
- Para comparar procesos, lo importante es usar los mismos shocks en cada AR(1).
- `statsmodels.tsa.arima_process.ArmaProcess` usa el signo invertido en la parte
  AR: para `rho=0.7`, se ingresa `[1, -0.7]`.
- Si se usa simulacion profesional, el `burn-in` puede hacer que los primeros
  valores no coincidan con una simulacion manual que fija `y_0 = epsilon_0`.
- ACF/PACF son guias visuales: siempre conviene revisar tambien residuos y
  coherencia teorica.
