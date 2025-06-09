## Créditos
Este proyecto se basa en el repositorio original:  
https://github.com/wdavilav/pos-store

### Clona el proyecto
```bash
git clone https://github.com/CamiloJaraG/pos-store.git
cd pos-store
```  
### Instala Docker
Desinstala conflictos:  
```bash
for pkg in docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc; do sudo apt-get remove $pkg; done
```
Instala el repositorio de Docker:
```bash
# Add Docker's official GPG key:
sudo apt-get update
sudo apt-get install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
```
Instala la última versión de Docker
```bash
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
```  

```bash  
docker run -d -p 8080:8080 pos-store:latest
```

### Contenido de archivo Dockerfile  
```dockerfile
# Dockerfile
FROM python:3.10-slim

# Instalar dependencias necesarias
RUN apt-get update && apt-get install -y \
    build-essential \
    libpango1.0-0 \
    libgdk-pixbuf2.0-0 \
    libffi-dev \
    libcairo2 \
    && apt-get clean

# Crear directorio de trabajo
WORKDIR /app

# Copiar requerimientos e instalar
COPY deploy/txt/requirements.txt /app/requirements.txt
RUN pip install --upgrade pip && pip install -r requirements.txt

# Copiar el resto del proyecto
COPY . .

# Copiar el entrypoint
COPY entrypoint.sh /app/entrypoint.sh
RUN chmod +x /app/entrypoint.sh

# Puerto expuesto
EXPOSE 8080

# EntryPoint y comando por defecto
ENTRYPOINT ["/app/entrypoint.sh"]
CMD ["python", "manage.py", "runserver", "0.0.0.0:8080"]
```

### Contenido de archivo entrypoint.sh
```bash
#!/bin/bash
#!/bin/bash

# Migraciones
echo "Ejecutando makemigrations y migrate"
python manage.py makemigrations
python manage.py migrate 

# Carga de datos iniciales
echo "Cargando datos iniciales"
python manage.py shell --command='from core.init import *'
# Cargar datos de ejemplo
echo "Cargando datos de ejemplo"
python manage.py shell --command='from core.utils import *'

# Arrancar servidor
echo "Iniciando servidor Django"
exec "$@"
```
