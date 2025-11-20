USE GD2C2025
GO

--Categorías y Turnos más solicitados:
CREATE VIEW Categorias_Turnos
    (categoría, turno)
AS SELECT ct.descripcion, t.descripcion
    FROM cursos cr
    JOIN categorias ct  ON cr.id_categoria = ct.id_categoria
    JOIN turnos t       ON cr.tipo_turno = t.tipo_turno

--Tasa de rechazo de inscripciones:

CREATE VIEW Tasa_Reachazos_Inscr (tasa_mes, mes, sede)
AS
 SELECT (SUM(SELECT COUNT(*) FROM Inscripcion WHERE = sede )/SUM(SELECT COUNT(*) FROM ) * 100) AS promedio_mes, sede 
 FROM Inscripcion ins
 GROUP BY mes, sede
 ORDER BY mes, sede

--Comparación de desmpeño de cursada por sede:

CREATE VIEW comp_desempeño (porc_aprobado, sede, año)
AS
 SELECT (SELECT SUM(*) FROM alumno a WHERE/SELECT SUM() FROM * 100) AS porc_aprobado, sede, año
 FROM 
 GROUP BY sede, año
 ORDER BY sede, año

--Tiempo promedio de finalización de curso:

CREATE VIEW promedio_finalizacion_curso(prom_tiempo, curso, año)
AS
 SELECT (SUM(SELECT - SELECT)/SELECT COUNT(*)) AS prom_tiempo, curso, año
 FROM 
 GROUP BY curso, año
 ORDER BY curso, año

--Nota promedio de finales:

CREATE VIEW promedio_finales (prom_notas, alumno_rango_etario, Curso_Categoria)
AS
 SELECT (SELECT SUM() /SELECT COUNT()) AS prom_notas, alumno_rango_etario, Curso_Categoria
 FROM
 GROUP BY alumno_rango_etario, Curso_Categoria
 ORDER BY alumno_rango_etario, Curso_Categoria

--Tasa de ausentismo finales:

CREATE VIEW ausentismo_finales (porc_ausent, semestre, sede)
AS
 SELECT (SELECT COUNT() / SELECT COUNT () * 100) AS porc_ausent, semestre, sede
 FROM
 GROUP BY semestre, sede
 ORDER BY semestre, sede

--Desvío de pagos:

CREATE VIEW Desvio_pagos(porc_pagos, semestre)
AS
 SELECT ((COUNT(*)/ SELECT COUNT(*) FROM pago) * 100) AS porc_pagos,
  semestre = CASE fecha_pago --supondré que por semestre se refiere a CUANDO fue pagado y no CUANDO expiró.
  WHEN (acortar a mes comparativo) THEN 'primer semestre'
  ELSE 'segundo semestre'
 FROM pago p JOIN factura f ON (p.factura_numero = f.factura_numero)
 WHERE (p.fecha_pago > f.Factura_FechaVencimiento)
 GROUP BY semestre
 ORDER BY semestre

-- el COUNT(*) FROM pago trae de TODOS los pagos, no los casos mensuales específicamente.

--Tasa de Morosidad Financiera mensual:

CREATE VIEW Morosidad_financiera_mensual (Tasa_Morosidad, monto_adeudado, mes)
AS
 SELECT (SELECT COUNT(*)/ SELECT SUM(*)) AS Tasa_Morosidad, monto_adeudado, mes
 FROM
 GROUP BY mes
 ORDER BY mes

--Ingresos por categoría de cursos:

CREATE VIEW ingresos_categoría_cursos (categoria_curso, ingresos, sede, año)
AS
 SELECT TOP 3 categoria_curso, (SELECT SUM(*)) ingresos, sede, año
 FROM
 GROUP BY
 ORDER BY categoria_curso, año, sede

--Índice de satisfacción:

CREATE VIEW indice_satisfaccion (satisfaccion_anual, profesor_rango_etario, sede)
AS
 SELECT ( ((%satisfechos - %insatisfechos) +100)/2) AS satisfaccion_anual
 FROM
 GROUP BY profesor_rango_etario, sede
 ORDER BY profesor_rango_etario, sede