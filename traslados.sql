SELECT
  s.id,
  s.rnp_seq_number     AS rnp_seq_numb,
  s.dni_solicitante    AS DNI,
  s.nombre_solicitante AS Nombre,
  -- remove both “a las” and stray “ho” in one regex pass, then trim whitespace
  TRIM(
    REGEXP_REPLACE(s.fecha_solicitud, '(a las|ho)', '')
  )                    AS Fecha_solicitud,
  s.depto_origen       AS Depto_origen,
  s.ciudad_origen      AS Ciudad_origen,
  p.nombre             AS Pais_Destino,
  c.nombre             AS Consulado_Destino,
  s.rnp_lote           AS Lote,
  s.seq_numb           AS Sobre,
  s.tel                AS Telefono
FROM solicitudes_traslado_dni_internacional AS s
JOIN paises                  AS p ON p.id = s.pais_destino
JOIN consulados_paises       AS c ON c.id = s.ciudad_destino
WHERE s.id >= 1145
ORDER BY s.id ASC;
