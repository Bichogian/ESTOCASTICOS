# Clases 4 y 5 - Regresion multiple, matrices, multicolinealidad y heterocedasticidad

[Volver al indice general](../Res+Pra.md)

Mapa completo de las Clases 4 y 5: teoria del PDF, codigo de los tres notebooks y
Ejercitacion 4. Cada tema sigue el mismo recorrido:

$$\text{teoria} \;\rightarrow\; \text{para que sirve} \;\rightarrow\; \text{codigo generico} \;\rightarrow\; \text{como leer la salida}$$

## Archivos de estas clases

| Tipo | Archivo | Para que se usa |
|---|---|---|
| Teoria | `Clases/MIA103_Clase_4.pdf` | Regresion multiple, dummies, matrices, heterocedasticidad, consistencia |
| Teoria | `Clases/Matrix.pdf` | Repaso de operaciones matriciales |
| Python | `Codigos/MIA103_2026_Clase_04_01_Introducción.ipynb` | Ejemplo casa: regresion multiple, tests t y F, dummies, interacciones |
| Python | `Codigos/MIA103_2026_Clase_04_02_Notación_Matricial.ipynb` | $(X'X)^{-1}X'y$ a mano, matrices $P$ y $M$ |
| Python | `Codigos/MIA103_2026_Clase_04_03_Multicolinealidad_Heteroscedasticidad.ipynb` | Multicolinealidad y los tres tests de heterocedasticidad |
| Practica | `Practicas/MIA103_Ejer_4.pdf` | Regresiones 1 y 2 sobre la base de casas |
| Resuelta | `Practicas_Resueltas/Respuestas_4.ipynb` | Resolucion propia |
| Datos | `Bases de Datos MIA103/Ejemplo_Casa.xls` | 546 casas de Windsor, Canada (Gary Koop) |
| Datos | `Bases de Datos MIA103/CEO_ejemplo_multicolinealidad.xlsx` | Ejemplo con dos regresores casi identicos |

## Mapa tema - PDF - notebook - practica

| # | Tema | PDF | Notebook | Practica |
|---:|---|---|---|---|
| 1 | Modelo multiple y ecuaciones normales | p. 2-8 | `04_01` celda 15 | - |
| 2 | Insesgadez y varianzas | p. 8-11 | - | - |
| 3 | Multicolinealidad | p. 12-15 | `04_03` celdas 4-10 | Ej. c |
| 4 | Interpretacion ceteris paribus | p. 15 | - | Ej. a |
| 5 | $R^2$ y $R^2$ ajustado | p. 16-19 | `04_01` celdas 17-20, 56-58 | - |
| 6 | Test t con $n-k$ gl | p. 20-22 | `04_01` celdas 40-46 | - |
| 7 | Test F | p. 22-24, 35-37 | `04_01` celdas 47-50 | Ej. b, g |
| 8 | Variables dummy | p. 25-31 | `04_01` celdas 87-96 | Ej. e |
| 9 | Transformaciones logaritmicas | p. 32-34 | - | - |
| 10 | Omitidas relevantes / irrelevantes incluidas | p. 38-44 | - | - |
| 11 | Notacion matricial | p. 45-51 | `04_02` completo | - |
| 12 | Interacciones y no linealidades | p. 52-57 | `04_01` celdas 68-80 | - |
| 13 | Heterocedasticidad y WLS | p. 58-64 | `04_03` celdas 11-18 | - |
| 14 | Tests de heterocedasticidad | p. 65-72 | `04_03` celdas 13-22 | - |
| 15 | Consistencia | p. 73-76 | - | - |

---

# Parte A - Regresion multiple

## 1. El modelo y las ecuaciones normales

### Teoria

Con dos variables explicativas:

$$y_i = \alpha + \beta_1 x_{1i} + \beta_2 x_{2i} + u_i$$

MCO minimiza $S(\tilde\alpha,\tilde\beta_1,\tilde\beta_2) = \sum(y_i - \tilde\alpha - \tilde\beta_1 x_{1i} - \tilde\beta_2 x_{2i})^2$.
Las tres CPO dan las **ecuaciones normales**:

$$\sum_{i=1}^{n} e_i = 0 \qquad \sum_{i=1}^{n} e_i x_{1i} = 0 \qquad \sum_{i=1}^{n} e_i x_{2i} = 0$$

Ojo con el nombre: **"normal" no tiene nada que ver con la distribucion normal**.
Viene de "ortogonal": los residuos son ortogonales a los regresores.

### La solucion

Definiendo las sumas cruzadas centradas:

$$S_{y1} = \sum (x_{1i}-\bar{x}_1)(y_i-\bar{y}) \qquad S_{11} = \sum (x_{1i}-\bar{x}_1)^2 \qquad S_{12} = \sum (x_{1i}-\bar{x}_1)(x_{2i}-\bar{x}_2)$$

el sistema queda:

$$S_{y1} = \hat\beta_1 S_{11} + \hat\beta_2 S_{12} \qquad\qquad S_{y2} = \hat\beta_1 S_{12} + \hat\beta_2 S_{22}$$

y la solucion:

$$\hat\beta_1 = \frac{S_{y1}S_{22} - S_{y2}S_{12}}{S_{11}S_{22} - S_{12}^2} \qquad\qquad \hat\beta_2 = \frac{S_{y2}S_{11} - S_{y1}S_{12}}{S_{11}S_{22} - S_{12}^2}$$

$$\hat\alpha = \bar{y} - \hat\beta_1\bar{x}_1 - \hat\beta_2\bar{x}_2$$

**Existen siempre?** No: el denominador $S_{11}S_{22}-S_{12}^2$ tiene que ser
distinto de cero. Ese es exactamente el problema de multicolinealidad del punto 3.

### Codigo generico

```python
import statsmodels.api as sm

variables = ['LOTE','CUARTOS','BANOS','PISOS','ENTRADA','REC',
             'SOTANO','CALEF','AIRE','GARAGE','NBHD']

X = sm.add_constant(df[variables])
y = df['PRECIO']

regmul = sm.OLS(y, X).fit()
print(regmul.summary())
```

### Verificar las ecuaciones normales

```python
regmul.resid.sum()                                  # ~ 0
np.dot(regmul.model.exog[:, 1], regmul.resid)       # ~ 0 para cada columna
```

Los numeros no dan cero exacto sino del orden de $10^{-9}$ o menos. **La columna
con la escala mas grande (LOTE, en miles) da el valor mas lejano a cero**: es
error relativo de punto flotante, no un problema del modelo.

---

## 2. Insesgadez y varianza de los estimadores

### Teoria

La descomposicion del estimador es:

$$\hat\beta_1 = \beta_1 + \frac{S_{22}\sum(x_{1i}-\bar{x}_1)u_i - S_{12}\sum(x_{2i}-\bar{x}_2)u_i}{S_{11}S_{22}-S_{12}^2}$$

Tomando esperanza y usando $E(u_i)=0$: $E(\hat\beta_1) = \beta_1$. Es insesgado.

Y la varianza:

$$Var(\hat\beta_1) = \frac{\sigma^2 S_{22}}{S_{11}S_{22}-S_{12}^2} \qquad\qquad Var(\hat\beta_2) = \frac{\sigma^2 S_{11}}{S_{11}S_{22}-S_{12}^2}$$

### La reescritura clave

Si $r_{12}^2 = \dfrac{S_{12}^2}{S_{11}S_{22}}$ es la correlacion muestral al
cuadrado entre los regresores, entonces:

$$\boxed{\;Var(\hat\beta_1) = \frac{\sigma^2}{S_{11}\left(1 - r_{12}^2\right)}\;}$$

Esta formula es el corazon de las Clases 4 y 5. Se lee asi:

- Comparada con la regresion simple ($Var = \sigma^2/S_{11}$), la varianza esta
  **inflada por el factor $1/(1-r_{12}^2)$**.
- Ese factor es el **VIF** (variance inflation factor).
- Si $r_{12}^2 \to 1$, la varianza **explota**.

---

## 3. Multicolinealidad

### Teoria

| Tipo | Condicion | Consecuencia |
|---|---|---|
| **Perfecta** | $r_{12}^2 = 1$ | el denominador es cero: **no hay solucion unica** |
| **Alta** | $r_{12}^2$ cerca de 1 pero $\ne 1$ | hay solucion unica, pero las **varianzas son enormes** |

### Para que sirve entenderlo

**Multicolinealidad perfecta** significa que una variable explicativa es
combinacion lineal exacta de otra(s). La intuicion del PDF: es como incluir la
misma variable **en pesos y en centavos**. A cual de las dos le atribuimos la
explicacion de $y$? A ninguna: hay infinitas combinaciones que dan el mismo
ajuste.

**Multicolinealidad alta** no sesga nada: los estimadores siguen siendo
insesgados y MCO sigue siendo BLUE. Lo que hace es **inflar los errores
estandar**, y por lo tanto bajar los estadisticos $t$, haciendo que variables
importantes parezcan no significativas.

### Como detectarla

**Sintoma tipico**: varias variables con $t$ bajos **pero** un $R^2$ alto y un
test $F$ global significativo. Si ninguna variable explica nada, como puede el
modelo explicar tanto?

Dos metodos del PDF:

1. **Eliminar de a una** las variables sospechadas (las de $t$ bajo). Si al sacar
   una, la que queda pasa a tener un $t$ alto (mayor a 1.645, por ejemplo),
   **habia multicolinealidad**.
2. **Test F conjunto** sobre los coeficientes sospechosos:
   - si se **rechaza** $H_0$ (los betas conjuntamente cero) $\Rightarrow$ hay
     multicolinealidad: juntas explican, separadas no se distinguen;
   - si **no** se rechaza $\Rightarrow$ esas variables simplemente **no explican**
     a $y$.

Esa distincion es la que hace que valga la pena correr el test F.

### Codigo generico

```python
X = sm.add_constant(df.drop(columns='Comp'))
reg = sm.OLS(df['Comp'], X).fit()
print(reg.summary())

# test F conjunto sobre las sospechosas
print(reg.f_test("Gan = 0, Gan_10 = 0"))

# y despues, eliminando de a una
reg2 = sm.OLS(df['Comp'], sm.add_constant(df['Gan'])).fit()
```

### Salida verificada (ejemplo `CEO_ejemplo_multicolinealidad.xlsx`)

```text
correlacion entre Gan y Gan_10 = 0.99999263      <- casi perfecta

--- con las dos variables ---
                coef      std err        t        P>|t|
const         0.6558       0.166      3.941      0.000
Gan          -0.0131       0.031     -0.430      0.669     <- NO significativa
Gan_10        0.1396       0.305      0.457      0.649     <- NO significativa
R2 = 0.436238

Test F conjunto (Gan = 0, Gan_10 = 0):
    F = 25.9223    p = 4.59e-09        <- SI se rechaza

--- eliminando Gan_10 ---
                coef      std err        t        P>|t|
Gan           0.0008    0.0001166      7.228      0.000     <- ahora SI significativa
R2 = 0.434479
```

### Como leer la salida

Es el ejemplo perfecto del sintoma:

- Individualmente, **ninguna** de las dos variables es significativa ($p = 0.669$
  y $p = 0.649$).
- **Conjuntamente** el test F rechaza contundentemente ($p = 4.6\times10^{-9}$).
- Al eliminar una, la que queda salta a $t = 7.228$.
- Y el $R^2$ practicamente no cambia ($0.4362 \to 0.4345$): la segunda variable no
  aportaba informacion nueva.

Diagnostico: **multicolinealidad alta**, no irrelevancia. Ademas notar el **signo
absurdo** de `Gan` ($-0.0131$, negativo) en la primera regresion: coeficientes con
signo economicamente imposible son otra senal clasica.

---

## 4. Interpretacion de las pendientes

### Teoria

En regresion multiple, los coeficientes son **derivadas parciales**:

$$\frac{\partial \hat{y}_i}{\partial x_{1i}} = \hat\beta_1$$

Por eso la interpretacion **siempre** debe incluir *ceteris paribus*: "manteniendo
todo lo demas constante".

### Ejemplo (inciso a de la practica)

$\hat\beta_{GARAGE} = 4139.8$ significa: **por cada auto adicional que entra en el
garage, el precio esperado de la casa aumenta 4139.8 dolares canadienses,
manteniendo constantes todas las demas caracteristicas** (tamanio del lote,
cuartos, banos, pisos, etc.).

Sin el *ceteris paribus* la frase es falsa: casas con garages mas grandes tambien
tienden a ser mas grandes, y ese efecto ya lo captan las otras variables.

---

## 5. $R^2$ y $R^2$ ajustado

### Teoria

Sigue valiendo $TSS = ESS + RSS$ y $R^2 = ESS/TSS$. En regresion multiple, $R^2$
es la **correlacion al cuadrado entre $y_i$ e $\hat{y}_i$** (ya no entre $y$ y una
sola $x$).

**El problema**: al agregar variables explicativas, aunque sean irrelevantes, el
RSS **siempre cae** y el $R^2$ **siempre sube**. Entonces $R^2$ no sirve para
comparar modelos anidados.

Por eso se define:

$$\bar{R}^2 = 1 - \frac{RSS/(n-k)}{TSS/(n-1)}$$

donde $k$ = numero de parametros (intercepto + pendientes). Penaliza por
parametros: **puede bajar** si la variable agregada no aporta lo suficiente.

### Codigo generico

```python
regmul.rsquared          # R2
regmul.rsquared_adj      # R2 ajustado

# a mano
1 - (regmul.ssr/regmul.df_resid) / (regmul.centered_tss/(regmul.df_model + regmul.df_resid))
```

### Como leer la salida

En las dos regresiones de la practica:

```text
             R2          R2 ajustado
Regresion 1  0.664891    0.657975
Regresion 2  0.665005    0.657449
```

El $R^2$ **sube** de la 1 a la 2 (se agrego una variable neta), pero el $R^2$
**ajustado baja**. Traduccion: descomponer BANOS en dos dummies no mejora el
modelo lo suficiente como para justificar el parametro extra, al menos por este
criterio.

---

## 6. Grados de libertad y $s^2$

### Teoria

$$s^2 = \frac{RSS}{n-k} \qquad\qquad \frac{(n-k)s^2}{\sigma^2}\sim\chi^2_{n-k}$$

donde $k$ = intercepto + pendientes. Con dos regresores, $k=3$ y los grados de
libertad son $n-3$.

**Este es el cambio operativo mas importante respecto de la Clase 3**: todos los
valores criticos (t y F) usan $n-k$, no $n-2$.

### Codigo generico

```python
regmul.scale       # s^2
regmul.df_resid    # n - k
regmul.df_model    # numero de pendientes (k - 1)
np.sqrt(regmul.scale)   # "S.E. of regression" de la salida
```

---

# Parte B - Inferencia en regresion multiple

## 7. Test t

### Teoria

Igual que en regresion simple, con la unica diferencia de los grados de libertad:

$$\frac{\hat\beta_j - \beta_{j0}}{se(\hat\beta_j)} \sim t_{n-k}$$

### Codigo generico

```python
# H0: beta_AIRE = 10000   (sintaxis de formula)
print(regmul.t_test("AIRE = 10000"))

# equivalente con matriz de restricciones
R = np.zeros((1, len(regmul.params)))
R[0, regmul.params.index.get_loc("AIRE")] = 1
print(regmul.t_test((R, [10000])))

# intervalo de confianza
regmul.conf_int(alpha=0.05).loc["LOTE"]
```

`t_test` con string es mucho mas legible y evita errores de posicion. La version
con matriz $R$ sirve cuando la restriccion es rara o se arma programaticamente.

---

## 8. Test F

### Teoria

Sirve para hipotesis que involucran **varios coeficientes a la vez**:

$$H_0: \beta_1 = \beta_2 \qquad\text{(equivale a } \beta_1 - \beta_2 = 0\text{)}$$
$$H_0: \beta_1 = \beta_2 = 0$$

El estadistico compara el ajuste **con** y **sin** la restriccion:

$$\boxed{\;F = \frac{(RRSS - URSS)/q}{URSS/(n-k)}\;}$$

| Simbolo | Que es |
|---|---|
| RRSS | RSS del modelo **restringido** (imponiendo $H_0$) |
| URSS | RSS del modelo **no restringido** (bajo $H_A$) |
| $q$ | numero de restricciones bajo $H_0$ |
| $k$ | parametros del modelo no restringido |

Distribucion: $F_{q,\;n-k}$. **Se rechaza $H_0$ si el estadistico es mayor al
valor critico** (el test F siempre es a una cola derecha).

### La intuicion

Imponer una restriccion nunca puede mejorar el ajuste, asi que
$RRSS \ge URSS$. La pregunta es: **cuanto empeora**? Si empeora mucho respecto
del ruido de fondo ($URSS/(n-k)$), la restriccion es falsa y se rechaza.

### El F de la salida de los software

Es el caso particular:

$$H_0: \beta_1 = \beta_2 = \cdots = 0 \qquad\qquad H_A: \text{al menos un } \beta \ne 0$$

Bajo esa $H_0$ el modelo restringido es solo el intercepto, asi que **RRSS = TSS**,
$q$ = numero de pendientes y los gl del denominador son $n-k$.

**Es uno de los primeros numeros que hay que mirar**: si el p-value es alto
(mayor a 0.10), el modelo estimado **no sirve**, porque no se puede rechazar que
la variable dependiente sea explicada solo por la constante mas el error.

### Codigo generico

```python
# F conjunto sobre dos variables
print(regmul.f_test("CALEF = 0, AIRE = 0"))

# hipotesis con combinacion lineal
print(regdummy.f_test("BANOS_3 = 2 * BANOS_2"))

# el F global ya viene en la salida
regmul.fvalue, regmul.f_pvalue
```

Version con matriz de restricciones, util cuando el nombre de la variable tiene
caracteres raros:

```python
r = np.zeros(X.shape[1])
r[X.columns.get_loc("BANOS_3")] =  1
r[X.columns.get_loc("BANOS_2")] = -2
print(regdummy.f_test(r))
```

La restriccion $\beta_3 = 2\beta_2$ se reescribe como $\beta_3 - 2\beta_2 = 0$, y
por eso el vector lleva $1$ y $-2$.

### Como leer la salida

Del test F global de la Regresion 1:

```text
F = 96.1389    con  q = 11  y  n-k = 533     p-value = 7.67e-119
```

Verificacion manual:

$$F = \frac{(TSS - RSS)/11}{RSS/533} = 96.1389 \;\checkmark$$

Conclusion: se rechaza contundentemente que todas las pendientes sean cero, o sea
que el conjunto de atributos si explica el precio.

---

# Parte C - Variables dummy

## 9. Los cuatro modelos y la trampa

### Teoria

Una dummy toma valores 0 o 1. Con $M_i$ = mujer y $H_i$ = hombre, y sabiendo que
$M_i + H_i = 1$:

| Modelo | Especificacion | Interpretacion |
|---|---|---|
| **1** | $y_i = \beta_0 + \beta_1 M_i + u_i$ | $\hat\beta_0 = \bar{y}_{hombres}$, $\hat\beta_1 = \bar{y}_{mujeres} - \bar{y}_{hombres}$ |
| **2** | $y_i = \gamma_0 + \gamma_1 H_i + u_i$ | $\hat\gamma_0 = \bar{y}_{mujeres}$, $\hat\gamma_1 = \bar{y}_{hombres} - \bar{y}_{mujeres}$ |
| **3** | $y_i = \delta_0 M_i + \delta_1 H_i + u_i$ | $\hat\delta_0 = \bar{y}_{mujeres}$, $\hat\delta_1 = \bar{y}_{hombres}$ (sin intercepto) |
| **4** | $y_i = \theta_0 + \theta_1 M_i + \theta_2 H_i + u_i$ | **MAL ESPECIFICADO** |

### Por que el Modelo 4 esta mal

Tiene 3 incognitas y solo 2 ecuaciones ($\hat\theta_0+\hat\theta_1 = \bar{y}_{muj}$
y $\hat\theta_0+\hat\theta_2 = \bar{y}_{hom}$): **infinitas soluciones**.

Es multicolinealidad perfecta: $M_i + H_i = 1$, y ese vector de unos es
exactamente la columna del intercepto. Se conoce como **trampa de la variable
dummy** (dummy variable trap).

**La regla**: con $c$ categorias hay que incluir $c-1$ dummies si hay intercepto,
o $c$ dummies si no lo hay. Nunca las dos cosas.

En el ejemplo casa, BANOS toma valores 1, 2 y 3: se incluyen DB2 y DB3, y **la
categoria base (1 bano) queda absorbida en el intercepto**.

### Codigo generico

```python
# crear dummies desde una variable categorica
X2 = pd.get_dummies(df, columns=['BANOS'], drop_first=True, dtype=int)
```

`drop_first=True` **es lo que evita la trampa**: elimina el primer nivel, que pasa
a ser la categoria de referencia. `dtype=int` evita que queden booleanas, que
`statsmodels` a veces no maneja bien.

### Como leer la salida

Del inciso (e) de la practica: $\hat\beta_{DB3} = 29392.54$ se interpreta como

**una casa con exactamente 3 banos vale, en promedio, 29392.54 dolares mas que una
casa con 1 bano** (la categoria base omitida), manteniendo todo lo demas constante.

**No** es "vale 29392 mas que una con 2 banos". La comparacion es **siempre contra
la categoria omitida**. La diferencia entre 3 y 2 banos seria
$29392.54 - 13481.18 = 15911.36$.

---

# Parte D - Transformaciones e interacciones

## 10. Transformaciones logaritmicas

### Teoria

Un modelo exponencial $y_i = A x_i^{\beta} u_i$ no es lineal, pero tomando
logaritmos:

$$\ln(y_i) = A + \beta \ln(x_i) + u_i$$

que si es lineal en parametros y se estima por MCO.

### Interpretacion segun la forma

| Modelo | Nombre | Interpretacion de $\hat\beta$ |
|---|---|---|
| $y = \alpha + \beta x$ | nivel-nivel | $x$ sube 1 unidad $\Rightarrow$ $y$ sube $\hat\beta$ **unidades** |
| $\ln y = \alpha + \beta \ln x$ | log-log | $x$ sube **1%** $\Rightarrow$ $y$ sube $\hat\beta$ **%** (**elasticidad**) |
| $\ln y = \alpha + \beta x$ | semilog (log-nivel) | $x$ sube 1 unidad $\Rightarrow$ $y$ sube $100\hat\beta$ **%** |
| $y = \alpha + \beta \ln x$ | nivel-log | $x$ sube 1% $\Rightarrow$ $y$ sube $\hat\beta/100$ **unidades** |

**Regla mnemotecnica**: la variable que esta en logaritmos se interpreta en
**porcentajes**; la que esta en niveles, en **unidades**.

### Ejemplo del PDF

$$\widehat{\ln(wage)} = 0.6 + 0.081\,\text{education}$$

Un anio mas de educacion aumenta el salario en **8.1%**.

### Codigo generico

```python
df["log_y"] = np.log(df["y"])
df["log_x"] = np.log(df["x"])

modelo = smf.ols("log_y ~ log_x", data=df).fit()   # elasticidad
```

---

## 11. No linealidades e interacciones

### Teoria: la regla unica

Cuando una variable aparece en mas de un termino, **los coeficientes no se
interpretan por separado**: hay que mirar la **derivada parcial completa**.

**Termino cuadratico**, en $y = \alpha + \beta_1 x_1 + \beta_2 x_2 + \beta_3 x_2^2 + u$:

$$\frac{\partial \hat{y}}{\partial x_2} = \hat\beta_2 + 2\hat\beta_3 x_2$$

El efecto **depende del valor de $x_2$**. Hay que evaluar en algun punto: en
general la **media** o la **mediana**.

**Interaccion**, en $\widehat{precio} = \cdots + \beta_{LOTE}LOTE + \beta_{NBHD}NBHD + \beta_{int}(LOTE \times NBHD)$:

$$\frac{\partial \widehat{precio}}{\partial LOTE} = \hat\beta_{LOTE} + \hat\beta_{int}\,NBHD$$

### Ejemplo del PDF

$$\frac{\partial \widehat{precio}}{\partial LOTE} = 3.18 + 1.18\,NBHD$$

$$NBHD = 0 \;\Rightarrow\; 3.18 \qquad\qquad NBHD = 1 \;\Rightarrow\; 4.36$$

Un pie cuadrado extra de lote se valora **mas** en un vecindario agradable. Esa es
exactamente la pregunta que la interaccion permite responder.

Y en la otra direccion, como NBHD es dummy:

$$\frac{\Delta \widehat{precio}}{\Delta NBHD} = 2601.53 + 1.18\,LOTE$$

aunque el primer coeficiente no es significativo por si solo.

### Codigo generico

```python
# a mano
X['LOTE_NBHD'] = X['LOTE'] * X['NBHD']

# con formulas (mucho mas comodo)
import statsmodels.formula.api as smf

smf.ols('PRECIO ~ CUARTOS + LOTE*NBHD', data=df).fit()
```

| Operador | Que incluye |
|---|---|
| `x1:x2` | **solo** la interaccion |
| `x1*x2` | `x1` + `x2` + `x1:x2` |
| `x1 + x2` | solo los efectos principales |

`LOTE*CUARTOS*BANOS*NBHD` genera automaticamente **todas** las combinaciones de a
dos, de a tres y de a cuatro. A mano serian 11 variables extra.

### Regla practica

Si se incluye una interaccion, **hay que incluir tambien los efectos
principales** (`x1*x2`, no `x1:x2` solo). Si no, el modelo impone una restriccion
que no se quiso imponer.

---

# Parte E - Notacion matricial

## 12. El modelo en matrices

### Teoria

$$\mathbf{y} = \mathbf{X}\boldsymbol{\beta} + \mathbf{u}$$

con $\mathbf{y}$ de $n\times1$, $\mathbf{X}$ de $n\times k$ (primera columna de
unos), $\boldsymbol\beta$ de $k\times1$ y $\mathbf{u}$ de $n\times1$.

MCO minimiza $\mathbf{e}'\mathbf{e} = (\mathbf{y}-\mathbf{X}\tilde\beta)'(\mathbf{y}-\mathbf{X}\tilde\beta)$,
lo que da las ecuaciones normales en forma matricial:

$$\mathbf{X}'\mathbf{X}\hat{\boldsymbol\beta} = \mathbf{X}'\mathbf{y} \qquad\Longrightarrow\qquad \boxed{\;\hat{\boldsymbol\beta} = (\mathbf{X}'\mathbf{X})^{-1}\mathbf{X}'\mathbf{y}\;}$$

Y con homocedasticidad y no autocorrelacion ($\boldsymbol\Omega = E(\mathbf{u}\mathbf{u}') = \sigma^2\mathbf{I}$):

$$\boxed{\;Var(\hat{\boldsymbol\beta}) = \sigma^2(\mathbf{X}'\mathbf{X})^{-1}\;}$$

### Para que sirve

Es la forma en que se generaliza a $k$ variables: una sola formula en vez de un
sistema que crece. Ademas deja ver de inmediato el problema de multicolinealidad:
**si las columnas de $\mathbf{X}$ son linealmente dependientes,
$\det(\mathbf{X}'\mathbf{X}) = 0$ y la inversa no existe**.

### Ejemplo numerico del PDF

$$\mathbf{y} = \begin{pmatrix}4\\7\\3\\9\\17\end{pmatrix}, \qquad \mathbf{X} = \begin{pmatrix}1&2\\1&3\\1&1\\1&5\\1&9\end{pmatrix}$$

$$\mathbf{X}'\mathbf{X} = \begin{pmatrix}5&20\\20&120\end{pmatrix}, \qquad \det = 200, \qquad (\mathbf{X}'\mathbf{X})^{-1} = \begin{pmatrix}0.6&-0.1\\-0.1&0.025\end{pmatrix}$$

$$\mathbf{X}'\mathbf{y} = \begin{pmatrix}40\\230\end{pmatrix} \qquad\Longrightarrow\qquad \hat{\boldsymbol\beta} = \begin{pmatrix}1\\1.75\end{pmatrix}$$

$$\hat{\mathbf{y}} = \begin{pmatrix}4.5\\6.25\\2.75\\9.75\\16.75\end{pmatrix}, \qquad \mathbf{e} = \begin{pmatrix}-0.5\\0.75\\0.25\\-0.75\\-0.25\end{pmatrix}$$

### Codigo generico

```python
import numpy as np

def estimar_mco_matricial(X, y):
    XtX_inv = np.linalg.inv(X.T @ X)
    beta = XtX_inv @ X.T @ y

    n, k = X.shape
    residuos = y - X @ beta
    s2 = float(residuos.T @ residuos) / (n - k)

    return beta, s2 * XtX_inv     # beta y su matriz var-cov
```

**Advertencia del notebook**: invertir matrices es costoso y numericamente
inestable. En produccion se usa `np.linalg.solve(X.T@X, X.T@y)`. La inversa
explicita queda solo con fines didacticos.

Verificacion:

```python
np.sqrt(np.diag(var_beta))    # == modelo.bse
modelo.scale * np.linalg.inv(X.T @ X)   # == modelo.cov_params()
```

---

## 13. Matrices de proyeccion

### Teoria

$$\hat{\mathbf{y}} = \mathbf{X}\hat{\boldsymbol\beta} = \mathbf{X}(\mathbf{X}'\mathbf{X})^{-1}\mathbf{X}'\mathbf{y} = \mathbf{P}\mathbf{y}$$

$$\mathbf{P} = \mathbf{X}(\mathbf{X}'\mathbf{X})^{-1}\mathbf{X}' \qquad\qquad \mathbf{M} = \mathbf{I} - \mathbf{P}$$

Las dos son de $n\times n$ e **idempotentes**: $\mathbf{P}\mathbf{P}=\mathbf{P}$ y
$\mathbf{M}\mathbf{M}=\mathbf{M}$. Y:

$$\mathbf{e} = \mathbf{y} - \hat{\mathbf{y}} = (\mathbf{I}-\mathbf{P})\mathbf{y} = \mathbf{M}\mathbf{y}$$

### Que significan

$\mathbf{P}$ ("hat matrix") **proyecta** $\mathbf{y}$ sobre el espacio generado por
las columnas de $\mathbf{X}$: es la sombra de $\mathbf{y}$ sobre el plano de los
regresores. $\mathbf{M}$ proyecta sobre el complemento ortogonal: lo que sobra.

Idempotente = proyectar dos veces es lo mismo que proyectar una vez. Geometricamente
obvio: la sombra de la sombra es la sombra.

Esto da la interpretacion geometrica de MCO: **$\hat{\mathbf{y}}$ es el punto del
plano de los regresores mas cercano a $\mathbf{y}$**, y $\mathbf{e}$ es
perpendicular a ese plano (que es justamente $\sum e_i x_{ji} = 0$).

### Codigo generico

```python
P = X @ np.linalg.inv(X.T @ X) @ X.T
M = np.eye(P.shape[0]) - P

np.allclose(P @ P, P)              # True: idempotente
np.allclose(M @ y, modelo.resid)   # True: M y = residuos
```

---

# Parte F - Variables omitidas e irrelevantes

## 14. Omitir una variable relevante

### Teoria

Si el modelo verdadero es $y_i = \alpha + \beta_1 x_{1i} + \beta_2 x_{2i} + u_i$
pero se estima omitiendo $x_2$, el estimador obtenido cumple:

$$E(\hat\beta_1) = \beta_1 + \beta_2\frac{S_{12}}{S_{11}} = \beta_1 + \beta_2\frac{Cov(x_1,x_2)}{Var(x_1)}$$

**El estimador es sesgado.** El sesgo es $\beta_2\dfrac{Cov(x_1,x_2)}{Var(x_1)}$.

### La direccion del sesgo

| $\beta_2$ | $Cov(x_1,x_2)$ | Sesgo |
|---|---|---|
| $>0$ | $>0$ | **positivo** (sobreestima) |
| $>0$ | $<0$ | negativo (subestima) |
| $<0$ | $>0$ | negativo |
| $<0$ | $<0$ | positivo |

**El sesgo desaparece si $Cov(x_1,x_2)=0$**: omitir una variable relevante pero no
correlacionada con la incluida no sesga nada.

### Ejemplo clasico del PDF

$$y_i = \alpha + \beta_1 S_i + \beta_2 a_i + u_i$$

donde $y$ = ingresos, $S$ = anios de educacion (schooling), $a$ = habilidad
(ability). La habilidad **no es observable**, asi que se omite.

Es razonable pensar que $\beta_2 > 0$ (mas habilidad, mas ingreso) y que
$Cov(S,a) > 0$ (los mas habiles estudian mas). Entonces **el sesgo es positivo**:
al omitir habilidad, se **sobreestima** el retorno de la educacion.

### El trade-off

Ademas:

$$Var(\hat\beta_1^{simple}) = \frac{\sigma^2}{S_{11}} \;\le\; \frac{\sigma^2}{S_{11}(1-r_{12}^2)} = Var(\hat\beta_1^{multiple})$$

O sea: **omitir una variable relevante da un estimador sesgado pero de menor
varianza**.

Esto **no contradice Gauss-Markov**, porque el teorema compara estimadores
**insesgados** y aca uno de los dos no lo es.

Cuando hay sesgo, la comparacion correcta es por **error cuadratico medio**:

$$MSE(\hat\beta) = Var(\hat\beta) + \left[\text{sesgo}(\hat\beta)\right]^2$$

---

## 15. Incluir una variable irrelevante

### Teoria

Si el verdadero es $y_i = \alpha + \beta_1 x_{1i} + u_i$ pero se incluye $x_2$
irrelevante:

- $\hat\beta_1$ **sigue siendo insesgado**;
- pero $Var(\hat\beta_1^{multiple}) \ge Var(\hat\beta_1^{simple})$: **se pierde
  eficiencia**.

### Los dos errores comparados

| | Sesgo | Varianza |
|---|---|---|
| **Omitir relevante** | **si** (grave) | menor |
| **Incluir irrelevante** | no | mayor (leve) |

**Incluir de mas es mucho menos grave que omitir de menos**: el sesgo no
desaparece con mas datos, la ineficiencia si se atenua. Ante la duda, conviene
incluir.

---

# Parte G - Heterocedasticidad

## 16. El problema

### Teoria

El Supuesto 2a decia $Var(u_i) = \sigma^2$ para todo $i$ (**homocedasticidad**).
Ahora se viola:

$$Var(u_i) = \sigma_i^2$$

Cada observacion tiene su propia varianza. Los errores son **heterocedasticos**.

### Consecuencias

| Propiedad | Sigue valiendo? |
|---|---|
| Insesgadez de $\hat\beta_{OLS}$ | **Si** |
| Consistencia | **Si** |
| Gauss-Markov (BLUE) | **No** |
| Formula usual de $Var(\hat\beta)$ | **No** |

La varianza correcta pasa a ser:

$$Var(\hat\beta_{OLS}) = \frac{\sum(x_i-\bar{x})^2\sigma_i^2}{\left(\sum(x_i-\bar{x})^2\right)^2}$$

que **no** es $\sigma^2/\sum(x_i-\bar{x})^2$.

### Por que importa

El estimador puntual esta bien, pero **los errores estandar estan mal
calculados**, y por lo tanto los estadisticos $t$, los p-values y los intervalos
de confianza estan mal. Se puede concluir que una variable es significativa
cuando no lo es, o al reves.

**Es un problema de inferencia, no de estimacion.**

---

## 17. La solucion teorica: WLS / GLS

### Teoria

Si se conociera $\sigma_i$, se divide todo el modelo por $\sigma_i$:

$$\frac{y_i}{\sigma_i} = \alpha\frac{1}{\sigma_i} + \beta\frac{x_i}{\sigma_i} + \frac{u_i}{\sigma_i}$$

Con $w_i = 1/\sigma_i$, el modelo transformado es:

$$y_i^* = \alpha w_i + \beta x_i^* + u_i^*$$

**Por que funciona**: los nuevos errores tienen varianza 1,

$$Var(u_i^*) = Var\!\left(\frac{u_i}{\sigma_i}\right) = \frac{1}{\sigma_i^2}Var(u_i) = 1$$

y por lo tanto son homocedasticos. Aplicar MCO al modelo transformado da
estimadores **MELI**.

### Nombres

- **MCP / WLS** (minimos cuadrados ponderados / weighted least squares): se llama
  ponderado porque cada observacion recibe un peso distinto. **A mayor varianza
  del error de una observacion, menor su ponderacion**: se le hace menos caso a
  las observaciones mas ruidosas.
- **MCG / GLS** (generalizados): termino mas amplio, para cualquier caso donde se
  transforma el modelo para que se cumplan los supuestos clasicos.
- **FGLS** (feasible GLS): lo que se usa en la practica, porque los $\sigma_i$ no
  se conocen: el software los **estima** primero y despues estima el modelo. Da
  estimadores consistentes.

**Detalle del modelo transformado**: no tiene constante, porque el intercepto pasa
a multiplicar a $w_i$, que es una variable.

---

## 18. Los tres tests de heterocedasticidad

En los tres, $H_0$ = homocedasticidad y $H_A$ = heterocedasticidad.

### Test de White

1. Regresar $y$ en las $X$ por MCO y calcular los residuos.
2. Regresar los **residuos al cuadrado** en una constante, las $X$, **sus
   cuadrados y sus productos cruzados**.
3. Calcular el $R^2$ de esa segunda regresion.

$$nR^2 \;\xrightarrow{a}\; \chi^2_q$$

donde $q$ = numero de parametros de la segunda regresion **excluyendo la
constante**.

Es el mas general: no supone ninguna forma particular de heterocedasticidad. La
contracara es que consume muchos grados de libertad.

### Test de Goldfeld-Quandt

Supone que $\sigma_i^2$ esta correlacionada con **algun regresor**.

1. Ordenar las observaciones segun ese regresor, de menor a mayor.
2. Omitir $c$ observaciones **centrales** (tipicamente $c = n/3$).
3. Correr la regresion en las $(n-c)/2$ observaciones **mas bajas**: obtener
   $RSS_1$. Y en las $(n-c)/2$ **mas altas**: obtener $RSS_2$.
4. El estadistico es el ratio:

$$\frac{RSS_2}{RSS_1} \sim F_{\frac{n-c-2k}{2},\;\frac{n-c-2k}{2}}$$

**Pregunta del PDF**: cuando el ratio seria cercano a 1? Cuando la varianza de los
errores es igual en los dos grupos, o sea **bajo homocedasticidad**. Por eso
valores lejos de 1 son evidencia contra $H_0$.

Se omiten las centrales justamente para **acentuar el contraste** entre los dos
extremos.

### Test de Breusch-Pagan

1. Regresar $y$ en las $X$, obtener residuos y calcular
   $\tilde\sigma^2 = RSS/n$.
2. Regresar $\dfrac{e_i^2}{\tilde\sigma^2}$ en una constante y en las variables
   **sospechadas** de generar heterocedasticidad.
3. Calcular el ESS de esa regresion.

$$\tfrac{1}{2}ESS \;\xrightarrow{a}\; \chi^2_q$$

Mas focalizado que White: permite testear una hipotesis especifica sobre que
variable genera el problema.

### Regla de decision

**Basta con que uno de los tres rechace $H_0$ para tener que tener en cuenta la
presencia de heterocedasticidad.**

### Codigo generico

```python
import statsmodels.stats.api as sms
import statsmodels.stats.diagnostic as diag

reg = sm.OLS(y, X).fit()

# White
lm, lm_p, f, f_p = sms.het_white(reg.resid, reg.model.exog)
print(f"White: LM={lm:.4f}  p={lm_p:.6f}")

# Breusch-Pagan
bp, bp_p, _, _ = sms.het_breuschpagan(reg.resid, X)
print(f"BP:    LM={bp:.4f}  p={bp_p:.6f}")

# Goldfeld-Quandt
gq, gq_p, _ = diag.het_goldfeldquandt(
    y=reg.model.endog, x=reg.model.exog,
    idx=X.columns.get_loc('LOTE'),      # variable por la que ordenar
    drop=int(0.20*len(y)),              # observaciones centrales a omitir
    alternative='increasing')
print(f"GQ:    F={gq:.4f}  p={gq_p:.6f}")
```

### Salida verificada (base de casas, 546 obs)

```text
White:          LM = 168.2793    p = 0.000000
Breusch-Pagan:  LM =  61.9526    p = 0.000000
Goldfeld-Quandt: F =   2.4202    p = 0.000000    (ordenando por LOTE)
```

**Los tres rechazan contundentemente.** Hay heterocedasticidad. Tiene sentido
economico: la varianza del precio de casas caras es mucho mayor que la de casas
baratas, asi que el error crece con el tamanio del lote.

---

## 19. Errores estandar robustos

### Teoria

Alternativa practica a WLS: dejar los coeficientes de MCO (que son insesgados) y
**corregir solo los errores estandar** con la formula de White.

### Codigo generico

```python
reg_robusto = reg.get_robustcov_results(cov_type='HC1')
print(reg_robusto.summary())
```

Variantes: `HC0` (White original), `HC1` (correccion por grados de libertad, la
mas usada), `HC2`, `HC3` (mejor en muestras chicas).

### Salida verificada

```text
variable    coef          se_OLS       se_HC1       t_OLS     t_HC1
LOTE           3.5463      0.3503       0.3938     10.124     9.004
CUARTOS     1832.0035   1047.0002    1038.1582      1.750     1.765
AIRE       12632.8904   1555.0211    1666.2248      8.124     7.582
NBHD        9369.5132   1669.0907    1870.8835      5.614     5.008
```

### Como leer la salida

- **Los coeficientes no cambian**: es exactamente el mismo MCO. Solo cambia la
  segunda columna.
- Los errores estandar robustos suelen ser **mas grandes**, y por lo tanto los
  $t$ mas chicos: MCO estaba siendo **demasiado optimista** sobre la precision.
- No siempre: en `CUARTOS` el robusto es levemente menor. La correccion va en la
  direccion que corresponda segun el patron real de la heterocedasticidad.
- En este caso ninguna conclusion cambia (todas siguen significativas), pero en
  un caso al filo si podria cambiar.

**Cuando usar cual**: si se conoce la forma de la heterocedasticidad, WLS es mas
eficiente. Si no se conoce (lo habitual), **errores robustos** es la practica
estandar.

---

# Parte H - Consistencia

## 20. Definicion y demostracion

### Teoria

Un estimador $\hat\beta$ es **consistente** si converge al parametro cuando
$n\to\infty$:

$$\lim_{n\to\infty} P\left(|\hat\beta - \beta| < \varepsilon\right) = 1 \qquad\forall \varepsilon>0$$

Se escribe $plim(\hat\beta) = \beta$.

### Los dos supuestos necesarios

$$\text{(a)}\quad \frac{1}{n}\sum(x_i-\bar{x})^2 \to \sigma_x^2 < \infty$$

$$\text{(b)}\quad \frac{1}{n}\sum(x_i-\bar{x})u_i \to 0$$

(a) dice que la varianza de $X$ tiende a una constante finita. **(b) dice que el
regresor no esta correlacionado con el error en el limite** (exogeneidad).

### La demostracion

$$\hat\beta = \beta + \frac{\frac{1}{n}\sum(x_i-\bar{x})u_i}{\frac{1}{n}\sum(x_i-\bar{x})^2} \;\Longrightarrow\; plim(\hat\beta) = \beta + \frac{0}{\sigma_x^2} = \beta$$

### Que pasa si falla (b)

Si $\frac{1}{n}\sum(x_i-\bar{x})u_i \to A \ne 0$, entonces
$plim(\hat\beta) = \beta + A/\sigma_x^2 \ne \beta$ y **el estimador deja de ser
consistente**.

Esto es lo que ocurre con **variables omitidas correlacionadas con los regresores**,
error de medicion o simultaneidad. Es el problema de **endogeneidad**, y es mas
grave que la heterocedasticidad: no se arregla con mas datos ni con errores
robustos.

### Insesgadez vs consistencia

| | Que dice |
|---|---|
| **Insesgadez** | propiedad de muestra finita: $E(\hat\beta)=\beta$ |
| **Consistencia** | propiedad asintotica: $\hat\beta\to\beta$ cuando $n\to\infty$ |

Son independientes: un estimador puede ser insesgado e inconsistente, o sesgado y
consistente. En la practica **la consistencia es la propiedad minima aceptable**.

---

# Parte I - Ejercitacion 4

## 21. Regresion 1

### Codigo

```python
df = pd.read_excel('Bases de Datos MIA103/Ejemplo_Casa.xls',
                   sheet_name='HPRICE', usecols='A:L')

# el enunciado usa 545 obs: hay que sacar la unica casa con 4 banos
df = df[df['BANOS'] != 4].copy()

V = ['LOTE','CUARTOS','BANOS','PISOS','ENTRADA','REC',
     'SOTANO','CALEF','AIRE','GARAGE','NBHD']

reg1 = sm.OLS(df['PRECIO'], sm.add_constant(df[V])).fit()
print(reg1.summary())
```

### Salida verificada (coincide exactamente con el enunciado)

```text
n = 545     R2 = 0.664891     R2 adj = 0.657975
F = 96.1389   (gl: 11 y 533)   p-value = 7.67e-119
S.E. of regression = 15398.96    RSS = 1.26389e+11

variable       coef        std err       t        P>|t|
const      -3509.7393     3419.390    -1.026     0.305
LOTE           3.5341        0.350    10.102     0.000
CUARTOS     1909.3244     1046.422     1.825     0.069
BANOS      13829.4900     1519.347     9.102     0.000
PISOS       6492.6879      924.670     7.022     0.000
ENTRADA     6722.7877     2042.146     3.292     0.001
REC         4623.2425     1898.206     2.436     0.015
SOTANO      5506.6270     1585.876     3.472     0.001
CALEF      12995.3300     3214.103     4.043     0.000
AIRE       12622.7000     1552.591     8.130     0.000
GARAGE      4139.8173      841.671     4.919     0.000
NBHD        9469.9610     1667.598     5.679     0.000
```

### (a) Interpretar el coeficiente 4139.8 de GARAGE

Por cada **auto adicional** que entra en el garage, el precio esperado de la casa
aumenta **4139.82 dolares canadienses**, *ceteris paribus*.

GARAGE **no es dummy**: toma valores 0, 1, 2 o 3, asi que el efecto es por unidad
de capacidad, no una comparacion entre dos categorias.

### (b) Para que sirve el estadistico F = 96.14

$$H_0: \beta_{LOTE} = \beta_{CUARTOS} = \cdots = \beta_{NBHD} = 0 \quad (\text{las 11 pendientes son cero})$$
$$H_A: \text{al menos una pendiente es distinta de cero}$$

**Modelo bajo $H_0$**: $PRECIO_i = \alpha + u_i$. El precio solo se explica por una
constante mas ruido; ningun atributo importa.

**Modelo bajo $H_A$**: la regresion completa.

**Como esta calculado**:

$$F = \frac{(RRSS - URSS)/q}{URSS/(n-k)} = \frac{(TSS - RSS)/11}{RSS/533} = 96.1389$$

(bajo $H_0$, RRSS = TSS porque el modelo restringido solo tiene el intercepto).

**Conclusion**: con p-value practicamente cero se **rechaza $H_0$**. El conjunto de
atributos si explica el precio de las casas: el modelo sirve.

### (c) Puede haber multicolinealidad?

**No hay evidencia clara de multicolinealidad problematica.** El razonamiento:

El sintoma de multicolinealidad es varias variables con $t$ bajos junto a un $F$
global alto. Aca **10 de las 11 pendientes son significativas al 5%**, con $t$
entre 2.4 y 10.1. La unica dudosa es CUARTOS ($t = 1.825$, $p = 0.069$), que es
significativa al 10% pero no al 5%.

Con **una sola** variable en el limite no se puede diagnosticar multicolinealidad:
para eso harian falta al menos dos variables no significativas cuyo test F
conjunto si rechace.

Lo que si es razonable **sospechar** es correlacion entre CUARTOS y las demas
medidas de tamanio (LOTE, BANOS, PISOS): casas mas grandes tienen mas de todo. El
chequeo formal seria:

```python
print(reg1.f_test("CUARTOS = 0"))     # con una sola variable equivale al test t
df[V].corr()                          # mirar la matriz de correlaciones
```

### (d) Valor esperado de una casa especifica

Lote 5100, 3 cuartos, 2 banos, 2 pisos, con entrada, con rec, con calefaccion,
NBHD=1, **sin** garage, **sin** sotano, **sin** aire.

```python
x = pd.DataFrame([[1, 5100, 3, 2, 2, 1, 1, 0, 1, 0, 0, 1]],
                 columns=['const'] + V)
reg1.predict(x)
```

$$\widehat{PRECIO} = 94\,697.64 \text{ dolares canadienses}$$

Verificacion a mano:

$$-3509.74 + 3.5341(5100) + 1909.32(3) + 13829.49(2) + 6492.69(2)$$
$$+\; 6722.79 + 4623.24 + 0 + 12995.33 + 0 + 0 + 9469.96 = 94\,697.64$$

**Cuidado con el orden de las columnas**: SOTANO va antes que CALEF, y en el
enunciado se enumeran en otro orden. Es la fuente de error mas comun de este
inciso.

---

## 22. Regresion 2 (con dummies DB2 y DB3)

### Codigo

```python
df['DB2'] = (df['BANOS'] == 2).astype(int)
df['DB3'] = (df['BANOS'] == 3).astype(int)

V2 = ['LOTE','CUARTOS','PISOS','ENTRADA','REC','SOTANO',
      'CALEF','AIRE','GARAGE','NBHD','DB2','DB3']       # sale BANOS

reg2 = sm.OLS(df['PRECIO'], sm.add_constant(df[V2])).fit()
```

Equivalente con `get_dummies`:

```python
X2 = pd.get_dummies(df, columns=['BANOS'], drop_first=True, dtype=int)
```

### Salida verificada

```text
n = 545     R2 = 0.665005     R2 adj = 0.657449
F = 88.0071    RSS = 1.26346e+11

const      10308.9500    3464.573     2.976     0.003
LOTE           3.5268       0.351    10.062     0.000
DB2        13481.1800    1726.361     7.809     0.000
DB3        29392.5400    5079.824     5.786     0.000
```

### (e) Interpretar el coeficiente 29392.54 de DB3

Una casa con **exactamente 3 banos** vale, en promedio, **29392.54 dolares
canadienses mas que una casa con 1 bano** (la categoria base omitida), manteniendo
todo lo demas constante.

Es esencial aclarar **contra que se compara**. Como se incluyeron DB2 y DB3 pero
no DB1, la categoria de referencia es "1 bano" y quedo absorbida en el intercepto.

Comparando con la Regresion 1: alli BANOS entraba como variable continua con
$\hat\beta = 13829.49$, imponiendo que **cada bano extra vale lo mismo**. La
Regresion 2 libera ese supuesto: pasar de 1 a 2 banos vale 13481, pero de 1 a 3
vale 29393 (o sea, de 2 a 3 vale 15911). El efecto es aproximadamente lineal, lo
que explica por que el $R^2$ casi no mejora.

### (f) Intervalo de confianza del 95% para $\beta_{LOTE}$

Usando la normal como aproximacion (el enunciado lo permite):

$$3.526753 \pm 1.96 \times 0.350519 = [2.8397,\; 4.2138]$$

Con la $t$ exacta (532 gl, $CV = 1.9645$): $[2.8382,\; 4.2153]$.

```python
reg2.conf_int(alpha=0.05).loc['LOTE']
```

Practicamente identicos: con $n = 545$ la $t$ ya es indistinguible de la normal.
El intervalo **no contiene el cero**, coherente con $t = 10.06$.

### (g) Testear $\beta_{DB3} = 2\beta_{DB2}$

**Que significa la hipotesis**: que el efecto de tener 3 banos es exactamente **el
doble** del de tener 2 banos. Es decir, que el valor de cada bano adicional es
**constante** y no hay rendimientos decrecientes ni crecientes. La intuicion: si
el segundo bano agrega $X$, el tercero agrega otro $X$.

**Se puede hacer**: es una restriccion lineal sobre los coeficientes, o sea un
test F (o t) con $q=1$.

**Pasos**:

1. Reescribir la hipotesis como restriccion lineal:
   $$H_0: \beta_{DB3} - 2\beta_{DB2} = 0 \qquad\qquad H_A: \beta_{DB3} - 2\beta_{DB2} \ne 0$$
2. Correr el test:

```python
print(reg2.f_test("DB3 = 2 * DB2"))
print(reg2.t_test("DB3 - 2*DB2 = 0"))     # equivalente
```

Con matriz de restricciones:

```python
r = np.zeros(len(reg2.params))
r[reg2.params.index.get_loc("DB3")] =  1
r[reg2.params.index.get_loc("DB2")] = -2
print(reg2.f_test(r))
```

### Salida verificada

```text
F test: F = 0.18151    p = 0.67025    df_num = 1    df_denom = 532

t-test equivalente:
    estimacion de (DB3 - 2*DB2) = 2430.18
    std err = 5704.06        t = 0.426       p = 0.670
```

### Conclusion

El p-value es $0.670$, mucho mayor que $0.05$. **No se rechaza $H_0$** al 5%.

No hay evidencia de que el efecto del tercer bano sea distinto del doble del
segundo. La estimacion puntual de $\beta_{DB3}-2\beta_{DB2}$ es $2430.18$
(sugeriria un leve rendimiento creciente), pero su error estandar es $5704.06$:
el efecto no se distingue de cero.

Notar que $F = t^2$: $0.426^2 = 0.1815$. Con una sola restriccion los dos tests son
exactamente equivalentes.

---

## 23. Errores frecuentes

| Error | Por que pasa | Como se evita |
|---|---|---|
| Trampa de la dummy | incluir todas las categorias **con** intercepto | `drop_first=True`, o $c-1$ dummies |
| Interpretar dummy sin decir contra que | falta la categoria base | "respecto de la categoria omitida" |
| Interpretar $\beta$ sin *ceteris paribus* | se copia el habito de regresion simple | son derivadas **parciales** |
| Grados de libertad $n-2$ | quedo de la Clase 3 | son $n-k$ |
| Comparar modelos por $R^2$ | $R^2$ siempre sube | usar $\bar{R}^2$ |
| Interpretar $\beta_2$ y $\beta_3$ por separado con cuadraticos | son un solo efecto | derivada parcial $\hat\beta_2 + 2\hat\beta_3 x$ |
| Interaccion sin efectos principales | `x1:x2` en vez de `x1*x2` | incluir siempre los principales |
| Concluir "no significativa" con multicolinealidad | los $t$ estan deflactados | test F conjunto y eliminar de a una |
| Usar `sheet_name` / `usecols` mal | el Excel tiene layout fijo | `usecols='A:L'`, `sheet_name='HPRICE'` |
| Olvidar filtrar la casa de 4 banos | el enunciado usa 545, no 546 | `df[df['BANOS'] != 4]` |
| Orden de columnas en `predict` | la lista de variables no coincide | armar el `DataFrame` con `columns=exog_names` |
| Creer que heterocedasticidad sesga | sesga la **varianza**, no el coeficiente | MCO sigue insesgado; falla la inferencia |
| Pasar a `het_white` una X sin la constante | necesita la matriz de diseno completa | pasar `reg.model.exog` |

---

## 24. Checklist de Clases 4 y 5

Al terminar deberias poder:

1. Escribir el modelo multiple y sus ecuaciones normales.
2. Explicar por que se llaman "normales" y que no es por la distribucion.
3. Escribir $\hat\beta_1$ y $\hat\beta_2$ en terminos de los $S_{jk}$.
4. Derivar $Var(\hat\beta_1) = \sigma^2/[S_{11}(1-r_{12}^2)]$.
5. Distinguir multicolinealidad perfecta de alta.
6. Explicar por que la perfecta impide una solucion unica.
7. Diagnosticar multicolinealidad con el test F y eliminando de a una.
8. Interpretar coeficientes como derivadas parciales con *ceteris paribus*.
9. Definir $R^2$ ajustado y explicar por que hace falta.
10. Saber que los gl son $n-k$.
11. Plantear un test t para $H_0:\beta_j = c$ en `statsmodels`.
12. Escribir el estadistico F general y decir que es RRSS, URSS, $q$ y $k$.
13. Explicar que testea el F de la salida y cual es el modelo bajo $H_0$.
14. Testear una restriccion lineal del tipo $\beta_3 = 2\beta_2$.
15. Explicar los cuatro modelos con dummies y por que el cuarto esta mal.
16. Interpretar el coeficiente de una dummy contra la categoria base.
17. Interpretar modelos log-log, log-nivel y nivel-log.
18. Interpretar terminos cuadraticos e interacciones via derivada parcial.
19. Escribir $\hat\beta = (X'X)^{-1}X'y$ y $Var(\hat\beta)=\sigma^2(X'X)^{-1}$.
20. Resolver el ejemplo matricial del PDF a mano.
21. Definir $P$ y $M$ y explicar que son idempotentes y que proyectan.
22. Calcular el sesgo por variable relevante omitida y su direccion.
23. Explicar el trade-off sesgo-varianza y el MSE.
24. Explicar por que incluir una irrelevante es menos grave que omitir una relevante.
25. Enunciar que consecuencias tiene la heterocedasticidad y cuales no.
26. Explicar por que WLS soluciona el problema.
27. Describir los tres tests de heterocedasticidad y sus estadisticos.
28. Correr errores robustos y explicar que corrigen.
29. Definir consistencia y demostrarla en regresion simple.
30. Explicar que pasa si el regresor esta correlacionado con el error.

---

## 25. Notas tecnicas

- Dependencias: `pandas`, `numpy`, `matplotlib`, `scipy`, `statsmodels`,
  `seaborn`, `openpyxl` y `xlrd` (para leer `.xls`, no `.xlsx`).
- Los notebooks leen `Ejemplo_Casa.xls` y `CEO_ejemplo_multicolinealidad.xlsx` sin
  ruta; en el repo estan en `Bases de Datos MIA103/`.
- `Ejemplo_Casa.xls` es formato `.xls` viejo: necesita `xlrd`, no `openpyxl`.
- La base tiene **546** observaciones; el enunciado de la practica usa **545**
  porque saca la unica casa con 4 banos.
- `pd.set_option('display.float_format', '{:.6f}'.format)` evita la notacion
  cientifica al mirar coeficientes chicos.
- En `get_dummies`, `dtype=int` evita columnas booleanas que pueden dar problemas
  al pasarlas a `sm.OLS`.
- `f_test` acepta string, matriz $R$, o tupla $(R, q)$. El string es lo mas legible.
- `get_robustcov_results` devuelve un objeto de resultados **distinto**: los
  coeficientes se acceden por posicion, no por nombre.
- `het_goldfeldquandt` necesita `alternative='increasing'` si se sospecha que la
  varianza **crece** con el regresor elegido.
