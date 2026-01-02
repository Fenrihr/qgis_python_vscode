# Configuración automática de QGIS + Python + VSCode

Este proyecto incluye un script (`setup_qgis_vscode.py`) que configura todo lo necesario para trabajar con QGIS en VSCode:

- 🐍 Crea `qgis.pth` → para que Python sepa siempre dónde está QGIS.
- 📂 Crea `qgis.code-workspace` → para abrir el proyecto en VSCode con todo configurado.
- 📝 Crea `.env.example` → archivo base de variables de entorno.
- 🚫 Actualiza `.gitignore` → para que `.env` no se suba a Git.
- 🧪 Incluye `test_qgis.py` → para comprobar que las librerías de QGIS se importan correctamente.

---

## ⚡ Requisitos

- Tener instalado **QGIS (Standalone o OSGeo4W)** en Windows.
- Tener instalado **Python (cualquiera)** para poder ejecutar el script.
- Tener instalado **VSCode** con la extensión de Python.

---

## Cómo usarlo

### 1. Ejecutar script

```bash
python setup_qgis_vscode.py
```

Esto genera:

- `qgis.pth`
- `qgis.code-workspace`
- `.env.example`
- `.gitignore`

### 2. Abrir el proyecto en VSCode

En VSCode → `File > Open Workspace from File...` → selecciona `qgis.code-workspace`.

---

## ⚠️ Notas importantes

- El archivo `qgis.pth` se crea dentro de la carpeta de instalación de QGIS  
  (`C:/Program Files/QGIS.../Lib/site-packages`).  
  Esto puede requerir **ejecutar el script como Administrador**.  
  Si ves esta advertencia:  

  ```txt
  😿 No se pudo crear qgis.pth (permiso denegado).
  ⚠️ ⚠️ ⚠️   Intenta ejecutar este script como Administrador.
  ```

  Solo copia el archivo qgis.pth (que se crea en la raíz del proyecto) en el directorio que se menciona en la terminal.

- El `.env` no se versiona en Git. Cada usuario debe copiar `.env.example` a `.env` y modificarlo si necesita personalizar rutas.

---

## ✅ Resultado final

Con este script, cualquier usuario podrá configurar VSCode para trabajar con QGIS, sin necesidad de editar rutas manualmente.
