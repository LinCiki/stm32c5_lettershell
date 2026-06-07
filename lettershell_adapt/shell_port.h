#include "shell.h"
#include "shell_ext.h"
#include "mx_hal_def.h"

#define LOW_LEVEL_DATA_SIZE (128)

extern unsigned short shell_buffer[LOW_LEVEL_DATA_SIZE];
extern Shell UserShell;

void low_level_read(void);
void letter_shell_user_init(void);
