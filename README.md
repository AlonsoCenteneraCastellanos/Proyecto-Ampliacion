# WebFusion Digital — Despliegue Automatizado WordPress

> Proyecto de automatización de despliegue web con Vagrant, Docker y GitHub  
> Asignatura: Sistemas de Despliegue · WebFusion Digital S.L.

---

## 📐 Arquitectura del sistema

```
Ordenador local
      │
      ▼
  Vagrant (Vagrantfile)
      │  provision.sh instala Docker y lanza docker-compose
      ▼
  VM Ubuntu 22.04 (jammy64)
      │
      ▼
  Docker Engine
      ├── Contenedor: db          (MySQL 8.0)
      ├── Contenedor: wordpress   (WordPress latest + Apache)
      └── Contenedor: git-sync   (Alpine + Git → clona repo)
                          │
                          ▼
                    Volumen: theme_data
                          │
                          ▼
              /var/www/html/wp-content/themes/webfusion
```

### Flujo de datos

1. **git-sync** se conecta a GitHub, clona/actualiza el repositorio y copia los archivos PHP de la carpeta `/php` al volumen `theme_data`.
2. **WordPress** monta ese mismo volumen en la ruta de temas `/var/www/html/wp-content/themes/webfusion` y sirve el tema actualizado.
3. **db** (MySQL) almacena todos los datos de WordPress de forma persistente.

---

## 🗂 Estructura del repositorio

```
webfusion-wordpress/
├── Vagrantfile              # Configuración de la VM
├── provision.sh             # Script de aprovisionamiento automático
├── docker-compose.yml       # Definición de contenedores
├── Dockerfile.gitsync       # Imagen personalizada del contenedor git-sync
├── entrypoint.sh            # Script ejecutado por git-sync al arrancar
├── php/
│   ├── index.php            # Plantilla principal del tema WordPress
│   ├── style.css            # Hoja de estilos + cabecera de tema
│   └── functions.php        # Funciones y soporte del tema
└── README.md                # Este documento
```

---

## ⚙️ Descripción de cada componente

### `Vagrantfile`
Declara la máquina virtual:
- **Box**: `ubuntu/jammy64` (Ubuntu 22.04 LTS)
- **Recursos**: 2 GB RAM, 2 CPUs
- **Red**: reenvío del puerto **80 → 8080** (acceso desde el host)
- **Provisioning**: ejecuta `provision.sh` automáticamente

### `provision.sh`
Script de aprovisionamiento que:
1. Actualiza los paquetes del sistema.
2. Instala Docker Engine y Docker Compose Plugin.
3. Añade el usuario `vagrant` al grupo `docker`.
4. Lanza `docker compose up -d --build` desde `/vagrant`.

### `docker-compose.yml`
Define tres servicios:

| Servicio    | Imagen             | Función |
|-------------|-------------------|---------|
| `db`        | mysql:8.0          | Base de datos WordPress |
| `wordpress` | wordpress:latest   | Servidor web + PHP |
| `git-sync`  | (build local)      | Descarga código desde GitHub |

### `Dockerfile.gitsync` + `entrypoint.sh`
Imagen Alpine mínima que ejecuta `entrypoint.sh`:
- Si el repo no existe → `git clone`
- Si ya existe → `git pull`
- Copia los archivos de `/php` al volumen compartido `/output`

### `php/`
Archivos del tema WordPress personalizado:
- **`style.css`**: cabecera con metadatos del tema + estilos CSS completos
- **`index.php`**: plantilla principal con secciones: Hero, Servicios, Estadísticas, Nosotros, Contacto
- **`functions.php`**: registro de soporte del tema y encolado de estilos

---

## 🚀 Instrucciones de despliegue paso a paso

### Prerrequisitos (máquina host)
- [VirtualBox](https://www.virtualbox.org/) ≥ 6.1
- [Vagrant](https://www.vagrantup.com/) ≥ 2.3
- Git
- Conexión a internet

### Paso 1 — Clonar el repositorio

```bash
git clone https://github.com/TU_USUARIO/webfusion-wordpress.git
cd webfusion-wordpress
```

### Paso 2 — (Importante) Configurar la URL del repo

Edita `docker-compose.yml` y reemplaza la URL del repositorio en la sección `git-sync`:

```yaml
environment:
  REPO_URL: "https://github.com/TU_USUARIO/webfusion-wordpress.git"
```

### Paso 3 — Levantar el entorno

```bash
vagrant up
```

Este comando:
- Descarga la box `ubuntu/jammy64` (solo la primera vez)
- Crea y configura la VM
- Instala Docker automáticamente
- Lanza todos los contenedores

⏱ La primera vez puede tardar **5-10 minutos** dependiendo de tu conexión.

### Paso 4 — Acceder a WordPress

Abre el navegador y navega a:

```
http://localhost:8080
```

Sigue el asistente de instalación de WordPress (elige idioma, crea usuario admin).

### Paso 5 — Activar el tema WebFusion

1. Accede a: `http://localhost:8080/wp-admin`
2. Ve a **Apariencia → Temas**
3. Activa el tema **WebFusion Digital**

---

## 🔄 Ejemplo de actualización de contenido

Para reflejar cambios del repositorio sin reconstruir todo el entorno:

### 1. Realiza cambios en los archivos PHP
```bash
# Edita, por ejemplo, el texto del hero en php/index.php
nano php/index.php
```

### 2. Sube los cambios a GitHub
```bash
git add php/index.php
git commit -m "Actualizar texto del hero"
git push origin main
```

### 3. Aplica los cambios en el entorno
```bash
vagrant provision
```

Internamente esto:
1. Ejecuta de nuevo `provision.sh`
2. Que recrea el contenedor `git-sync`
3. El cual hace `git pull` y copia los archivos actualizados al volumen de WordPress
4. Los cambios se reflejan inmediatamente en `http://localhost:8080`

**¡Sin intervención manual adicional!** ✅

---

## 🛑 Comandos útiles

```bash
# Iniciar el entorno
vagrant up

# Aplicar cambios del repositorio
vagrant provision

# Acceder por SSH a la VM
vagrant ssh

# Ver logs de los contenedores (desde dentro de la VM)
cd /vagrant && docker compose logs -f

# Detener los contenedores
cd /vagrant && docker compose down

# Apagar la VM
vagrant halt

# Eliminar la VM completamente
vagrant destroy
```

---

## 🔧 Resolución de problemas

| Problema | Solución |
|----------|----------|
| Puerto 8080 ocupado | Cambia `host: 8080` por otro puerto en el Vagrantfile |
| WordPress no carga | Espera 30 s más; MySQL tarda en inicializarse |
| El tema no aparece | Comprueba que git-sync terminó con éxito: `docker compose logs git-sync` |
| Cambios no se reflejan | Ejecuta `vagrant provision` y espera unos segundos |

---

## 📦 Tecnologías utilizadas

- **Vagrant** 2.3+ con VirtualBox
- **Ubuntu** 22.04 LTS (jammy64)
- **Docker** Engine 24+
- **Docker Compose** Plugin v2
- **WordPress** (imagen oficial Docker Hub)
- **MySQL** 8.0
- **Alpine Linux** 3.19 (contenedor git-sync)
- **GitHub** (control de versiones y fuente de verdad del código)

---

*Desarrollado para WebFusion Digital S.L. — Proyecto de despliegue automatizado*
