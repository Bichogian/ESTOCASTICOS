# Clase 1 - Retornos, distribuciones y momentos

[Volver al indice general](../Res+Pra.md)

Mapa completo de la Clase 1: teoria del PDF, codigo de los notebooks y
Ejercitacion 1. Cada tema sigue el mismo recorrido:

$$\text{teoria} \;\rightarrow\; \text{para que sirve} \;\rightarrow\; \text{codigo generico} \;\rightarrow\; \text{como leer la salida}$$

## Archivos de esta clase

| Tipo | Archivo | Para que se usa |
|---|---|---|
| Teoria | `Clases/MIA103_Clase_1.pdf` | Retornos, normal, momentos, Jarque-Bera, QQ plot |
| Python | `Codigos/MIA103_2026_Clase_00_Intro_practica.ipynb` | Repaso de numpy / pandas / matplotlib |
| Python | `Codigos/MIA103_2026_Clase_01_01.ipynb` | S&P 500: retornos, descriptivos, QQ plot, Jarque-Bera |
| Python | `Codigos/MIA103_2026_Clase_01_02_Mixtura.ipynb` | Mixtura de normales y sus momentos |
| Practica | `Practicas/MIA103_Ejer_1.pdf` (+ `_Sol.pdf`) | Ejercicios 1 a 3 |
| Resuelta | `Practicas_Resueltas/Respuestas_1.ipynb` | Resolucion propia con MELI |
| Datos | `Bases de Datos MIA103/SP500_.xlsx` | Serie local del S&P 500 |

## Mapa tema - PDF - notebook - practica

| # | Tema | PDF | Notebook | Practica |
|---:|---|---|---|---|
| 1 | Retorno simple y bruto | p. 2 | `01_01` celda 10 | Ej. 3a |
| 2 | Retorno logaritmico y Taylor | p. 3-5 | `01_01` celda 10 | Ej. 3e |
| 3 | Aditividad temporal del log-retorno | p. 6-7 | - | Ej. 3e |
| 4 | Ejercicios 1 y 2 del PDF | p. 7, 9-10 | - | - |
| 5 | Normal, estandarizacion | p. 11-13 | `01_01` celda 19 | - |
| 6 | Media-varianza y nivel de perdida | p. 14-15 | - | - |
| 7 | Asimetria | p. 17-18 | `01_01` celda 22 | Ej. 3b |
| 8 | Curtosis y curtosis en exceso | p. 18-19 | `01_01` celda 22 | Ej. 3b |
| 9 | Momentos de la normal estandar | p. 20 | - | Ej. 1 |
| 10 | Jarque-Bera | p. 21 | `01_01` celda 22 | Ej. 3d |
| 11 | QQ plot | p. 22-23 | `01_01` celdas 19-20 | - |
| 12 | Mixtura de normales | - | `01_02` completo | Ej. 2 |

---

# Parte A - Retornos

## 1. Retorno simple

### Teoria

Si $P_t$ es el precio del activo en el momento $t$:

$$R_t \;=\; \frac{P_t - P_{t-1}}{P_{t-1}} \;=\; \frac{P_t}{P_{t-1}} - 1$$

- $R_t$ es el **retorno neto**.
- $1 + R_t = \dfrac{P_t}{P_{t-1}}$ es el **retorno bruto**.

### Para que sirve

Es lo que efectivamente se gana o se pierde. Si invertiste 100 pesos y
$R_t = 0.03$, tenes 103. Todo calculo de plata real usa retorno simple.

### Codigo generico

```python
import pandas as pd

# df tiene una columna de precios ordenada por fecha
df["ret_simple"] = df["Precio"].pct_change()
```

`pct_change()` hace exactamente $P_t/P_{t-1} - 1$. Equivale a
`df["Precio"]/df["Precio"].shift(1) - 1`.

### Como leer la salida

La **primera fila siempre es `NaN`**: no hay $P_{t-1}$ para la primera
observacion. Por eso despues siempre va un `.dropna()`.

Los valores vienen en tanto por uno: `0.0123` es un retorno de 1.23%.

---

## 2. Retorno logaritmico

### Teoria

$$r_t \;=\; \ln\!\left(\frac{P_t}{P_{t-1}}\right) \;=\; \ln(P_t) - \ln(P_{t-1}) \;=\; \Delta \ln (P_t)$$

Es el logaritmo del retorno bruto. La relacion con el simple sale de un
polinomio de Taylor de grado 1 alrededor de $x_0 = 1$:

$$\ln(x) \;\approx\; \ln(1) + \frac{1}{1}(x-1) \;=\; x - 1$$

Aplicado al retorno bruto:

$$r_t = \ln(1 + R_t) \;\approx\; R_t$$

### Para que sirve

Dos razones concretas:

1. **Se suman en el tiempo** (ver punto 3), lo que simplifica todo el analisis de
   series de tiempo.
2. Es la transformacion que usamos en toda la materia para pasar de un precio con
   tendencia a una serie estacionaria.

### La aproximacion no siempre es buena

$$\ln(1.02) = 0.01980263 \approx 0.02 \quad \text{(muy buena)}$$

$$\ln(1.25) = 0.223144 \qquad \ln(0.75) = -0.287682 \quad \text{(mala)}$$

Con retornos grandes la diferencia importa. Y notar la asimetria: **en
logaritmos, los retornos negativos se hacen mas negativos y los positivos menos
positivos**. Esto es clave al medir riesgo, porque el riesgo vive en la cola
izquierda.

### Codigo generico

```python
import numpy as np

df["ret_log"] = np.log(df["Precio"] / df["Precio"].shift(1))
# equivalente:
df["ret_log"] = np.log(df["Precio"]).diff()
```

### Como leer la salida

Para retornos diarios normales, `ret_log` y `ret_simple` van a ser casi
identicos (difieren en la 4a o 5a decimal). Si ves diferencias grandes, es que
hubo un movimiento fuerte ese dia.

---

## 3. Aditividad temporal del retorno logaritmico

### Teoria

Los log-retornos diarios de una semana suman el log-retorno semanal:

$$r_1 + r_2 + r_3 + r_4 + r_5 = \ln\frac{P_1}{P_0} + \ln\frac{P_2}{P_1} + \cdots + \ln\frac{P_5}{P_4}$$

La suma telescopica deja:

$$= \ln(P_5) - \ln(P_0) = \ln\!\left(\frac{P_5}{P_0}\right)$$

Los retornos **simples no tienen esta propiedad**: hay que multiplicar retornos
brutos, no sumar netos.

### Para que sirve

Convertir frecuencias sin esfuerzo: diario a mensual, mensual a anual. Y es lo
que se pide verificar en el Ejercicio 3e.

### Codigo generico

```python
# suma de log-retornos diarios de un mes
suma_diarios = df.loc["2025-06", "ret_log"].sum()

# log-retorno directo del mes: precio final vs precio del dia previo al mes
precio_fin = df.loc["2025-06", "Precio"].iloc[-1]
pos = df.index.get_loc(df.loc["2025-06"].index[0])
precio_ini = df["Precio"].iloc[pos - 1]

directo = np.log(precio_fin / precio_ini)

print(suma_diarios, directo)   # deben coincidir
```

### Como leer la salida

Los dos numeros tienen que dar **exactamente lo mismo** (salvo error de redondeo
en la decimal 15). Si no coinciden, casi siempre es porque tomaste como precio
inicial el primer precio *del* mes en vez del ultimo precio del mes *anterior*.

---

## 4. Los dos ejercicios del PDF

### Ejercicio 1

*Un activo tiene retorno logaritmico diario de $-2\%$ durante 5 dias. Si $P_0 = 130$,
cuanto vale $P_5$?*

Por aditividad, el log-retorno de la semana es $5 \times (-0.02) = -0.10$:

$$\ln\!\left(\frac{P_5}{P_0}\right) = -0.10 \;\Longrightarrow\; \ln(P_5) = \ln(130) - 0.10 = 4.76753$$

$$P_5 = e^{4.76753} = 117.63$$

```python
P5 = 130 * np.exp(-0.10)     # 117.63
```

**Ojo con el error tipico:** $130 \times (1 - 0.10) = 117.00$ esta **mal**. El
$-10\%$ es logaritmico, no simple.

### Ejercicio 2

*El retorno logaritmico promedio diario fue $0.177\%$ en un mes de 20 dias. Cual
es el retorno simple acumulado del mes?*

Si $\bar{x} = \frac{1}{n}\sum x_i$, entonces $\sum x_i = n\bar{x}$:

$$\sum_{i=1}^{20} r_i = 20 \times 0.00177 = 0.0354$$

$$\frac{P_{20}}{P_0} = e^{0.0354} = 1.036 \;\Longrightarrow\; R = 1.036 - 1 = 3.6\%$$

```python
R = np.exp(20 * 0.00177) - 1   # 0.0360
```

### Idea para recordar

Para pasar de log a simple: $R = e^{r} - 1$. Para pasar de simple a log:
$r = \ln(1+R)$.

---

# Parte B - Cargar datos y describirlos

## 5. Traer precios a un DataFrame

### Codigo generico

Dos caminos, los dos usados en clase:

```python
# A) desde un Excel local
df = pd.read_excel("Bases de Datos MIA103/SP500_.xlsx", sheet_name=0)

# B) descargando de Yahoo Finance
import yfinance as yf

sp500 = yf.download('^GSPC', start='2021-06-01', end='2026-03-01',
                    interval='1d', auto_adjust=True)

df = sp500[['Close']].reset_index()
df.columns = ['Date', 'Adj Close']

# limpieza estandar, siempre igual
df = df.dropna()
df['Date'] = pd.to_datetime(df['Date'])
df = df.sort_values('Date')
```

### Como leer la salida

- `auto_adjust=True` ajusta por dividendos y splits. Sin eso, un split aparece
  como una caida enorme que no es un retorno real.
- Si `yfinance` devuelve columnas con dos niveles (MultiIndex), se accede como
  `df_meli["Close"]["MELI"]`. Es lo que aparece en `Respuestas_1.ipynb`.
- **Siempre ordenar por fecha antes de calcular retornos.** Si el DataFrame esta
  desordenado, `pct_change()` devuelve basura sin avisar.

---

## 6. Estadisticos descriptivos: media y volatilidad

### Teoria

Sobre una muestra de $n$ observaciones:

$$\bar{x} = \frac{\sum_{i=1}^{n} x_i}{n} \qquad\qquad s^2 = \frac{\sum_{i=1}^{n}(x_i - \bar{x})^2}{n-1}$$

$$s = \sqrt{s^2}$$

A ese desvio estandar $s$ lo llamamos **volatilidad** del retorno.

### Para que sirve

La media dice cuanto rinde en promedio; la volatilidad, cuanto se mueve. Son los
dos numeros del criterio media-varianza: entre dos activos con la misma media,
preferimos el de menor volatilidad.

### Codigo generico

```python
ret = df["ret_simple"].dropna()

print(ret.describe())        # count, mean, std, min, cuartiles, max

media = ret.mean()
vol   = ret.std()            # pandas usa n-1 por defecto
```

### Como leer la salida

- `pandas` `.std()` divide por $n-1$; `numpy` `.std()` divide por $n$ salvo que
  pases `ddof=1`. Con miles de datos la diferencia es despreciable, pero conviene
  saberlo.
- La volatilidad sale en la misma frecuencia que los datos. Para anualizar
  volatilidad diaria: $\sigma_{anual} = \sigma_{diario}\sqrt{252}$.
- Un valor tipico de volatilidad diaria de un indice es 0.01 (1%); de una accion
  individual, 0.02-0.03.

---

## 7. Normal, estandarizacion y criterio media-varianza

### Teoria

La densidad de $X \sim N(\mu, \sigma^2)$ es:

$$f(x \mid \mu, \sigma^2) = \frac{1}{\sqrt{2\pi\sigma^2}}\; e^{-\frac{(x-\mu)^2}{2\sigma^2}}, \qquad x \in \mathbb{R}$$

**Estandarizar** es redefinir la variable para que tenga media 0 y varianza 1:

$$Z = \frac{X - \mu}{\sigma} \;\sim\; N(0,1)$$

Esto funciona por las propiedades:

$$E(a + bX) = a + bE(X) \qquad Var(a + bX) = b^2 Var(X)$$

### Para que sirve

Estandarizar permite comparar variables con escalas distintas y es el paso previo
obligatorio para el QQ plot, la asimetria y la curtosis (que son medidas de
**forma**, y por lo tanto se calculan sobre la variable estandarizada).

### Nivel minimo de retorno con confianza $cl$

Bajo normalidad, si $\alpha_{cl}$ es el valor critico tal que
$P(Z \le \alpha_{cl}) = 1 - cl$, entonces el retorno minimo al $cl \cdot 100\%$
de confianza es:

$$X = \mu + \alpha_{cl}\,\sigma$$

Para $cl = 99\%$: $\alpha_{cl} = -2.33$, entonces $X = \mu - 2.33\sigma$.

### Codigo generico

```python
from scipy.stats import norm

z = (ret - ret.mean()) / ret.std()      # estandarizar

alpha = norm.ppf(0.01)                  # -2.3263  (cola izquierda al 99%)
peor_retorno = ret.mean() + alpha * ret.std()
```

### Como leer la salida

`norm.ppf(p)` devuelve el valor $z$ que deja probabilidad $p$ a la izquierda:

| confianza | $p$ de cola | $\alpha_{cl}$ |
|---|---|---|
| 95% | 0.05 | $-1.6449$ |
| 99% | 0.01 | $-2.3263$ |

El resultado se lee: "con 99% de confianza, la perdida diaria no supera X".

**Limitacion importante que marca el PDF:** este calculo supone normalidad. Como
los retornos reales tienen colas pesadas, el metodo **subestima** el riesgo de
eventos extremos.

---

# Parte C - Momentos: forma de la distribucion

## 8. Asimetria (skewness)

### Teoria

$$S = \frac{1}{n}\sum_{i=1}^{n}\left(\frac{x_i - \bar{x}}{s}\right)^3$$

- $S > 0$: **asimetria positiva**, cola derecha pesada.
- $S < 0$: **asimetria negativa**, cola izquierda pesada.
- $S = 0$: simetrica (la normal tiene $S=0$).

### Para que sirve

En finanzas la asimetria negativa es la mala: significa que los eventos extremos
son mayoritariamente perdidas. Un activo con $S<0$ tiene mas riesgo de cola del
que sugiere su volatilidad.

### Codigo generico

```python
from scipy import stats

# forma manual, tal como la formula
S = (((ret - ret.mean()) / ret.std())**3).mean()

# forma directa
S = stats.skew(ret)
```

### Como leer la salida

Los dos numeros difieren un poco porque la formula manual usa `ret.std()`
(divisor $n-1$) y `stats.skew` usa el divisor $n$. Para $n$ grande la diferencia
es minima. El notebook de clase muestra ambas justamente para que se vea.

---

## 9. Curtosis

### Teoria

$$K = \frac{1}{n}\sum_{i=1}^{n}\left(\frac{x_i - \bar{x}}{s}\right)^4$$

La **curtosis en exceso** es:

$$K_E = K - 3$$

Porque para la normal $K = 3$. Clasificacion:

| Valor | Nombre | Colas |
|---|---|---|
| $K_E = 0$ | mesocurtica | como la normal |
| $K_E > 0$ | **leptocurtica** | mas pesadas que la normal |
| $K_E < 0$ | platicurtica | mas livianas, densidad mas plana |

### Para que sirve

Casi todas las series financieras son leptocurticas: hay muchos mas dias de
movimientos extremos de los que predice una normal. Es la razon principal por la
que el supuesto de normalidad falla.

### Codigo generico

```python
K   = (((ret - ret.mean()) / ret.std())**4).mean()   # curtosis "cruda"
K_E = K - 3                                          # en exceso

# con scipy: OJO con el argumento fisher
stats.kurtosis(ret, fisher=False)   # devuelve K   (curtosis cruda)
stats.kurtosis(ret)                 # devuelve K_E (por defecto fisher=True)
```

### Como leer la salida

**El error mas comun de la materia**: `stats.kurtosis` por defecto
(`fisher=True`) devuelve la curtosis **en exceso**, no la cruda. Si ves un
numero como `4.2` es curtosis cruda; si ves `1.2` es en exceso. Un retorno
diario tipico da $K$ entre 5 y 15.

---

## 10. Momentos de la normal estandar (Ejercicio 1 de la practica)

### Teoria

Para $Z \sim N(0,1)$:

$$E(Z) = \int_{-\infty}^{+\infty} z \,\frac{1}{\sqrt{2\pi}} e^{-z^2/2}\,dz = 0$$
$$Var(Z) = E(Z^2) = 1 \qquad E(Z^3) = 0 \qquad E(Z^4) = 3$$

### Como se demuestran sin integrar

El argumento corto es de **paridad**:

- $\phi(z) = \frac{1}{\sqrt{2\pi}}e^{-z^2/2}$ es una funcion **par**: $\phi(-z) = \phi(z)$.
- $z \cdot \phi(z)$ y $z^3 \cdot \phi(z)$ son funciones **impares**, y la integral
  de una funcion impar sobre $\mathbb{R}$ es 0. De ahi $E(Z)=0$ y $E(Z^3)=0$.
- $E(Z^2)=1$ es la definicion misma de normal estandar.
- $E(Z^4)=3$ sale por integracion por partes (o de la funcion generadora de
  momentos $M_X(t) = e^{\mu t + \sigma^2 t^2/2}$, derivando cuatro veces).

### Consecuencia

Como asimetria y curtosis se calculan sobre la variable **estandarizada**,
cualquier normal (no solo la estandar) tiene $S = 0$ y $K = 3$. Por eso la
referencia "3" en la curtosis en exceso.

---

## 11. Test de Jarque-Bera

### Teoria

$$JB = \frac{n}{6}\left(S^2 + \frac{K_E^2}{4}\right)$$

Bajo $H_0$ los datos son normales, y entonces $JB \sim \chi^2_2$ asintoticamente.

$$H_0: \text{los datos siguen una distribucion normal}$$

Valores criticos aproximados: **6** al 5% y **9** al 1%.

### Para que sirve

Es un test formal que reemplaza al "me parece que el histograma no es normal".
Combina las dos desviaciones que importan: asimetria y colas.

### Codigo generico

```python
from scipy import stats

jb_stat, jb_pvalue = stats.jarque_bera(ret)

print(f"JB = {jb_stat:.4f}")
print(f"p-value = {jb_pvalue:.4f}")

if jb_pvalue < 0.05:
    print("Rechazamos normalidad al 5%")
else:
    print("No rechazamos normalidad al 5%")
```

Version manual, que es la que reproduce la formula del PDF:

```python
S   = (((ret - ret.mean()) / ret.std())**3).mean()
K   = (((ret - ret.mean()) / ret.std())**4).mean()
n   = ret.size
JB  = n/6 * (S**2 + 0.25 * (K - 3)**2)
```

### Como leer la salida

- $JB$ **grande** y $p$-value **chico** $\Rightarrow$ se rechaza normalidad.
- Con retornos diarios de cualquier activo real y varios anios de datos, el
  $JB$ da en los cientos o miles y el p-value da `0.0000`. **Se rechaza siempre.**
  Eso no es un error: es el hecho estilizado de que los retornos no son normales.
- El test es asintotico: con muestras chicas (menos de ~100) no es confiable.

---

## 12. QQ plot

### Teoria

Procedimiento del PDF:

1. Ordenar la muestra de menor a mayor y construir la acumulada empirica
   $\hat{P}_i = i/n$.
2. Calcular los cuantiles teoricos $\hat{z}_i = \Phi^{-1}(\hat{P}_i)$.
3. Estandarizar los datos: $z_i = \dfrac{x_i - \bar{x}}{s}$.
4. Graficar $\hat{z}_i$ contra $z_i$. Si los datos son normales, los puntos caen
   sobre la recta de 45 grados.

### Para que sirve

Es el complemento visual del Jarque-Bera: no solo dice *si* falla la normalidad,
sino **donde** falla.

### Codigo generico

```python
import scipy.stats as stats
import statsmodels.api as sm
import matplotlib.pyplot as plt

z = (ret - ret.mean()) / ret.std()

# opcion 1: scipy
stats.probplot(z, dist="norm", plot=plt)
plt.show()

# opcion 2: statsmodels
sm.qqplot(z, line='s', fit=True)   # line='s' ajusta una recta a los datos
plt.show()
```

### Como leer la salida

| Forma del grafico | Interpretacion |
|---|---|
| Puntos sobre la recta | normalidad razonable |
| Extremos **por debajo** a la izquierda y **por encima** a la derecha (forma de S invertida) | colas pesadas, leptocurtica: el caso tipico de retornos |
| Solo la cola izquierda se despega | asimetria negativa |
| Puntos formando una S "hacia adentro" | colas livianas, platicurtica (ej: uniforme) |

Pregunta del PDF: la **t-Student** (simetrica, colas pesadas) da la S invertida
en ambos extremos; la **uniforme** (simetrica, colas livianas) da la S contraria.

---

# Parte D - Mixtura de normales (Ejercicio 2)

## 13. Que es una mixtura

### Teoria

Una mixtura combina dos densidades normales con pesos que suman 1:

$$f_X(x) = w_1 \cdot \frac{1}{\sqrt{2\pi}}e^{-\frac{x^2}{2}} \;+\; w_2 \cdot \frac{1}{\sqrt{8\pi}}e^{-\frac{(x+1.5)^2}{8}}$$

con $w_1 = 0.75$ para $N(0,1)$ y $w_2 = 0.25$ para $N(-1.5,\,4)$.

**No es la suma de dos variables normales.** Es como si con probabilidad 0.75
sorteamos de la primera normal y con 0.25 de la segunda. El resultado **no es
normal**.

### Para que sirve

Es el modelo mas simple que genera asimetria y colas pesadas partiendo de
normales. Sirve para representar "regimenes": un regimen tranquilo frecuente y
uno turbulento poco frecuente.

### Codigo generico

```python
import numpy as np, pandas as pd
import scipy.stats as stats

w1, mu1, var1 = 0.75, 0.0, 1.0
w2, mu2, var2 = 0.25, -1.5, 4.0

z = np.arange(-8, 8.05, 0.1)
df = pd.DataFrame({"z": z})

df["pdf_1"]    = stats.norm.pdf(df["z"], loc=mu1, scale=np.sqrt(var1))
df["pdf_2"]    = stats.norm.pdf(df["z"], loc=mu2, scale=np.sqrt(var2))
df["pdf_mixt"] = w1 * df["pdf_1"] + w2 * df["pdf_2"]
```

### Como leer la salida

**Trampa central del ejercicio**: `scipy` pide `scale` = **desvio estandar**, no
varianza. Para $N(-1.5, 4)$ hay que pasar `scale=2`, no `scale=4`. Es el error
mas frecuente en este ejercicio.

---

## 14. Momentos de la mixtura

### Teoria

No se pueden promediar las asimetrias ni las curtosis. Hay que ir por los
momentos centrados. Con $\mu_{mix} = w_1\mu_1 + w_2\mu_2$:

$$\sigma^2_{mix} = \sum_i w_i\left[\sigma_i^2 + (\mu_i - \mu_{mix})^2\right]$$

$$\mu_3 = \sum_i w_i\left[(\mu_i - \mu_{mix})^3 + 3(\mu_i - \mu_{mix})\sigma_i^2\right]$$

$$\mu_4 = \sum_i w_i\left[(\mu_i - \mu_{mix})^4 + 6(\mu_i - \mu_{mix})^2\sigma_i^2 + 3\sigma_i^4\right]$$

Y finalmente:

$$S = \frac{\mu_3}{\sigma_{mix}^3} \qquad\qquad K = \frac{\mu_4}{\sigma_{mix}^4}$$

### Codigo generico

```python
mu_mix  = w1*mu1 + w2*mu2
var_mix = w1*(var1 + (mu1-mu_mix)**2) + w2*(var2 + (mu2-mu_mix)**2)
std_mix = np.sqrt(var_mix)

mu_3 = (w1*((mu1-mu_mix)**3 + 3*(mu1-mu_mix)*var1)
      + w2*((mu2-mu_mix)**3 + 3*(mu2-mu_mix)*var2))

mu_4 = (w1*((mu1-mu_mix)**4 + 6*(mu1-mu_mix)**2*var1 + 3*var1**2)
      + w2*((mu2-mu_mix)**4 + 6*(mu2-mu_mix)**2*var2 + 3*var2**2))

skewness = mu_3 / std_mix**3
kurtosis = mu_4 / var_mix**2
```

### Salida para este ejercicio

```text
media      = -0.3750
varianza   =  2.1719      desvio = 1.4737
mu_3       = -2.8477
mu_4       = 22.8918
asimetria  = -0.8897
curtosis   =  4.8530      en exceso = 1.8530
```

### Como leer la salida

- **Asimetria $-0.89$**: negativa, como se ve en el grafico. Tiene sentido: la
  segunda componente esta corrida a la izquierda ($\mu_2 = -1.5$), asi que
  engorda la cola izquierda.
- **Curtosis $4.85 > 3$**: leptocurtica. Mezclar dos normales con varianzas
  distintas (1 y 4) genera colas mas pesadas que cualquiera de las dos.

Conclusion del ejercicio: **la mixtura es asimetrica negativa y leptocurtica**,
aunque este construida enteramente con normales.

---

## 15. Comparar la mixtura contra su normal equivalente

### Por que

Comparar la mixtura contra una $N(0,1)$ no dice nada: tienen media y varianza
distintas, asi que la diferencia visual mezcla ubicacion, escala y forma. La
comparacion correcta es contra la normal que tiene **exactamente la misma media
y varianza** que la mixtura: asi lo unico que queda a la vista es la forma.

### Codigo generico

```python
from scipy.stats import norm

df["pdf_normal_equiv"] = norm.pdf(df["z"], loc=mu_mix, scale=std_mix)

plt.plot(df["z"], df["pdf_mixt"], label="Mixture", color="green")
plt.plot(df["z"], df["pdf_normal_equiv"], "--", color="black",
         label=f"Normal equivalente N({mu_mix:.3f}, {var_mix:.3f})")
plt.legend(); plt.show()
```

### Inspeccion de colas

En el grafico las colas parecen ambas cero. La unica forma de ver que pasa es
mirar los numeros:

```python
cola_izq = df[(df["z"] >= -8) & (df["z"] <= -7.1)]
print(cola_izq[["z", "pdf_mixt", "pdf_normal_equiv"]])
```

### Como leer la salida

En la cola izquierda la densidad de la mixtura es **varios ordenes de magnitud
mayor** que la de la normal equivalente. Eso es exactamente lo que significa
"colas pesadas": eventos extremos mucho mas probables de lo que dice la normal.

Es la leccion practica de toda la clase: **dos distribuciones con identica media
y varianza pueden tener riesgo de cola completamente distinto.**

---

# Parte E - Resolucion de la Ejercitacion 1

## 16. Guion completo

### Ejercicio 1 - momentos de la normal estandar

Teorico. Ver punto 10: argumento de paridad para $E(Z)$ y $E(Z^3)$; definicion
para $E(Z^2)$; integracion por partes o mgf para $E(Z^4)=3$.

### Ejercicio 2 - mixtura

Ver puntos 13 a 15. Respuesta: asimetrica **negativa** ($S=-0.89$) y leptocurtica
($K=4.85$). Los coeficientes se calculan con los momentos centrados de la
mixtura, no promediando los de cada componente.

### Ejercicio 3 - activo real

```python
import yfinance as yf, numpy as np, pandas as pd
from scipy import stats
import matplotlib.pyplot as plt

# (0) datos: 3 a 5 anios
data = yf.download("MELI", period="5y", interval="1d", auto_adjust=True)

px = pd.DataFrame()
px["Close"] = data["Close"]["MELI"]      # yfinance devuelve MultiIndex

# (a) retornos simples
px["ret"] = px["Close"].pct_change()
ret = px["ret"].dropna()

# (b) media, volatilidad, asimetria, curtosis
print("media     ", ret.mean())
print("volatilidad", ret.std())
print("asimetria ", stats.skew(ret))
print("curtosis  ", stats.kurtosis(ret, fisher=False))   # cruda

# (c) histograma
plt.hist(ret, bins=50, edgecolor="black", alpha=0.7)
plt.title("Histograma de retornos"); plt.show()

# (d) Jarque-Bera
jb, p = stats.jarque_bera(ret)
print("JB:", jb, "p-value:", p)
print("Rechazamos normalidad al 5%" if p < 0.05 else "No rechazamos")

# (e) log-retornos y verificacion de aditividad
px["ret_log"] = np.log(px["Close"] / px["Close"].shift(1))

mes = "2025-06"
suma = px.loc[mes, "ret_log"].sum()

pos = px.index.get_loc(px.loc[mes].index[0])
directo = np.log(px.loc[mes, "Close"].iloc[-1] / px["Close"].iloc[pos - 1])

print(suma, directo)     # iguales
```

### Como redactar la conclusion del punto (d)

```text
El estadistico de Jarque-Bera es JB = [valor], con p-value = 0.0000.
Como el p-value es menor que 0.05, rechazo la hipotesis nula de normalidad
al 5% de significancia.

El rechazo se explica por los dos componentes del estadistico: la curtosis
cruda es [valor] > 3, es decir colas mas pesadas que la normal, y la asimetria
es [valor], lo que indica [simetria aproximada / cola izquierda pesada].

Esto es consistente con lo que muestra el QQ plot, donde los puntos de ambos
extremos se despegan de la recta de 45 grados.
```

---

## 17. Errores frecuentes

| Error | Por que pasa | Como se evita |
|---|---|---|
| `scale=4` para $N(-1.5,4)$ | `scipy` pide desvio, no varianza | `scale=np.sqrt(4)` = 2 |
| Confundir curtosis cruda con en exceso | `fisher=True` es el default | `stats.kurtosis(x, fisher=False)` para la cruda |
| $130 \times (1-0.10)$ en el Ejercicio 1 | tratar un log-retorno como simple | $130 \cdot e^{-0.10}$ |
| Promediar asimetrias de la mixtura | no es lineal | usar momentos centrados $\mu_3$, $\mu_4$ |
| Primera fila `NaN` rompe el calculo | `pct_change()` la genera | `.dropna()` antes de estadisticos |
| Retornos con saltos raros | falta ajustar por splits | `auto_adjust=True` |
| Comparar mixtura contra $N(0,1)$ | mezcla ubicacion, escala y forma | comparar contra la normal equivalente |
| Calcular retornos sin ordenar | el DataFrame venia desordenado | `df.sort_values('Date')` primero |

---

## 18. Checklist de Clase 1

Al terminar deberias poder:

1. Escribir y distinguir retorno simple, bruto y logaritmico.
2. Explicar de donde sale $\ln(1+R) \approx R$ (Taylor en $x_0=1$).
3. Decir cuando la aproximacion es mala y por que importa para el riesgo.
4. Demostrar que los log-retornos se suman en el tiempo.
5. Resolver los ejercicios 1 y 2 del PDF sin dudar del signo.
6. Calcular media y volatilidad y saber que divisor usa cada libreria.
7. Estandarizar una variable y justificar por que con $E(a+bX)$ y $Var(a+bX)$.
8. Calcular el retorno minimo al $cl\%$ de confianza bajo normalidad.
9. Definir e interpretar asimetria.
10. Definir curtosis, curtosis en exceso, y las tres categorias.
11. Justificar por que la normal tiene $S=0$ y $K=3$.
12. Plantear el Jarque-Bera, su $H_0$, su distribucion y sus criticos.
13. Construir e interpretar un QQ plot, incluida la forma de S invertida.
14. Construir una mixtura de normales y calcular sus cuatro momentos.
15. Explicar por que una mixtura de normales no es normal.
16. Explicar por que dos distribuciones con igual media y varianza pueden tener
    riesgo de cola muy distinto.

---

## 19. Notas tecnicas

- Dependencias: `pandas`, `numpy`, `matplotlib`, `scipy`, `statsmodels`,
  `yfinance` y `openpyxl` (para `read_excel`).
- El notebook `01_01` lee `SP500.xlsx` sin ruta; el archivo del repo esta en
  `Bases de Datos MIA103/SP500_.xlsx` (con guion bajo). Hay que ajustar el nombre
  y la ruta.
- `yfinance` puede devolver columnas MultiIndex segun la version: si
  `df["Close"]` falla, probar `df["Close"][ticker]`.
- Los numeros que salen de Yahoo Finance cambian con la fecha de descarga. Las
  **interpretaciones** no cambian; los valores puntuales si.
- El notebook `Clase_00_Intro_practica.ipynb` es repaso de herramientas:
  `np.array`, `np.arange`, `np.linspace`, `np.random.normal`, `pd.DataFrame`,
  `plt.plot`, `plt.hist`, `to_csv` / `read_csv`. No tiene teoria propia.
