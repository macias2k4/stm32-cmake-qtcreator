# stm32-cmake-qtcreator
This project is how to prepare a development environment for writing applications for STM32 (e.g. Nucleo) on **Linux (Ubuntu)**. By using: ARM GCC, CMake, and QtCreator.

## ARM GCC

Choose and download package for your OS from the page: https://xpack.github.io/arm-none-eabi-gcc/releases/

Pick the last version. In my case, it is: `xPack GNU Arm Embedded GCC v9.2.1-1.1 released` and then choose a file`xpack-arm-none-eabi-gcc-9.2.1-1.1-linux-x64.tar.gz` for your OS.

Download and uncompress a file:
```
tar xvzf xpack-arm-none-eabi-gcc-9.2.1-1.1-linux-x64.tar.gz
```
Then check a version of the compiler:
```
xpack-arm-none-eabi-gcc-9.2.1-1.1/bin/arm-none-eabi-g++ --version
```
You should see somethink like that:
```
arm-none-eabi-g++ (xPack GNU Arm Embedded GCC, 64-bit) 9.2.1 20191025 (release) [ARM/arm-9-branch revision 277599]
...
```

### Compile test code by command line
 - Create **main.cpp** file with content
```
#include <iostream>
int main() 
{
  auto l = [](){return 5;};
  return l();
}
```
 - check is it compiles:
 ```
 xpack-arm-none-eabi-gcc-9.2.1-1.1/bin/arm-none-eabi-g++ -specs=nosys.specs -mthumb -mcpu=cortex-m4 main.cpp -o test
 ```
