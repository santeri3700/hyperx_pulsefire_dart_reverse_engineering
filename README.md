# HyperX Pulsefire Dart Reverse Engineering

## Introduction
Reverse engineering material for the Kingston HyperX Pulsefire Dart Wireless Gaming Mouse

The HyperX Pulsefire Dart Wireless Gaming Mouse enumerates at 0951:16E1 (wireless) and 0951:16E2 (wired) and uses URB_INTERRUPT for control. Messages are 64 bytes long and zero-filled.

My unit (HX-MC006B 3500457-001.B00LF) has the following firmware versions reported by the Windows software:
- Wireless firmware v4.1.0.4 (Wireless dongle firmware)
- Wired    firmware v1.1.0.8 (Mouse firmware)

These values seem to be the same (each digit split by dot) as in bcdDevice USB device descriptor value. <br>

Check firmware versions on Linux: `cat $(egrep -l '16e1|16e2' /sys/bus/usb/devices/usb*/*/idProduct | sed 's/idProduct/bcdDevice/g')`

All settings seem to be saved only with `DE FF 00 00 ...`, otherwise power cycle will revert all changes.
The mouse operates in "direct mode" by default based on this information and how the new NGenuity communicates with the mouse.
It is therefore safe to send constant color changes to the mouse without wearing the on-board memory. 

The mouse is only compatible with the newer version of [HyperX NGenuity](https://www.hyperxgaming.com/ngenuity#headline) (only available for Windows 10 from the Microsoft Store) and has a different protocol compared to older HyperX mice.

The codename for the newer NGenuity software is "NGenuity2", so that could perhaps be used as the protocol name.

## Protocol documentation
- [Index](protocol/index.md)

## Packet captures
- [Index](captures/index.md)

# License
[![CC0](https://licensebuttons.net/p/zero/1.0/88x31.png)](https://creativecommons.org/publicdomain/zero/1.0/)

The contents of this repository are licensed with 
[Creative Commons — CC0 1.0 Universal](https://creativecommons.org/publicdomain/zero/1.0/) license unless explicitly stated otherwise. Zero rights reserved.

Kingston®, HyperX® & HyperX Pulsefire Dart™ are registered trademarks of Kingston Technology Corporation. <br>
This project is not affiliated with or endorsed by Kingston Technology Corporation.
