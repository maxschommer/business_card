EESchema Schematic File Version 4
EELAYER 26 0
EELAYER END
$Descr A4 11693 8268
encoding utf-8
Sheet 2 5
Title ""
Date ""
Rev ""
Comp ""
Comment1 ""
Comment2 ""
Comment3 ""
Comment4 ""
$EndDescr
$Comp
L Motor:Motor_DC M201
U 1 1 5BCBEB5F
P 4350 4650
F 0 "M201" V 4055 4600 50  0000 C CNN
F 1 "Motor_DC" V 4146 4600 50  0000 C CNN
F 2 "" H 4350 4560 50  0001 C CNN
F 3 "~" H 4350 4560 50  0001 C CNN
	1    4350 4650
	0    1    1    0   
$EndComp
$Comp
L Custom:AP1017AEN U?
U 1 1 5BCBEC9C
P 4300 3750
AR Path="/5BCBEC9C" Ref="U?"  Part="1" 
AR Path="/5BCB9C49/5BCBEC9C" Ref="U201"  Part="1" 
F 0 "U201" H 4300 4125 50  0000 C CNN
F 1 "AP1017AEN" H 4300 4034 50  0000 C CNN
F 2 "CustomFootprints:AP1017AEN" H 4300 3750 50  0001 C CNN
F 3 "" H 4300 3750 50  0001 C CNN
	1    4300 3750
	1    0    0    -1  
$EndComp
Text HLabel 3900 4400 0    50   Input ~ 0
DIFF1
Text HLabel 4700 4400 2    50   Input ~ 0
DIFF2
Text HLabel 3900 3600 0    50   Input ~ 0
INA
Text HLabel 3900 3700 0    50   Input ~ 0
INB
$Comp
L power:+1V8 #PWR0113
U 1 1 5BCBEF43
P 4800 3600
F 0 "#PWR0113" H 4800 3450 50  0001 C CNN
F 1 "+1V8" H 4815 3773 50  0000 C CNN
F 2 "" H 4800 3600 50  0001 C CNN
F 3 "" H 4800 3600 50  0001 C CNN
	1    4800 3600
	1    0    0    -1  
$EndComp
$Comp
L power:+1V8 #PWR0114
U 1 1 5BCBEF69
P 3550 3800
F 0 "#PWR0114" H 3550 3650 50  0001 C CNN
F 1 "+1V8" H 3565 3973 50  0000 C CNN
F 2 "" H 3550 3800 50  0001 C CNN
F 3 "" H 3550 3800 50  0001 C CNN
	1    3550 3800
	1    0    0    -1  
$EndComp
Wire Wire Line
	3550 3800 3900 3800
Wire Wire Line
	4700 3600 4800 3600
Wire Wire Line
	3900 4650 4050 4650
Wire Wire Line
	3900 3900 3900 4650
Wire Wire Line
	4550 4650 4700 4650
Wire Wire Line
	4700 3900 4700 4650
$Comp
L Device:C C201
U 1 1 5BCBE054
P 5050 3950
F 0 "C201" H 5165 3996 50  0000 L CNN
F 1 "10uF" H 5165 3905 50  0000 L CNN
F 2 "Capacitor_SMD:C_0805_2012Metric" H 5088 3800 50  0001 C CNN
F 3 "~" H 5050 3950 50  0001 C CNN
	1    5050 3950
	1    0    0    -1  
$EndComp
$Comp
L Device:C C202
U 1 1 5BCBE0B0
P 5400 3850
F 0 "C202" H 5515 3896 50  0000 L CNN
F 1 "1uF" H 5515 3805 50  0000 L CNN
F 2 "Capacitor_SMD:C_0603_1608Metric" H 5438 3700 50  0001 C CNN
F 3 "~" H 5400 3850 50  0001 C CNN
	1    5400 3850
	1    0    0    -1  
$EndComp
Wire Wire Line
	5050 4150 5050 4100
Wire Wire Line
	5050 4150 5400 4150
Wire Wire Line
	5400 4150 5400 4000
Wire Wire Line
	5050 3800 4700 3800
$Comp
L power:GND #PWR0115
U 1 1 5BCBE369
P 4500 4150
F 0 "#PWR0115" H 4500 3900 50  0001 C CNN
F 1 "GND" H 4505 3977 50  0000 C CNN
F 2 "" H 4500 4150 50  0001 C CNN
F 3 "" H 4500 4150 50  0001 C CNN
	1    4500 4150
	1    0    0    -1  
$EndComp
Wire Wire Line
	4500 4150 4300 4150
$Comp
L power:GND #PWR0116
U 1 1 5BCBE62A
P 5400 4150
F 0 "#PWR0116" H 5400 3900 50  0001 C CNN
F 1 "GND" H 5405 3977 50  0000 C CNN
F 2 "" H 5400 4150 50  0001 C CNN
F 3 "" H 5400 4150 50  0001 C CNN
	1    5400 4150
	1    0    0    -1  
$EndComp
Connection ~ 5400 4150
Wire Wire Line
	4700 3700 5400 3700
Text HLabel 5400 3700 2    50   Input ~ 0
VC
Text HLabel 5050 3800 2    50   Input ~ 0
VM
$EndSCHEMATC
