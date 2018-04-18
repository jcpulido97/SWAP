# Practica 3

## Objetivos de la práctica

En  esta  práctica  configuraremos  una  red  entre  varias  máquinas  de  forma  que 
tengamos un balanceador que reparta la carga entre varios servidores finales.

El  problema  a  solucionar  es  la  sobrecarga  de  los  servidores.  Se  puede  balancear 
cualquier protocolo, pero dado que esta asignatura se centra en las tecnologías web, 
balancearemos los servidores HTTP que tenemos configurados.

De esta forma conseguiremos una infraestructura redundante y de alta disponibilidad.

## Cuestiones a resolver
En  esta  práctica  el  objetivo  es  configurar  las  máquinas  virtuales  de  forma  que  dos 
hagan  de  servidores  web  finales  mientras  que  la  tercera  haga  de  balanceador  de carga por software. 

En esta práctica se llevarán a cabo, como mínimo, las siguientes tareas:

1. Configurar una máquina e instalar el nginx como balanceador de carga
2. Configurar una máquina e instalar el haproxy como balanceador de carga
3. Someter a la granja web a una alta carga, generada con la herramienta Apache Benchmark, teniendo primero nginx y después haproxy. 

En las tareas  1  y  2 debemos hacer  peticiones  a  la  dirección  IP del  balanceador y comprobar  que  realmente  se  reparte  la  carga. Para  ello,  el index.html en  las máquinas finales deben ser diferentes para ver cómo las respuestas que recibimos al 
hacer varias peticiones son diferentes (eso indicará que el balanceador deriva tráfico a las máquinas servidoras finales).

## Resolución

Nuestro objetivo es terminar con una granja web de este estilo

![alt text](https://github.com/jcpulido97/SWAP/blob/master/Practicas/P3/img/diagrama.png)

### Nginx

Primero empezaremos por la instalación del balanceador Nginx

```bash
  sudo apt-get update && sudo apt-get dist-upgrade && sudo apt-get autoremove
  sudo apt-get install nginx
  sudo systemctl start nginx
```

Ahora deberemos de editar el archivo de configuración **/etc/nginx/conf.d/default.conf**
Para añadir las siguientes líneas:

```
upstream apaches {
  server 192.168.56.5;  #IP de Máquina 1
  server 192.168.56.6;  #IP de Máquina 2
}

server{
  listen 80;
  server_name balanceador;
  
  access_log /var/log/nginx/balanceador.access.log;
  error_log /var/log/nginx/balanceador.error.log;
  
  root /var/www/;
  
  location /
  {
    proxy_pass http://apaches;
    proxy_set_header Host $host;
    proxy_set_header X-Real-IP $remote_addr;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_http_version 1.1;
    proxy_set_header Connection "";
  }
}
```
Guardamos los cambios e iniciamos el servidor web.
```
sudo systemctl start nginx
```
Con esto ya deberíamos de conseguir que nuestra máquina balancee entre ambos servidores finales

![alt text](https://github.com/jcpulido97/SWAP/blob/master/Practicas/P3/img/balanceador_ssl.gif)

### Haproxy

Lo primero es instalar el balanceador haproxy:
```bash
  sudo apt-get install haproxy
```
Ahora deberemos de modificar el archivo **/etc/haproxy/haproxy.cfg** 
```
global
  daemon
  maxconn 256
  
defaults
  mode http
  contimeout 4000
  clitimeout 42000
  srvtimeout 43000
  
frontend http-in
  bind *:80
  default_backend servers
  
backend servers
  server m1 192.168.56.5:80 maxconn 32
  server m2 192.168.56.6:80 maxconn 32
```
Una vez guardada la configuración debemos de iniciar el servicio de haproxy
```
sudo /usr/sbin/haproxy -f /etc/haproxy/haproxy.cfg
```
Una vez más deberíamos obtener el mismo resultado que con nginx, solo con haproxy balanceando entre los servidores

![alt text](https://github.com/jcpulido97/SWAP/blob/master/Practicas/P3/img/balanceador_ssl.gif)

### Apache Benchmark

Por último vamos a someter a un benchmark nuestra "granja web" para ver como se comporta frente a una elevada carga.

Lanzamos una prueba contra el balanceador
```
ab -n 1000 -c 10 http://192.168.56.11/index.html

Nginx:
![alt text](https://github.com/jcpulido97/SWAP/blob/master/Practicas/P3/img/Captura.PNG)

Haproxy:
![alt text](https://github.com/jcpulido97/SWAP/blob/master/Practicas/P3/img/Haproxy.PNG)
```
