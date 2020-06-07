
cmake_minimum_required(VERSION 3.10)
 
project(Nucleo_CMake C ASM)
 
# Startup code is written by ST in assembly, so without this statement there are errors.
ENABLE_LANGUAGE (ASM-ATT)
 
#set(CMAKE_C_COMPILER /home/macias/opt/xPacks/arm-none-eabi-gcc/xpack-arm-none-eabi-gcc-9.2.1-1.1/bin/arm-none-eabi-gcc)
#set(CMAKE_CXX_COMPILER /home/macias/opt/xPacks/arm-none-eabi-gcc/xpack-arm-none-eabi-gcc-9.2.1-1.1/bin/arm-none-eabi-g++)

INCLUDE_DIRECTORIES("Inc/")
 
# Resonator used in this project. Stm32F4-DISCO uses 8MHz crystal. I left this definition here
# in the CMakeLists.txt rather than the toolchain file, because it's project dependent, not
# "platform" dependent, where by platform I mean STM32F4.
ADD_DEFINITIONS (-DHSE_VALUE=8000000)
 
# All the sources goes here. Adding headers isn't obligatory, but since QtCreator treats CMakeLists.txt as
# its "project configuration" it simply makes header files appear in the source tree pane.
set(include
 "Inc/main.h"
 "Inc/stm32f4xx_hal_conf.h"
 "Inc/stm32f4xx_it.h"
)
set(src
 "Src/main.c"
 "Src/stm32f4xx_hal_msp.c"
 "Src/stm32f4xx_it.c"
 "Src/system_stm32f4xx"
)
add_executable(${CMAKE_PROJECT_NAME}.elf
    ${include}
    ${src}
)
 
# Workaround : splitting C and C++ code helps QtCreator parse header files correctly. Without it, QtCreator
# sometimes treats C++ as C and vice versa. EDIT : this comment was written when in the ADD_EXECUTABLE C++
# files were present.
add_library ("stm" STATIC
 "${CUBE_ROOT}/Drivers/STM32F4xx_HAL_Driver/Src/stm32f4xx_hal.c"
 "${CUBE_ROOT}/Drivers/STM32F4xx_HAL_Driver/Src/stm32f4xx_hal_uart.c"
 "${CUBE_ROOT}/Drivers/STM32F4xx_HAL_Driver/Src/stm32f4xx_hal_cortex.c"
 "${CUBE_ROOT}/Drivers/STM32F4xx_HAL_Driver/Src/stm32f4xx_hal_gpio.c"
 "${CUBE_ROOT}/Drivers/STM32F4xx_HAL_Driver/Src/stm32f4xx_hal_rcc.c"
 "${CUBE_ROOT}/Drivers/STM32F4xx_HAL_Driver/Src/stm32f4xx_ll_gpio.c"
 "${CUBE_ROOT}/Drivers/STM32F4xx_HAL_Driver/Src/stm32f4xx_ll_rcc.c"
 "${CUBE_ROOT}/Drivers/STM32F4xx_HAL_Driver/Src/stm32f4xx_ll_utils.c"
 "${CUBE_ROOT}/Drivers/STM32F4xx_HAL_Driver/Inc/stm32f4xx_hal_cortex.h"
 "${CUBE_ROOT}/Drivers/STM32F4xx_HAL_Driver/Inc/stm32f4xx_hal_gpio_ex.h"
 "${CUBE_ROOT}/Drivers/STM32F4xx_HAL_Driver/Inc/stm32f4xx_hal_gpio.h"
 "${CUBE_ROOT}/Drivers/STM32F4xx_HAL_Driver/Inc/stm32f4xx_hal.h"
 "${CUBE_ROOT}/Drivers/STM32F4xx_HAL_Driver/Inc/stm32f4xx_hal_rcc_ex.h"
 "${CUBE_ROOT}/Drivers/STM32F4xx_HAL_Driver/Inc/stm32f4xx_hal_rcc.h"
 "${CUBE_ROOT}/Drivers/STM32F4xx_HAL_Driver/Inc/stm32f4xx_ll_cortex.h"
 "${CUBE_ROOT}/Drivers/STM32F4xx_HAL_Driver/Inc/stm32f4xx_ll_gpio.h"
 "${CUBE_ROOT}/Drivers/STM32F4xx_HAL_Driver/Inc/stm32f4xx_ll_rcc.h"
 "${CUBE_ROOT}/Drivers/STM32F4xx_HAL_Driver/Inc/stm32f4xx_ll_system.h"
 "${STARTUP_CODE}"
)
 
# This links both pieces together.
TARGET_LINK_LIBRARIES (${CMAKE_PROJECT_NAME}.elf -Wl,--whole-archive stm -Wl,--no-whole-archive)
 
FIND_PROGRAM (OPENOCD openocd)
ADD_CUSTOM_TARGET("upload" DEPENDS ${CMAKE_PROJECT_NAME}.elf COMMAND ${OPENOCD} -f /usr/share/openocd/scripts/interface/stlink-v2.cfg -f /usr/share/openocd/scripts/target/stm32f4x.cfg -c 'program ${CMAKE_PROJECT_NAME}.elf verify reset exit')

