# Resumen teoria + practica - Codigos y clases

Este archivo conecta la teoria hasta Clase 8 con los notebooks de `Codigos`. Tambien incluyo los notebooks que aparecen como continuacion de Clase 9 o pronosticos, pero los marco como material posterior/complementario cuando exceden la teoria pedida hasta Clase 8.

## Estado de bases y reproducibilidad

Las bases fueron agregadas en `Bases de Datos MIA103/`. Eso ya permite interpretar mucho mejor los notebooks, pero hay un punto tecnico importante: varios notebooks leen archivos con nombres sueltos, por ejemplo `pd.read_excel("wheat.xlsx")`. Si el notebook se ejecuta desde `Codigos/`, o desde la raiz del repo, no va a encontrar automaticamente los archivos que estan dentro de `Bases de Datos MIA103/` salvo que se ajuste el path.

Estado exacto contra lo que espera el codigo:

| Archivo esperado por notebooks | Estado actual |
|---|---|
| `CEO_ejemplo_multicolinealidad.xlsx` | Esta en `Bases de Datos MIA103/` |
| `Ejemplo_Casa.xls` | Esta en `Bases de Datos MIA103/` |
| `UK_rates.xlsx` | Esta en `Bases de Datos MIA103/` |
| `ceo.xlsx` | Esta en `Bases de Datos MIA103/` |
| `wheat.xlsx` | Esta en `Bases de Datos MIA103/` |
| `SP500.xlsx` | No esta exacto; existe `SP500_.xlsx` |
| `MIA103_Ejer_3_Datos.xlsx` | No esta exacto; `ibm.xlsx` parece cubrir la parte IBM/SP500/RF |
| `MIA103_Clase_2.xlsx` | No esta exacto |
| `year_gdp_Argentina.csv` | No esta exacto |
| `ejemplo.csv` | No esta exacto |

Bases adicionales cargadas que no aparecen llamadas directamente por los notebooks actuales:

- `Precios_y_Dinero.xlsx`: contiene `MMYY`, `IPC`, `M` y `M_en_ARS`; parece material de precios/dinero o cointegracion posterior.
- `Ejemplo 9a Engle Granger.csv`: contiene `date`, `ftse100`, `sp500_usd`, `fx`; sirve para Engle-Granger/cointegracion.
- `mroz.xlsx` y `MROZ.pdf`: base y descripcion para modelos con variable dependiente dicotomica, probablemente Probit/Logit de Clase 9.
- `UK_rates.dta`: version Stata de tasas UK, paralela a `UK_rates.xlsx`.

Para que todos los notebooks corran sin tocar codigo, habria que copiar o enlazar las bases esperadas al directorio desde donde se ejecuta cada notebook. La alternativa mas prolija es editar los notebooks para usar un path comun, por ejemplo:

```python
DATA_DIR = "../Bases de Datos MIA103"
df = pd.read_excel(f"{DATA_DIR}/wheat.xlsx")
```

En esta revision no cambie notebooks; el objetivo fue analizar y documentar.

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

## Analisis tecnico general de los codigos

Los notebooks tienen una estructura bastante consistente:

```text
imports -> carga de datos/simulacion -> transformaciones -> graficos -> estimacion -> interpretacion
```

Las librerias principales son:

- `numpy`: simulacion, logaritmos, algebra, secuencias.
- `pandas`: tablas, lectura de bases, transformaciones, retornos y rezagos.
- `matplotlib` y `seaborn`: visualizacion.
- `scipy.stats`: distribuciones, Jarque-Bera, valores criticos.
- `statsmodels`: MCO, ARIMA, VAR, diagnosticos.
- `arch.unitroot`: DFGLS.
- `sklearn.linear_model`: aparece en ejercicios de regresion, aunque la inferencia principal se apoya en `statsmodels`.

El paquete importante para interpretacion econometrica es `statsmodels`, porque devuelve no solo coeficientes sino errores estandar, `t`, `p-values`, `R^2`, F, diagnosticos y resultados especificos de series de tiempo.

### Patron 1 - Transformaciones con rezagos

Muchas operaciones descansan en alinear una observacion con su pasado:

```python
df["Return_pct"] = df["Adj Close"].pct_change()
df["Return_log"] = np.log(df["Adj Close"] / df["Adj Close"].shift(1))
```

`pct_change()` calcula `P_t / P_{t-1} - 1`. `shift(1)` mueve la serie un periodo para construir manualmente el rezago. Despues de estas operaciones aparece un primer valor faltante, porque no hay dato previo para el primer periodo. Por eso suele venir:

```python
df = df.dropna()
```

Esto no es un detalle menor: en series de tiempo, perder una observacion por diferencias o rezagos es normal, pero hay que verificar que `X` e `y` queden alineados.

### Patron 2 - Intercepto en `statsmodels`

En `statsmodels`, el intercepto no se agrega solo si uno arma la matriz manualmente. Por eso aparece:

```python
X = sm.add_constant(x)
modelo = sm.OLS(y, X).fit()
```

Si no se agrega la constante, el modelo queda sin intercepto. Eso cambia:

- interpretacion de coeficientes;
- residuos;
- `R^2`;
- tests de hipotesis.

Este es uno de los puntos mas importantes para no equivocarse copiando codigo.

### Patron 3 - Simulacion vs base real

Hay notebooks autocontenidos, que simulan datos y corren sin bases externas:

- `MIA103_2026_Clase_01_02_Mixtura.ipynb`
- `MIA103_2026_Clase_02_Ejercicios_1_y_2.ipynb`
- `MIA103_2026_Clase_03.ipynb`
- `MIA103_2026_Clase_04_02_Notacion_Matricial.ipynb`
- `MIA103_2026_Clase_06_Procesos_autorregresivos_ARMA.ipynb`

Y hay notebooks aplicados que dependen de datos:

- S&P500, IBM, PBI, casas, trigo, tasas UK.

Para simulaciones conviene fijar semilla:

```python
np.random.seed(123)
```

Si no, los numeros cambian en cada corrida. La teoria no cambia, pero los resultados puntuales pueden variar.

### Patron 4 - Graficos antes de estimar

Los notebooks suelen graficar antes de correr tests o modelos. Eso esta bien: en series de tiempo, el grafico ayuda a detectar tendencia, quiebres, outliers, volatilidad cambiante y no estacionariedad.

Pero el grafico no reemplaza al test. Por ejemplo, una serie con tendencia deterministica y una con raiz unitaria pueden verse parecidas. Por eso despues aparecen ADF/DFGLS.

### Patron 5 - Outputs embebidos

Los notebooks guardan muchas salidas. Eso permite leer resultados aunque falte una base o una libreria, pero tambien puede generar confusion: una salida embebida puede no corresponder a la ultima version del codigo si alguien edito una celda y no la volvio a ejecutar.

Regla sana:

```text
Kernel -> Restart & Run All
```

y recien ahi confiar en los resultados.

## Analisis notebook por notebook

### `MIA103_2026_Clase_00_Intro_practica.ipynb`

Es un notebook de infraestructura. El foco no es teoria econometrica sino aprender el flujo de trabajo: crear arrays, DataFrames, graficar y leer archivos.

El punto tecnico a cuidar es `ejemplo.csv`: el codigo lo espera con ese nombre exacto. En las bases nuevas no aparece exacto.

### `MIA103_2026_Clase_01_01.ipynb`

Este notebook mezcla dos fuentes:

```python
df_archivo = pd.read_excel("SP500.xlsx", sheet_name=0)
sp500 = yf.download("^GSPC", ...)
```

Primero intenta leer un Excel, pero despues descarga datos desde Yahoo Finance con `yfinance`. Eso implica dos cosas:

- si no hay internet, la parte `yf.download()` puede fallar;
- si se quiere usar solo la base subida, hay que adaptar el codigo a `SP500_.xlsx`.

La base cargada `SP500_.xlsx` tiene hojas `Datos_SP500`, `Retornos`, `Estadisticas_Descriptivas` y `QQ-Plot`. La primera hoja trae `Date` y `Close`, no exactamente `Adj Close`. Entonces, para usarla con el codigo actual, habria que renombrar:

```python
df = pd.read_excel(DATA_DIR / "SP500_.xlsx", sheet_name=" Datos_SP500")
df = df.rename(columns={"Close": "Adj Close"})
```

Analisis econometrico: el notebook hace bien el puente entre precios y retornos. Los precios suelen ser no estacionarios; los retornos suelen ser mucho mas cercanos a estacionarios. Por eso se calcula:

```python
Return_pct
Return_log
```

El Jarque-Bera sobre retornos chequea si la distribucion es normal. En activos financieros, lo esperable muchas veces es rechazar normalidad por colas pesadas.

### `MIA103_2026_Clase_01_02_Mixtura.ipynb`

Es teorico-computacional y no depende de datos. Sirve para entender por que normalidad es una idealizacion.

La parte valiosa es que no se queda solo en graficar normales: calcula momentos de una mixtura. Eso muestra que combinar poblaciones normales puede producir una distribucion con curtosis/asimetria distinta de una normal simple.

Este notebook dialoga directamente con Jarque-Bera: si los retornos financieros son mezcla de regimes, shocks o volatilidades, la normal simple puede quedar corta.

### `MIA103_2026_Clase_02_PBI_Argentina.ipynb`

El codigo espera:

```python
df = pd.read_csv("year_gdp_Argentina.csv")
```

Ese archivo no aparece exacto en `Bases de Datos MIA103/`. Cuando este disponible, el notebook deberia producir:

- grafico de PBI real en nivel;
- `log_pbi`;
- crecimiento logaritmico promedio;
- tendencia por media movil;
- ciclo como desvio respecto de tendencia;
- HP filter.

La linea clave:

```python
cycle, trend = hpfilter(df["log_pbi"], lamb=100)
```

Para datos anuales, `lambda=100` es una eleccion comun. Para datos trimestrales suele verse `1600`, y para mensuales valores mas altos. Esto hay que tenerlo presente: `lambda` depende de la frecuencia.

### `MIA103_2026_Clase_02_Ejercicio_3.ipynb`

Es la misma logica aplicada a PBI de USA. El codigo espera `MIA103_Clase_2.xlsx`, que no aparece exacto.

Conceptualmente, es importante porque ayuda a ver que tendencia/ciclo no es una propiedad unica: depende de la economia, frecuencia, muestra y metodo de filtrado.

### `MIA103_2026_Clase_03.ipynb`

Es el notebook mas limpio para entender MCO desde simulacion:

```python
modelo = sm.OLS(y, x_matrix).fit()
```

Como los datos son simulados, se puede comparar:

- parametro verdadero usado para generar datos;
- estimacion MCO;
- residuos;
- salida de `summary()`.

Este tipo de ejercicio es ideal para entender que `betahat` es aleatorio: si simulo otra muestra, cambia. La teoria de insesgadez dice que en promedio le pega al parametro, no que cada muestra individual sea exacta.

### `MIA103_2026_Clase_03_Ejercicios.ipynb`

El codigo espera:

```python
pd.read_excel("MIA103_Ejer_3_Datos.xlsx")
```

No esta exacto, pero `ibm.xlsx` parece contener la informacion necesaria: `IBM_price`, `S&P500_index` y `3mTB (RF) anualizada`.

El bloque central:

```python
df["R_IBM"] = df["IBM"].pct_change()
df["R_SP"] = df["SP500"].pct_change()
df["Rf"] = (1 + df["3mTB"] / 100) ** (1 / 12) - 1
df["Ribm-Rf"] = df["R_IBM"] - df["Rf"]
df["Rsp-Rf"] = df["R_SP"] - df["Rf"]
modelo = sm.OLS(y, X).fit()
```

Esto arma un CAPM empirico:

```text
R_IBM - R_f = alpha + beta (R_M - R_f) + u
```

Lectura:

- `beta`: riesgo sistematico de IBM respecto del mercado.
- `alpha`: exceso de retorno no explicado por el mercado.
- test de `alpha = 0`: pregunta si hay rendimiento anormal.
- test de `beta = 1`: pregunta si IBM se mueve uno a uno con el mercado.
- `R^2`: cuanto del exceso de retorno de IBM explica el exceso de retorno del mercado.

Punto tecnico bueno: anualiza/mensualiza la tasa libre de riesgo correctamente con potencia:

```python
(1 + tasa_anual) ** (1/12) - 1
```

No divide simplemente por 12, que seria una aproximacion.

### `MIA103_2026_Clase_03_profundizacion.ipynb`

Usa `ceo.xlsx`, que ahora esta cargado. La base tiene `Ganancias` y `Compensacion_CEO`.

Este notebook es util para entender que una regresion simple aplicada puede tener buena interpretacion inicial pero tambien problemas:

- relacion no lineal;
- outliers;
- heterocedasticidad;
- variables omitidas.

Por eso conecta naturalmente con Clase 4.

### `MIA103_2026_Clase_04_01_Introduccion.ipynb`

Usa `Ejemplo_Casa.xls`, que esta cargado, aunque para correrlo en Python hace falta soporte `xlrd`.

El codigo usa regresiones multiples e interacciones:

```python
regmul = sm.OLS(y, X).fit()
regpura = sm.OLS(...).fit()
regprod = sm.OLS(...).fit()
```

Tambien usa dummies:

```python
X2 = pd.get_dummies(df_filtrado, columns=["BANOS"], drop_first=True, dtype=int)
```

Lectura conceptual:

- Una dummy cambia interceptos entre grupos.
- Una interaccion cambia pendientes entre grupos.
- `drop_first=True` evita la trampa de dummies si hay constante.

En regresion multiple, el analisis correcto no es "esta variable explica mucho sola", sino "esta variable aporta explicacion manteniendo constantes las demas".

### `MIA103_2026_Clase_04_02_Notacion_Matricial.ipynb`

Es un notebook de verificacion teorica. Muestra que MCO es algebra lineal:

```text
betahat = (X'X)^(-1) X'y
```

El valor pedagogico esta en comparar el resultado manual de NumPy contra `statsmodels`. Si coinciden, queda claro que `statsmodels` automatiza el calculo, no cambia la teoria.

Riesgo tecnico: si `X'X` no es invertible, la formula falla. Ese fallo no es un bug de Python: es multicolinealidad perfecta.

### `MIA103_2026_Clase_04_03_Multicolinealidad_Heteroscedasticidad.ipynb`

Usa `CEO_ejemplo_multicolinealidad.xlsx` y `Ejemplo_Casa.xls`, ambos cargados.

La base `CEO_ejemplo_multicolinealidad.xlsx` tiene `Gan`, `Gan_10` y `Comp`. `Gan_10` es una transformacion casi mecanica de `Gan`, por eso es ideal para mostrar multicolinealidad.

El codigo de heterocedasticidad:

```python
white_test = sms.het_white(regre_casa.resid, regre_casa.model.exog)
lm_stat, lm_pval, f_stat, f_pval = het_white(regre_casa.resid, X)
bp_stat, bp_pval, _, _ = het_breuschpagan(regre_casa.resid, X)
```

Lectura:

- Si `p-value` bajo en White/BP, rechazo homocedasticidad.
- Si hay heterocedasticidad, los coeficientes MCO pueden seguir siendo razonables, pero la inferencia clasica queda sospechada.
- Conviene comparar errores estandar convencionales vs robustos.

Extension natural que podria agregarse al notebook:

```python
regre_casa.get_robustcov_results(cov_type="HC1")
```

Eso permitiria ver como cambian los `t` y `p-values`.

### `MIA103_2026_Clase_06_Procesos_autorregresivos_ARMA.ipynb`

Es autocontenido. Simula procesos AR, MA y ARMA:

```python
from statsmodels.tsa.arima_process import ArmaProcess
from statsmodels.graphics.tsaplots import plot_acf, plot_pacf
```

El valor del notebook es entrenar el ojo:

- AR: persistencia por rezagos de la propia variable.
- MA: persistencia corta por shocks pasados.
- ARMA: mezcla de ambos.

Punto tecnico importante: `statsmodels` suele representar el polinomio AR con signo invertido. Para un AR(1) `y_t = rho y_{t-1} + e_t`, muchas funciones esperan algo como:

```python
ar = np.array([1, -rho])
```

Si se pone `+rho` por error, se simula otro proceso.

### `MIA103_2026_Clase_07_Ejemplo_ADF_DFGLS.ipynb`

Usa `wheat.xlsx`, ahora cargado. La base trae `yearmm`, `wheat_srw` y `wheat_hrw`.

El flujo es correcto:

```text
serie en niveles -> ADF/DFGLS -> si no estacionaria, diferencia -> nuevo test
```

Lineas clave:

```python
test = adfuller(y, regression="c", autolag="t-stat")
test_adf_ct = adfuller(y, regression="ct", autolag="t-stat", regresults=True)
dfgls_ct = DFGLS(y, trend="ct")
```

La parte mas sofisticada del notebook es que no solo llama `adfuller`; tambien arma la regresion auxiliar OLS del ADF. Eso ayuda a entender que el test no es magia: es una regresion sobre diferencias, nivel rezagado, componentes deterministicos y rezagos de diferencias.

Riesgo practico: para `DFGLS` hace falta el paquete `arch`.

### `Forecast.ipynb`

Tambien usa `wheat.xlsx`. Estima:

```python
ARIMA(y, order=(1,0,0))
```

Eso es un AR(1) en la implementacion moderna de `statsmodels`. El notebook compara prediccion dentro de muestra y fuera de muestra.

Lectura teorica:

- In-sample sirve para ver ajuste, pero puede ser optimista.
- Out-of-sample evalua capacidad predictiva real.
- Si el AR(1) es estacionario, los pronosticos de largo plazo convergen a la media incondicional.

### `MIA103 Clase 09 VECM.ipynb`

Es posterior al pedido "hasta clase 8", pero usa directamente la puerta que abre la Clase 8.

La base `UK_rates.xlsx` esta cargada y contiene `dates`, `mth1`, ..., `mth12`, o sea tasas por distintos vencimientos.

El flujo:

```python
test = adfuller(serie, regression="ct", autolag="t-stat")
test = DFGLS(rates[mes].dropna(), trend="ct")
var_model = VAR(rates)
lag_order_results = var_model.select_order(maxlags=12)
jres = coint_johansen(rates, det_order=1, k_ar_diff=4)
vecm = VECM(rates, k_ar_diff=4, coint_rank=rank, deterministic="colo")
```

La secuencia esta bien planteada:

1. Ver si las tasas son `I(1)`.
2. Ver si las diferencias son `I(0)`.
3. Elegir rezagos como VAR.
4. Usar Johansen para rango de cointegracion.
5. Estimar VECM si hay cointegracion.
6. Hacer diagnosticos de residuos.

Punto conceptual clave: en VECM, `k_ar_diff` es un rezago menos que el VAR en niveles. Si el VAR elegido es `p`, el VECM usa `p - 1` rezagos en diferencias.

## Recomendaciones practicas para dejar el repo mas ejecutable

Si la idea es usar estos notebooks durante la cursada, conviene hacer una de estas dos cosas:

1. Editar cada notebook para que lea desde `Bases de Datos MIA103/`.
2. Crear copias o enlaces con los nombres exactos que esperan los notebooks.

Mi recomendacion es la primera, porque deja clara la organizacion del repo. Un patron simple:

```python
from pathlib import Path

DATA_DIR = Path("../Bases de Datos MIA103")
df = pd.read_excel(DATA_DIR / "wheat.xlsx")
```

Si se ejecuta desde la raiz del repo, el path seria:

```python
DATA_DIR = Path("Bases de Datos MIA103")
```

Tambien conviene tener una celda inicial de dependencias:

```python
import numpy as np
import pandas as pd
import statsmodels.api as sm
```

y, cuando corresponda:

```python
from arch.unitroot import DFGLS
```

En este entorno de revision, `pandas` esta instalado, pero no estaban disponibles `openpyxl` y `xlrd`, que son necesarios para leer `.xlsx` y `.xls` con `pandas`. En una maquina local, eso se arregla con:

```bash
pip install openpyxl xlrd arch
```

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

Con las bases nuevas, la interpretacion de los codigos queda mucho mas completa. Lo que todavia falta para una ejecucion reproducible perfecta es alinear paths/nombres exactos y asegurar dependencias (`openpyxl`, `xlrd`, `arch`). La teoria y el codigo matchean bien: los notebooks implementan las transformaciones y modelos que aparecen en las clases, y los materiales de Clase 9/VECM son una continuacion natural de lo que Clase 8 deja planteado.
