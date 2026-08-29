# Clase 8 - VAR, estabilidad, VEC y causalidad de Granger

[Volver al indice general](../Res+Pra.md)

Mapa completo de la Clase 8: teoria del PDF, codigo de los dos notebooks y
Ejercitacion 7. Cada tema sigue el mismo recorrido:

$$\text{teoria} \;\rightarrow\; \text{para que sirve} \;\rightarrow\; \text{codigo generico} \;\rightarrow\; \text{como leer la salida}$$

Todas las salidas numericas de esta guia fueron reproducidas ejecutando el codigo
de la clase sobre la base del repositorio.

## Archivos de esta clase

| Tipo | Archivo | Para que se usa |
|---|---|---|
| Teoria | `Clases/MIA103_Clase_8_VAR_.pdf` | VAR, autovalores, estabilidad, VEC y causalidad de Granger |
| Python | `Codigos/MIA103 Clase 08 Introducción VAR.ipynb` | Simulacion, estimacion, estabilidad, ADF, VAR de precios y dinero, Granger |
| Python | `Codigos/MIA103 Clase 08 Estacionariedad Invertibilidad.ipynb` | Raices AR/MA, circulo unitario, impulso-respuesta, ACF/PACF |
| Practica | `Practicas/MIA103_Ejer_7_.pdf` | VAR entre crecimiento monetario e inflacion |
| Datos | `Bases de Datos MIA103/Precios_y_Dinero.xlsx` | `MMYY`, `IPC`, `M `, `M_en_ARS` |

## Mapa tema - PDF - notebook

| # | Tema | PDF | Notebook |
|---:|---|---|---|
| 1 | Definicion de VAR($p$) | p. 2 | Intro VAR, celdas 0-1 |
| 2 | Ruido blanco vectorial y $\Omega$ | p. 3 | Intro VAR, celdas 6-7 |
| 3 | VAR(1) con dos variables | p. 4 | Intro VAR, celdas 2-5 |
| 4 | Autovalores, diagonalizacion y estabilidad | p. 5-7 | Intro VAR, celdas 8-12 |
| 5 | Caso 1: $I(0)$ y equilibrio de largo plazo | p. 8-9 | Intro VAR, celdas 26-29 |
| 6 | Simulacion del VAR(1) | - | Intro VAR, celdas 19-25 |
| 7 | Estimacion del VAR | - | Intro VAR, celdas 30-42 |
| 8 | Caso 2: cointegracion | p. 10-11 | Intro VAR, celdas 13-15 |
| 9 | Forma VEC | p. 12-16 | (teoria; se resuelve a mano) |
| 10 | Caso 3: Jordan e $I(2)$ | p. 17-20 | Intro VAR, celdas 16-18 |
| 11 | Causalidad de Granger | p. 21-22 | Intro VAR, celdas 43-46 |
| 12 | Raices AR/MA, invertibilidad, IRF | - | Estacionariedad Invertibilidad, todo |
| 13 | Ejercitacion 7: dinero e inflacion | - | Intro VAR, celdas 47-72 |

---

# Parte A - Teoria del VAR

## 1. De AR univariado a VAR

### Teoria

Hasta la Clase 7 mirabamos procesos autorregresivos univariados:

$$AR(p):\quad y_t = c + \rho_1 y_{t-1} + \cdots + \rho_p y_{t-p} + \varepsilon_t$$

En un VAR pasamos de una variable a un **vector columna** de $k$ variables:

$$\mathbf{y}_t = (y_{1t},\, y_{2t},\, y_{3t},\, \dots,\, y_{kt})'$$

Un VAR($p$) es:

$$\boxed{\;\mathbf{y}_t = \mathbf{m} + A_1\mathbf{y}_{t-1} + A_2\mathbf{y}_{t-2} + \cdots + A_p\mathbf{y}_{t-p} + \boldsymbol\varepsilon_t\;}$$

donde:

- $\mathbf{y}_t$ es un vector $k\times1$;
- $\mathbf{m}$ es un vector de constantes $k\times1$;
- cada $A_i$ es una matriz de coeficientes $k\times k$;
- $\boldsymbol\varepsilon_t$ es un vector $k\times1$ de ruidos blancos.

### Para que sirve

Cada variable depende de sus propios rezagos **y de los rezagos de las demas**.

Un VAR **no elige una variable como estrictamente exogena**: trata a todas las
variables del vector como endogenas y deja que la dinamica se exprese via rezagos.
Esa es la diferencia conceptual con una regresion, donde hay que decidir de
antemano quien explica a quien.

### Idea para recordar

VAR = muchas ecuaciones AR estimadas juntas, donde todas las variables pueden
depender del pasado de todas.

---

## 2. Ruido blanco vectorial

### Teoria

El error $\boldsymbol\varepsilon_t$ es un vector de ruidos blancos que cumple:

$$E(\boldsymbol\varepsilon_t) = \mathbf{0} \quad \forall t$$

$$E(\boldsymbol\varepsilon_t\boldsymbol\varepsilon_s') = \begin{cases}\boldsymbol\Omega & \text{si } t = s\\ \mathbf{0} & \text{si } t \ne s\end{cases}$$

$\boldsymbol\Omega$ es la matriz de varianzas y covarianzas contemporaneas de los
shocks, y se supone **definida positiva**.

### Para que sirve

Marca que se admite y que no:

- Los shocks **no** estan correlacionados serialmente: el shock de hoy no debe
  estar correlacionado con el de ayer.
- Los shocks de **distintas ecuaciones si** pueden estar correlacionados en el
  mismo periodo. Un shock contemporaneo puede golpear a la vez a inflacion y
  dinero.

### Codigo generico

En el notebook $\boldsymbol\Omega$ es parte del proceso generador elegido:

```python
Omega = np.array([[1.0, 0.5],
                  [0.5, 1.0]])
```

### Como leer la salida

**$\boldsymbol\Omega$ no se elige cuando se estima: se estima.** En
`statsmodels` la estimacion aparece como `results.sigma_u`. Si la covarianza fuera
del diagonal es grande, los shocks de las dos ecuaciones estan muy ligados.

---

## 3. VAR(1) con dos variables

### Teoria

El caso mas simple del PDF es $k=2$, $p=1$:

$$\mathbf{y}_t = \mathbf{m} + A\,\mathbf{y}_{t-1} + \boldsymbol\varepsilon_t \tag{$*$}$$

$$\begin{pmatrix}y_{1t}\\ y_{2t}\end{pmatrix} = \begin{pmatrix}m_1\\ m_2\end{pmatrix} + \begin{pmatrix}a_{11} & a_{12}\\ a_{21} & a_{22}\end{pmatrix}\begin{pmatrix}y_{1,t-1}\\ y_{2,t-1}\end{pmatrix} + \begin{pmatrix}\varepsilon_{1t}\\ \varepsilon_{2t}\end{pmatrix}$$

Ecuacion por ecuacion:

$$y_{1t} = m_1 + a_{11}y_{1,t-1} + a_{12}y_{2,t-1} + \varepsilon_{1t}$$
$$y_{2t} = m_2 + a_{21}y_{1,t-1} + a_{22}y_{2,t-1} + \varepsilon_{2t}$$

### Como interpretar los coeficientes

| Coeficiente | Que mide |
|---|---|
| $a_{11}$ | persistencia propia de $y_1$ |
| $a_{12}$ | efecto predictivo del rezago de $y_2$ sobre $y_1$ |
| $a_{21}$ | efecto predictivo del rezago de $y_1$ sobre $y_2$ |
| $a_{22}$ | persistencia propia de $y_2$ |

**La diagonal es persistencia; lo de afuera de la diagonal es transmision
cruzada.** Si toda la parte fuera de la diagonal de una fila fuera cero, no habria
causalidad de Granger en esa direccion.

### Codigo generico

```python
A = np.array([[0.5, 0.2],
              [0.1, 0.4]])
m = np.array([1.0, 0.5])
```

que corresponde a:

$$y_{1t} = 1.0 + 0.5\,y_{1,t-1} + 0.2\,y_{2,t-1} + \varepsilon_{1t}$$
$$y_{2t} = 0.5 + 0.1\,y_{1,t-1} + 0.4\,y_{2,t-1} + \varepsilon_{2t}$$

---

## 4. Autovalores y diagonalizacion

### Teoria

El comportamiento de $\mathbf{y}_t$ depende de la matriz $A$. Sean sus autovalores
y autovectores:

$$\Lambda = \begin{pmatrix}\lambda_1 & 0\\ 0 & \lambda_2\end{pmatrix} \qquad\qquad C = \begin{pmatrix}\vdots & \vdots\\ \mathbf{c}_1 & \mathbf{c}_2\\ \vdots & \vdots\end{pmatrix}$$

Si los autovalores son distintos, los autovectores son linealmente independientes,
$C$ es no singular y:

$$C^{-1}AC = \Lambda \qquad\qquad A = C\Lambda C^{-1}$$

Definiendo $\mathbf{z}_t = C^{-1}\mathbf{y}_t$ (o sea $\mathbf{y}_t = C\mathbf{z}_t$)
y premultiplicando $(*)$ por $C^{-1}$:

$$\mathbf{z}_t = \mathbf{m}^* + \Lambda\,\mathbf{z}_{t-1} + \boldsymbol\eta_t$$

con $\mathbf{m}^* = C^{-1}\mathbf{m}$ y $\boldsymbol\eta_t = C^{-1}\boldsymbol\varepsilon_t$.
Como $\Lambda$ es diagonal:

$$z_{1t} = m_1^* + \lambda_1 z_{1,t-1} + \eta_{1t}$$
$$z_{2t} = m_2^* + \lambda_2 z_{2,t-1} + \eta_{2t}$$

### Para que sirve

**La diagonalizacion desarma el sistema en dos AR(1) univariados y separados.**
Cada autovalor indica la persistencia de una direccion del sistema:

| $\lvert\lambda_i\rvert$ | Comportamiento de $z_{it}$ |
|---|---|
| $<1$ | $I(0)$: el shock es transitorio |
| $=1$ | random walk con drift: raiz unitaria |
| $>1$ | explosivo (el PDF lo descarta) |

Y la condicion de estabilidad del VAR(1) queda:

$$\boxed{\;|\lambda_i| < 1 \quad \text{para todo } i\;}$$

### Codigo generico

```python
eigenvalues, eigenvectors = np.linalg.eig(A)

print("Autovalores:", eigenvalues)
print("Modulo:", np.abs(eigenvalues))

stable = np.all(np.abs(eigenvalues) < 1)
print("El VAR es estable?", stable)
```

### Salida verificada

```text
Autovalores: [0.6 0.3]
Modulo:      [0.6 0.3]
El VAR es estable? True
```

Ambos autovalores tienen modulo menor que uno: estamos en el **Caso 1**, las
variables son $I(0)$ y existe equilibrio de largo plazo.

### Idea para recordar

En VAR, los autovalores cumplen el papel que $\rho$ cumplia en AR(1).

---

## 5. Caso 1: todos los autovalores con modulo menor a uno

### Teoria

Si $|\lambda_1|<1$ y $|\lambda_2|<1$, los $\mathbf{z}_t$ son $I(0)$. Como
$\mathbf{y}_t = C\mathbf{z}_t$ es combinacion lineal de ellos, tambien
$\mathbf{y}_t$ es $I(0)$.

Tomando esperanza en $(*)$ y suponiendo un valor de largo plazo $\bar{\mathbf{y}}$:

$$\bar{\mathbf{y}} = \mathbf{m} + A\bar{\mathbf{y}} \;\Longrightarrow\; (I-A)\bar{\mathbf{y}} = \mathbf{m} \;\Longrightarrow\; \Pi\bar{\mathbf{y}} = \mathbf{m}, \quad \Pi = I - A$$

Si $\Pi$ es no singular hay solucion unica:

$$\boxed{\;\bar{\mathbf{y}} = (I-A)^{-1}\mathbf{m}\;}$$

### Dos propiedades utiles del PDF

$$\mu_i = 1 - \lambda_i \quad\text{(los autovalores de } \Pi\text{)} \qquad\qquad \text{los autovectores de } \Pi \text{ son los de } A$$

Con eso se ve directo que **$\Pi$ es no singular exactamente cuando ningun
$\lambda_i$ vale 1**.

### Codigo generico

```python
I = np.eye(2)

y_bar = np.linalg.solve(I - A, m)
print("Equilibrio de largo plazo:", y_bar)

print((I - A) @ y_bar)     # verificacion: debe dar m
```

### Salida verificada

```text
Equilibrio de largo plazo: [2.5   1.25]
Verificacion (I-A) y_bar : [1.0   0.5 ]   -> es exactamente m
```

### Como leer la salida

El sistema tiene equilibrio de largo plazo: los desvios son transitorios y revierte
a su media.

**`np.linalg.solve(I - A, m)` es preferible a `np.linalg.inv(I - A) @ m`**: es mas
estable numericamente y evita invertir explicitamente.

---

## 6. Simular un VAR(1)

### Teoria

Para generar datos hace falta, ademas de $A$ y $\mathbf{m}$, el vector de errores.
Para simular se supone (no es un requisito teorico del VAR):

$$\boldsymbol\varepsilon_t \sim N(\mathbf{0},\, \boldsymbol\Omega)$$

y se itera la recursion $\mathbf{y}_t = \mathbf{m} + A\mathbf{y}_{t-1} + \boldsymbol\varepsilon_t$.

### Codigo generico

```python
np.random.seed(2484)
T = 350

eps = np.random.multivariate_normal(mean=[0, 0], cov=Omega, size=T)

y = np.zeros((T, 2))
for t in range(1, T):
    y[t] = m + A @ y[t-1] + eps[t]

df = pd.DataFrame(y[1:], columns=["y1", "y2"])
df.plot(figsize=(12, 5), title="VAR(1) simulado")
```

### Como leer la salida

Tres detalles del codigo:

- **`np.random.multivariate_normal` con `cov=Omega`** es lo que genera la
  correlacion contemporanea entre las dos ecuaciones. Con `np.random.normal` dos
  veces por separado la correlacion seria cero.
- **`A @ y[t-1]`** es producto matricial: cada fila mezcla los dos rezagos.
- **Se descarta la primera fila** (`y[1:]`) porque `y[0]` es el valor inicial cero
  y no lo genero el proceso.

Como el sistema es estable, la serie fluctua alrededor de
$\bar{\mathbf{y}} = (2.5,\, 1.25)$ en vez de derivar.

---

## 7. Estimar un VAR

### Teoria

Si todas las ecuaciones tienen los mismos regresores, un VAR puede estimarse por
**MCO ecuacion por ecuacion**. Para dos variables y $p$ rezagos, la ecuacion de
$y_1$ es:

$$y_{1t} = c_1 + a_{11,1}y_{1,t-1} + a_{12,1}y_{2,t-1} + \cdots + a_{11,p}y_{1,t-p} + a_{12,p}y_{2,t-p} + e_{1t}$$

La ecuacion de $y_2$ usa **los mismos regresores**, pero otra variable dependiente.

### Codigo generico

```python
from statsmodels.tsa.vector_ar.var_model import VAR

model = VAR(df)            # df: columnas = variables del sistema
results = model.fit(1)     # VAR(1)
print(results.summary())

A_hat     = results.coefs[0]    # matriz A estimada
m_hat     = results.intercept   # vector m estimado
Omega_hat = results.sigma_u     # Omega estimada
```

`results.coefs` tiene forma $(p, k, k)$: `coefs[0]` es $A_1$, `coefs[1]` es $A_2$,
etc.

### Salida verificada

Comparando verdad contra estimacion sobre 349 observaciones simuladas:

```text
A verdadera            A estimada
[0.5  0.2]             [0.4535  0.2395]
[0.1  0.4]             [0.0858  0.3860]

m verdadero            m estimado
[1.0  0.5]             [0.9578  0.5328]
```

### Como leer la salida

Las estimaciones se acercan a los valores verdaderos pero no coinciden: la muestra
es finita. Es la misma logica de cualquier MCO.

**La parte dificil del VAR no es estimarlo, sino decidir**: que variables entran,
si van en niveles o diferencias, cuantos rezagos, si el sistema es estable, y que
hipotesis dinamicas se quieren testear.

---

## 8. Estabilidad con $p>1$: la matriz companion

### Teoria

Con $p>1$ no alcanza con mirar una sola matriz $A$. El VAR($p$) se reescribe como
un VAR(1) de dimension $k\cdot p$ usando la **matriz companion**:

$$F = \begin{pmatrix}A_1 & A_2 & \cdots & A_{p-1} & A_p\\ I & 0 & \cdots & 0 & 0\\ 0 & I & \cdots & 0 & 0\\ \vdots & & \ddots & & \vdots\\ 0 & 0 & \cdots & I & 0\end{pmatrix}$$

El VAR es **estable si todos los autovalores de $F$ tienen modulo menor a 1**.

### Codigo generico

```python
results.is_stable()      # forma recomendada: True / False

results.roots            # OJO: raices del polinomio caracteristico
np.abs(results.roots)    # aca la estabilidad requiere modulo > 1
```

### La trampa mas importante de la clase

`statsmodels` reporta en `roots` **las raices del polinomio caracteristico**, no
los autovalores de la companion. La relacion es **inversa**:

$$|\text{raices}| > 1 \iff |\text{autovalores companion}| < 1 \iff \text{estable}$$

En el VAR(3) de la practica, `np.abs(results.roots)` da
$[2.16,\, 1.94,\, 1.94,\, 1.88,\, 1.88,\, 1.78]$, todos mayores que 1, y el maximo
modulo de autovalor de la companion es $0.5618 < 1$. **Las dos lecturas dicen lo
mismo.**

Para obtener el autovalor de la companion directamente:

```python
A_stack = np.hstack(results.coefs)      # k x (k*p)
k, p = results.neqs, results.k_ar

comp = np.vstack([
    A_stack,
    np.hstack([np.eye(k*(p-1)), np.zeros((k*(p-1), k))])
])
max_modulo = np.abs(np.linalg.eigvals(comp)).max()
```

### Idea para recordar

Usar `is_stable()` para concluir; usar `roots` **solo** si se recuerda que ahi la
condicion es modulo **mayor** a uno.

---

## 9. Caso 2: un autovalor unitario y otro estable

### Teoria

Si $\lambda_1 = 1$ y $|\lambda_2| < 1$, entonces $z_{1t}$ es un random walk con
drift y $z_{2t}$ es $I(0)$. Como $y_{1t}$ e $y_{2t}$ son combinaciones lineales de
ambos, **las dos son $I(1)$**.

No tiene sentido preguntarse por un equilibrio estatico de $\bar{y}_1$ o
$\bar{y}_2$ por separado. Pero si tiene sentido preguntar si hay **cointegracion**.

Tomando la segunda fila de $\mathbf{z}_t = C^{-1}\mathbf{y}_t$:

$$z_{2t} = \mathbf{c}^{(2)}\mathbf{y}_t$$

donde $\mathbf{c}^{(2)}$ es la segunda fila de $C^{-1}$. Escribiendo
$\mathbf{y}_t = \mathbf{c}_1 z_{1t} + \mathbf{c}_2 z_{2t}$ y premultiplicando por
$\mathbf{c}^{(2)}$, usando $\mathbf{c}^{(2)}\mathbf{c}_1 = 0$ y
$\mathbf{c}^{(2)}\mathbf{c}_2 = 1$:

$$\boxed{\;\mathbf{c}^{(2)}\mathbf{y}_t = z_{2t}\;}$$

Es decir: $z_{2t}$ es una **combinacion lineal de dos variables $I(1)$ que resulta
$I(0)$**.

### Codigo generico

```python
A_caso2 = np.array([[1.2, -0.2],
                    [0.6,  0.4]])

np.linalg.eigvals(A_caso2)     # array([1. , 0.6])
```

### Idea para recordar

Cointegracion = variables $I(1)$ unidas por una combinacion lineal $I(0)$. El
vector fila $\mathbf{c}^{(2)}$ **es** el vector de cointegracion.

---

## 10. La forma VEC

### Teoria

Partiendo de $\mathbf{y}_t = \mathbf{m} + A\mathbf{y}_{t-1} + \boldsymbol\varepsilon_t$
y restando $\mathbf{y}_{t-1}$:

$$\Delta\mathbf{y}_t = \mathbf{m} - \Pi\,\mathbf{y}_{t-1} + \boldsymbol\varepsilon_t, \qquad \Pi = I - A$$

En el Caso 2 los autovalores de $\Pi$ son $0$ y $1-\lambda_2$: **$\Pi$ es singular
y tiene rango 1**. Como comparte autovectores con $A$:

$$\Pi = C\begin{pmatrix}0 & 0\\ 0 & 1-\lambda_2\end{pmatrix}C^{-1} = \underbrace{\begin{pmatrix}\vdots\\ \mathbf{c}_2(1-\lambda_2)\\ \vdots\end{pmatrix}}_{\boldsymbol\alpha}\underbrace{\begin{pmatrix}\cdots & \mathbf{c}^{(2)} & \cdots\end{pmatrix}}_{\boldsymbol\beta'}$$

Es decir, $\Pi$ de rango 1 se factoriza como **producto exterior** de un vector
columna por un vector fila:

$$\boxed{\;\Pi = \boldsymbol\alpha\boldsymbol\beta' \qquad\Longrightarrow\qquad \Delta\mathbf{y}_t = \mathbf{m} - \boldsymbol\alpha\boldsymbol\beta'\mathbf{y}_{t-1} + \boldsymbol\varepsilon_t\;}$$

### Para que sirve

| Objeto | Que mide |
|---|---|
| $\boldsymbol\beta'\mathbf{y}_{t-1}$ | el **desvio** respecto de la relacion de largo plazo |
| $\boldsymbol\alpha$ | los **pesos**: como ajusta cada variable ante el desequilibrio |

Es un **Vector Error Correction Model (VEC)**: combina diferencias de corto plazo
con una relacion de largo plazo en niveles.

Ecuacion por ecuacion:

$$\Delta y_{1t} = m_1 - c_{21}(1-\lambda_2)z_{2,t-1} + \varepsilon_{1t}$$
$$\Delta y_{2t} = m_2 - c_{22}(1-\lambda_2)z_{2,t-1} + \varepsilon_{2t}$$

### Ejemplo completo del PDF, paso a paso

Con $m_1 = m_2 = 0$:

$$y_{1t} = 1.2y_{1,t-1} - 0.2y_{2,t-1} + \varepsilon_{1t}$$
$$y_{2t} = 0.6y_{1,t-1} + 0.4y_{2,t-1} + \varepsilon_{2t}$$

**Paso 1 - autovalores**, de $\det(A - \lambda I) = 0$:

$$\lambda_1 = 1 \qquad\qquad \lambda_2 = 0.6$$

**Paso 2 - autovectores**:

$$\lambda_1 = 1:\quad \begin{pmatrix}0.2 & -0.2\\ 0.6 & -0.6\end{pmatrix}\begin{pmatrix}x_1\\ x_2\end{pmatrix} = 0 \;\Longrightarrow\; x_1 = x_2 \;\Longrightarrow\; \mathbf{c}_1 = \begin{pmatrix}1\\1\end{pmatrix}$$

$$\lambda_2 = 0.6:\quad \begin{pmatrix}0.6 & -0.2\\ 0.6 & -0.2\end{pmatrix}\begin{pmatrix}x_1\\ x_2\end{pmatrix} = 0 \;\Longrightarrow\; 0.6x_1 = 0.2x_2 \;\Longrightarrow\; \mathbf{c}_2 = \begin{pmatrix}1\\3\end{pmatrix}$$

**Paso 3 - matrices**:

$$C = \begin{pmatrix}1 & 1\\ 1 & 3\end{pmatrix} \qquad\qquad C^{-1} = \begin{pmatrix}1.5 & -0.5\\ -0.5 & 0.5\end{pmatrix}$$

**Paso 4 - forma VEC**:

$$\Delta y_{1t} = 0.2y_{1,t-1} - 0.2y_{2,t-1} + \varepsilon_{1t}$$
$$\Delta y_{2t} = 0.6y_{1,t-1} - 0.6y_{2,t-1} + \varepsilon_{2t}$$

o, como producto exterior:

$$\Delta\mathbf{y}_t = -\underbrace{\begin{pmatrix}0.4\\ 1.2\end{pmatrix}}_{\boldsymbol\alpha}\underbrace{\begin{pmatrix}-0.5 & 0.5\end{pmatrix}}_{\boldsymbol\beta'}\mathbf{y}_{t-1} + \boldsymbol\varepsilon_t$$

La relacion de cointegracion es $\boldsymbol\beta' = (-0.5,\, 0.5)$, proporcional a
$\mathbf{c}^{(2)}$, la segunda fila de $C^{-1}$.

### Verificacion en Python

```python
A2 = np.array([[1.2, -0.2], [0.6, 0.4]])
Pi = np.eye(2) - A2

print(Pi)                          # [[-0.2, 0.2], [-0.6, 0.6]]
print(np.linalg.eigvals(Pi))       # [0. , 0.4]   -> son 0 y 1 - lambda_2
print(np.linalg.matrix_rank(Pi))   # 1            -> rango reducido

alpha = np.array([[0.4], [1.2]])
beta  = np.array([[-0.5, 0.5]])
print(-alpha @ beta)               # [[0.2, -0.2], [0.6, -0.6]] = -Pi
```

### Como leer la salida

Las tres cosas cierran: los autovalores de $\Pi$ son $0$ y $1-0.6 = 0.4$, el rango
es 1, y $-\boldsymbol\alpha\boldsymbol\beta'$ reproduce exactamente los
coeficientes de la forma VEC.

**El rango de $\Pi$ es la cantidad de relaciones de cointegracion**:

| $\text{rango}(\Pi)$ | Interpretacion |
|---|---|
| $0$ | no hay cointegracion: trabajar el VAR en diferencias |
| $1$ | una relacion de cointegracion: **VEC** |
| $k$ | las series ya eran $I(0)$: VAR en niveles |

---

## 11. Caso 3: autovalores unitarios repetidos

### Teoria

Si $\lambda_1 = \lambda_2 = 1$ y no hay dos autovectores linealmente
independientes, $A$ **no se puede diagonalizar**: no existe $C^{-1}$.

El PDF lo analiza con la **forma de Jordan**. Existe $P$ no singular tal que:

$$P^{-1}AP = J, \qquad J = \begin{pmatrix}\lambda & 1\\ 0 & \lambda\end{pmatrix}$$

Con $\mathbf{z}_t = P^{-1}\mathbf{y}_t$, sustituyendo en $(*)$:

$$\mathbf{z}_t = J\mathbf{z}_{t-1} + \mathbf{m}^* + \boldsymbol\eta_t$$

o sea:

$$z_{1t} = \lambda z_{1,t-1} + z_{2,t-1} + m_1^* + \eta_{1t}$$
$$z_{2t} = \lambda z_{2,t-1} + m_2^* + \eta_{2t}$$

Con $\lambda = 1$, en terminos del operador de rezagos:

$$(1-L)z_{1t} = z_{2,t-1} + m_1^* + \eta_{1t}$$
$$(1-L)z_{2t} = m_2^* + \eta_{2t}$$

La segunda dice que $z_{2t}$ es $I(1)$. Multiplicando la primera por $(1-L)$:

$$(1-L)^2 z_{1t} = m_2^* + \eta_{2t} + \eta_{1t} - \eta_{1,t-1}$$

Entonces **$z_{1t}$ es $I(2)$**, y por lo tanto $y_{1t}$ e $y_{2t}$ son ambas
$I(2)$.

### Codigo generico

```python
A_caso3 = np.array([[0.8, -0.4],
                    [0.1,  1.2]])

w, v = np.linalg.eig(A_caso3)
print(w)   # autovalores
print(v)   # autovectores
```

### Salida verificada

```text
autovalores: [1.  1.]
autovectores:
[[ 0.8944  0.8944]
 [-0.4472 -0.4472]]
```

### Como leer la salida

**Las dos columnas de autovectores son identicas**: ambas proporcionales a
$(-2,\,1)'$. Es exactamente lo que dice el PDF: hay un solo autovector y falta el
segundo, asi que $A$ no es diagonalizable.

Es un buen chequeo practico: **si `np.linalg.eig` devuelve columnas repetidas, la
matriz es defectuosa y hay que ir a Jordan.**

Este caso es una posibilidad teorica; el trabajo aplicado se concentra en sistemas
estables $I(0)$ o en variables $I(1)$ con posible cointegracion.

---

## 12. Causalidad de Granger

### Teoria

Decimos que $x_t$ **causa en sentido de Granger** a $y_t$ si los rezagos de $x_t$
ayudan a explicar $y_t$, una vez incluidos los rezagos de $y_t$.

En la ecuacion de $y$:

$$y_t = c + a_1y_{t-1} + \cdots + a_py_{t-p} + b_1x_{t-1} + \cdots + b_px_{t-p} + e_t$$

$$\boxed{\;H_0: b_1 = b_2 = \cdots = b_p = 0 \qquad H_A: \text{al menos un } b_j \ne 0\;}$$

Es un **test F conjunto** sobre los $p$ coeficientes de $x$ rezagada.

### Codigo generico

```python
test = results.test_causality(caused="y1", causing=["y2"], kind="f")
print(test.summary())
```

`caused` es la variable de la ecuacion; `causing` es la lista de variables cuyos
rezagos se anulan bajo $H_0$. **La direccion del test es `causing -> caused`**, y
se confunde facil.

### Salida verificada (sobre el VAR(1) simulado)

Por construccion $a_{12}=0.2\ne0$ y $a_{21}=0.1\ne0$, o sea que hay causalidad en
las dos direcciones:

```text
y2 -> y1 : p-value = 0.0002    se rechaza H0
y1 -> y2 : p-value = 0.0875    se rechaza al 10%, no al 5%
```

### Como leer la salida

El test recupera lo que pusimos en el proceso generador. Y muestra algo util: **el
efecto mas chico ($a_{21}=0.1$) es mas dificil de detectar que el mas grande
($a_{12}=0.2$)**.

Granger es **causalidad predictiva temporal**. No es causalidad estructural ni
prueba un mecanismo economico. Que "el crecimiento monetario cause en Granger a la
inflacion" significa que sus rezagos ayudan a predecir inflacion condicional en
los rezagos de inflacion. **No** significa:

- que la politica monetaria sea el unico determinante de inflacion;
- que haya causalidad experimental;
- que el efecto sea contemporaneo;
- que no existan variables omitidas.

### Idea para recordar

Granger responde: **"sirve el pasado de $x$ para pronosticar $y$?"** Nada mas.

---

## 13. Seleccion de rezagos

### Teoria

$$\text{pocos rezagos} \to \text{autocorrelacion residual, dinamica perdida}$$
$$\text{muchos rezagos} \to \text{se consumen grados de libertad, sobreajuste}$$

Se usan criterios de informacion: **AIC**, **BIC** (Schwarz), **HQ** y **FPE**.
Para cada uno se elige el $p$ que **minimiza** el valor.

### Codigo generico

```python
model = VAR(data)

print(model.select_order().summary())      # maxlags por defecto
print(model.select_order(24).summary())    # maxlags explicito

model.select_order(24).selected_orders     # dict con el p elegido por criterio
```

### Como leer la salida

En general:

- **AIC** suele elegir modelos mas largos;
- **BIC** penaliza mas los parametros y suele elegir menos rezagos;
- **HQ** queda en un punto intermedio.

Un detalle que se pasa por alto: **cambiar `maxlags` cambia la muestra efectiva**
sobre la que se comparan todos los modelos, asi que los valores de los criterios se
mueven. En la base de la practica, con `maxlags` por defecto y con `maxlags=24` el
minimo de AIC cae igual en $p=13$, pero los numeros no son identicos.

---

# Parte B - Notebook complementario: estacionariedad e invertibilidad

Este notebook no es sobre VAR: es el cierre univariado de ARMA que conviene tener
fresco, porque **la logica de "raices y circulo unitario" es la misma que despues
aplicamos a los autovalores del VAR**.

## 14. Raices AR y MA

### Teoria

Para un proceso ARMA:

| Parte | Condicion | Propiedad |
|---|---|---|
| **AR** | raices del polinomio AR fuera del circulo unitario | **estacionariedad** |
| **MA** | raices del polinomio MA fuera del circulo unitario | **invertibilidad** |

"Fuera del circulo unitario" = modulo mayor a 1.

### Codigo generico

`statsmodels` pide los polinomios con el **lag cero incluido** y con el signo de
la parte AR **invertido**:

```python
from statsmodels.tsa.arima_process import ArmaProcess

arparams = np.array([.75, -.25])
maparams = np.array([.5])

ar = np.r_[1, -arparams]   # signo invertido y lag 0
ma = np.r_[1, maparams]    # signo normal y lag 0

arma_process = ArmaProcess(ar, ma)

print(arma_process.isstationary)
print(arma_process.isinvertible)
print(arma_process.arroots)
print(arma_process.maroots)
```

### Como leer la salida

El detalle del signo es la trampa clasica. El proceso

$$y_t = 0.75y_{t-1} - 0.25y_{t-2} + \varepsilon_t + 0.5\varepsilon_{t-1}$$

se escribe $(1 - 0.75L + 0.25L^2)y_t = (1 + 0.5L)\varepsilon_t$. Por eso
`ar = [1, -0.75, 0.25]` lleva los coeficientes AR con signo cambiado y
`ma = [1, 0.5]` no.

El notebook grafica esas raices contra el circulo unitario: **si los puntos caen
afuera del circulo, el proceso es estacionario/invertible**.

---

## 15. Impulso-respuesta, simulacion y ACF/PACF

### Codigo generico

```python
print(arma_process.impulse_response(10))       # IRF teorica

y = arma_process.generate_sample(500)          # serie sintetica
model = sm.tsa.ARIMA(y, order=(2, 0, 1), trend='n').fit()
print(model.params)
print(model.summary())

plot_acf(y, lags=20)
plot_pacf(y, lags=20)
```

### Como leer la salida

- `order=(2, 0, 1)`: 2 rezagos AR, 0 diferenciaciones, 1 rezago MA.
- `trend='n'`: sin constante ni tendencia.
- `params` devuelve los coeficientes por maxima verosimilitud; con muestra finita
  se aproximan a $\rho_1=0.75$, $\rho_2=-0.25$, $\theta_1=0.5$ pero no coinciden
  exactamente.
- La IRF muestra como se disipa un shock unitario: **si el proceso es estacionario,
  converge a cero**.

---

# Parte C - Ejercitacion 7: dinero e inflacion

## 16. El enunciado

El gobierno lo contrata para investigar si una mayor tasa de crecimiento de la
base monetaria **causa en sentido de Granger** una mayor tasa de inflacion.

Requisitos explicitos:

- usar la base `Precios_y_Dinero.xlsx` vista en clase;
- usar **todo el periodo**;
- decidir cuantos meses (rezagos) tomar;
- si se muestra causalidad, el VAR **debe ser estable**;
- el numero de rezagos **debe surgir de un criterio de seleccion optima**;
- nivel de significancia del **10%** en todos los tests.

Pista del enunciado: *"en clase vimos que usando pocos rezagos no encontrabamos
causalidad; es posible que haya que tomar mas rezagos"*.

---

## 17. Preparacion de datos

### Codigo generico

```python
df = pd.read_excel("Bases de Datos MIA103/Precios_y_Dinero.xlsx")
print(df.columns.tolist())

# 1. quitar espacios invisibles en los nombres de columnas
df.columns = df.columns.str.strip()

# 2. indice mensual
inicio = pd.to_datetime(df['MMYY'].iloc[0]).strftime('%Y-%m')
df["yearmm"] = pd.period_range(start=inicio, periods=len(df), freq="M")
df = df.set_index("yearmm")

# 3. tipos
df['IPC'] = df['IPC'].astype(float)
df['M']   = df['M'].astype(float)

# 4. tasas
df["infl"]   = df["IPC"].pct_change()
df["crec_m"] = df["M"].pct_change()

df = df[['infl', 'crec_m']].dropna()
```

### Salida verificada

```text
columnas originales : ['MMYY', 'IPC', 'M ', 'M_en_ARS']
periodo de la base  : 2003-01 a 2018-04   (184 observaciones)
periodo de las tasas: 2003-02 a 2018-04   (183 observaciones)
```

### Como leer la salida

Tres detalles que rompen el codigo si se ignoran:

- la columna de dinero viene como `'M '`, **con un espacio al final**: por eso el
  `df.columns.str.strip()` va **antes** de usar `df['M']`;
- `MMYY` viene como fecha; se reconstruye un `PeriodIndex` mensual para que el VAR
  y los graficos entiendan la frecuencia;
- la primera observacion se pierde con `pct_change()`: se pasa de 184 a 183 filas.

### `pct_change` vs diferencia de logaritmos

El notebook de clase usa `pct_change()`. Una alternativa habitual es
$100\,\Delta\ln$:

```python
df["infl"]   = 100 * np.log(df["IPC"]).diff()
df["crec_m"] = 100 * np.log(df["M"]).diff()
```

Las dos aproximan la misma tasa y **dan la misma conclusion**. Se verifico
corriendo todo el ejercicio por ambos caminos: los criterios eligen el mismo $p$ y
los p-values difieren en la tercera decimal (en $p=13$: $0.0467$ con `pct_change`
contra $0.0474$ con $100\Delta\ln$).

Lo unico que cambia es la **escala de los criterios de informacion**: multiplicar
las series por 100 corre el AIC en una constante, asi que los valores absolutos no
son comparables entre versiones, pero el minimo cae en el mismo $p$.

---

## 18. Chequeo previo de estacionariedad (ADF)

### Teoria

Antes de estimar el VAR hay que confirmar que las variables que entran son $I(0)$.
Si fueran $I(1)$, la ruta correcta no es un VAR en niveles sino cointegracion /
VEC.

### Codigo generico

```python
from statsmodels.tsa.stattools import adfuller

test_adf = adfuller(df['infl'], regression="ct", autolag="t-stat", regresults=True)
print(f"Estadistico ADF: {test_adf[0]:.4f}")
print(f"p-valor:         {test_adf[1]:.4f}")
print(test_adf[3].resols.summary())
```

### Salida verificada

```text
variable   regression   ADF stat   p-value   lags
infl       ct           -7.7204    0.0000      0
crec_m     ct           -3.6720    0.0243     14
crec_m     c            -3.1373    0.0239     14
```

### Como leer la salida

- **`infl` con constante y tendencia**: se rechaza fuertemente la raiz unitaria.
- **`crec_m`**: se rechaza al 5% tanto con tendencia (`ct`) como sin ella (`c`). El
  notebook prueba las dos especificaciones para mostrar que la conclusion **no
  depende** de incluir la tendencia.

Las dos tasas son $I(0)$: el VAR en tasas esta bien planteado y no hace falta ir a
un VEC.

**El ADF va antes del VAR.** Es lo que justifica trabajar en tasas y no en niveles.

---

## 19. Seleccion de rezagos

### Codigo generico

```python
model = VAR(df[["infl", "crec_m"]].dropna())
print(model.select_order(24).summary())
print(model.select_order(24).selected_orders)
```

### Salida verificada

```text
 p      AIC        BIC        FPE          HQIC
 1    -16.73    -16.61*    5.439e-08     -16.68
 2    -16.79    -16.60     5.111e-08     -16.71*
 3    -16.81    -16.54     4.987e-08     -16.70
12    -17.01    -16.05     4.102e-08     -16.62
13    -17.05*   -16.01     3.964e-08*    -16.63
22    -17.03    -15.30     4.131e-08     -16.33
24    -17.03    -15.14     4.197e-08     -16.26

selected_orders: {'aic': 13, 'bic': 1, 'hqic': 2, 'fpe': 13}
```

### Como leer la salida

Los criterios no coinciden:

$$AIC: p = 13 \qquad FPE: p = 13 \qquad BIC: p = 1 \qquad HQ: p = 2$$

BIC y HQ eligen dinamicas muy cortas porque penalizan fuerte la cantidad de
parametros: un VAR bivariado con 13 rezagos estima **52 coeficientes de
pendiente**. AIC penaliza menos y admite la dinamica larga que sugiere el
enunciado.

**En esta base el criterio optimo relevante es AIC con $p = 13$**, confirmado por
FPE.

---

## 20. Estimacion, estabilidad y residuos

### Codigo generico

El notebook estima varias especificaciones para mostrar el contraste:

```python
result_var2  = model.fit(maxlags=2, trend='ct')   # cerca de BIC/HQ
result_var3  = model.fit(maxlags=3, trend='ct')   # el que se discute en clase
result_var8  = model.fit(8)                       # sin aval de ningun criterio
result_var13 = model.fit(13)                      # AIC

print(result_var3.is_stable())
print(np.abs(result_var3.roots))

wb = result_var3.test_whiteness(nlags=12)         # autocorrelacion de residuos
print(wb)

for h in range(4, 13):
    print(h, result_var3.test_whiteness(nlags=h, adjusted=True).pvalue)
```

### Salida verificada - barrido de rezagos

Estimando **sin tendencia** y testeando en ambas direcciones:

```text
 p    estable   max|eig companion|   p-value crec_m -> infl   p-value infl -> crec_m
 1      si            0.6673               0.7739                    0.0152
 2      si            0.7931               0.6128                    0.0132
 3      si            0.8075               0.0530                    0.0050
 4      si            0.8214               0.1022                    0.0466
 5      si            0.8735               0.0823                    0.0598
 8      si            0.9432               0.1312                    0.0185
12      si            0.9799               0.0519                    0.0855
13      si            0.9844               0.0467                    0.0474
22      si            0.9940               0.0417                    0.1616
24      si            0.9954               0.2296                    0.2918
```

Con la especificacion exacta del notebook, `VAR(3)` con `trend='ct'`:

```text
Granger crec_m -> infl : F = 2.1049,  df = (3, 344),  p = 0.0993
Granger infl -> crec_m : F = 4.9883,                  p = 0.0021
is_stable() = True,   min |roots| = 1.78
```

### Salida verificada - residuos del VAR(3)

```text
nlags   p-value test_whiteness
  4        0.1831
  6        0.0460
  8        0.0717
 10        0.0251
 12        0.0003
```

### Como leer la salida

Tres lecturas:

1. **Estabilidad**: todas las especificaciones son estables, pero el maximo modulo
   de autovalor de la companion **crece con $p$** (de $0.67$ a $0.995$). Con 24
   rezagos el sistema esta al borde del circulo unitario.

2. **Residuos**: el `test_whiteness` del VAR(3) **rechaza** la hipotesis de no
   autocorrelacion a partir de 6 rezagos. Es evidencia de que 3 rezagos dejan
   dinamica sin capturar, y un argumento adicional a favor de subir $p$.

3. **Direccion inversa**: `infl -> crec_m` es significativa en casi todas las
   especificaciones, y con $p$ bajo es **mas fuerte** que la direccion que pide el
   enunciado. Hay **retroalimentacion bidireccional**, no una calle de una sola
   mano.

### Idea para recordar

Para concluir Granger no alcanza con el p-value: hay que mostrar que el VAR es
estable, y conviene mirar si los residuos quedaron blancos.

---

## 21. Resultado y conclusion

### El resultado

Con $p = 13$, elegido por AIC y FPE:

```text
Granger crec_m -> infl : F = 1.7739,  df = (13, 286),  p-value = 0.0467
VAR estable            : is_stable() = True
max |eig companion|    : 0.9844 < 1
observaciones usadas   : 170
```

Como $0.0467 < 0.10$, **se rechaza $H_0$** al nivel de significancia pedido.

### Codigo generico

```python
res = model.fit(13)

print(res.is_stable())

test = res.test_causality(caused="infl", causing=["crec_m"], kind="f")
print(test.summary())
```

### Conclusion

Usando todo el periodo disponible, tasas mensuales, seleccion de rezagos por AIC
($p=13$), VAR estable y nivel de significancia del 10%: **si hay evidencia de que
el crecimiento de la base monetaria causa en sentido de Granger a la inflacion.**

La cantidad de meses a tomar es **13**.

### Matices que conviene declarar

- **La conclusion depende del criterio de rezagos.** AIC y FPE eligen 13 y
  permiten rechazar; BIC elige 1 y HQ elige 2, y con esos $p$ el p-value es $0.77$
  y $0.61$: no se rechaza nada. El enunciado anticipa esto, asi que AIC es la
  eleccion defendible.
- La especificacion del notebook, `VAR(3)` con `trend='ct'`, tambien rechaza al
  10% ($p=0.0993$), **pero al filo y sin respaldo de ningun criterio de
  seleccion**. Sirve para la discusion de clase, no como respuesta al enunciado,
  que exige criterio optimo.
- **Con $p=24$ el p-value vuelve a $0.23$**: agregar rezagos indefinidamente no
  "mejora" el resultado, lo destruye por perdida de grados de libertad. No hay que
  buscar el $p$ que da el p-value mas lindo.
- La causalidad tambien corre en sentido inverso (`infl -> crec_m`, $p=0.0474$ en
  $p=13$). Es un sistema con retroalimentacion.
- Es **causalidad predictiva, no estructural**.

### Respuesta corta de examen

**AIC elige 13 rezagos, el VAR(13) es estable, el p-value de Granger es
$0.0467 < 0.10$, entonces si hay causalidad en sentido de Granger.**

---

## 22. Como redactar la respuesta

```text
Trabajo con las tasas mensuales, definidas como variacion porcentual del IPC y de
la base monetaria: infl_t = IPC_t/IPC_{t-1} - 1 y crec_m_t = M_t/M_{t-1} - 1.
El periodo es 2003-02 a 2018-04, 183 observaciones.

Primero verifico con ADF que ambas tasas sean I(0), para justificar el VAR en
tasas y no un VEC. Se rechaza la raiz unitaria en las dos series al 5%.

Estimo el VAR sobre todo el periodo disponible y selecciono la cantidad de rezagos
con criterios de informacion. AIC y FPE minimizan en p=13; BIC elige 1 y HQ elige
2. Uso AIC porque el enunciado sugiere que con pocos rezagos no aparece causalidad
y porque el test de autocorrelacion de residuos rechaza la hipotesis de ruido
blanco en las especificaciones cortas.

Verifico que el VAR(13) sea estable: is_stable() da True y el maximo modulo de los
autovalores de la matriz companion es 0.9844, menor que 1.

Luego testeo causalidad de Granger desde crec_m hacia infl:
H0: los 13 coeficientes de los rezagos de crec_m en la ecuacion de infl son cero.
El estadistico F es 1.7739 con (13, 286) grados de libertad y p-value 0.0467.

Como 0.0467 < 0.10, rechazo H0 al nivel de significancia pedido. Encuentro
evidencia de que el crecimiento de la base monetaria causa en sentido de Granger a
la inflacion, tomando 13 meses de rezagos.

Aclaro dos cosas: (i) esta es causalidad predictiva, no estructural; (ii) el test
en la direccion inversa tambien rechaza (p = 0.0474), de modo que el sistema
presenta retroalimentacion.
```

---

## 23. Errores frecuentes

| Error | Por que pasa | Como se evita |
|---|---|---|
| `KeyError: 'M'` | la columna es `'M '` con espacio | `df.columns = df.columns.str.strip()` primero |
| Leer `roots` como autovalores | `statsmodels` reporta las raices del polinomio | usar `is_stable()`; en `roots` la condicion es modulo $>1$ |
| Invertir la direccion del test | `caused` vs `causing` se confunden | la direccion es `causing -> caused` |
| Elegir $p$ mirando el p-value | tentacion de buscar el resultado lindo | elegir $p$ con AIC/BIC/HQ **antes** de testear |
| Concluir solo con el p-value | el enunciado pide estabilidad | reportar `is_stable()` junto al test |
| Comparar AIC entre escalas distintas | `pct_change` vs $100\Delta\ln$ corren el AIC | comparar solo dentro de la misma transformacion |
| Correr el VAR en niveles de IPC y M | son series con tendencia | ADF primero, VAR en tasas |
| Confundir Granger con causalidad real | el nombre engana | decir siempre "en sentido de Granger" |
| Signo de los parametros AR en `ArmaProcess` | pide el polinomio caracteristico | `ar = np.r_[1, -arparams]` |
| `model.fit(maxlags=3)` como "hasta 3" | sin `ic`, estima exactamente ese orden | leer la doc o usar `model.fit(3)` |

---

## 24. Checklist de Clase 8

Al terminar deberias poder explicar:

1. Que es un VAR($p$) y como se escribe en forma matricial.
2. Como se escribe un VAR(1) con dos variables ecuacion por ecuacion.
3. Que significa que los shocks sean ruido blanco vectorial.
4. Por que los shocks pueden estar correlacionados contemporaneamente.
5. Como se interpreta cada elemento de la matriz $A$.
6. Por que los autovalores gobiernan la dinamica.
7. Que significa que un VAR sea estable y como se chequea con $p>1$.
8. Que ocurre si todos los autovalores tienen modulo menor a uno.
9. Como aparece el equilibrio de largo plazo $(I-A)\bar{\mathbf{y}} = \mathbf{m}$.
10. Por que $\mu_i = 1-\lambda_i$ para los autovalores de $\Pi$.
11. Que ocurre si hay un autovalor unitario y otro estable.
12. Por que eso abre la puerta a cointegracion.
13. Como se escribe la forma VEC y que rol juega el rango de $\Pi$.
14. Que significan $\boldsymbol\alpha$ y $\boldsymbol\beta$ en $\Pi = \boldsymbol\alpha\boldsymbol\beta'$.
15. Como resolver a mano el ejemplo $A = \begin{pmatrix}1.2 & -0.2\\ 0.6 & 0.4\end{pmatrix}$.
16. Por que el Caso 3 necesita Jordan y como aparece $I(2)$.
17. Que es y que no es causalidad de Granger.
18. Como se plantea la $H_0$ del test y por que es un test F conjunto.
19. Por que hay que elegir rezagos con criterio y que hace cada criterio.
20. Por que hay que verificar estabilidad antes de concluir.
21. Como se resuelve la practica dinero-inflacion y cual es la respuesta.
22. Diferencia entre raices AR (estacionariedad) y MA (invertibilidad).

---

## 25. Notas tecnicas

- Dependencias: `pandas`, `numpy`, `statsmodels`, `matplotlib` y `openpyxl`.
- La columna de dinero aparece como `M `, con un espacio al final.
- El notebook lee `Precios_y_Dinero.xlsx` sin ruta; en el repo esta en
  `Bases de Datos MIA103/`.
- `plt.style.use('seaborn-v0_8-darkgrid')` requiere matplotlib reciente; en
  versiones viejas el estilo se llamaba `seaborn-darkgrid`.
- La celda que usa `display(roots)` funciona en Jupyter; en un script hay que usar
  `print`.
- **`model.fit(maxlags=3, trend='ct')` no significa "hasta 3 rezagos"**: cuando se
  pasa `maxlags` sin `ic`, `statsmodels` estima exactamente ese orden.
- El notebook incluye una celda con `model.fit(8)` etiquetada como "se puede pero
  no esta avalado por ningun criterio de optimalidad": es un ejemplo de lo que
  **no** hay que hacer en la practica.
