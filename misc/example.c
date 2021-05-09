#include <stdio.h>
#include <stdlib.h>
#include <hidapi/hidapi.h>

int main(int argc, char const *argv[])
{
	int result;
	unsigned char buf[64]; // 64 bytes data size (report count)
	struct hid_device_info *devs, *dev;
	hid_device *handle = NULL;
	int red = 255;
	int green = 255;
	int blue = 255;

	result = hid_init();
	if (result != 0)
	{
		printf("Init failed! Return value: %i\n", result);
		return 1;
	}

	devs = hid_enumerate(0x0951, 0x16e1); // HyperX Pulsefire Dart Wireless Dongle

	if (devs == NULL)
	{
		devs = hid_enumerate(0x0951, 0x16e2); // HyperX Pulsefire Dart Wired Connection

		if (devs == NULL)
		{
			printf("Device not found!\n");
			return 1;
		}
	}

	dev = devs;

	printf("Enumerating devices...\n\n");

	while (dev)
	{
		printf("Path:           : %s\n", dev->path);
		printf("- Manufacturer  : %ls\n", dev->manufacturer_string);
		printf("- Product       : %ls\n", dev->product_string);
		printf("- Serial number : %ls\n", dev->serial_number);
		printf("- Release number: %hu\n", dev->release_number);
		printf("- Usage Page    : %#04x\n", dev->usage_page);
		printf("- Usage         : %#04x\n", dev->usage);
		printf("- Interface     : %i\n", dev->interface_number);
		printf("\n");

		/*
			Pulsefire Dart Wireless Dongle  - Usage page 0xff00 and interface 2
			Pulsefire Dart Wired Connection - Usage page 0xff13 and interface 1
		*/
		if ((dev->usage_page == 0xff00 && dev->interface_number == 2) ||
			(dev->usage_page == 0xff13 && dev->interface_number == 1) && dev->usage == 0x01 )
		{
			printf("Correct device and interface found!\n");
			handle = hid_open_path(dev->path);
			break;
		}

		dev = dev->next;
	}

	if(handle == NULL)
	{
		printf("Correct device and interface could not be found. Check usage page and interface number!\n");
		return 1;
	}

	// Free up some memory
	hid_free_enumeration(devs);

	// Get RGB color from arguments
	if (argc == 4)
	{
		red = atoi(argv[1]);
		green = atoi(argv[2]);
		blue = atoi(argv[3]);

		// Validate input so we don't accidentally brick the mouse.
		if (red < 0 || red > 255 || green < 0 || green > 255 || blue < 0 || blue > 255)
		{
			printf("Invalid color value(s)!\n");
			return 1;
		}
	}

	printf("Setting mouse LED color...\nRED: %i\nGREEN: %i\nBLUE: %i\n\n", red, green, blue);

	// Prefill buffer with zeroes
	for(int i = 0; i < sizeof(buf); i++) buf[i] = 0x00;

	// Example RGB LED change data
	buf[0x00] = 0xd2;  // Set LED properties
	buf[0x01] = 0x20;  // LED number. 0x00 = Scroll wheel, 0x10 = Logo, 0x20 = Both
	buf[0x02] = 0x00;  // Effect mode. 0x00 = Static, 0x10 = Spectrum test, 0x12 = Spectrum, 0x20 = Breathing, 0x30 = Trigger Fade
	buf[0x03] = 0x08;  // 8 bytes following this position
	buf[0x04] = red;   // RED
	buf[0x05] = green; // GREEN
	buf[0x06] = blue;  // BLUE
	buf[0x07] = red;   // RED
	buf[0x08] = green; // GREEN
	buf[0x09] = blue;  // BLUE
	buf[0x0a] = 0x64;  // Brightness. Min: 0x00, Max: 0x64
	buf[0x0b] = 0x00;  // Effect speed. 0x00 for Solid mode

	printf("Writing the following buffer:\n\n");

	int buf_print_size = 12; // Only the first 12 bytes are interesting
	for (int i = 0; i < buf_print_size; i++)
		printf("buf[%#04x] = %#04x;\n", i, buf[i]);

	printf("\n");

	// Write the data to the mouse
	result = hid_write(handle, buf, sizeof(buf));
	if (result != -1)
	{
		printf("Write successful!\n");
		hid_close(handle);
		result = hid_exit();
		return 0;
	}
	else
	{
		printf("Write failed! Return value: %i\n", result);
		hid_close(handle);
		result = hid_exit();
		return 1;
	}
}