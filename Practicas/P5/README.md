# Práctica 5: Replicación de bases de datos MySQL

## Objetivos de la práctica

A la hora de hacer copias de seguridad de nuestras bases de datos ( BD ) MySQL, una opción muy común suele ser la de usar una réplica maestro - esclavo, de manera que nuestro servidor en producción hace de maestro y otro servidor de backup hace de esclavo. Podemos hacer copias desde el servidor de backup sin que se vea afectado el rendimiento del sistema en producción y sin interrupciones de servicio. Por ejemplo, podemos tener un pequeño servidor actuando como backup en nuestra oficina sincronizado mediante réplicas con nuestro sistema en producción. Tener un servidor de backup con MySQL actuando como esclavo de replicación es una solución asequible y no consume demasiado ancho de banda en un sitio web de tráfico normal, además de que no afecta al rendimiento del maestro en el sistema en producción

Los objetivos concretos de esta práctica son:
-Copiar archivos de copia de seguridad mediante ssh
-Clonar manualmente BD entre máquinas
-Configurar  la  estructura  maestro esclavo  entre  dos  máquinas  para  realizar  el 
clonado automático de la información.
