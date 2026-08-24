# Clases 4 y 5 - Teoria + practica + Python

[← Volver al indice general](../Res+Pra.md)

Esta guia unifica las clases 4 y 5 porque ambas usan el mismo PDF teorico y la misma serie de notebooks. Cruza regresion multiple, notacion matricial, multicolinealidad y heterocedasticidad con la Ejercitacion 4 y las bases utilizadas en clase.

El recorrido de cada tema es:

```text
microteoria -> en Python lo hacemos asi -> salida del ejemplo -> que significa -> idea para recordar
```

## Archivos que vamos a usar

| Tipo | Archivo | Para que se usa |
|---|---|---|
| Teoria | `Clases/MIA103_Clase_4.pdf` | Regresion multiple, F, dummies, interacciones y problemas del modelo |
| Python | `Codigos/MIA103_2026_Clase_04_01_Introducción.ipynb` | Aplicacion completa a precios de casas |
| Python | `Codigos/MIA103_2026_Clase_04_02_Notación_Matricial.ipynb` | MCO matricial, varianzas y matrices de proyeccion |
| Python | `Codigos/MIA103_2026_Clase_04_03_Multicolinealidad_Heteroscedasticidad.ipynb` | Multicolinealidad, errores robustos y tests de heterocedasticidad |
| Practica | `Practicas/MIA103_Ejer_4.pdf` | Dos modelos de valuacion de casas y restricciones lineales |
| Datos | `Bases de Datos MIA103/Ejemplo_Casa.xls` | 546 casas vendidas en Windsor, Canada |
| Datos | `Bases de Datos MIA103/CEO_ejemplo_multicolinealidad.xlsx` | Ejemplo construido de multicolinealidad entre ganancias actuales y rezagadas |

`MIA103_Ejer_5_.pdf` no se incorpora a este bloque: aunque su nombre dice Ejercitacion 5, sus consignas son de ruido blanco, AR(1), shocks, ACF y PACF. Se usara junto con la Clase 6, donde corresponde por contenido.

## Que notebook usamos para cada tema

| Paso | Tema | Notebook |
|---:|---|---|
| 1 | Regresion multiple e interpretacion ceteris paribus | `04_01_Introducción` |
| 2 | Salida de `statsmodels`, tests t e intervalos | `04_01_Introducción` |
| 3 | Test F y restricciones conjuntas | `04_01_Introducción` |
| 4 | R cuadrado y R cuadrado ajustado | `04_01_Introducción` |
| 5 | Prediccion y bandas | `04_01_Introducción` |
| 6 | Variables dummy | `04_01_Introducción` |
| 7 | Interacciones | `04_01_Introducción` |
| 8 | Notacion matricial y solucion MCO | `04_02_Notación_Matricial` |
| 9 | Matrices de proyeccion | `04_02_Notación_Matricial` |
| 10 | Regresiones 1 y 2 de la practica | `04_01_Introducción` |
| 11 | Multicolinealidad perfecta y alta | `04_03_Multicolinealidad_Heteroscedasticidad` |
| 12 | Heterocedasticidad y errores robustos HC1 | `04_03_Multicolinealidad_Heteroscedasticidad` |
| 13 | Tests de White, Breusch-Pagan y Goldfeld-Quandt | `04_03_Multicolinealidad_Heteroscedasticidad` |
| 14 | WLS, GLS, FGLS y consistencia | Teoria del PDF; `04_03` aporta los diagnosticos y la correccion robusta |

## 1. Regresion lineal multiple

### Microresumen teorico

El modelo con varias variables explicativas es:

```text
y_i = beta_0 + beta_1*x_1i + ... + beta_{k-1}*x_{k-1,i} + u_i
```

El valor predicho es:

```text
y_hat_i = beta_0_hat + beta_1_hat*x_1i + ... + beta_{k-1}_hat*x_{k-1,i}
```

MCO vuelve a minimizar la suma de residuos al cuadrado, pero ahora elige simultaneamente todos los coeficientes.

### Interpretacion ceteris paribus

`beta_j_hat` mide cuanto cambia el valor esperado de `y` cuando `x_j` aumenta una unidad, manteniendo constantes las demas variables incluidas.

Esta aclaracion es esencial: en regresion multiple, una pendiente es una derivada parcial. No es la relacion bruta que se observaria ignorando las otras caracteristicas.

### Ejemplo de casas

La variable dependiente es `PRECIO`, en dolares canadienses. Entre las explicativas aparecen:

- Variables continuas: `LOTE`.
- Conteos: `CUARTOS`, `BANOS`, `PISOS`, `GARAGE`.
- Dummies: `ENTRADA`, `REC`, `SOTANO`, `CALEF`, `AIRE`, `NBHD`.

### En Python lo hacemos asi

```python
df_casa = pd.read_excel(
    'Bases de Datos MIA103/Ejemplo_Casa.xls',
    sheet_name='HPRICE',
    usecols='A:L'
)

variables = [
    'LOTE', 'CUARTOS', 'BANOS', 'PISOS', 'ENTRADA',
    'REC', 'SOTANO', 'CALEF', 'AIRE', 'GARAGE', 'NBHD'
]

X = sm.add_constant(df_casa[variables])
y = df_casa['PRECIO']
modelo = sm.OLS(y, X).fit()
```

### Idea para recordar

Cada coeficiente depende del conjunto de controles incluidos. Agregar o quitar variables puede cambiar su interpretacion y su valor.

## 2. Salida de la regresion multiple

### Salida con las 546 casas

El notebook primero estima el modelo sobre la base completa:

```text
Variable       Coeficiente    Error estandar    p-value
const          -4038.3504       3409.471          0.237
LOTE               3.5463          0.350          0.000
CUARTOS          1832.0035       1047.000          0.081
BANOS           14335.5585       1489.921          0.000
PISOS            6556.9457        925.290          0.000
ENTRADA          6687.7789       2045.246          0.001
REC              4511.2838       1899.958          0.018
SOTANO           5452.3855       1588.024          0.001
CALEF           12831.4063       3217.597          0.000
AIRE            12632.8904       1555.021          0.000
GARAGE           4244.8290        840.544          0.000
NBHD             9369.5132       1669.091          0.000

R^2 = 0.673124
R^2 ajustado = 0.666390
n = 546
```

### Ejemplos de interpretacion

- `LOTE=3.5463`: un pie cuadrado adicional de lote se asocia con aproximadamente 3.55 dolares canadienses adicionales de precio, manteniendo todo lo demas constante.
- `AIRE=12632.89`: una casa con aire acondicionado tiene un precio esperado aproximadamente 12,633 dolares mayor que una casa comparable sin aire.
- `GARAGE=4244.83`: cada lugar adicional para un auto se asocia con aproximadamente 4,245 dolares adicionales, ceteris paribus. `GARAGE` no es dummy porque puede valer 0, 1, 2 o 3.
- `CUARTOS` tiene `p=0.081`: no es individualmente significativo al 5%, aunque si lo seria al 10%.

### Precaucion

Los coeficientes describen asociaciones condicionales. No prueban que construir un garage o instalar aire cause exactamente el aumento estimado.

## 3. Ecuaciones normales, sumas de cuadrados y residuos

### Microresumen teorico

Con intercepto y varias explicativas, las condiciones de MCO implican:

```text
suma(e_i) = 0
suma(x_1i*e_i) = 0
...
suma(x_ji*e_i) = 0
```

Los residuos son ortogonales a cada columna de la matriz de diseño y tambien a los valores predichos.

La descomposicion sigue siendo:

```text
TSS = ESS + RSS
R^2 = ESS/TSS = 1 - RSS/TSS
```

En regresion multiple con intercepto:

```text
R^2 = Corr(y, y_hat)^2
```

Ya no es, en general, la correlacion cuadrada entre `y` y una unica `x`.

### Salida del ejemplo

```text
TSS = 388602785841.36
ESS = 261577714196.89
RSS = 127025071644.47
R^2 = 0.673124
s^2 = 237874666.00
s = 15423.19
```

### Que significa

- El modelo explica aproximadamente `67.31%` de la variabilidad muestral del precio.
- El desvio residual estimado es cercano a 15,423 dolares: aun controlando por los atributos, los precios individuales pueden alejarse bastante de la recta o hiperplano estimado.

### Idea para recordar

La ortogonalidad de residuos es una propiedad mecanica del ajuste. No demuestra que los errores poblacionales sean exogenos u homocedasticos.

## 4. R cuadrado ajustado

### Microresumen teorico

Agregar variables nunca aumenta RSS y, por lo tanto, nunca reduce el R cuadrado ordinario, aunque las variables nuevas sean irrelevantes.

El R cuadrado ajustado penaliza el numero de parametros:

```text
R2_ajustado = 1 - [RSS/(n-k)] / [TSS/(n-1)]
```

`k` incluye intercepto y pendientes.

### Salida del ejemplo

```text
R^2 = 0.673124
R^2 ajustado = 0.666390
```

### Que significa

La diferencia refleja la penalizacion por usar once variables explicativas. El R cuadrado ajustado puede bajar al agregar una variable que aporta poco.

### Idea para recordar

Para comparar modelos anidados con distinta cantidad de variables, el R cuadrado ajustado es mas informativo que el R cuadrado puro, aunque tampoco reemplaza criterios economicos ni validacion fuera de muestra.

## 5. Tests individuales e intervalos

### Microresumen teorico

El test individual conserva la forma:

```text
t = (beta_j_hat - beta_j,0) / SE(beta_j_hat)
```

Ahora los grados de libertad residuales son `n-k`, donde `k` es la cantidad total de parametros estimados.

### En Python

```python
modelo.pvalues
modelo.conf_int(alpha=0.05)
modelo.t_test('AIRE = 10000')
```

### Ejemplo: H0 de que AIRE vale 10000

```text
beta_AIRE_hat = 12632.89
t = 1.693
p-value = 0.091
IC 95% = [9578.18, 15687.60]
```

Al 5% no rechazamos `H0: beta_AIRE=10000`. El valor 10,000 esta dentro del intervalo del 95%.

### Intervalo para LOTE

```text
IC 95% de beta_LOTE = [2.8582, 4.2344]
```

Manteniendo constantes las demas variables, la muestra es compatible con un aumento de entre aproximadamente 2.86 y 4.23 dolares por pie cuadrado adicional.

## 6. Test F y restricciones conjuntas

### Microresumen teorico

Un test t prueba una restriccion lineal. El test F permite probar una o varias restricciones simultaneas.

```text
F = [(RRSS - URSS)/q] / [URSS/(n-k)]
```

- `RRSS`: RSS del modelo restringido por H0.
- `URSS`: RSS del modelo no restringido.
- `q`: cantidad de restricciones.
- `n-k`: grados de libertad del modelo no restringido.

Restringir coeficientes no puede mejorar el ajuste, por eso `RRSS >= URSS`. Si la perdida de ajuste es grande, rechazamos las restricciones.

### Test F conjunto del notebook

```python
modelo.f_test('CALEF = 0, AIRE = 0')
```

Salida:

```text
F = 36.8888
p-value = 9.86e-16
q = 2
gl denominador = 534
```

Rechazamos que calefaccion y aire sean conjuntamente irrelevantes.

### F global de una regresion

El F informado en el encabezado prueba:

```text
H0: todas las pendientes = 0
HA: al menos una pendiente != 0
```

El modelo restringido contiene solo intercepto. El no restringido incluye todos los atributos.

### Idea para recordar

Que una variable no sea significativa individualmente no implica que un grupo que la contiene sea conjuntamente irrelevante.

## 7. Variables dummy y categoria base

### Microresumen teorico

Una dummy toma valores 0 y 1. En un modelo:

```text
y = beta_0 + beta_1*D + u
```

- Si `D=0`, la media esperada es `beta_0`.
- Si `D=1`, es `beta_0 + beta_1`.
- `beta_1` es la diferencia respecto de la categoria base `D=0`.

Si una variable categorica tiene tres niveles y hay intercepto, incluimos solo dos dummies. La categoria omitida es la base. Incluir las tres y el intercepto generaria multicolinealidad perfecta porque sus dummies suman uno.

### Dummies de cantidad de baños

La practica elimina la unica casa con cuatro baños. Para las 545 restantes:

```python
df_filtrado = df_casa[df_casa['BANOS'] != 4].copy()

datos_dummy = pd.get_dummies(
    df_filtrado,
    columns=['BANOS'],
    drop_first=True,
    dtype=int
)
```

Se crean `BANOS_2` y `BANOS_3`; una casa con un baño tiene ambas en cero y es la categoria base.

### Salida de la regresion dummy

```text
BANOS_2 = 13481.18
BANOS_3 = 29392.54
```

Interpretaciones, ceteris paribus:

- Dos baños: aproximadamente 13,481 dolares mas que una casa de un baño.
- Tres baños: aproximadamente 29,393 dolares mas que una casa de un baño.

No debe interpretarse `BANOS_3` como diferencia frente a dos baños. Esa diferencia seria `29392.54 - 13481.18`.

## 8. Interacciones

### Microresumen teorico

Una interaccion permite que el efecto de una variable dependa del valor de otra. Por ejemplo:

```text
PRECIO = beta_0 + beta_1*LOTE + beta_2*NBHD
         + beta_3*(LOTE*NBHD) + ...
```

El efecto marginal del lote es:

```text
si NBHD=0: dPRECIO/dLOTE = beta_1
si NBHD=1: dPRECIO/dLOTE = beta_1 + beta_3
```

El coeficiente aislado de `NBHD` pasa a representar la diferencia entre barrios cuando `LOTE=0`. Si cero no es relevante, conviene centrar `LOTE` para dar una interpretacion mas util al efecto principal.

### En Python

Creacion manual:

```python
df_casa['LOTE_NBHD'] = df_casa['LOTE'] * df_casa['NBHD']
```

Con formulas:

```python
reg = smf.ols(
    'PRECIO ~ CUARTOS + LOTE * NBHD',
    data=df_casa
).fit()
```

En formulas:

- `x1:x2`: solo interaccion.
- `x1*x2`: efectos principales e interaccion.
- `x1+x2`: solo efectos principales.

### Ejemplo completo del notebook

Controlando por todos los atributos:

```text
beta_LOTE = 3.1816
beta_NBHD = 2601.53
beta_LOTE_NBHD = 1.1794
p-value de la interaccion = 0.092
```

El precio marginal de un pie cuadrado de lote se estima en:

```text
Barrio no agradable: 3.1816
Barrio agradable:    3.1816 + 1.1794 = 4.3610
```

Al 5% la diferencia marginal no es significativa; al 10% queda cerca del umbral.

### Idea para recordar

Con interacciones, los coeficientes principales no se interpretan aisladamente como efectos universales.

## 9. Notacion matricial de MCO

### Microresumen teorico

El modelo general se escribe:

```text
y = X*beta + u
```

- `y`: vector `n x 1`.
- `X`: matriz de diseño `n x k`, incluida la columna de unos.
- `beta`: vector `k x 1`.
- `u`: vector de errores `n x 1`.

La solucion MCO es:

```text
beta_hat = (X'X)^(-1) X'y
```

Existe una solucion unica si `X` tiene rango completo. Si una columna es combinacion lineal exacta de otras, `X'X` no es invertible: hay multicolinealidad perfecta.

Bajo homocedasticidad y ausencia de autocorrelacion:

```text
Var(beta_hat) = sigma^2 * (X'X)^(-1)
```

### Ejemplo del notebook

```python
X = np.array([
    [1, 2], [1, 3], [1, 1], [1, 5], [1, 9]
])
y = np.array([4, 7, 3, 9, 17])

beta = np.linalg.inv(X.T @ X) @ X.T @ y
```

Salida:

```text
beta_hat = [1.00, 1.75]
errores estandar = [0.5477, 0.1118]
y_hat = [4.50, 6.25, 2.75, 9.75, 16.75]
residuos = [-0.50, 0.75, 0.25, -0.75, 0.25]
```

El calculo manual coincide con `statsmodels`.

### Precaucion computacional

La formula con inversa es util para entender la teoria, pero en calculos numericos suele ser mas estable resolver el sistema con `np.linalg.solve` o usar las rutinas especializadas de `statsmodels`.

## 10. Matrices de proyeccion

### Microresumen teorico

La matriz:

```text
P = X(X'X)^(-1)X'
```

proyecta `y` sobre el espacio generado por las columnas de `X`:

```text
y_hat = P*y
```

La matriz residual es:

```text
M = I - P
e = M*y
```

Ambas son idempotentes:

```text
P*P = P
M*M = M
```

### En Python

```python
P = X @ np.linalg.inv(X.T @ X) @ X.T
M = np.eye(X.shape[0]) - P

np.allclose(P @ P, P)  # True
np.allclose(M @ y, modelo.resid)  # True
```

### Que significa

MCO separa geometricamente `y` en dos partes ortogonales: la proyeccion explicada por `X` y el residuo que queda fuera de ese espacio.

## 11. Practica 4 - Regresion 1

La practica elimina la unica casa con cuatro baños y trabaja con 545 observaciones.

### En Python reproducimos la regresion asi

```python
casas = pd.read_excel(
    'Bases de Datos MIA103/Ejemplo_Casa.xls',
    sheet_name='HPRICE',
    usecols='A:L'
)
casas = casas[casas['BANOS'] != 4].copy()

y = casas['PRECIO']
X = sm.add_constant(casas.drop(columns='PRECIO'))
reg1 = sm.OLS(y, X).fit()
```

### Salida principal

```text
R^2 = 0.664891
R^2 ajustado = 0.657975
F = 96.1389
p-value F = 7.67e-119
n = 545

GARAGE = 4139.8173
```

### a. Interpretacion de GARAGE

Un espacio adicional de garage se asocia con un aumento de aproximadamente 4,140 dolares canadienses en el precio esperado, manteniendo constantes los demas atributos.

### b. Test F global

```text
H0: beta_LOTE = beta_CUARTOS = ... = beta_NBHD = 0
HA: al menos una pendiente es distinta de cero
```

El modelo restringido solo predice el precio medio mediante un intercepto. El no restringido usa los once atributos. Como el p-value es practicamente cero, rechazamos H0: los atributos son conjuntamente informativos.

### c. ¿Hay evidencia de multicolinealidad?

La salida no muestra evidencia fuerte por si sola:

- Casi todas las variables tienen estadisticos t altos.
- `CUARTOS` es la unica cerca de no ser significativa al 5%.
- El F global es alto, pero ese F no es por si solo un diagnostico de multicolinealidad.

Para afirmarlo deberiamos inspeccionar correlaciones entre explicativas, VIF o tests conjuntos de grupos sospechosos. El numero de condicion alto tambien puede estar influido por la escala de `LOTE`, por lo que tampoco prueba el problema por si solo.

### d. Precio esperado de la casa indicada

La casa tiene:

```text
LOTE=5100, CUARTOS=3, BANOS=2, PISOS=2,
ENTRADA=1, REC=1, SOTANO=0, CALEF=1,
AIRE=0, GARAGE=0, NBHD=1
```

El valor se obtiene multiplicando cada atributo por su coeficiente y sumando el intercepto:

```python
nueva = pd.DataFrame([{
    'const': 1, 'LOTE': 5100, 'CUARTOS': 3,
    'BANOS': 2, 'PISOS': 2, 'ENTRADA': 1,
    'REC': 1, 'SOTANO': 0, 'CALEF': 1,
    'AIRE': 0, 'GARAGE': 0, 'NBHD': 1
}])

precio_estimado = reg1.predict(nueva)
```

Salida aproximada:

```text
94697.65 dolares canadienses
```

Es un valor esperado condicional, no una garantia sobre el precio de venta individual.

## 12. Practica 4 - Regresion 2 con dummies de baños

Se reemplaza `BANOS` por `BANOS_2` y `BANOS_3`, dejando un baño como categoria base.

### Salida principal

```text
LOTE = 3.526753, SE = 0.350519
BANOS_2 = 13481.18
BANOS_3 = 29392.54
R^2 = 0.665005
R^2 ajustado = 0.657449
```

### e. Interpretacion de DB3

Manteniendo constantes los demas atributos, una casa con tres baños vale en promedio aproximadamente 29,393 dolares mas que una casa comparable con un baño, que es la categoria omitida.

### f. Intervalo del 95% para LOTE

Usando la aproximacion normal solicitada:

```text
3.526753 +/- 1.96*0.350519
IC aproximado = [2.8397, 4.2138]
```

Con la t exacta y `statsmodels`, el intervalo es aproximadamente `[2.838, 4.215]`. La diferencia es minima por el gran tamaño muestral.

### g. Test de H0: beta_DB3 = 2*beta_DB2

Reescribimos la restriccion:

```text
H0: beta_DB3 - 2*beta_DB2 = 0
```

En Python:

```python
reg2.f_test('BANOS_3 = 2 * BANOS_2')
```

Salida:

```text
F = 0.181513
p-value = 0.670249
gl numerador = 1
gl denominador = 532
```

No rechazamos H0 al 5%. Los datos son compatibles con que el premio de pasar de un baño a tres sea el doble del premio de pasar de uno a dos.

La intuicion es contrastar una estructura lineal en la cantidad de baños: si cada baño adicional aportara el mismo monto, el efecto de tres frente a uno seria dos veces el efecto de dos frente a uno.

No rechazar no demuestra que la igualdad sea exactamente verdadera; indica que la muestra no detecta una diferencia estadisticamente significativa respecto de esa restriccion.

## 13. Prediccion y bandas en regresion multiple

### En Python

```python
pred = modelo.get_prediction(nuevos_valores)
tabla = pred.summary_frame(alpha=0.05)
```

Para los atributos medios de la muestra, el notebook obtiene:

```text
Prediccion media = 68121.60
IC de la media = [66824.98, 69418.21]
Intervalo de prediccion = [37796.31, 98446.89]
```

La banda de prediccion es mucho mas amplia porque agrega la variabilidad individual del error a la incertidumbre sobre la media condicional.

---

# Segunda parte - Multicolinealidad y heterocedasticidad

Esta segunda parte completa el mismo PDF con el notebook `04_03`. El objetivo ya no es solamente estimar el modelo, sino comprobar que las variables explicativas permiten identificar los efectos y que la inferencia utiliza errores estandar adecuados.

## 14. MCO con dos regresores: de donde sale la multicolinealidad

### Microresumen teorico

Para el modelo:

```text
y_i = beta_0 + beta_1*x_1i + beta_2*x_2i + u_i
```

definimos las sumas centradas:

```text
S_11 = suma[(x_1i - x_1_prom)^2]
S_22 = suma[(x_2i - x_2_prom)^2]
S_12 = suma[(x_1i - x_1_prom)(x_2i - x_2_prom)]
S_y1 = suma[(y_i - y_prom)(x_1i - x_1_prom)]
S_y2 = suma[(y_i - y_prom)(x_2i - x_2_prom)]
```

Las pendientes MCO pueden escribirse como:

```text
beta_1_hat = (S_y1*S_22 - S_y2*S_12) / (S_11*S_22 - S_12^2)
beta_2_hat = (S_y2*S_11 - S_y1*S_12) / (S_11*S_22 - S_12^2)
beta_0_hat = y_prom - beta_1_hat*x_1_prom - beta_2_hat*x_2_prom
```

El denominador comun es:

```text
S_11*S_22 - S_12^2 = S_11*S_22*(1-r_12^2)
```

Si `|r_12|=1`, el denominador es cero: existe multicolinealidad perfecta y no hay una solucion unica. Si `|r_12|` esta cerca de uno, el denominador se vuelve pequeno y las pendientes pueden estimarse, pero con mucha incertidumbre.

### Varianza de las pendientes

Bajo los supuestos clasicos:

```text
Var(beta_1_hat | X) = sigma^2 / [S_11*(1-r_12^2)]
Var(beta_2_hat | X) = sigma^2 / [S_22*(1-r_12^2)]
```

El factor `1/(1-r_12^2)` muestra exactamente por que la correlacion entre regresores infla los errores estandar.

### Idea para recordar

La multicolinealidad es un problema de informacion contenida en `X`, no de correlacion entre `X` y el error. La multicolinealidad alta no sesga MCO: dificulta separar efectos individuales y reduce su precision.

## 15. Multicolinealidad: ejemplo de los CEO

### Que hace el notebook

La base contiene:

- `Comp`: compensacion del CEO.
- `Gan`: ganancias actuales.
- `Gan_10`: una version casi redundante de ganancias.

Se estima primero:

```python
X = sm.add_constant(df_ceo[['Gan', 'Gan_10']])
reg_multi = sm.OLS(df_ceo['Comp'], X).fit()
```

### Salida con ambas variables

```text
n = 70
R^2 = 0.436
R^2 ajustado = 0.419
F global = 25.9223
p-value F = 4.59e-09

              coef       SE       t       p-value
const       0.6558    0.166    3.95       0.000
Gan        -0.0131    0.031   -0.43       0.669
Gan_10      0.1396    0.305    0.46       0.649
```

Los dos tests t individuales dan p-values altos, pero el test conjunto produce:

```text
H0: beta_Gan = beta_Gan_10 = 0
F = 25.9223
p-value = 4.59e-09
```

Se rechaza que ambas sean conjuntamente irrelevantes. El modelo capta informacion sobre la compensacion, pero la similitud entre los regresores impide adjudicarla con precision a uno u otro.

### Que ocurre al quitar `Gan_10`

```python
X_reducida = sm.add_constant(df_ceo[['Gan']])
reg_reducida = sm.OLS(df_ceo['Comp'], X_reducida).fit()
```

Salida relevante:

```text
beta_Gan_hat = 0.0008
t = 7.228
p-value < 0.001
R^2 = 0.434
```

El ajuste casi no cambia (`0.436` a `0.434`), pero `Gan` recupera mucha significatividad. La segunda variable agregaba muy poca informacion independiente.

### Como se interpreta correctamente

La combinacion de F conjunto significativo, t individuales bajos, coeficientes inestables y regresores casi duplicados es coherente con multicolinealidad en este ejemplo. Sin embargo, un R cuadrado alto y t bajos no la demuestran por si solos; conviene revisar correlaciones, VIF, numero de condicion y el sentido economico de las variables.

### Que podemos hacer

- Reunir mas observaciones con variacion independiente.
- Eliminar una variable redundante si la teoria lo permite.
- Combinar variables que midan el mismo concepto.
- Mantenerlas si el interes es predecir y la prediccion es estable, aceptando que los efectos individuales seran imprecisos.

No corresponde eliminar variables automaticamente solo para obtener p-values pequenos.

## 16. Supuestos de Gauss-Markov y estimacion de la varianza

### Microresumen teorico

En forma matricial, los supuestos centrales son:

```text
y = X*beta + u
E(u | X) = 0
Var(u | X) = sigma^2*I
X tiene rango completo
```

Con ellos, MCO es MELI o BLUE: el mejor estimador lineal e insesgado, donde "mejor" significa menor varianza dentro de esa clase.

La varianza desconocida se estima mediante:

```text
s^2 = RSS/(n-k)
Var_hat(beta_hat | X) = s^2*(X'X)^(-1)
```

`k` es la cantidad total de parametros, incluido el intercepto. Dividir por `n-k` corrige los grados de libertad usados al estimar las pendientes.

### Idea para recordar

Gauss-Markov no exige normalidad para que MCO sea BLUE. La normalidad se utiliza para obtener tests t y F exactos en muestras finitas; con muestras grandes suele recurrirse a resultados asintoticos.

## 17. Heterocedasticidad

### Microresumen teorico

La homocedasticidad exige una varianza condicional constante:

```text
Var(u_i | X) = sigma^2
```

Hay heterocedasticidad cuando cambia entre observaciones:

```text
Var(u_i | X) = sigma_i^2
```

En datos de casas, por ejemplo, los precios de inmuebles grandes o caros pueden presentar dispersiones mayores que los de inmuebles pequenos.

### Consecuencias

Si sigue cumpliendose `E(u|X)=0`:

- Los coeficientes MCO continúan siendo insesgados y, bajo condiciones regulares, consistentes.
- MCO deja de ser eficiente: ya no es BLUE.
- La formula convencional `s^2*(X'X)^(-1)` es incorrecta.
- Los errores estandar, tests t, tests F e intervalos convencionales pueden resultar engañosos.

La heterocedasticidad no cambia mecanicamente los coeficientes MCO de una regresion ya estimada; cambia la forma correcta de medir su incertidumbre.

### Diagnostico grafico

Un primer paso es graficar residuos o residuos cuadrados contra valores ajustados y variables sospechosas. Un patron de abanico sugiere varianza creciente, aunque el grafico no reemplaza un test formal.

## 18. Errores estandar robustos HC1

### En Python lo hacemos asi

```python
modelo_robusto = modelo.get_robustcov_results(cov_type='HC1')
print(modelo_robusto.summary())
```

Tambien puede pedirse desde el ajuste:

```python
modelo_robusto = sm.OLS(y, X).fit(cov_type='HC1')
```

### Que muestra la salida de casas

Los coeficientes son exactamente los mismos que en MCO ordinario, pero cambian los errores estandar y, por lo tanto, los estadisticos t, p-values e intervalos. Algunos ejemplos:

```text
Variable     Coeficiente     SE robusto HC1      t robusto
LOTE             3.5463            0.394            9.004
BANOS        14335.5585         1899.664            7.546
REC            4511.2838         2144.416            2.104
CALEF         12831.4063         4242.979            3.024
```

`REC` sigue siendo significativo al 5% (`p` cercano a `0.036`) y `CALEF` al 1% (`p` cercano a `0.003`), pero la evidencia es menor que con los errores convencionales.

### Que significa

HC1 conserva la estimacion MCO y corrige la matriz de covarianzas de forma robusta a heterocedasticidad. Es una correccion para la inferencia; no vuelve homocedasticos a los datos ni hace que MCO sea eficiente.

### Idea para recordar

Si no conocemos la forma de la heterocedasticidad y nos interesa inferir, los errores robustos suelen ser la solucion practica. Si conocemos o podemos modelar bien la varianza, WLS/GLS puede ademas mejorar la eficiencia.

## 19. White, Breusch-Pagan y Goldfeld-Quandt

Los tres tests parten de:

```text
H0: homocedasticidad
HA: heterocedasticidad
```

Por eso, un p-value pequeno lleva a rechazar varianza constante.

### 19.1 Test de White

White utiliza una regresion auxiliar de los residuos al cuadrado sobre las explicativas, sus cuadrados y productos cruzados. Bajo `H0`:

```text
LM = n*R_aux^2  ->  chi-cuadrado(q)
```

No obliga a elegir de antemano una forma concreta para la varianza, pero puede consumir muchos grados de libertad cuando hay muchos regresores.

En Python:

```python
from statsmodels.stats.diagnostic import het_white

lm_white, p_white, f_white, p_f_white = het_white(
    modelo.resid,
    modelo.model.exog
)
```

Salida del notebook:

```text
LM de White = 168.2793
p-value = 7.14e-10
```

Se rechaza homocedasticidad con claridad.

### 19.2 Test de Breusch-Pagan

Breusch-Pagan relaciona los residuos cuadrados con un conjunto de variables que se supone puede explicar la varianza. Es mas parsimonioso que White, pero requiere especificar esa relacion auxiliar.

En Python:

```python
from statsmodels.stats.diagnostic import het_breuschpagan

lm_bp, p_bp, f_bp, p_f_bp = het_breuschpagan(
    modelo.resid,
    modelo.model.exog
)
```

Salida:

```text
LM de Breusch-Pagan = 61.9526
p-value = 4.01e-09
```

Tambien se rechaza homocedasticidad.

### 19.3 Test de Goldfeld-Quandt

Goldfeld-Quandt:

1. Ordena las observaciones por una variable sospechosa.
2. Elimina una fraccion central.
3. Estima regresiones en los grupos de valores bajos y altos.
4. Compara sus RSS ajustados por grados de libertad mediante un estadistico F.

En el notebook se ordena por `LOTE`, se elimina el 20% central y se prueba si la varianza aumenta:

```python
from statsmodels.stats.diagnostic import het_goldfeldquandt

gq = het_goldfeldquandt(
    y,
    X,
    idx=indice_de_lote,
    drop=0.20,
    alternative='increasing'
)
```

Salida:

```text
F = 2.3853
p-value = 5.67e-09
alternativa = increasing
```

La dispersion residual es significativamente mayor en el grupo con lotes grandes.

### Lectura conjunta

White, Breusch-Pagan y Goldfeld-Quandt coinciden en rechazar homocedasticidad en el ejemplo de casas. No son tres estimaciones diferentes del modelo: son diagnosticos con construcciones y alternativas distintas.

## 20. WLS, GLS y FGLS

### Microresumen teorico

Si conocemos la varianza de cada observacion, podemos transformar el modelo dividiendo por su desvio:

```text
y_i/sigma_i = beta_0*(1/sigma_i) + beta_1*(x_1i/sigma_i) + ... + u_i/sigma_i
```

El error transformado tiene varianza uno. Esto equivale a minimos cuadrados ponderados:

```text
minimizar suma[w_i*u_i^2]
w_i = 1/sigma_i^2
```

Las observaciones con mayor varianza reciben menor peso.

- `WLS`: MCO ponderado cuando se proporcionan los pesos.
- `GLS`: admite una matriz general conocida de varianzas y covarianzas `Omega`.
- `FGLS`: estima primero `Omega` o los pesos y despues aplica GLS; por eso es "factible".

### En Python, si conocemos o estimamos los pesos

```python
modelo_wls = sm.WLS(y, X, weights=1/varianza_estimada).fit()
```

### Eleccion practica

- Errores robustos: coeficientes MCO iguales, inferencia corregida y pocas exigencias sobre la forma de la varianza.
- WLS/FGLS: coeficientes y pesos pueden cambiar; puede ganar eficiencia si el modelo de varianza esta bien especificado.
- Pesos incorrectos pueden empeorar el resultado, por lo que no conviene inventarlos solo porque un test rechazo homocedasticidad.

## 21. Consistencia

### Microresumen teorico

Un estimador es consistente si se aproxima al verdadero parametro cuando aumenta el tamano muestral:

```text
plim(beta_hat) = beta
```

En regresion, una forma intuitiva de verlo es:

```text
beta_hat = beta + (X'X)^(-1)X'u
```

Dividiendo por `n`, necesitamos que:

- La variacion muestral de los regresores converja a una matriz finita e invertible.
- La covarianza muestral entre regresores y errores converja a cero.

Entonces el segundo termino desaparece en probabilidad y `beta_hat` converge a `beta`.

### Consistencia versus insesgamiento

- Insesgamiento es una propiedad de muestra finita: `E(beta_hat)=beta`.
- Consistencia es una propiedad asintotica: el error de estimacion desaparece cuando `n` crece.

Un estimador puede ser sesgado en muestras pequenas y consistente. Con heterocedasticidad y exogeneidad, MCO puede seguir siendo insesgado y consistente, aunque los errores estandar clasicos sean incorrectos.

## Cierre conjunto de las Clases 4 y 5

Al terminar esta clase deberiamos poder explicar:

1. Como se interpreta una pendiente ceteris paribus.
2. Como cambian grados de libertad y errores estandar en regresion multiple.
3. Por que R cuadrado siempre sube al agregar variables y para que sirve el ajustado.
4. La diferencia entre un test t individual y un test F conjunto.
5. Como interpretar una dummy respecto de su categoria base.
6. Por que no debemos incluir todas las dummies junto con un intercepto.
7. Como cambia la interpretacion cuando existe una interaccion.
8. La solucion matricial de MCO y el requisito de rango completo.
9. El significado geometrico de las matrices `P` y `M`.
10. Como reproducir e interpretar las dos regresiones de la practica.
11. La diferencia entre multicolinealidad perfecta y multicolinealidad alta.
12. Por que la multicolinealidad aumenta errores estandar sin sesgar MCO.
13. Como leer el ejemplo de los CEO: F conjunto significativo, t individuales bajos y ajuste casi igual al quitar una variable redundante.
14. Que consecuencias tiene la heterocedasticidad para coeficientes, eficiencia e inferencia.
15. Que corrigen los errores robustos HC1 y que no corrigen.
16. Como se construyen e interpretan White, Breusch-Pagan y Goldfeld-Quandt.
17. La diferencia entre errores robustos, WLS, GLS y FGLS.
18. La diferencia entre insesgamiento y consistencia.

## Observaciones tecnicas antes de ejecutar

- Los notebooks buscan `Ejemplo_Casa.xls` en el directorio actual. Desde la raiz debe usarse `Bases de Datos MIA103/Ejemplo_Casa.xls`.
- La base tiene 546 casas, pero la practica usa 545 porque elimina la unica observacion con cuatro baños.
- Los resultados iniciales del notebook con 546 observaciones no deben confundirse con las Regresiones 1 y 2 del enunciado, que usan 545.
- Las clases 4 y 5 forman aqui un unico bloque porque comparten `MIA103_Clase_4.pdf` y los tres notebooks numerados `04_01`, `04_02` y `04_03`.
- `MIA103_Ejer_5_.pdf` se reserva para la Clase 6: su contenido es ruido blanco, AR(1), shocks, ACF y PACF, no regresion multiple.
- Un numero de condicion alto puede provenir de escalas muy diferentes entre variables. No debe interpretarse automaticamente como prueba de multicolinealidad.
