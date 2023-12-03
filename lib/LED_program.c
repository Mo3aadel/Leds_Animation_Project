#include "../inc/STD_TYPES.h"
#include "../inc/BIT_MATH.h"
#include "DIO_interface.h"
#include "USART_interface.h"
#include "LED_private.h"
#include "LED_config.h"
#include "LED_interface.h"
#include "FreeRTOS.h"
#include "task.h"

u8 Global_u8ReceivedState = 0;

/*Creating array of structs named patterns*/
LedPattern Patterns[] =
	{
		/*index 0 in my array of structs will contain the off signal default behaviour*/
		{1, {0, EOP}},

		/*index 1 in my array of structs contains flashing pattern with 500ms delay.*/
		{500, {255, 0, EOP}},

		/*index 2 in my array of structs contains moving left with 250ms delay.*/
		{250, {128, 64, 32, 16, 8, 4, 2, 1, EOP}},

		/*index 3 in my array of structs contains moving right with 250ms delay.*/
		{250, {1, 2, 4, 8, 16, 32, 64, 128, EOP}},

		/*index 4, Two LEDs converging with 300ms delay.*/
		{300, {24, 36, 66, 129, EOP}},

		/*index 5, Two LEDs diverging with 300ms delay.*/
		{250, {129, 66, 36, 24, EOP}},

		/*index 6, Ping Pong with 250ms delay.*/
		{300, {2, 8, 32, 128, 64, 16, 4, 1, EOP}},

		/*index 7, Snake effect with 300ms delay.*/
		{300, {224, 112, 56, 28, 14, 7, 131, 193, EOP}},

		/*index 8, converging and diverging with 300ms delay.*/
		{300, {129, 195, 231, 255, 255, 231, 195, EOP}}};

void LED_voidInit(void)
{
	DIO_voidSetPortDirection(LED_PORT, PORT_DIRECTION_OUTPUT);
}
void LED_voidCheckState(void)
{
	Global_u8ReceivedState = (USART_u8ReceiveDataOnInterrupt() - '0');
}

void LED_voidActivatePattern(void *ptr)
{
	
	u8 static Local_u8ActiveLEDsState = 0;
	u8 static Local_u8Iterator = 0;

	u8 static const Local_u8TotalNoOfPatterns = sizeof(Patterns) / sizeof(Patterns[0]);

	while (1)
	{
		
		if (VALID_LED_PATTERN)
		{
			Local_u8ActiveLEDsState = Global_u8ReceivedState;
		}
		for (Local_u8Iterator = 0; Patterns[Local_u8ActiveLEDsState].pattern[Local_u8Iterator] != EOP; Local_u8Iterator++)
		{
			DIO_voidSetPortValue(LED_PORT, Patterns[Local_u8ActiveLEDsState].pattern[Local_u8Iterator]);
			vTaskDelay(Patterns[Local_u8ActiveLEDsState].delay);
		}
	}
}