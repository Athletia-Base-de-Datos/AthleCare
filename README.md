# AthleCare - Base de Datos

Base de datos desarrollada para **AthleCare**, una solución orientada a la prevención de lesiones deportivas y la gestión inteligente de protocolos de rehabilitación.

## Descripción del proyecto

AthleCare busca facilitar el seguimiento del estado físico de los deportistas y la gestión de sus procesos de recuperación mediante el registro y organización de información relevante.

La propuesta contempla el almacenamiento de datos biométricos, el seguimiento de lesiones, la gestión de alertas y el control de protocolos de rehabilitación.

La base de datos permite organizar la información necesaria para apoyar el trabajo del equipo médico, fisioterapeutas y personal técnico, así como el seguimiento de la evolución de los deportistas.

## Segmentos objetivo

- **Deportistas:** información de los atletas registrados.
- **Especialistas:** datos del personal encargado del seguimiento y rehabilitación.
- **Instituciones y disciplinas:** organización de los deportistas según su institución y disciplina deportiva.


## Tecnologías utilizadas

- **SQL Server:** sistema gestor de base de datos utilizado para la implementación.
- **SQL:** lenguaje utilizado para la creación de tablas, inserción de datos y elaboración de consultas.
- **Visual Studio Code:** entorno de desarrollo utilizado para editar y ejecutar los scripts SQL.
- **Git:** control de versiones del proyecto.
- **GitHub:** alojamiento del repositorio y colaboración del equipo.

## Estructura del proyecto

```text
AthleCare/
├── sql/
│   ├── 01_creacion_tablas.sql
│   ├── 02_insertar_datos.sql
│   └── consultas/
│       ├── consultas_fabiana.sql
│       ├── consultas_jose.sql
│       ├── consultas_cesar.sql
│       ├── consultas_micaela.sql
│       └── consultas_yeray.sql
├── docs/
├── nosql/
└── README.md
```

## Organización de los scripts SQL

1. **Creación de tablas:** contiene las instrucciones para crear la estructura de la base de datos y establecer las relaciones entre las tablas.
2. **Inserción de datos:** contiene los registros de ejemplo necesarios para trabajar con la base de datos.
3. **Consultas SQL:** reúne las consultas desarrolladas por los integrantes del equipo para obtener información de la base de datos.

## Cómo ejecutar el proyecto

1. Descargar o clonar el repositorio.
2. Abrir la carpeta del proyecto en Visual Studio Code.
3. Verificar que se encuentre instalada la extensión de SQL Server.
4. Conectarse a una instancia de SQL Server.
5. Ejecutar el script `01_creacion_tablas.sql` para crear la estructura de la base de datos.
6. Ejecutar `02_insertar_datos.sql` para registrar los datos de ejemplo.
7. Abrir los archivos de la carpeta `sql/consultas/` y ejecutar las consultas correspondientes.

## Integrantes del equipo

| Integrante | Rama de trabajo | Responsabilidad |
|---|---|---|
| Aleesandro Reyes| `feature/consultas-yeray` | Desarrollo de consultas SQL |
| Fabiana Chumioque| `feature/consultas-fabiana` | Desarrollo de consultas SQL |
| Josue Navarro| `feature/consultas-josue` | Desarrollo de consultas SQL |
| Micaela Aguirre| `feature/consultas-micaela` | Desarrollo de consultas SQL |
| César Mirano | `feature/consultas-cesar` | Desarrollo de consultas SQL |


Cada integrante desarrolla sus consultas en su propia rama, manteniendo una organización individual del trabajo.

## Organización de ramas

Para el control de versiones y la colaboración del equipo se utiliza un flujo de trabajo basado
