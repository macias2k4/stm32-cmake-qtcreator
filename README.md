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
```cpp
#include <iostream>
int main() 
{
  auto l = [](){return 5;};
  return l();
}
```
 - check is it compiles:
 ```console
 xpack-arm-none-eabi-gcc-9.2.1-1.1/bin/arm-none-eabi-g++ -specs=nosys.specs -mthumb -mcpu=cortex-m4 main.cpp -o test
 ```
 
 ## CMake
 Download and install the last version of CMake.
 
To make sure that we will use last version of CMake we need to go to page: https://cmake.org/download/ and download .sh file. In my case its `cmake-3.17.2-Linux-x86_64.sh`. 
 
 Then we need to run this script to extract his content and add cmake file link to usr/local/bin:
 ```console
chmod +x cmake-3.17.2-Linux-x86_64.sh
sudo mkdir -p /opt/cmake
sudo sh cmake-3.17.2-Linux-x86_64.sh --prefix=/opt/cmake
sudo ln -s /opt/cmake/bin/cmake /usr/local/bin/cmake
 ```
 
Now we can check the version of CMake:
```console
cmake --version
```
My result is:
```
cmake version 3.17.2

CMake suite maintained and supported by Kitware (kitware.com/cmake).
```

 
 
 ## QtCreator
 
 ### Install QtCreator
 Download installation file from https://download.qt.io/official_releases/qtcreator/ and do installation process.
 
 ### Setup QtCreator
 
 During this phase, I use information from the page: http://www.iwasz.pl/electronics/stm32-on-ubuntu-linux-step-by-step/

 #### Install Bare Metal plugin
After start QtCreator, do:
 - Help -> About Plugins
 - Turn on ***BareMetal*** plugin

 ![alt text](https://github.com/macias2k4/stm32-cmake-qtcreator/blob/master/resources/aboutPlugins_bareMetal.png?raw=true)
 
 To make plugin active QtCreator have to be restarted.
 
#### Add server provider for OpenOCD GDB
 - Open Tools -> Options 
 - Select ***Devices*** and tab ***Bare Metal***
 - Add ***OpenOCD***, leave default parameter values and ***Apply***
 
 ![alt text](https://github.com/macias2k4/stm32-cmake-qtcreator/blob/master/resources/options_devices_bareMetal.png?raw=true)
 
 - Switch do tab ***Devices*** and ***Bare Metal Device***
 - Set a name and select OpenOCD just created and ***Apply***
 
 ![alt text](https://github.com/macias2k4/stm32-cmake-qtcreator/blob/master/resources/options_devices_devices.png?raw=true)
 

