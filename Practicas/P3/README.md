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

![alt text][diagrama.png]
