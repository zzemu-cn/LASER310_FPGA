# LASER310 FPGA

Welcome to LASER310_FPGA project. This project is an attempt to recreate the once famous VZ300/Laser310 computer in 80's on Altera Cyclone based FPGA boards.

<img src="doc/images/Laser310onVGA.jpeg" alt="Laser310 on VGA" width="400"/>

***Software requirment:***   
Quartus 13.0 web edition for projects except DE0_CV. For DE0_CV, you need 18.0 or newer.   

***Features implemented:***
1. MC6847 /w VGA output
2. Super high resolution mode (256*192)
3. Cassette input/output emu
4. Laser310 internal ROM/DOS ROM on flash
5. Enable external ROM with onboard switches at runtime.
6. VZ200 support
7. 256K RAM module
8. Buzzer output
9. PS/2 keyboard support (Ctrl+F12 to reset).
10. 12.5MHz overclock on SW0

***Planned***

1. Z80 bus on GPIO mapping.
2. Floppy emu support

***Screenshots***  
IORQ output n,5 captured on GPIO1  
<img src="doc/IORQ_output 5.jpg" alt="IORQ on output"/>  

***Supported boards***

- Terasic DE0
- Terasic DE0_CV
- Terasic DE1
- Terasic DE2
- Terasic DE2-70
- Terasic DE2-115

***Folder structures***

doc_LASER310:

Laser310 Ext Basic P1.5c and user manual.

Laser310 System B and user manual.

Laser310 Monitor and user manual

Cassette output encoding details.

Laser310 keyboard encoding schema

Laser310 oscilloscope screenshot of cassette output 

rom:

VZ300/Laser310 roms

Software:

development tools for this project. 

vz:

Some come games for testing.

SYSTEM-B.vz is a binary file loading/saving tool for cassette/disk on Laser 310.

BASIC_P1.5C.vz is an extended Basic for Laser 310 developed by XinMin Peng in 80's.

MONITORR.vz is an award winning CALL-151 like system monitor tool for Laser 310.

More details on these VZ300/Laser310 softwares to follow.

