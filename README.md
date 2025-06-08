## Créditos
Este proyecto se basa en el repositorio original:  
https://github.com/wdavilav/pos-store

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
