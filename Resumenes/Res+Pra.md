# Guia de teoria + practica + Python

Indice general. El desarrollo completo esta separado por clase dentro de
`Teoria_y_Practica/`.

Cada clase mapea **teoria (PDF) - codigo de la clase (notebooks) - ejercitacion**,
y cada tema sigue el mismo recorrido:

$$\text{teoria} \;\rightarrow\; \text{para que sirve} \;\rightarrow\; \text{codigo generico} \;\rightarrow\; \text{como leer la salida}$$

Las salidas numericas de las guias fueron **reproducidas ejecutando el codigo de
cada clase sobre las bases del repositorio**, no copiadas de los notebooks.

## Clases

| Clase | Temas | Teoria | Practica | Guia |
|---|---|---|---|---|
| 1 | Retornos simples y logaritmicos, normal, momentos, Jarque-Bera, QQ plot y mixturas | `MIA103_Clase_1.pdf` | Ejer. 1 | [Abrir Clase 1](Teoria_y_Practica/Clase_01.md) |
| 2 | PBI, tasas de crecimiento, escala logaritmica, tendencia y ciclo, medias moviles y filtro HP | `MIA103_Clase_2.pdf` | Ejer. 2 | [Abrir Clase 2](Teoria_y_Practica/Clase_02.md) |
| 3 | Regresion simple, MCO, Gauss-Markov, inferencia, test t, p-value, IC y CAPM | `MIA103_Clase_3.pdf` | Ejer. 3 | [Abrir Clase 3](Teoria_y_Practica/Clase_03.md) |
| 4 y 5 | Regresion multiple, dummies, interacciones, notacion matricial, multicolinealidad y heterocedasticidad | `MIA103_Clase_4.pdf` | Ejer. 4 | [Abrir Clases 4 y 5](Teoria_y_Practica/Clase_04_y_05.md) |
| 6 | Ruido blanco, AR, MA, ARMA, random walk, autocovarianzas, ACF/PACF y Durbin-Watson | `MIA103_Clase_6.pdf` | Ejer. 5 | [Abrir Clase 6](Teoria_y_Practica/Clase_06.md) |
| 7 | Estacionariedad, raices unitarias, ADF, DFGLS, operador de rezagos, impulso-respuesta y cointegracion | `MIA103_Clase_7_.pdf` | Ejer. 6 | [Abrir Clase 7](Teoria_y_Practica/Clase_07.md) |
| 8 | VAR, autovalores, estabilidad, VEC, matriz de Jordan y causalidad de Granger | `MIA103_Clase_8_VAR_.pdf` | Ejer. 7 | [Abrir Clase 8](Teoria_y_Practica/Clase_08.md) |
| Pronosticos | Forecast dentro y fuera de muestra | `Pronósticos MIA103 Anual 2026.pdf` | - | Pendiente |
| 9 | Cointegracion y VECM | `MIA103_Clase_9_Anual 2026.pdf` | - | Pendiente |
| 9 adicional | Probit y Logit | `MIA103_Clase_9_Probit_Logit.pdf` | - | Pendiente |

## Como esta armada cada guia

Todas tienen la misma estructura:

1. **Archivos de esta clase**: tabla con el PDF de teoria, los notebooks, la
   practica y las bases de datos.
2. **Mapa tema - PDF - notebook - practica**: en que pagina del PDF y en que celda
   del notebook esta cada tema.
3. **Desarrollo por tema**, con el recorrido de arriba.
4. **Resolucion de la ejercitacion** paso a paso, con las salidas verificadas.
5. **Errores frecuentes**: tabla de que sale mal, por que, y como evitarlo.
6. **Checklist** de lo que hay que poder explicar al terminar.
7. **Notas tecnicas**: dependencias, rutas y trampas de las librerias.

## Hilo conductor de la materia

```text
Clase 1     retornos y su distribucion (no son normales)
Clase 2     descomponer una serie en tendencia y ciclo
Clase 3     regresion simple e inferencia
Clases 4-5  regresion multiple; que pasa cuando fallan los supuestos
Clase 6     el error deja de ser ruido blanco: AR, MA, ARMA
Clase 7     la serie deja de ser estacionaria: raices unitarias y ADF
Clase 8     varias series a la vez: VAR, VEC y causalidad de Granger
```

Las Clases 6 a 8 se leen encadenadas: la condicion "raices fuera del circulo
unitario" de la Clase 7 reaparece en la Clase 8 como "autovalores dentro del
circulo unitario", y la cointegracion que se introduce en la Clase 7 es la que se
formaliza como VEC en la Clase 8.

## Rutas del repositorio

| Carpeta | Contenido |
|---|---|
| `Clases/` | PDFs de teoria |
| `Codigos/` | notebooks de clase |
| `Practicas/` | PDFs de ejercitaciones |
| `Practicas_Resueltas/` | resoluciones propias |
| `Bases de Datos MIA103/` | bases `.xlsx` / `.xls` / `.csv` |
| `Excels/` | planillas de clase |
| `Resumenes/Teoria_y_Practica/` | estas guias |

Varios notebooks leen los archivos **sin ruta** (por ejemplo `wheat.xlsx` en vez de
`Bases de Datos MIA103/wheat.xlsx`), porque estan pensados para Google Colab. Cada
guia lo aclara en su seccion de notas tecnicas.
