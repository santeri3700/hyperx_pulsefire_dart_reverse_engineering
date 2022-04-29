# HyperX Pulsefire Dart Reverse Engineering

## Introduction
Reverse engineering material for the HyperX Pulsefire Dart Wireless Gaming Mouse

The HyperX Pulsefire Dart Wireless Gaming Mouse enumerates at **0951:16E1** (wireless) and **0951:16E2** (wired) and uses URB_INTERRUPT for control. Messages are 64 bytes long and zero-filled.

My unit (*HX-MC006B 3500457-001.B00LF*) has the following firmware versions reported by the Windows software:
- Wireless firmware v4.1.0.4 (Wireless dongle firmware)
- Wired    firmware v1.1.0.8 (Mouse firmware)

These values seem to be the same (each digit split by dot) as in bcdDevice USB device descriptor value. <br>

Check firmware versions on Linux:
```
cat $(egrep -l '16e1|16e2' /sys/bus/usb/devices/*/idProduct | sed 's/idProduct/bcdDevice/g')
```

The mouse operates in "direct mode" by default. It is therefore safe to send constant changes to the mouse without wearing the on-board memory. \
Settings are only saved when sending a packet starting with `DE FF 00 00`.

The mouse is only compatible with the newer version of [HyperX NGenuity](https://www.hyperxgaming.com/ngenuity#headline) (only available for Windows 10 from the Microsoft Store) and has a different protocol compared to older HyperX mice.

The codename for the newer NGenuity software is "NGenuity2", so that could perhaps be used as the protocol name.

The reverse engineering process has been purely done by inspecting the packets sent by NGenuity Beta and the mouse itself. \
Some parts of the protocol documentation have been discovered by trial and error. \
No HyperX Windows software has been decompiled or inspected while creating this project.

## Protocol documentation
- [Index](protocol/index.md)

## HIDAPI example code
- [example.c](misc/example.c) <br>
`gcc -Ihidapi -lhidapi-hidraw example.c -o example && ./example 255 128 64 # RED GREEN BLUE`

## Packet captures
- [Index](captures/index.md)

## WIP Wireshark Dissector
- [wireshark_ngenuity2_dissector.lua](misc/wireshark_ngenuity2_dissector.lua) (Hacked together in a few hours)

# License
[![CC0](https://licensebuttons.net/p/zero/1.0/88x31.png)](https://creativecommons.org/publicdomain/zero/1.0/)

The contents of this repository are licensed with 
[Creative Commons — CC0 1.0 Universal](https://creativecommons.org/publicdomain/zero/1.0/) license unless explicitly stated otherwise. Zero rights reserved.

HyperX® & HyperX Pulsefire Dart™ are registered trademarks of HP Inc (which were previously owned by Kingston Technology Corporation). <br>
This project is not affiliated with or endorsed by HyperX, HP Inc or Kingston Technology Corporation. <br>
All registered trademarks and trademarks are property of their respective owners.
