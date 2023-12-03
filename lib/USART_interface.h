#ifndef _USART_INTERFACE_H_
#define _USART_INTERFACE_H_

void USART_voidInit(void);
u8 USART_u8ReceiveDataOnInterrupt(void);
u8 USART_u8SetCallBack(void (*Copy_ptrtofunc)(void));

#endif
