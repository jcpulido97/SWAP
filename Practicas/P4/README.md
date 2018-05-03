# Práctica 4

## Objetivo de la práctica

El objetivo de esta práctica es llevar a cabo la configuración de seguridad de la granja 
web. Para ello, llevaremos a cabo las siguientes tareas:
- Instalar un certificado SSL para configurar el acceso HTTPS a los servidores.
- Configurar las reglas del cortafuegos para proteger la granja web.

## 1) Instalar un certificado SSL autofirmado para configurar el acceso por HTTPS

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

## 2) Configurar las reglas del cortafuegos para proteger la granja web.

En mi caso vamos a utilizar una 4ª máquina que hará de servidor de entrada de cara a Internet, de esta forma
nuestros servidores quedarán ocultados de cara al público y solo serán accesibles mediante los puertos designados
por nosotros.

La herramienta a utilizar serán las iptables que se basa en Netfilter, una parte del kernel encargada de manipular
e interceptar paquetes de red.

Ahora vamos a crear un script que configure las reglas de nuestro sistema de forma automática
```
  #!/bin/bash
  # Eliminar todas las reglas (configuración limpia)
  iptables -F
  iptables -X
  iptables -Z
  iptables -t nat -F

  # Política por defecto: denegar todo el tráfico
  iptables -P INPUT DROP
  iptables -P OUTPUT DROP
  iptables -P FORWARD DROP

  # Permitir cualquier acceso desde localhost (interface lo)
  iptables -A INPUT -i lo -j ACCEPT
  iptables -A OUTPUT -o lo -j ACCEPT

  # Bloquear todo el tráfico ICMP (ping), para evitar ataques como el del ping de la muerte:
  iptables -A INPUT -p icmp --icmp-type echo-request -j DROP

  # Abrir el puerto 22 para permitir el acceso por SSH:
  iptables -A INPUT -p tcp --dport 22 -j ACCEPT
  iptables -A OUTPUT -p udp --sport 22 -j ACCEPT

  # Abrir los puertos HTTP/HTTPS (80 y 443) para configurar un servidor web:
  iptables -A INPUT -m state --state NEW -p tcp --dport 80 -j ACCEPT
  iptables -A INPUT -m state --state NEW -p tcp --dport 443 -j ACCEPT

  # Abrir el puerto 53 para permitir el acceso a DNS:
  iptables -A INPUT -m state --state NEW -p udp --dport 53 -j ACCEPT
  iptables -A INPUT -m state --state NEW -p tcp --dport 53 -j ACCEPT

  # Bloquear todo el tráfico de entrada desde una IP:
  iptables -I INPUT -s 150.214.13.13 -j DROP

  # Bloquear todo el tráfico de salida hacia una IP:
  iptables -I OUTPUT -s 31.13.83.8 -j DROP

  # Evitar el acceso a www.facebook.com especificando el nombre de dominio:
  iptables -A OUTPUT -p tcp -d www.facebook.com -j DROP

  # Reglas multipuerto
  iptables -A INPUT -i eth0 -p tcp -m multiport --dports 22,80,443 -m state --state NEW,ESTABLISHED -j ACCEPT
  iptables -A OUTPUT -o eth0 -p tcp -m multiport --sports 22,80,443 -m state --state ESTABLISHED -j ACCEPT

  # Confgiguración para usar firewall como nat para reenrutar los paquetes que lleguen a los puertos 80 o 443
  iptables -P FORWARD ACCEPT
  iptables -t nat -A PREROUTING -i enp0s8 -p tcp --dport 80 -j DNAT --to-destination 192.168.56.11
  iptables -t nat -A PREROUTING -i enp0s8 -p tcp --dport 80 -j DNAT --to-destination 192.168.56.11
  iptables -t nat -A PREROUTING -i enp0s8 -p tcp --dport 80 -j DNAT --to-destination 192.168.56.11
  iptables -t nat -A POSTROUTING -o enp0s8 -p tcp --dport 80 -d 192.168.56.11 -j SNAT --to-source 192.168.56.15
  iptables -t nat -A POSTROUTING -o enp0s8 -p tcp --dport 443 -d 192.168.56.11 -j SNAT --to-source 192.168.56.15
  iptables -t nat -A PREROUTING -i enp0s8 -p tcp --dport 443 -j DNAT --to-destination 192.168.56.11
```
