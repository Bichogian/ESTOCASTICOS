# Clase 2 - Teoria + practica + Python

[← Volver al indice general](../Res+Pra.md)

Esta guia cruza la teoria de la Clase 2 con los notebooks, la Ejercitacion 2, el Excel de la clase y las salidas obtenidas.

El recorrido de cada tema es:

```text
microteoria -> en Python lo hacemos asi -> salida del ejemplo -> que significa -> idea para recordar
```

## Archivos que vamos a usar

| Tipo | Archivo | Para que se usa |
|---|---|---|
| Teoria | `Clases/MIA103_Clase_2.pdf` | PBI real, crecimiento, logaritmos, tendencia y ciclo |
| Python | `Codigos/MIA103_2026_Clase_02_PBI_Argentina.ipynb` | PBI argentino, crecimiento, media movil y filtro HP |
| Python | `Codigos/MIA103_2026_Clase_02_Ejercicio_3.ipynb` | Aplicacion de media movil y HP al PBI de Estados Unidos |
| Python | `Codigos/MIA103_2026_Clase_02_Ejercicios_1_y_2.ipynb` | Mixturas, momentos, simulacion y QQ plots de la practica |
| Practica | `Practicas/MIA103_Ejer_2.pdf` | Dos ejercicios de mixturas y uno de tendencia-ciclo |
| Datos | `Excels/MIA103_Clase_2.xlsx` | PBI real de Argentina y Estados Unidos, media movil y HP |

## Que notebook usamos para cada tema

| Paso | Tema | Notebook o archivo |
|---:|---|---|
| 1 | PBI nominal y PBI real | PDF de Clase 2 |
| 2 | Crecimiento simple, acumulado y promedio | PDF y notebook `PBI_Argentina` |
| 3 | Escala logaritmica | Notebook `PBI_Argentina` |
| 4 | Tendencia y ciclo | PDF y notebook `PBI_Argentina` |
| 5 | Media movil centrada | Notebooks `PBI_Argentina` y `Ejercicio_3` |
| 6 | Filtro Hodrick-Prescott | Notebooks `PBI_Argentina` y `Ejercicio_3` |
| 7 | Mixtura simetrica y leptocurtica | Notebook `Ejercicios_1_y_2`, ejercicio 1 |
| 8 | Mixtura asimetrica y platicurtica | Notebook `Ejercicios_1_y_2`, ejercicio 2 |
| 9 | Descomposicion del PBI de Estados Unidos | Notebook `Ejercicio_3`, ejercicio 3 de la practica |

## 1. PBI nominal y PBI real

### Microresumen teorico

El PBI mide el valor de los bienes finales producidos en una economia durante un periodo.

El PBI nominal usa los precios del mismo periodo:

```text
PBI nominal_t = suma de P_i,t * Q_i,t
```

Puede aumentar porque suben las cantidades, porque suben los precios o por ambas razones.

El PBI real usa precios de un año base:

```text
PBI real_t = suma de P_i,0 * Q_i,t
```

Al mantener fijos los precios, busca medir cambios en las cantidades producidas. Por eso usamos PBI real para hablar de crecimiento o recesion.

### En Python lo hacemos asi

El Excel nuevo contiene una hoja llamada `PBI Real Arg`. Para cargar las columnas de año y PBI desde la raiz del repositorio:

```python
import pandas as pd

df = pd.read_excel(
    'Excels/MIA103_Clase_2.xlsx',
    sheet_name='PBI Real Arg',
    usecols='B:C',
    skiprows=10
)
df.columns = ['year', 'gdp']
df = df.dropna().sort_values('year').reset_index(drop=True)
```

### Salida del ejemplo

```text
year        gdp
1950  196688.453125
1951  208305.203125
1952  195898.250000
1953  204164.875000
```

### Que significa esta salida

Cada valor representa produccion real valuada a precios constantes. La caida entre 1951 y 1952 refleja una disminucion real de la actividad, no simplemente un cambio de precios.

### Idea para recordar

El PBI nominal mezcla cantidades y precios. El PBI real intenta aislar cantidades y es el relevante para medir actividad economica.

## 2. Tasas de crecimiento

### Microresumen teorico

El crecimiento simple entre dos periodos es:

```text
g_t = PBI_t / PBI_{t-1} - 1
```

El crecimiento acumulado entre el inicio y el final es:

```text
1 + g_acumulado = PBI_final / PBI_inicial
```

Si queremos una tasa anual constante equivalente para `n` años:

```text
1 + g_promedio = (PBI_final / PBI_inicial)^(1/n)
```

La tasa logaritmica promedio es:

```text
g_log = [ln(PBI_final) - ln(PBI_inicial)] / n
```

Para tasas pequeñas, `g_log` aproxima la tasa porcentual anual.

### En Python lo hacemos asi

```python
primero = df.iloc[0]
ultimo = df.iloc[-1]
n = ultimo['year'] - primero['year']

crecimiento_log_promedio = (
    np.log(ultimo['gdp'] / primero['gdp']) / n
)
```

### Salida del ejemplo

El notebook original, con su archivo CSV 1950-2023, guarda:

```text
0.022374
```

Esto equivale aproximadamente a un crecimiento logaritmico promedio anual de `2.2374%`.

Con el Excel nuevo, que contiene Argentina entre 1950 y 2019, obtenemos aproximadamente:

```text
0.023209
```

es decir, `2.3209%` anual en terminos logaritmicos.

### Que significa esta salida

Las dos tasas no son contradictorias: usan periodos y versiones de datos diferentes. Una tasa promedio resume todo el intervalo con una unica pendiente; no significa que el PBI haya crecido exactamente a esa tasa todos los años.

### Ejemplo teorico de la clase

Entre 1963 y 1998, el PDF utiliza aproximadamente:

```text
PBI_1963 = 270609
PBI_1998 = 705822
```

El cociente es `2.6085`: el PBI final equivale a 2.6085 veces el inicial. El crecimiento acumulado es entonces `160.85%`, mientras que la tasa anual constante equivalente es aproximadamente `2.77%`.

### Idea para recordar

No hay que confundir crecimiento acumulado con crecimiento promedio anual. Uno describe todo el periodo; el otro construye una tasa anual equivalente.

## 3. Escala logaritmica

### Microresumen teorico

Aplicar logaritmos comprime la escala y transforma cocientes en diferencias:

```text
ln(PBI_t / PBI_{t-1}) = ln(PBI_t) - ln(PBI_{t-1})
```

Esto facilita leer el crecimiento: en un grafico de `ln(PBI)`, la pendiente aproxima la tasa de crecimiento.

### En Python lo hacemos asi

```python
df['log_pbi'] = np.log(df['gdp'])
```

### Salida del ejemplo

```text
year        gdp       log_pbi
1950  196688.453125  12.189376
1951  208305.203125  12.246760
1952  195898.250000  12.185351
```

### Que significa esta salida

Entre 1950 y 1951, la diferencia logaritmica es positiva; entre 1951 y 1952 es negativa. La transformacion cambia la escala, pero no cambia el orden temporal ni convierte una caida en crecimiento.

### Idea para recordar

Una diferencia de logaritmos se interpreta aproximadamente como una variacion porcentual cuando el cambio es pequeño.

## 4. Tendencia y ciclo

### Microresumen teorico

La clase propone descomponer el logaritmo del PBI en:

```text
y_t = y_t^g + y_t^c
```

donde:

- `y_t` es el logaritmo del PBI observado.
- `y_t^g` es la tendencia o componente de largo plazo.
- `y_t^c` es el ciclo o desvio respecto de la tendencia.

Si `y_t^c > 0`, la actividad esta por encima de la tendencia estimada. Si `y_t^c < 0`, esta por debajo. Esto no equivale automaticamente a la definicion tecnica de recesion basada en tasas de crecimiento consecutivas.

### Tres metodos planteados

1. Tendencia deterministica: ajustar una recta. Se desarrollara con regresion en clases posteriores.
2. Media movil centrada: promediar observaciones cercanas.
3. Filtro Hodrick-Prescott: elegir una tendencia suave mediante optimizacion.

### Idea para recordar

Tendencia y ciclo no se observan directamente: dependen del metodo utilizado para estimarlos.

## 5. Media movil centrada

### Microresumen teorico

Con una ventana de `2n+1`, la tendencia en `t` es:

```text
y_t^g = promedio(y_{t-n}, ..., y_t, ..., y_{t+n})
```

La clase utiliza `n=5`, es decir, once años: cinco anteriores, el contemporaneo y cinco posteriores.

El ciclo se calcula como:

```text
y_t^c = y_t - y_t^g
```

### En Python lo hacemos asi

```python
df['ygmm'] = df['log_pbi'].rolling(
    window=11,
    center=True
).mean()

df['ciclo_mm'] = df['log_pbi'] - df['ygmm']
```

### Salida del ejemplo argentino

```text
Año    log(PBI)   Tendencia MM11   Ciclo
1963   12.508431      12.576386   -0.067954
1998   13.467203      13.362985    0.104218
2002   13.264402      13.453190   -0.188788
```

### Que significa esta salida

- En 1963 el PBI estaba aproximadamente `6.8%` logaritmico por debajo de la tendencia movil.
- En 1998 estaba por encima de la tendencia.
- En 2002 aparece una brecha negativa muy marcada, consistente con la crisis argentina.

### Limitacion de los extremos

Con una ventana centrada de once observaciones no podemos calcular la tendencia para los primeros cinco ni para los ultimos cinco años. En Python aparecen como `NaN`.

### Idea para recordar

Una ventana mayor produce una tendencia mas suave, pero elimina mas observaciones en los extremos y puede ocultar movimientos relevantes.

## 6. Filtro Hodrick-Prescott

### Microresumen teorico

El filtro HP elige una tendencia que equilibra dos objetivos:

1. Que las diferencias entre la serie y la tendencia sean pequeñas.
2. Que la pendiente de la tendencia no cambie bruscamente.

De forma simplificada, minimiza:

```text
suma(ciclo_t^2) + lambda * suma(cambio_en_pendiente_t^2)
```

`lambda` controla el castigo a los cambios de pendiente. Cuanto mayor es, mas suave resulta la tendencia. Para datos anuales, la clase utiliza `lambda=100`.

### En Python lo hacemos asi

```python
from statsmodels.tsa.filters.hp_filter import hpfilter

cycle, trend = hpfilter(df['log_pbi'], lamb=100)
df['y_g'] = trend
df['y_c'] = cycle
```

`hpfilter` devuelve primero el ciclo y despues la tendencia. Conviene respetar ese orden para no intercambiar las interpretaciones.

### Salida del ejemplo argentino

```text
Año    log(PBI)   Tendencia HP   Ciclo HP
1963   12.508431      12.578466  -0.070035
1998   13.467203      13.364598   0.102605
2002   13.264402      13.443636  -0.179234
```

### Que significa esta salida

HP y la media movil cuentan una historia parecida en estos años, aunque no producen valores identicos. En 2002, por ejemplo, ambos metodos detectan una brecha negativa grande.

### Diferencia frente a la media movil

- HP produce estimaciones en los extremos de la muestra.
- La media movil centrada pierde cinco datos en cada extremo.
- HP depende de `lambda`; la media movil depende del ancho de ventana.
- Ninguno revela una tendencia verdadera: ambos construyen una estimacion.

### Idea para recordar

Si aumenta `lambda`, la tendencia se vuelve mas suave y una mayor parte de las fluctuaciones queda asignada al ciclo.

## 7. Practica 2, ejercicio 1 - Mixtura simetrica y leptocurtica

### Que hacemos en la practica

Mezclamos:

```text
0.40 * N(-1,9) + 0.60 * N(-1,4)
```

Las dos normales tienen la misma media, pero distintas varianzas.

### En Python lo hacemos asi

```python
w1, mu1, var1 = 0.40, -1, 9
w2, mu2, var2 = 0.60, -1, 4

df['pdf_1'] = stats.norm.pdf(df['z'], loc=mu1, scale=3)
df['pdf_2'] = stats.norm.pdf(df['z'], loc=mu2, scale=2)
df['pdf_mix'] = w1 * df['pdf_1'] + w2 * df['pdf_2']
```

### Salida teorica

```text
Media: -1.0
Varianza: 6.0
Asimetria: 0.0
Curtosis: 3.5
```

### Que significa esta salida

- La mixtura es simetrica porque ambos componentes estan centrados en `-1`.
- Es leptocurtica porque su curtosis `3.5` es mayor que `3`.
- Puede ser simetrica y no ser normal: simetria no implica normalidad.

### Simulacion de 2000 observaciones

```python
n = 2000
x1 = np.random.normal(mu1, np.sqrt(var1), size=n)
x2 = np.random.normal(mu2, np.sqrt(var2), size=n)
selector = np.random.uniform(size=n)
muestra = np.where(selector < w1, x1, x2)
```

El notebook guardo una muestra con media `-0.9279`, desvio `2.4601`, asimetria `0.1266` y exceso de curtosis `0.7332`.

Estos valores no coinciden exactamente con los teoricos por variabilidad muestral. Ademas, el notebook no fija una semilla aleatoria, por lo que cambian en cada ejecucion. Teoricamente esperamos media `-1`, desvio `sqrt(6)=2.4495`, asimetria `0` y exceso de curtosis `0.5`.

### Idea para recordar

Los parametros teoricos describen la poblacion. Los estadisticos calculados sobre 2000 simulaciones son aproximaciones aleatorias a esos parametros.

## 8. Practica 2, ejercicio 2 - Mixtura asimetrica

### Que hacemos en la practica

Mezclamos:

```text
0.35 * N(1.2,0.09) + 0.65 * N(-0.8,0.81)
```

Ahora cambian las medias, las varianzas y los pesos. La densidad puede mostrar dos zonas de concentracion y no tiene por que ser simetrica.

### Salida teorica

```text
Media: -0.10
Varianza: 1.468
Asimetria: -0.24558
Curtosis: 2.00040
```

### Que significa esta salida

- La asimetria es negativa, no positiva: la cola izquierda tiene mayor peso relativo.
- La curtosis es menor que `3`, por lo que la distribucion es platicurtica, no leptocurtica.
- El grafico es necesario para discutir bimodalidad; los momentos por si solos no dicen cuantos modos tiene una distribucion.

La simulacion guardada arroja media `-0.0924`, desvio `1.1888`, asimetria `-0.1840` y exceso de curtosis `-1.0230`. Las diferencias con los valores teoricos son muestrales y cambian al volver a simular.

### Idea para recordar

No debemos decidir asimetria o curtosis solamente mirando el grafico. El grafico sugiere; los coeficientes permiten clasificar.

## 9. Practica 2, ejercicio 3 - PBI real de Estados Unidos

### Que hacemos en la practica

Usamos la hoja `PBI Real USA` y descomponemos `ln(PBI)` mediante:

1. Media movil centrada de once años.
2. Filtro HP con `lambda=100`.

Para cada metodo graficamos serie y tendencia, y luego el ciclo por separado.

### En Python lo hacemos asi

```python
usa = pd.read_excel(
    'Excels/MIA103_Clase_2.xlsx',
    sheet_name='PBI Real USA',
    usecols='B:C',
    skiprows=10,
    nrows=96
)

usa['log_pbi'] = np.log(usa['GDPCA'])
usa['tendencia_mm'] = usa['log_pbi'].rolling(11, center=True).mean()
usa['ciclo_mm'] = usa['log_pbi'] - usa['tendencia_mm']
usa['ciclo_hp'], usa['tendencia_hp'] = hpfilter(
    usa['log_pbi'], lamb=100
)
```

### Algunas salidas representativas

```text
Año   Ciclo MM11   Ciclo HP
1934   -0.113018   -0.095223
2008    0.016819    0.012563
2009   -0.027917   -0.029594
2020         NaN   -0.028982
2023         NaN    0.005858
```

### Que significa esta salida

- En 1934 la economia seguia claramente por debajo de su tendencia estimada.
- En 2008 todavia aparece levemente por encima de tendencia anual, mientras que en 2009 la brecha se vuelve negativa.
- En 2020 HP detecta una brecha negativa. La media movil centrada no puede calcularla porque faltan cinco años futuros.
- Los metodos no tienen por que ubicar exactamente el mismo punto de giro.

### Idea para recordar

La estimacion del ciclo depende del filtro. Siempre debemos informar el metodo y su parametro antes de interpretar una brecha como auge o recesion.

## Cierre de la Clase 2

Al terminar esta clase deberiamos poder explicar:

1. La diferencia entre PBI nominal y real.
2. La diferencia entre crecimiento acumulado y promedio anual.
3. Por que usamos logaritmos y como se interpreta una diferencia logaritmica.
4. La descomposicion `serie = tendencia + ciclo`.
5. Como funciona una media movil centrada y por que pierde extremos.
6. Que optimiza el filtro HP y que efecto tiene `lambda`.
7. Por que dos metodos de tendencia generan ciclos distintos.
8. La diferencia entre momentos teoricos y estadisticos de una simulacion.
9. Por que simetria, normalidad, curtosis y bimodalidad son propiedades diferentes.

## Observaciones tecnicas antes de ejecutar

- `MIA103_2026_Clase_02_Ejercicio_3.ipynb` busca `MIA103_Clase_2.xlsx` en su directorio actual. El archivo esta en `Excels/`, por lo que hay que usar la ruta indicada en esta guia o mover el directorio de trabajo.
- `MIA103_2026_Clase_02_PBI_Argentina.ipynb` busca `year_gdp_Argentina.csv`, que no esta en el repositorio. El Excel nuevo contiene los datos argentinos en `PBI Real Arg`, pero llega hasta 2019 y usa una version de la serie distinta de la salida 1950-2023 guardada en el notebook.
- Los ejercicios de simulacion no fijan `np.random.seed(...)`; por eso sus salidas cambian en cada ejecucion.
