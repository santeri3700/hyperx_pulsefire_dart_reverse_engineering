# HyperX Gaming Mouse protocol documentation (NGenuity2 protocol)

# Send
These packets are sent by NGenuity.

## Set polling rate
| Byte index | Value | Description |
| ------ | ------ | ------ |
| 0x00 | 0xD0 | Set polling rate |
| 0x01 | 0x00 | Unknown/padding |
| 0x02 | 0x00 | Unknown/padding |
| 0x03 | 0x01 | 1 byte after byte index 0x03 |
| 0x04 | 0x** | Polling rate value <br><ul><li>0x00 = 125Hz </li><li>0x01 = 250Hz</li><li>0x02 = 500Hz </li><li>0x03 = 1000Hz</li></ul> |

## Set color, mode, effect, brightness and speed per LED
| Byte index | Value | Description |
| ------ | ------ | ------ |
| 0x00 | 0xD2 | Send LED |
| 0x01 | 0x20 | LED number <br><ul><li>0x00 = Scroll wheel </li><li>0x10 = Logo </li><li>0x20 = Both</li></ul> |
| 0x02 | 0x00 | Effect mode <br><ul><li>0x00 = Static color </li><li>0x12 = Spectrum Cycle </li><li>0x20 = Breathing </li><li>0x30 = Trigger Fade</li></ul> |
| 0x03 | 0x08 | 8 bytes after byte index 0x03 |
| 0x04 | 0xAA | RED |
| 0x05 | 0xBB | GREEN |
| 0x06 | 0xCC | BLUE |
| 0x07 | 0xAA | RED (doesn't seem to affect anything) |
| 0x08 | 0xBB | GREEN (doesn't seem to affect anything) |
| 0x09 | 0xCC | BLUE (doesn't seem to affect anything) |
| 0x0A | 0x64 | Brightness <br><ul><li>Min: 0x64 (DEC: 100) </li><li>Max: 0x00 (DEC: 0)</li> <li>Step: 0x01 (DEC: 1)</li></ul> |
| 0x0B | 0x00 | Effect speed <br><b>ONLY APPLIES TO NON-STATIC MODES!</b> <br><ul><li>Min: 0x40 (DEC: 64) </li><li>Max: 0x00 (DEC: 0)</li> <li>Step: 0x01 (DEC: 1)</li></ul> |

## Select DPI profile
| Byte index | Value | Description |
| ------ | ------ | ------ |
| 0x00 | 0xD3 | Send DPI profile |
| 0x01 | 0x00 | 0x00 = Select DPI profile <br>0x03 = Set DPI profile effect color |
| 0x02 | 0x00 | Unknown |
| 0x03 | 0x01 | 1 byte after byte index 0x03 |
| 0x04 | 0x01 | Profile number (0x00-0x04) |

## Set button assignment
| Byte index | Value | Description |
| ------ | ------ | ------ |
| 0x00 | 0xD4 | Send button assignment |
| 0x01 | 0x** | Physical button <br><ul><li>0x00 = Left click </li><li>0x01 = Right click </li><li>0x02 = Middle click </li><li>0x03 = Side button forward </li><li>0x04 = Side button back </li><li>0x05 = DPI Toggle </li></ul> |
| 0x02 | 0x** | Assignment type <br><ul><li>0x01 = Mouse functions (USB HID Button Page 0x09) </li><li>0x02 = Keyboard functions (USB HID Keyboard Page 0x07) </li><li>0x03 = Media functions (Non-standard codes) </li><li>0x04 = Macro function </li><li>0x07 = Unknown/DPI Switch function(s) </li></ul> |
| 0x03 | 0x02 | 2 bytes after byte index 0x03 |
| 0x00 | 0x** | Assignment code or USB HID Usage ID <br><b>More information in "Button assignment codes" section</b> |
| 0x00 | 0x04 | Unknown. Seems to always be 0x04 except on macro function where the value is 0x00 |

## Set macro assignment
<b>Must be sent immediately after last packet of macro data </b>
| Byte index | Value | Description |
| ------ | ------ | ------ |
| 0x00 | 0xD5 | Set macro assignment |
| 0x01 | 0x** | Physical button <br><ul><li>0x02 = Middle click </li><li>0x03 = Side button forward </li><li>0x04 = Side button back </li><li>0x05 = DPI Toggle </li></ul> |
| 0x02 | 0x00 | Unknown |
| 0x03 | 0x05 | 5 bytes after byte index 0x03 |
| 0x04 | 0x** | Number of macro events (0x01-0xFF?) |
| 0x05 | 0x00 | Unknown |
| 0x06 | 0x00 | Unknown |
| 0x07 | 0x00 | Unknown |
| 0x08 | 0x00 | Unknown |

## Set macro data
Macro data can contain a maximum of 6 events each packet because each packet must not exceed 64 bytes. <br>
Each macro event contains the key code and delay which defines how long the mouse should wait before executing the next macro event in the macro data. <br>
First 4 bytes are reserved and rest are used for the macro data (6 * 10 bytes = 60 bytes).

| Byte index | Value | Description |
| ------ | ------ | ------ |
| 0x00 | 0xD6 | Set macro data |
| 0x01 | 0x** | Physical button <br><ul><li>0x02 = Middle click </li><li>0x03 = Side button forward </li><li>0x04 = Side button back </li><li>0x05 = DPI Toggle </li></ul> |
| 0x02 | 0x00 | Unknown. Changes when the amount on macro events is more than 6 in total. |
| 0x03 | 0x** | Number of macro events(?). Unknown when more than 6 macro events in total. |
| 0x04-0x40 | 10 byte macro events | Each event starts with <br>`1A` (for keyboard functions) <br>or <br>`25` (for mouse functions) |

### Example macro events 1:

1. Key 1 down for  100ms (64 00 = 0x0064 = 100ms)
2. Key 1   up for  255ms (FF 00 = 0x00FF = 255ms)
3. Key 2 down for  100ms
4. Key 2   up for 1234ms (D2 04 = 0x04D2 = 1234ms)
5. Key 3 down for  100ms
6. Key 3   up for  255ms

First 4 bytes:
| Set macro data | Physical button | Unknown | Number of macro events/Unknown |
| ------ | ------ | ------ | ------ |
| D6 | 04 | 00 | 06 |

Tailing 60-byte macro data:
| Macro event | Unknown | Key/00=Key up | Unknown | Unknown | Unknown | Unknown | Unknown | Delay upper byte | Delay lower byte |
| ------ | ------ | ------ | ------ | ------ | ------ | ------ | ------ | ------ | ------ |
| 1A | 00 | 1E | 00 | 00 | 00 | 00 | 00 | 64 | 00 |
| 1A | 00 | 00 | 00 | 00 | 00 | 00 | 00 | FF | 00 |
| 1A | 00 | 1F | 00 | 00 | 00 | 00 | 00 | 64 | 00 |
| 1A | 00 | 00 | 00 | 00 | 00 | 00 | 00 | D2 | 04 |
| 1A | 00 | 20 | 00 | 00 | 00 | 00 | 00 | 64 | 00 |
| 1A | 00 | 00 | 00 | 00 | 00 | 00 | 00 | FF | 00 |

### Example macro events 2:

##### (PART 1/3)
- Key 1 down for 255ms
- Key 1   up for 255ms
- Key 2 down for 255ms
- Key 2   up for 255ms
- Key 3 down for 255ms
- Key 3   up for 255ms

First 4 bytes:
| Set macro data | Physical button | Unknown | Number of macro events/Unknown |
| ------ | ------ | ------ | ------ |
| D6 | 04 | 00 | 06 |

Tailing 60-byte macro data:
| Macro event | Unknown | Key/00=Key up | Unknown | Unknown | Unknown | Unknown | Unknown | Delay upper byte | Delay lower byte |
| ------ | ------ | ------ | ------ | ------ | ------ | ------ | ------ | ------ | ------ |
| 1A | 00 | 1E | 00 | 00 | 00 | 00 | 00 | FF | 00 |
| 1A | 00 | 00 | 00 | 00 | 00 | 00 | 00 | FF | 00 |
| 1A | 00 | 1F | 00 | 00 | 00 | 00 | 00 | FF | 00 |
| 1A | 00 | 00 | 00 | 00 | 00 | 00 | 00 | FF | 00 |
| 1A | 00 | 20 | 00 | 00 | 00 | 00 | 00 | FF | 00 |
| 1A | 00 | 00 | 00 | 00 | 00 | 00 | 00 | FF | 00 |

##### (PART 2/3)
- Key 4 down for 255ms
- Key 4   up for 255ms
- Key 5 down for 255ms
- Key 5   up for 255ms
- Key 6 down for 255ms
- Key 6   up for 255ms

First 4 bytes:
| Set macro data | Physical button | Unknown | Number of macro events/Unknown |
| ------ | ------ | ------ | ------ |
| D6 | 04 | 01 | 86 |

Tailing 60-byte macro data:
| Macro event | Unknown | Key/00=Key up | Unknown | Unknown | Unknown | Unknown | Unknown | Delay upper byte | Delay lower byte |
| ------ | ------ | ------ | ------ | ------ | ------ | ------ | ------ | ------ | ------ |
| 1A | 00 | 21 | 00 | 00 | 00 | 00 | 00 | FF | 00 |
| 1A | 00 | 00 | 00 | 00 | 00 | 00 | 00 | FF | 00 |
| 1A | 00 | 22 | 00 | 00 | 00 | 00 | 00 | FF | 00 |
| 1A | 00 | 00 | 00 | 00 | 00 | 00 | 00 | FF | 00 |
| 1A | 00 | 23 | 00 | 00 | 00 | 00 | 00 | FF | 00 |
| 1A | 00 | 00 | 00 | 00 | 00 | 00 | 00 | FF | 00 |

##### (PART 3/3)
- Key 7 down for 255ms
- Key 7   up for 255ms

First 4 bytes:
| Set macro data | Physical button | Unknown | Number of macro events/Unknown |
| ------ | ------ | ------ | ------ |
| D6 | 04 | 03 | 02 |

Tailing 60-byte macro data:
| Macro event | Unknown | Key/00=Key up | Unknown | Unknown | Unknown | Unknown | Unknown | Delay upper byte | Delay lower byte |
| ------ | ------ | ------ | ------ | ------ | ------ | ------ | ------ | ------ | ------ |
| 1A | 00 | 24 | 00 | 00 | 00 | 00 | 00 | FF | 00 |
| 1A | 00 | 00 | 00 | 00 | 00 | 00 | 00 | FF | 00 |
| 1A | 00 | 00 | 00 | 00 | 00 | 00 | 00 | 00 | 00 |
| 1A | 00 | 00 | 00 | 00 | 00 | 00 | 00 | 00 | 00 |
| 1A | 00 | 00 | 00 | 00 | 00 | 00 | 00 | 00 | 00 |
| 1A | 00 | 00 | 00 | 00 | 00 | 00 | 00 | 00 | 00 |

---

## Save settings to hardware
| Byte index | Value | Description |
| ------ | ------ | ------ |
| 0x00 | 0xDE | Save? |
| 0x01 | 0xFF | Unknown/profile(s)? |

## Get mouse information
| Byte index | Value | Description |
| ------ | ------ | ------ |
| 0x00 | 0x50 | Get mouse information |

## Get heartbeat
| Byte index | Value | Description |
| ------ | ------ | ------ |
| 0x00 | 0x51 | Get heartbeat |

<br>

# Receive
These packets are sent by the mouse ("reports" require a request first, "events" come directly from the mouse without a request).

## Report: Mouse information
| Byte index | Value | Description |
| ------ | ------ | ------ |
| 0x00 | 0x50 | Mouse information report |
| 0x01 | 0x00 | Unknown |
| 0x02 | 0x00 | Unknown |
| 0x03 | 0x1d | Unknown |
| 0x04 | 0xe2 | Unknown |
| 0x05 | 0x16 | Unknown |
| 0x06 | 0x51 | Unknown |
| 0x07 | 0x09 | Unknown |
| 0x08 | 0x08 | Unknown |
| 0x09 | 0x00 | Unknown |
| 0x0a | 0x01 | Unknown |
| 0x0b | 0x01 | Unknown |
| 0x0c | 0x48 | H |
| 0x0d | 0x79 | y |
| 0x0e | 0x70 | p |
| 0x0f | 0x65 | e |
| 0x10 | 0x72 | r |
| 0x11 | 0x58 | X |
| 0x12 | 0x20 | (space) |
| 0x13 | 0x50 | P |
| 0x14 | 0x75 | u |
| 0x15 | 0x6c | l |
| 0x16 | 0x73 | s |
| 0x17 | 0x65 | e |
| 0x18 | 0x66 | f |
| 0x19 | 0x69 | i |
| 0x1a | 0x72 | r |
| 0x1b | 0x65 | e |
| 0x1c | 0x20 | (space) |
| 0x1d | 0x44 | D |
| 0x1e | 0x61 | a |
| 0x1f | 0x72 | r |
| 0x20 | 0x74 | t |

## Report: Heartbeat
| Byte index | Value | Description |
| ------ | ------ | ------ |
| 0x00 | 0x51 | Heartbeat report |
| 0x01 | 0x00 | Unknown/padding |
| 0x02 | 0x00 | Unknown/padding |
| 0x03 | 0x03 | 3 bytes after byte index 0x03 |
| 0x04 | 0x** | Battery percentage <br><ul><li>Min: 0x00 (DEC: 0) </li><li>Max: 0x64 (DEC: 100)</li> <li>Step: 0x01 (DEC: 1)</li></ul> |
| 0x05 | 0x01 | Unknown |
| 0x06 | 0x0F | Unknown |
| 0x07 | 0x8B | Unknown value, changes when battery percentage changes. Maybe voltage? |
| 0x08 | 0x10 | Unknown value, changes when battery percentage changes. Maybe voltage? |
| 0x08 | 0x02 | Unknown |
| 0x09 | 0x40 | Unknown |

## Event: Mouse state change
| Byte index | Value | Description |
| ------ | ------ | ------ |
| 0x00 | 0xff | Generic event |
| 0x01 | 0x03 | Unknown |
| 0x02 | 0x** | Active profile number (0x00-0x04) |
| 0x03 | 0x** | <ul><li>0x00 = USB cable NOT connected / NOT charging </li><li>0x01 = USB cable connected / Charging </li></ul> |
| 0x04 | 0x** | <ul><li>0x00 = Sleep </li><li>0x01 = Awake </li></ul> |
| 0x05 | 0x00 | Unknown |
| 0x06 | 0x** | <ul><li>0x00 = No button(s) pressed / Button(s) up</li> <li>0x02 = DPI toggle button</li></ul> |
| 0x07 | 0x** | <ul><li>0x00 = Not buttons pressed</li> <li>0x01 = Left click</li> <li>0x02 = Right click</li> <li>0x04 = Middle click</li> <li>0x08 = Side button forward</li> <li>0x10 = Side button back</li> |
<br>

---

# Button assignment codes
An official list of codes (also known as Usage IDs) can be found from USB-IF's [USB HID Usage Tables PDF](https://www.usb.org/sites/default/files/hut1_2.pdf)

## Mouse functions (Assignment type = 0x01)
[USB HID Usage Tables PDF](https://www.usb.org/sites/default/files/hut1_2.pdf) Page 102 (12 - Button Page - 0x09)
| Code | Button/key/action |
| ------ | ------ |
| 0x01 | Left click |
| 0x02 | Right click |
| 0x03 | Middle click |
| 0x04 | Forward |
| 0x05 | Back |

## Keyboard functions (Assignment type = 0x02)
[USB HID Usage Tables PDF](https://www.usb.org/sites/default/files/hut1_2.pdf) Pages 81-88 (10 - Keyboard/Keypad Page - 0x07) <br>

Not every key code has been tested on the actual hardware, but my guess is that all of the IBM PC/AT compatible key codes will work.

## Media functions (Assignment type = 0x03)
Seems like the media buttons are not the same as defined in the USB-IF's specifications.
| Code | Button/key/action |
| ------ | ------ |
| 0x00 | Play/Pause |
| 0x01 | Stop |
| 0x02 | Previous |
| 0x03 | Next |
| 0x04 | Volume mute |
| 0x05 | Volume down |
| 0x06 | Volume up |

## Unknown functions (Assignment type = 0x07)
| Code | Button/key/action |
| ------ | ------ |
| 0x08 | DPI Toggle |
