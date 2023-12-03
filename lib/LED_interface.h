#ifndef LED_INTERFACE_H_
#define LED_INTERFACE_H_

/*Max Pattern Length it can be increased to any number but you must mark the end of pattern with EOP*/
#define MAX_PATTERN_LENGTH 10

/*Struct for my patterns it contains array for the pattern and its corrsponding delay*/
typedef struct
{
    u16 delay;
    s16 pattern[MAX_PATTERN_LENGTH];
} LedPattern;

void LED_voidInit(void);
void LED_voidCheckState(void);
void LED_voidActivatePattern(void *ptr);

#endif