# Práctica 4

## Objetivo de la práctica

El objetivo de esta práctica es llevar a cabo la configuración de seguridad de la granja 
web. Para ello, llevaremos a cabo las siguientes tareas:
- Instalar un certificado SSL para configurar el acceso HTTPS a los servidores.
- Configurar las reglas del cortafuegos para proteger la granja web.

## Instalar un certificado SSL autofirmado para configurar el acceso por HTTPS

Para proteger las comunicaciones entre el Servidor y el cliente haremos uso de un certificado.
Normalmente se instalaría un certificado firmado por entidades reconocidas de forma que nuestros
clientes pudieran acceder sin ningún aviso de que el certificado no es de fiar.

En este caso utilizaremos un certificado autofirmado para ahorrarnos ciertos pasos en la instalacion
pero en un caso de producción esto sería algo inaceptable.

![alt text](https://github.com/jcpulido97/SWAP/blob/master/Practicas/P4/img/granja.png)

**Ahora deberemos elegir entre la opción a) o b) según nuestra topología**

### a) Instalación del certificado en cada servidor

En nuestro caso podemos instalarlo en cada una de las máquinas servidoras finales:
```
  a2enmod ssl
  service apache2 restart 
  sudo mkdir /etc/apache2/ssl 
  sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/apache2/ssl/apache.key -out /etc/apache2/ssl/apache.crt
```
#### a.1) Modificar los archivos de configuración de apache
```
  nano /etc/apache2/sites-available/default-ssl
```
#### a.2) Añadir las siguientes lineas donde pone SSLEngine on:
```
  SSLCertificateFile /etc/apache2/ssl/apache.crt 
  SSLCertificateKeyFile /etc/apache2/ssl/apache.key
```
#### a.3) Sólo queda activar defaul--ssl y reiniciar el servicio y nuestro servidor ya estaría listo para servir HTTPS:
```
  a2ensite default-ssl
  service apache2 reload
```

### b) Instalación del certificado en la máquina balanceadora

También podemos ahorrarnos bastante tiempo haciendo que la máquina encargada de cifrar la conexión sea la
máquina dedicada a balancear de esta forma solo habrá que realizar la configuración solo una vez
```
  sudo mkdir /etc/nginx/ssl
  sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/nginx/ssl/nginx.key -out /etc/nginx/ssl/nginx.crt
```
#### b.1) Modificar el archivo de sites-enabled/default.conf en la carpeta de instalación de nginx

Añadiendo un server en el puerto 443 y activando los distintos parametros para realizar proxy como anteriormente
y también activando las distintas opciones que vemos para decir donde se encuentran los certificados.

![alt text](https://github.com/jcpulido97/SWAP/blob/master/Practicas/P4/img/nginx_ssl.PNG)

## Configurar las reglas del cortafuegos para proteger la granja web.
