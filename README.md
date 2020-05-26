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
 https://doc.qt.io/qtcreator/creator-developing-baremetal.html

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
 
 #### Adding Bare Metal Devices
 
 - Switch do tab ***Devices*** and ***Bare Metal Device***
 - Set a name and select OpenOCD just created and ***Apply***
 
 ![alt text](https://github.com/macias2k4/stm32-cmake-qtcreator/blob/master/resources/options_devices_devices.png?raw=true)
 
 #### Configure Compilers
 
 - Open ***Tools -> Options***
 - Select ***Kits*** and tab ***Compilers***
 - Use ***Add -> GCC -> C***. Set 'Name' (e.g. ***ARM GCC 9 (C)***) and set a path to file ***arm-none-eabi-gcc*** in directory where you uncomprese file ***xpack-arm-none-eabi-gcc-9.2.1-1.1-linux-x64.tar.gz*** from first chapter ***ARM GCC***
 - Use ***Add -> GCC -> C++***. Set 'Name' (e.g. ***ARM-GCC 9 (C++)***) and set a path to file ***arm-none-eabi-g++*** in directory where you uncomprese file ***xpack-arm-none-eabi-gcc-9.2.1-1.1-linux-x64.tar.gz*** from first chapter ***ARM GCC***
 
 ![alt text](https://github.com/macias2k4/stm32-cmake-qtcreator/blob/master/resources/options_kits_compilers.png?raw=true)
 
 #### Configure Kit for building application for ARM device
  
 - Open ***Tools -> Options***
 - Select ***Kits*** and tab ***Kits***
 - Use ***Add*** to create new kiy
  - Set ***Name*** e.g. *ARM CMake GCC 9*
  - Set ***Device type*** to *Bare Metal Device*
  - Set ***Device*** to device created in step **Adding Bare Metal Devices** (in my case it's *STM32F4*)
  - Set C and C++ compiler created in step **Configure Compilers** and ***Apply***
 
 ![alt text](https://github.com/macias2k4/stm32-cmake-qtcreator/blob/master/resources/options_kits_kits.png?raw=true)
 
## STM32 tools (Stm32CubeMX, HAL)

So far we can compile C/C++ code in ARM-GCC compiler in a command line or IDE (QtCreator), but to create software for STM32 (e.g. Nucleo) we still need something more:
- **Stm32CubeMX** - UI tool, for configuring peripherals for microcontroller STM32
- **HAL** *(Hardware Abstraction Layer)* - interface for microcontroller hardware

### Installing Stm32CubeMX

Install java if it's not already installed:
```console
sudo apt-get update && apt-get upgrade
sudo apt-get install default-jdk
```

Download STM32CubeMX from site: https://www.st.com/en/development-tools/stm32cubemx.html

 Then we need to run the installation process (when I'm writing this article current version was 5-6-1):
 ```console
unzip en.stm32cubemx_v5-6-1.zip
chmod +x SetupSTM32CubeMX-5.6.1.linux
sudo ./SetupSTM32CubeMX-5.6.1.linux
 ```
 
 Now we can run STM32CubeMX to check is it work (go to installation path and start the application)
 ```console
 cd /usr/local/STMicroelectronics/STM32Cube/STM32CubeMX
 sudo ./STM32CubeMX
 ```
 
## First project (blinking LED)
 
 It's finally time to create the first project for our board. This will be blinking led.

### Configure microcontroller periphery and generate code
 
 When we start STM32CubeMX application I use option **ACCESS TO BOARD SELECTOR**. Then in **Part Number Search** write the name of board *Nucleo-f411re*(in my case). Select board on the bottom list and use **Start Project**.
 
 ![alt text](https://github.com/macias2k4/stm32-cmake-qtcreator/blob/master/resources/stm32cubemx_boardSelector.png?raw=true)
 
 After that we will see a view of **Pinout & Configuration** (we leave this in default settings). We switch to **Project Manager** and set needed parameters in his tabs: **Project, Code Generator**.
 
. images

After setting all parameters we use button **GENERATE CODE**

### Generating CMake project file from STM32CubeMX project file



### 
