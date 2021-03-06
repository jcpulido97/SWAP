# Práctica 1
## Cuestiones a resolver

En esta práctica el objetivo es configurar las máquinas virtuales para trabajar en prácticas posteriores, asegurando la conectividad entre dichas máquinas.
Como resultado de la práctica 1 se mostrarán dos máquinas funcionando al profesor en clase (accesos con curl para solicitar páginas web sencillas, así como el
acceso por SSH entre ambas máquinas).
Específicamente, hay que llevar a cabo las siguientes tareas:

1. Acceder por ssh de una máquina a otra
2. Acceder mediante la herramienta curl desde una máquina a la otra

El resultado de ejecutar estas tareas se debe documentar usando un archivo de texto y/o capturas de pantalla que se subirán a la cuenta de GitHub.

- - -

## Configuración

Todo lo que hagamos de ahora en adelante deberemos de replicarlo para la 2ª máquina que tenemos, cambiando la IP para evitar conflictos

Instalamos el Stack LAMP bien sea desde la instalación del SO o bien mediante el siguiente comando
```
sudo tasksel install lamp-server
```
Debemos configurar una nueva interfaz de red (HostOnly) para poder comunicar ambas máquina entre sí, estableciendo una ip estática a cada una de ellas. Para configurarlo:

1. Modificar el archivo  `/etc/network/interfaces`

```
    auto enp0s8
    iface enp0s8 inet static
    address 192.168.56.X  # Dando una Ip para cada máquina
    netmask 255.255.255.0 
```

2. Reiniciamos la red para aplicar los cambios:
```
    sudo /etc/init.d/networking restart 
```

3. Probamos la conexión:
```
    ping 192.168.56.X 
```

Para poder conectarnos a las máquinas vistuales vamos a realizarlo con ssh.

1. Acceder por ssh de una máquina a otra  

```
    ssh jcpulido97@192.168.56.X
```    

Acceder desde la máquina anfitrión a una máquina  

```
    ssh jcpulido97@192.168.56.Y
```    

- - -

## Configuración del html

1. Creamos un html para probar la conexión al servidor http en "/var/www/html/hola.html"
```
  <HTML>
  <BODY>
    Esto funciona  :)
  </BODY>
  </HTML>
```

2. Acceder mediante la herramienta curl desde una máquina a la otra   

```
    curl 192.168.56.X/hola.html
```    
Obtendremos como salida:
```
  <HTML>
  <BODY>
    Esto funciona  :)
  </BODY>
  </HTML>
```
