#!/bin/bash
########################### Scrip ASM_AVR ##############################
##Programa para compilar y quemar archivo HEX de ASM.
##En geany ~/ sh asm.sh %f
##/usr/local/bin/avr	xterm -e .asm_avr  "%d"		Raul Macias Sep_2016
##avrdude -P /dev/ttyS0 -b 19200 -c ponyser -p m328p -F -U flash:w:P.hex
##Para gravar fuses:
##avrdude -P /dev/ttyUSB0  -c usbasp -p m328p -F -U efuse:w:0xff:m
########################################################################
######################## Procesador con AVRA  ##########################
if grep -o atmega328p *.asm
then
CPU_P="m328p"
elif grep -o attiny25 *.asm
then
CPU_P="t25"
elif grep -o attiny2313 *.asm
then
CPU_P="t2313"
fi
############################### AvrDude ################################
#Selecciono programador de microcontrolador desde archivo ASM
if grep -o usbasp *.asm
then
AVRDUDE=1
elif grep -o dasa *.asm
then
AVRDUDE=2
elif grep -o stk500v1 *.asm
then
AVRDUDE=3
fi

case $AVRDUDE in
1) PROG="usbasp";;
2) PROG="dasa" PORT="/dev/ttyS0" BAUD="19200";;
3) PROG="stk500v1" PORT="/dev/ttyUSB0" BAUD="57600";;
esac
########################## Comando de avra #############################
avra -l *.lst *.asm
########################################################################
if [ -f *.eep.hex ]; then
########################################################################
echo -e "\033[34m    ___ _   _____      ___  _______  ___   \033[0m"
echo -e "\033[34m   / _ | | / / _ \    / _ |/  __/  \/   \  \033[0m"
echo -e "\033[34m  / __ | |/ / , _/   / __ |__  /  /  /  /  \033[0m"
echo -e "\033[34m /_/ |_|___/_/|_|   /_/ |_|___/__/__/__/   \033[0m"
echo -e "\033[36m ========================================= \033[0m"
echo -e "\033[37m Proyecto `ls *.asm` Programar AVR $CPU_P? \033[0m"
else
echo -e "\033[31m <<===========¡¡¡ERROR!!!=============>> \033[0m"
read
exit 0
fi
##Caso "y" programa microcontrolador caso ENTER o "n" salta y sale
read a
	case $a in
	(y|Y)
	rm *.eep.hex
if [ -f *.hex ]; then
progg=(*.hex);
fi
######################### Comando avrdude ##############################
avrdude -P $PORT -b $BAUD -c $PROG -p $CPU_P -F -U flash:w:$progg
########################################################################
read
##Borrado de archivos y salida
rm *.obj
rm *.cof
rm *.hex
exit 0
	;;
	read) exit 0
	;;
	esac
########################################################################
