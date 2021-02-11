# HyperX Pulsefire Dart Reverse Engineering

## Introduction
Reverse engineering material for the Kingston HyperX Pulsefire Dart Wireless Gaming Mouse

The HyperX Pulsefire Dart Wireless Gaming Mouse enumerates at 0951:16E1 (wireless) and 0951:16E2 (wired) and uses URB_INTERRUPT for control. Messages are 64 bytes long and zero-filled.

All settings seem to be saved only with `DE FF 00 00 ...`, otherwise power cycle will revert all changes.
The mouse operates in "direct mode" by default based on this information and how the new NGenuity communicates with the mouse.
It is therefore safe to send constant color changes to the mouse without wearing the on-board memory. 

The mouse is only compatible with the newer version of [HyperX NGenuity](https://www.hyperxgaming.com/ngenuity#headline) (only available for Windows 10 from the Microsoft Store) and has a different protocol compared to older HyperX mice.

The codename for the newer NGenuity software is "NGenuity2", so that could perhaps be used as the protocol name.

# Protocol documentation
- [Index](protocol/index.md)
