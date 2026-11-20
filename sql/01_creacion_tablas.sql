
CREATE DATABASE AthleCare;
GO
USE AthleCare;
GO

-- tablas base y catálogos
CREATE TABLE dbo.usuario (
    id_usuario INT IDENTITY(1,1) PRIMARY KEY,
    nombres VARCHAR(80) NOT NULL,
    apellidos VARCHAR(80) NOT NULL,
    correo VARCHAR(120) NOT NULL,
    contrasena_hash VARCHAR(255) NOT NULL,
    telefono VARCHAR(15) NULL,
    rol VARCHAR(20) NOT NULL,
    fecha_registro DATETIME2 NOT NULL DEFAULT SYSDATETIME(),
    estado VARCHAR(10) NOT NULL DEFAULT 'ACTIVO',
    CONSTRAINT uq_usuario_correo UNIQUE (correo),
    CONSTRAINT ck_usuario_correo CHECK (correo LIKE '%_@_%._%'),
    CONSTRAINT ck_usuario_rol CHECK (rol IN ('DEPORTISTA', 'ESPECIALISTA')),
    CONSTRAINT ck_usuario_estado CHECK (estado IN ('ACTIVO', 'INACTIVO'))
);
GO

CREATE TABLE dbo.institucion (
    id_institucion INT IDENTITY(1,1) PRIMARY KEY,
    nombre VARCHAR(120) NOT NULL,
    tipo VARCHAR(30) NOT NULL,
    ciudad VARCHAR(60) NOT NULL,
    CONSTRAINT uq_institucion_nombre_ciudad UNIQUE (nombre, ciudad),
    CONSTRAINT ck_institucion_tipo CHECK (
        tipo IN ('CLUB', 'ACADEMIA', 'CENTRO_ALTO_RENDIMIENTO', 'CENTRO_TERAPIA', 'INSTITUCION_EDUCATIVA')
    )
);
GO

CREATE TABLE dbo.disciplina (
    id_disciplina INT IDENTITY(1,1) PRIMARY KEY,
    nombre VARCHAR(60) NOT NULL,
    CONSTRAINT uq_disciplina_nombre UNIQUE (nombre)
);
GO



-- perfiles y asignación
CREATE TABLE dbo.deportista (
    id_deportista INT IDENTITY(1,1) PRIMARY KEY,
    id_usuario INT NOT NULL,
    id_institucion INT NOT NULL,
    id_disciplina INT NOT NULL,
    fecha_nacimiento DATE NOT NULL,
    peso_kg DECIMAL(5,2) NULL,
    estatura_cm DECIMAL(5,1) NULL,
    posicion VARCHAR(40) NULL,
    categoria VARCHAR(40) NULL,
    CONSTRAINT uq_deportista_usuario UNIQUE (id_usuario),
    CONSTRAINT fk_deportista_usuario FOREIGN KEY (id_usuario) REFERENCES dbo.usuario(id_usuario),
    CONSTRAINT fk_deportista_institucion FOREIGN KEY (id_institucion) REFERENCES dbo.institucion(id_institucion),
    CONSTRAINT fk_deportista_disciplina FOREIGN KEY (id_disciplina) REFERENCES dbo.disciplina(id_disciplina),
    CONSTRAINT ck_deportista_fecha_nac CHECK (fecha_nacimiento < CAST(GETDATE() AS DATE)),
    CONSTRAINT ck_deportista_peso CHECK (peso_kg IS NULL OR peso_kg > 0),
    CONSTRAINT ck_deportista_estatura CHECK (estatura_cm IS NULL OR estatura_cm > 0)
);
GO

CREATE TABLE dbo.especialista (
    id_especialista INT IDENTITY(1,1) PRIMARY KEY,
    id_usuario INT NOT NULL,
    id_institucion INT NOT NULL,
    especialidad VARCHAR(30) NOT NULL,
    numero_colegiatura VARCHAR(20) NULL,
    CONSTRAINT uq_especialista_usuario UNIQUE (id_usuario),
    CONSTRAINT fk_especialista_usuario FOREIGN KEY (id_usuario) REFERENCES dbo.usuario(id_usuario),
    CONSTRAINT fk_especialista_institucion FOREIGN KEY (id_institucion) REFERENCES dbo.institucion(id_institucion),
    CONSTRAINT ck_especialista_especialidad CHECK (
        especialidad IN ('ENTRENADOR', 'PREPARADOR_FISICO', 'FISIOTERAPEUTA', 'MEDICO_DEPORTOLOGO')
    )
);
GO

CREATE UNIQUE INDEX uq_especialista_colegiatura
    ON dbo.especialista (numero_colegiatura)
    WHERE numero_colegiatura IS NOT NULL;
GO

CREATE TABLE dbo.asignacion_especialista (
    id_deportista INT NOT NULL,
    id_especialista INT NOT NULL,
    fecha_inicio DATE NOT NULL DEFAULT CAST(GETDATE() AS DATE),
    fecha_fin DATE NULL,
    CONSTRAINT pk_asignacion_especialista PRIMARY KEY (id_deportista, id_especialista, fecha_inicio),
    CONSTRAINT fk_asig_deportista FOREIGN KEY (id_deportista) REFERENCES dbo.deportista(id_deportista),
    CONSTRAINT fk_asig_especialista FOREIGN KEY (id_especialista) REFERENCES dbo.especialista(id_especialista),
    CONSTRAINT ck_asig_fechas CHECK (fecha_fin IS NULL OR fecha_fin >= fecha_inicio)
);
GO

-- biometría, alertas, lesiones, rehabilitación, retorno
CREATE TABLE dbo.registro_biometrico (
    id_registro_biometrico INT IDENTITY(1,1) PRIMARY KEY,
    id_deportista INT NOT NULL,
    fecha_registro DATE NOT NULL DEFAULT CAST(GETDATE() AS DATE),
    rpe TINYINT NOT NULL,
    duracion_sesion_min SMALLINT NULL,
    horas_sueno DECIMAL(4,2) NOT NULL,
    calidad_sueno TINYINT NOT NULL,
    nivel_dolor TINYINT NOT NULL,
    hrv_ms DECIMAL(5,1) NULL,
    frecuencia_cardiaca_reposo SMALLINT NULL,
    CONSTRAINT uq_registro_deportista_fecha UNIQUE (id_deportista, fecha_registro),
    CONSTRAINT fk_reg_bio_deportista FOREIGN KEY (id_deportista) REFERENCES dbo.deportista(id_deportista),
    CONSTRAINT ck_reg_bio_rpe CHECK (rpe BETWEEN 0 AND 10),
    CONSTRAINT ck_reg_bio_duracion CHECK (duracion_sesion_min IS NULL OR duracion_sesion_min >= 0),
    CONSTRAINT ck_reg_bio_sueno CHECK (horas_sueno BETWEEN 0 AND 24),
    CONSTRAINT ck_reg_bio_calidad CHECK (calidad_sueno BETWEEN 1 AND 5),
    CONSTRAINT ck_reg_bio_dolor CHECK (nivel_dolor BETWEEN 0 AND 10),
    CONSTRAINT ck_reg_bio_hrv CHECK (hrv_ms IS NULL OR hrv_ms > 0),
    CONSTRAINT ck_reg_bio_fc CHECK (frecuencia_cardiaca_reposo IS NULL OR frecuencia_cardiaca_reposo BETWEEN 25 AND 220)
);
GO

CREATE TABLE dbo.alerta (
    id_alerta INT IDENTITY(1,1) PRIMARY KEY,
    id_registro_biometrico INT NOT NULL,
    id_especialista INT NULL,
    tipo_alerta VARCHAR(20) NOT NULL,
    nivel_riesgo VARCHAR(10) NOT NULL,
    mensaje VARCHAR(300) NOT NULL,
    fecha_emision DATETIME2 NOT NULL DEFAULT SYSDATETIME(),
    estado_atencion VARCHAR(10) NOT NULL DEFAULT 'PENDIENTE',
    fecha_atencion DATETIME2 NULL,
    CONSTRAINT uq_alerta_registro_tipo UNIQUE (id_registro_biometrico, tipo_alerta),
    CONSTRAINT fk_alerta_registro FOREIGN KEY (id_registro_biometrico) REFERENCES dbo.registro_biometrico(id_registro_biometrico),
    CONSTRAINT fk_alerta_especialista FOREIGN KEY (id_especialista) REFERENCES dbo.especialista(id_especialista),
    CONSTRAINT ck_alerta_tipo CHECK (tipo_alerta IN ('FATIGA', 'SUENO', 'DOLOR', 'CARGA')),
    CONSTRAINT ck_alerta_riesgo CHECK (nivel_riesgo IN ('BAJO', 'MEDIO', 'ALTO', 'CRITICO')),
    CONSTRAINT ck_alerta_estado CHECK (estado_atencion IN ('PENDIENTE', 'ATENDIDA'))
);
GO

CREATE TABLE dbo.lesion (
    id_lesion INT IDENTITY(1,1) PRIMARY KEY,
    id_deportista INT NOT NULL,
    id_especialista INT NOT NULL,
    zona_corporal VARCHAR(60) NOT NULL,
    lateralidad VARCHAR(10) NOT NULL DEFAULT 'NO_APLICA',
    tipo_lesion VARCHAR(60) NOT NULL,
    gravedad VARCHAR(10) NOT NULL,
    fecha_lesion DATE NOT NULL,
    es_recidiva BIT NOT NULL DEFAULT 0,
    estado VARCHAR(20) NOT NULL DEFAULT 'ACTIVA',
    descripcion VARCHAR(500) NULL,
    CONSTRAINT fk_lesion_deportista FOREIGN KEY (id_deportista) REFERENCES dbo.deportista(id_deportista),
    CONSTRAINT fk_lesion_especialista FOREIGN KEY (id_especialista) REFERENCES dbo.especialista(id_especialista),
    CONSTRAINT ck_lesion_lateralidad CHECK (lateralidad IN ('IZQUIERDA', 'DERECHA', 'BILATERAL', 'NO_APLICA')),
    CONSTRAINT ck_lesion_gravedad CHECK (gravedad IN ('LEVE', 'MODERADA', 'SEVERA')),
    CONSTRAINT ck_lesion_estado CHECK (estado IN ('ACTIVA', 'EN_REHABILITACION', 'ALTA'))
);
GO

CREATE TABLE dbo.protocolo_rehabilitacion (
    id_protocolo_rehabilitacion INT IDENTITY(1,1) PRIMARY KEY,
    id_lesion INT NOT NULL,
    id_especialista INT NOT NULL,
    nombre VARCHAR(100) NOT NULL,
    objetivo VARCHAR(300) NOT NULL,
    fecha_inicio DATE NOT NULL,
    fecha_estimada_fin DATE NULL,
    estado VARCHAR(15) NOT NULL DEFAULT 'ACTIVO',
    CONSTRAINT fk_prot_lesion FOREIGN KEY (id_lesion) REFERENCES dbo.lesion(id_lesion),
    CONSTRAINT fk_prot_especialista FOREIGN KEY (id_especialista) REFERENCES dbo.especialista(id_especialista),
    CONSTRAINT ck_prot_fechas CHECK (fecha_estimada_fin IS NULL OR fecha_estimada_fin >= fecha_inicio),
    CONSTRAINT ck_prot_estado CHECK (estado IN ('ACTIVO', 'FINALIZADO', 'SUSPENDIDO'))
);
GO


CREATE UNIQUE INDEX uq_protocolo_activo_por_lesion
    ON dbo.protocolo_rehabilitacion (id_lesion)
    WHERE estado = 'ACTIVO';
GO

CREATE TABLE dbo.fase_rehabilitacion (
    id_fase_rehabilitacion INT IDENTITY(1,1) PRIMARY KEY,
    id_protocolo_rehabilitacion INT NOT NULL,
    numero_fase TINYINT NOT NULL,
    nombre VARCHAR(80) NOT NULL,
    descripcion VARCHAR(500) NULL,
    duracion_estimada_dias SMALLINT NULL,
    estado VARCHAR(12) NOT NULL DEFAULT 'PENDIENTE',
    CONSTRAINT uq_fase_protocolo_numero UNIQUE (id_protocolo_rehabilitacion, numero_fase),
    CONSTRAINT fk_fase_protocolo FOREIGN KEY (id_protocolo_rehabilitacion) REFERENCES dbo.protocolo_rehabilitacion(id_protocolo_rehabilitacion),
    CONSTRAINT ck_fase_numero CHECK (numero_fase >= 1),
    CONSTRAINT ck_fase_duracion CHECK (duracion_estimada_dias IS NULL OR duracion_estimada_dias > 0),
    CONSTRAINT ck_fase_estado CHECK (estado IN ('PENDIENTE', 'EN_CURSO', 'COMPLETADA'))
);
GO

CREATE TABLE dbo.ejercicio (
    id_ejercicio INT IDENTITY(1,1) PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    categoria VARCHAR(20) NOT NULL,
    descripcion VARCHAR(500) NULL,
    url_video VARCHAR(300) NULL,
    CONSTRAINT uq_ejercicio_nombre UNIQUE (nombre),
    CONSTRAINT ck_ejercicio_categoria CHECK (
        categoria IN ('MOVILIDAD', 'FUERZA', 'ISOMETRICO', 'PROPIOCEPCION', 'RESISTENCIA')
    )
);
GO

CREATE TABLE dbo.fase_ejercicio (
    id_fase_rehabilitacion INT NOT NULL,
    id_ejercicio INT NOT NULL,
    orden TINYINT NOT NULL,
    series TINYINT NOT NULL,
    repeticiones TINYINT NULL,
    duracion_segundos SMALLINT NULL,
    descanso_segundos SMALLINT NOT NULL DEFAULT 60,
    carga_recomendada VARCHAR(60) NULL,
    CONSTRAINT pk_fase_ejercicio PRIMARY KEY (id_fase_rehabilitacion, id_ejercicio),
    CONSTRAINT uq_fase_ejercicio_orden UNIQUE (id_fase_rehabilitacion, orden),
    CONSTRAINT fk_fe_fase FOREIGN KEY (id_fase_rehabilitacion) REFERENCES dbo.fase_rehabilitacion(id_fase_rehabilitacion),
    CONSTRAINT fk_fe_ejercicio FOREIGN KEY (id_ejercicio) REFERENCES dbo.ejercicio(id_ejercicio),
    CONSTRAINT ck_fe_orden CHECK (orden >= 1),
    CONSTRAINT ck_fe_series CHECK (series > 0),
    CONSTRAINT ck_fe_repeticiones CHECK (repeticiones IS NULL OR repeticiones > 0),
    CONSTRAINT ck_fe_duracion CHECK (duracion_segundos IS NULL OR duracion_segundos > 0),
    CONSTRAINT ck_fe_dosificacion CHECK (repeticiones IS NOT NULL OR duracion_segundos IS NOT NULL),
    CONSTRAINT ck_fe_descanso CHECK (descanso_segundos >= 0)
);
GO


CREATE TABLE dbo.evaluacion_retorno (
    id_evaluacion_retorno INT IDENTITY(1,1) PRIMARY KEY,
    id_protocolo_rehabilitacion INT NOT NULL,
    id_especialista INT NOT NULL,
    fecha_evaluacion DATE NOT NULL DEFAULT CAST(GETDATE() AS DATE),
    puntaje DECIMAL(5,2) NULL,
    resultado VARCHAR(20) NOT NULL,
    observaciones VARCHAR(500) NULL,
    CONSTRAINT fk_eval_protocolo FOREIGN KEY (id_protocolo_rehabilitacion) REFERENCES dbo.protocolo_rehabilitacion(id_protocolo_rehabilitacion),
    CONSTRAINT fk_eval_especialista FOREIGN KEY (id_especialista) REFERENCES dbo.especialista(id_especialista),
    CONSTRAINT ck_eval_puntaje CHECK (puntaje IS NULL OR (puntaje BETWEEN 0 AND 100)),
    CONSTRAINT ck_eval_resultado CHECK (resultado IN ('APTO', 'RETORNO_PROGRESIVO', 'NO_APTO'))
);
GO