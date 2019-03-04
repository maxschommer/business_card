/*
 * BalancingBusinessCard.cpp
 *
 * Created: 11/3/2018 4:36:13 PM
 * Author : mschommer
 */
#define F_CPU 2000000UL // 2 MHz for delay

#include <avr/io.h>
#include <stdio.h>
#include <math.h>
#include <util/delay.h>
#include <avr/interrupt.h>

#include "TinyWireM.h"
#include "USI_TWI_Master.h"

#include "alphabet.h"
#include "accelerometer_utils.h"

void Init_ACC()
{												   // Setup the LIS3DHTR
	lis3dhWriteByte(LIS3DH_CTRL_REG1, 0b10010111); // 1.344 kHz , No Low-power mode, all axes enabled
	lis3dhWriteByte(LIS3DH_CTRL_REG4, 0b00110000); // +-16g range, defaults otherwise
}

// Gets the current x-axis acceleration in m/s
float read_accel()
{
	// TODO: read all 10 bits
	// int raw = lis3dhReadInt(LIS3DH_OUT_X_L); // 10 bits of data
	int8_t raw = lis3dhReadByte(LIS3DH_OUT_X_H);
	return (int16_t(raw) << 2) * 0.004 * 9.8 * 8; // 4 milligees per digit in +-2g mode
}

void ShowLine(uint16_t line)
{
	PORTA = (PORTA & (~(0b000011111 << 3))) | (line & 0b000011111) << 3; // LED0, LED1, LED2, LED3, LED4
	PORTB = ((line & 0b000100000) << 1);								 // LED5
	PORTB |= ((line & 0b001000000) >> 1);								 // LED6
	PORTB |= ((line & 0b010000000) >> 3);								 // LED7
	PORTB |= ((line & 0b100000000) >> 5);								 // LED8
}

// current_time returns the current time in increments of about 0.1 ms (1 tick), 0.000128s for 2MHz clock
// Must be called at least 30 times per second, or could lose count.
uint32_t current_time()
{
	static uint32_t timerOverflowCount = 0; // Each overflow count is 0.032768s for 2MHz clock

	// Record total time since start
	if ((TIFR & (1 << TOV0)) == (1 << TOV0)) // check if overflow flag is set
	{
		TIFR = 1 << TOV0; //clear timer1 overflow flag
		timerOverflowCount++;
	}
	return TCNT0L + 256 * timerOverflowCount; // total time since start of uC
}

// Returns 1 if maxima detected, -1 if minima detected, or 0
int8_t detect_edge(uint32_t t)
{
	// TODO: switch to a filter?
	const float DEBOUNCE_THRESH = 2.0; // m/s^2

	static int8_t dir = 1; // Start looking for a max

	static float min_detected = 9999999;

	float val = read_accel() * dir;

	if (val < min_detected)
	{
		min_detected = val;
	}

	if (val > min_detected + DEBOUNCE_THRESH)
	{
		// Edge detected
		min_detected = 9999999;
		dir *= -1;
		return dir;
	}

	return 0;
}

int main()
{
	// Configuring ATTiny

	CLKPR = 1 << CLKPCE;
	CLKPR = 1 << CLKPS1; // Set clock division to 4

	TCCR0B = 1 << CS02; // Divide clock by 256

	USICR = 1 << USIWM1; // Enable Two-Wire mode of USI register

	DDRB = 0b01111010; // Set LEDs on port B as output
	DDRA = 0b11111000; // Set LEDs on port A as output
	TinyWireM.begin(); // initialize I2C lib

	Init_ACC();

	// Message Display Parameters
	char message[] = "ERIC MAX";		   // Message to display
	int kerning = 2;					   // Space between letters, in bars
	const float before_message_frac = 0.2; // Target fraction of cycle waiting before display

	// Generate Flash Pattern
	struct FlashPattern flashPattern = convertString(message, kerning);
	long double timeToWait;

	// Variable Initializations
	uint32_t lastEdgeTime = current_time(); // Time that the last acceleration peak was detected
	uint32_t estimated_period = 10000;		// In ticks, time to sweep one dir
	int8_t dir = 1;							// 1 if moving right, -1 if moving left

	while (1)
	{
		// Detect the left edge
		uint32_t t = current_time();

		// Check for an edge, update variables if found
		int8_t edge = detect_edge(t);

		if (edge != 0)
		{
			estimated_period = t - lastEdgeTime; // TODO: Smooth this?
			lastEdgeTime = t;
			dir = edge;

			if (estimated_period > 10000)
			{
				estimated_period = 10000;
			}
		}

		// Calculate current position
		float frac_time = float(t - lastEdgeTime) / estimated_period;
		float frac_space = frac_time;
		// float frac_space = (-cos(frac_time * M_PI) + 1) / 2;

		float frac_message = (frac_space - before_message_frac) / (1 - 2 * before_message_frac);

		// Display
		if (frac_message >= 0.0 && frac_message < 1.0)
		{
			size_t currentIndex = frac_message * flashPattern.length;

			if (dir < 0)
			{
				currentIndex = flashPattern.length - currentIndex - 1;
			}
			if (dir > 0)
				ShowLine(flashPattern.data[currentIndex]);
		}
		else
		{
			ShowLine(0);
		}
	}
}