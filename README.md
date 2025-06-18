## Créditos
Este proyecto se basa en el repositorio original:  
https://github.com/wdavilav/pos-store

## Instalación del proyecto
### Dentro de una máquina con Ubuntu 22:  
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
### Crear un archivo systemd para Gunicorn
```bash
sudo nano /etc/systemd/system/gunicorn.service
```  
### Configuración de systemd para Gunicorn
```bash
[Unit]
Description=gunicorn daemon for pos-store
After=network.target

[Service]
User=ubuntu
Group=ubuntu
WorkingDirectory=/home/ubuntu/pos-store
ExecStart=/home/ubuntu/pos-store/env/bin/gunicorn --access-logfile - --workers 3 --bind 127.0.0.1:8080 config.wsgi:application

[Install]
WantedBy=multi-user.target
```
### Ejecutar Gunicorn 
```bash
sudo systemctl daemon-reload
sudo systemctl enable gunicorn
sudo systemctl start gunicorn
```
### Crear el archivo de configuración de Nginx
```bash
sudo nano /etc/nginx/sites-available/pos-store.me
```
### Configuración inicial de Nginx
Solo agregar dominios a server_name si se posee uno, de lo contrario escribir la dirección IP pública de la máquina donde esté realizando la instalación
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
### Copiar configuración de Nginx para crear enlace simbólico
```bash
sudo ln -s /etc/nginx/sites-available/pos-store.me /etc/nginx/sites-enabled/
```
### Reiniciar Nginx
```bash
sudo nginx -t && sudo systemctl reload nginx
```
### Añadir HTTPS (Solo si se tiene un dominio)
```bash
sudo certbot --nginx -d pos-store.me www.pos-store.me
```  
Proporcionar correo electrónico y aceptar términos y condiciones.  
Si las direcciones agregadas en el archivo están en los registros del DNS, entonces Certbot logrará desplegar certificados para las mismas.
### Dar permisos a Nginx para poder acceder a la carpeta de los archivos estáticos
```bash
sudo chmod -R o+r /home/ubuntu/pos-store/staticfiles
sudo find /home/ubuntu/pos-store/staticfiles -type d -exec chmod o+x {} \;
sudo chown -R ubuntu:ubuntu /home/ubuntu/pos-store/staticfiles
sudo find /home/ubuntu/pos-store/staticfiles -type d -exec chmod 755 {} \;
sudo find /home/ubuntu/pos-store/staticfiles -type f -exec chmod 644 {} \;

```
