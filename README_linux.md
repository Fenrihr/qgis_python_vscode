# Configuración de PyQGIS en Linux

Este documento describe cómo configurar un entorno de desarrollo para PyQGIS en Linux, tanto de forma automática usando un script bash como manualmente paso a paso con Conda.

## 🎯 Características

- ✅ Configuración automática con script bash
- ✅ Configuración manual paso a paso
- ✅ Detecta automáticamente la instalación de Conda
- ✅ Crea entorno virtual con QGIS y Python
- ✅ Genera configuración de workspace de VSCode
- ✅ Configura variables de entorno (.env)
- ✅ Actualiza .gitignore automáticamente
- ✅ Verifica la instalación de QGIS
- ✅ No requiere Python instalado para la configuración automática (usa bash puro)

## 📋 Requisitos previos

- **Conda** instalado (Miniconda o Anaconda)
  - [Descargar Miniconda](https://docs.conda.io/en/latest/miniconda.html)
- **VSCode** instalado
- Extensión de Python para VSCode
- Acceso a internet para descargar paquetes

## 🚀 Método 1: Configuración Automática

Script bash para configurar automáticamente el entorno de desarrollo de PyQGIS en Linux usando Conda.

### Ejecución básica

```bash
./setup_qgis_vscode_linux.sh
```

### Opciones durante la ejecución

El script te preguntará interactivamente:

1. **Si recrear el entorno existente** (si ya existe)
2. **Si sobrescribir archivos de configuración** (.env, workspace)
3. **Si verificar la instalación** de QGIS al finalizar

### Archivos generados

El script crea/actualiza los siguientes archivos:

- `qgis_env/` - Entorno Conda con QGIS
- `.env` - Variables de entorno para el proyecto
- `qgis.code-workspace` - Workspace de VSCode
- `.gitignore` - Actualizado con entradas necesarias

### ¿Qué hace el script?

1. **Detecta Conda**: Verifica que Conda esté instalado en el sistema
2. **Gestiona el entorno**: Crea o usa un entorno existente con QGIS 3.44.6
3. **Configura VSCode**: Genera workspace con rutas correctas
4. **Variables de entorno**: Crea archivo .env con configuración necesaria
5. **Git**: Actualiza .gitignore para no versionar archivos temporales
6. **Verifica**: Opcionalmente comprueba que QGIS se importe correctamente

### Personalización

Puedes editar las siguientes variables al inicio del script:

```bash
ENV_NAME="qgis_env"          # Nombre del entorno
QGIS_VERSION="3.44.6"        # Versión de QGIS
PYTHON_VERSION="3.12"        # Versión de Python
```

## 🛠️ Método 2: Configuración Manual

Pasos para crear manualmente un entorno Conda que incluya QGIS y sus dependencias.

### Pasos para crear el entorno QGIS

1. **Abrir la terminal**.

2. **Crear un nuevo entorno Conda**. Puedes nombrar el entorno como desees, en este ejemplo lo llamaremos `qgis_env`:

   ```bash
   conda create -n qgis_dev qgis=3.44.6 python=3.12 -c conda-forge
   ```

    o en una carpeta específica:

   ```bash
    conda create --prefix ./qgis_env qgis=3.44.6 python=3.12 -c conda-forge

    conda config --set env_prompt "({name})> "
    ```

    > **Nota**: al 2025-12-30, QGIS 3.44.6 es la última versión stable disponible en conda-forge. Puedes verificar la última versión disponible en el [repositorio de QGIS en conda-forge](https://anaconda.org/conda-forge/qgis).

3. **Activar el entorno**:
    - Si creaste el entorno con un nombre:

    ```bash
    conda activate qgis_env
    ```

    - Si creaste el entorno en una carpeta específica:

    ```bash
    conda activate ./qgis_env
    ```

4. **Verificar la instalación de QGIS**: Puedes iniciar QGIS desde la terminal escribiendo:

   ```bash
   qgis 
   ```

   Si QGIS se inicia correctamente, la instalación ha sido exitosa.

   o bien, puedes verificar la versión instalada con el script Python: test_qgis.py

    ```bash
    python test_qgis.py
    ```

### Desactivando el entorno

Para salir del entorno Conda, simplemente ejecuta:

```bash
conda deactivate
```

### Notas adicionales para configuración manual

- Puedes instalar paquetes adicionales en el entorno QGIS utilizando `conda install` o `pip install` según sea necesario.
- Asegúrate de mantener tu entorno actualizado ejecutando `conda update --all` periódicamente dentro del entorno activado.
- Si encuentras problemas con dependencias, considera crear un nuevo entorno para evitar conflictos.
- Para eliminar el entorno, usa el siguiente comando:
  - Si usaste un nombre:

  ```bash
  conda remove --name qgis_env --all
  ```

  - Si usaste una carpeta específica:

  ```bash
  conda remove --prefix ./qgis_env --all
  ```

## 📁 Estructura del entorno

```txt
qgis_env/
├── bin/
│   └── python           # Intérprete de Python
├── share/
│   └── qgis/
│       └── python/      # Módulos de PyQGIS
│           └── plugins/ # Plugins de QGIS
└── lib/                 # Bibliotecas compartidas
```

## 📖 Uso después de la instalación

### Opción 1: Usar el workspace de VSCode

```bash
code qgis.code-workspace
```

VSCode cargará automáticamente la configuración y el intérprete correcto.

### Opción 2: Activar manualmente el entorno

```bash
conda activate ./qgis_env
python test_qgis.py
```

### Opción 3: Debug en VSCode

1. Abre el archivo Python que deseas ejecutar
2. Presiona `F5` o ve a "Run and Debug"
3. Selecciona "QGIS Python"
4. El script se ejecutará con el entorno QGIS correcto

## 🔄 Actualizar QGIS

Para actualizar a una nueva versión de QGIS:

```bash
# Opción 1: Ejecutar el script de nuevo y recrear el entorno
./setup_qgis_vscode_linux.sh

# Opción 2: Actualizar manualmente
conda activate ./qgis_env
conda update qgis -c conda-forge
```

## 🐛 Solución de problemas

### Error: "No se encontró Conda"

Instala Miniconda o Anaconda y asegúrate de que `conda` esté en tu PATH:

```bash
# Verifica que conda esté disponible
which conda
```

### Error al importar QGIS

Verifica que el entorno se creó correctamente:

```bash
conda activate ./qgis_env
python -c "from qgis.core import QgsApplication; print('OK')"
```

### VSCode no encuentra el intérprete

1. Presiona `Ctrl+Shift+P`
2. Busca "Python: Select Interpreter"
3. Selecciona el intérprete en `qgis_env/bin/python`

## 📚 Recursos adicionales

- [Documentación oficial de QGIS](https://www.qgis.org/en/docs/index.html)
- [PyQGIS Cookbook](https://docs.qgis.org/latest/en/docs/pyqgis_developer_cookbook/)
- [Canal conda-forge de QGIS](https://anaconda.org/conda-forge/qgis)
- [Documentación de Conda](https://docs.conda.io/projects/conda/en/latest/index.html)
- [Canal conda-forge](https://conda-forge.org/) para paquetes de código abierto.
- [Foro de la comunidad QGIS](https://community.qgis.org/)
- [Canal de YouTube de QGIS](https://www.youtube.com/c/QGISProject)
- [Curso de QGIS en Udemy](https://www.udemy.com/course/qgis-para-principiantes/)
- [Curso de QGIS en Coursera](https://www.coursera.org/learn/gis-qgis)
- [Tutoriales de QGIS en YouTube](https://www.youtube.com/results?search_query=qgis+tutorials)
- [Documentación de PyQGIS](https://docs.qgis.org/latest/en/docs/pyqgis_developer_cookbook/)
- [Repositorio de ejemplos de PyQGIS en GitHub](https://github.com/qgis/pyqgis)
- [Foro de PyQGIS en Stack Exchange](https://gis.stackexchange.com/questions/tagged/pyqgis)
- [Curso de PyQGIS en Udemy](https://www.udemy.com/course/pyqgis-for-beginners/)
- [Curso de PyQGIS en Coursera](https://www.coursera.org/learn/pyqgis)
- [Tutoriales de PyQGIS en YouTube](https://www.youtube.com/results?search_query=pyqgis+tutorials)
- [Repositorio original](https://github.com/tu-usuario/qgis_python_vscode)

## ⚠️ Notas

- El entorno se crea en `./qgis_env` (local al proyecto)
- Para compartir el proyecto, otros usuarios deben ejecutar el script o seguir los pasos manuales
- El entorno puede ocupar ~2GB de espacio en disco
- La primera creación puede tardar 5-10 minutos

## 📄 Licencia

Este script es de código abierto. Siéntete libre de modificarlo según tus necesidades.

---

**¿Problemas o sugerencias?** Abre un issue en el repositorio o contribuye con un pull request 😺
