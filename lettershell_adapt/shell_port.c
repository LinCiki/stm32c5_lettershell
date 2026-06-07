#include "shell_port.h"

unsigned short shell_buffer[LOW_LEVEL_DATA_SIZE] = {0};
unsigned short low_level_data[LOW_LEVEL_DATA_SIZE] = {0};
unsigned int receive_ptr = 0;
unsigned int read_ptr = 0;

Shell UserShell;


void low_level_read(void)
{
    hal_status_t ret = HAL_OK;
    unsigned short data = 0;

    do {
        // 每个字符给10ms时间
        ret = HAL_UART_Receive(mx_usart2_uart_gethandle(), &data, 1, 10);
        if (ret == HAL_OK) {
            low_level_data[receive_ptr] = data;
            receive_ptr++;
        }
    } while (ret != HAL_TIMEOUT);
}

signed short letter_shell_read(char *dataPtr, unsigned short dataSize)
{
    if (dataPtr == NULL || dataSize == 0) {
        return 0;
    }

    if (receive_ptr != 0) {
        // 读超时 且 有读到过数据 交给shell处理
        *dataPtr = low_level_data[read_ptr];
        read_ptr++;
        receive_ptr--;
        return 1;
    }
    read_ptr = 0;
    return 0;
}

signed short letter_shell_write(char *dataPtr, unsigned short dataSize)
{
    HAL_UART_Transmit(mx_usart2_uart_gethandle(), dataPtr, dataSize, 10 * dataSize);
    return 0;
}

void letter_shell_user_init(void)
{
    UserShell.write = letter_shell_write;
    UserShell.read = letter_shell_read;
}
