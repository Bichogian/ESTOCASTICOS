# Clase 3 - Regresion lineal simple, MCO e inferencia

[Volver al indice general](../Res+Pra.md)

Mapa completo de la Clase 3: teoria del PDF, codigo de los notebooks y
Ejercitacion 3. Cada tema sigue el mismo recorrido:

$$\text{teoria} \;\rightarrow\; \text{para que sirve} \;\rightarrow\; \text{codigo generico} \;\rightarrow\; \text{como leer la salida}$$

## Archivos de esta clase

| Tipo | Archivo | Para que se usa |
|---|---|---|
| Teoria | `Clases/MIA103_Clase_3.pdf` | MCO, insesgadez, Gauss-Markov, inferencia |
| Python | `Codigos/MIA103_2026_Clase_03.ipynb` | Simulacion y primera regresion |
| Python | `Codigos/MIA103_2026_Clase_03_profundización.ipynb` | Anatomia completa de la salida de `statsmodels` |
| Python | `Codigos/MIA103_2026_Clase_03_Ejercicios.ipynb` | Resolucion de la Ejercitacion 3 |
| Practica | `Practicas/MIA103_Ejer_3.pdf` | Ejercicios 1, 2 y 3 |
| Resuelta | `Practicas_Resueltas/Respuestas_3.ipynb` | Resolucion propia |
| Datos | `Bases de Datos MIA103/ceo.xlsx` | Ganancias y compensacion de CEOs (70 obs) |
| Datos | `Bases de Datos MIA103/MIA103 Ejercitación 3 Datos.xlsx` | IBM, S&P500, T-Bill 3m y hoja de CEOs |

## Mapa tema - PDF - notebook - practica

| # | Tema | PDF | Notebook | Practica |
|---:|---|---|---|---|
| 1 | Modelo, error y residuo | p. 2-6 | `Clase_03` celda 4 | - |
| 2 | MCO: CPO y ecuaciones normales | p. 6-10 | - | Ej. 1 |
| 3 | $\hat\beta = Cov/Var$ | p. 11 | `Ejercicios` celda 2 | Ej. 1 |
| 4 | Propiedades de la recta estimada | p. 12 | `profundización` celdas 36-46 | - |
| 5 | TSS = ESS + RSS y $R^2$ | p. 14-16 | `profundización` celdas 12-25 | Ej. 3d, 2f |
| 6 | Insesgadez | p. 17-20 | - | - |
| 7 | Supuesto 2 y varianzas | p. 21-24 | `profundización` celdas 55-60 | - |
| 8 | Gauss-Markov (BLUE) | p. 25-28 | - | - |
| 9 | $s^2$ como estimador de $\sigma^2$ | p. 28-32 | `profundización` celdas 26-31 | - |
| 10 | Supuesto 3 y normalidad | p. 33-38 | - | - |
| 11 | De la normal a la t de Student | p. 40-46 | - | - |
| 12 | Test de hipotesis | p. 47-51 | `Ejercicios` celdas 14-26 | Ej. 2b, 2c, 3c |
| 13 | p-value | p. 52 | `Ejercicios` celda 44 | Ej. 3c |
| 14 | Intervalos de confianza | p. 53-54 | `Ejercicios` celda 27 | Ej. 2d |
| 15 | Bandas de confianza y prediccion | - | `profundización` celdas 61-89 | - |

---

# Parte A - El modelo y el metodo

## 1. Que observamos y que no

### Teoria

Observamos los pares $(y_i, x_i)$ para $i = 1,\dots,n$. El **Supuesto 1** es:

$$E(y_i) = \alpha + \beta x_i \tag{1}$$

De ahi:

$$y_i = \alpha + \beta x_i + \underbrace{\left(y_i - E(y_i)\right)}_{u_i} \;=\; \alpha + \beta x_i + u_i$$

| Observado | No observado |
|---|---|
| $y_i$, $x_i$ | $\alpha$, $\beta$, $u_i$ |

### Por que se puede estimar

Porque $\alpha$ y $\beta$ se suponen **identicos para todas las observaciones**.
Eso permite acumular informacion de las $n$ observaciones para estimar solo dos
numeros.

Punto conceptual del PDF: $\alpha$ y $\beta$ son **parametros**, no variables
aleatorias. Son numeros poblacionales desconocidos y fijos.

### Error vs residuo: la distincion clave

| | Definicion | Observable? |
|---|---|---|
| **Error** $u_i$ | $u_i = y_i - E(y_i)$, distancia a la recta **poblacional** | **No** |
| **Residuo** $e_i$ | $e_i = y_i - \hat{y}_i$, distancia a la recta **estimada** | **Si** |

donde $\hat{y}_i = \hat\alpha + \hat\beta x_i$ es el valor predicho.

**No son lo mismo y confundirlos es el error conceptual mas comun de la clase.**
El error existe aunque nunca lo veamos; el residuo es lo que efectivamente
calculamos y es una estimacion del error.

### Codigo generico

```python
import numpy as np, statsmodels.api as sm

np.random.seed(42)
n, alpha, beta = 150, 0.05, 1.5

x = np.random.normal(loc=1.0, scale=0.5, size=n)
u = np.random.normal(loc=0.0, scale=0.25, size=n)   # los errores VERDADEROS
y = alpha + beta*x + u
```

Simular es la unica situacion donde conocemos $\alpha$, $\beta$ y los $u_i$
verdaderos, y por eso sirve para ver que tan cerca queda la estimacion.

---

## 2. Minimos Cuadrados Ordinarios

### Teoria

MCO minimiza la suma de residuos al cuadrado, es decir la suma de las
**distancias verticales** al cuadrado:

$$S(a,b) = \sum_{i=1}^{n}\left(y_i - a - b x_i\right)^2$$

Condiciones de primer orden:

$$\frac{\partial S}{\partial a} = -2\sum_{i=1}^{n}(y_i - a - b x_i) = 0$$
$$\frac{\partial S}{\partial b} = -2\sum_{i=1}^{n}(y_i - a - b x_i)\,x_i = 0$$

Que dan las **ecuaciones normales**:

$$\text{I.}\;\; \sum_{i=1}^{n}\left(y_i - \hat\alpha - \hat\beta x_i\right) = 0 \qquad\qquad \text{II.}\;\; \sum_{i=1}^{n}\left(y_i - \hat\alpha - \hat\beta x_i\right)x_i = 0$$

### Las preguntas que plantea el PDF

- **Por que al cuadrado?** Para que los residuos positivos y negativos no se
  cancelen, y para penalizar mas los desvios grandes. Ademas hace el problema
  diferenciable (a diferencia del valor absoluto).
- **Por que distancias verticales y no horizontales?** Porque el modelo explica
  $y$ **dado** $x$: el error esta en $y$, no en $x$.
- **Da lo mismo que variable es $y$ y cual es $x$?** **No.** Regresar $y$ en $x$
  da una recta distinta que regresar $x$ en $y$. Solo coinciden si el ajuste es
  perfecto.

### Solucion

$$\boxed{\;\hat\alpha = \bar{y} - \hat\beta\bar{x}\;} \qquad\qquad \boxed{\;\hat\beta = \frac{\sum_{i=1}^{n}(x_i-\bar{x})(y_i-\bar{y})}{\sum_{i=1}^{n}(x_i-\bar{x})^2}\;}$$

$\hat\alpha$ sale directo de la ecuacion normal I: sumando y dividiendo por $n$
queda $n\bar{y} - n\hat\alpha - \hat\beta n \bar{x} = 0$.

$\hat\beta$ sale de sustituir $\hat\alpha$ en la ecuacion normal II.

---

## 3. $\hat\beta$ es covarianza sobre varianza (Ejercicio 1 de la practica)

### Teoria

Dividiendo numerador y denominador por $n$:

$$\hat\beta = \frac{\frac{1}{n}\sum(x_i-\bar{x})(y_i-\bar{y})}{\frac{1}{n}\sum(x_i-\bar{x})^2} = \frac{\widehat{Cov}(X,Y)}{\widehat{Var}(X)}$$

Ese es el Ejercicio 1: la demostracion es simplemente notar que el $1/n$ se
cancela y reconocer las definiciones muestrales.

### Relacion con la correlacion

$$\rho_{XY} = \frac{Cov(X,Y)}{\sigma_X \sigma_Y} \qquad\Longrightarrow\qquad \hat\rho^2_{XY} = \frac{\widehat{Cov}(X,Y)^2}{\widehat{Var}(X)\widehat{Var}(Y)} = \hat\beta\,\frac{\widehat{Cov}(X,Y)}{\widehat{Var}(Y)}$$

### Para que sirve: el beta financiero

Es la lectura que pide la practica. Cuando se calcula el **beta de un activo**
regresando su prima de riesgo contra la prima de riesgo del mercado:

$$\beta_{activo} = \frac{Cov(R_{activo}-R_f,\; R_m - R_f)}{Var(R_m - R_f)}$$

Es decir, el beta del CAPM **es** el coeficiente de una regresion simple. No hay
dos conceptos distintos.

---

## 4. Propiedades de la recta estimada

### Teoria

Del PDF, cuatro propiedades que salen de las ecuaciones normales:

1. **La recta pasa por el punto de medias** $(\bar{x}, \bar{y})$.
2. $\displaystyle\sum_{i=1}^{n} e_i = 0$ (los residuos suman cero, y su media es cero).
3. $\displaystyle\sum_{i=1}^{n} e_i x_i = 0$ (los residuos no estan correlacionados con $X$).
4. El **signo de $\hat\beta$ es el signo de $Cov(X,Y)$**.

Las propiedades 2 y 3 son literalmente las ecuaciones normales I y II reescritas.

**Importante**: son propiedades **algebraicas**, se cumplen siempre por
construccion. No son evidencia de que el modelo este bien especificado.

### Es un minimo, no un maximo?

El PDF lo prueba: para cualquier par alternativo $(a^*, b^*)$,

$$S(a^*,b^*) = \sum e_i^2 + \sum\left[(\hat\alpha - a^*) + (\hat\beta - b^*)x_i\right]^2 \;\ge\; \sum e_i^2$$

Los terminos cruzados se anulan **justamente por las propiedades 2 y 3**. El
termino que sobra es una suma de cuadrados, siempre $\ge 0$.

### Codigo generico

```python
modelo.resid.sum()      # ~ 0  (orden 1e-14)
modelo.resid.mean()     # ~ 0

dfX = pd.DataFrame(modelo.model.exog, columns=modelo.model.exog_names)
dfX["res"] = modelo.resid
dfX.cov().loc["Ganancias", "res"]    # ~ 0
```

### Como leer la salida

Da algo como `1.4e-14`, no cero exacto: es **error de redondeo de punto
flotante**, no un problema del modelo. Si diera `0.5`, ahi si habria un error de
codigo.

---

# Parte B - Bondad de ajuste

## 5. Descomposicion de la suma de cuadrados y $R^2$

### Teoria

$$\underbrace{\sum_{i=1}^{n} e_i^2}_{RSS} = \underbrace{\sum_{i=1}^{n}(y_i - \bar{y})^2}_{TSS} - \underbrace{\hat\beta^2\sum_{i=1}^{n}(x_i-\bar{x})^2}_{ESS}$$

o, reordenado:

$$\boxed{TSS = ESS + RSS}$$

| Sigla | Nombre | Que mide |
|---|---|---|
| TSS | total sum of squares | variabilidad total de $Y$ ($n$ veces su varianza muestral) |
| ESS | explained sum of squares | la parte explicada por las $X$ |
| RSS | residual sum of squares | la parte que el modelo no explica |

Dividiendo todo por TSS y definiendo:

$$\boxed{\;R^2 = \frac{ESS}{TSS} = 1 - \frac{RSS}{TSS}\;}$$

### Para que sirve

Es la medida de bondad de ajuste. Si $R^2 = 0.3$, **la variable $X$ explica el
30% de la variabilidad de $Y$**.

Con intercepto en el modelo, $R^2 \in [0,1]$. En regresion **simple**, ademas:

$$R^2 = \rho^2_{XY}$$

o sea el $R^2$ es la correlacion al cuadrado.

### Codigo generico

```python
tss = modelo.centered_tss
ess = modelo.ess
rss = modelo.ssr

modelo.rsquared          # el que reporta statsmodels
ess / tss                # por definicion
1 - rss / tss            # equivalente

y_hat = modelo.fittedvalues
np.corrcoef(y, y_hat)[0,1]**2      # tambien equivalente
```

### Como leer la salida

Cuatro caminos, el mismo numero. Es un buen control de que se entendio la
descomposicion.

**Advertencias**:

- Un $R^2$ alto no significa que el modelo sea correcto ni que haya causalidad.
- Un $R^2$ bajo no significa que $\beta$ no sea significativo: en la regresion de
  IBM el $R^2$ es $0.277$ y sin embargo $\beta$ es fuertemente significativo.
- Sin intercepto, el $R^2$ pierde su interpretacion y puede salir negativo.

---

# Parte C - Propiedades estadisticas de los estimadores

## 6. Insesgadez

### Teoria

Un estimador $\hat\gamma$ es **insesgado** si $E(\hat\gamma) = \gamma$. Los
estimadores MCO lo son:

$$E(\hat\beta) = \beta \qquad\qquad E(\hat\alpha) = \alpha$$

La demostracion arranca de la **descomposicion del estimador**:

$$\hat\beta = \beta + \frac{\sum_{i=1}^{n}(x_i-\bar{x})u_i}{\sum_{i=1}^{n}(x_i-\bar{x})^2}$$

que se lee como: *estimador = parametro + error muestral del estimador*.

Tomando esperanza, tratando las $x$ como dadas (constantes) y usando el Supuesto
1 ($E(u_i)=0$), el segundo termino se anula y queda $E(\hat\beta)=\beta$.

Para $\hat\alpha$ se usa la descomposicion analoga
$\hat\alpha - \alpha = (\beta - \hat\beta)\bar{x} + \bar{u}$.

### Que significa

Insesgado **no** significa "acierta". Significa que si repitieramos el muestreo
infinitas veces, el promedio de las estimaciones daria el valor verdadero. En una
muestra concreta $\hat\beta$ casi seguro difiere de $\beta$.

**Esta descomposicion es teorica**: no se puede calcular ni verificar con datos,
porque los $u_i$ no son observables.

---

## 7. Supuesto 2 y varianzas de los estimadores

### Teoria

$$\text{Supuesto 2:}\quad \begin{cases} (2a) & Var(u_i) = \sigma^2 \quad \forall i \qquad \textbf{(Homocedasticidad)}\\[4pt] (2b) & Cov(u_i, u_j) = 0 \quad \forall i \ne j \qquad \textbf{(No autocorrelacion)}\end{cases}$$

Con eso se pueden calcular:

$$Var(\hat\beta) = \frac{\sigma^2}{\sum_{i=1}^{n}(x_i-\bar{x})^2}$$

$$Var(\hat\alpha) = \sigma^2\left[\frac{1}{n} + \frac{\bar{x}^2}{\sum_{i=1}^{n}(x_i-\bar{x})^2}\right]$$

$$Cov(\hat\alpha,\hat\beta) = \frac{-\bar{x}\,\sigma^2}{\sum_{i=1}^{n}(x_i-\bar{x})^2}$$

### Como se interpretan estas formulas

Es la pregunta que deja abierta el PDF. Tres lecturas:

1. **Mas dispersion en $X$ mejora la estimacion.** El denominador
   $\sum(x_i-\bar{x})^2$ esta abajo: si las $x$ estan muy juntas, la pendiente es
   dificil de determinar (imaginate ajustar una recta a puntos casi verticales).
2. **Mas ruido empeora la estimacion.** $\sigma^2$ esta arriba en las tres.
3. **La covarianza tiene signo opuesto a $\bar{x}$.** Si $\bar{x} > 0$, sobrestimar
   la pendiente obliga a subestimar el intercepto: la recta pivota sobre el punto
   de medias.

Ademas, mas $n$ aumenta el denominador, asi que **la precision crece con el
tamanio de muestra**.

### Codigo generico

```python
modelo.cov_params()   # matriz de varianzas-covarianzas de los estimadores
modelo.bse            # standard errors = raiz de la diagonal
```

### Como leer la salida

`cov_params()` devuelve una matriz $2\times2$: la diagonal son
$Var(\hat\alpha)$ y $Var(\hat\beta)$, y fuera de la diagonal
$Cov(\hat\alpha,\hat\beta)$. La columna `std err` del `summary` es exactamente la
raiz de la diagonal.

---

## 8. Teorema de Gauss-Markov

### Teoria

Bajo los Supuestos 1 y 2, los estimadores MCO son **MELI** (mejores estimadores
lineales insesgados), en ingles **BLUE** (best linear unbiased estimator).

"Mejor" = de **minima varianza** dentro de la clase de estimadores que son
lineales en $y$ e insesgados.

### Esqueleto de la prueba

Definiendo $w_i = \dfrac{x_i - \bar{x}}{\sum(x_i-\bar{x})^2}$, se tiene
$\hat\beta = \sum w_i y_i$.

Se toma un competidor lineal insesgado $\tilde\beta = \sum c_i y_i$ y se escribe
$c_i = w_i + d_i$. La insesgadez obliga a $\sum d_i = 0$ y $\sum d_i x_i = 0$.
Entonces:

$$Var(\tilde\beta) - Var(\hat\beta) = \sigma^2\sum d_i^2 \;\ge\; 0$$

Cualquier desvio respecto de los $w_i$ **agrega** varianza.

### Que significa (y que no)

- No dice que MCO sea el mejor estimador posible: dice que es el mejor **entre
  los lineales e insesgados**. Un estimador sesgado puede tener menor error
  cuadratico medio.
- **No necesita normalidad**: Gauss-Markov solo usa los Supuestos 1 y 2. La
  normalidad (Supuesto 3) hace falta recien para la inferencia.
- Si falla la homocedasticidad o hay autocorrelacion, **MCO sigue siendo
  insesgado pero deja de ser BLUE**, y los errores estandar quedan mal
  calculados. Ese es el tema de la Clase 4-5.

---

## 9. Estimar $\sigma^2$

### Teoria

$\sigma^2$ es desconocido, asi que hay que estimarlo con los residuos. El PDF
demuestra que:

$$E\left(\sum_{i=1}^{n} e_i^2\right) = (n-2)\,\sigma^2$$

Por eso el estimador insesgado divide por $n-2$, no por $n$:

$$\boxed{\;s^2 = \frac{\sum_{i=1}^{n} e_i^2}{n-2} = \frac{RSS}{n-2}\;}$$

### Por que $n-2$

Porque se estimaron **dos** parametros ($\hat\alpha$ y $\hat\beta$), y cada uno
impone una restriccion sobre los residuos (las dos ecuaciones normales). Quedan
$n-2$ grados de libertad. En regresion multiple con $k$ parametros seria $n-k$.

### Codigo generico

```python
modelo.scale                    # s^2
modelo.ssr / modelo.df_resid    # equivalente: RSS / (n-k)
np.sqrt(modelo.scale)           # s, el "error tipico" de la salida
modelo.df_resid                 # n - k
```

### Como leer la salida

En la salida de `summary()` aparece como parte del bloque superior; en la salida
de Excel del PDF se llama **"Error tipico"**. En la regresion de IBM vale
$0.0598$: es la desviacion tipica de los residuos, en las mismas unidades que $y$.

---

## 10. Supuesto 3: normalidad

### Teoria

$$\text{Supuesto 3:}\qquad u_i \sim N(0,\sigma^2), \quad \text{i.i.d.}$$

No contradice los supuestos anteriores: agrega la **forma de la distribucion**.

### Corolarios

Como $y_i = \alpha + \beta x_i + u_i$, entonces $y_i \sim N(\alpha + \beta x_i,\, \sigma^2)$.
Y como $\hat\alpha$ y $\hat\beta$ son **combinaciones lineales de los $y_i$**,
tambien son normales:

$$\hat\beta \sim N\!\left(\beta,\; \frac{\sigma^2}{\sum(x_i-\bar{x})^2}\right)$$

$$\hat\alpha \sim N\!\left(\alpha,\; \sigma^2\left[\frac{1}{n} + \frac{\bar{x}^2}{\sum(x_i-\bar{x})^2}\right]\right)$$

Y para la varianza estimada:

$$\frac{(n-2)s^2}{\sigma^2} \sim \chi^2_{n-2}$$

Usando que la $\chi^2_v$ tiene $E = v$ y $Var = 2v$:

$$E(s^2) = \sigma^2 \qquad\qquad Var(s^2) = \frac{2\sigma^4}{n-2}$$

### Para que sirve

**Sin el Supuesto 3 no hay inferencia.** Se puede estimar y saber que MCO es
BLUE, pero no se pueden hacer tests ni intervalos de confianza, porque no se
conoce la distribucion de los estimadores.

---

# Parte D - Inferencia

## 11. De la normal a la t de Student

### El problema

Estandarizando:

$$\frac{\hat\beta - \beta}{\sqrt{\dfrac{\sigma^2}{\sum(x_i-\bar{x})^2}}} \sim N(0,1)$$

Pero **$\sigma^2$ es desconocido**. Hay que reemplazarlo por $s^2$, y al hacerlo
la distribucion deja de ser normal.

### El lema

Si $Z \sim N(0,1)$ e $Y \sim \chi^2_v$ son **independientes**, entonces:

$$t_v = \frac{Z}{\sqrt{Y/v}} \sim t\text{-Student con } v \text{ grados de libertad}$$

### Aplicacion

Combinando $\dfrac{\hat\beta-\beta}{\sqrt{\sigma^2/\sum(x_i-\bar x)^2}} \sim N(0,1)$
con $\dfrac{(n-2)s^2}{\sigma^2}\sim\chi^2_{n-2}$, los $\sigma$ se cancelan y queda:

$$\boxed{\;\frac{\hat\beta - \beta}{\sqrt{\dfrac{s^2}{\sum(x_i-\bar{x})^2}}} = \frac{\hat\beta-\beta}{se(\hat\beta)} \sim t_{n-2}\;}$$

Falta un detalle que el PDF deja como ejercicio: probar que $\hat\beta$ y $s^2$
son **independientes**, lo que se hace mostrando que $Cov(\hat\beta, e_j)=0$ y
usando que bajo normalidad covarianza cero implica independencia.

### Error estandar

$$se(\hat\beta) = \sqrt{\frac{s^2}{\sum(x_i-\bar{x})^2}}$$

Es la **raiz de la varianza estimada** del estimador. En general, `se` de
cualquier estimador es la raiz de su varianza estimada.

### Por que importa

La $t$ tiene la misma forma simetrica que la normal pero **colas mas pesadas**:
los valores criticos son mas exigentes. A medida que $n\to\infty$, la $t$ tiende
a la normal estandar. Por eso con muestras grandes se usa $1.96$ y con muestras
chicas hay que ir a la tabla.

---

## 12. Test de hipotesis

### Teoria

Para el modelo $y_i = \alpha + \beta x_i + u_i$, el test central es:

$$H_0: \beta = 0 \qquad\qquad H_A: \beta \ne 0$$

Es un test **a dos colas**: se rechaza si hay evidencia de que $\beta$ es
positivo **o** negativo. Un test a una cola seria por ejemplo
$H_0: \beta \ge 0$ contra $H_A: \beta < 0$.

### Los dos errores

| | $H_0$ verdadera | $H_0$ falsa |
|---|---|---|
| **Rechazo $H_0$** | **Error Tipo I** | correcto |
| **No rechazo $H_0$** | correcto | **Error Tipo II** |

El **nivel de significancia** $\alpha$ es la probabilidad de error Tipo I con la
que decidimos trabajar.

### Los 4 pasos del PDF

1. Fijar el nivel de significancia $\alpha$.
2. Buscar el o los **valores criticos** $CV$ en la tabla que corresponda.
3. Calcular el estadistico bajo $H_0$:
   $$t = \frac{\hat\beta - \beta_0}{se(\hat\beta)}$$
4. Concluir segun caiga o no en la region de rechazo.

### Para que sirve el caso $\beta_0 = 0$

Si **no** se rechaza $H_0: \beta = 0$, se esta diciendo que no hay evidencia para
sostener que $\beta$ sea distinto de cero, y por lo tanto **la variable $X$ no
explica a $Y$**.

### Codigo generico

```python
from scipy import stats

# estadistico para H0: beta = beta_0
beta_0 = 0
t_stat = (modelo.params["x"] - beta_0) / modelo.bse["x"]

# valor critico a dos colas
gl = modelo.df_resid              # n - k
cv = stats.t.ppf(1 - alpha/2, gl)

print(t_stat, cv, "rechazo" if abs(t_stat) > cv else "no rechazo")

# p-value a dos colas calculado a mano
p = 2 * (1 - stats.t.cdf(abs(t_stat), gl))
```

Cuando $\beta_0 = 0$, el estadistico es directamente `modelo.tvalues`.

### Como leer la salida

**Cuando $\beta_0 \ne 0$ hay que calcularlo a mano.** La columna `t` del summary
solo sirve para $H_0: \beta = 0$. Es la trampa del inciso (c) de la practica.

---

## 13. El p-value

### Teoria

El p-value es la **minima probabilidad de error Tipo I con la que rechazo $H_0$**.
Siempre esta entre 0 y 1.

$$\text{Rechazo } H_0 \iff p\text{-value} \le \alpha$$
$$\text{No rechazo } H_0 \iff p\text{-value} > \alpha$$

### Para que sirve

Evita tener que mirar la tabla: se compara directamente contra el nivel de
significancia elegido.

### Como leer la salida

- El p-value del `summary` es siempre **a dos colas** y siempre para
  $H_0: \text{coeficiente} = 0$.
- Para un test a una cola con la alternativa en la direccion del estimador, se
  divide por 2.
- Un p-value chiquisimo ($5.5\times10^{-10}$) no significa que el efecto sea
  **grande**: significa que esta bien medido. Magnitud y significancia son cosas
  distintas.

---

## 14. Intervalos de confianza

### Teoria

Un intervalo de confianza del 95% para un parametro $\gamma$ (sea $\alpha$ o
$\beta$):

$$\left(\hat\gamma - |CV_{0.025}|\,se(\hat\gamma),\;\; \hat\gamma + CV_{0.975}\,se(\hat\gamma)\right)$$

Sale de despejar $\beta$ en:

$$P\left(-1.96 < \frac{\hat\beta - \beta}{se(\hat\beta)} < 1.96\right) = 0.95$$

### Relacion con el test

Son equivalentes: **$H_0: \beta = \beta_0$ se rechaza al 5% si y solo si
$\beta_0$ queda fuera del IC del 95%.** Sirve como control cruzado.

### Codigo generico

```python
modelo.conf_int(alpha=0.05)     # todas las filas

# a mano
t_val = stats.t.ppf(0.975, modelo.df_resid)
lo = modelo.params["x"] - t_val * modelo.bse["x"]
hi = modelo.params["x"] + t_val * modelo.bse["x"]
```

---

# Parte E - Python: correr y leer una regresion

## 15. La regresion basica

### Codigo generico

```python
import statsmodels.api as sm

X = sm.add_constant(df["x"])    # agrega la columna de unos
y = df["y"]

modelo = sm.OLS(y, X).fit()
print(modelo.summary())
```

**`add_constant` es obligatorio.** A diferencia de `sklearn`, `statsmodels.api`
**no** agrega el intercepto solo. Si se olvida, se estima una recta forzada por el
origen y todo el analisis queda mal.

Alternativa con formulas (estilo R):

```python
import statsmodels.formula.api as smf
modelo = smf.ols("y ~ x", data=df).fit()    # el intercepto va implicito
```

### Por que `statsmodels` y no `sklearn`

`sklearn` esta pensado para prediccion: da los coeficientes y poco mas.
`statsmodels` esta pensado para inferencia: da errores estandar, estadisticos t,
p-values, intervalos de confianza y tests, que es lo que necesitamos.

---

## 16. Decodificar la salida de `summary()`

### Las cuatro columnas de la tabla de coeficientes

| Columna | Simbolo | Que es |
|---|---|---|
| `coef` | $\hat\beta$ | el estimador |
| `std err` | $se(\hat\beta)$ | raiz de su varianza estimada |
| `t` | $\hat\beta / se(\hat\beta)$ | estadistico para $H_0: \beta=0$ |
| `P>\|t\|` | p-value | a dos colas, para $H_0: \beta=0$ |
| `[0.025  0.975]` | IC 95% | intervalo de confianza |

La tercera columna es literalmente **la primera dividida por la segunda**.

### Atributos utiles

```python
modelo.params        # coeficientes
modelo.bse           # standard errors
modelo.tvalues       # estadisticos t
modelo.pvalues       # p-values
modelo.conf_int()    # intervalos de confianza
modelo.rsquared      # R2
modelo.fittedvalues  # y_hat
modelo.resid         # residuos
modelo.scale         # s^2
modelo.centered_tss  # TSS
modelo.ess           # ESS
modelo.ssr           # RSS
modelo.nobs          # n
modelo.df_resid      # n - k
modelo.cov_params()  # matriz var-cov de los estimadores
```

### Prediccion

```python
# a mano
y_hat = modelo.params.iloc[0] + modelo.params["x"] * 500

# con el predictor (hay que incluir el 1 del intercepto)
modelo.predict([1, 500])

# producto escalar
np.dot([1, 500], modelo.params)
```

---

## 17. Bandas de confianza vs bandas de prediccion

### Teoria

Son dos cosas distintas y confundirlas es habitual.

**Banda de confianza** (para la media condicional $\hat{y}$):

$$Var(\hat{y}) = Var(\hat\alpha) + x^2 Var(\hat\beta) + 2x\,Cov(\hat\alpha,\hat\beta)$$

**Banda de prediccion** (para una observacion futura $y$): agrega la varianza del
error, porque una observacion nueva trae su propio ruido:

$$Var(y) = Var(\hat{y}) + \sigma^2$$

### Codigo generico

```python
pred = modelo.get_prediction()
IC = pred.summary_frame(alpha=0.05)
```

Devuelve seis columnas:

| Columna | Que es |
|---|---|
| `mean` | $\hat{y}$ |
| `mean_se` | $se(\hat{y})$ |
| `mean_ci_lower` / `mean_ci_upper` | **banda de confianza** |
| `obs_ci_lower` / `obs_ci_upper` | **banda de prediccion** |

Reproduccion manual:

```python
p = modelo.cov_params().values
var_y_hat = p[0,0] + p[1,1]*df["x"]**2 + 2*df["x"]*p[1,0]
se_y_hat  = np.sqrt(var_y_hat)

t_val = stats.t.ppf(0.975, modelo.df_resid)

# banda de confianza
lo_c, hi_c = y_hat - t_val*se_y_hat, y_hat + t_val*se_y_hat

# banda de prediccion (agrega s^2)
se_pred = np.sqrt(var_y_hat + modelo.mse_resid)
lo_p, hi_p = y_hat - t_val*se_pred, y_hat + t_val*se_pred
```

### Como leer la salida

- La banda de **prediccion es siempre mas ancha** que la de confianza.
- Las dos son **mas angostas cerca de $\bar{x}$** y se abren en los extremos: es
  el efecto del termino $x^2 Var(\hat\beta)$. Predecir lejos del centro de los
  datos es mas incierto.
- Al graficar hay que **ordenar por $x$** (`np.argsort`), si no las bandas salen
  en zigzag.

---

# Parte F - Ejercitacion 3

## 18. Ejercicio 1 - demostracion

Ya esta en el punto 3: dividir numerador y denominador de $\hat\beta$ por $n$ y
reconocer covarianza y varianza muestrales. La lectura financiera es que el beta
del CAPM es exactamente esa razon.

---

## 19. Ejercicio 2 - CAPM de IBM

### Planteo

Se regresa la prima de riesgo de IBM contra la prima de riesgo del mercado:

$$R_{IBM} - R_f = \alpha + \beta\,(R_{S\&P} - R_f) + u$$

Datos mensuales, tasa libre de riesgo = T-Bill a 3 meses.

### Codigo

```python
df = pd.read_excel("Bases de Datos MIA103/MIA103 Ejercitación 3 Datos.xlsx",
                   sheet_name="Datos_Ejer_2_IBM")[
    ["Date", "IBM_price", "S&P500_index", "3mTB (RF) anualizada"]]
df.columns = ["Date", "IBM", "SP500", "TB3"]

df["R_IBM"] = df["IBM"].pct_change()
df["R_SP"]  = df["SP500"].pct_change()
df["Rf"]    = (1 + df["TB3"]/100)**(1/12) - 1      # anualizada -> mensual

df["y"] = df["R_IBM"] - df["Rf"]
df["x"] = df["R_SP"]  - df["Rf"]
df = df.dropna()

modelo = sm.OLS(df["y"], sm.add_constant(df["x"])).fit()
print(modelo.summary())
```

**Detalle importante**: la tasa viene **anualizada en porcentaje**, asi que hay
que pasarla a mensual con $(1+TB/100)^{1/12}-1$, no dividiendo por 12.

### Salida verificada

```text
n = 59      grados de libertad = 57      R2 = 0.276847
error tipico (s) = 0.059838

              coef        std err        t         P>|t|      [0.025    0.975]
const       0.003128      0.007937     0.3941     0.6950     -0.0128    0.0190
Rsp-Rf      0.697587      0.149333     4.6713     0.0000      0.3986    0.9966

valor critico t al 5%, gl=57:  +/- 2.0025
```

Coincide exactamente con la salida de Excel del enunciado.

### (a) Interpretacion de la pendiente $0.698$

Si la prima de riesgo del mercado aumenta **un punto porcentual**, la prima de
riesgo de IBM aumenta **0.698 puntos porcentuales**.

Financieramente es el **beta de IBM**. Como $\beta < 1$, IBM es un activo
**defensivo**: amplifica menos que proporcionalmente los movimientos del mercado.
Si el mercado cae 10%, IBM cae aproximadamente 7%.

### (b) Test $H_0: \beta = 0$

$$t = \frac{0.698 - 0}{0.149} = 4.67$$

Como $|4.67| > 2.0025$, **se rechaza $H_0$** al 5%. El p-value es
$1.87\times10^{-5}$, muchisimo menor que $0.05$.

Conclusion: hay evidencia estadistica de que el beta de IBM es distinto de cero,
o sea que el mercado si explica los retornos de IBM.

### (c) Test $H_0: \beta = 1$

**Aca hay que calcular a mano**: la columna `t` del summary no sirve.

$$t = \frac{0.697587 - 1}{0.149333} = -2.0251$$

Como $|-2.0251| > 2.0025$, **se rechaza $H_0$** al 5%, pero **por muy poco**. El
p-value exacto es $0.0476$.

```python
t = (modelo.params["x"] - 1) / modelo.bse["x"]      # -2.0251
p = 2*(1 - stats.t.cdf(abs(t), modelo.df_resid))    #  0.0476
```

Conclusion: hay evidencia (al filo) de que el beta es distinto de 1, es decir que
IBM no se mueve uno a uno con el mercado. **Al 1% no se rechazaria**: conviene
decirlo, porque el resultado es sensible al nivel de significancia elegido.

### (d) Intervalo de confianza al 95% para $\beta$

$$0.698 \pm 2.0025 \times 0.149333 \;=\; [0.3986,\; 0.9966]$$

Coherente con (b) y (c): el intervalo **no contiene el 0** (por eso se rechaza en
b) y **no contiene el 1** (por eso se rechaza en c), aunque el 1 queda apenas
afuera.

### (e) Es el intercepto distinto de cero?

$t = 0.394$, muy dentro de $(-2.0025,\; 2.0025)$, y p-value $= 0.695$.

**No se rechaza $H_0: \alpha = 0$.** El intercepto no es estadisticamente distinto
de cero.

Lectura financiera: el $\alpha$ de Jensen no es significativo, o sea que IBM no
genera retorno anormal mas alla de lo que explica su exposicion al mercado.

### (f) Se puede saber la correlacion?

**Si, indirectamente.** En regresion simple $R^2 = \rho^2$, entonces:

$$\rho = \sqrt{0.276847} = 0.5262$$

El signo se toma del signo de $\hat\beta$, que es positivo. En la salida de Excel
aparece directamente como "Coeficiente de correlacion multiple" $= 0.52616$.

---

## 20. Ejercicio 3 - CEOs y ganancias

### Codigo

```python
df3 = pd.read_excel("Bases de Datos MIA103/ceo.xlsx")

X = sm.add_constant(df3["Ganancias"])
y = df3["Compensacion_CEO"]

modelo3 = sm.OLS(y, X).fit()
print(modelo3.summary())
```

### Salida verificada

```text
n = 70      grados de libertad = 68      R2 = 0.4345

                 coef        std err       t        P>|t|
const          0.599965      ...         ...        ...
Ganancias      0.000842      0.000117    7.2279    5.50e-10

TSS = 59.4459    ESS = 25.8280    RSS = 33.6179    s2 = 0.4944
valor critico t al 1%, gl=68:  +/- 2.6501
IC 95% para beta: [0.000610, 0.001075]
```

### (b) Interpretacion de $\hat\beta = 0.000842$

Si la ganancia de la empresa aumenta en **1 millon de dolares**, la compensacion
al CEO aumenta en **0.000842 millones**, o sea **842 dolares**.

### (c) Test $H_0: \beta = 0$ al 1%

$$t = \frac{0.000842}{0.000117} = 7.2279$$

Valor critico al 1% con 68 gl: $\pm 2.6501$. Como $7.23 > 2.65$, **se rechaza
$H_0$**. El p-value es $5.5\times10^{-10} < 0.01$.

Conclusion: hay evidencia estadistica de que mayores ganancias se traducen en
mayores compensaciones a los CEOs.

**El punto conceptual que remarca el notebook**: que $\hat\beta = 0.000842$ tenga
"muchos ceros" **no dice nada sobre su significancia estadistica**. El numero es
chico porque las unidades son millones; en dolares serian 842. La significancia
la determina el cociente $\hat\beta / se(\hat\beta)$, no la magnitud absoluta del
coeficiente.

### (d) Que porcentaje de la variabilidad se explica?

$R^2 = 0.4345$: **el 43.4%** de la variabilidad en las compensaciones a los CEOs
es explicado por las ganancias de las empresas.

Verificacion: $ESS/TSS = 25.8280 / 59.4459 = 0.4345$.

---

## 21. Errores frecuentes

| Error | Por que pasa | Como se evita |
|---|---|---|
| Olvidar `sm.add_constant` | `statsmodels.api` no lo agrega solo | siempre `X = sm.add_constant(...)` |
| Usar la columna `t` para $H_0: \beta=1$ | esa columna es solo para $\beta_0=0$ | calcular $(\hat\beta-\beta_0)/se$ a mano |
| Confundir error $u_i$ con residuo $e_i$ | se parecen | error = a la recta poblacional (no observable) |
| Dividir RSS por $n$ | el insesgado divide por $n-2$ | `modelo.scale` o `ssr/df_resid` |
| Grados de libertad mal | son $n-k$, no $n-1$ | `modelo.df_resid` |
| Pasar tasa anual a mensual dividiendo por 12 | la capitalizacion es geometrica | $(1+r)^{1/12}-1$ |
| Leer $R^2$ bajo como "beta no significativo" | son cosas distintas | mirar el p-value del coeficiente |
| Confundir banda de confianza con la de prediccion | ambas salen del mismo frame | prediccion agrega $s^2$ y es mas ancha |
| Interpretar coeficiente chico como irrelevante | depende de las unidades | mirar el t, no la magnitud |
| Graficar bandas sin ordenar por $x$ | los datos vienen desordenados | `np.argsort(x)` antes de graficar |
| Creer que Gauss-Markov necesita normalidad | se mezclan supuestos 2 y 3 | BLUE solo usa supuestos 1 y 2 |

---

## 22. Checklist de Clase 3

Al terminar deberias poder:

1. Distinguir observado de no observado y enunciar el Supuesto 1.
2. Distinguir error de residuo.
3. Escribir el problema de MCO y derivar las ecuaciones normales.
4. Obtener $\hat\alpha$ y $\hat\beta$ a partir de las ecuaciones normales.
5. Demostrar que $\hat\beta = \widehat{Cov}(X,Y)/\widehat{Var}(X)$.
6. Explicar por que MCO usa distancias verticales y por que al cuadrado.
7. Enunciar las cuatro propiedades algebraicas de la recta estimada.
8. Escribir $TSS = ESS + RSS$ y definir $R^2$.
9. Explicar por que $R^2 = \rho^2$ en regresion simple.
10. Demostrar insesgadez usando la descomposicion del estimador.
11. Enunciar el Supuesto 2 y sus dos partes.
12. Escribir e interpretar $Var(\hat\beta)$, $Var(\hat\alpha)$ y $Cov(\hat\alpha,\hat\beta)$.
13. Enunciar Gauss-Markov y decir que supuestos usa y cuales no.
14. Justificar por que $s^2$ divide por $n-2$.
15. Enunciar el Supuesto 3 y sus corolarios sobre las distribuciones.
16. Explicar por que aparece la $t$ de Student en lugar de la normal.
17. Definir error estandar.
18. Ejecutar los 4 pasos de un test de hipotesis.
19. Definir error Tipo I y Tipo II.
20. Definir p-value y aplicar la regla de decision.
21. Construir un IC y relacionarlo con el test.
22. Leer las cuatro columnas de una salida de regresion.
23. Distinguir banda de confianza de banda de prediccion.
24. Interpretar un beta financiero y decir si el activo es defensivo o agresivo.

---

## 23. Notas tecnicas

- Dependencias: `pandas`, `numpy`, `matplotlib`, `scipy`, `statsmodels`,
  `openpyxl`.
- Los notebooks leen `ceo.xlsx` y `MIA103_Ejer_3_Datos.xlsx` sin ruta. En el repo
  estan en `Bases de Datos MIA103/`, y el segundo se llama
  `MIA103 Ejercitación 3 Datos.xlsx`.
- Ese Excel tiene 6 hojas: `Datos_Ejer_2_IBM`, `Regr_Ejer_2`, `Datos_Ejer_3_CEO`,
  `IBM`, `S&P`, `3mTB`. El notebook usa `sheet_name=2` para los CEOs, que es
  `Datos_Ejer_3_CEO`; el archivo `ceo.xlsx` tiene los mismos datos ya limpios.
- `sm.OLS(y, X)` recibe **primero la dependiente**. Al reves corre igual y da un
  resultado sin sentido.
- Si `X` es un `DataFrame`, los coeficientes quedan indexados por nombre de
  columna (`modelo.params["Ganancias"]`); si es un `array`, quedan por posicion
  (`modelo.params[1]`).
- `modelo.mse_resid` y `modelo.scale` son el mismo numero ($s^2$).
