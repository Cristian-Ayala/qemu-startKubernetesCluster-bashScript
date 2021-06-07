#!/bin/bash
echo "Iniciando maquinas virtuales"
# Luego de haber agregado las llaves publicas a las máquinas me puedo conectar sin contraseña
# ssh-keygen
# ssh-copy-id usuario@direccion_ip
sudo virsh start master && sudo virsh start worker1 && sudo virsh start worker2

echo "Maquina virtuales iniciadas"
# Try to ping master's network, if success -> vm is on and receiving ssh connections
# -q quiet
# -c nb of pings to perform
# -W timeout
ping -q -c1 -W1 192.168.122.69 > /dev/null
salida=$?
echo "Esperando disponibilidad de master"
while [ $salida -ne 0 ]
do
	echo "Espere por favor. Mientras el nodo master se inicia"
        ping -q -c1 -W1 192.168.122.69 > /dev/null
        salida=$?
done
echo "Master Iniciado"

# >/dev/null 2>&1 means redirect stdout to /dev/null and stderr to stdout .
# en español: redirige la salida a una interfaz nula y redirige los mensajes de error a la salida estandar
konsole --new-tab --noclose -p "LocalTabTitleFormat"="master" -e "/bin/zsh -c 'ssh zeus@192.168.122.69'" > /dev/null 2>&1 &

ping -q -c1 -W1 192.168.122.79 > /dev/null
salida=$?
echo "Esperando disponibilidad de worker1..."
while [ $salida -ne 0 ]
do
	echo "Espere por favor."
        ping -q -c1 -W1 192.168.122.79 > /dev/null
        salida=$?
done
echo "Worker1 iniciada"
konsole --new-tab --noclose -p "LocalTabTitleFormat"="worker 1" -e "/bin/zsh -c 'ssh zeus@192.168.122.79'" > /dev/null 2>&1 &


ping -q -c1 -W1 192.168.122.89 > /dev/null
salida=$?
echo "Esperando disponibilidad de worker2..."
while [ $salida -ne 0 ]
do
	echo "Espere por favor."
        ping -q -c1 -W1 192.168.122.89 > /dev/null
        salida=$?
done
echo "Worker2 iniciada"

konsole --new-tab --noclose -p "LocalTabTitleFormat"="worker 2" -e "/bin/zsh -c 'ssh zeus@192.168.122.89'" > /dev/null 2>&1 &

