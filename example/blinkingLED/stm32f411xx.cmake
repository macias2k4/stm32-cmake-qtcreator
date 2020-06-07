# This variable is used later to set a C/C++ macro which tells CubeF4 which µC to use. ST
# drivers, and other code is bloated with all sorts of macros, #defines and #ifdefs.
add_definitions(-DSTM32F411xE)
 
# This is a variable which is later used here and in the CMakeLists.txt. It simply tells
# where to find the SDK (CubeF4). Please change it accordingly if you have other 
# version of CubeF4 installed.
SET (CUBE_ROOT "$ENV{HOME}/STM32Cube/Repository/STM32Cube_FW_F4_V1.25.0")
 
# Startup code and linker script - more on it later.
SET (STARTUP_CODE "${CUBE_ROOT}/Projects/STM32F411RE-Nucleo/Templates/SW4STM32/startup_stm32f411xe.s")
SET (LINKER_SCRIPT "${CUBE_ROOT}/Projects/STM32F411RE-Nucleo/Templates/SW4STM32/STM32F4xx-Nucleo/STM32F411RETx_FLASH.ld")
 
# Magic settings. Without it CMake tries to run test programs on the host platform, which
# fails of course.
SET (CMAKE_SYSTEM_NAME Generic)
SET (CMAKE_SYSTEM_PROCESSOR arm)
 
# -mcpu tells which CPU to target obviously. -fdata-sections -ffunction-sections Tells GCC to.
# get rid of unused code in the output binary. -Wall produces verbose warnings.
SET(CMAKE_C_FLAGS "-mcpu=cortex-m4 -std=gnu99 -fdata-sections -ffunction-sections -Wall" CACHE INTERNAL "c compiler flags")
 
# Flags for g++ are used only when compliing C++ sources (*.cc, *.cpp etc). -std=c++17 Turns
# on all the C++17 goodies, -fno-rtti -fno-exceptions turns off rtti and exceptions.
SET(CMAKE_CXX_FLAGS "-mcpu=cortex-m4 -std=c++17 -fno-rtti -fno-exceptions -Wall -fdata-sections -ffunction-sections -MD -Wall" CACHE INTERNAL "cxx compiler flags")
 
# Those flags gets passed into the linker which is run by the GCC at he end of the process..
# -T tells the linker which LD script to use, -specs=nosys.specs sets the specs which most 
# notably tells the compiler to use libnosys.a which contains all the syscalls like _sbrk,
# _exit and much more. They are more like an interface between our program and operating system /
# bare metal system we are running it on. You can use rdimon.specs instead or write syscalls 
# yourself which for bare-metal isn't difficult. --gc-sections strips out unused code from 
#binaries I think.
SET (CMAKE_EXE_LINKER_FLAGS "-T ${LINKER_SCRIPT} -specs=nosys.specs -Wl,--gc-sections" CACHE INTERNAL "exe link flags")
 
# Some directories in the GCC tree.
INCLUDE_DIRECTORIES(${SUPPORT_FILES})
LINK_DIRECTORIES(${SUPPORT_FILES})
 
# Random include paths for CubeF4 peripheral drivers and CMSIS.
INCLUDE_DIRECTORIES("${CUBE_ROOT}/Drivers/STM32F4xx_HAL_Driver/Inc/")
INCLUDE_DIRECTORIES("${CUBE_ROOT}/Drivers/STM32F4xx_HAL_Driver/Inc/Legacy/")
INCLUDE_DIRECTORIES("${CUBE_ROOT}/Drivers/CMSIS/Device/ST/STM32F4xx/Include/")
INCLUDE_DIRECTORIES("${CUBE_ROOT}/Drivers/CMSIS/Include/")

