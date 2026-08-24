# Clase 1 - Teoria + practica + Python

[← Volver al indice general](../Res+Pra.md)

Esta guia cruza la teoria de la Clase 1 con sus notebooks, la ejercitacion y las salidas obtenidas.

En cada tema seguimos siempre el mismo recorrido:

```text
microteoria -> en Python lo hacemos asi -> salida del ejemplo -> que significa -> idea para recordar
```

Las salidas numericas pertenecen a los ejemplos guardados en los notebooks. Si se actualiza la fuente de Yahoo Finance, los numeros pueden cambiar sin que cambie la interpretacion.

## Retornos, distribuciones y momentos

## Archivos que vamos a usar

| Tipo | Archivo | Para que se usa |
|---|---|---|
| Teoria | `Clases/MIA103_Clase_1.pdf` | Definiciones de retornos, distribuciones y momentos |
| Python | `Codigos/MIA103_2026_Clase_01_01.ipynb` | Precios del S&P 500, retornos, estadisticos, QQ plot y Jarque-Bera |
| Python | `Codigos/MIA103_2026_Clase_01_02_Mixtura.ipynb` | Densidades normales, mixtura, momentos y comportamiento de las colas |
| Practica | `Practicas/MIA103_Ejer_1.pdf` | Ejercicios de aplicacion |
| Solucion | `Practicas/MIA103_Ejer_1_Sol.pdf` | Control de los resultados de la practica |
| Datos | `Bases de Datos MIA103/SP500_.xlsx` | Serie local del S&P 500 |

## Orden de estudio y notebook correspondiente

| Paso | Tema | Notebook |
|---:|---|---|
| 1 | Precios y construccion de retornos | `MIA103_2026_Clase_01_01.ipynb` |
| 2 | Estadisticos descriptivos y momentos | `MIA103_2026_Clase_01_01.ipynb` |
| 3 | Estandarizacion y QQ plot | `MIA103_2026_Clase_01_01.ipynb` |
| 4 | Test de Jarque-Bera | `MIA103_2026_Clase_01_01.ipynb` |
| 5 | Densidad normal y mixtura de normales | `MIA103_2026_Clase_01_02_Mixtura.ipynb` |
| 6 | Momentos y colas de la mixtura | `MIA103_2026_Clase_01_02_Mixtura.ipynb` |

## 1. Precios y retornos

### Microresumen teorico

Un precio `P_t` indica cuanto vale un activo en el momento `t`. Para comparar variaciones entre momentos usamos retornos.

El retorno simple es:

```text
R_t = (P_t - P_{t-1}) / P_{t-1} = P_t / P_{t-1} - 1
```

El retorno logaritmico es:

```text
r_t = ln(P_t / P_{t-1}) = ln(P_t) - ln(P_{t-1})
```

Para variaciones pequeñas, ambos son muy parecidos. El retorno simple tiene una interpretacion porcentual directa. El retorno logaritmico es aditivo en el tiempo, por lo que resulta especialmente util en series temporales.

### En Python lo hacemos asi

Notebook: `MIA103_2026_Clase_01_01.ipynb`.

```python
df['Return_pct'] = df['Adj Close'].pct_change()
df['Return_log'] = np.log(df['Adj Close'] / df['Adj Close'].shift(1))
```

`pct_change()` compara el precio actual con el anterior. `shift(1)` desplaza la serie un periodo y permite construir manualmente el cociente `P_t / P_{t-1}`.

### Salida del ejemplo de la clase

| Fecha | Precio ajustado | Retorno simple | Retorno logaritmico |
|---|---:|---:|---:|
| 2021-06-01 | 4202.040039 | `NaN` | `NaN` |
| 2021-06-02 | 4208.120117 | 0.001447 | 0.001446 |
| 2021-06-03 | 4192.850098 | -0.003629 | -0.003635 |
| 2021-06-04 | 4229.890137 | 0.008834 | 0.008795 |

### Que significa esta salida

- El primer retorno es `NaN` porque no existe un precio anterior con el cual comparar la primera observacion.
- El 2 de junio el retorno simple fue `0.001447`, aproximadamente `0.1447%`.
- El 3 de junio el retorno fue negativo: el indice bajo aproximadamente `0.3629%`.
- El retorno simple y el logaritmico son casi iguales porque las variaciones diarias son pequeñas.

### Idea para recordar

El precio es un nivel; el retorno mide la variacion relativa. Para estudiar riesgo y distribuciones normalmente trabajamos con retornos, no directamente con precios.

## 2. Estadisticos descriptivos y momentos

### Microresumen teorico

Los momentos resumen distintas caracteristicas de una distribucion:

- Media: ubicacion o retorno promedio.
- Varianza y desvio estandar: dispersion o volatilidad.
- Asimetria: falta de simetria entre las colas.
- Curtosis: peso de las colas y concentracion respecto de una normal.

Una normal tiene asimetria `0` y curtosis total `3`. Si usamos exceso de curtosis, la normal tiene valor `0`.

### En Python lo hacemos asi

```python
df['Return_pct'].describe()
```

### Salida del ejemplo de la clase

```text
count    1191.000000
mean        0.000471
std         0.010724
min        -0.059750
25%        -0.004696
50%         0.000813
75%         0.006052
max         0.095154
```

### Que significa esta salida

- Hay 1191 retornos validos.
- La media diaria es `0.000471`, aproximadamente `0.0471%`.
- El desvio estandar diario es `0.010724`, aproximadamente `1.0724%`; esta es una medida de volatilidad diaria.
- El peor retorno de la muestra fue cercano a `-5.975%`.
- El mejor fue cercano a `9.515%`.
- La mediana fue `0.0813%`. Que media y mediana no coincidan exactamente ya sugiere que la distribucion no es perfectamente simetrica.

### Idea para recordar

La media habla del centro; el desvio habla del riesgo alrededor de ese centro. Minimo, maximo y cuantiles ayudan a ver lo que una unica medida promedio oculta.

## 3. Estandarizacion y QQ plot

### Microresumen teorico

Estandarizar un retorno significa restarle su media y dividirlo por su desvio estandar:

```text
z_t = (R_t - media) / desvio
```

La nueva variable queda expresada en cantidad de desvios estandar respecto de la media. El QQ plot compara los cuantiles observados con los cuantiles que tendria una distribucion normal.

### En Python lo hacemos asi

```python
retornos = df['Return_pct'].dropna()
retornos_estandarizados = (
    retornos - retornos.mean()
) / retornos.std()

stats.probplot(retornos_estandarizados, dist='norm', plot=plt)
```

El notebook tambien muestra la alternativa de `statsmodels`:

```python
sm.qqplot(retornos_estandarizados, line='s', fit=True)
```

### Salida del ejemplo de la clase

La salida es un grafico. Si los retornos fueran aproximadamente normales, los puntos quedarian cerca de la recta de referencia. En el ejemplo del S&P 500, los mayores desvios aparecen en los extremos.

### Que significa esta salida

Los desvios en las colas indican que los eventos extremos ocurren de una manera distinta a la que predice una normal. El QQ plot sirve como diagnostico visual, pero no reemplaza un contraste formal.

### Idea para recordar

Centro alineado y colas desviadas significa que una normal puede describir razonablemente observaciones comunes, pero representar mal los episodios extremos.

## 4. Test de Jarque-Bera

### Microresumen teorico

Jarque-Bera contrasta conjuntamente la asimetria y la curtosis.

```text
H0: los datos son compatibles con una distribucion normal
H1: los datos no son compatibles con una distribucion normal
```

Su estadistico es:

```text
JB = n/6 * [S^2 + (K - 3)^2 / 4]
```

donde `S` es la asimetria y `K` es la curtosis total.

### En Python lo hacemos asi

```python
jb_stat, jb_pvalue = stats.jarque_bera(retornos)

print(f'P-valor: {jb_pvalue:.4f}')
print(f'Estadistico de Jarque-Bera: {jb_stat:.4f}')
```

### Salida del ejemplo de la clase

```text
P-valor: 0.0000
Estadistico de Jarque-Bera: 2656.0862
Asimetria: 0.1655
Curtosis: 10.3085
```

### Que significa esta salida

Como el `p-value` es menor que `0.05`, rechazamos `H0`. Los retornos del ejemplo no son compatibles con una distribucion normal.

La asimetria positiva `0.1655` es moderada. La gran diferencia aparece en la curtosis: `10.3085` esta muy por encima del valor `3` de una normal. Por lo tanto, el rechazo se relaciona especialmente con colas pesadas y una mayor presencia de valores extremos.

No debemos decir que el `p-value` es la probabilidad de que `H0` sea verdadera. El resultado significa que observar una discrepancia como esta seria extremadamente improbable si realmente se cumpliera la normalidad.

### Idea para recordar

Si `p < 0.05`, rechazamos normalidad. Siempre hay que complementar esa decision diciendo si el problema parece venir de la asimetria, de la curtosis o de ambas.

## 5. Densidad normal y mixtura de normales

### Microresumen teorico

Una mixtura combina dos o mas distribuciones usando pesos que suman uno. En el ejemplo:

```text
X ~ 0.75 * N(0, 1) + 0.25 * N(-1.5, 4)
```

Esto no significa sumar dos variables aleatorias. Significa que una observacion proviene del primer componente con probabilidad `0.75` y del segundo con probabilidad `0.25`.

La densidad combinada es:

```text
f_mix(x) = 0.75 * f_1(x) + 0.25 * f_2(x)
```

### En Python lo hacemos asi

Notebook: `MIA103_2026_Clase_01_02_Mixtura.ipynb`.

```python
w1 = 0.75
w2 = 0.25

df['pdf_normal'] = stats.norm.pdf(df['z'])
df['pdf_m15_v4'] = stats.norm.pdf(
    df['z'], loc=-1.5, scale=2
)
df['pdf_mixt'] = (
    w1 * df['pdf_normal']
    + w2 * df['pdf_m15_v4']
)
```

En `scipy`, `scale` recibe el desvio estandar, no la varianza. Como la segunda normal tiene varianza `4`, usamos `scale=2`.

### Salida del ejemplo de la clase

Para `z = -8`:

```text
PDF N(0,1):              5.052271e-15
PDF N(-1.5,4):           1.015000e-03
PDF de la mixtura:       2.536310e-04
```

### Que significa esta salida

En un valor muy negativo, la densidad de la normal estandar es practicamente cero. La segunda normal tiene media negativa y mayor dispersion, por lo que asigna mucha mas densidad a esa region. Aunque solo pesa `25%`, domina la cola izquierda de la mixtura.

### Idea para recordar

Un componente con poco peso puede tener un efecto enorme sobre las colas si tiene mayor varianza o una media desplazada.

## 6. Momentos de la mixtura

### Microresumen teorico

La media de una mixtura es el promedio ponderado de las medias:

```text
media_mix = w1 * media_1 + w2 * media_2
```

La varianza no es solamente el promedio ponderado de las varianzas. Tambien debe incorporar la distancia entre la media de cada componente y la media total:

```text
var_mix = suma de w_i * [var_i + (media_i - media_mix)^2]
```

### En Python lo hacemos asi

```python
mu_mix = w1 * mu1 + w2 * mu2

var_mix = (
    w1 * (var1 + (mu1 - mu_mix) ** 2)
    + w2 * (var2 + (mu2 - mu_mix) ** 2)
)
```

El notebook calcula despues los momentos centrados tercero y cuarto para obtener asimetria y curtosis.

### Salida del ejemplo de la clase

```text
Media: -0.375
Varianza: 2.17188
Tercer momento: -2.84766
Cuarto momento: 22.89185
Asimetria: -0.88968
Curtosis: 4.85301
```

### Que significa esta salida

- La media negativa surge porque el segundo componente tiene media `-1.5`.
- La asimetria `-0.88968` indica una cola izquierda mas pronunciada.
- La curtosis `4.85301` supera el valor `3` de una normal: la mixtura tiene colas mas pesadas.
- Una normal con la misma media y varianza no reproduce necesariamente la forma ni el riesgo de cola de la mixtura.

### Idea para recordar

Dos distribuciones pueden tener la misma media y varianza y aun asi diferir mucho en asimetria, curtosis y probabilidad de eventos extremos.

## 7. Comparacion de colas

### Microresumen teorico

Para comparar correctamente la mixtura contra una normal conviene usar una normal equivalente con la misma media y varianza. Asi, cualquier diferencia restante corresponde a la forma, la asimetria o las colas, y no simplemente a una ubicacion o escala distinta.

### En Python lo hacemos asi

```python
pdf_normal_equiv = norm.pdf(
    df['z'], loc=mu_mix, scale=np.sqrt(var_mix)
)
```

### Salida del ejemplo de la clase

En `z = -8`:

```text
Densidad de la mixtura:         0.000254
Densidad de la normal equivalente: 4.163973e-07
```

### Que significa esta salida

La mixtura asigna muchisima mas densidad a un evento extremo de la cola izquierda que la normal equivalente. Esto muestra por que asumir normalidad puede subestimar el riesgo extremo aun cuando la media y la varianza esten correctamente estimadas.

### Idea para recordar

La comparacion de colas es central en finanzas: un modelo puede describir bien el centro y, al mismo tiempo, subestimar fuertemente las perdidas extremas.

## 8. Practica 1 cruzada con la teoria

Esta seccion explica que pide cada ejercicio, que concepto teorico practica y donde aparece resuelto en Python.

### Ejercicio 1 - Momentos de la normal estandar

#### Que hacemos en la practica

Se demuestra mediante integrales que, si `Z ~ N(0,1)`:

```text
E(Z)   = 0
E(Z^2) = 1
E(Z^3) = 0
E(Z^4) = 3
```

#### Cruce con la teoria

- `E(Z)=0` confirma que la normal estandar esta centrada en cero.
- `E(Z^2)=1` confirma que su varianza es uno.
- `E(Z^3)=0` se relaciona con su simetria y produce un coeficiente de asimetria igual a cero.
- `E(Z^4)=3` produce una curtosis total igual a tres.

Los momentos impares se anulan porque la densidad es simetrica y la funcion que se integra es impar. Para los momentos pares, la practica utiliza integracion por partes.

#### Que significa el resultado

Estos cuatro valores son la referencia contra la cual despues comparamos distribuciones empiricas y mixturas. Jarque-Bera usa precisamente las desviaciones de la asimetria respecto de `0` y de la curtosis respecto de `3`.

### Ejercicio 2 - Mixtura de normales

#### Que hacemos en la practica

Construimos la densidad:

```text
0.75 * N(0,1) + 0.25 * N(-1.5,4)
```

y calculamos su media, varianza, asimetria y curtosis. Este ejercicio se implementa en `MIA103_2026_Clase_01_02_Mixtura.ipynb`.

#### Salida obtenida

```text
Media: -0.375
Varianza: 2.17188
Asimetria: -0.88968
Curtosis: 4.85301
```

#### Cruce con la teoria

- La asimetria negativa confirma la cola izquierda alargada que se observa en el grafico.
- La curtosis mayor que `3` indica una distribucion leptocurtica y con colas mas pesadas que una normal.
- La practica aclara que los momentos deben calcularse sobre la distribucion, no aplicando estadistica descriptiva a la tabla de valores de la densidad como si fueran una muestra.

#### Que significa el resultado

La mixtura combina dos normales, pero el resultado no es normal. Este es el puente entre la teoria de momentos y el problema empirico de los retornos financieros: una distribucion puede mostrar asimetria y una frecuencia de extremos que la normal no captura.

### Ejercicio 3 - Retornos de un activo financiero

#### Que hacemos en la practica

Elegimos un activo, descargamos entre tres y cinco años de precios ajustados y luego:

1. Calculamos retornos simples.
2. Calculamos media, volatilidad, asimetria y curtosis.
3. Graficamos el histograma.
4. Contrastamos normalidad con Jarque-Bera.
5. Verificamos la propiedad aditiva de los retornos logaritmicos.

El notebook `MIA103_2026_Clase_01_01.ipynb` desarrolla estos pasos usando el S&P 500, aunque no deja implementados explicitamente el histograma ni la comprobacion mensual del ultimo inciso.

#### En Python completamos el histograma asi

```python
plt.hist(retornos, bins=30, edgecolor='black')
plt.xlabel('Retorno simple diario')
plt.ylabel('Frecuencia')
plt.title('Histograma de retornos del S&P 500')
plt.show()
```

#### En Python verificamos la suma logaritmica asi

```python
mes = df[df['Date'].dt.to_period('M') == '2025-01']

suma_diaria = mes['Return_log'].sum()
retorno_mes = np.log(
    mes['Adj Close'].iloc[-1] / mes['Adj Close'].iloc[0]
)

print(suma_diaria)
print(retorno_mes)
```

La igualdad se debe a que:

```text
ln(P_1/P_0) + ln(P_2/P_1) + ... + ln(P_T/P_{T-1})
= ln(P_T/P_0)
```

Los cocientes intermedios se cancelan al sumar los logaritmos.

#### Salida e interpretacion de Jarque-Bera

En la solucion oficial aparece un ejemplo con:

```text
JB = 1982.8
```

El notebook actualizado obtiene:

```text
JB = 2656.0862
p-value = 0.0000
```

Los valores difieren porque usan muestras o fechas distintas. La conclusion teorica es la misma: rechazamos normalidad. Esto muestra que el resultado numerico depende de la muestra, mientras que la regla de decision no cambia.

#### Precaucion con los precios

La practica destaca que deben usarse precios ajustados por dividendos, cupones o pagos de capital. De lo contrario, una transferencia al tenedor podria interpretarse erroneamente como una perdida de precio y generar un retorno falso.

## Cierre de la Clase 1

Al terminar esta clase deberiamos poder explicar:

1. La diferencia entre precio, retorno simple y retorno logaritmico.
2. Que informacion aportan media, desvio, asimetria y curtosis.
3. Como leer un QQ plot.
4. Como tomar una decision con el `p-value` de Jarque-Bera.
5. Que representa una mixtura de distribuciones.
6. Por que una mixtura puede generar asimetria y colas pesadas.
7. Por que igualar media y varianza no alcanza para igualar riesgos extremos.

## Observacion tecnica antes de ejecutar

El notebook intenta leer `SP500.xlsx`, mientras que la base local se llama `SP500_.xlsx`. Tambien ofrece descargar los datos con `yfinance`. Si se utiliza Yahoo Finance en otra fecha, la cantidad de observaciones y las salidas numericas pueden diferir de las guardadas en el notebook.
