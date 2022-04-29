# HyperX Gaming Mouse protocol documentation (NGenuity2 protocol)

Device and vendor IDs: **0951:16E1** (wireless), **0951:16E2** (wired) \
Usage page: 0xFF13 (wired), 0xFF00 (wireless) \
Interface: 1 (wired), 2 (wireless)

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

## Set low-power warning threshold
| Byte index | Value | Description |
| ------ | ------ | ------ |
| 0x00 | 0xD1 | Set low-power warning threshold |
| 0x01 | 0x00 | Unknown/padding |
| 0x02 | 0x00 | Unknown/padding |
| 0x03 | 0x01 | 1 byte after byte index 0x03 |
| 0x04 = 0x** | Battery percentage (Officially 5-25%)

## Set color, mode, effect, brightness and speed per LED
| Byte index | Value | Description |
| ------ | ------ | ------ |
| 0x00 | 0xD2 | Send LED |
| 0x01 | 0x20 | LED number <br><ul><li>0x00 = Logo </li><li>0x10 = Scroll wheel </li><li>0x20 = Both</li></ul> |
| 0x02 | 0x00 | Effect mode <br><ul><li>0x00 = Static color </li><li>0x10 = Unofficial Spectrum Cycle (works when 0x12 doesn't) <li>0x12 = Spectrum Cycle </li><li>0x20 = Breathing </li><li>0x30 = Trigger Fade</li></ul> |
| 0x03 | 0x08 | 8 bytes after byte index 0x03 |
| 0x04 | 0xAA | RED |
| 0x05 | 0xBB | GREEN |
| 0x06 | 0xCC | BLUE |
| 0x07 | 0xAA | RED (probably related to an effect, unused by NGenuity) |
| 0x08 | 0xBB | GREEN (probably related to an effect, unused by NGenuity) |
| 0x09 | 0xCC | BLUE (probably related to an effect, unused by NGenuity) |
| 0x0A | 0x64 | Brightness <br><ul><li>Min: 0x00 (DEC: 0) </li><li>Max: 0x64 (DEC: 100)</li> <li>Step: 0x01 (DEC: 1)</li></ul> |
| 0x0B | 0x00 | Effect speed <br><b>ONLY APPLIES TO NON-STATIC MODES!</b> <br><ul><li>Min: 0x64 (DEC: 100) </li><li>Max: 0x00 (DEC: 0)</li> <li>Step: 0x01 (DEC: 1)</li></ul> |

## Set DPI profiles/selection/color/DPI value
| Byte index | Value | Description |
| ------ | ------ | ------ |
| 0x00 | 0xD3 | Send DPI profile |
| 0x01 | 0x** | Mode <br><ul><li>0x00 = Select DPI profile </li><li>0x01 = Set enabled DPI profiles </li><li>0x02 = Set DPI value </li><li>0x03 = Set DPI change effect color </li></ul> |
| 0x02 | 0x00 | <ul><li>DPI Profile number when Mode = 0x00 or 0x03 </li></ul> |
| 0x03 | 0x** | <ul><li>Mode 0x00 & 0x01 -> 0x01 = 1 byte after byte index 0x03 (Enabled DPI profiles) </li><li>Mode 0x02 = 2 bytes after byte index 0x03 (DPI value lower byte & DPI value upper byte)</li><li>Mode 0x03 -> 0x03 = 3 bytes after byte index 0x03 (R, G ,B) </li></ul> |
| 0x04 | 0x** | <ul><li>Mode 0x00 = Set active DPI profile number (0x00-0x04) </li><li>Mode 0x01 = Enabled DPI profiles (5 bit value, see more details below) </li><li>Mode 0x02 = DPI value lower byte (see more details below) </li><li>Mode 0x03 = RED</ul> |
| 0x05 | 0x** | <ul><li>Mode 0x02 = DPI value upper byte  (see more details below) </li><li>Mode 0x03 = GREEN</li></ul> |
| 0x06 | 0x** | <ul><li>Mode 0x03 = BLUE</li></ul> |

### DPI value data structure
DPI data consists of a 2-byte integer which is divisible by 50 (this is also called the "step").

    # DPI to 2-byte integer
    16000 DPI / 50 STEP = 320
    Lower byte  = (320 & 255) = 64 (0x40)
    Upper byte  = (320 >> 8) & 255 = 1 (0x01)
    RESULT      = 0x40 0x01

    # 2-byte integer to DPI
    0x40 0x01 = 64 1
    (1 << 8) + 64 = 320
    320 * 50 = 16000 DPI

### DPI enabled profiles data structure
Enabled profiles are selected with a 5-bit number. \
Each bit represents the state of each DPI profile (5 in total). \
The order is reversed so 1st bit is the 5th profile and 5th bit is the 1st profile.
| Enabled profiles | #5 | #4 | #3 | #2 | #1 | Quintet |
| --------------- | - | - | - | - | - | ------ |
| 1               | 0 | 0 | 0 | 0 | 1 | **1**  |
| 1,2             | 0 | 0 | 0 | 1 | 1 | **3**  |
| 1,2,3           | 0 | 0 | 1 | 1 | 1 | **7**  |
| 1,2,3,4         | 0 | 1 | 1 | 1 | 1 | **15** |
| 1,2,3,4,5       | 1 | 1 | 1 | 1 | 1 | **31** |
| 1,3,5           | 1 | 0 | 1 | 0 | 1 | **21** |
| 2,4             | 0 | 1 | 0 | 1 | 0 | **10** |


## Set button assignment
| Byte index | Value | Description |
| ------ | ------ | ------ |
| 0x00 | 0xD4 | Send button assignment |
| 0x01 | 0x** | Physical button <br><ul><li>0x00 = Left click </li><li>0x01 = Right click </li><li>0x02 = Middle click </li><li>0x03 = Side button forward </li><li>0x04 = Side button back </li><li>0x05 = DPI Toggle </li></ul> |
| 0x02 | 0x** | Assignment type <br><ul><li>0x01 = Mouse functions (USB HID Button Page 0x09) </li><li>0x02 = Keyboard functions (USB HID Keyboard Page 0x07) </li><li>0x03 = Media functions (Non-standard codes) </li><li>0x04 = Macro function </li><li>0x07 = Unknown/DPI Switch function(s) </li></ul> |
| 0x03 | 0x02 | 2 bytes after byte index 0x03 |
| 0x04 | 0x** | Physical button number, Assignment code or USB HID Usage ID <br><b>More information in "Button assignment codes" section</b> |
| 0x05 | 0x04 | Unknown. Seems to always be `0x04` except on macro function where the value is `0x00` |

## Set macro assignment
<b>Must be sent immediately <u>after</u> last packet of macro data! </b>
| Byte index | Value | Description |
| ------ | ------ | ------ |
| 0x00 | 0xD5 | Set macro assignment |
| 0x01 | 0x** | Physical button <br><ul><li>0x02 = Middle click </li><li>0x03 = Side button forward </li><li>0x04 = Side button back </li><li>0x05 = DPI Toggle </li></ul> |
| 0x02 | 0x00 | Unknown |
| 0x03 | 0x05 | 5 bytes after byte index 0x03 |
| 0x04 | 0x** | Number of macro events (0x01-0xFF?) |
| 0x05 | 0x00 | Unknown |
| 0x06 | 0x00 | Repeat mode <br><ul><li>0x00 = Play once </li><li>0x02 = Toggle repeat </li><li>0x03 = Hold repeat </li></ul> |
| 0x07 | 0x00 | Unknown |
| 0x08 | 0x00 | Unknown |

## Set macro data
Macro data can contain a maximum of 6 events each packet because each packet must not exceed 64 bytes. <br>
Each macro event contains the key code and delay which defines how long the mouse should wait before executing the next macro event in the macro data. <br>
First 4 bytes are reserved and the rest are used for the macro data (6 "rows" * 10 bytes = 60 bytes).

| Byte index | Value | Description |
| ------ | ------ | ------ |
| 0x00 | 0xD6 | Set macro data |
| 0x01 | 0x** | Physical button <br><ul><li>0x02 = Middle click </li><li>0x03 = Side button forward </li><li>0x04 = Side button back </li><li>0x05 = DPI Toggle </li></ul> |
| 0x02 | 0x00 | Seems to be somekind of an order number with some relation to the next byte. |
| 0x03 | 0x** | Number of macro events(?). Unknown/`0x86` when sending more than 1 packet of macro events in total. |
| 0x04-0x40 | 10 byte macro events | Each event starts with an "event type" <br>`1A` (for keyboard functions) <br>or <br>`25` (for mouse functions) |

### Macro event "rows"
* List of keycodes can be found under the Mouse functions & Keyboard functions sections.
* Delay converted to milliseconds is half of the actual delay (50 = 100ms and so on).
  * Example 1: `0x32 0x00 = (0x00 << 8) + 0x32 = 50 * 2 = 100ms`.
  * Example 2: `0xEE 0x02 = (0x02 << 8) + 0xEE = 750 * 2 = 1500ms`.
* Maximum delay in NGenuity is 9999ms. This is probably actually higher, but just limited by the official software. Theoretical maximum is 131.07s. \
(`0xFF 0xFF = (0xFF << 8) + 0xFF = 65535 * 2 = 131070ms = 131.07s = 2.1845 min`)

### Mouse function macro event "row"

* NGenuity only allows one mouse button down at a time. Looks like this is a limitation of the protocol and not NGenuity.

| Event type | Keycode | Unknown | Delay upper byte | Delay lower byte | Event type | Keycode | Unknown | Delay upper byte | Delay lower byte |
| - | - | - | - | - | - | - | - | - | - |
| 0x25 | 0x01 | 0x00 | 0x32 | 0x00 | 0x25 | 0x00 | 0x00 | 0x32 | 0x00 |

---

### Keyboard function macro event "row"

* Maximum of 5 buttons can be simultenously pressed down at a time.
* "The modifier keys 8-bit value" contains the keyboard in a single byte.

| Modifier key    |	Binary           | Info           |
| --------------- | ---------------- | -------------- |
| L-CTRL          | 0000000**1**     | 8th bit        |
| L-SHIFT         | 000000**1**0     | 7th bit        |
| L-ALT           | 00000**1**00     | 6th bit        |
| L-WIN           | 0000**1**000     | 5th bit        |
| R-CTRL          | 000**1**0000     | 4th bit        |
| R-SHIFT         | 00**1**00000     | 3rd bit        |
| R-ALT/ALT-GR    | 0**1**00000**1** | 2nd & 8th bits |
| R-WIN           | **1**0000000     | 1st bit        |

| Event type | Modifier keys 8-bit value | Keycode | Keycode | Keycode | Keycode | Keycode | Unknown | Delay upper byte | Delay lower byte |
| - | - | - | - | - | - | - | - | - | - |
| 0x1a | 0x00 | 0x00 | 0x32 | 0x00 | 0x25 | 0x00 | 0x00 | 0x32 | 0x00 |

---

## Save settings to hardware
| Byte index | Value | Description |
| ------ | ------ | ------ |
| 0x00 | 0xDE | Save? |
| 0x01 | 0xFF | Unknown/profile(s)? |

## Get mouse information
| Byte index | Value | Description |
| ------ | ------ | ------ |
| 0x00 | 0x50 | Get mouse hardware information |

## Get heartbeat
| Byte index | Value | Description |
| ------ | ------ | ------ |
| 0x00 | 0x51 | Get heartbeat |

## Get LED settings
**NOTE:** This packet was guessed instead of intercepted from NGenuity. \
The official software does not read settings from the mouse as far as I know.
| Byte index | Value | Description |
| ------ | ------ | ------ |
| 0x00 | 0x52 | Get mouse LED settings |

<br>

# Receive
These packets are sent by the mouse ("reports" require a request first, "events" come directly from the mouse without a request).

## Report: Mouse connectivity status
| Byte index | Value | Description |
| ------ | ------ | ------ |
| 0x00 | 0x46 | Mouse connectivity report |
| 0x01 | 0x00 | Unknown/Padding |
| 0x02 | 0x00 | Unknown/Padding |
| 0x03 | 0x0* | <ul><li>0x01 = Wireless connection (1 byte after byte index 0x03) </li><li>0x02 = Wired connection (2 bytes after byte index 0x03) </li></ul> |
| 0x04 | 0x** | <ul>Wireless connection<li>0x00 = Mouse not connected via dongle </li><li>0x01 = Mouse connected via dongle </li>Wired connection<li>0xEC = Unknown</li></ul>
| 0x05 | 0x00 | Unknown/Padding (only present when connected by wire)

## Report: Mouse hardware information
| Byte index | Value | Description |
| ------ | ------ | ------ |
| 0x00 | 0x50 | Mouse hardware information report |
| 0x01 | 0x00 | Unknown/Padding |
| 0x02 | 0x00 | Unknown/Padding |
| 0x03 | 0x1d | 29 bytes after byte index 0x03 |
| 0x04 | 0xe2 | Product ID **Lower** byte. <br>Example Product IDs: <ul><li>16 __e1__ = Pulsefire Dart Wireless Dongle</li><li> 16 __e2__ = Pulsefire Dart Wired Connection</li></ul> |
| 0x05 | 0x16 | Product ID **Upper** byte. <br>Example Product IDs: <ul><li>__16__ e1 = Pulsefire Dart Wireless Dongle</li><li> __16__ e2 = Pulsefire Dart Wired Connection</li></ul> |
| 0x06 | 0x51 | Vendor ID **Lower** byte. <br>E.g 09 __51__ = Kingston  |
| 0x07 | 0x09 | Vendor ID **Upper** byte. <br>E.g __09__ 51 = Kingston |
| 0x08 | 0x08 | Firmware build. E.g 1.1.0.__8__ (4th digit) |
| 0x09 | 0x00 | Firmware revision. E.g 1.1.__0__.8 (3rd digit) |
| 0x0a | 0x01 | Firmware minor version. 1.__1__.0.8 (2nd digit) |
| 0x0b | 0x01 | Firmware major version. __1__.1.0.8 (1st digit) |
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
| 0x05 | 0x01 | Charging status <ul><li>0x00 = Not charging</li><li>0x01 = Charging</li></ul> |
| 0x06 | 0x0F | Unknown |
| 0x07 | 0x8B | Unknown value, changes when battery percentage changes. Maybe voltage? |
| 0x08 | 0x10 | Unknown value, changes when battery percentage changes. Maybe voltage? |
| 0x09 | 0x02 | Unknown |
| 0x0a | 0x40 | Unknown |

## Report: LED settings
This packet seems to contain only LED settings **saved** to the on-board memory, not necessarily the currently applied settings.
| Byte index | Value | Description |
| ------ | ------ | ------ |
| 0x00 | 0x52 | LED settings report |
| 0x01 | 0x00 | Unknown/padding |
| 0x02 | 0x00 | Unknown/padding |
| 0x03 | 0x11 | Unknown/Some kind of length value? |
| 0x04 | 0x00 | Logo effect upper byte |
| 0x05 | 0x00 | Logo effect lower byte |
| 0x06 | 0x00 | Logo effect speed |
| 0x07 | 0x64 | Logo brightness |
| 0x08 | 0x** | Logo Red1? |
| 0x09 | 0x** | Logo Green1? |
| 0x0a | 0x** | Logo Blue1? |
| 0x0b | 0x** | Logo Red2? |
| 0x0c | 0x** | Logo Green2? |
| 0x0d | 0x** | Logo Blue2? |
| 0x0e | 0x00 | Scroll effect upper byte |
| 0x0f | 0x00 | Scroll effect lower byte |
| 0x10 | 0x00 | Scroll effect speed |
| 0x11 | 0x64 | Scroll brightness |
| 0x12 | 0x** | Scroll Red3? |
| 0x13 | 0x** | Scroll Green3? |
| 0x14 | 0x** | Scroll Blue3? |
| 0x15 | 0x** | Scroll Red4? |
| 0x16 | 0x** | Scroll Green4? |
| 0x17 | 0x** | Scroll Blue4? |
| 0x18 | 0x00 | Unknown/Nothing? |
| 0x19 | 0x00 | Unknown/Nothing? |
| 0x1a | 0x00 | Unknown/Nothing? |

## Event: Mouse state change
| Byte index | Value | Description |
| ------ | ------ | ------ |
| 0x00 | 0xff | Generic event |
| 0x01 | 0x03 | Unknown |
| 0x02 | 0x** | Enabled profile number (0x00-0x04) |
| 0x03 | 0x** | <ul><li>0x00 = USB cable NOT connected / NOT charging </li><li>0x01 = USB cable connected / Charging </li></ul> |
| 0x04 | 0x** | <ul><li>0x00 = Going to sleep </li><li>0x01 = Wakes from sleep </li></ul> |
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
