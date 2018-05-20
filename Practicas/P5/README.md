# Práctica 5: Replicación de bases de datos MySQL

## Objetivos de la práctica

A la hora de hacer copias de seguridad de nuestras bases de datos ( BD ) MySQL, una opción muy común suele ser la de usar una réplica maestro - esclavo, de manera que nuestro servidor en producción hace de maestro y otro servidor de backup hace de esclavo. Podemos hacer copias desde el servidor de backup sin que se vea afectado el rendimiento del sistema en producción y sin interrupciones de servicio. Por ejemplo, podemos tener un pequeño servidor actuando como backup en nuestra oficina sincronizado mediante réplicas con nuestro sistema en producción. Tener un servidor de backup con MySQL actuando como esclavo de replicación es una solución asequible y no consume demasiado ancho de banda en un sitio web de tráfico normal, además de que no afecta al rendimiento del maestro en el sistema en producción

Los objetivos concretos de esta práctica son:
- Clonar manualmente BD entre máquinas
- Configurar  la  estructura  maestro esclavo  entre  dos  máquinas  para  realizar  el clonado automático de la información.

### Copiar archivos de copia de seguridad mediante ssh

En este apartado haremos una copia de seguridad de forma manual de una Base de Datos para luego restaurarla de forma manual en una 2ª máquina

Primero creamos una BD de ejemplo e insertamos algunos datos de prueba
```
mysql> create database contactos;
mysql> use contactos;
mysql> create table datos(nombre varchar(100),tlf int);
mysql> insert into datos(nombre,tlf) values ("asdf",12345677);
mysql> select * from datos;
+---------+-----------+
| nombre  | tlf       |
+---------+-----------+
| asdf    |  12345677 |
+---------+-----------+
```

Ahora haremos un backup a la ruta que queramos
```bash
#Bloqueamos las tablas de la BD mientras hacemos la copia
mysql -u root –p
mysql>FLUSH TABLES WITH READ LOCK;
mysql> quit

mysqldump contactos -u root -p > ./ejemplodb.sql
 
#Desbloqueamos las tablas
mysql -u root –p
mysql> UNLOCK TABLES;
mysql> quit
```

Copiamos el .sql a la máquina donde queramos restaurar la BD
```
mysql -u root –p
mysql> CREATE DATABASE 'contactos';
mysql> quit

mysql -u root -p ejemplodb < /tmp/ejemplodb.sql
```
Ya tendríamos nuestro servidor con la copia de las tablas

### Configurar  la  estructura  maestro esclavo

La forma de hacer copias manualmente es buena pero consume tiempo y no es instantánea, sin embargo si configuramos un servidor de forma que sea el maestro y el de backup esclavo, cada vez que un dato se insertase en el maestro este lo transmitiría a todos sus esclavos de forma que las tablas estarían replicadas de forma casi instantánea

Debemos de cambiar la configuracion "/etc/mysql/my.cnf" que también puede ser "/etc/mysql/mysql.conf.d/mysqld.cnf" dependiendo de la version de mysql
```
Comentamos el parámetro bind-address que sirve para que escuche a un servidor:
#bind-address 127.0.0.1

Establecemos el identificador del servidor.
server-id = 1

Guardamos el documento y reiniciamos el servicio:
/etc/init.d/mysql restart
```
Creamos el usuario esclavo:
![alt text](https://github.com/jcpulido97/SWAP/blob/master/Practicas/P5/img/creacionUser.PNG)

Mostramos los datos de master para saber el file que debemos de sincronizar mas adelante
![alt text](https://github.com/jcpulido97/SWAP/blob/master/Practicas/P5/img/masterStatus.PNG)

En la máquina que actuará de esclavo introduciremos los siguientes comandos, para indicarle donde encontrar al servidor maestro y que base de datos de replicar
![alt text](https://github.com/jcpulido97/SWAP/blob/master/Practicas/P5/img/changemaster.PNG)
