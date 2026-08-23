# Resumen teoria + practica - Codigos y clases

Este archivo conecta la teoria hasta Clase 8 con los notebooks de `Codigos`. Tambien incluyo los notebooks que aparecen como continuacion de Clase 9 o pronosticos, pero los marco como material posterior/complementario cuando exceden la teoria pedida hasta Clase 8.

## Datasets faltantes para ejecutar todo

En el repo no hay archivos `.xlsx`, `.xls` ni `.csv`. Para correr todos los notebooks como estan, faltan estos datasets:

- `CEO_ejemplo_multicolinealidad.xlsx`
- `Ejemplo_Casa.xls`
- `MIA103_Clase_2.xlsx`
- `MIA103_Ejer_3_Datos.xlsx`
- `SP500.xlsx`
- `UK_rates.xlsx`
- `ceo.xlsx`
- `ejemplo.csv`
- `wheat.xlsx`
- `year_gdp_Argentina.csv`

Sin esos archivos pude leer la logica de los notebooks, el codigo y las salidas guardadas, pero no puedo garantizar una ejecucion limpia de punta a punta.

## Mapa rapido notebook -> tema

| Notebook | Tema principal | Clase relacionada | Dataset |
|---|---|---:|---|
| `MIA103_2026_Clase_00_Intro_practica.ipynb` | Jupyter, NumPy, Pandas, graficos, lectura CSV | Intro practica | `ejemplo.csv` |
| `MIA103_2026_Clase_01_01.ipynb` | S&P500, retornos simples/log, estadisticos, Jarque-Bera | 1 | `SP500.xlsx` |
| `MIA103_2026_Clase_01_02_Mixtura.ipynb` | Mixtura de normales, momentos, pdf | 1 | No requiere dataset |
| `MIA103_2026_Clase_02_PBI_Argentina.ipynb` | PBI, log, tendencia/ciclo, HP filter | 2 | `year_gdp_Argentina.csv` |
| `MIA103_2026_Clase_02_Ejercicio_3.ipynb` | PBI USA, HP filter | 2 | `MIA103_Clase_2.xlsx` |
| `MIA103_2026_Clase_02_Ejercicios_1_y_2.ipynb` | Simulacion, mixturas, bootstrap | 1-2 | No requiere dataset |
| `MIA103_2026_Clase_03.ipynb` | Simulacion de regresion lineal simple con OLS | 3 | No requiere dataset |
| `MIA103_2026_Clase_03_Ejercicios.ipynb` | CAPM/IBM/SP500, retornos, OLS, tests | 3 | `MIA103_Ejer_3_Datos.xlsx` |
| `MIA103_2026_Clase_03_profundizacion.ipynb` | Regresion y profundizacion aplicada | 3-4 | `ceo.xlsx` |
| `MIA103_2026_Clase_04_01_Introduccion.ipynb` | Regresion multiple, dummies, interpretacion | 4 | `Ejemplo_Casa.xls` |
| `MIA103_2026_Clase_04_02_Notacion_Matricial.ipynb` | MCO matricial con NumPy/statsmodels | 4 | No requiere dataset |
| `MIA103_2026_Clase_04_03_Multicolinealidad_Heteroscedasticidad.ipynb` | Multicolinealidad, White/BP/GQ, robustez | 4 | `CEO_ejemplo_multicolinealidad.xlsx`, `Ejemplo_Casa.xls` |
| `MIA103_2026_Clase_06_Procesos_autorregresivos_ARMA.ipynb` | Simulacion AR, MA, ARMA, ACF/PACF | 6 | No requiere dataset |
| `MIA103_2026_Clase_07_Ejemplo_ADF_DFGLS.ipynb` | ADF, DFGLS, orden de integracion | 7 | `wheat.xlsx` |
| `Forecast.ipynb` | Forecast AR(1)/ARIMA, in-sample/out-of-sample | Complemento | `wheat.xlsx` |
| `MIA103 Clase 09 VECM.ipynb` | Johansen, VECM, cointegracion | Posterior a Clase 8/9 | `UK_rates.xlsx` |

## Practica 0 - Herramientas basicas

El notebook de practica 0 arma el ambiente de trabajo:

- `numpy` para arrays, secuencias y simulaciones numericas.
- `pandas` para DataFrames y lectura de archivos.
- `matplotlib` para graficos.

La idea practica es que casi todo el curso se trabaja como pipeline:

```text
cargar datos -> limpiar/transformar -> calcular variables -> graficar -> estimar modelo -> interpretar salida
```

El ejemplo de lectura:

```python
otro_df = pd.read_csv("ejemplo.csv")
```

es la base de lo que se repite luego con Excel y series temporales.

## Clase 1 en codigo - Retornos, distribuciones y momentos

### `MIA103_2026_Clase_01_01.ipynb`

Conecta directamente con la teoria de retornos. Lee precios del S&P500:

```python
df_archivo = pd.read_excel("SP500.xlsx", sheet_name=0)
```

Calcula retornos simples:

```python
df["Return_pct"] = df["Adj Close"].pct_change()
```

Y retornos logaritmicos con la diferencia de logaritmos. La interpretacion es:

- `pct_change()` implementa `P_t / P_{t-1} - 1`.
- `np.log(P_t) - np.log(P_{t-1})` implementa `ln(P_t / P_{t-1})`.
- Para retornos chicos, ambos se parecen.
- Para acumulacion temporal, los log-retornos se suman.

El notebook tambien calcula estadisticos descriptivos y graficos. Esto matchea con la teoria de media, varianza, desvio, asimetria y curtosis.

El test de Jarque-Bera aparece como chequeo de normalidad:

```text
H0: la distribucion es compatible con normalidad
HA: no es normal
```

Es importante porque buena parte de la inferencia clasica descansa en normalidad o aproximaciones asintoticas.

### `MIA103_2026_Clase_01_02_Mixtura.ipynb`

Este notebook profundiza distribuciones. Construye una mixtura de normales y calcula:

- pdf de normales.
- media de la mixtura.
- varianza de la mixtura.
- tercer momento centrado.
- cuarto momento centrado.
- asimetria y curtosis.

El punto conceptual: una distribucion puede parecer "normal" en el centro pero tener colas mas pesadas, asimetria o curtosis distinta. Eso importa en riesgo financiero porque la cola izquierda es donde aparecen perdidas extremas.

## Clase 2 en codigo - PBI, logaritmos, tendencia y ciclo

### `MIA103_2026_Clase_02_PBI_Argentina.ipynb`

Lee:

```python
df = pd.read_csv("year_gdp_Argentina.csv")
```

Luego trabaja con PBI real, calcula logaritmos y separa tendencia/ciclo. El flujo es:

```text
PBI real -> log(PBI) -> tendencia -> ciclo = log(PBI) - tendencia
```

La media movil centrada suaviza la serie y define una tendencia local. El ciclo queda como desvio respecto de esa tendencia.

El filtro HP aparece como:

```python
cycle, trend = hpfilter(df["log_pbi"], lamb=100)
```

La teoria detras:

- `trend` es el componente suavizado de largo plazo.
- `cycle` es la fluctuacion de corto/mediano plazo.
- `lambda` controla la suavidad de la tendencia.

### `MIA103_2026_Clase_02_Ejercicio_3.ipynb`

Repite la logica con PBI real de USA:

```python
df = pd.read_excel("MIA103_Clase_2.xlsx", sheet_name="PBI Real USA", usecols="B:C", skiprows=10, nrows=96)
cycle, trend = hpfilter(df["log_pbi"], lamb=100)
```

El valor practico es comparar una misma tecnica de descomposicion en otra economia/serie.

### `MIA103_2026_Clase_02_Ejercicios_1_y_2.ipynb`

Trabaja simulacion, mixturas y bootstrap. Sirve para reforzar que muchos conceptos del curso son distribucionales: no solo interesa un promedio, sino la forma de la distribucion muestral y la incertidumbre asociada.

## Clase 3 en codigo - Regresion lineal simple

### `MIA103_2026_Clase_03.ipynb`

Simula datos y estima un modelo por OLS:

```python
modelo = sm.OLS(y, x_matrix).fit()
```

La conexion teorica es directa:

- La teoria define `y_i = alpha + beta x_i + u_i`.
- El codigo genera `x`, `y`, agrega una columna de unos para el intercepto y estima con `statsmodels`.
- `fit()` calcula los estimadores MCO.
- `summary()` muestra coeficientes, errores estandar, estadisticos `t`, `p-values`, `R^2` y F.

Detalle importante: en `statsmodels`, si se quiere intercepto hay que agregarlo:

```python
X = sm.add_constant(x)
```

Si no se agrega, el modelo queda forzado a pasar por el origen y cambia la interpretacion de `R^2`, residuos y coeficientes.

### `MIA103_2026_Clase_03_Ejercicios.ipynb`

Usa datos de mercado:

```python
df = pd.read_excel("MIA103_Ejer_3_Datos.xlsx")
df["R_IBM"] = df["IBM"].pct_change()
df["R_SP"] = df["SP500"].pct_change()
modelo = sm.OLS(y, X).fit()
```

Esto aplica la teoria de retornos de Clase 1 y la regresion de Clase 3. La estructura es tipo CAPM:

```text
exceso de retorno del activo = alpha + beta * exceso de retorno del mercado + error
```

Interpretacion:

- `beta` mide sensibilidad del activo al mercado.
- `alpha` mide rendimiento promedio no explicado por el mercado.
- El `t-test` de `alpha = 0` pregunta si hay evidencia de rendimiento anormal.
- `R^2` indica que parte de la variabilidad del exceso de retorno del activo explica el mercado.

El notebook tambien usa valores criticos de t y p-values. Eso corresponde a la parte de inferencia de Clase 3.

### `MIA103_2026_Clase_03_profundizacion.ipynb`

Usa `ceo.xlsx` y profundiza regresion aplicada. El objetivo es leer una base real, estimar modelos, interpretar coeficientes y salidas de `statsmodels`. Funciona como puente hacia Clase 4: pasar de regresion simple a multiples explicativas y diagnosticos.

## Clase 4 en codigo - Regresion multiple, dummies, matriz, multicolinealidad y heterocedasticidad

### `MIA103_2026_Clase_04_01_Introduccion.ipynb`

Usa:

```python
df_casa = pd.read_excel("Ejemplo_Casa.xls", sheet_name="HPRICE", usecols="A:L")
```

El dataset de casas permite interpretar regresion multiple:

```text
precio = alpha + beta_1 * area + beta_2 * habitaciones + ... + error
```

El coeficiente de cada variable se lee "manteniendo constantes" las demas variables. Esto es el cambio clave respecto de regresion simple.

Tambien aparecen variables dummy con `pandas.get_dummies()`:

```python
pd.get_dummies(..., drop_first=True)
```

La opcion `drop_first=True` evita multicolinealidad perfecta cuando hay intercepto. Se deja una categoria base y los coeficientes de las dummies miden diferencias respecto de esa base.

### `MIA103_2026_Clase_04_02_Notacion_Matricial.ipynb`

Lleva la teoria matricial a codigo. La formula:

```text
betahat = (X'X)^(-1)X'y
```

se implementa con matrices de NumPy y se compara con `statsmodels`. El objetivo es ver que `statsmodels.OLS` no es una caja negra: esta resolviendo el mismo problema de MCO.

La condicion critica es que `X'X` sea invertible. Si no lo es, hay multicolinealidad perfecta.

### `MIA103_2026_Clase_04_03_Multicolinealidad_Heteroscedasticidad.ipynb`

Usa:

```python
dfmulti = pd.read_excel("CEO_ejemplo_multicolinealidad.xlsx", sheet_name="Hoja1", usecols="A:C")
df_casa = pd.read_excel("Ejemplo_Casa.xls", sheet_name="HPRICE", usecols="A:L")
```

La parte de multicolinealidad muestra que variables muy correlacionadas inflan errores estandar. El modelo puede tener buen ajuste global pero coeficientes individuales poco significativos.

La parte de heterocedasticidad implementa tests:

```python
from statsmodels.stats.diagnostic import het_white, het_breuschpagan
```

La teoria se traduce asi:

- White: busca patrones generales en residuos cuadrados.
- Breusch-Pagan: testea si variables especificas explican la varianza de errores.
- Goldfeld-Quandt: compara varianzas entre grupos ordenados.

Cuando hay heterocedasticidad, el problema principal no es necesariamente el sesgo de los betas, sino la inferencia: errores estandar, t-tests y p-values convencionales pueden ser incorrectos. Por eso se miran errores robustos o FGLS.

## Clase 6 en codigo - Procesos AR, MA, ARMA, ACF y PACF

### `MIA103_2026_Clase_06_Procesos_autorregresivos_ARMA.ipynb`

Este notebook simula procesos teoricos. Usa:

```python
from statsmodels.tsa.arima_process import ArmaProcess
from statsmodels.tsa.arima.model import ARIMA
from statsmodels.graphics.tsaplots import plot_acf, plot_pacf
```

Conecta con:

```text
AR(1):   y_t = rho y_{t-1} + epsilon_t
MA(1):   y_t = epsilon_t + theta epsilon_{t-1}
ARMA:    combina ambos
```

La parte mas importante es visual:

```python
plot_acf(y, lags=20)
plot_pacf(y, lags=20)
```

La ACF muestra autocorrelaciones por rezago. La PACF mide correlacion parcial, descontando rezagos intermedios.

Patrones utiles:

- AR: PACF corta, ACF decae.
- MA: ACF corta, PACF decae.
- ARMA: ambas decaen.

El notebook sirve para reconocer estructuras antes de estimar modelos sobre datos reales.

## Clase 7 en codigo - ADF, DFGLS y orden de integracion

### `MIA103_2026_Clase_07_Ejemplo_ADF_DFGLS.ipynb`

Usa precios de trigo:

```python
df = pd.read_excel("wheat.xlsx")
```

Aplica ADF:

```python
from statsmodels.tsa.stattools import adfuller
test = adfuller(y, regression="c", autolag="t-stat")
test_adf_ct = adfuller(y, regression="ct", autolag="t-stat", regresults=True)
```

La decision teorica:

```text
H0: la serie tiene raiz unitaria, no estacionaria
HA: la serie es estacionaria
```

Si el p-value es chico o el estadistico es mas negativo que el valor critico, se rechaza `H0`.

El parametro `regression` importa:

- `"n"`: sin constante.
- `"c"`: con constante.
- `"ct"`: con constante y tendencia.

Elegir mal los componentes deterministicos puede cambiar la conclusion.

El notebook tambien muestra lo que hay detras del ADF: una regresion auxiliar OLS para `Delta y_t` contra `y_{t-1}` y rezagos de diferencias.

DFGLS aparece con:

```python
from arch.unitroot import DFGLS
dfgls_c = DFGLS(y, trend="c")
dfgls_ct = DFGLS(y, trend="ct")
```

La logica practica para orden de integracion:

1. Testear la serie en niveles.
2. Si no se rechaza raiz unitaria, tomar primera diferencia.
3. Testear la primera diferencia.
4. Si la diferencia es estacionaria, la serie original es `I(1)`.

## Clase 8 y continuacion practica - VAR, forecast y VECM

En los PDFs hasta Clase 8 aparece la teoria de VAR:

```text
y_t = m + A_1 y_{t-1} + ... + A_p y_{t-p} + epsilon_t
```

El notebook de VECM es de Clase 9, pero se apoya directamente en el cierre de Clase 8: autovalores, integracion, cointegracion y forma de correccion de errores.

### `Forecast.ipynb`

Usa:

```python
df = pd.read_excel("wheat.xlsx")
ar1_model = ARIMA(y, order=(1,0,0))
```

Un `ARIMA(y, order=(1,0,0))` estima un AR(1). Sirve para pronosticos:

- In-sample: predice dentro de la muestra observada y permite evaluar ajuste.
- Out-of-sample: estima con una submuestra y pronostica periodos no usados en la estimacion.

La teoria de AR(1) dice que el pronostico converge hacia la media de largo plazo si el proceso es estacionario.

### `MIA103 Clase 09 VECM.ipynb`

Usa:

```python
df = pd.read_excel("UK_rates.xlsx").dropna()
var_model = VAR(rates)
from statsmodels.tsa.vector_ar.vecm import coint_johansen, VECM
vecm = VECM(rates, k_ar_diff=4, coint_rank=rank, deterministic="colo")
```

Aunque es posterior a Clase 8, encaja con la idea teorica:

- Primero se testea si las series son `I(1)` con ADF/DFGLS.
- Luego se seleccionan rezagos con un VAR en niveles.
- Despues se aplica Johansen para encontrar rango de cointegracion.
- Si hay cointegracion, se estima VECM.

Relacion entre VAR y VECM:

```text
VAR(p) en niveles con variables I(1)
=> VECM(p-1) en diferencias + termino de correccion de error
```

El termino de correccion de error mide el desvio respecto de la relacion de largo plazo. Los coeficientes de ajuste indican que variables reaccionan cuando el sistema esta fuera de equilibrio.

## Chequeo de consistencia teoria-practica

La correspondencia principal queda asi:

- Retornos simples/log y momentos: Clase 1 -> S&P500 y mixturas.
- Crecimiento, log(PBI), tendencia/ciclo: Clase 2 -> PBI Argentina/USA, media movil, HP filter.
- MCO simple, `R^2`, t-tests: Clase 3 -> simulacion OLS y ejercicios CAPM.
- MCO multiple, dummies, F-test, matriz: Clase 4 -> casas, dummies, formula matricial.
- Multicolinealidad y heterocedasticidad: Clase 4 -> CEO/casas, White, Breusch-Pagan, Goldfeld-Quandt.
- Ruido blanco, AR, MA, ARMA: Clase 6 -> simulaciones con `ArmaProcess`, ACF/PACF.
- Estacionariedad, ADF, DFGLS: Clase 7 -> wheat, orden de integracion.
- VAR, autovalores, Granger, cointegracion inicial: Clase 8 -> puente hacia VECM y forecast.

Lo unico que no puedo chequear completamente todavia es la ejecucion reproducible de notebooks que dependen de archivos externos. Para cerrar esa parte, conviene agregar los datasets listados arriba a una carpeta de datos o al mismo directorio donde los notebooks esperan encontrarlos.

