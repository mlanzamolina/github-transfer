-- ("localhost", "vnrnp", "#HDelite9099", "rnphi")
-- 1) build the outfile path with today’s date (YYYY-MM-DD)
SET @out_path = CONCAT(
  'C:/Users/opc/Desktop/repor/reporte_solicitudes_entrega_',
  DATE_FORMAT(NOW(), '%Y-%m-%d'),
  '-nuevo.csv'
);

-- 2) assemble the SELECT (note inner quotes doubled for literal embedding)
SET @qry = '
SELECT
  s.id,
  s.rnp_seq_number     AS rnp_seq_numb,
  s.dni_solicitante    AS DNI,
  s.nombre_solicitante AS Nombre,
  CASE
    WHEN TRIM(s.fecha_solicitud) REGEXP ''^[0-9]{4}-[0-9]{2}-[0-9]{2} '' 
      THEN CAST(TRIM(s.fecha_solicitud) AS DATETIME)
    ELSE STR_TO_DATE(
      TRIM(REGEXP_REPLACE(s.fecha_solicitud, ''(a las|ho)'', '''')),
      ''%c/%e/%Y %r''
    )
  END AS Fecha_dt,
  s.depto_origen   AS Depto_origen,
  s.ciudad_origen  AS Ciudad_origen,
  p.nombre         AS Pais_Destino,
  c.nombre         AS Consulado_Destino,
  s.rnp_lote       AS Lote,
  s.tel            AS Telefono
FROM solicitudes_traslado_dni_internacional AS s
JOIN paises            AS p ON p.id = s.pais_destino
JOIN consulados_paises AS c ON c.id = s.ciudad_destino
WHERE s.id >= 1145
  AND (
    CASE
      WHEN TRIM(s.fecha_solicitud) REGEXP ''^[0-9]{4}-[0-9]{2}-[0-9]{2} '' 
        THEN CAST(TRIM(s.fecha_solicitud) AS DATETIME)
      ELSE STR_TO_DATE(
        TRIM(REGEXP_REPLACE(s.fecha_solicitud, ''(a las|ho)'', '''')),
        ''%c/%e/%Y %r''
      )
    END
  ) > ''2023-01-03 11:17:13''
ORDER BY Fecha_dt DESC
';

-- 3) tack on the dynamic OUTFILE clause
SET @full_sql = CONCAT(
  @qry,
  ' INTO OUTFILE ''', 
  @out_path, 
  ''' FIELDS TERMINATED BY '','' ENCLOSED BY ''"'' LINES TERMINATED BY ''\n'''
);

-- 4) prepare & run it
PREPARE stmt FROM @full_sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;
