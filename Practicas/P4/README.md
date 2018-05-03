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

a) En nuestro caso podemos instalarlo en cada una de las máquinas servidoras finales:

```
  a2enmod ssl
  service apache2 restart 
  mkdir /etc/apache2/ssl 
  openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/apache2/ssl/apache.key -out /etc/apache2/ssl/apache.crt
```
a.1) Modificar los archivos de configuración de apache
```
  nano /etc/apache2/sites-available/default-ssl
  #Añadir las siguientes lineas  
```

O ahorrarnos bastante tiempo haciendo que la máquina encargada de cifrar la conexión sea la
máquina dedicada a balancear de esta forma solo habrá que realizar la configuración solo una vez

```
  openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/apache2/ssl/apache.key -out /etc/apache2/ssl/apache.crt
  
