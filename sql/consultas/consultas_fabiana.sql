
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

-- consulta 2: mostrat nivel de riesgo y estado de atencion
SELECT
u.nombres,
u.apellidos,
a.tipo_alerta,
a.nivel_riesgo,
a.mensaje,
a.fecha_emision,
a.estado_atencion
FROM dbo.alerta a
INNER JOIN dbo.registro_biometrico rb
ON a.id_registro_biometrico = rb.id_registro_biometrico
INNER JOIN dbo.deportista d
ON rb.id_deportista = d.id_deportista
INNER JOIN dbo.usuario u
ON d.id_usuario = u.id_usuario
ORDER BY a.fecha_emision DESC;

-- consulta 3: consultar protocolos de rehabilitacion (con informacion de lesión, deportista y especilista responsable)
SELECT
pr.nombre AS protocolo,
pr.objetivo,
pr.fecha_inicio,
pr.fecha_estimada_fin,
pr.estado AS estado_protocolo,
u_deportista.nombres + ' ' + u_deportista.apellidos AS deportista,
l.zona_corporal,
l.tipo_lesion,
l.gravedad,
u_especialista.nombres + ' ' + u_especialista.apellidos AS especialista,
e.especialidad
FROM dbo.protocolo_rehabilitacion pr
INNER JOIN dbo.lesion l
ON pr.id_lesion = l.id_lesion
INNER JOIN dbo.deportista d
ON l.id_deportista = d.id_deportista
INNER JOIN dbo.usuario u_deportista
ON d.id_usuario = u_deportista.id_usuario
INNER JOIN dbo.especialista e
ON pr.id_especialista = e.id_especialista
INNER JOIN dbo.usuario u_especialista
ON e.id_usuario = u_especialista.id_usuario
ORDER BY pr.fecha_inicio DESC;

