# Clase 8 - Teoria + practica + Python

[Volver al indice general](../Res+Pra.md)

Esta guia cruza la teoria de la Clase 8 con la Ejercitacion 7. El tema central
es VAR: modelos autorregresivos vectoriales, estabilidad por autovalores,
relacion con cointegracion/VEC y causalidad de Granger.

La practica pide investigar si el crecimiento de la base monetaria causa en
sentido de Granger a la inflacion usando la base `Precios_y_Dinero.xlsx`.

El recorrido de cada tema es:

```text
microteoria -> en Python lo hacemos asi -> salida del ejemplo -> que significa -> idea para recordar
```

## Archivos que vamos a usar

| Tipo | Archivo | Para que se usa |
|---|---|---|
| Teoria | `Clases/MIA103_Clase_8_VAR_.pdf` | VAR, autovalores, estabilidad, VEC y causalidad de Granger |
| Practica | `Practicas/MIA103_Ejer_7_.pdf` | VAR entre crecimiento monetario e inflacion |
| Datos | `Bases de Datos MIA103/Precios_y_Dinero.xlsx` | IPC, dinero y dinero en pesos |

## Que usamos para cada tema

| Paso | Tema | Material |
|---:|---|---|
| 1 | Definicion de VAR(p) | PDF Clase 8 |
| 2 | VAR(1) con dos variables | PDF Clase 8 |
| 3 | Ruido blanco vectorial y matriz Omega | PDF Clase 8 |
| 4 | Autovalores, diagonalizacion y estabilidad | PDF Clase 8 |
| 5 | Caso I(0): equilibrio de largo plazo | PDF Clase 8 |
| 6 | Caso I(1): cointegracion y VEC | PDF Clase 8 |
| 7 | Caso I(2) y matriz Jordan | PDF Clase 8 |
| 8 | Causalidad de Granger | PDF Clase 8 |
| 9 | Ejercitacion 7: dinero e inflacion | Practica y base `Precios_y_Dinero.xlsx` |

---

## 1. De AR univariado a VAR

### Microresumen teorico

Hasta Clase 7 miramos procesos autorregresivos univariados, como:

```text
y_t = c + rho_1 y_{t-1} + ... + rho_p y_{t-p} + epsilon_t
```

En un VAR pasamos de una sola variable a un vector de variables:

```text
y_t = (y_1t, y_2t, ..., y_kt)'
```

Un VAR(p) es:

```text
y_t = m + A_1 y_{t-1} + A_2 y_{t-2}
      + ... + A_p y_{t-p} + epsilon_t
```

Donde:

- `y_t` es un vector `k x 1`;
- `m` es un vector de constantes `k x 1`;
- cada `A_i` es una matriz `k x k`;
- `epsilon_t` es un vector de innovaciones.

### Que significa

Cada variable depende de sus propios rezagos y de los rezagos de las demas
variables del sistema.

Un VAR no elige una variable como estrictamente exogena. Trata a todas las
variables del vector como endogenas y deja que la dinamica se exprese mediante
rezagos.

### Idea para recordar

VAR = muchas ecuaciones AR estimadas juntas, donde todas las variables pueden
depender del pasado de todas.

---

## 2. Ruido blanco vectorial

### Microresumen teorico

En el VAR:

```text
y_t = m + A_1 y_{t-1} + ... + A_p y_{t-p} + epsilon_t
```

el error `epsilon_t` es un vector de ruidos blancos:

```text
E(epsilon_t) = 0
```

y:

```text
E(epsilon_t epsilon_s') = Omega si t = s
E(epsilon_t epsilon_s') = 0     si t != s
```

`Omega` es la matriz de varianzas y covarianzas contemporaneas de los shocks.

### Que significa

Los shocks no estan correlacionados serialmente: el shock de hoy no debe estar
correlacionado con el de ayer.

Pero los shocks de distintas ecuaciones si pueden estar correlacionados en el
mismo periodo. Por ejemplo, un shock contemporaneo puede afectar al mismo tiempo
a inflacion y dinero.

### Idea para recordar

En un VAR, los errores pueden estar correlacionados contemporaneamente entre
ecuaciones, pero no deberian tener autocorrelacion serial.

---

## 3. VAR(1) con dos variables

### Microresumen teorico

El caso mas simple del PDF es `k=2` y `p=1`:

```text
y_t = m + A y_{t-1} + epsilon_t
```

En forma matricial:

```text
(y_1t)   (m_1)   (a_11  a_12) (y_1,t-1)   (epsilon_1t)
(y_2t) = (m_2) + (a_21  a_22) (y_2,t-1) + (epsilon_2t)
```

En forma de ecuaciones:

```text
y_1t = m_1 + a_11 y_1,t-1 + a_12 y_2,t-1 + epsilon_1t
y_2t = m_2 + a_21 y_1,t-1 + a_22 y_2,t-1 + epsilon_2t
```

### Como interpretar coeficientes

- `a_11`: persistencia propia de `y_1`.
- `a_12`: efecto predictivo del rezago de `y_2` sobre `y_1`.
- `a_21`: efecto predictivo del rezago de `y_1` sobre `y_2`.
- `a_22`: persistencia propia de `y_2`.

### Idea para recordar

En un VAR(1), cada ecuacion parece una regresion multiple con rezagos como
explicativas.

---

## 4. Estimacion ecuacion por ecuacion

### Microresumen teorico

Si todas las ecuaciones tienen los mismos regresores, un VAR puede estimarse por
MCO ecuacion por ecuacion.

Para dos variables y `p` rezagos, la ecuacion de `y_1` seria:

```text
y_1t = c_1
       + a_11,1 y_1,t-1 + a_12,1 y_2,t-1
       + ...
       + a_11,p y_1,t-p + a_12,p y_2,t-p
       + e_1t
```

La ecuacion de `y_2` usa los mismos regresores, pero otra variable dependiente.

### En Python con statsmodels

```python
from statsmodels.tsa.api import VAR

data = df[["inflacion", "crec_monetario"]].dropna()
modelo = VAR(data)

seleccion = modelo.select_order(maxlags=24)
print(seleccion.summary())

res = modelo.fit(22)
print(res.summary())
```

### Que significa

La parte dificil del VAR no suele ser estimarlo, sino decidir:

- que variables entran;
- si deben estar en niveles o diferencias;
- cuantos rezagos usar;
- si el sistema es estable;
- que hipotesis dinamicas se quieren testear.

### Idea para recordar

Un VAR es facil de correr y facil de sobreinterpretar. La clave esta en
estacionariedad, rezagos, estabilidad y lectura de tests.

---

## 5. Autovalores y diagonalizacion

### Microresumen teorico

En el VAR(1):

```text
y_t = m + A y_{t-1} + epsilon_t
```

la dinamica depende de la matriz `A`.

Si `A` tiene autovalores distintos, puede diagonalizarse:

```text
A = C Lambda C^{-1}
```

Definimos:

```text
z_t = C^{-1} y_t
```

Entonces:

```text
z_t = m* + Lambda z_{t-1} + eta_t
```

Como `Lambda` es diagonal:

```text
z_1t = m_1* + lambda_1 z_1,t-1 + eta_1t
z_2t = m_2* + lambda_2 z_2,t-1 + eta_2t
```

### Que significa

La diagonalizacion transforma el sistema en combinaciones lineales que se
comportan como AR(1) separados.

Cada autovalor indica la persistencia de una direccion del sistema:

- modulo menor a 1: shock transitorio;
- modulo igual a 1: raiz unitaria;
- modulo mayor a 1: comportamiento explosivo.

### Idea para recordar

En VAR, los autovalores cumplen el papel que `rho` cumplia en AR(1).

---

## 6. Caso 1: todos los autovalores menores a uno

### Microresumen teorico

Si:

```text
|lambda_1| < 1
|lambda_2| < 1
```

entonces los procesos transformados `z_t` son `I(0)`. Como:

```text
y_t = C z_t
```

tambien `y_t` es `I(0)`.

### Equilibrio de largo plazo

Tomando esperanza en:

```text
y_t = m + A y_{t-1} + epsilon_t
```

si hay media de largo plazo `ybar`:

```text
ybar = m + A ybar
```

Entonces:

```text
(I - A)ybar = m
Pi ybar = m
```

donde:

```text
Pi = I - A
```

Si `Pi` es no singular, existe una solucion unica para `ybar`.

### Que significa

El sistema tiene equilibrio de largo plazo. Los desvios respecto de ese equilibrio
son transitorios y el sistema revierte a su media.

### Idea para recordar

VAR estable: todos los autovalores dentro del circulo unitario y shocks que se
disipan.

---

## 7. Caso 2: un autovalor unitario y otro estable

### Microresumen teorico

Si:

```text
lambda_1 = 1
|lambda_2| < 1
```

entonces una direccion del sistema es random walk y otra es estacionaria.

En el PDF:

- `z_1t` es random walk con drift;
- `z_2t` es `I(0)`.

Como `y_1t` e `y_2t` son combinaciones lineales de `z_1t` y `z_2t`, ambas pueden
ser `I(1)`.

Pero existe una combinacion lineal de `y_1t` e `y_2t` que es `I(0)`:

```text
c(2) y_t = z_2t
```

### Que significa

Este es el caso de cointegracion: dos variables pueden ser no estacionarias en
niveles, pero una combinacion lineal entre ellas es estacionaria.

No tiene sentido buscar un equilibrio estatico de niveles individuales, pero si
puede existir una relacion de largo plazo entre las variables.

### Idea para recordar

Cointegracion = variables `I(1)` unidas por una combinacion lineal `I(0)`.

---

## 8. VEC: forma de correccion de errores

### Microresumen teorico

Partimos de:

```text
y_t = m + A y_{t-1} + epsilon_t
```

Restando `y_{t-1}`:

```text
Delta y_t = m - Pi y_{t-1} + epsilon_t
```

donde:

```text
Pi = I - A
```

Si `Pi` tiene rango reducido, puede escribirse como producto exterior:

```text
Pi = alpha beta'
```

Entonces:

```text
Delta y_t = m - alpha beta' y_{t-1} + epsilon_t
```

### Que significa

- `beta' y_{t-1}` mide el desvio respecto de la relacion de largo plazo.
- `alpha` mide como ajustan las variables cuando hay desequilibrio.

Esto es un Vector Error Correction Model, o VEC.

### Ejemplo del PDF

El PDF propone:

```text
y_1t = 1.2 y_1,t-1 - 0.2 y_2,t-1 + epsilon_1t
y_2t = 0.6 y_1,t-1 + 0.4 y_2,t-1 + epsilon_2t
```

La matriz es:

```text
A = [1.2  -0.2
     0.6   0.4]
```

Los autovalores son:

```text
lambda_1 = 1
lambda_2 = 0.6
```

Hay una direccion con raiz unitaria y otra estacionaria. La forma VEC queda:

```text
Delta y_1t = 0.2 y_1,t-1 - 0.2 y_2,t-1 + epsilon_1t
Delta y_2t = 0.6 y_1,t-1 - 0.6 y_2,t-1 + epsilon_2t
```

Tambien:

```text
Delta y_t = - [0.4, 1.2]' [-0.5, 0.5] y_{t-1} + epsilon_t
```

La relacion de cointegracion esta en el vector fila:

```text
[-0.5, 0.5] y_{t-1}
```

### Idea para recordar

VEC combina diferencias de corto plazo con una relacion de largo plazo en
niveles.

---

## 9. Caso 3: autovalores unitarios repetidos

### Microresumen teorico

Si:

```text
lambda_1 = 1
lambda_2 = 1
```

y no hay suficientes autovectores linealmente independientes, `A` no se puede
diagonalizar.

El PDF menciona que este caso se analiza con matriz de Jordan:

```text
P^{-1} A P = J
```

con:

```text
J = [lambda  1
     0       lambda]
```

Si `lambda = 1`, puede aparecer integracion de orden dos:

```text
z_2t es I(1)
z_1t es I(2)
```

### Que significa

Este caso es mas complejo y el curso lo presenta como posibilidad teorica. Para
el trabajo aplicado normal se suele concentrar en sistemas estables `I(0)` o en
variables `I(1)` con posible cointegracion.

### Idea para recordar

Autovalores unitarios repetidos pueden generar dinamicas mas persistentes, incluso
`I(2)`.

---

## 10. Causalidad de Granger

### Microresumen teorico

Decimos que `x_t` causa en sentido de Granger a `y_t` si los rezagos de `x_t`
ayudan a explicar `y_t`, una vez incluidos los rezagos de `y_t`.

En un VAR con dos variables:

```text
y_t = c + a_1 y_{t-1} + ... + a_p y_{t-p}
          + b_1 x_{t-1} + ... + b_p x_{t-p}
          + e_t
```

El test plantea:

```text
H0: b_1 = b_2 = ... = b_p = 0
HA: al menos un b_j != 0
```

Si se rechaza `H0`, los rezagos de `x` agregan informacion predictiva para `y`.

### Que significa

Granger es causalidad predictiva temporal. No es causalidad estructural ni prueba
un mecanismo economico profundo.

Ejemplo:

```text
crecimiento monetario causa en Granger a inflacion
```

significa que rezagos del crecimiento monetario ayudan a predecir inflacion
condicional en los rezagos de inflacion.

No significa automaticamente:

- que la politica monetaria sea el unico determinante de inflacion;
- que haya causalidad experimental;
- que el efecto sea contemporaneo;
- que no existan variables omitidas.

### Idea para recordar

Granger responde: "sirve el pasado de x para pronosticar y?".

---

## 11. Seleccion de rezagos en VAR

### Microresumen teorico

Elegir la cantidad de rezagos `p` es central.

Pocos rezagos:

```text
pueden dejar autocorrelacion residual y perder dinamica relevante
```

Muchos rezagos:

```text
consumen grados de libertad y pueden sobreajustar
```

Se usan criterios de informacion:

```text
AIC
BIC o Schwarz
HQ
```

### Como se leen

Para cada criterio se elige el `p` que minimiza el valor del criterio.

En general:

- AIC suele elegir modelos mas largos.
- BIC penaliza mas la cantidad de parametros y suele elegir menos rezagos.
- HQ queda muchas veces en un punto intermedio.

### Idea para recordar

La practica pide elegir rezagos con algun criterio optimo. Si distintos criterios
dan resultados distintos, hay que decirlo.

---

## 12. Estabilidad del VAR

### Microresumen teorico

Un VAR es estable si sus raices/autovalores relevantes quedan dentro del circulo
unitario en la representacion de companion matrix.

Intuitivamente:

```text
todos los modulos < 1 -> shocks transitorios
modulo = 1            -> raiz unitaria
modulo > 1            -> explosivo
```

### En Python con statsmodels

```python
res = modelo.fit(p)
res.is_stable()
```

Tambien puede mirarse:

```python
res.roots
```

Segun la convencion de `statsmodels`, `roots` suele reportar las raices inversas;
por eso conviene usar `is_stable()` para evitar confusiones de lectura.

### Idea para recordar

Para usar VAR en la practica de Granger, no alcanza con que el p-value de Granger
sea chico: el VAR tambien debe ser estable.

---

## 13. Ejercitacion 7 - Pregunta empirica

### Enunciado

La practica pregunta si una mayor tasa de crecimiento de la base monetaria causa
en sentido de Granger una mayor tasa de inflacion.

Pide:

- usar la base `Precios_y_Dinero.xlsx`;
- usar todo el periodo;
- decidir cuantos meses/rezagos usar con criterio optimo;
- verificar estabilidad del VAR;
- testear al 10% de significancia.

### Variables

La base tiene:

```text
MMYY
IPC
M
M_en_ARS
```

Construimos:

```text
inflacion_t = 100 * Delta ln(IPC_t)
crec_m_t    = 100 * Delta ln(M_t)
```

El periodo disponible para las tasas mensuales queda:

```text
2003-02 a 2018-04
183 observaciones
```

### Por que usamos diferencias logaritmicas

IPC y base monetaria en niveles suelen tener tendencia y no ser estacionarias.
Para un VAR estable y una lectura de Granger mas razonable, la pregunta del
enunciado ya habla de tasas:

```text
tasa de inflacion
tasa de crecimiento de base monetaria
```

Por eso se usan diferencias de logaritmos, que aproximan tasas porcentuales.

### Idea para recordar

No testeamos Granger entre niveles de IPC y dinero, sino entre tasas.

---

## 14. Preparacion de datos en Python

### En Python

Con dependencias completas:

```python
import numpy as np
import pandas as pd

df = pd.read_excel("Bases de Datos MIA103/Precios_y_Dinero.xlsx")

df["date"] = pd.to_datetime(df["MMYY"], unit="D", origin="1899-12-30")
df = df.set_index("date")

df["inflacion"] = 100 * np.log(df["IPC"]).diff()
df["crec_m"] = 100 * np.log(df["M "]).diff()

data = df[["inflacion", "crec_m"]].dropna()
```

### Que significa

La primera observacion se pierde porque una diferencia necesita el periodo
anterior.

Multiplicar por 100 solo cambia escala: permite leer los coeficientes y tasas en
porcentajes aproximados.

### Idea para recordar

La transformacion importante es `Delta log`; el `*100` es solo escala.

---

## 15. Seleccion de rezagos y resultado

### Resultados obtenidos

Se estimaron VAR con rezagos de 1 a 24 sobre:

```text
inflacion
crecimiento monetario
```

Los criterios seleccionaron:

```text
AIC: p = 22
BIC: p = 1
HQ:  p = 2
```

Tabla resumida de los rezagos mas relevantes:

```text
p    AIC      BIC      HQ       max autovalor   estable   p-value Granger M -> inflacion
1    1.5611   1.6667   1.6039   0.6695     si        0.7803
2    1.5129   1.6896   1.5846   0.7934     si        0.6093
3    1.4963   1.7447   1.5970   0.8096     si        0.0495
4    1.4971   1.8177   1.6271   0.8244     si        0.0985
5    1.4833   1.8765   1.6428   0.8753     si        0.0857
12   1.3196   2.2383   1.6924   0.9790     si        0.0572
22   1.3077   3.0302   2.0071   0.9935     si        0.0484
24   1.3182   3.2097   2.0863   0.9953     si        0.2318
```

### Que significa

Con pocos rezagos, como `p=1` o `p=2`, no aparece evidencia de causalidad de
Granger desde crecimiento monetario hacia inflacion.

Pero usando AIC, el criterio optimo elige `p=22`. Con ese VAR:

```text
p-value Granger = 0.0484
```

Como:

```text
0.0484 < 0.10
```

se rechaza la hipotesis nula al 10%.

Ademas, el VAR con `p=22` es estable:

```text
maximo modulo de autovalor de la companion matrix = 0.9935 < 1
```

### Conclusion de la practica

Usando diferencias logaritmicas, todo el periodo disponible, seleccion de rezagos
por AIC y nivel de significancia del 10%, si hay evidencia de que el crecimiento
de la base monetaria causa en sentido de Granger a la inflacion.

La cantidad de rezagos elegida es:

```text
22 meses
```

### Matiz importante

La conclusion depende del criterio de rezagos:

- AIC elige 22 rezagos y permite rechazar al 10%.
- BIC elige 1 rezago y no permite rechazar.
- HQ elige 2 rezagos y no permite rechazar.

Como el enunciado sugiere que con pocos rezagos no aparecia causalidad y que
podria requerirse mas historia, AIC es una eleccion defendible porque admite una
dinamica mas larga.

### Idea para recordar

Si el examen pide "mostrar si es posible", una respuesta bien defendida es:
con AIC, 22 rezagos, VAR estable y p-value menor al 10%, si se encuentra
causalidad de Granger.

---

## 16. Test de Granger en Python

### Con statsmodels

```python
from statsmodels.tsa.api import VAR

modelo = VAR(data)
res = modelo.fit(22)

test = res.test_causality(
    caused="inflacion",
    causing=["crec_m"],
    kind="f"
)

print(test.summary())
```

La hipotesis es:

```text
H0: los 22 coeficientes de crec_m rezagado en la ecuacion de inflacion son cero
HA: al menos uno es distinto de cero
```

### Lectura

Si el p-value es menor que `0.10`, rechazamos `H0`.

Eso significa que, condicional en los rezagos de inflacion, los rezagos de
crecimiento monetario agregan informacion para predecir inflacion.

### Idea para recordar

El test de Granger es un test F conjunto sobre muchos coeficientes rezagados.

---

## 17. Como redactar la respuesta de examen

Una respuesta completa podria decir:

```text
Trabajo con las tasas, definidas como diferencias logaritmicas:
inflacion_t = 100 Delta ln(IPC_t) y crec_m_t = 100 Delta ln(M_t).

Estimo un VAR sobre todo el periodo disponible. Selecciono la cantidad de rezagos
con AIC, que minimiza el criterio en p=22. Verifico que el VAR(22) sea estable,
ya que el maximo modulo de los autovalores de la companion matrix es 0.9935,
menor que 1.

Luego testeo causalidad de Granger desde crec_m hacia inflacion:
H0: todos los coeficientes de los rezagos de crec_m en la ecuacion de inflacion
son cero.

El p-value del test es 0.0484. Como es menor que 0.10, rechazo H0 al nivel de
significancia pedido. Por lo tanto, encuentro evidencia de que el crecimiento de
la base monetaria causa en sentido de Granger a la inflacion.

Aclaro que esta es causalidad predictiva, no causalidad estructural.
```

### Idea para recordar

La respuesta tiene que incluir transformacion de variables, rezagos, estabilidad,
hipotesis, p-value y conclusion.

---

## 18. Checklist de Clase 8

Al terminar esta clase deberias poder explicar:

1. Que es un VAR(p).
2. Como se escribe un VAR(1) con dos variables.
3. Que significa que los shocks sean ruido blanco vectorial.
4. Por que los shocks pueden estar correlacionados contemporaneamente.
5. Como se interpreta cada matriz `A_i`.
6. Por que los autovalores gobiernan la dinamica.
7. Que significa que un VAR sea estable.
8. Que ocurre si todos los autovalores tienen modulo menor a uno.
9. Como aparece el equilibrio de largo plazo `(I-A)ybar = m`.
10. Que ocurre si hay un autovalor unitario y otro estable.
11. Por que eso abre la puerta a cointegracion.
12. Como se escribe la forma VEC.
13. Que significan `alpha` y `beta` en `Pi = alpha beta'`.
14. Que es causalidad de Granger.
15. Que no significa causalidad de Granger.
16. Por que hay que elegir rezagos con criterio.
17. Por que hay que verificar estabilidad antes de concluir.
18. Como resolver la practica dinero-inflacion.
19. Por que usamos diferencias logaritmicas para tasas.
20. Como redactar una conclusion estadistica al 10%.

## Observaciones tecnicas antes de ejecutar

- Para correr la practica con `pandas.read_excel` se necesita `openpyxl`.
- Para estimar VAR comodamente se necesita `statsmodels`.
- La columna de dinero en la base aparece como `M `, con un espacio al final.
- La fecha `MMYY` esta guardada como fecha serial de Excel; se puede convertir
  con `origin="1899-12-30"`.
- Si se trabaja desde la raiz del repositorio, la ruta de la base es
  `Bases de Datos MIA103/Precios_y_Dinero.xlsx`.
- La conclusion empirica reportada arriba usa `IPC` y `M`, transformadas como
  diferencias logaritmicas multiplicadas por 100.
- Como BIC y HQ eligen pocos rezagos, conviene mencionar que la evidencia de
  Granger aparece al usar AIC, que selecciona una dinamica mas larga.
