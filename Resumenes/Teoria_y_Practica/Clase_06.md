# Clase 6 - Series de tiempo: ruido blanco, AR, MA, ARMA y correlogramas

[Volver al indice general](../Res+Pra.md)

Mapa completo de la Clase 6: teoria del PDF, codigo de los notebooks y
Ejercitacion 5. Cada tema sigue el mismo recorrido:

$$\text{teoria} \;\rightarrow\; \text{para que sirve} \;\rightarrow\; \text{codigo generico} \;\rightarrow\; \text{como leer la salida}$$

## Archivos de esta clase

| Tipo | Archivo | Para que se usa |
|---|---|---|
| Teoria | `Clases/MIA103_Clase_6.pdf` | Ruido blanco, AR, MA, ARMA, autocovarianzas, ACF/PACF, Durbin-Watson |
| Python | `Codigos/MIA103_2026_Clase_06_Procesos_autorregresivos_ARMA.ipynb` | Simular todos los procesos y comparar sus ACF/PACF |
| Python | `Practicas/MIA103_2026_Clase_06_Resolución_Ejercitación_5.ipynb` | Resolucion de la practica en Python |
| Practica | `Practicas/MIA103_Ejer_5_.pdf` | Simular AR(1) con distintos $\rho$, shocks y random walk |
| Practica | `Practicas/MIA103_Ejer_6_.pdf` | Precios y dinero (usa ADF de Clase 7 + correlogramas de esta) |
| Resuelta | `Practicas_Resueltas/Respuestas_5.ipynb` / `Respuestas_6.ipynb` | Resoluciones propias |
| Datos | `Bases de Datos MIA103/Precios_y_Dinero.xlsx` | Para la Ejercitacion 6 |

## Mapa tema - PDF - notebook - practica

| # | Tema | PDF | Notebook | Practica |
|---:|---|---|---|---|
| 1 | El problema de la autocorrelacion | p. 2-5 | - | - |
| 2 | Ruido blanco | p. 6-7 | `Clase_06` celda 4 | Ej. 5.1 |
| 3 | Procesos AR | p. 8 | `Clase_06` celdas 6-12 | Ej. 5.2, 5.3 |
| 4 | Procesos MA | p. 9 | `Clase_06` celdas 14-20 | - |
| 5 | ARMA, IMA, ARIMA | p. 10-11 | `Clase_06` celdas 22-23 | - |
| 6 | Random walk | p. 11 | - | Ej. 5.10 |
| 7 | AR(1) = MA($\infty$) | p. 12 | - | Ej. 5.6 |
| 8 | Autocovarianza y autocorrelacion | p. 13-14 | - | - |
| 9 | ACF de MA(1) y MA(2) | p. 14-18 | - | - |
| 10 | ACF de AR(1) | p. 19-23 | - | - |
| 11 | ACF y PACF: identificacion | p. 23-24 | `Clase_06` celda 27 | Ej. 5.8, 6.5, 6.6 |
| 12 | Estadistico Durbin-Watson | p. 25-27 | - | Ej. 6.7 |

---

# Parte A - Por que hace falta reparametrizar

## 1. El problema en series de tiempo

### Teoria

En series de tiempo escribimos:

$$y_t = \alpha + \beta x_t + u_t, \qquad t = 1,2,\dots,T$$

Usamos $t$ en vez de $i$ y $T$ en vez de $n$ para marcar que **las observaciones
tienen un orden natural**.

El problema es que el **Supuesto 2b (no autocorrelacion de los errores) muy
posiblemente no se cumpla**: en una serie de tiempo, el error de hoy suele estar
relacionado con el de ayer.

### El conteo que hace inviable el enfoque directo

Con $T$ errores, la matriz $\boldsymbol\Omega$ de varianzas y covarianzas tiene:

$$T \text{ varianzas} \;+\; \frac{T(T-1)}{2} \text{ covarianzas} \;=\; \frac{T(T+1)}{2} \text{ parametros}$$

| $T$ | varianzas | covarianzas | total |
|---|---|---|---|
| 5 | 5 | 10 | 15 |
| 10 | 10 | 45 | 55 |
| 100 | 100 | 4950 | 5050 |

**Con 100 observaciones habria que estimar 5050 parametros.** Es imposible: hay
mas parametros que datos.

### La solucion: reparametrizar

La idea es **imponer una estructura** a los errores de modo que esas
$\frac{T(T+1)}{2}$ varianzas y covarianzas queden determinadas por **unos pocos
parametros**.

Ese es el sentido de todo lo que sigue: AR, MA y ARMA son formas de reparametrizar
$\boldsymbol\Omega$. Un AR(1) reduce 5050 parametros a **dos** ($\rho$ y
$\sigma_\varepsilon^2$).

### Idea para recordar

AR, MA y ARMA no son "modelos de moda": son la respuesta al problema de que
$\boldsymbol\Omega$ tiene mas parametros que observaciones.

---

## 2. Ruido blanco

### Teoria

$\varepsilon_t$ es **ruido blanco** si cumple las tres condiciones:

$$\text{(a)}\; E(\varepsilon_t) = 0 \;\;\forall t \qquad \text{(b)}\; Var(\varepsilon_t)=\sigma_\varepsilon^2 \;\;\forall t \qquad \text{(c)}\; Cov(\varepsilon_t,\varepsilon_{t-j})=0 \;\;\forall t,\; j\ne0$$

Media cero, varianza constante, sin autocorrelacion. **Son exactamente los
errores con los que trabajamos hasta la Clase 5.**

### Convencion de notacion

De aca en adelante, **cada vez que aparezca $\varepsilon_t$ significa ruido
blanco**. Los $u_t$ son los errores del modelo, que ahora pueden tener estructura.

### Debil vs fuerte

- **Debil**: la definicion de arriba (no correlacion).
- **Fuerte**: reemplaza la condicion (c) por **independencia**.

No correlacion no implica independencia salvo bajo normalidad. En la practica del
curso se trabaja con el debil.

### Codigo generico

```python
import numpy as np

np.random.seed(42)
T = 500
epsilon = np.random.normal(loc=0, scale=1, size=T)

plt.plot(epsilon)
plt.title("Simulacion de ruido blanco")
```

### Como leer la salida

El grafico se ve como una banda de ruido alrededor de cero, **sin patron, sin
tendencia y con amplitud constante**. Si al graficar una serie ves eso, es ruido
blanco. Si ves tramos que se quedan arriba o abajo por varios periodos, hay
autocorrelacion.

---

# Parte B - Los procesos

## 3. Procesos autorregresivos (AR)

### Teoria

$$AR(1):\quad u_t = \rho\,u_{t-1} + \varepsilon_t$$
$$AR(2):\quad u_t = \rho_1 u_{t-1} + \rho_2 u_{t-2} + \varepsilon_t$$
$$AR(p):\quad u_t = \rho_1 u_{t-1} + \cdots + \rho_p u_{t-p} + \varepsilon_t$$

con $\varepsilon_t$ ruido blanco.

### Para que sirve

Modela **persistencia**: el valor de hoy depende del de ayer. Cuanto mas grande
$|\rho|$, mas memoria tiene el proceso y mas lento vuelve a su media.

### Codigo generico - version manual

```python
def simular_ar1(rho, n, errores):
    y = np.zeros(n)
    y[0] = errores[0]
    for i in range(1, n):
        y[i] = rho * y[i-1] + errores[i]
    return y
```

### Codigo generico - con `statsmodels`

```python
from statsmodels.tsa.arima_process import ArmaProcess

rho = 0.7

ar_params = np.array([1, -rho])     # OJO: signo invertido y lag 0
ma_params = np.array([1])           # sin parte MA

proceso = ArmaProcess(ar_params, ma_params)
u = proceso.generate_sample(nsample=500)
```

**La trampa del signo**: `ArmaProcess` pide el polinomio caracteristico. El
proceso $u_t = 0.7u_{t-1}+\varepsilon_t$ se escribe
$(1 - 0.7L)u_t = \varepsilon_t$, asi que `ar = [1, -0.7]`.

Para un AR(2) con $\rho_1=0.7$ y $\rho_2=-0.2$: `ar = [1, -0.7, 0.2]`.

### Manual vs libreria: cual usar

| | Manual | `ArmaProcess` |
|---|---|---|
| Valor inicial | $y_0 = \varepsilon_0$, con varianza $\sigma^2$ | descarta observaciones iniciales (burn-in) |
| Estacionariedad | los primeros valores **no** son estacionarios | toda la serie es estacionaria |

La varianza teorica de un AR(1) estacionario es $\sigma^2/(1-\rho^2)$, mayor que
$\sigma^2$. Al forzar $y_0=\varepsilon_0$ el arranque tiene varianza demasiado
chica y la serie tarda en "calentarse". Por eso para analisis serio conviene
`ArmaProcess`; la version manual es la que pide la practica porque replica el
Excel.

Para usar el **mismo** ruido blanco en las dos:

```python
u = proceso.generate_sample(nsample=100, distrvs=lambda size: aleatorios)
```

---

## 4. Procesos de medias moviles (MA)

### Teoria

$$MA(1):\quad u_t = \theta\,\varepsilon_{t-1} + \varepsilon_t$$
$$MA(2):\quad u_t = \theta_1\varepsilon_{t-1} + \theta_2\varepsilon_{t-2} + \varepsilon_t$$
$$MA(q):\quad u_t = \theta_1\varepsilon_{t-1} + \cdots + \theta_q\varepsilon_{t-q} + \varepsilon_t$$

### Para que sirve

Modela **memoria corta y finita**: un shock afecta solo durante $q$ periodos y
despues desaparece por completo. Es la diferencia esencial con AR, donde el shock
se disipa gradualmente pero nunca del todo.

### Codigo generico

```python
theta1 = 0.8

ar_params = np.array([1])              # sin parte AR
ma_params = np.array([1, theta1])      # signo NORMAL, lag 0 incluido

proceso = ArmaProcess(ar_params, ma_params)
u = proceso.generate_sample(nsample=500)
```

**Asimetria importante**: los coeficientes AR van con **signo invertido**, los MA
con **signo normal**. Es la fuente de error mas comun al usar `ArmaProcess`.

Para $MA(4)$ con $\theta = (0.8,\,-0.4,\,0.3,\,0.2)$: `ma = [1, 0.8, -0.4, 0.3, 0.2]`.

---

## 5. ARMA, random walk, IMA y ARIMA

### Teoria

$$ARMA(1,1):\quad u_t = \rho u_{t-1} + \theta\varepsilon_{t-1} + \varepsilon_t$$

$$ARMA(p,q):\quad u_t = \sum_{j=1}^{p}\rho_j u_{t-j} + \sum_{j=1}^{q}\theta_j\varepsilon_{t-j} + \varepsilon_t$$

**Random walk**: caso particular del AR(1) con $\rho = 1$:

$$u_t = u_{t-1} + \varepsilon_t$$

**IMA(1)**: $\Delta u_t = u_t - u_{t-1}$ es MA(1):

$$u_t - u_{t-1} = \theta\varepsilon_{t-1} + \varepsilon_t$$

**ARIMA($p$,1,$q$)**: $\Delta u_t$ es ARMA($p,q$). El "I" es de **integrado**: hay
que diferenciar para llegar a un proceso estacionario.

### Codigo generico

```python
# ARMA(1,1)
ar = np.array([1, -rho])
ma = np.array([1, theta])
y = ArmaProcess(ar, ma).generate_sample(500)

# funcion auxiliar que generaliza todo
def simular_proceso(ar, ma, n=500, seed=123):
    np.random.seed(seed)
    return ArmaProcess(ar, ma).generate_sample(nsample=n)
```

Con esa funcion se simula cualquier proceso cambiando solo los dos arrays. Es la
generalizacion que hace el notebook.

---

## 6. AR(1) es un MA($\infty$)

### Teoria

Sustituyendo recursivamente en $u_t = \rho u_{t-1} + \varepsilon_t$:

$$u_t = \varepsilon_t + \rho u_{t-1} = \varepsilon_t + \rho\varepsilon_{t-1} + \rho^2 u_{t-2} = \cdots$$

$$\boxed{\;u_t = \sum_{j=0}^{\infty}\rho^{\,j}\varepsilon_{t-j}\;}$$

### Para que sirve

Tres consecuencias directas:

1. **$E(u_t)=0$**, porque cada ruido blanco tiene esperanza cero. (Es la respuesta
   al punto 6 de la Ejercitacion 5.)
2. Los coeficientes $\rho^j$ son la **funcion impulso-respuesta**: cuanto queda de
   un shock $j$ periodos despues.
3. Explica por que AR y MA no son categorias tan distintas: son dos formas de
   escribir lo mismo.

### La condicion $|\rho|<1$

La suma infinita converge solo si $|\rho|<1$. Es la condicion de
**estacionariedad** del AR(1). Con $\rho=1$ los coeficientes no decaen y la serie
acumula todos los shocks para siempre: es el random walk.

### Impulso-respuesta verificada

Efecto de un shock unitario en $t$, medido en $t+k$:

```text
rho=0.5:  1.000  0.500  0.250  0.125  0.062  0.031  0.016  0.008  ...  (t+10: 0.0010)
rho=0.9:  1.000  0.900  0.810  0.729  0.656  0.590  0.531  0.478  ...  (t+10: 0.3487)
rho=1.0:  1.000  1.000  1.000  1.000  1.000  1.000  1.000  1.000  ...  (t+10: 1.0000)
```

**Vida media del shock** ($\rho^k = 0.5 \Rightarrow k = \ln 0.5/\ln\rho$):

| $\rho$ | vida media |
|---|---|
| 0.5 | 1.0 periodo |
| 0.7 | 1.9 periodos |
| 0.9 | 6.6 periodos |
| 1.0 | **infinita** |

### Como leer esto

Es exactamente lo que pregunta el punto 9 de la practica. Con $\rho=0.5$ el shock
practicamente desaparece en 5 periodos; con $\rho=0.9$ despues de 10 periodos
todavia queda el 35%; con $\rho=1$ **nunca** desaparece.

---

# Parte C - Autocovarianzas y autocorrelaciones

## 7. Definiciones

### Teoria

$$\gamma_s = Cov(u_t, u_{t-s}), \qquad s = 0,1,2,\dots$$

$$\rho_s = Corr(u_t,u_{t-s}) = \frac{\gamma_s}{\gamma_0}, \qquad s=1,2,\dots$$

Notar que $\gamma_0 = Var(u_t)$ y $\rho_0 = 1$ siempre.

### Por que hace falta el supuesto de estacionariedad

Se supone que las series son **estacionarias** (concepto que se define
formalmente en la Clase 7, y que **no tiene nada que ver con estacionalidad**).

Lo que garantiza ese supuesto es que **$\gamma_s$ no depende del momento del
tiempo en que se evalua**, solo del rezago $s$. Sin eso, $\gamma_s$ seria distinto
en cada $t$ y no se podria dividir por un $\gamma_0$ unico.

---

## 8. ACF de los procesos MA

### MA(1): $u_t = \theta\varepsilon_{t-1}+\varepsilon_t$

$$\gamma_0 = Var(u_t) = E(\theta\varepsilon_{t-1}+\varepsilon_t)^2 = \theta^2\sigma_\varepsilon^2 + \sigma_\varepsilon^2 = (1+\theta^2)\sigma_\varepsilon^2$$

$$\gamma_1 = Cov(\theta\varepsilon_{t-1}+\varepsilon_t,\;\theta\varepsilon_{t-2}+\varepsilon_{t-1}) = \theta\sigma_\varepsilon^2$$

$$\gamma_2 = Cov(\theta\varepsilon_{t-1}+\varepsilon_t,\;\theta\varepsilon_{t-3}+\varepsilon_{t-2}) = 0$$

**La clave**: $\gamma_1 \ne 0$ porque los dos lados comparten $\varepsilon_{t-1}$.
$\gamma_2 = 0$ porque no comparten ningun $\varepsilon$.

$$\gamma_s = \begin{cases}(1+\theta^2)\sigma_\varepsilon^2 & s=0\\ \theta\sigma_\varepsilon^2 & s=1\\ 0 & s\ge2\end{cases} \qquad\qquad \rho_s = \begin{cases}1 & s=0\\ \dfrac{\theta}{1+\theta^2} & s=1\\ 0 & s\ge2\end{cases}$$

### MA(2): $u_t = \theta_1\varepsilon_{t-1}+\theta_2\varepsilon_{t-2}+\varepsilon_t$

$$\gamma_0 = (1+\theta_1^2+\theta_2^2)\sigma_\varepsilon^2 \qquad \gamma_1 = \theta_1(1+\theta_2)\sigma_\varepsilon^2 \qquad \gamma_2 = \theta_2\sigma_\varepsilon^2 \qquad \gamma_s = 0\;\; s\ge3$$

$$\rho_1 = \frac{\theta_1(1+\theta_2)}{1+\theta_1^2+\theta_2^2} \qquad\qquad \rho_2 = \frac{\theta_2}{1+\theta_1^2+\theta_2^2}$$

### El resultado general

$$\boxed{\text{Para un } MA(q),\;\; \rho_s = 0 \;\;\text{ para todo } s \ge q+1}$$

**La ACF de un MA se corta de golpe despues del rezago $q$.** Esa es la firma que
permite identificarlo.

### Ejemplos numericos verificados

```text
MA(1) con theta = 0.8:
    gamma_0 = 1.6400        rho_1 = 0.4878        rho_2, rho_3, ... = 0

MA(2) con theta_1 = 0.8, theta_2 = -0.4:
    gamma_0 = 1.8000        rho_1 = 0.2667        rho_2 = -0.2222      rho_3+ = 0
```

### La matriz $\boldsymbol\Omega$ de un MA(1)

$$\boldsymbol\Omega = \sigma_\varepsilon^2\begin{pmatrix} 1+\theta^2 & \theta & 0 & \cdots & 0\\ \theta & 1+\theta^2 & \theta & \cdots & 0\\ 0 & \theta & 1+\theta^2 & \cdots & 0\\ \vdots&\vdots&\vdots&\ddots&\vdots\\ 0&0&0&\cdots&1+\theta^2\end{pmatrix}$$

**Es una matriz banda**: solo la diagonal y las dos subdiagonales adyacentes son
distintas de cero. Ahi se ve el logro de la reparametrizacion: toda la matriz
queda descrita por **dos** numeros ($\theta$ y $\sigma_\varepsilon^2$) en vez de
$T(T+1)/2$.

Para un MA(2) la banda tiene un ancho mas.

---

## 9. ACF de un AR(1)

### Teoria

Usando la representacion $MA(\infty)$:

$$\gamma_0 = Var(u_t) = \sigma_\varepsilon^2\left(1+\rho^2+\rho^4+\cdots\right) = \frac{\sigma_\varepsilon^2}{1-\rho^2}$$

usando que para $|a|<1$, $1+a+a^2+\cdots = \dfrac{1}{1-a}$ (la nota al pie del
PDF: si la suma vale $b$, entonces $1+ab = b$, y despejando $b = 1/(1-a)$).

$$\gamma_1 = \frac{\rho\,\sigma_\varepsilon^2}{1-\rho^2} = \rho\gamma_0 \qquad\qquad \boxed{\;\gamma_s = \rho^s\gamma_0\;}$$

$$\boxed{\;\rho_s = \rho^{\,s}\;}$$

### La firma del AR(1)

**La ACF decae exponencialmente y nunca llega exactamente a cero.** Es lo opuesto
al MA, que se corta de golpe.

```text
rho = 0.5:  0.500  0.250  0.125  0.062  0.031   (cae rapido)
rho = 0.7:  0.700  0.490  0.343  0.240  0.168
rho = 0.9:  0.900  0.810  0.729  0.656  0.590   (cae lento)
```

Y la varianza:

$$Var = \frac{\sigma_\varepsilon^2}{1-\rho^2}: \qquad \rho=0.5 \to 1.33\sigma^2 \qquad \rho=0.9 \to 5.26\sigma^2$$

Cuanto mas persistente el proceso, **mayor su varianza**. Es lo que se ve en el
grafico de la practica: la serie con $\rho=0.9$ oscila mucho mas amplio.

### La matriz $\boldsymbol\Omega$ de un AR(1)

$$\boldsymbol\Omega = \frac{\sigma_\varepsilon^2}{1-\rho^2}\begin{pmatrix} 1 & \rho & \rho^2 & \cdots & \rho^{T-1}\\ \rho & 1 & \rho & \cdots & \rho^{T-2}\\ \rho^2 & \rho & 1 & \cdots & \rho^{T-3}\\ \vdots&\vdots&\vdots&\ddots&\vdots\\ \rho^{T-1}&\rho^{T-2}&\rho^{T-3}&\cdots&1\end{pmatrix}$$

**Ninguna celda es cero**, pero toda la matriz depende de solo dos parametros. La
reparametrizacion funciono igual.

---

## 10. ACF y PACF: como identificar un proceso

### Teoria

La **funcion de autocorrelacion parcial (PACF)** mide la correlacion entre $u_t$ y
$u_{t-s}$ **descontando el efecto de los rezagos intermedios**. Se obtiene
corriendo regresiones sucesivas:

$$u_t \text{ en } u_{t-1} \;\longrightarrow\; \hat\rho_1 \text{ es la PACF de orden 1}$$
$$u_t \text{ en } u_{t-1},\,u_{t-2} \;\longrightarrow\; \hat\rho_2 \text{ es la PACF de orden 2}$$
$$u_t \text{ en } u_{t-1},\,u_{t-2},\,u_{t-3} \;\longrightarrow\; \hat\rho_3 \text{ es la PACF de orden 3}$$

**La PACF de orden $s$ es el coeficiente del ultimo rezago en esa regresion.**

### La tabla de identificacion

Esta es la tabla mas importante de la clase:

| Proceso | ACF | PACF |
|---|---|---|
| **AR($p$)** | decae exponencialmente (o con oscilaciones) | **se corta despues del rezago $p$** |
| **MA($q$)** | **se corta despues del rezago $q$** | decae exponencialmente |
| **ARMA($p,q$)** | decae | decae |
| **Ruido blanco** | todo cero | todo cero |

**Regla mnemotecnica**: la funcion que **se corta** dice el orden.
ACF corta $\rightarrow$ es MA y dice $q$. PACF corta $\rightarrow$ es AR y dice $p$.

### Por que funciona

En un AR(1), $u_t$ esta correlacionado con $u_{t-2}$, pero **solo a traves de
$u_{t-1}$**. Cuando la PACF descuenta $u_{t-1}$, la correlacion parcial con
$u_{t-2}$ desaparece. Por eso la PACF de un AR(1) tiene un solo palito y despues
nada.

En un MA(1), $u_t$ y $u_{t-2}$ **no comparten ningun $\varepsilon$**, asi que la
correlacion es cero directamente y la ACF se corta.

### Codigo generico

```python
from statsmodels.graphics.tsaplots import plot_acf, plot_pacf

fig, axes = plt.subplots(1, 2, figsize=(12, 4))
plot_acf(serie, lags=20, ax=axes[0])
plot_pacf(serie, lags=20, ax=axes[1])
plt.show()
```

### Como leer la salida

- La **banda sombreada** es el intervalo de confianza al 95%, aproximadamente
  $\pm 1.96/\sqrt{T}$. Los palitos **dentro** de la banda no son
  estadisticamente distintos de cero.
- El palito del rezago 0 en la ACF **siempre vale 1** y no se interpreta.
- Con $T$ chico la banda es ancha y cuesta identificar; con $T$ grande se afina.
- En la practica los correlogramas rara vez son tan limpios como en la teoria.
  Conviene mirar el patron general y no obsesionarse con un palito aislado que
  apenas sale de la banda: por azar, 1 de cada 20 lo hace.

---

# Parte D - Durbin-Watson

## 11. El estadistico

### Teoria

Testea autocorrelacion **de orden 1** en los residuos de una regresion MCO:

$$DW = \frac{\sum_{t=2}^{T}(e_t - e_{t-1})^2}{\sum_{t=1}^{T}e_t^2}$$

Siempre esta entre 0 y 4, y se relaciona con la autocorrelacion de primer orden
por $DW \approx 2(1-\hat\rho)$:

| $DW$ | Interpretacion |
|---|---|
| cerca de **0** | autocorrelacion de orden 1 **positiva** |
| cerca de **2** | **no** hay autocorrelacion de orden 1 |
| cerca de **4** | autocorrelacion de orden 1 **negativa** |

### Verificacion numerica

Generando residuos con autocorrelacion conocida:

```text
rho de los residuos    DW observado    2(1-rho)
      -0.9               3.7731          3.80
      -0.5               2.9554          3.00
       0.0               1.9438          2.00
       0.5               1.1016          1.00
       0.9               0.1825          0.20
```

La aproximacion $DW \approx 2(1-\rho)$ funciona muy bien.

### La regla de decision (con las dos zonas)

La tabla de Durbin-Watson da **dos** valores criticos, $d_L$ y $d_U$, en funcion
de $T$ y de la cantidad de pendientes $k$.

**Si $DW < 2$:**

| Condicion | Conclusion |
|---|---|
| $DW < d_L$ | **se rechaza** $H_0$: hay autocorrelacion positiva |
| $d_L < DW < d_U$ | **test inconcluso** |
| $DW > d_U$ | **no se rechaza** $H_0$ |

**Si $DW > 2$:** se usa $4 - DW$ como estadistico y se compara igual. Si
$4-DW < d_L$, hay autocorrelacion **negativa**.

La zona inconclusa es una rareza de este test y no hay que ignorarla: significa
que con esa muestra no se puede decidir.

### Codigo generico

```python
from statsmodels.stats.stattools import durbin_watson

dw = durbin_watson(modelo.resid)
```

Tambien aparece directamente en `modelo.summary()`.

### Limitaciones

- Detecta **solo autocorrelacion de orden 1**. Si hay estructura de orden 4
  (estacional, por ejemplo) puede dar cerca de 2 igual.
- **No es valido si el modelo incluye la variable dependiente rezagada** como
  regresor. En ese caso hay que usar la $h$ de Durbin o un test de
  Breusch-Godfrey.
- Alternativa moderna y mas general: `acorr_ljungbox` o `acorr_breusch_godfrey`.

---

# Parte E - Ejercitacion 5

## 12. Guion completo

La practica esta pensada para Excel, pero se replica exacto en Python.

### Puntos 1 a 4: generar y graficar

```python
n = 100
aleatorios = np.random.standard_normal(n)     # ruido blanco

def simular_ar(rho, n, errores):
    y = np.zeros(n)
    y[0] = errores[0]                          # el enunciado pide y_1 = eps_1
    for i in range(1, n):
        y[i] = rho * y[i-1] + errores[i]
    return y

ar_05 = simular_ar(0.5, n, aleatorios)
ar_09 = simular_ar(0.9, n, aleatorios)

df = pd.DataFrame({'white_noise': aleatorios, 'AR(1)0.5': ar_05, 'AR(1)0.9': ar_09})
df.plot()
```

**Es esencial usar el mismo ruido blanco en los tres**: asi las diferencias entre
las series se deben solo a $\rho$ y no al azar.

### Punto 5: distintas simulaciones (el F9 de Excel)

En Python equivale a volver a correr la celda del ruido blanco. **Lo que hay que
notar es que el patron cualitativo se repite**: el ruido blanco siempre oscila
rapido alrededor de cero, el AR(0.5) un poco mas suave, el AR(0.9) hace ondas
largas y amplias. **Los numeros cambian, la forma no.**

### Punto 6: por que tienen media cero, y cual "vuelve a la media"

**Por que media cero**: el ruido blanco por definicion. Los dos AR(1) porque se
escriben como $u_t = \sum\rho^j\varepsilon_{t-j}$ y cada $\varepsilon$ tiene
esperanza cero.

Nota importante: **si hubiera una constante $c$ en el AR(1), la media no seria
cero pero seguiria siendo constante**, e igual a $c/(1-\rho)$.

**Cual revierte a la media**: los tres, mientras $|\rho|<1$. Pero a velocidades
muy distintas: el AR(0.9) tarda 6.6 periodos en disipar la mitad de un shock,
frente a 1 periodo del AR(0.5). Visualmente el AR(0.9) **parece** no volver, pero
si vuelve. El que genuinamente **no** revierte es el random walk del punto 10.

### Punto 7: estimar $\rho$ por MCO sin constante

```python
df["lag_05"] = df["AR(1)0.5"].shift(1)
df["lag_09"] = df["AR(1)0.9"].shift(1)
df_reg = df.dropna()                       # se pierde la primera obs

m05 = sm.OLS(df_reg["AR(1)0.5"], df_reg[["lag_05"]]).fit()
m09 = sm.OLS(df_reg["AR(1)0.9"], df_reg[["lag_09"]]).fit()

print(m05.params.iloc[0], m09.params.iloc[0])
```

**Sin constante**: no se usa `add_constant`, porque el proceso generador no tiene
intercepto.

### Salida y el sesgo de muestra chica

En una simulacion cualquiera con $T=100$ los estimadores no dan exactamente 0.5 y
0.9. Sobre 2000 simulaciones:

```text
rho verdadero    media de rho_hat    sesgo      desvio
     0.5              0.4915         -0.0085    0.0864
     0.9              0.8818         -0.0182    0.0500
     1.0              0.9828         -0.0172    0.0309
```

**Como leer esto**: el estimador MCO de un AR(1) es **sesgado hacia abajo** en
muestras finitas (el sesgo es aproximadamente $-(1+3\rho)/T$). Con $T=100$ es
chico, pero existe.

Esto no contradice nada de las clases anteriores: la insesgadez de MCO requiere
que los regresores sean **fijos**, y aca el regresor ($y_{t-1}$) es una variable
aleatoria correlacionada con el pasado del error. MCO sigue siendo **consistente**
(el sesgo tiende a cero cuando $T\to\infty$), que es lo que salva la situacion.

Notar tambien que **el desvio es mucho menor para $\rho$ alto**: es mas facil
estimar procesos persistentes.

### Punto 8: ACF y PACF

```python
fig, axes = plt.subplots(2, 2, figsize=(12, 8))
plot_acf(df["AR(1)0.5"],  lags=20, ax=axes[0,0]); axes[0,0].set_title("ACF  rho=0.5")
plot_pacf(df["AR(1)0.5"], lags=20, ax=axes[0,1]); axes[0,1].set_title("PACF rho=0.5")
plot_acf(df["AR(1)0.9"],  lags=20, ax=axes[1,0]); axes[1,0].set_title("ACF  rho=0.9")
plot_pacf(df["AR(1)0.9"], lags=20, ax=axes[1,1]); axes[1,1].set_title("PACF rho=0.9")
```

**Lo que hay que ver**:

- Las dos **ACF decaen exponencialmente**: la de $\rho=0.5$ entra en la banda
  hacia el rezago 3-4; la de $\rho=0.9$ sigue afuera hasta el rezago 10 o mas.
- Las dos **PACF tienen un solo palito significativo en el rezago 1** y despues
  nada. Es la firma inequivoca de un **AR(1)**.

Ese contraste es el objetivo del ejercicio: la ACF dice "es autorregresivo", la
PACF dice "de orden 1".

### Punto 9: el shock

```python
aleatorios_shock = aleatorios.copy()
aleatorios_shock[14] = 3                  # celda A15 de Excel = indice 14

ar_05_shock = simular_ar(0.5, n, aleatorios_shock)
ar_09_shock = simular_ar(0.9, n, aleatorios_shock)
```

**Respuesta**: los dos vuelven a la media, pero **el de $\rho=0.9$ mucho mas
lento**. Con $\rho=0.5$ el shock casi desaparece en 4-5 periodos; con $\rho=0.9$
todavia queda un 35% diez periodos despues.

Graficando original vs shock con una linea vertical en $t=14$ se ve directamente
la funcion impulso-respuesta.

### Punto 10: random walk

```python
random_walk = simular_ar(1.0, n, aleatorios)
```

**Que cambia**: todo. El random walk **no vuelve a la media**. Se aleja de cero y
se queda donde lo dejaron los shocks acumulados, porque
$u_t = \sum_{j=0}^{t}\varepsilon_j$: es la suma de todos los shocks pasados, cada
uno con peso 1.

En una simulacion tipica, mientras el AR(0.5) tiene desvio $\approx 1.06$ y el
AR(0.9) $\approx 1.85$, el random walk deriva a valores muy alejados de cero y su
desvio **crece con $t$**: $Var(u_t) = t\sigma^2$. No tiene varianza constante, o
sea que **no es estacionario**.

Esa es la puerta de entrada a la Clase 7: raices unitarias.

### Puntos 11 y 12: opcionales

```python
for rho in [0.95, 0.97, 0.99, 1.01, 1.05]:
    plt.plot(simular_ar(rho, n, aleatorios), label=f"rho={rho}")

for rho in [-0.5, -0.9, -0.99]:
    plt.plot(simular_ar(rho, n, aleatorios), label=f"rho={rho}")
```

**Que se ve**:

- $\rho \to 1^-$: la serie se parece cada vez mas a un random walk. Con 0.99 es
  practicamente indistinguible en 100 observaciones. **Ese es el problema
  fundamental de los tests de raiz unitaria**: distinguir 0.99 de 1.00 con datos
  finitos es muy dificil.
- $\rho > 1$: **explosivo**. La serie se dispara exponencialmente. Con 1.05 y 100
  periodos, $1.05^{100} \approx 131$.
- $\rho < 0$: la serie **oscila alternando signo** en cada periodo (dientes de
  sierra), porque $\rho_s = \rho^s$ cambia de signo. Cuanto mas cerca de $-1$, mas
  violenta la oscilacion. La ACF alterna: negativa en impares, positiva en pares.

---

## 13. Ejercitacion 6 (puente a la Clase 7)

La Ejercitacion 6 usa `Precios_y_Dinero.xlsx` y mezcla dos clases:

| Ejercicio | Tema | Donde se ve |
|---|---|---|
| 1 | Graficar `m` e `ipc` | Clase 2 |
| 2, 3, 4 | Orden de integracion con ADF | **Clase 7** |
| 5, 6 | Correlograma y correlograma parcial de las tasas | **esta clase** |
| 7 | Regresion inflacion vs crec_m y autocorrelacion de residuos | esta clase + Clase 7 |

### Sobre los ejercicios 5 y 6

Se pide identificar si las series de `inflacion` y `crec_m` son AR o MA y de que
orden, usando exactamente la tabla del punto 10.

```python
from statsmodels.graphics.tsaplots import plot_acf, plot_pacf

fig, axes = plt.subplots(2, 2, figsize=(12, 8))
plot_acf(df["infl"],   lags=24, ax=axes[0,0])
plot_pacf(df["infl"],  lags=24, ax=axes[0,1])
plot_acf(df["crec_m"], lags=24, ax=axes[1,0])
plot_pacf(df["crec_m"],lags=24, ax=axes[1,1])
```

Con datos mensuales conviene mirar hasta el rezago 24 para detectar
estacionalidad (palitos en 12 y 24).

### Sobre el ejercicio 7

Pide correr `inflacion ~ crec_m`, mirar si los residuos estan autocorrelacionados
y decir que se haria en ese caso.

**El punto conceptual**: "una mayor tasa de crecimiento de la base monetaria
genera inflacion?" **no** se puede responder con esta regresion. Un coeficiente
significativo muestra asociacion contemporanea, no causalidad. La herramienta
correcta es el **test de causalidad de Granger dentro de un VAR**, que es
exactamente lo que se hace en la [Clase 8](Clase_08.md).

**Si los residuos estan autocorrelacionados**, las opciones son:

1. Agregar rezagos de las variables al modelo (pasar a un modelo dinamico).
2. Usar errores estandar robustos a autocorrelacion (**HAC / Newey-West**).
3. Modelar explicitamente la estructura del error (ARMA) y estimar por GLS.

```python
# opcion 2, la mas directa
modelo_hac = sm.OLS(y, X).fit(cov_type='HAC', cov_kwds={'maxlags': 12})
```

**Advertencia adicional**: el enunciado marca que "las series involucradas deben
tener el mismo orden de integracion". Regresar una serie I(1) contra otra I(1) sin
cointegracion produce **regresion espuria**: $R^2$ altisimo, $t$ enormes y todo
sin sentido. Por eso los ejercicios 2 a 4 (verificar que ambas sean I(0)) van
**antes** del 7.

---

## 14. Errores frecuentes

| Error | Por que pasa | Como se evita |
|---|---|---|
| Signo de los parametros AR en `ArmaProcess` | pide el polinomio caracteristico | `ar = np.r_[1, -rho]` |
| Signo de los MA | ahi **no** se invierte | `ma = np.r_[1, theta]` |
| Olvidar el 1 del lag cero | los dos arrays lo llevan | siempre empezar con `1` |
| Confundir ACF con PACF | los graficos se parecen | la que **se corta** da el orden |
| Estimar el AR(1) con constante | el proceso generador no la tiene | `sm.OLS(y, X)` sin `add_constant` |
| No usar el mismo ruido blanco | las series no son comparables | generar `eps` una vez y reusarlo |
| Leer el palito 0 de la ACF | siempre vale 1 | mirar desde el rezago 1 |
| Interpretar un solo palito fuera de banda | 1 de cada 20 lo hace por azar | mirar el patron completo |
| Usar DW con la dependiente rezagada | el test no es valido ahi | Breusch-Godfrey o h de Durbin |
| Ignorar la zona inconclusa del DW | se suele simplificar a "cerca de 2" | comparar contra $d_L$ y $d_U$ |
| Confundir estacionariedad con estacionalidad | suenan parecido | no tienen nada que ver |
| Creer que el AR(0.9) no revierte | revierte, pero lento | vida media $\ln 0.5/\ln\rho$ |

---

## 15. Checklist de Clase 6

Al terminar deberias poder:

1. Explicar por que en series de tiempo falla el Supuesto 2b.
2. Contar cuantos parametros tiene $\boldsymbol\Omega$ y por que es inviable.
3. Explicar que significa reparametrizar y para que sirve.
4. Enunciar las tres condiciones de ruido blanco.
5. Distinguir ruido blanco debil de fuerte.
6. Escribir AR(1), AR(2), AR($p$).
7. Escribir MA(1), MA(2), MA($q$).
8. Escribir ARMA($p,q$), IMA(1) y ARIMA($p$,1,$q$).
9. Definir random walk como caso particular del AR(1).
10. Demostrar que un AR(1) es un MA($\infty$).
11. Explicar por que hace falta $|\rho|<1$ para que converja.
12. Definir autocovarianza y autocorrelacion.
13. Explicar por que hace falta estacionariedad para escribir $\rho_s=\gamma_s/\gamma_0$.
14. Derivar $\gamma_0$, $\gamma_1$ y $\gamma_2$ de un MA(1).
15. Derivar las autocovarianzas de un MA(2).
16. Enunciar que la ACF de un MA($q$) se corta en $q$.
17. Derivar $\gamma_0 = \sigma^2/(1-\rho^2)$ de un AR(1).
18. Demostrar $\gamma_s = \rho^s\gamma_0$.
19. Escribir la matriz $\boldsymbol\Omega$ de un MA(1) y de un AR(1).
20. Explicar como se construye la PACF a partir de regresiones.
21. Usar la tabla ACF/PACF para identificar un proceso.
22. Explicar por que la PACF de un AR(1) se corta en 1.
23. Escribir el estadistico DW e interpretar sus tres zonas.
24. Aplicar la regla de decision con $d_L$ y $d_U$, incluida la zona inconclusa.
25. Explicar la funcion impulso-respuesta y calcular la vida media de un shock.
26. Explicar por que un random walk no revierte a la media.
27. Explicar por que MCO en un AR(1) es sesgado pero consistente.
28. Decir que hacer si los residuos de una regresion estan autocorrelacionados.

---

## 16. Notas tecnicas

- Dependencias: `numpy`, `pandas`, `matplotlib`, `statsmodels`.
- `ArmaProcess(ar, ma)` recibe **polinomios**, no coeficientes del proceso: el
  primer elemento es el del lag 0 y los AR van con signo cambiado.
- `generate_sample(nsample=T)` descarta observaciones iniciales para que la serie
  arranque estacionaria. Para forzar el mismo ruido blanco:
  `distrvs=lambda size: aleatorios`.
- `plot_pacf` acepta `method=` (`'ywm'`, `'ols'`, ...). El default cambio entre
  versiones de `statsmodels`; si los graficos no coinciden con otra maquina, es
  por eso.
- `plot_acf(x, lags=20)` falla si la serie tiene `NaN`: hacer `.dropna()` antes.
- `durbin_watson` esta en `statsmodels.stats.stattools`, no en `diagnostic`.
- Los resultados de cualquier simulacion cambian con la semilla. Las
  **interpretaciones** no cambian; los valores puntuales si.
- El notebook de la practica usa `np.random.standard_normal(n)`, equivalente a
  `np.random.normal(0, 1, n)`, que en Excel es
  `+INV.NORM.ESTAND(ALEATORIO())`.
