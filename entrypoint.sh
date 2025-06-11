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