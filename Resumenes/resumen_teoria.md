# Modelado Estocástico — teoría, fórmulas y mapa de cursada

> Una guía para estudiar con una secuencia única: **pregunta → modelo → supuesto → diagnóstico → interpretación**.

\[
\boxed{\text{pregunta} \;\longrightarrow\; \text{modelo} \;\longrightarrow\; \text{condiciones} \;\longrightarrow\; \text{conclusión}}
\]

Usamos el operador de rezago \(L\), definido por \(Lx_t=x_{t-1}\). Esta guía conecta las fórmulas de los PDFs con el código que las implementa.

---

## Mapa PDF ↔ Python ↔ habilidad

| Unidad | PDF | Notebook(s) | Qué se debe saber hacer |
|---|---|---|---|
| 0. Herramientas | — | `MIA103_2026_Clase_00_Intro_practica.ipynb` | Cargar, limpiar, indexar fechas y graficar. |
| 1. Distribuciones | `MIA103_Clase_1.pdf` | `MIA103_2026_Clase_01_01.ipynb`, `MIA103_2026_Clase_01_02_Mixtura.ipynb` | Retornos, momentos, normalidad, mixturas y QQ-plot. |
| 2. Tendencia y ciclo | `MIA103_Clase_2.pdf` | `MIA103_2026_Clase_02_PBI_Argentina.ipynb`, `MIA103_2026_Clase_02_Ejercicios_1_y_2.ipynb`, `MIA103_2026_Clase_02_Ejercicio_3.ipynb` | Transformar niveles y separar tendencia/ciclo. |
| 3. MCO simple | `MIA103_Clase_3.pdf` | `MIA103_2026_Clase_03.ipynb`, `MIA103_2026_Clase_03_Ejercicios.ipynb`, `MIA103_2026_Clase_03_profundización.ipynb` | Estimar e interpretar MCO, \(t\), \(F\), \(R^2\). |
| 4–5. MCO múltiple | `MIA103_Clase_4.pdf`, `Matrix.pdf` | `MIA103_2026_Clase_04_01_Introducción.ipynb`, `MIA103_2026_Clase_04_02_Notación_Matricial.ipynb`, `MIA103_2026_Clase_04_03_Multicolinealidad_Heteroscedasticidad.ipynb` | Efectos parciales, dummies, matrices y diagnósticos. |
| 6. ARMA | `MIA103_Clase_6.pdf` | `Codigos/MIA103_2026_Clase_06_Procesos_autorregresivos_ARMA.ipynb`, `Practicas/MIA103_2026_Clase_06_Resolución_Ejercitación_5.ipynb` | AR, MA, ARMA, ACF/PACF e impulso-respuesta. |
| 7. Raíz unitaria | `MIA103_Clase_7_.pdf` | `MIA103_2026_Clase_07_Ejemplo_ADF_DFGLS.ipynb` | \(I(0)\), \(I(1)\), ADF, DFGLS y BIC. |
| 8. VAR | `MIA103_Clase_8_VAR_.pdf` | `MIA103 Clase 08 Introducción VAR.ipynb`, `MIA103 Clase 08 Estacionariedad Invertibilidad.ipynb` | Rezagos, estabilidad, residuos y Granger. |
| 9. VECM y pronóstico | `MIA103_Clase_9_Anual 2026.pdf`, `Pronósticos MIA103 Anual 2026.pdf` | `MIA103 Clase 09 VECM.ipynb`, `Forecast.ipynb` | Cointegración, VECM y pronósticos. |
| 9. Respuesta binaria | `MIA103_Clase_9_Probit_Logit.pdf` | Material de la unidad | Logit, probit y efectos marginales. |

### Cómo estudiar cada tema

1. Escribir el modelo matemático antes de abrir Python.
2. Identificar la hipótesis o condición que corresponde verificar.
3. Ejecutar el notebook asociado de arriba hacia abajo.
4. Traducir la salida numérica a una conclusión con alcance limitado.
5. Usar `Practicas/` para intentar y `Practicas_Resueltas/` solo para contrastar.

---

# I. Distribuciones, retornos y mixturas

## 1. Retornos simples y logarítmicos

Para un precio \(P_t\):

\[
R_t=\frac{P_t-P_{t-1}}{P_{t-1}}=\frac{P_t}{P_{t-1}}-1,
\qquad
r_t=\log\!\left(\frac{P_t}{P_{t-1}}\right)=\Delta\log(P_t).
\]

\[
r_t=\log(1+R_t),
\qquad
R_t=e^{r_t}-1.
\]

Los log-retornos se suman en el tiempo:

\[
\sum_{t=1}^{T}r_t=\log\!\left(\frac{P_T}{P_0}\right).
\]

Los retornos simples se componen:

\[
1+R_{0,T}=\prod_{t=1}^{T}(1+R_t).
\]

Para movimientos pequeños, \(r_t\approx R_t\). Para movimientos grandes no es una igualdad exacta.

**Código asociado.** En `Clase_01_01`, `pct_change()` calcula retornos simples y `np.log(precio).diff()` log-retornos.

## 2. Momentos, QQ-plot y Jarque–Bera

Sea \(\mu=\mathbb E[X]\):

\[
\operatorname{Var}(X)=\mathbb E[(X-\mu)^2],
\qquad
\gamma_1=\frac{\mathbb E[(X-\mu)^3]}{\sigma^3},
\qquad
\kappa=\frac{\mathbb E[(X-\mu)^4]}{\sigma^4}.
\]

| Medida | Normal | Lectura |
|---|---:|---|
| Asimetría \(\gamma_1\) | \(0\) | Positiva: cola derecha más relevante; negativa: cola izquierda más relevante. |
| Curtosis \(\kappa\) | \(3\) | \(\kappa>3\): leptocurtosis, más masa relativa en colas. |
| Exceso de curtosis | \(0\) | \(\kappa-3\); revisar qué convención usa la función. |

Un QQ-plot compara cuantiles observados con cuantiles normales. Alineación aproximada sugiere normalidad razonable; desvíos sistemáticos en extremos indican diferencias de cola.

El test Jarque–Bera es:

\[
JB=\frac{n}{6}\left[S^2+\frac{(K-3)^2}{4}\right],
\qquad
H_0:\text{ normalidad}.
\]

Si el p-value es menor que \(\alpha\), se rechaza normalidad. No rechazar \(H_0\) no prueba que la distribución sea normal.

**Código asociado.** `Clase_01_01` calcula descriptivos y test; el QQ-plot se construye con `stats.probplot(serie, dist="norm", plot=ax)`.

## 3. Mixturas de normales

Una mixtura elige una componente; no suma variables aleatorias:

\[
f_X(x)=\sum_{i=1}^{m}w_i f_i(x),
\qquad w_i\ge0,
\qquad \sum_iw_i=1.
\]

Si \(X_i\sim\mathcal N(\mu_i,\sigma_i^2)\):

\[
\mu_X=\sum_iw_i\mu_i,
\qquad
\operatorname{Var}(X)=\sum_iw_i\left[\sigma_i^2+(\mu_i-\mu_X)^2\right].
\]

La varianza combina dispersión dentro de cada régimen y distancia entre sus medias. Por eso una mixtura puede tener colas pesadas aunque todas las componentes sean normales.

Para simular dos componentes: generar \(U\sim U(0,1)\), y elegir \(X_1\) si \(U<w_1\), o \(X_2\) en otro caso. En Python: `np.where(U < w1, x1, x2)`.

**Código asociado.** `Clase_01_02_Mixtura` implementa densidad, simulación y gráficos.

---

# II. Series macroeconómicas: crecimiento, tendencia y ciclo

## 4. Niveles y transformaciones

Para una serie de nivel \(Y_t\):

\[
g_t=\frac{Y_t-Y_{t-1}}{Y_{t-1}},
\qquad
g_t^{\log}=\Delta\log(Y_t).
\]

Una tasa interanual compara con la misma fecha del año previo; una anualizada reescala una variación mensual o trimestral. No son equivalentes.

**Código asociado.** `Clase_02_PBI_Argentina` trabaja el PBI real en niveles, logaritmos y gráficos temporales.

## 5. Tendencia y ciclo

\[
y_t=\tau_t+c_t,
\]

donde \(\tau_t\) es tendencia y \(c_t\) ciclo. Una tendencia determinística es:

\[
y_t=\alpha+\beta t+u_t.
\]

Una media móvil centrada es:

\[
\widetilde y_t=\frac{1}{2k+1}\sum_{j=-k}^{k}y_{t+j}.
\]

Describe el pasado, pero usa información futura y pierde extremos; no es pronóstico de tiempo real.

El filtro Hodrick–Prescott estima tendencia resolviendo:

\[
\min_{\{\tau_t\}}
\sum_{t=1}^{T}(y_t-\tau_t)^2+
\lambda\sum_{t=2}^{T-1}
\left[(\tau_{t+1}-\tau_t)-(\tau_t-\tau_{t-1})\right]^2.
\]

Mayor \(\lambda\) implica una tendencia más suave. Es un filtro descriptivo, sensible a \(\lambda\) y a los extremos muestrales.

**Código asociado.** `Clase_02_PBI_Argentina` usa `hpfilter` y visualiza el ciclo.

---

# III. Regresión lineal

## 6. MCO simple, supuesto de exogeneidad e inferencia

\[
y_i=\beta_0+\beta_1x_i+u_i.
\]

El error \(u_i\) no es el residuo estimado \(\widehat u_i=y_i-\widehat y_i\). MCO minimiza:

\[
SSR=\sum_{i=1}^{n}\widehat u_i^2.
\]

\[
\widehat\beta_1=
\frac{\sum_i(x_i-\bar x)(y_i-\bar y)}{\sum_i(x_i-\bar x)^2},
\qquad
\widehat\beta_0=\bar y-\widehat\beta_1\bar x.
\]

La condición central para interpretación causal es:

\[
\mathbb E[u_i\mid x_i]=0.
\]

Sin exogeneidad, puede existir sesgo por variables omitidas, simultaneidad o error de medición. Un p-value pequeño no soluciona endogeneidad.

\[
R^2=1-\frac{SSR}{TSS},
\qquad
t=\frac{\widehat\beta_j-\beta_{j,0}}{se(\widehat\beta_j)}.
\]

\(R^2\) mide ajuste dentro de muestra: no prueba causalidad ni buen pronóstico. Para un intervalo de confianza:

\[
\widehat\beta_j\pm t_{1-\alpha/2,df}\,se(\widehat\beta_j).
\]

**Código asociado.** `Clase_03` estima el modelo; `Clase_03_profundización` desarma `params`, residuos y sumas de cuadrados de `statsmodels`.

## 7. Regresión múltiple, dummies e interacciones

\[
y_i=\beta_0+\beta_1x_{1i}+\cdots+\beta_kx_{ki}+u_i.
\]

\(\beta_j\) es el efecto parcial de \(x_j\) sobre \(y\), manteniendo constantes los demás regresores.

Con una dummy \(D_i\):

\[
y_i=\beta_0+\beta_1x_i+\delta D_i+\gamma(D_ix_i)+u_i.
\]

| Grupo | Intercepto | Pendiente de \(x\) |
|---|---:|---:|
| \(D=0\) | \(\beta_0\) | \(\beta_1\) |
| \(D=1\) | \(\beta_0+\delta\) | \(\beta_1+\gamma\) |

Para restricciones conjuntas, el test apropiado es \(F\):

\[
F=\frac{(SSR_R-SSR_{UR})/q}{SSR_{UR}/(n-k-1)}.
\]

**Código asociado.** Clase 4 introduce modelos múltiples, dummies y notación matricial; clase 5 muestra problemas de especificación.

## 8. Notación matricial y diagnósticos

\[
\mathbf y=\mathbf X\boldsymbol\beta+\mathbf u,
\qquad
\widehat{\boldsymbol\beta}=(\mathbf X'\mathbf X)^{-1}\mathbf X'\mathbf y.
\]

La inversa existe si \(\mathbf X\) tiene rango completo. Con

\[
\mathbf H=\mathbf X(\mathbf X'\mathbf X)^{-1}\mathbf X',
\qquad
\mathbf M=\mathbf I-\mathbf H,
\]

se tiene \(\widehat{\mathbf y}=\mathbf H\mathbf y\) y \(\widehat{\mathbf u}=\mathbf M\mathbf y\). Propiedades: \(H^2=H\), \(M^2=M\), \(X'\widehat u=0\).

Heterocedasticidad significa:

\[
\operatorname{Var}(u_i\mid x_i)=\sigma_i^2,
\]

en vez de una varianza constante. Bajo exogeneidad, MCO puede seguir siendo insesgado, pero la inferencia clásica falla; se usan errores estándar robustos.

Multicolinealidad alta aumenta varianzas e intervalos; multicolinealidad perfecta impide estimar. White y Breusch–Pagan prueban, esencialmente:

\[
H_0:\text{ homocedasticidad},
\qquad H_1:\text{ heterocedasticidad}.
\]

**Código asociado.** `Clase_04_02_Notación_Matricial` implementa la álgebra; `Clase_04_03_Multicolinealidad_Heteroscedasticidad` ejecuta los diagnósticos y errores robustos.

---

# IV. Procesos estocásticos univariados

## 9. Ruido blanco y estacionariedad débil

\[
\mathbb E[\varepsilon_t]=0,
\qquad
\operatorname{Var}(\varepsilon_t)=\sigma_\varepsilon^2<\infty,
\qquad
\operatorname{Cov}(\varepsilon_t,\varepsilon_{t-h})=0\;(h\neq0).
\]

Esto define ruido blanco; no exige normalidad. Una serie \(y_t\) es débilmente estacionaria si su media y varianza son constantes y su autocovarianza depende solo del rezago:

\[
\mathbb E[y_t]=\mu,
\qquad
\operatorname{Var}(y_t)=\gamma(0),
\qquad
\operatorname{Cov}(y_t,y_{t-h})=\gamma(h).
\]

## 10. AR, MA y ARMA

\[
y_t=c+\phi y_{t-1}+\varepsilon_t
\quad\text{es AR(1), estacionario si}\quad |\phi|<1.
\]

\[
y_t=\mu+\varepsilon_t+\theta_1\varepsilon_{t-1}+\cdots+\theta_q\varepsilon_{t-q}
\quad\text{es MA(q).}
\]

\[
\phi(L)y_t=c+\theta(L)\varepsilon_t
\quad\text{es ARMA(p,q),}
\]

con

\[
\phi(L)=1-\phi_1L-\cdots-\phi_pL^p,
\qquad
\theta(L)=1+\theta_1L+\cdots+\theta_qL^q.
\]

| Propiedad | Polinomio | Criterio |
|---|---|---|
| Estacionariedad | \(\phi(z)\) | Todas las raíces tienen \(|z|>1\). |
| Invertibilidad | \(\theta(z)\) | Todas las raíces tienen \(|z|>1\). |

Todo MA finito es estacionario. La invertibilidad permite representar los shocks de manera única a partir de la historia observable.

**Código asociado.** `Clase_06_Procesos_autorregresivos_ARMA` simula los procesos. `Clase 08 Estacionariedad Invertibilidad` devuelve `arroots`, `maroots`, `isstationary` e `isinvertible` mediante `ArmaProcess`.

## 11. ACF, PACF e impulso-respuesta

| Proceso ideal | ACF | PACF |
|---|---|---|
| AR(p) | Decae | Se corta después de \(p\). |
| MA(q) | Se corta después de \(q\). | Decae. |
| ARMA(p,q) | Decae | Decae. |

Son reglas orientativas, no pruebas exactas en muestras finitas.

Para un ARMA estacionario:

\[
y_t-\mu=\sum_{j=0}^{\infty}\psi_j\varepsilon_{t-j}.
\]

\(\psi_j\) es la respuesta a un shock unitario luego de \(j\) períodos. Para

\[
y_t=\phi_1y_{t-1}+\phi_2y_{t-2}+\varepsilon_t+\theta_1\varepsilon_{t-1},
\]

\[
\psi_0=1,
\qquad
\psi_1=\phi_1+\theta_1,
\qquad
\psi_j=\phi_1\psi_{j-1}+\phi_2\psi_{j-2}\quad(j\ge2).
\]

**Cuidado de signos.** Si la ecuación tiene \(-0.32y_{t-2}\), entonces \(\phi_2=-0.32\). En `statsmodels`, el vector AR se ingresa con signos invertidos respecto de los coeficientes de la ecuación.

---

# V. Raíces unitarias, ADF y orden de integración

## 12. \(I(0)\), \(I(1)\) y random walk

Una serie es \(I(0)\) si es estacionaria en niveles. Es \(I(1)\) si no lo es en niveles, pero sí después de una diferencia:

\[
\Delta y_t=y_t-y_{t-1}=(1-L)y_t.
\]

El random walk:

\[
y_t=y_{t-1}+\varepsilon_t,
\qquad \Delta y_t=\varepsilon_t,
\]

tiene raíz unitaria y shocks permanentes. Una serie con tendencia determinística,

\[
y_t=\alpha+\beta t+u_t,
\qquad u_t\sim I(0),
\]

es diferente: los shocks se disipan alrededor de una trayectoria determinística.

## 13. Test ADF y DFGLS

ADF estima:

\[
\Delta y_t=\alpha+\delta t+\gamma y_{t-1}
+\sum_{i=1}^{p}\psi_i\Delta y_{t-i}+u_t.
\]

\[
H_0:\gamma=0\quad\text{(raíz unitaria)},
\qquad
H_1:\gamma<0\quad\text{(estacionariedad)}.
\]

El estadístico ADF usa valores críticos especiales: no se interpreta con una tabla \(t\) común. En `statsmodels`, `autolag="BIC"` elige el número de rezagos que minimiza:

\[
BIC=-2\log(\widehat L)+k\log(T).
\]

| `regression` | Componentes | Uso razonable |
|---|---|---|
| `"n"` | Ninguno | Serie con media cero por teoría. |
| `"c"` | Constante | Serie alrededor de media no nula. |
| `"ct"` | Constante y tendencia | Tendencia determinística plausible. |

Si el p-value es menor que \(\alpha\), se rechaza raíz unitaria. Si no se rechaza, no se demuestra que exista raíz unitaria: solo no hay evidencia suficiente contra ella.

DFGLS quita eficientemente los componentes determinísticos y aplica un test tipo Dickey–Fuller; en ciertas muestras puede tener mayor potencia.

**Código asociado.** `Clase_07_Ejemplo_ADF_DFGLS` compara ADF/DFGLS y muestra la elección de `regression`, `maxlag` y `autolag`.

---

# VI. VAR, Granger y cointegración

## 14. VAR(p), rezagos y estabilidad

Para \(\mathbf y_t\in\mathbb R^K\):

\[
\mathbf y_t=\mathbf c+A_1\mathbf y_{t-1}+\cdots+A_p\mathbf y_{t-p}+\mathbf u_t.
\]

Cada variable depende de sus propios rezagos y de los rezagos de todas las otras. Se selecciona \(p\) comparando AIC, BIC, HQIC o FPE; se escoge el menor valor del criterio elegido. BIC suele preferir mayor parsimonia.

Un VAR estable admite una representación MA infinita convergente. La condición es que los autovalores de la matriz compañera estén dentro del círculo unitario. En Python:

```python
modelo = VAR(datos)
orden = modelo.select_order(maxlags=12)
resultado = modelo.fit(orden.selected_orders["bic"])
resultado.is_stable()
```

Luego se revisa ausencia de autocorrelación residual. Ljung–Box plantea:

\[
H_0:\text{ no existe autocorrelación hasta el rezago analizado}.
\]

**Código asociado.** `Clase 08 Introducción VAR` desarrolla selección y estimación; la práctica usa `acorr_ljungbox` sobre los residuos de cada ecuación.

## 15. Causalidad de Granger

\(x\) causa a \(y\) en sentido de Granger si sus rezagos mejoran la predicción de \(y\), una vez incluidos los rezagos de \(y\). No es causalidad estructural.

\[
H_0:\beta_{x,1}=\beta_{x,2}=\cdots=\beta_{x,p}=0
\quad\text{en la ecuación de }y_t.
\]

| Pregunta | Llamado correcto |
|---|---|
| ¿\(x\) anticipa \(y\)? | `test_causality(caused="y", causing="x")` |
| ¿\(y\) anticipa \(x\)? | `test_causality(caused="x", causing="y")` |

Se informan ambas direcciones: estadístico, p-value e hipótesis. Un p-value bajo rechaza que los rezagos de la variable `causing` sean conjuntamente irrelevantes.

## 16. Cointegración y VECM

Series \(I(1)\) están cointegradas si una combinación lineal es \(I(0)\):

\[
z_t=y_t-\beta x_t\sim I(0).
\]

Esto representa equilibrio de largo plazo. El VECM es:

\[
\Delta\mathbf y_t=\mathbf c+\Pi\mathbf y_{t-1}
+\sum_{i=1}^{p-1}\Gamma_i\Delta\mathbf y_{t-i}+\mathbf u_t,
\qquad
\Pi=\alpha\beta'.
\]

\(\beta'\mathbf y_{t-1}\) es el desvío de equilibrio; \(\alpha\) mide la velocidad de corrección.

| Rango de \(\Pi\) | Modelo |
|---:|---|
| \(0\) | Sin cointegración: VAR en diferencias. |
| Entre \(0\) y \(K\) | Cointegración: VECM. |
| \(K\) | El vector es estacionario en niveles. |

**Código asociado.** `Clase 09 VECM` usa `coint_johansen`, determina el rango y estima `VECM`.

---

# VII. Pronóstico y respuesta binaria

## 17. Pronóstico

Para un AR(1) sin constante:

\[
y_t=\phi y_{t-1}+\varepsilon_t,
\qquad
\widehat y_{t+h\mid t}=\phi^h y_t.
\]

Si \(|\phi|<1\), el pronóstico converge a la media incondicional. La incertidumbre aumenta con el horizonte porque se acumulan shocks futuros desconocidos.

**Código asociado.** `Forecast.ipynb` estima un AR(1) y contrasta pronóstico dentro y fuera de muestra.

## 18. Logit y probit

Cuando \(Y_i\in\{0,1\}\):

\[
\Pr(Y_i=1\mid X_i)=F(X_i'\beta).
\]

| Modelo | \(F\) |
|---|---|
| Logit | \(\Lambda(z)=\frac{e^z}{1+e^z}\). |
| Probit | \(\Phi(z)\), CDF normal estándar. |

Los coeficientes no son cambios directos en probabilidad; se interpretan mediante efectos marginales, que dependen de \(X\).

---

# VIII. Checklist de examen

| Si piden… | Hacer primero | Concluir después |
|---|---|---|
| Normalidad | Momentos, QQ y/o JB | Hipótesis, p-value y qué aspecto se aleja de normalidad. |
| Mixtura | Pesos y componentes | Media, varianza, forma y simulación. |
| Regresión | Modelo y unidades | Efecto parcial, inferencia y supuestos. |
| Estacionariedad | Especificación ADF | Hipótesis, rezagos, p-value y orden de integración. |
| ARMA | \(\phi(L)\) y \(\theta(L)\) | Raíces, estacionariedad, invertibilidad e IRF. |
| VAR | Órdenes de integración | Rezagos, estabilidad, residuos y Granger bidireccional. |
| Cointegración | Confirmar \(I(1)\) | Rango y decisión entre VAR en diferencias o VECM. |

## Errores frecuentes

- Confundir el error \(u_i\) con el residuo \(\widehat u_i\).
- Decir “acepto \(H_0\)”: lo correcto es “no rechazo \(H_0\)”.
- Interpretar el p-value como probabilidad de que \(H_0\) sea verdadera.
- Llamar causalidad económica a la causalidad predictiva de Granger.
- Usar tabla \(t\) usual para ADF.
- Diferenciar una serie sin analizar ADF ni componentes determinísticos.
- Olvidar que en ARMA las **raíces**, no necesariamente cada coeficiente, deben quedar fuera del círculo unitario.
- Invertir `caused` y `causing` en Granger.

La prueba de comprensión es poder explicar qué ecuación se estima, qué hipótesis se contrasta y qué significa el resultado antes de ejecutar una celda.
