## Créditos
Este proyecto se basa en el repositorio original:  
https://github.com/wdavilav/pos-store

## Instalación del proyecto  
### Hacer actualizaciones
```bash
sudo apt update && sudo apt upgrade
```  
### Clona el proyecto y entra en la carpeta
```bash
git clone https://github.com/CamiloJaraG/pos-store.git
cd pos-store
```  
### Crea un archivo .env.local con las credenciales proporcionadas
```bash
nano .env.local
```
Guarda con Ctrl + O y luego Ctrl + X.  
### Instala los paquetes necesarios
```bash
sudo apt install nginx gunicorn python3 python3-venv python3-pip libpq-dev certbot python3-certbot-nginx

```  
### Inicia environment de Python
```bash
python3 -m venv env
source env/bin/activate
```
### Instala requerimientos
```bash
pip install --upgrade pip
pip install -r requirements.txt
```
### Instala más paquetes necesarios
```bash
sudo apt update && sudo apt install -y \
    libpango-1.0-0 \
    libcairo2 \
    libgdk-pixbuf2.0-0 \
    libffi-dev \
    libpangocairo-1.0-0 \
    libjpeg-dev \
    libxml2 \
    libxslt1.1 \
    libssl-dev \
    libcurl4-openssl-dev \
    build-essential

```
### Para probar
Correr la aplicación en segundo plano con gunicorn
```bash
nohup gunicorn config.wsgi:application --bind 0.0.0.0:8080 &
```

### Configuración de Nginx
```bash
server {
    listen 80;
    server_name pos-store.me www.pos-store.me;

    location /static/ {
        alias /home/ubuntu/pos-store/staticfiles/;
        autoindex on;
        access_log /var/log/nginx/static_access.log;
        error_log /var/log/nginx/static_error.log debug;
    }

    location / {
        proxy_pass http://127.0.0.1:8080;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
```
