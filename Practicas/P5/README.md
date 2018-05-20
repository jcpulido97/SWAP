# Práctica 5: Replicación de bases de datos MySQL

## Objetivos de la práctica

A la hora de hacer copias de seguridad de nuestras bases de datos (BD)
MySQL, una opción  muy  común  suele  ser  la  de  usar  una  réplica  maestro-esclavo,
de  manera  que nuestro  servidor  en  producción  hace  de  maestro  y  otro  servidor
de  backup  hace  de esclavo.

Podemos  hacer  copias  desde  el  servidor  de  backup sin  que  se  vea  afectado
el rendimiento del sistema en producción y sin interrupciones de servicio.

Tener una  réplica  en  otro  servidor  también  añade 
fiabilidad  ante  fallos  totales  del sistema en producción, los cuales, tarde o 
temprano, ocurrirán. Por ejemplo, podemos tener  un  pequeño  servidor  actuando  como
backup  en  nuestra  oficina  sincronizado mediante réplicas con nuestro sistema en 
producción. Esta   opción,   además,   añade   fiabilidad   ante   posibles interrupciones
de   servicio permanentes  del  servidor  maestro  por  cualquier  escenario  catastrófico
que  nos podamos  imaginar.  En  ese  caso,  tendremos  posiblemente  decenas  de  clientes
y servicios  parados  sin  posibilidad  de  recuperar  sus  datos  si  no  hemos preparado
un buen plan de contingencias. Tener un servidor de backup con MySQL actuando como esclavo
de replicación es una solución asequible y no consume demasiado ancho de banda en un sitio
web de tráfico normal, además de que no afecta al rendimiento del maestro en el sistema en
producción
