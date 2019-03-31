EESchema Schematic File Version 4
LIBS:BalancingBusinessCardLights-cache
EELAYER 29 0
EELAYER END
$Descr A4 11693 8268
encoding utf-8
Sheet 3 4
Title ""
Date ""
Rev ""
Comp ""
Comment1 ""
Comment2 ""
Comment3 ""
Comment4 ""
$EndDescr
Text HLabel 4250 2600 0    50   Input ~ 0
SDA
Text HLabel 4250 2400 0    50   Input ~ 0
SCL
$Comp
L power:GND #PWR026
U 1 1 5BCBFB95
P 4250 2500
F 0 "#PWR026" H 4250 2250 50  0001 C CNN
F 1 "GND" V 4255 2372 50  0000 R CNN
F 2 "" H 4250 2500 50  0001 C CNN
F 3 "" H 4250 2500 50  0001 C CNN
	1    4250 2500
	0    1    1    0   
$EndComp
$Comp
L power:GND #PWR027
U 1 1 5BCBFCA0
P 4250 2700
F 0 "#PWR027" H 4250 2450 50  0001 C CNN
F 1 "GND" V 4255 2572 50  0000 R CNN
F 2 "" H 4250 2700 50  0001 C CNN
F 3 "" H 4250 2700 50  0001 C CNN
	1    4250 2700
	0    1    1    0   
$EndComp
$Comp
L power:GND #PWR029
U 1 1 5BCBFE0D
P 7250 2500
F 0 "#PWR029" H 7250 2250 50  0001 C CNN
F 1 "GND" V 7255 2372 50  0000 R CNN
F 2 "" H 7250 2500 50  0001 C CNN
F 3 "" H 7250 2500 50  0001 C CNN
	1    7250 2500
	0    -1   -1   0   
$EndComp
$Comp
L power:GND #PWR030
U 1 1 5BCBFE24
P 7250 2700
F 0 "#PWR030" H 7250 2450 50  0001 C CNN
F 1 "GND" V 7255 2572 50  0000 R CNN
F 2 "" H 7250 2700 50  0001 C CNN
F 3 "" H 7250 2700 50  0001 C CNN
	1    7250 2700
	0    -1   -1   0   
$EndComp
NoConn ~ 7250 2600
NoConn ~ 7250 2800
NoConn ~ 7250 2400
NoConn ~ 7250 2200
NoConn ~ 7250 2100
$Comp
L Device:C C3
U 1 1 5BCC04AB
P 7800 2450
F 0 "C3" H 7915 2496 50  0000 L CNN
F 1 "10uF" H 7915 2405 50  0000 L CNN
F 2 "Capacitor_SMD:C_0805_2012Metric" H 7838 2300 50  0001 C CNN
F 3 "~" H 7800 2450 50  0001 C CNN
	1    7800 2450
	1    0    0    -1  
$EndComp
$Comp
L Device:C C4
U 1 1 5BCC04F1
P 8100 2450
F 0 "C4" H 8215 2496 50  0000 L CNN
F 1 "100nF" H 8215 2405 50  0000 L CNN
F 2 "Capacitor_SMD:C_0603_1608Metric" H 8138 2300 50  0001 C CNN
F 3 "~" H 8100 2450 50  0001 C CNN
	1    8100 2450
	1    0    0    -1  
$EndComp
Wire Wire Line
	8100 2300 7800 2300
Wire Wire Line
	7800 2600 7950 2600
$Comp
L power:GND #PWR031
U 1 1 5BCC05A4
P 7950 2600
F 0 "#PWR031" H 7950 2350 50  0001 C CNN
F 1 "GND" H 7955 2427 50  0000 C CNN
F 2 "" H 7950 2600 50  0001 C CNN
F 3 "" H 7950 2600 50  0001 C CNN
	1    7950 2600
	1    0    0    -1  
$EndComp
Connection ~ 7950 2600
Wire Wire Line
	7950 2600 8100 2600
Wire Wire Line
	7250 2300 7800 2300
Connection ~ 7800 2300
$Comp
L power:+3V3 #PWR032
U 1 1 5C0FED29
P 8100 2300
F 0 "#PWR032" H 8100 2150 50  0001 C CNN
F 1 "+3V3" H 8115 2473 50  0000 C CNN
F 2 "" H 8100 2300 50  0001 C CNN
F 3 "" H 8100 2300 50  0001 C CNN
	1    8100 2300
	1    0    0    -1  
$EndComp
Connection ~ 8100 2300
$Comp
L Custom:LIS3DHTR U2
U 1 1 5BCBF7EE
P 4250 2100
F 0 "U2" H 5750 2593 60  0000 C CNN
F 1 "LIS3DHTR" H 5750 2487 60  0000 C CNN
F 2 "CustomFootprints:LIS3DHTR" H 5750 2340 60  0001 C CNN
F 3 "https://www.st.com/content/ccc/resource/technical/document/datasheet/3c/ae/50/85/d6/b1/46/fe/CD00274221.pdf/files/CD00274221.pdf/jcr:content/translations/en.CD00274221.pdf" H 5750 2381 60  0000 C CNN
F 4 "497-10613-1-ND" H 4250 2100 50  0001 C CNN "Digikey"
	1    4250 2100
	1    0    0    -1  
$EndComp
$Comp
L power:+3V3 #PWR025
U 1 1 5C0FED7A
P 4250 2100
F 0 "#PWR025" H 4250 1950 50  0001 C CNN
F 1 "+3V3" H 4265 2273 50  0000 C CNN
F 2 "" H 4250 2100 50  0001 C CNN
F 3 "" H 4250 2100 50  0001 C CNN
	1    4250 2100
	1    0    0    -1  
$EndComp
$Comp
L power:+3V3 #PWR028
U 1 1 5C0FEDA2
P 4250 2800
F 0 "#PWR028" H 4250 2650 50  0001 C CNN
F 1 "+3V3" V 4265 2928 50  0000 L CNN
F 2 "" H 4250 2800 50  0001 C CNN
F 3 "" H 4250 2800 50  0001 C CNN
	1    4250 2800
	0    -1   -1   0   
$EndComp
$EndSCHEMATC
