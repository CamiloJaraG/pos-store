## Créditos
Este proyecto se basa en el repositorio original:  
https://github.com/wdavilav/pos-store

## Instalación del proyecto  
### Hacer actualizaciones
```bash
sudo apt update
sudo apt upgrade
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
