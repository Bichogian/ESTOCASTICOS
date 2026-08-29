# Clase 2 - PBI, crecimiento, tendencia y ciclo

[Volver al indice general](../Res+Pra.md)

Mapa completo de la Clase 2: teoria del PDF, codigo de los notebooks y
Ejercitacion 2. Cada tema sigue el mismo recorrido:

$$\text{teoria} \;\rightarrow\; \text{para que sirve} \;\rightarrow\; \text{codigo generico} \;\rightarrow\; \text{como leer la salida}$$

## Archivos de esta clase

| Tipo | Archivo | Para que se usa |
|---|---|---|
| Teoria | `Clases/MIA103_Clase_2.pdf` | PBI, tasas de crecimiento, tendencia y ciclo |
| Python | `Codigos/MIA103_2026_Clase_02_PBI_Argentina.ipynb` | PBI Argentina: log, media movil, filtro HP |
| Python | `Codigos/MIA103_2026_Clase_02_Ejercicios_1_y_2.ipynb` | Mixturas de la practica + bootstrap + QQ plot |
| Python | `Codigos/MIA103_2026_Clase_02_Ejercicio_3.ipynb` | PBI de EEUU: media movil y HP |
| Practica | `Practicas/MIA103_Ejer_2.pdf` | Ejercicios 1, 2 y 3 |
| Resuelta | `Practicas_Resueltas/Respuestas_2.ipynb` | Resolucion propia |
| Datos | `Excels/MIA103_Clase_2.xlsx` | Hojas `PBI Real Arg`, `Med Mov`, `HP`, `PBI Real USA` |

## Mapa tema - PDF - notebook - practica

| # | Tema | PDF | Notebook | Practica |
|---:|---|---|---|---|
| 1 | PBI nominal vs real | p. 1-2 | - | - |
| 2 | Tasa de crecimiento y acumulada | p. 3-4 | `PBI_Argentina` celda 7 | - |
| 3 | Tasa promedio anual (radicacion) | p. 5 | `PBI_Argentina` celda 7 | - |
| 4 | Escala logaritmica | p. 5-6 | `PBI_Argentina` celda 9 | - |
| 5 | Descomposicion $y_t = y_t^g + y_t^c$ | p. 7 | - | Ej. 3 |
| 6 | Tendencia deterministica | p. 8 | (se ve en Clase 3) | - |
| 7 | Medias moviles centradas | p. 9-10 | `PBI_Argentina` celdas 11-15 | Ej. 3 |
| 8 | Filtro Hodrick-Prescott | p. 10-12 | `PBI_Argentina` celdas 17-21 | Ej. 3 |
| 9 | Mixturas (repaso de Clase 1) | - | `Ejercicios_1_y_2` | Ej. 1 y 2 |
| 10 | Bootstrap y QQ plot | - | `Ejercicios_1_y_2` celdas 9-10 | Ej. 1e, 2j |

---

# Parte A - PBI y tasas de crecimiento

## 1. PBI nominal vs PBI real

### Teoria

$$PBI\ Nominal_t = \sum_i P_i^t \, Q_i^t \qquad\qquad PBI\ Real_t = \sum_i P_i^0 \, Q_i^t$$

La unica diferencia es el precio con que se valua: el nominal usa los precios
**del periodo $t$**, el real usa los precios de un **anio base** fijo (el "Anio 0").

### Para que sirve

El nominal sube si suben los precios **o** si suben las cantidades: mezcla
inflacion con crecimiento. El real solo sube si suben las **cantidades**.

Por eso en economia se trabaja con el PBI real: decimos que la economia **crece**
cuando el PBI real crece y que esta en **recesion** cuando cae.

### Idea para recordar

Real = cantidades a precios constantes. Es la unica medida que aisla produccion
de inflacion.

---

## 2. Tasa de crecimiento y tasa acumulada

### Teoria

Tasa de un periodo al siguiente:

$$g_t = \frac{PBI_t - PBI_{t-1}}{PBI_{t-1}} = \frac{PBI_t}{PBI_{t-1}} - 1
\qquad\Longrightarrow\qquad 1 + g_t = \frac{PBI_t}{PBI_{t-1}}$$

Tasa acumulada entre dos anios cualesquiera:

$$1 + g_{acum} = \frac{PBI_{98}}{PBI_{63}}$$

### Ejemplo del PDF

$$1 + g_{acum} = \frac{705822}{270609} = 2.6085 \;\Longrightarrow\; g_{acum} = 1.6085$$

Se lee: **entre 1963 y 1998 el PBI real de Argentina crecio 160.85%** en total
(35 anios acumulados).

### Codigo generico

```python
df["g"] = df["gdp"].pct_change()                     # tasa periodo a periodo
g_acum  = df["gdp"].iloc[-1] / df["gdp"].iloc[0] - 1 # acumulada de toda la serie
```

### Como leer la salida

`g_acum = 1.6085` **no** es "creció 1.6%": es 160.85%. Es un error de lectura
frecuente cuando el crecimiento acumulado supera el 100%.

---

## 3. Tasa de crecimiento promedio anual

### Teoria

La relacion entre la tasa acumulada en $n$ periodos y la tasa de cada periodo es
**multiplicativa**, no aditiva:

$$1 + g_{acum} = (1 + g)^n$$

Despejando con radicacion:

$$g = (1 + g_{acum})^{1/n} - 1$$

### Ejemplo del PDF

$$2.6085 = (1+g)^{35} \;\Longrightarrow\; 1 + g = 2.6085^{1/35} = 1.0277$$

La tasa de crecimiento promedio anual entre 1963 y 1998 fue **2.77%**.

### Para que sirve

Responde: "si la economia hubiera crecido siempre al mismo ritmo, a que tasa
tendria que haber crecido para acumular ese total". Es la tasa geometrica, no el
promedio simple de las tasas anuales.

### Codigo generico

```python
n = df["year"].iloc[-1] - df["year"].iloc[0]

# version exacta (radicacion)
g = (df["gdp"].iloc[-1] / df["gdp"].iloc[0])**(1/n) - 1

# version logaritmica (la del notebook)
g_log = (1/n) * np.log(df["gdp"].iloc[-1] / df["gdp"].iloc[0])
```

### Como leer la salida

Las dos dan casi lo mismo, porque $\ln(1+g) \approx g$ (Taylor, Clase 1):

```text
exacta:      2.7770 %
logaritmica: 2.7391 %
```

La logaritmica siempre da un poco **menos**. Con tasas chicas la diferencia es
irrelevante; con tasas grandes hay que usar la exacta.

**Nunca promediar las tasas anuales sumandolas y dividiendo por $n$**: eso da un
promedio aritmetico que sobreestima el crecimiento real.

---

## 4. Escala logaritmica

### Teoria

Graficar $\ln(PBI_t)$ en vez de $PBI_t$. La ventaja es que la **pendiente del
grafico es directamente la tasa de crecimiento**:

$$\frac{\ln PBI_{98} - \ln PBI_{63}}{98 - 63} = \frac{1}{35}\ln\!\left(\frac{PBI_{98}}{PBI_{63}}\right) = \ln\!\left(\frac{PBI_{98}}{PBI_{63}}\right)^{1/35}$$

Y lo de adentro del logaritmo es $(1+g_{acum})^{1/n} = 1+g$, asi que la pendiente
es $\ln(1+g) \approx g$.

### Para que sirve

Tres cosas que en escala normal no se ven:

1. Una serie que crece a tasa constante se ve como una **recta**. En escala normal
   se ve como una exponencial.
2. Se pueden comparar visualmente periodos con niveles muy distintos: la misma
   pendiente significa la misma tasa, aunque el nivel sea 10 veces mayor.
3. Habilita la descomposicion tendencia-ciclo aditiva del punto 5.

### Codigo generico

```python
df["log_pbi"] = np.log(df["gdp"])

plt.plot(df["year"], df["log_pbi"])
```

### Como leer la salida

En el grafico del PDF, el $\ln$ del PBI argentino va de $12.51$ (1950) a $13.47$
(2019). La diferencia $13.47 - 12.51 = 0.96$ es el crecimiento logaritmico
acumulado en 69 anios: aproximadamente $e^{0.96} = 2.6$, o sea el PBI se
multiplico por 2.6.

Tramos con **pendiente mas empinada** = periodos de crecimiento mas rapido.
Tramos planos u horizontales = estancamiento.

---

# Parte B - Descomponer tendencia y ciclo

## 5. La descomposicion

### Teoria

Trabajando sobre la serie en logaritmos, que llamamos $y_t$:

$$y_t = y_t^g + y_t^c$$

- $y_t^g$: componente **tendencial** (el PBI potencial o de largo plazo).
- $y_t^c$: componente **ciclico** (los desvios de corto plazo).

### Para que sirve

Separa dos preguntas distintas:

- "cuanto puede producir esta economia en el largo plazo" (tendencia, depende de
  capital, trabajo, tecnologia);
- "estamos por encima o por debajo de ese potencial ahora" (ciclo).

Cuando $y_t^c > 0$ la economia esta en **auge**; cuando $y_t^c < 0$, en
**recesion**.

### Por que en logaritmos

Porque en logaritmos la descomposicion es **aditiva** y el ciclo se lee
directamente como desvio porcentual. Un $y_t^c = -0.05$ significa "el PBI esta 5%
por debajo de su tendencia".

### Las tres formas de hacerlo

| Metodo | Idea | Donde se ve |
|---|---|---|
| Tendencia deterministica | ajustar una recta a $y_t$ | PDF p. 8, se resuelve en Clase 3 con regresion |
| Medias moviles | promediar ventanas centradas | punto 6 |
| Filtro Hodrick-Prescott | problema de optimizacion | punto 7 |

---

## 6. Medias moviles centradas

### Teoria

La tendencia es el promedio de $y_t$ en una ventana **simetrica** de ancho
$2n+1$: $n$ hacia atras, $n$ hacia adelante, mas la contemporanea.

$$y_t^g = \frac{1}{2n+1}\sum_{j=-n}^{n} y_{t+j}$$

Y el ciclo por diferencia:

$$y_t^c = y_t - y_t^g$$

### Para que sirve

La logica es: si un ciclo completo (auge + recesion) dura aproximadamente esa
cantidad de anios, al promediar la ventana los positivos del auge cancelan los
negativos de la recesion y lo que queda es la tendencia.

### Eleccion de $n$

$n$ es el **parametro de suavizado**. El valor tipico con datos anuales es
$n = 5$, o sea una ventana de 11 anios, porque uno espera que un ciclo economico
completo entre en esa ventana.

- $n$ mas grande $\rightarrow$ tendencia mas suave, pero se pierde mas informacion
  en las puntas.
- Por eso **no conviene tomar $n$ grande respecto de $T$** (total de
  observaciones).

### Codigo generico

```python
df["ygmm"]  = df["log_pbi"].rolling(window=11, center=True).mean()
df["ciclo"] = df["log_pbi"] - df["ygmm"]
```

`window=11` es $2n+1$ con $n=5$. **`center=True` es imprescindible**: sin eso
pandas alinea la ventana hacia atras y la "tendencia" queda desfasada 5 anios.

### Como leer la salida

**Los primeros y ultimos $n$ valores son `NaN`.** Con ventana 11 son 5 al inicio
y 5 al final:

```text
NaN en ygmm: 10 en total (5 al inicio + 5 al final)
```

Es la limitacion estructural del metodo: no se puede calcular un promedio
centrado sin datos a ambos lados. Justamente por eso no se recomienda una ventana
muy ancha.

Graficar el ciclo con una linea horizontal en cero ayuda a leerlo:

```python
plt.plot(df["year"], df["ciclo"])
plt.axhline(0, color="black", linestyle="--")
```

Arriba de cero = auge; abajo = recesion.

---

## 7. Filtro de Hodrick-Prescott

### Teoria

HP tambien parte de $y_t = y_t^g + y_t^c$, pero obtiene la descomposicion
resolviendo un problema de optimizacion:

$$\min_{y_t^g,\, y_t^c} \;\; \sum_{t=0}^{T} \left(y_t^c\right)^2 \;+\; \gamma \sum_{t=1}^{T-1}\left[\left(y_{t+1}^g - y_t^g\right) - \left(y_t^g - y_{t-1}^g\right)\right]^2$$

con $\gamma > 0$. Como $y_t^c = y_t - y_t^g$, se reescribe dependiendo solo de la
tendencia:

$$\min_{y_t^g} \;\; \sum_{t=0}^{T}\left(y_t - y_t^g\right)^2 \;+\; \gamma \sum_{t=1}^{T-1}\left[\left(y_{t+1}^g - y_t^g\right) - \left(y_t^g - y_{t-1}^g\right)\right]^2$$

### Como entender los dos terminos

**Primer termino**: quiere que el ciclo sea chico, es decir que la tendencia pegue
lo mas cerca posible de los datos. Si fuera lo unico, la solucion seria trivial:
$y_t^g = y_t$, ciclo cero. Pero esa tendencia oscilaria con el ciclo, y entonces
no serviria como "tendencia".

**Segundo termino**: penaliza los **cambios en la pendiente** de la tendencia. Si
la derivada hacia atras $(y_t^g - y_{t-1}^g)$ es muy distinta de la derivada hacia
adelante $(y_{t+1}^g - y_t^g)$, esa diferencia se eleva al cuadrado y se multiplica
por $\gamma$. Es lo que impide la solucion trivial.

**$\gamma$ es el trade-off**: cuanto mas grande, mas se castiga que la tendencia
se curve, y por lo tanto mas parecida a una recta queda.

### Para que sirve

Es el metodo estandar en macroeconomia para estimar producto potencial y brecha
del producto (output gap). A diferencia de la media movil, **no pierde
observaciones en las puntas**.

### Codigo generico

```python
from statsmodels.tsa.filters.hp_filter import hpfilter

cycle, trend = hpfilter(df["log_pbi"], lamb=100)

df["y_c"] = cycle
df["y_g"] = trend
```

**Trampa de la funcion**: `hpfilter` devuelve **(ciclo, tendencia)** en ese orden.
Es contraintuitivo y es el error mas comun. Si el "ciclo" te queda con forma de
serie creciente, invertiste el orden.

### Valores tipicos de $\lambda$

| Frecuencia | $\lambda$ |
|---|---|
| Anual | 100 (a veces 6.25) |
| Trimestral | 1600 |
| Mensual | 14400 |

En la practica se pide $\lambda = 100$ porque los datos son anuales.

### Que pasa si $\gamma$ (o $\lambda$) es mayor

Es la pregunta con la que cierra el PDF. Respuesta verificada sobre el PBI de
EEUU:

```text
lambda =     6.25  ->  desvio del ciclo = 0.0296
lambda =      100  ->  desvio del ciclo = 0.0550
lambda =     1600  ->  desvio del ciclo = 0.0750
lambda =    10000  ->  desvio del ciclo = 0.0801
```

**A mayor $\lambda$, la tendencia se vuelve mas rigida (tiende a una recta) y por
lo tanto el ciclo absorbe mas variabilidad.** En el limite $\lambda \to \infty$ la
tendencia es exactamente una recta y el filtro coincide con la tendencia
deterministica del punto 6 del PDF.

En el limite opuesto, $\lambda \to 0$, la tendencia se pega a los datos y el ciclo
tiende a cero.

---

# Parte C - Ejercitacion 2

## 8. Ejercicio 1: mixtura de dos normales con la misma media

### Enunciado

$$f(x) = 0.4\,\varphi_1(x) + 0.6\,\varphi_2(x), \qquad X_1 \sim N(-1,\,9),\; X_2 \sim N(-1,\,4)$$

### Codigo

```python
import numpy as np, pandas as pd
import scipy.stats as stats

w1, mu1, var1 = 0.4, -1, 9
w2, mu2, var2 = 0.6, -1, 4

z = np.arange(-10, 10.05, 0.1)
df = pd.DataFrame({"z": z})

df["pdf_1"]    = stats.norm.pdf(df["z"], loc=mu1, scale=np.sqrt(var1))  # scale=3
df["pdf_2"]    = stats.norm.pdf(df["z"], loc=mu2, scale=np.sqrt(var2))  # scale=2
df["pdf_mixt"] = w1*df["pdf_1"] + w2*df["pdf_2"]
```

### Momentos (mismas formulas que Clase 1)

```python
mu_mix  = w1*mu1 + w2*mu2
var_mix = w1*(var1 + (mu1-mu_mix)**2) + w2*(var2 + (mu2-mu_mix)**2)

mu_3 = (w1*((mu1-mu_mix)**3 + 3*(mu1-mu_mix)*var1)
      + w2*((mu2-mu_mix)**3 + 3*(mu2-mu_mix)*var2))
mu_4 = (w1*((mu1-mu_mix)**4 + 6*(mu1-mu_mix)**2*var1 + 3*var1**2)
      + w2*((mu2-mu_mix)**4 + 6*(mu2-mu_mix)**2*var2 + 3*var2**2))

skew = mu_3 / var_mix**1.5
kurt = mu_4 / var_mix**2
```

### Salida verificada

```text
media     = -1.0000
varianza  =  6.0000     desvio = 2.4495
asimetria =  0.0000
curtosis  =  3.5000     en exceso = 0.5000
```

### Respuestas

**(b) Es asimetrica?** **No.** Es perfectamente simetrica, y se ve en el grafico:
las dos componentes tienen **la misma media** $\mu = -1$, entonces cada una es
simetrica alrededor del mismo punto y la mezcla tambien lo es. El calculo lo
confirma: $S = 0$ exacto.

**(c)** Media $-1$, varianza $6$, asimetria $0$, curtosis $3.5$.

Notar que la varianza $= 0.4(9) + 0.6(4) = 6$: cuando las medias coinciden, el
termino $(\mu_i - \mu_{mix})^2$ se anula y la varianza es el simple promedio
ponderado de las varianzas.

**(d) Es leptocurtica?** **Si**: $K = 3.5 > 3$, o sea $K_E = 0.5 > 0$.

Esta es la leccion del ejercicio: **una mixtura puede ser simetrica y aun asi
tener colas mas pesadas que la normal.** Mezclar dos normales con varianzas
distintas (9 y 4) genera exceso de curtosis aunque no genere asimetria.

En el grafico contra la normal equivalente $N(-1, 6)$ se ve el patron tipico de
leptocurtosis: **mas alta en el centro, mas baja en los hombros, mas alta en las
colas.**

---

## 9. Ejercicio 2: mixtura bimodal

### Enunciado

$$f(x) = 0.35\,\varphi_1(x) + 0.65\,\varphi_2(x), \qquad X_1 \sim N(1.2,\,0.09),\; X_2 \sim N(-0.8,\,0.81)$$

### Salida verificada

```text
media     = -0.1000
varianza  =  1.4680     desvio = 1.2116
asimetria = -0.2456
curtosis  =  2.0004     en exceso = -0.9996

modas locales del grafico: z = -0.80  y  z = 1.19
```

### Respuestas al inciso (g), que es una trampa triple

La pregunta es: *asimetrica positiva? leptocurtica? bimodal?* Las tres respuestas
van contra la intuicion:

| Pregunta | Respuesta | Por que |
|---|---|---|
| Asimetrica **positiva**? | **No: es negativa** ($S = -0.2456$) | la componente pesada (peso 0.65) esta a la izquierda y es la mas dispersa |
| **Leptocurtica**? | **No: es platicurtica** ($K = 2.00 < 3$) | $K_E = -1.00$, colas mas livianas que la normal |
| **Bimodal**? | **Si**, con modas en $-0.80$ y $1.19$ | las medias estan lejos respecto de los desvios (0.3 y 0.9) |

### Por que este caso es tan distinto al Ejercicio 1

En el Ejercicio 1 las medias coincidian y las varianzas diferian: eso genera
**exceso de curtosis sin asimetria**.

Aca las medias estan **muy separadas** ($1.2$ vs $-0.8$) respecto de los desvios
($0.3$ y $0.9$). Cuando las componentes se separan tanto, la densidad se parte en
dos jorobas y la masa se distribuye "hacia los costados en vez de hacia las
colas": el resultado es **platicurtico**, la forma achatada.

### Como saberlo de antemano

Regla practica: si la distancia entre las medias es grande respecto de los
desvios, la mixtura tiende a ser **bimodal y platicurtica**. Si las medias son
parecidas pero las varianzas muy distintas, tiende a ser **unimodal y
leptocurtica**.

### Idea para recordar

**Bimodal y platicurtica van juntas.** Y una curtosis menor a 3 no significa
"menos riesgo": significa que la forma no se parece a una normal, en la direccion
opuesta a la habitual.

---

## 10. Generar una muestra de la mixtura y hacer el QQ plot

### Teoria

Para simular una mixtura se hace exactamente lo que dice la definicion: se sortea
de que componente sale cada observacion.

### Codigo generico

```python
n = 2000

x1 = np.random.normal(mu1, np.sqrt(var1), size=n)
x2 = np.random.normal(mu2, np.sqrt(var2), size=n)
u  = np.random.uniform(size=n)

muestra = np.where(u < w1, x1, x2)   # con prob w1 toma x1, si no x2
```

`np.where(u < w1, x1, x2)` es la clave: la uniforme decide componente por
componente con la probabilidad correcta.

### QQ plot manual (el que pide la practica)

```python
m_est = np.sort((muestra - muestra.mean()) / muestra.std())
cuantiles_teoricos = stats.norm.ppf(np.arange(1, n+1) / n)

plt.scatter(m_est, cuantiles_teoricos)
plt.plot([-4, 4], [-4, 4], 'r--')
plt.xlabel("Valores simulados estandarizados")
plt.ylabel("Valores teoricos")
plt.show()
```

La consigna pide **teoricos en el eje vertical** y **simulados estandarizados en
el horizontal**, que es al reves de lo que hace `sm.qqplot`. Por eso conviene
hacerlo a mano.

### Como leer la salida

| Ejercicio | Forma esperada | Lectura |
|---|---|---|
| Ej. 1 (leptocurtica, $K_E = 0.5$) | extremos que se despegan hacia afuera de la recta | colas mas pesadas que la normal |
| Ej. 2 (platicurtica, $K_E = -1.0$) | extremos que se doblan hacia **adentro** de la recta | colas mas livianas; el centro se aparta por la bimodalidad |

En el caso bimodal el QQ plot muestra ademas un "escalon" o cambio de pendiente
en la zona central: es la firma grafica de las dos jorobas.

### Nota tecnica

`stats.norm.ppf(np.arange(1, n+1)/n)` genera un **infinito** en la ultima
posicion, porque $\Phi^{-1}(1) = +\infty$. Es lo que hace el notebook de clase y
funciona igual porque matplotlib ignora el punto, pero la version robusta es:

```python
cuantiles_teoricos = stats.norm.ppf((np.arange(1, n+1) - 0.5) / n)
```

---

## 11. Ejercicio 3: descomponer el PBI de EEUU

### Enunciado

Descomponer el PBI de EEUU en tendencia y ciclo con (1) filtro HP con
$\lambda = 100$ y (2) medias moviles de 11 observaciones. Graficar serie
observada + tendencia por un lado, y ciclo por otro. **Trabajar en logaritmos.**

### Codigo completo

```python
import pandas as pd, numpy as np
import matplotlib.pyplot as plt
from statsmodels.tsa.filters.hp_filter import hpfilter

df = pd.read_excel("Excels/MIA103_Clase_2.xlsx", sheet_name="PBI Real USA",
                   usecols="B:C", skiprows=10, nrows=96)

df = df.sort_values("Año").reset_index(drop=True)
df["log_pbi"] = np.log(df["GDPCA"])

# (2) medias moviles
df["ygmm"]     = df["log_pbi"].rolling(window=11, center=True).mean()
df["ciclo_mm"] = df["log_pbi"] - df["ygmm"]

# (1) filtro HP
cycle, trend = hpfilter(df["log_pbi"], lamb=100)
df["y_c"], df["y_g"] = cycle, trend

# graficos: serie + tendencia
plt.plot(df["Año"], df["log_pbi"], label="log(PBI)")
plt.plot(df["Año"], df["y_g"], "--", label="Tendencia HP")
plt.legend(); plt.show()

# graficos: ciclo
plt.plot(df["Año"], df["y_c"], label="Ciclo HP")
plt.axhline(0, color="gray", linestyle="--")
plt.legend(); plt.show()
```

### Salida verificada

```text
periodo: 1929 - 2023 (95 observaciones)
crecimiento logaritmico promedio anual: 3.12 %

desvio del ciclo HP (lambda=100): 0.0550
desvio del ciclo por media movil: 0.0525

5 peores anios del ciclo HP          5 mejores anios del ciclo HP
1933   -0.1653                        1944   +0.2055
1932   -0.1303                        1929   +0.1950
1949   -0.0961                        1943   +0.1889
1934   -0.0952                        1945   +0.1455
1938   -0.0941                        1942   +0.1007
```

### Como leer la salida

Este es el mejor control de sanidad posible: **los resultados coinciden con la
historia economica**.

- Los peores anios son **1932-1934**: la Gran Depresion. Un ciclo de $-0.165$
  significa que el PBI estuvo aproximadamente **16.5% por debajo de su
  tendencia**.
- Los mejores son **1942-1945**: la movilizacion industrial de la Segunda Guerra
  Mundial. En 1944 el PBI estuvo 20% **por encima** de la tendencia.
- 1929 aparece alto porque es el pico previo al crack; el filtro lo lee como auge
  respecto de la tendencia de largo plazo.

Si tus peores anios no son los de la Depresion, algo esta mal: probablemente
invertiste `cycle, trend`.

### Comparacion de los dos metodos

```text
                      HP (lambda=100)      Media movil (11)
observaciones utiles  todas (95)           85 (pierde 5 y 5)
desvio del ciclo      0.0550               0.0525
```

Los dos ciclos son muy parecidos en el centro de la muestra. La diferencia
practica es que **HP cubre toda la serie** y la media movil pierde las puntas, que
suelen ser justamente los anios que mas interesan (los mas recientes).

La contracara: HP en las puntas es menos confiable de lo que parece (problema de
"end-point bias"), solo que en vez de devolver `NaN` devuelve un numero.

---

## 12. Errores frecuentes

| Error | Por que pasa | Como se evita |
|---|---|---|
| `trend, cycle = hpfilter(...)` | el orden real es al reves | `cycle, trend = hpfilter(...)` |
| Media movil desfasada | falta `center=True` | `rolling(window=11, center=True)` |
| Descomponer la serie en niveles | el ciclo queda en unidades, no en % | tomar `np.log()` primero |
| Promediar tasas anuales sumando | el crecimiento es multiplicativo | $(1+g_{acum})^{1/n}-1$ |
| Leer $g_{acum}=1.6085$ como 1.6% | es 160.85% | multiplicar por 100 al final |
| `scale=varianza` en `norm.pdf` | scipy pide desvio | `scale=np.sqrt(var)` |
| Asumir que bimodal implica leptocurtica | es al reves | bimodal tiende a **platicurtica** |
| Olvidar los `NaN` de la media movil | son estructurales | `.dropna()` antes de estadisticos del ciclo |
| No ordenar por anio | el Excel/csv puede venir desordenado | `sort_values(...).reset_index(drop=True)` |

---

## 13. Checklist de Clase 2

Al terminar deberias poder:

1. Definir PBI nominal y real y explicar que aisla cada uno.
2. Calcular tasa de crecimiento, acumulada y promedio anual.
3. Justificar por que la tasa promedio usa radicacion y no promedio simple.
4. Explicar por que en escala logaritmica la pendiente es la tasa de crecimiento.
5. Escribir $y_t = y_t^g + y_t^c$ e interpretar el signo del ciclo.
6. Explicar por que la descomposicion se hace en logaritmos.
7. Calcular una media movil centrada y decir cuantos datos se pierden y por que.
8. Justificar la eleccion de la ventana $2n+1$.
9. Escribir el problema de optimizacion de HP y explicar los dos terminos.
10. Explicar el rol de $\gamma$ (o $\lambda$) y que pasa en los dos limites.
11. Elegir $\lambda$ segun la frecuencia de los datos.
12. Comparar ventajas y desventajas de media movil vs HP.
13. Calcular los cuatro momentos de una mixtura.
14. Explicar por que una mixtura simetrica puede ser leptocurtica.
15. Explicar por que una mixtura bimodal tiende a ser platicurtica.
16. Simular una mixtura con `np.where` y una uniforme.
17. Construir e interpretar un QQ plot en los dos casos.

---

## 14. Notas tecnicas

- Dependencias: `pandas`, `numpy`, `matplotlib`, `scipy`, `statsmodels`,
  `openpyxl`.
- El notebook de Argentina lee `year_gdp_Argentina.csv`, que **no esta en el
  repositorio**. Los datos equivalentes estan en `Excels/MIA103_Clase_2.xlsx`,
  hoja `PBI Real Arg`. Fuente original: FRED, serie `RGDPNAARA666NRUG`.
- El notebook del Ejercicio 3 lee `MIA103_Clase_2.xlsx` sin ruta; en el repo esta
  en `Excels/`.
- La lectura `usecols="B:C", skiprows=10, nrows=96` esta calibrada al layout
  exacto de la hoja `PBI Real USA`. Si se edita el Excel, hay que recalibrar.
- El Excel tiene ademas las hojas `Med Mov` y `HP`, que son la version en planilla
  de lo mismo (el PDF menciona resolver HP con Solver).
- `hpfilter` devuelve objetos `Series` alineados al indice del input: si el
  DataFrame tiene indice raro, conviene `reset_index(drop=True)` antes.
