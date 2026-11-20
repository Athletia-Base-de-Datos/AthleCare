
USE AthleCare;
GO

INSERT INTO dbo.institucion (nombre, tipo, ciudad) VALUES
('Centro Médico Deportivo Lima', 'CENTRO_TERAPIA', 'Lima'),
('Club Deportivo San Isidro', 'CLUB', 'Lima');
GO

INSERT INTO dbo.disciplina (nombre) VALUES
('Fútbol'),
('Atletismo');
GO

INSERT INTO dbo.usuario (nombres, apellidos, correo, contrasena_hash, telefono, rol, estado) VALUES
('Diego', 'Saavedra', 'diego.saavedra@correo.com', 'hash_demo_1', '987654321', 'DEPORTISTA', 'ACTIVO'),
('Camila', 'Torres', 'camila.torres@correo.com', 'hash_demo_2', '912345678', 'ESPECIALISTA', 'ACTIVO');
GO

INSERT INTO dbo.deportista (id_usuario, id_institucion, id_disciplina, fecha_nacimiento, peso_kg, estatura_cm, posicion, categoria) VALUES
(1, 2, 1, '2007-04-15', 72.50, 178.0, 'Mediocampista', 'Sub-20');
GO

INSERT INTO dbo.especialista (id_usuario, id_institucion, especialidad, numero_colegiatura) VALUES
(2, 1, 'FISIOTERAPEUTA', 'COL-45892');
GO

INSERT INTO dbo.asignacion_especialista (id_deportista, id_especialista, fecha_inicio, fecha_fin) VALUES
(1, 1, '2026-10-01', NULL);
GO

INSERT INTO dbo.registro_biometrico (id_deportista, fecha_registro, rpe, duracion_sesion_min, horas_sueno, calidad_sueno, nivel_dolor, hrv_ms, frecuencia_cardiaca_reposo) VALUES
(1, '2026-11-18', 7, 75, 7.50, 4, 2, 68.0, 56);
GO

INSERT INTO dbo.alerta (id_registro_biometrico, id_especialista, tipo_alerta, nivel_riesgo, mensaje, estado_atencion, fecha_atencion) VALUES
(1, NULL, 'DOLOR', 'MEDIO', 'Molestia leve reportada tras sesión de entrenamiento.', 'PENDIENTE', NULL);
GO

INSERT INTO dbo.lesion (id_deportista, id_especialista, zona_corporal, lateralidad, tipo_lesion, gravedad, fecha_lesion, es_recidiva, estado, descripcion) VALUES
(1, 1, 'Rodilla', 'DERECHA', 'Tendinopatía rotuliana', 'MODERADA', '2026-11-10', 0, 'EN_REHABILITACION', 'Dolor progresivo al cargar.');
GO

INSERT INTO dbo.protocolo_rehabilitacion (id_lesion, id_especialista, nombre, objetivo, fecha_inicio, fecha_estimada_fin, estado) VALUES
(1, 1, 'Protocolo Rodilla Fase Inicial', 'Reducir dolor e inflamación y recuperar rango de movimiento', '2026-11-11', '2026-12-10', 'ACTIVO');
GO

INSERT INTO dbo.fase_rehabilitacion (id_protocolo_rehabilitacion, numero_fase, nombre, descripcion, duracion_estimada_dias, estado) VALUES
(1, 1, 'Control de síntomas y movilidad', 'Ejercicios isométricos y movilidad articular sin dolor', 14, 'EN_CURSO');
GO

INSERT INTO dbo.ejercicio (nombre, categoria, descripcion, url_video) VALUES
('Isométrico de cuádriceps en pared', 'ISOMETRICO', 'Mantener posición sin provocar dolor agudo', NULL);
GO

INSERT INTO dbo.fase_ejercicio (id_fase_rehabilitacion, id_ejercicio, orden, series, repeticiones, duracion_segundos, descanso_segundos, carga_recomendada) VALUES
(1, 1, 1, 4, NULL, 45, 60, 'Peso corporal');
GO


INSERT INTO dbo.evaluacion_retorno (id_protocolo_rehabilitacion, id_especialista, fecha_evaluacion, puntaje, resultado, observaciones) VALUES
(1, 1, '2026-11-19', 75.00, 'RETORNO_PROGRESIVO', 'Buena tolerancia a cargas controladas.');
GO


