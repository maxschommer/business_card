/*
 * BalancingBusinessCard.cpp
 *
 * Created: 11/3/2018 4:36:13 PM
 * Author : mschommer
 */ 

#include <avr/io.h>
#include <util/delay.h>


int main (void)
{
	// set PB3 to be output
	DDRB = 0b00001000;
	while (1) {
		
		// flash# 1:
		// set PB3 high
		PORTB = 0b00001000;
		_delay_ms(20);
		// set PB3 low
		PORTB = 0b00000000;
		_delay_ms(20);

		// flash# 2:
		// set PB3 high
		PORTB = 0b00001000;
		_delay_ms(200);
		// set PB3 low
		PORTB = 0b00000000;
		_delay_ms(200);
	}
}