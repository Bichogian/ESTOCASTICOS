# Clase 3 - Teoria + practica + Python

[← Volver al indice general](../Res+Pra.md)

Esta guia cruza la teoria de regresion lineal simple con los tres notebooks de Clase 3, la Ejercitacion 3 y las bases de IBM y compensaciones a CEOs.

El recorrido de cada tema es:

```text
microteoria -> en Python lo hacemos asi -> salida del ejemplo -> que significa -> idea para recordar
```

## Archivos que vamos a usar

| Tipo | Archivo | Para que se usa |
|---|---|---|
| Teoria | `Clases/MIA103_Clase_3.pdf` | Modelo lineal, MCO, propiedades, supuestos e inferencia |
| Python | `Codigos/MIA103_2026_Clase_03.ipynb` | Regresion simulada con parametros conocidos |
| Python | `Codigos/MIA103_2026_Clase_03_Ejercicios.ipynb` | Resolucion de los tres ejercicios de la practica |
| Python | `Codigos/MIA103_2026_Clase_03_profundización.ipynb` | Sumas de cuadrados, residuos, predicciones y bandas |
| Practica | `Practicas/MIA103_Ejer_3.pdf` | Beta financiero y regresion de compensacion a CEOs |
| Datos | `Bases de Datos MIA103/ibm.xlsx` | IBM, S&P 500 y tasa libre de riesgo |
| Datos | `Bases de Datos MIA103/ceo.xlsx` | Ganancias empresariales y compensaciones a CEOs |

## Que notebook usamos para cada tema

| Paso | Tema | Notebook |
|---:|---|---|
| 1 | Modelo poblacional, error y residuo | `MIA103_2026_Clase_03.ipynb` |
| 2 | Estimacion por MCO con `statsmodels` | `MIA103_2026_Clase_03.ipynb` |
| 3 | Sumas de cuadrados y R cuadrado | `MIA103_2026_Clase_03_profundización.ipynb` |
| 4 | Propiedades de los residuos | `MIA103_2026_Clase_03_profundización.ipynb` |
| 5 | Varianza residual y errores estandar | `MIA103_2026_Clase_03_profundización.ipynb` |
| 6 | Tests t, p-values e intervalos | `MIA103_2026_Clase_03_Ejercicios.ipynb` |
| 7 | Beta financiero de IBM | `MIA103_2026_Clase_03_Ejercicios.ipynb` |
| 8 | Ganancias y compensacion a CEOs | `MIA103_2026_Clase_03_Ejercicios.ipynb` y `profundización` |
| 9 | Prediccion, banda de confianza y banda de prediccion | `MIA103_2026_Clase_03_profundización.ipynb` |

## 1. Modelo de regresion lineal simple

### Microresumen teorico

El modelo poblacional es:

```text
y_i = alpha + beta*x_i + u_i
```

- `y_i`: variable que queremos explicar.
- `x_i`: variable explicativa.
- `alpha`: intercepto poblacional.
- `beta`: pendiente poblacional.
- `u_i`: error poblacional no observable.

La esperanza condicional modelada es:

```text
E(y_i | x_i) = alpha + beta*x_i
```

`beta` mide cuanto cambia en promedio `y` cuando `x` aumenta una unidad. Es una asociacion condicional dentro del modelo; no demuestra causalidad por si sola.

### Error frente a residuo

El error poblacional es:

```text
u_i = y_i - E(y_i | x_i)
```

No se observa porque tampoco conocemos la recta poblacional.

Luego de estimar la recta obtenemos:

```text
y_hat_i = alpha_hat + beta_hat*x_i
e_i = y_i - y_hat_i
```

`e_i` es el residuo observable de la regresion. Error y residuo no son sinonimos exactos.

### Ejemplo simulado de la clase

El primer notebook genera datos con parametros conocidos:

```python
np.random.seed(42)
n = 150

alpha = 0.05
beta = 1.5

x = np.random.normal(loc=1.0, scale=0.5, size=n)
u = np.random.normal(loc=0.0, scale=0.25, size=n)
y = alpha + beta * x + u
```

### Que significa este ejemplo

Como nosotros generamos los datos, sabemos que la recta verdadera tiene intercepto `0.05` y pendiente `1.5`. Esto permite comprobar si MCO produce estimaciones razonablemente cercanas cuando observa solo `x` e `y`.

### Idea para recordar

Los parametros poblacionales son numeros fijos desconocidos. Los estimadores cambian de una muestra a otra.

## 2. Minimos Cuadrados Ordinarios

### Microresumen teorico

MCO elige `alpha_hat` y `beta_hat` para minimizar la suma de residuos al cuadrado:

```text
RSS = suma de (y_i - alpha_hat - beta_hat*x_i)^2
```

Los residuos se elevan al cuadrado para evitar que positivos y negativos se cancelen y para penalizar mas las distancias grandes.

Las formulas de la solucion son:

```text
beta_hat = suma[(x_i-x_bar)(y_i-y_bar)] / suma[(x_i-x_bar)^2]
alpha_hat = y_bar - beta_hat*x_bar
```

### En Python lo hacemos asi

```python
x_matrix = sm.add_constant(x)
modelo = sm.OLS(y, x_matrix).fit()
print(modelo.summary())
```

`sm.OLS` no agrega automaticamente el intercepto en esta sintaxis. `sm.add_constant(x)` incorpora una columna de unos.

### Salida del ejemplo simulado

```text
                 coef    std err       t      P>|t|
const          0.0802      0.048   1.686      0.094
x1             1.4871      0.045  33.381      0.000

R-squared: 0.883
No. Observations: 150
```

Los parametros exactos guardados son:

```text
alpha_hat = 0.080194
beta_hat  = 1.487082
```

### Que significa esta salida

- La pendiente estimada `1.4871` esta cerca de la pendiente verdadera `1.5`.
- El intercepto estimado `0.0802` esta cerca de `0.05`, aunque en esta muestra su `p-value=0.094` no permite rechazar que sea cero al 5%.
- El modelo explica `88.3%` de la variacion muestral de `y`.
- La enorme significancia de la pendiente era esperable porque simulamos una relacion fuerte.

### Idea para recordar

Que un estimador sea insesgado no significa que coincida exactamente con el parametro en cada muestra. Significa que su promedio entre muchas muestras coincide con el parametro.

## 3. Ecuaciones normales y propiedades de los residuos

### Microresumen teorico

Las condiciones de primer orden de MCO producen:

```text
suma(e_i) = 0
suma(x_i*e_i) = 0
```

Cuando el modelo incluye intercepto:

- La media de los residuos es cero.
- Los residuos son ortogonales a la variable explicativa incluida.
- La recta estimada pasa por `(x_bar, y_bar)`.
- El signo de `beta_hat` coincide con el signo de la covarianza entre `x` e `y`.

Estas son propiedades algebraicas del ajuste MCO, no pruebas de que los supuestos poblacionales sean verdaderos.

### En Python lo comprobamos asi

En el ejemplo de CEOs:

```python
modelo1.resid.sum()
modelo1.resid.mean()

df_aux = pd.DataFrame({
    'Ganancias': df['Ganancias'],
    'residuo': modelo1.resid
})
df_aux.cov().loc['Ganancias', 'residuo']
```

### Salida del ejemplo

```text
Suma de residuos:              2.35e-14
Media de residuos:             3.36e-16
Cov(Ganancias, residuos):     -5.88e-14
```

### Que significa esta salida

Los resultados no son cero exacto por precision numerica de la computadora, pero su magnitud es despreciable. Confirman que el algoritmo encontro la solucion MCO.

No prueban homocedasticidad, normalidad, ausencia de autocorrelacion ni exogeneidad.

### Idea para recordar

`Cov(x,residuo)=0` en la muestra es una consecuencia mecanica de MCO con intercepto. No debe confundirse con el supuesto teorico sobre `Cov(x,error)`.

## 4. Descomposicion de la variabilidad y R cuadrado

### Microresumen teorico

La variabilidad total de `y` se descompone como:

```text
TSS = ESS + RSS
```

- `TSS`: variabilidad total de `y` alrededor de su media.
- `ESS`: variabilidad explicada por la recta.
- `RSS`: variabilidad que queda en los residuos.

El coeficiente de determinacion es:

```text
R^2 = ESS/TSS = 1 - RSS/TSS
```

En una regresion simple con intercepto tambien se cumple:

```text
R^2 = Corr(x,y)^2
```

### En Python lo hacemos asi

```python
tss = modelo1.centered_tss
ess = modelo1.ess
rss = modelo1.ssr
r2 = modelo1.rsquared
```

### Salida del ejemplo de CEOs

```text
TSS = 59.445857
ESS = 25.827970
RSS = 33.617887
R^2 = 0.434479
```

### Que significa esta salida

Las ganancias empresariales explican aproximadamente `43.45%` de la variabilidad muestral de las compensaciones a CEOs. El `56.55%` restante queda sin explicar por esta regresion simple.

Un R cuadrado alto no prueba causalidad ni que el modelo cumpla sus supuestos. Un R cuadrado bajo tampoco vuelve inutil una relacion estimada.

### Idea para recordar

R cuadrado mide ajuste dentro de la muestra, no validez causal ni calidad automatica de las predicciones futuras.

## 5. Supuestos, insesgadez y Gauss-Markov

### Microresumen teorico

La clase parte de media condicional correctamente especificada:

```text
E(u_i | x_i) = 0
```

Bajo este supuesto, los estimadores MCO son insesgados:

```text
E(beta_hat) = beta
E(alpha_hat) = alpha
```

Luego incorpora:

```text
Var(u_i) = sigma^2             homocedasticidad
Cov(u_i,u_j) = 0 para i != j  ausencia de autocorrelacion
```

Bajo los supuestos de Gauss-Markov, MCO es BLUE o MELI: el mejor estimador lineal insesgado. `Mejor` significa menor varianza dentro de esa clase de estimadores; no significa perfecto ni necesariamente mejor que cualquier estimador imaginable.

### Varianza de la pendiente

```text
Var(beta_hat) = sigma^2 / suma[(x_i-x_bar)^2]
```

La estimacion de `beta` es mas precisa cuando:

- Los errores tienen menor varianza.
- Hay mayor dispersion informativa en `x`.
- En general hay mas observaciones que aportan variacion util.

### Idea para recordar

MCO siempre puede calcular una recta si los datos lo permiten. Sus buenas propiedades estadisticas dependen de supuestos adicionales.

## 6. Varianza residual y errores estandar

### Microresumen teorico

Como `sigma^2` es desconocida, en regresion simple la estimamos mediante:

```text
s^2 = RSS/(n-2)
```

Restamos dos grados de libertad porque estimamos intercepto y pendiente. `s^2` estima la varianza del error. Su raiz `s` estima el desvio del error.

El error estandar de un coeficiente es la raiz de su varianza estimada. Mide incertidumbre del estimador, no dispersion de la variable dependiente.

### En Python lo hacemos asi

```python
s2 = modelo1.scale
s = np.sqrt(modelo1.scale)
errores_estandar = modelo1.bse
```

### Salida del ejemplo de CEOs

```text
s^2 = 0.494381
s   = 0.703122

SE(alpha_hat) = 0.112318
SE(beta_hat)  = 0.000117
```

### Que significa esta salida

El tamaño de un coeficiente aislado no indica si es preciso. Hay que compararlo con su error estandar mediante un estadistico `t`.

### Idea para recordar

Coeficiente es efecto estimado; error estandar es incertidumbre sobre ese efecto.

## 7. Normalidad, t de Student e inferencia

### Microresumen teorico

Para obtener resultados exactos de inferencia en muestras finitas, la clase agrega:

```text
u_i ~ N(0,sigma^2), iid
```

Como reemplazamos `sigma^2` por `s^2`, el estadistico estandarizado sigue una t de Student:

```text
t = (beta_hat - beta_0) / SE(beta_hat)
```

En regresion simple tiene `n-2` grados de libertad.

Para un test bilateral:

```text
H0: beta = beta_0
HA: beta != beta_0
```

podemos decidir de dos maneras equivalentes:

- Rechazar si `|t|` supera el valor critico.
- Rechazar si `p-value <= nivel_de_significancia`.

No rechazar no significa demostrar que `H0` sea verdadera; significa que la muestra no aporta evidencia suficiente para rechazarla.

### Intervalo de confianza

```text
beta_hat +/- t_critico * SE(beta_hat)
```

Para un test bilateral al 5%, rechazamos `H0: beta=beta_0` exactamente cuando `beta_0` queda fuera del intervalo de confianza del 95%.

### Idea para recordar

Estimacion puntual, error estandar, test e intervalo cuentan partes de la misma historia: valor estimado, incertidumbre y valores poblacionales compatibles con la muestra.

## 8. Practica 3, ejercicio 1 - Beta como covarianza sobre varianza

### Que hacemos en la practica

Partimos de:

```text
beta_hat = suma[(x_i-x_bar)(y_i-y_bar)] / suma[(x_i-x_bar)^2]
```

Si dividimos numerador y denominador por el mismo factor, `n` o `n-1`, obtenemos:

```text
beta_hat = Cov(x,y) / Var(x)
```

### Cruce con la teoria financiera

En CAPM regresamos la prima de riesgo del activo sobre la prima de riesgo del mercado:

```text
R_activo - R_f = alpha + beta*(R_mercado - R_f) + u
```

Por lo tanto:

```text
beta_hat = Cov(R_activo-R_f, R_mercado-R_f)
           / Var(R_mercado-R_f)
```

### Que significa

El beta combina co-movimiento con el mercado y volatilidad del mercado. Si la covarianza es positiva, el beta tambien lo es. No es simplemente la volatilidad individual del activo.

## 9. Practica 3, ejercicio 2 - Beta financiero de IBM

### Preparacion de los datos

La base disponible es `Bases de Datos MIA103/ibm.xlsx`.

```python
df = pd.read_excel('Bases de Datos MIA103/ibm.xlsx')
df = df[['Date', 'IBM_price', 'S&P500_index',
         '3mTB (RF) anualizada']]
df.columns = ['Date', 'IBM', 'SP500', '3mTB']

df['R_IBM'] = df['IBM'].pct_change()
df['R_SP'] = df['SP500'].pct_change()
df['Rf'] = (1 + df['3mTB']/100)**(1/12) - 1
df['Ribm-Rf'] = df['R_IBM'] - df['Rf']
df['Rsp-Rf'] = df['R_SP'] - df['Rf']
df = df.dropna()
```

La tasa del Treasury esta anualizada y expresada en porcentaje. Primero se divide por 100 y luego se convierte en tasa efectiva mensual.

### Regresion en Python

```python
X = sm.add_constant(df['Rsp-Rf'])
y = df['Ribm-Rf']
modelo = sm.OLS(y, X).fit()
```

### Salida principal

```text
                 coef    std err      t      P>|t|    IC 95%
const          0.003128   0.007937   0.394   0.695   [-0.0128, 0.0190]
Rsp-Rf         0.697587   0.149333   4.671   0.000   [ 0.3986, 0.9966]

R^2 = 0.276847
n = 59
```

### a. Interpretacion del beta

`beta_hat=0.6976` indica que, ante un aumento de un punto porcentual en la prima de riesgo del mercado, la prima de riesgo de IBM aumenta en promedio aproximadamente `0.698` puntos porcentuales.

Como es positivo y menor que uno, IBM acompaña al mercado en esta muestra, pero con menor sensibilidad. Esta es una interpretacion muestral; no garantiza que el beta futuro sea constante.

### b. Test de H0: beta=0

```text
t = 0.697587 / 0.149333 = 4.6713
valor critico bilateral al 5%, gl=57: +/-2.0025
p-value aproximado: 0.0000187
```

Como `|4.6713| > 2.0025` y `p<0.05`, rechazamos `H0`. Hay evidencia de que la prima de riesgo de IBM se relaciona linealmente con la del mercado.

### c. Test de H0: beta=1

```text
t = (0.697587 - 1) / 0.149333 = -2.0251
```

Como `|-2.0251| > 2.0025`, rechazamos `H0` al 5%, aunque por un margen pequeño. El intervalo `[0.3986, 0.9966]` tambien excluye apenas al valor `1`.

### d. Intervalo de confianza del beta

```text
IC 95% = [0.3986, 0.9966]
```

Son los valores poblacionales de beta compatibles con la muestra al nivel de confianza elegido. No significa que haya 95% de probabilidad de que un beta fijo este dentro del intervalo ya calculado.

### e. Significancia del intercepto

```text
alpha_hat = 0.003128
t = 0.394
p-value = 0.695
```

No rechazamos `H0: alpha=0`. No hay evidencia suficiente para sostener que el alfa de Jensen sea distinto de cero.

### f. Correlacion entre las primas de riesgo

En regresion simple con intercepto:

```text
R^2 = Corr(x,y)^2
```

Entonces:

```text
sqrt(0.276847) = 0.526162
```

Elegimos el signo positivo porque la pendiente estimada es positiva. La correlacion muestral es aproximadamente `0.526`.

## 10. Practica 3, ejercicio 3 - Ganancias y compensacion a CEOs

### Que hacemos en la practica

Estimamos:

```text
Compensacion_CEO = alpha + beta*Ganancias + u
```

Ambas variables estan medidas en millones de dolares.

### En Python lo hacemos asi

```python
ceo = pd.read_excel('Bases de Datos MIA103/ceo.xlsx')

X = sm.add_constant(ceo['Ganancias'])
y = ceo['Compensacion_CEO']
modelo_ceo = sm.OLS(y, X).fit()
```

### Salida principal

```text
                 coef      std err      t      P>|t|       IC 95%
const          0.599965    0.112318   5.342    0.000    [0.376, 0.824]
Ganancias      0.000842    0.000117   7.228    0.000    [0.001, 0.001]

R^2 = 0.434479
n = 70
gl residuales = 68
```

La tabla redondea el intervalo de la pendiente a tres decimales; esto oculta precision. Para interpretar conviene usar el coeficiente sin redondear.

### a y b. Regresion e interpretacion

Si las ganancias aumentan en un millon de dolares, la compensacion estimada aumenta `0.000842` millones, es decir, aproximadamente `842` dolares.

El intercepto `0.599965` millones es la compensacion predicha cuando las ganancias son cero. Puede no tener una interpretacion economica util si cero queda lejos del rango relevante de la muestra.

### c. Test de H0: beta=0 al 1%

```text
t = 7.2279
valor critico bilateral, alpha=0.01, gl=68: +/-2.6501
p-value aproximado: 5.50e-10
```

Rechazamos `H0`. Hay evidencia estadistica al 1% de una asociacion positiva entre ganancias y compensacion.

Que el coeficiente tenga varios ceros no implica poca significancia: su tamaño depende de las unidades. Si la compensacion se expresara en dolares, la pendiente seria `842` en lugar de `0.000842` millones.

### d. Porcentaje explicado

```text
R^2 = 0.434479
```

Las ganancias explican aproximadamente `43.45%` de la variabilidad muestral de las compensaciones. El resultado no demuestra que aumentar ganancias cause mecanicamente un aumento salarial.

## 11. Prediccion y bandas

### Prediccion puntual

Para una empresa con ganancias de 500 millones:

```python
y_hat_500 = (
    modelo_ceo.params['const']
    + modelo_ceo.params['Ganancias'] * 500
)
```

Salida:

```text
1.021128 millones de dolares
```

Esta es la compensacion promedio estimada por la recta para ese nivel de ganancias.

### Banda de confianza frente a banda de prediccion

```python
pred = modelo_ceo.get_prediction()
tabla = pred.summary_frame(alpha=0.05)
```

La tabla contiene:

- `mean`: valor medio predicho.
- `mean_ci_lower` y `mean_ci_upper`: intervalo para la media condicional.
- `obs_ci_lower` y `obs_ci_upper`: intervalo para una observacion individual futura.

La banda de prediccion es mas ancha porque incorpora dos fuentes de incertidumbre:

```text
incertidumbre sobre la recta + variabilidad individual del error
```

La banda de confianza solo cuantifica incertidumbre sobre el promedio estimado.

### Idea para recordar

Predecir la compensacion promedio de todas las empresas con `x=500` es mas preciso que predecir la compensacion de una empresa individual con `x=500`.

## 12. Como leer una salida de `statsmodels`

| Campo | Pregunta que responde |
|---|---|
| `coef` | ¿Cual es el valor estimado del parametro? |
| `std err` | ¿Cuanta incertidumbre tiene ese estimador? |
| `t` | ¿Cuantos errores estandar separan al estimador del valor nulo, normalmente cero? |
| `P>|t|` | ¿Rechazamos el test bilateral contra cero al nivel elegido? |
| `[0.025, 0.975]` | ¿Que valores del parametro son compatibles con un IC del 95%? |
| `R-squared` | ¿Que proporcion de variabilidad muestral explica el modelo? |
| `Df Residuals` | ¿Cuantos grados de libertad quedan para estimar la varianza residual? |
| `F-statistic` | ¿El conjunto de pendientes aporta explicacion frente a un modelo solo con intercepto? |

## Cierre de la Clase 3

Al terminar esta clase deberiamos poder explicar:

1. La diferencia entre parametro, estimador, error y residuo.
2. Que funcion minimiza MCO y por que agrega un intercepto.
3. Las formulas de `alpha_hat` y `beta_hat`.
4. Las propiedades algebraicas de los residuos.
5. La descomposicion `TSS = ESS + RSS` y el significado de R cuadrado.
6. Que significa que MCO sea insesgado y BLUE bajo supuestos.
7. La diferencia entre coeficiente y error estandar.
8. Como construir e interpretar un test t, un p-value y un intervalo.
9. Como interpretar el beta de un activo y el alfa de Jensen.
10. La diferencia entre banda de confianza y banda de prediccion.

## Observaciones tecnicas antes de ejecutar

- `MIA103_2026_Clase_03_Ejercicios.ipynb` busca `MIA103_Ejer_3_Datos.xlsx`, archivo que no existe con ese nombre. La informacion esta separada en `Bases de Datos MIA103/ibm.xlsx` y `Bases de Datos MIA103/ceo.xlsx`.
- `MIA103_2026_Clase_03_profundización.ipynb` busca `ceo.xlsx` en el directorio actual. Desde la raiz debe usarse `Bases de Datos MIA103/ceo.xlsx`.
- La salida de CEOs muestra un numero de condicion alto. Como hay una sola variable explicativa, esto puede deberse principalmente a la escala muy distinta entre la constante y `Ganancias`; no es evidencia suficiente de multicolinealidad.
- En el test de CEOs la practica exige un nivel de significancia de `1%`. El p-value es mucho menor que `0.01`, por lo que la conclusion de rechazo se mantiene.
