# 数字逻辑电路实验

This contains all projects completed for this lab course. 

The software used is Quartus II (free version), the Hardware Description Language used is VHDL, and the FPGA device we use is the MAX II EMP240T100C5

Due to the epidemic, there are only four projects. 
We utilize a virtual FPGA created by THU and Quartus' simulation tools to analyze our code and implementation. 

实验
  1. 点亮数字人生
  2. 四位加法器
  3. 计算器的设计
  4. 串行密码锁
  
## 点亮数字人生 Digital Tube Display
The nixie tube is the most intuitive window to understand the digital circuit. According to the decoding requirements of the nixie tube, use the hardware description language to design and control the output of the nixie tube through the input to display the number. 

## 四位加法器 Four Bit Adder 
The hardware description language is used to design and implement the multiplexer, and the software is used to simulate the function, and then it is downloaded to CPLD for verification.

## 计算器的设计 Calculator
Master the basic analysis and design method of the sequential logic circuit, understand the working principle of the trigger (触发器), use the hardware description language to realize the gate level design of the trigger, understand the working principle of the register (寄存器), use the hardware description language to realize the design of different word length registers, master the method of using the trigger to constitute various counters, and use the hardware description language to realize the design of designated function counters.

## 串行密码锁 Serial Password
Master the basic analysis and design method of sequential logic circuit, understand the working principle of state machine, and use hardware description language to realize state machine to design a practical application example. Create a system that can set a password, check if the password is correct, and utilize a master password.

## 开放性数电实验设计 Open Project
This is was our final project, to create our own design. I chose to design a stop watch with basic functionalities, reset, start/stop, split times (up to 3), and show lap history. The timer can go from 0:00:00 to 9:59:99 (minutes:seconds:centiseconds)

