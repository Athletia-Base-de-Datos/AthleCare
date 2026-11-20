
USE AthleCare;
GO

-- consulta 1: métrica biométricas y carga acumulada del deportista
SELECT
    d.id_deportista,
    u.nombres + ' ' + u.apellidos AS deportista,
    disc.nombre AS disciplina,
    inst.nombre AS institucion,
    COUNT(rb.id_registro_biometrico) AS total_registros,
    ROUND(AVG(CAST(rb.horas_sueno AS FLOAT)), 2) AS promedio_horas_sueno,
    ISNULL(SUM(CAST(rb.rpe AS INT) * ISNULL(rb.duracion_sesion_min, 0)), 0) AS carga_interna_total
FROM dbo.deportista d
INNER JOIN dbo.usuario u
    ON d.id_usuario = u.id_usuario
INNER JOIN dbo.disciplina disc
    ON d.id_disciplina = disc.id_disciplina
INNER JOIN dbo.institucion inst
    ON d.id_institucion = inst.id_institucion
LEFT JOIN dbo.registro_biometrico rb
    ON d.id_deportista = rb.id_deportista
GROUP BY
    d.id_deportista,
    u.nombres,
    u.apellidos,
    disc.nombre,
    inst.nombre
ORDER BY carga_interna_total DESC;
GO