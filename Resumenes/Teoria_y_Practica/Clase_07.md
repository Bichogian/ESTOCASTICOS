# Clase 7 - Estacionariedad, raices unitarias, ADF y cointegracion

[Volver al indice general](../Res+Pra.md)

Mapa completo de la Clase 7: teoria del PDF, codigo del notebook de ADF/DFGLS y
Ejercitacion 6. Cada tema sigue el mismo recorrido:

$$\text{teoria} \;\rightarrow\; \text{para que sirve} \;\rightarrow\; \text{codigo generico} \;\rightarrow\; \text{como leer la salida}$$

## Archivos de esta clase

| Tipo | Archivo | Para que se usa |
|---|---|---|
| Teoria | `Clases/MIA103_Clase_7_.pdf` | Estacionariedad, ADF, operador de rezagos, IRF, cointegracion |
| Python | `Codigos/MIA103_2026_Clase_07_Ejemplo_ADF_DFGLS.ipynb` | ADF y DFGLS sobre el precio del trigo |
| Practica | `Practicas/MIA103_Ejer_6_.pdf` | Orden de integracion de precios y dinero |
| Resuelta | `Practicas_Resueltas/Respuestas_6.ipynb` | Resolucion propia |
| Datos | `Bases de Datos MIA103/wheat.xlsx` | Precio mensual del trigo (Pink Sheet, Banco Mundial) |
| Datos | `Bases de Datos MIA103/Precios_y_Dinero.xlsx` | IPC y base monetaria para la practica |
| Puente | `Practicas/MIA103_Ejer_7_.pdf` | VAR y Granger: se trabaja en la [Clase 8](Clase_08.md) |

## Mapa tema - PDF - notebook - practica

| # | Tema | PDF | Notebook | Practica |
|---:|---|---|---|---|
| 1 | Estacionariedad debil y fuerte | p. 2-3 | - | - |
| 2 | I(0), I(1) y diferencias | p. 4-5 | celdas 52-62 | Ej. 2, 3, 4 |
| 3 | Test de Dickey-Fuller | p. 6-7 | celda 25 | Ej. 2 |
| 4 | El "aumentado": rezagos, constante, tendencia | p. 8-10 | celdas 18-32 | Ej. 2 |
| 5 | Phillips-Perron | p. 11 | - | - |
| 6 | Tendencia deterministica vs raiz unitaria | p. 11-14 | celdas 55, 60 | - |
| 7 | Cuantos rezagos: Ng-Perron y Schwert | p. 15-16 | celdas 29-35 | - |
| 8 | DFGLS | p. 16-17 | celdas 44-51, 63-69 | - |
| 9 | Operador de rezagos | p. 18-20 | - | - |
| 10 | Estacionariedad de AR, MA y ARMA | p. 21-29 | - | - |
| 11 | Media y varianza de AR(1) y ARMA | p. 29-33 | - | - |
| 12 | Invertibilidad y AR($\infty$) | p. 34-37 | - | - |
| 13 | Impulso-respuesta, mean lag, median lag | p. 37-43 | - | - |
| 14 | Cointegracion | p. 44-46 | - | Ej. 7 |

---

# Parte A - Estacionariedad

## 1. Definicion

### Teoria

Un proceso $y_t$ es **debilmente estacionario** si:

$$E(y_t) = \mu < \infty \quad \forall t$$
$$Var(y_t) = \sigma^2 < \infty \quad \forall t$$
$$Cov(y_t, y_{t-j}) = \gamma_j \quad \forall t,\; j = \pm1, \pm2, \dots$$

Media y varianza **constantes**, y autocovarianzas que dependen **solo del rezago
$j$**, no del momento $t$.

Cuando un proceso es estacionario decimos que es **integrado de orden cero**,
$I(0)$.

**Fuertemente estacionario** (o estrictamente): la **distribucion conjunta** de
$\{y_t, y_{t+j_1},\dots,y_{t+j_n}\}$ depende solo de los intervalos
$(j_1,\dots,j_n)$ y no de $t$.

Si un proceso es estrictamente estacionario **y tiene segundos momentos finitos**,
entonces tambien es debilmente estacionario. La reciproca no vale en general.

### Para que sirve

Toda la inferencia en series de tiempo depende de esto. Si la serie no es
estacionaria, la media y la varianza muestrales **no estiman nada**: no hay un
$\mu$ ni un $\sigma^2$ poblacionales a los que converjan.

### Advertencia de vocabulario

**Estacionariedad no tiene nada que ver con estacionalidad.** Estacionalidad es
un patron que se repite cada 12 meses o cada 4 trimestres. Suenan parecido y no
estan relacionados.

---

## 2. Orden de integracion

### Teoria

Si $y_t$ **no** es estacionario, se toman diferencias:

$$\Delta y_t = y_t - y_{t-1}$$

- Si $\Delta y_t$ es estacionario, entonces $y_t$ es **$I(1)$**.
- Si $\Delta y_t$ tampoco lo es, se vuelve a diferenciar: si $\Delta(\Delta y_t)$
  es estacionario, $y_t$ es $I(2)$.

**Un proceso $I(1)$ es no estacionario.** En la practica casi todas las series
economicas y financieras son $I(0)$ o $I(1)$.

### El ejemplo canonico

$$\log(P_t) \sim I(1) \qquad\Longrightarrow\qquad \Delta\log(P_t) = r_t \sim I(0)$$

El log-precio de un activo es $I(1)$; el **retorno logaritmico** (su primera
diferencia) es $I(0)$. Por eso toda la materia trabaja con retornos y no con
precios.

### Por que importa el orden de integracion

**Lo primero que hay que revisar al trabajar con series de tiempo.** La razon:
solo se pueden relacionar variables **del mismo orden de integracion**.

Regresar una serie $I(1)$ contra otra $I(1)$ que no esta cointegrada produce
**regresion espuria**: $R^2$ altisimo, estadisticos $t$ enormes, y todo
completamente sin sentido. Es lo que se evita con los pasos previos de ADF.

---

# Parte B - El test de Dickey-Fuller aumentado

## 3. De donde sale el test

### Teoria

Sea $y_t$ un AR(1). Se quiere testear si $\rho = 1$ (random walk) contra
$\rho < 1$ (AR(1) estacionario):

$$y_t = \rho y_{t-1} + \varepsilon_t; \qquad H_0: \rho = 1, \qquad H_A: \rho < 1$$

Restando $y_{t-1}$ de ambos lados:

$$\Delta y_t = (\rho - 1)y_{t-1} + \varepsilon_t \tag{$*$}$$

$$\boxed{\;H_0: \rho - 1 = 0 \qquad H_A: \rho - 1 < 0\;}$$

Llamando $\gamma = \rho - 1$, el test es simplemente si el coeficiente de
$y_{t-1}$ en esa regresion es cero.

### Para que sirve la reescritura

Convierte una hipotesis rara ("$\rho$ vale exactamente 1") en una familiar ("este
coeficiente es cero"), que se lee directamente de una regresion MCO.

---

## 4. Por que los valores criticos no son los de la $t$

### Teoria

**Bajo $H_0$ la serie es no estacionaria.** Toda la teoria asintotica de la Clase
3 supone estacionariedad, asi que **el estadistico no tiene distribucion $t$**.

Dickey y Fuller mostraron que los valores criticos correctos son **mayores en
valor absoluto** que los de la $t$ convencional, y que el ajuste depende del
tamanio de la muestra.

**Como el test es a una cola izquierda, los valores criticos son siempre
negativos.**

### Como leer la salida

Los software reportan directamente los valores criticos correctos y el p-value:

```text
Estadistico ADF : -1.8591
p-valor         :  0.3515
Valores criticos:
   1%: -3.4437
   5%: -2.8674
  10%: -2.5700
```

**Se rechaza $H_0$ si el estadistico es MENOR (mas negativo) que el valor
critico.** Aca $-1.8591 > -2.8674$, asi que **no** se rechaza: hay raiz unitaria.

**El error mas comun** es comparar contra $\pm1.96$. Con esos criticos se
rechazaria raiz unitaria casi siempre.

---

## 5. Por que "aumentado"

### Teoria

El problema del Dickey-Fuller simple $(*)$: si hay **autocorrelacion en los
residuos** de esa regresion, los valores criticos ya no estan bien calculados.

La solucion de Dickey y Fuller: agregar **rezagos de la variable dependiente**
para remover esa autocorrelacion, y ademas permitir constante y tendencia
deterministica:

$$\Delta y_t = c + \gamma\, y_{t-1} + d\,t + \sum_{i=1}^{p}\phi_i \Delta y_{t-i} + \varepsilon_t \tag{$**$}$$

Las hipotesis **no cambian**:

$$H_0: \gamma = 0 \qquad\qquad H_A: \gamma < 0$$

Los terminos $\Delta y_{t-1}, \Delta y_{t-2}, \dots$ estan solo para limpiar la
autocorrelacion: **no se interpretan**.

### Phillips-Perron

El ADF supone que los errores de $(**)$ son i.i.d. El test de **Phillips-Perron**
relaja ese supuesto usando una correccion no parametrica en vez de rezagos.

---

## 6. Constante y tendencia: la eleccion mas delicada

### Teoria

El punto crucial del PDF: **graficamente es casi imposible distinguir una serie
con tendencia deterministica de una con raiz unitaria**. Pero son cosas distintas
y **se estacionarizan de forma completamente diferente**.

| | Modelo | Es estacionaria? | Como se estacionariza |
|---|---|---|---|
| **Tendencia deterministica** | $Y_t = \beta t + \varepsilon_t$ | **No**: $E(Y_t) = \beta t$ depende de $t$ | **regresar contra $t$ y quedarse con los residuos** |
| **Raiz unitaria** | $Y_t = Y_{t-1} + \varepsilon_t$ | **No** | **tomar primeras diferencias** |

Notar que en el primer caso $Var(Y_t) = \sigma_\varepsilon^2$ es constante: lo que
falla es solo la media.

Una serie $I(0)$ **mas** una tendencia deterministica se llama a veces
"trend-stationary". Se estacionariza quitandole la tendencia, **no**
diferenciando.

### Por que importa

Aplicar el metodo equivocado deja la serie mal especificada:

- diferenciar una serie trend-stationary introduce una estructura MA artificial
  (sobrediferenciacion);
- quitarle tendencia a una serie $I(1)$ no la estacionariza.

### Las cuatro opciones en `statsmodels`

| `regression=` | Que incluye |
|---|---|
| `"n"` | ni constante ni tendencia |
| `"c"` | solo constante (el default) |
| `"ct"` | constante y tendencia lineal |
| `"ctt"` | constante, tendencia lineal y cuadratica |

### La estrategia practica

1. Empezar con `"ct"`.
2. Mirar en la regresion auxiliar si el coeficiente de la tendencia es
   **significativo**.
3. Si **no** lo es, repetir con `"c"`, porque incluir terminos deterministicos
   innecesarios **reduce el poder del test**.

Eso es exactamente lo que hace el notebook con el trigo.

---

## 7. Cuantos rezagos usar

### Teoria

Es una decision con costos en las dos direcciones:

```text
p muy chico  ->  queda correlacion serial, los valores criticos no son validos
p muy grande ->  se pierde poder estadistico del test
```

**Regla de Ng & Perron (1995)**:

1. Elegir una cota superior $p_{max}$.
2. Estimar el ADF con $p_{max}$ rezagos.
3. Si el valor absoluto del estadistico $t$ del **ultimo rezago** de $\Delta y_t$
   es $\ge 1.6$, quedarse con $p = p_{max}$. Si no, reducir en uno y repetir.

**Regla de Schwert (1989)** para la cota superior:

$$p_{max} = \left\lfloor 12\left(\frac{T}{100}\right)^{1/4}\right\rfloor$$

Con $T = 500$: $p_{max} = \lfloor 12 \times 1.495 \rfloor = 17$.

### En `statsmodels`

`autolag` implementa esas ideas:

| `autolag=` | Criterio |
|---|---|
| `"t-stat"` | la regla de Ng-Perron (el que usa el notebook) |
| `"AIC"` | minimiza Akaike (default) |
| `"BIC"` | minimiza Schwarz |
| `None` | usa exactamente `maxlag` |

Si no se especifica `maxlag`, `statsmodels` aplica la regla de Schwert.

### Como leer la salida

Sobre los retornos del trigo ($T=500$, $p_{max}=17$):

```text
maxlag  regression  autolag     ADF        p-value    lags
   17       c       t-stat     -8.2930     0.0000       8
   17      ct       t-stat     -8.3291     0.0000       8
   17     ctt       t-stat     -8.3365     0.0000       8
   17       n       t-stat     -8.2966     0.0000       8
 None       c       t-stat     -8.2930     0.0000       8
 None       c       AIC        -8.2930     0.0000       8
 None       c       BIC       -18.7245     0.0000       0
```

Dos lecturas:

- **La conclusion es robusta**: con cualquier especificacion se rechaza
  contundentemente. Cuando el resultado es asi de claro, los detalles no importan.
- **BIC elige 0 rezagos** y da un estadistico muy distinto ($-18.72$). BIC penaliza
  mas los parametros. Que el estadistico cambie tanto muestra por que la eleccion
  de rezagos no es un detalle: aca no cambia la conclusion, pero en un caso al
  filo si podria.

**El objetivo no es elegir el $p$ que da el p-value que mas conviene.**

---

## 8. Correr el ADF en Python

### Codigo generico

```python
from statsmodels.tsa.stattools import adfuller

test = adfuller(y, regression="ct", autolag="t-stat")

print(f"Estadistico ADF : {test[0]:.4f}")
print(f"p-valor         : {test[1]:.4f}")
print(f"Rezagos         : {test[2]}")
print(f"Observaciones   : {test[3]}")
for nivel, valor in test[4].items():
    print(f"  {nivel}: {valor:.4f}")
```

La tupla que devuelve `adfuller` es:

| Indice | Contenido |
|---|---|
| `[0]` | estadistico ADF |
| `[1]` | p-value |
| `[2]` | rezagos usados |
| `[3]` | observaciones efectivas |
| `[4]` | diccionario de valores criticos |
| `[5]` | criterio de informacion (o `RegressionResults` si `regresults=True`) |

### Ver la regresion auxiliar

```python
test = adfuller(y, regression="ct", autolag="t-stat", regresults=True)
print(test[3].resols.summary())
```

**Con `regresults=True` la estructura de la tupla cambia**: `test[2]` pasa a ser
el diccionario de criticos y `test[3]` el objeto de resultados. Es la trampa del
notebook, que por eso define dos funciones de impresion distintas.

### Reproducir el ADF a mano

```python
T = len(y)
t = np.arange(1, T + 1)
dy = y.diff()

X = pd.DataFrame({"const": 1.0, "trend": t, "y_lag1": y.shift(1)}, index=y.index)
for i in range(1, k_lags + 1):
    X[f"dy_lag{i}"] = dy.shift(i)

data = pd.concat([dy, X], axis=1).dropna()
res = sm.OLS(data.iloc[:, 0], data.iloc[:, 1:]).fit()

print(res.params["y_lag1"])    # gamma
print(res.tvalues["y_lag1"])   # ESTE es el estadistico ADF
```

### Como leer la salida

El **estadistico ADF es el $t$ del coeficiente de $y_{t-1}$** en esa regresion.
El numero coincide con el que reporta `adfuller`, pero **no se compara contra la
tabla $t$**: se compara contra los criticos de Dickey-Fuller.

Los coeficientes de `dy_lag1`, `dy_lag2`, ... no se interpretan: estan solo para
blanquear los residuos.

---

## 9. DFGLS

### Teoria

El **DFGLS** (Elliott, Rothenberg y Stock, 1996) es una variante del
Dickey-Fuller que usa una transformacion **GLS** para remover los componentes
deterministicos **antes** de hacer el contraste.

Tiene **mas poder estadistico** que el ADF, sobre todo cuando $\rho$ esta cerca de
1 pero no es 1. Es justamente el caso dificil.

El PDF senala ademas que **la cantidad optima de rezagos puede ser distinta segun
haya o no tendencia deterministica**.

### Codigo generico

```python
# requiere: pip install arch
from arch.unitroot import DFGLS

dfgls = DFGLS(y, trend="ct", method="t-stat")
print(dfgls.summary())

print(dfgls.regression.summary())   # la regresion de atras
```

`trend` acepta `"c"` y `"ct"` (no tiene `"n"` ni `"ctt"`).

### Para que se usa en la practica

Como **analisis de robustez**: si ADF y DFGLS coinciden, la conclusion es solida.
Si difieren, hay que mirar con mas cuidado, y en general se le da mas peso al
DFGLS por su mayor poder.

---

# Parte C - Operador de rezagos y condiciones de estacionariedad

## 10. El operador de rezagos

### Teoria

$$L x_t = x_{t-1} \qquad L^2 x_t = x_{t-2} \qquad L^k x_t = x_{t-k}$$

Con eso, la primera diferencia es:

$$\Delta y_t = y_t - y_{t-1} = (1-L)y_t$$

y un AR($p$) se escribe:

$$y_t\left(1 - \rho_1 L - \rho_2 L^2 - \cdots - \rho_p L^p\right) = \varepsilon_t \qquad\Longleftrightarrow\qquad y_t A(L) = \varepsilon_t$$

con $A(L) = 1 - \rho_1 L - \cdots - \rho_p L^p$ y
$A(1) = 1 - \rho_1 - \cdots - \rho_p$.

### Para que sirve

Convierte manipulaciones de rezagos en **algebra de polinomios**. Todo lo que
sigue (condiciones de estacionariedad, invertibilidad, impulso-respuesta) sale de
tratar $A(L)$ y $B(L)$ como polinomios comunes.

---

## 11. Condicion de estacionariedad de un AR

### Teoria

Un AR($p$) es debilmente estacionario si **todas las raices de**

$$1 - \rho_1 z - \rho_2 z^2 - \cdots - \rho_p z^p = 0$$

**estan fuera del circulo unitario**, es decir, tienen modulo mayor a 1.

Si todas las raices son reales, la condicion es que sean todas mayores a 1 en
valor absoluto.

Para un AR(1): $1 - \rho z = 0$ tiene raiz $z = 1/\rho$, que esta fuera del
circulo unitario si y solo si $|\rho| < 1$. **Es la condicion de siempre, escrita
de otra forma.**

### Ejemplo del PDF: AR(2) con raices complejas

$$y_t = 0.75 y_{t-1} - 0.25 y_{t-2} + \varepsilon_t \qquad\Longrightarrow\qquad y_t\left(1 - 0.75L + 0.25L^2\right) = \varepsilon_t$$

Resolviendo $0.25z^2 - 0.75z + 1 = 0$ con $a=\tfrac14$, $b=-\tfrac34$, $c=1$:

$$z = \frac{\tfrac34 \pm \sqrt{\tfrac{9}{16} - 1}}{\tfrac12} = \frac{3}{2} \pm \frac{i\sqrt7}{4}\cdot 2 \;=\; 1.5 \pm 1.3229\,i$$

El modulo (la distancia al origen) es:

$$\sqrt{\left(\tfrac32\right)^2 + \left(\tfrac{\sqrt7}{2}\right)^2} = \sqrt{\tfrac94 + \tfrac74} = \sqrt{4} = 2$$

Como $2 > 1$, **el proceso es estacionario**.

### Codigo generico

```python
# 1 - 0.75 z + 0.25 z^2 = 0
# np.roots recibe los coeficientes de mayor a menor grado
raices = np.roots([0.25, -0.75, 1])

print(raices)          # [1.5+1.3229j  1.5-1.3229j]
print(np.abs(raices))  # [2. 2.]  -> estacionario
```

Con `ArmaProcess` es aun mas directo:

```python
proc = ArmaProcess(np.array([1, -0.75, 0.25]), np.array([1]))
proc.isstationary     # True
proc.arroots          # las raices
```

### Como leer la salida

**Raices complejas no son un problema**: significan que el proceso tiene
oscilaciones ciclicas. Lo que importa es el **modulo**, no si son reales o
complejas. Por eso la condicion se enuncia como "fuera del circulo unitario" y no
como "mayores a 1".

---

## 12. Estacionariedad en MA y ARMA

### MA

$$y_t = \theta_1\varepsilon_{t-1} + \cdots + \theta_q\varepsilon_{t-q} + \varepsilon_t$$

**Un MA($q$) es siempre estacionario mientras los $\theta_i$ sean finitos.** No
hay condicion que verificar.

La razon: es una suma **finita** de ruidos blancos, asi que su media y su varianza
son constantes por construccion.

### ARMA

$$y_t A(L) = B(L)\varepsilon_t, \qquad A(L) = 1-\rho_1L-\cdots-\rho_pL^p, \qquad B(L) = 1+\theta_1L+\cdots+\theta_qL^q$$

Un ARMA($p,q$) es debilmente estacionario **si y solo si** los $\theta_i$ son
finitos **y** todas las raices de $A(z) = 0$ estan fuera del circulo unitario.

**La estacionariedad la decide solo la parte AR.**

### Tabla resumen

| Parte | Polinomio | Condicion | Propiedad |
|---|---|---|---|
| AR | $A(z)=0$ | raices fuera del circulo unitario | **estacionariedad** |
| MA | $B(z)=0$ | raices fuera del circulo unitario | **invertibilidad** |

Es la tabla que reaparece en el notebook complementario de la
[Clase 8](Clase_08.md).

---

## 13. Media y varianza

### AR(1) con constante

$$y_t = c + \rho y_{t-1} + \varepsilon_t$$

Suponiendo estacionariedad, $E(y_t) = E(y_{t-1}) = \mu$:

$$\mu = c + \rho\mu \;\Longrightarrow\; \mu(1-\rho) = c \;\Longrightarrow\; \boxed{\;\mu = \frac{c}{1-\rho}\;}$$

Y la varianza es **la misma que sin constante**, porque la constante no afecta las
desviaciones respecto de la media:

$$\gamma_0 = \frac{\sigma_\varepsilon^2}{1-\rho^2}$$

Lo mismo vale para todas las autocovarianzas.

### Caso general ARMA($p,q$)

$$E(y_t) = c\left(1 - \sum_{j=1}^{p}\rho_j\right)^{-1}$$

$$\gamma_0 = Var(y_t) = \sigma_\varepsilon^2\left(1-\sum_{j=1}^{p}\rho_j^2\right)^{-1}\left(1+\sum_{i=1}^{q}\theta_i^2\right)$$

Notar que $\left(1-\sum\rho_j\right)^{-1} = A(1)^{-1}$: la media depende de $A(1)$.
Cuando $A(1) \to 0$ (raiz unitaria), la media **no existe**.

### Por que importa: reversion a la media

**Los procesos estacionarios siempre vuelven a su media.** El PDF marca la
consecuencia financiera: si nos alejamos de la media, en algun momento habria que
volver, y eso puede traducirse en una **estrategia de inversion**.

Es el fundamento del pairs trading y de las estrategias de reversion a la media.

---

# Parte D - Invertibilidad e impulso-respuesta

## 14. Invertibilidad y representacion AR($\infty$)

### Teoria

Para un ARMA estacionario, $A(L)$ tiene inversa y se puede escribir:

$$y_t = c^* + G(L)\varepsilon_t, \qquad c^* = cA(L)^{-1}, \quad G(L) = B(L)A(L)^{-1}$$

que es una representacion **MA($\infty$)**.

Si ademas la parte MA es **invertible**, es decir si las raices de

$$1 + \theta_1 z + \theta_2 z^2 + \cdots + \theta_q z^q = 0$$

estan fuera del circulo unitario, entonces $B(L)^{-1}$ existe y:

$$y_t A(L)B(L)^{-1} = \tilde{c} + \varepsilon_t$$

que es una representacion **AR($\infty$)**.

### Que significa

Un mismo proceso puede escribirse de tres formas: ARMA($p,q$) finito, MA($\infty$)
o AR($\infty$). **La invertibilidad es lo que permite la tercera.**

Su importancia practica: solo si el proceso es invertible se pueden recuperar los
$\varepsilon_t$ (no observables) a partir del pasado observado de $y$. Sin eso, no
se pueden hacer pronosticos.

---

## 15. Funcion impulso-respuesta

### Teoria

Se introduce un shock unitario $u_t$ en el periodo $t$:

$$u_t = \begin{cases}1 & \text{en el periodo } t\\ 0 & \text{si no}\end{cases}$$

Partiendo de $y_t F(L) = \tilde{c} + \varepsilon_t + u_t$ con
$F(L) = A(L)B(L)^{-1}$, y notando que
$F(L)^{-1} = A(L)^{-1}B(L) = G(L) = 1 + g_1L + g_2L^2 + \cdots$:

$$y_t = c^* + G(L)(\varepsilon_t + u_t)$$

Los coeficientes $g_1, g_2, g_3,\dots$ son el **efecto del shock sobre
$y_{t+1}, y_{t+2}, y_{t+3},\dots$** Esa es la **funcion impulso-respuesta**.

### Tres medidas resumen

| Medida | Formula | Que mide |
|---|---|---|
| **Efecto de largo plazo** | $G(1) = 1 + g_1 + g_2 + \cdots = \dfrac{B(1)}{A(1)}$ | efecto acumulado total |
| **Mean lag** | $\dfrac{\sum i\,g_i}{\sum g_i} = G(1)^{-1}G'(1)$ | rezago promedio del efecto |
| **Median lag** | el $s$ tal que se acumulo la mitad de $G(1)$ | velocidad de transmision |

### Como calcular los $g_i$

Igualando coeficientes en $A(L)G(L) = B(L)$:

$$g_k = b_k - \sum_{j=1}^{p} a_j\, g_{k-j}$$

### Ejemplo completo del PDF (Carol Alexander II.5.2)

$$y_t = 0.03 + 0.75y_{t-1} - 0.25y_{t-2} + \varepsilon_t + 0.5\varepsilon_{t-1}$$

$$A(L) = 1 - 0.75L + 0.25L^2, \qquad B(L) = 1 + 0.5L$$

Igualando coeficientes en $(1 - 0.75L + 0.25L^2)(1 + g_1L + g_2L^2 + \cdots) = 1 + 0.5L$:

$$L^1:\quad g_1 - 0.75 = 0.5 \;\Longrightarrow\; g_1 = 1.25$$
$$L^2:\quad g_2 - 0.75g_1 + 0.25 = 0 \;\Longrightarrow\; g_2 = \tfrac{11}{16} = 0.6875$$
$$L^3:\quad g_3 - 0.75g_2 + 0.25g_1 = 0 \;\Longrightarrow\; g_3 = \tfrac{13}{64} = 0.203125$$
$$L^4:\quad g_4 - 0.75g_3 + 0.25g_2 = 0 \;\Longrightarrow\; g_4 = -\tfrac{5}{256} = -0.019531$$

### Codigo generico

```python
A = [1, -0.75, 0.25]     # coeficientes de A(L), con el 1 del lag 0
B = [1, 0.5]             # coeficientes de B(L)
p = len(A) - 1

g = [1.0]
for k in range(1, 40):
    b = B[k] if k < len(B) else 0.0
    g.append(b - sum(A[j]*g[k-j] for j in range(1, min(k, p)+1)))

g = np.array(g)

print("efecto largo plazo:", g.sum())                          # 3.0
print("mean lag:", (np.arange(len(g))*g).sum() / g.sum())      # 0.8333
print("acumulada:", np.cumsum(g)/g.sum())
```

### Salida verificada

```text
g:  1.0000  1.2500  0.6875  0.2031  -0.0195  -0.0654  -0.0442  -0.0168 ...

efecto de largo plazo  G(1) = B(1)/A(1) = 1.5/0.5 = 3.0
mean lag                             = 0.8333
IRF acumulada / G(1):  0.3333  0.7500  0.9792  1.0469  1.0404  1.0186 ...
median lag (interpolando entre s=0 y s=1) = 0.4
```

### Como leer la salida

- **$g_1 = 1.25 > 1$**: el efecto en $t+1$ es **mayor** que el impacto inicial.
  Es tipico de un ARMA con parte MA positiva: el shock se amplifica antes de
  disiparse.
- **$g_4 < 0$**: la IRF **cambia de signo**. Son las oscilaciones que generan las
  raices complejas del AR(2) (las mismas del punto 11, con modulo 2).
- **Efecto de largo plazo 3**: un shock unitario eleva el nivel acumulado de $y$
  en 3 unidades.
- **La acumulada supera 1.0 y despues baja**: sobrepasa el valor de largo plazo y
  converge oscilando (overshooting). Los efectos son visibles unos 10 periodos.
- **Median lag $= 0.4$**: la mitad del efecto total ya se transmitio antes del
  primer periodo. La transmision es muy rapida.

---

# Parte E - Cointegracion

## 16. Idea inicial

### Teoria

Si $y_t$ y $x_t$ son **ambas $I(1)$**, es posible regresar:

$$y_t = \alpha + \beta x_t + u_t$$

y si los **residuos de esa regresion son estacionarios**, entonces $y_t$ y $x_t$
estan **cointegradas**, y $\hat\beta$ estima la relacion de cointegracion.

Intuitivamente: las dos series comparten una **tendencia estocastica comun**.

### La condicion, dicha con precision

**Solo si ambas son $I(1)$ y los residuos son estacionarios el analisis por MCO es
estadisticamente valido.** Si los residuos no son estacionarios, la regresion es
**espuria** y no significa nada, por mas alto que sea el $R^2$.

### Para que sirve: la lectura financiera

La cointegracion es una medida de **dependencia de largo plazo**. Si dos precios
estan cointegrados, aunque no sepamos donde va a estar cada uno en el futuro,
**conociendo uno se puede determinar aproximadamente donde estara el otro**.

Que los residuos sean estacionarios significa que **revierten a la media**. Si se
piensa a esos residuos como un **spread** entre dos activos, un spread
mean-reverting es exactamente la base de una estrategia de *pairs trading*.

### Codigo generico (Engle-Granger en dos pasos)

```python
# paso 0: confirmar que las dos son I(1)
adfuller(y, regression="c")     # no rechaza
adfuller(x, regression="c")     # no rechaza
adfuller(y.diff().dropna())     # rechaza
adfuller(x.diff().dropna())     # rechaza

# paso 1: la regresion de cointegracion
reg = sm.OLS(y, sm.add_constant(x)).fit()

# paso 2: testear estacionariedad de los residuos
adfuller(reg.resid, regression="n")

# o directamente
from statsmodels.tsa.stattools import coint
stat, pvalue, crit = coint(y, x)
```

**Detalle**: al testear los residuos con ADF, los valores criticos correctos **no**
son los de Dickey-Fuller sino los de Engle-Granger (mas exigentes, porque los
residuos son estimados). Por eso conviene usar `coint`, que ya los aplica.

El desarrollo completo (VEC, rango de $\Pi$, Johansen) esta en la
[Clase 8](Clase_08.md) y en la Clase 9.

---

# Parte F - El ejemplo del trigo, paso a paso

## 17. Preparacion

### Codigo

```python
import numpy as np, pandas as pd
from statsmodels.tsa.stattools import adfuller

df = pd.read_excel("Bases de Datos MIA103/wheat.xlsx")

inicio = pd.to_datetime(df["yearmm"].iloc[0], format="%YM%m")
df["date"] = pd.period_range(start=inicio, periods=len(df), freq="M")
df = df.set_index("date")

df["wheat_srw"] = pd.to_numeric(df["wheat_srw"], errors="coerce")

x = np.log(df["wheat_srw"]).dropna()    # log-precio (niveles)
y = x.diff().dropna()                   # retorno logaritmico (diferencias)
```

`format="%YM%m"` interpreta el formato `1980M01` de la Pink Sheet.
`errors="coerce"` convierte a `NaN` cualquier valor no numerico en vez de romper.

```text
observaciones en niveles: 501
observaciones en diferencias: 500
p_max de Schwert: 17
```

---

## 18. Paso 1 - ADF sobre la serie en niveles

### Codigo

```python
test = adfuller(x, regression="ct", autolag="t-stat", regresults=True)
```

### Salida verificada

```text
NIVELES  log(P), regression="ct":
    Estadistico ADF : -3.1031
    p-valor         :  0.1055
    Rezagos         :  9
    Valor critico 5%: -3.4195

    En la regresion auxiliar, el coeficiente de la tendencia (x11):
        coef = 6.769e-05    t = 2.609    p = 0.009   -> SIGNIFICATIVA
```

### Como leer la salida

- $-3.1031 > -3.4195$: **no se rechaza $H_0$** al 5%. Y el p-value $0.1055 > 0.10$
  tampoco permite rechazar al 10%. **La serie en niveles no es estacionaria.**
- **La tendencia deterministica SI es significativa** ($p = 0.009$), asi que
  corresponde mantener `"ct"`. Si se corriera con `"c"` el resultado seria
  $ADF = -1.8591$ ($p = 0.3515$), aun mas lejos de rechazar.

---

## 19. Paso 2 - ADF sobre las primeras diferencias

### Codigo

```python
y = x.diff().dropna()
test = adfuller(y, regression="ct", autolag="t-stat", regresults=True)
```

### Salida verificada

```text
DIFERENCIAS  dlog(P), regression="ct":
    Estadistico ADF : -8.3291
    p-valor         :  0.0000
    Rezagos         :  8

    Coeficiente de la tendencia (x10):
        coef = 1.643e-05    t = 0.814    p = 0.416   -> NO significativa

DIFERENCIAS  dlog(P), regression="c":     <- especificacion final
    Estadistico ADF : -8.2930
    p-valor         :  0.0000
    Rezagos         :  8
    Valor critico 5%: -2.8674
```

### Como leer la salida

- $-8.29 \ll -2.87$: **se rechaza $H_0$ contundentemente.** Las diferencias son
  $I(0)$.
- **La tendencia ya NO es significativa** ($p = 0.416$), asi que corresponde
  repetir con `"c"`. Ese paso es el que hace el notebook y es la aplicacion
  directa de la estrategia del punto 6.

---

## 20. Robustez con DFGLS

### Codigo

```python
from arch.unitroot import DFGLS

print(DFGLS(x, trend="ct", method="t-stat").summary())   # niveles
print(DFGLS(y, trend="c",  method="t-stat").summary())   # diferencias
```

### Salida verificada

```text
DFGLS niveles      trend="ct":  stat = -2.1292   p = 0.2418   lags = 9
DFGLS diferencias  trend="ct":  stat = -7.9704   p = 0.0000   lags = 8
DFGLS diferencias  trend="c" :  stat = -8.2243   p = 0.0000   lags = 8
```

### Como leer la salida

**ADF y DFGLS coinciden en todo**: no rechazan en niveles, rechazan
contundentemente en diferencias. La conclusion es robusta.

---

## 21. Conclusion del ejemplo

```text
log(P_t)         : NO se rechaza raiz unitaria  ->  no estacionaria
Delta log(P_t)   : SI se rechaza raiz unitaria  ->  I(0)

Por lo tanto:    log(P_t) ~ I(1)
                 los retornos logaritmicos son I(0)
```

Es exactamente el resultado canonico del punto 2: el log-precio es $I(1)$, el
retorno es $I(0)$.

### Como redactar esto en un examen

```text
Aplico el test ADF sobre el logaritmo del precio del trigo (501 observaciones
mensuales). Empiezo con constante y tendencia deterministica lineal, y selecciono
los rezagos con el criterio t-stat de Ng-Perron sobre una cota de Schwert
p_max = 17.

En niveles el estadistico ADF es -3.1031 con p-value 0.1055. Como el p-value es
mayor a 0.10, no rechazo la hipotesis nula de raiz unitaria al 10%. La tendencia
deterministica resulta significativa (p = 0.009), lo que justifica mantener la
especificacion "ct".

En primeras diferencias el estadistico ADF es -8.3291 con p-value menor a 0.0001,
de modo que rechazo la hipotesis nula. Como la tendencia deterministica ya no es
significativa (p = 0.416), repito el test sin tendencia y obtengo ADF = -8.2930,
tambien con p-value menor a 0.0001.

Concluyo que log(P_t) es I(1) y que sus primeras diferencias, los retornos
logaritmicos, son I(0). El test DFGLS confirma la conclusion en ambos casos.
```

---

## 22. Ejercitacion 6: precios y dinero

### Guion

Trabaja con `Precios_y_Dinero.xlsx` (mensual, enero 2003 a abril 2018) y **usa
nivel de significancia del 5% en todos los tests**.

| Ejercicio | Que pide | Como se resuelve |
|---|---|---|
| **1** | Graficar `m` e `ipc` | ambas crecen fuerte: sugiere series no estacionarias con tendencia |
| **2** | Orden de integracion de `ipc` con ADF | ADF en niveles, despues en diferencias, hasta que sea $I(0)$ |
| **3** | Idem para `m` | mismo procedimiento |
| **4** | Construir `inflacion` y `crec_m` y mostrar que son $I(0)$ | las tasas son las primeras diferencias |
| **5** | ACF y PACF de `inflacion` | tabla de identificacion de la [Clase 6](Clase_06.md) |
| **6** | ACF y PACF de `crec_m` | idem |
| **7** | Regresion `inflacion ~ crec_m` y autocorrelacion de residuos | ver abajo |

### Codigo

```python
df = pd.read_excel("Bases de Datos MIA103/Precios_y_Dinero.xlsx")
df.columns = df.columns.str.strip()      # la columna de dinero es 'M ' con espacio

inicio = pd.to_datetime(df['MMYY'].iloc[0]).strftime('%Y-%m')
df["yearmm"] = pd.period_range(start=inicio, periods=len(df), freq="M")
df = df.set_index("yearmm")

df['IPC'] = df['IPC'].astype(float)
df['M']   = df['M'].astype(float)

# Ej. 2 y 3: niveles primero
for v in ['IPC', 'M']:
    print(v, adfuller(df[v], regression="ct", autolag="t-stat")[:2])

# Ej. 4: las tasas
df["infl"]   = df["IPC"].pct_change()
df["crec_m"] = df["M"].pct_change()
d = df[["infl","crec_m"]].dropna()

for v in ['infl', 'crec_m']:
    print(v, adfuller(d[v], regression="ct", autolag="t-stat")[:2])
```

### El resultado esperado

Los niveles de `IPC` y `M` **no** rechazan raiz unitaria; las tasas **si**. O sea:
las dos series son $I(1)$ en niveles y sus tasas de crecimiento son $I(0)$.

Los valores exactos de estos ADF estan verificados en la
[Clase 8](Clase_08.md#18-chequeo-previo-de-estacionariedad-adf), que retoma
la misma base:

```text
infl    con "ct": ADF = -7.7204   p = 0.0000   lags =  0
crec_m  con "ct": ADF = -3.6720   p = 0.0243   lags = 14
crec_m  con "c" : ADF = -3.1373   p = 0.0239   lags = 14
```

### El ejercicio 7 y su trampa

El enunciado marca: **"cuando corremos regresiones con series de tiempo, las
series involucradas deben tener el mismo orden de integracion"**. Por eso los
ejercicios 2 a 4 van antes.

Al correr `inflacion ~ crec_m`:

**"Podemos decir que una mayor tasa de crecimiento de la base monetaria genera
inflacion?"** **No.** Un coeficiente significativo muestra **asociacion
contemporanea**, no causalidad. La herramienta correcta es el **test de
causalidad de Granger dentro de un VAR**, que es exactamente el contenido de la
[Clase 8](Clase_08.md) y de la Ejercitacion 7.

**"Estan los residuos autocorrelacionados?"** Con datos mensuales de inflacion,
casi seguro que si. Se chequea con Durbin-Watson, Ljung-Box o Breusch-Godfrey:

```python
from statsmodels.stats.diagnostic import acorr_ljungbox, acorr_breusch_godfrey

reg = sm.OLS(d["infl"], sm.add_constant(d["crec_m"])).fit()

print(acorr_ljungbox(reg.resid, lags=[6, 12], return_df=True))
print(acorr_breusch_godfrey(reg, nlags=12))
```

**"Que haria si lo estuvieran?"** Tres opciones:

1. **Modelo dinamico**: agregar rezagos de las variables. Es el camino que lleva
   naturalmente al VAR de la Clase 8.
2. **Errores robustos a autocorrelacion (HAC / Newey-West)**: no cambia los
   coeficientes, corrige los errores estandar.
   ```python
   reg_hac = sm.OLS(y, X).fit(cov_type='HAC', cov_kwds={'maxlags': 12})
   ```
3. **Modelar el error como ARMA** y estimar por GLS.

---

## 23. Errores frecuentes

| Error | Por que pasa | Como se evita |
|---|---|---|
| Comparar el ADF contra $\pm1.96$ | se arrastra el habito del test $t$ | usar los criticos que devuelve `adfuller` |
| Rechazar cuando el estadistico es **mayor** | el test es a cola izquierda | se rechaza si es **mas negativo** que el critico |
| Confundir estacionariedad con estacionalidad | suenan parecido | no tienen relacion |
| Interpretar los coeficientes de los rezagos $\Delta y_{t-i}$ | parecen parte del modelo | estan solo para blanquear residuos |
| Dejar `"ct"` cuando la tendencia no es significativa | no se mira la regresion auxiliar | `regresults=True` y revisar el coeficiente de la tendencia |
| Diferenciar una serie trend-stationary | se asume que todo se arregla diferenciando | quitarle la tendencia con una regresion contra $t$ |
| Elegir el $p$ que da el p-value que conviene | tentacion | Ng-Perron o AIC/BIC, decidido **antes** |
| Confundir la estructura de la tupla con `regresults=True` | los indices se corren | usar funciones de impresion distintas |
| Regresar dos series $I(1)$ sin chequear cointegracion | sale $R^2$ altisimo | testear estacionariedad de los residuos |
| Usar criticos de ADF sobre residuos estimados | son mas exigentes | usar `coint`, que aplica los de Engle-Granger |
| Interpretar $R^2$ alto como buena regresion | puede ser espuria | primero el orden de integracion |
| Pensar que raices complejas rompen la estacionariedad | asusta el $i$ | lo que importa es el **modulo** |
| Creer que un MA puede ser no estacionario | se confunde con invertibilidad | MA siempre estacionario; lo que puede fallar es la invertibilidad |

---

## 24. Checklist de Clase 7

Al terminar deberias poder:

1. Enunciar las tres condiciones de estacionariedad debil.
2. Distinguir estacionariedad debil de fuerte.
3. Definir $I(0)$, $I(1)$, $I(2)$ y decir como se pasa de uno a otro.
4. Explicar por que el log-precio es $I(1)$ y el retorno $I(0)$.
5. Explicar por que hay que relacionar variables del mismo orden de integracion.
6. Derivar la regresion de Dickey-Fuller restando $y_{t-1}$.
7. Plantear $H_0$ y $H_A$ del ADF.
8. Explicar por que los criticos no son los de la $t$ y por que son negativos.
9. Explicar por que el test se "aumenta" con rezagos.
10. Escribir la regresion auxiliar completa del ADF.
11. Distinguir una serie con tendencia deterministica de una $I(1)$.
12. Decir como se estacionariza cada una de las dos.
13. Elegir entre `n`, `c`, `ct`, `ctt` y justificar la eleccion.
14. Aplicar la regla de Ng-Perron y la cota de Schwert.
15. Leer una salida de `adfuller` completa.
16. Reproducir el estadistico ADF a mano con una regresion MCO.
17. Explicar que es el DFGLS y por que tiene mas poder.
18. Usar el operador de rezagos y escribir $A(L)$ y $B(L)$.
19. Enunciar la condicion de estacionariedad de un AR($p$).
20. Calcular las raices de un AR(2) y su modulo, incluido el caso complejo.
21. Explicar por que un MA($q$) es siempre estacionario.
22. Enunciar la condicion de estacionariedad de un ARMA.
23. Distinguir estacionariedad (AR) de invertibilidad (MA).
24. Calcular la media de un AR(1) con constante.
25. Escribir la media y la varianza de un ARMA($p,q$).
26. Explicar la reversion a la media y su uso financiero.
27. Explicar que permite la invertibilidad (representacion AR($\infty$)).
28. Calcular los coeficientes $g_i$ de la funcion impulso-respuesta.
29. Calcular el efecto de largo plazo, el mean lag y el median lag.
30. Definir cointegracion y decir que dos condiciones hacen falta.
31. Explicar que es una regresion espuria y como se evita.
32. Explicar la lectura financiera de la cointegracion (spread mean-reverting).

---

## 25. Notas tecnicas

- Dependencias: `numpy`, `pandas`, `matplotlib`, `statsmodels`, `openpyxl` y
  **`arch`** (para DFGLS; se instala con `pip install arch`).
- El notebook lee `wheat.xlsx` sin ruta; en el repo esta en
  `Bases de Datos MIA103/`.
- La columna `yearmm` viene en formato `1980M01`: se parsea con
  `pd.to_datetime(..., format="%YM%m")`.
- `adfuller` devuelve una tupla cuya **estructura cambia** con `regresults=True`.
  Sin el flag: `(stat, pvalue, usedlag, nobs, critvalues, icbest)`. Con el flag,
  `critvalues` pasa al indice 2 y el objeto de resultados al 3.
- El `regression=` de `statsmodels` equivale al `trend=` de `arch`, pero `arch`
  solo acepta `"c"` y `"ct"` en `DFGLS`.
- En la regresion auxiliar de `adfuller`, los regresores se llaman `x1`, `x2`,
  ..., `const`. **La tendencia es el ultimo `xN`**, despues de `const`: hay que
  contar para identificarla.
- El p-value del ADF se interpola de tablas (MacKinnon). Un `0.0000` significa
  "menor al menor valor tabulado", no exactamente cero.
- Los resultados de `autolag="AIC"` y `autolag="t-stat"` suelen coincidir; `BIC`
  tiende a elegir bastante menos rezagos.
