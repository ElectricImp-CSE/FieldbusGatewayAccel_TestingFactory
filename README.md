# Fieldbus Gateway Accelerator Testing Factory Code

Factory Test Code for Fieldbus Gateway Accelerator

## Setup

For all tests to pass the following hardware must be plugged into the Fieldbus gateway.  

| Port        | External Hardware            | Instructions         |
| ----------- | ---------------------------- | -------------------- |
| Wiznet Eth  | Rasperry Pi with echo server | Must be plugged in for the 2nd test |
| USB         | USB FTDI232 board            | Must be plugged in for the 3rd test | 
| RS485       | PLC Click                    | Must be plugged in for the 4th test |
| Imp PoE Eth | Ethernet internet connection | Do not plug in until the imp has connected to wifi after BlinkUp. When the LED test starts plug in the ethernet cable. |


## Tests

The factory code runs through the following tests. 

After each test an LED blinks, green if test pass, red if test fails. 

When tests have all run the yellow LED turns on. If all tests have passed the green LED also turns on and a label is printed. If any test failed the red LED turns on and no label is printed.  

### Test 1 LEDs

Each LED is turned on then off.  *Note* The code always marks this test as passing.

1st: Red
2nd: Yellow
3rd: Green 

### Test 2 Wiznet Echo

This test requires an echo server (RasPi) and cat5 a crossover cable. Everything must be connected before the test starts. The test: 

* Opens a connection and receiver
* Sends the test string
* Checks response from RasPi for the test string
* Closes the connection

### Test 3 USB FTDI

This test requires a USB FTDI device (FTDI232). The test works best if the USB device is plugged in before the test starts. The test: 

* Initializes USB host and FTDI driver
* If a device is plugged in the onConnected FTDI callback triggers a test pass

### Test 4 RS485 Modbus

This test requires a PLC Click to be connected via modbus RS485 bus. The test:

* Reads a register
* Writes to that register with new value
* Reads that register again and checks for new value

### Test 5 Ethernet Connection Test

This test requires an ethernet cable that has an internet connection. For the test to pass the imp must connect to wifi when booting up, so the ethernet cable should be plugged in until the LED testing has started. This test:

* Checks that the imp has connected via wifi after BlinkUp
* Deletes wifi credentials, forcing a connection via ethernet
* Checks that the imp has connected via ethernet 
* Resets wifi credentials