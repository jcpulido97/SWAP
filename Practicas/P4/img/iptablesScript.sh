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
iptables -A OUTPUT -p tcp -d 179.60.192.36 -j DROP

# Reglas multipuerto
iptables -A INPUT -i eth0 -p tcp -m multiport --dports 22,80,443 -m state --state NEW,ESTABLISHED -j ACCEPT
iptables -A OUTPUT -o eth0 -p tcp -m multiport --sports 22,80,443 -m state --state ESTABLISHED -j ACCEPT

# Confgiguración para usar firewall como nat
iptables -t nat -A PREROUTING -i enp0s8 -p tcp --dport 80 -j DNAT --to-destination 192.168.56.107

iptables -t nat -A PREROUTING -i enp0s8 -p tcp --dport 80 -j DNAT --to-destination 192.168.56.107

iptables -P FORWARD ACCEPT

iptables -t nat -A PREROUTING -i enp0s8 -p tcp --dport 80 -j DNAT --to-destination 192.168.56.107

iptables -t nat -A POSTROUTING -o enp0s8 -p tcp --dport 80 -d 192.168.56.107 -j SNAT --to-source 192.168.56.108

iptables -t nat -A POSTROUTING -o enp0s8 -p tcp --dport 443 -d 192.168.56.107 -j SNAT --to-source 192.168.56.108

iptables -t nat -A PREROUTING -i enp0s8 -p tcp --dport 443 -j DNAT --to-destination 192.168.56.107

#iptables -P FORWARD ACCEPT
#iptables -P INPUT DROP
#iptables -P OUTPUT DROP
#iptables -P FORWARD ACCEPT
