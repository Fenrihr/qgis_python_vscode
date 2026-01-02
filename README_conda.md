# Creando entorno QGIS con Conda

Este documento describe los pasos para crear un entorno Conda que incluya QGIS y sus dependencias.

## Requisitos previos

- Tener instalado [Miniconda](https://docs.conda.io/en/latest/miniconda.html) o [Anaconda](https://www.anaconda.com/products/distribution).
- Tener acceso a internet para descargar los paquetes necesarios.

## Pasos para crear el entorno QGIS

1. **Abrir la terminal o el símbolo del sistema**.

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

## Desactivando el entorno

Para salir del entorno Conda, simplemente ejecuta:

```bash
conda deactivate
```

## Notas adicionales

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

## Recursos adicionales

- [Documentación oficial de QGIS](https://www.qgis.org/en/docs/index.html)
- [Documentación de Conda](https://docs.conda.io/projects/conda/en/latest/index.html)
- [Canal conda-forge](https://conda-forge.org/) para paquetes de código abierto.
- [Repositorio de QGIS en conda-forge](https://anaconda.org/conda-forge/qgis)
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

¡Ahora tienes un entorno Conda configurado con QGIS listo para usar!