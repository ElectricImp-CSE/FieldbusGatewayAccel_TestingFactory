//line 1 "device.nut"
#require "W5500.device.nut:1.0.0"
#require "CRC16.class.nut:1.0.0"
#require "ModbusRTU.class.nut:1.0.0"
#require "ModbusMaster.class.nut:1.0.0"
#require "Modbus485Master.class.nut:1.0.0"
#require "promise.class.nut:3.0.1"
#require "USB.device.lib.nut:0.1.0"

// Factory Tools Lib
#require "FactoryTools.class.nut:2.1.0"
// Factory Fixture Keyboard/Display Lib
#require "CFAx33KL.class.nut:1.1.0"

// Commands
// Commands are of varing lengths, so leave as strings
const QL720NW_CMD_ESCP_ENABLE      = "\x1B\x69\x61\x00";
const QL720NW_CMD_ESCP_INIT        = "\x1B\x40";

const QL720NW_CMD_SET_ORIENTATION  = "\x1B\x69\x4C";
const QL720NW_CMD_SET_TB_MARGINS   = "\x1B\x28\x63\x34\x30";
const QL720NW_CMD_SET_LEFT_MARGIN  = "\x1B\x6C";
const QL720NW_CMD_SET_RIGHT_MARGIN = "\x1B\x51";

const QL720NW_CMD_ITALIC_START     = "\x1B\x34";
const QL720NW_CMD_ITALIC_STOP      = "\x1B\x35";
const QL720NW_CMD_BOLD_START       = "\x1B\x45";
const QL720NW_CMD_BOLD_STOP        = "\x1B\x46";
const QL720NW_CMD_UNDERLINE_START  = "\x1B\x2D\x31";
const QL720NW_CMD_UNDERLINE_STOP   = "\x1B\x2D\x30";

const QL720NW_CMD_SET_FONT_SIZE    = "\x1B\x58\x00";
const QL720NW_CMD_SET_FONT         = "\x1B\x6B";

const QL720NW_CMD_BARCODE          = "\x1B\x69";
const QL720NW_CMD_BARCODE_DATA     = "\x62"

// Orientation Parameters
const QL720NW_LANDSCAPE            = 0x31;
const QL720NW_PORTRAIT             = 0x30;

// Special Characters
const QL720NW_TEXT_NEWLINE         = 0x0A;
const QL720NW_PAGE_FEED            = 0x0C;
const QL720NW_BACKSLASH            = 0x5C;

// Font Parameters
const QL720NW_FONT_BROUGHAM           = 0x00;
const QL720NW_FONT_LETTER_GOTHIC_BOLD = 0x01;
const QL720NW_FONT_BRUSSELS           = 0x02;
const QL720NW_FONT_HELSINKI           = 0x03;
const QL720NW_FONT_SAN_DIEGO          = 0x04;

const QL720NW_ITALIC                  = 0x01;
const QL720NW_BOLD                    = 0x02;
const QL720NW_UNDERLINE               = 0x04;

const QL720NW_FONT_SIZE_24            = 24;
const QL720NW_FONT_SIZE_32            = 32;
const QL720NW_FONT_SIZE_48            = 48;

const QL720NW_DOTS_PER_INCH           = 300;

// Barcode Parameters
// Keep as strings since this correlates with data sheet
const QL720NW_BARCODE_CODE39        = "t0";
const QL720NW_BARCODE_ITF           = "t1";
const QL720NW_BARCODE_EAN_8_13      = "t5";
const QL720NW_BARCODE_UPC_A         = "t5";
const QL720NW_BARCODE_UPC_E         = "t6";
const QL720NW_BARCODE_CODABAR       = "t9";
const QL720NW_BARCODE_CODE128       = "ta";
const QL720NW_BARCODE_GS1_128       = "tb";
const QL720NW_BARCODE_RSS           = "tc";
const QL720NW_BARCODE_CODE93        = "td";
const QL720NW_BARCODE_POSTNET       = "te";
const QL720NW_BARCODE_UPC_EXTENTION = "tf";

const QL720NW_BARCODE_CHARS         = "r1";
const QL720NW_BARCODE_NO_CHARS      = "r0";

const QL720NW_BARCODE_WIDTH_XXS     = "w4";
const QL720NW_BARCODE_WIDTH_XS      = "w0";
const QL720NW_BARCODE_WIDTH_S       = "w1";
const QL720NW_BARCODE_WIDTH_M       = "w2";
const QL720NW_BARCODE_WIDTH_L       = "w3";

const QL720NW_BARCODE_RATIO_3_1     = "z0";
const QL720NW_BARCODE_RATIO_25_1    = "z1";
const QL720NW_BARCODE_RATIO_2_1     = "z2";

const QL720NW_BARCODE_DEFAULT_HEIGHT    = 0.5;
const QL720NW_BARCODE_DEFAULT_CELL_SIZE = 3;
const QL720NW_BARCODE_DEFAULT_SIZE_AUTO = 0;

// 2D Barcode Parameters
const QL720NW_BARCODE_2D_QR             = 0x71;
const QL720NW_BARCODE_2D_DATAMATRIX     = 0x64;

// 2D QR Barcode Parameters
const QL720NW_BARCODE_2D_QR_SYMBOL_MODEL_1    = 0x01;
const QL720NW_BARCODE_2D_QR_SYMBOL_MODEL_2    = 0x02;
const QL720NW_BARCODE_2D_QR_SYMBOL_MICRO_QR   = 0x03;

const QL720NW_BARCODE_2D_QR_STRUCTURE_NOT_PARTITIONED = 0x00;
const QL720NW_BARCODE_2D_QR_STRUCTURE_PARTITIONED     = 0x01;

const QL720NW_BARCODE_2D_QR_ERROR_CORRECTION_HIGH_DENSITY             = 0x01;
const QL720NW_BARCODE_2D_QR_ERROR_CORRECTION_STANDARD                 = 0x02;
const QL720NW_BARCODE_2D_QR_ERROR_CORRECTION_HIGH_RELIABILITY         = 0x03;
const QL720NW_BARCODE_2D_QR_ERROR_CORRECTION_ULTRA_HIGH_RELIABILITY   = 0x04;

const QL720NW_BARCODE_2D_QR_DATA_INPUT_AUTO     = 0x00;
const QL720NW_BARCODE_2D_QR_DATA_INPUT_MANUAL   = 0x01;

const QL720NW_DEFAULT_CODE_NUMBER               = 0x00;
const QL720NW_DEFAULT_NUM_PARTITIONS            = 0x00;
const QL720NW_DEFAULT_PARITY_DATA               = 0x00;

// 2D DataMatrix Barcode Parameters
const QL720NW_BARCODE_2D_DM_SYMBOL_SQUARE       = 0x00;
const QL720NW_BARCODE_2D_DM_SYMBOL_RECTANGLE    = 0x01;

// Store parameter as a string because of length, please note that you can not concat with format()
const QL720NW_BARCODE_2D_DM_RESERVED            = "\x00\x00\x00\x00\x00";

// Error Messages
const ERROR_INVALID_ORIENTATION          = "Invalid Orientation";
const ERROR_UNKNOWN_FONT                 = "Unknown font";
const ERROR_INVALID_FONT_SIZE            = "Invalid font size";
const ERROR_2D_BARCODE_NOT_SUPPORTED     = "2D barcode type not supported";
const ERROR_INVALID_CODE_NUMBER          = "Code number must be between 1-16";
const ERROR_INVALID_NUMBER_OF_PARTITIONS = "Number of partitions must be between 2-16";
const ERROR_INVALID_BARCODE_DATA_TYPE    = "Barcode data must be a string or an integer";


class QL720NW {

    static VERSION = "1.0.0";

    _uart = null;   // A preconfigured UART
    _buffer = null; // buffer for building text

    constructor(uart, init = true) {
        _uart = uart;
        _buffer = blob();

        if (init) initialize();
    }

    function initialize() {
        _uart.write(QL720NW_CMD_ESCP_ENABLE); // Select ESC/P mode
        _uart.write(QL720NW_CMD_ESCP_INIT);   // Initialize ESC/P mode

        return this;
    }

    // Formating commands
    // --------------------------------------------------------------------------
    function setOrientation(orientation) {
        if (orientation == QL720NW_LANDSCAPE || orientation == QL720NW_PORTRAIT) {
            // Write orientation to uart
            _uart.write(format("%s%c", QL720NW_CMD_SET_ORIENTATION, orientation));
        } else {
            throw ERROR_INVALID_ORIENTATION;
        }

        return this;
    }

    function setRightMargin(column) {
        return _setMargin(QL720NW_CMD_SET_RIGHT_MARGIN, column);
    }

    function setLeftMargin(column) {
        return _setMargin(QL720NW_CMD_SET_LEFT_MARGIN, column);;
    }

    function setFont(font) {
        // Current supported fonts number 0 to 4
        if (font < 0 || font > 4) {
            throw ERROR_UNKNOWN_FONT;
        } else {
            _buffer.writestring(format("%s%c", QL720NW_CMD_SET_FONT, font));
        }
        return this;
    }

    function setFontSize(size) {
        if (size != 24 && size != 32 && size != 48) {
            throw ERROR_INVALID_FONT_SIZE;
        } else {
            // Write command, size lower bit, size upper bit
            _buffer.writestring(QL720NW_CMD_SET_FONT_SIZE); // Command has 0x00 char(s), so cannnot use format()
            _buffer.writestring(format("%c%c", size & 0xFF, (size >> 8) & 0xFF));
        }
        return this;
    }

    // Text commands
    // --------------------------------------------------------------------------

    function write(text, options = 0) {
        local beforeText = "";
        local afterText = "";

        if (options & QL720NW_ITALIC) {
            beforeText  += QL720NW_CMD_ITALIC_START;
            afterText   += QL720NW_CMD_ITALIC_STOP;
        }

        if (options & QL720NW_BOLD) {
            beforeText  += QL720NW_CMD_BOLD_START;
            afterText   += QL720NW_CMD_BOLD_STOP;
        }

        if (options & QL720NW_UNDERLINE) {
            beforeText  += QL720NW_CMD_UNDERLINE_START;
            afterText   += QL720NW_CMD_UNDERLINE_STOP;
        }

        _buffer.writestring(format("%s%s%s", beforeText, text, afterText));

        return this;
    }

    function writen(text, options = 0) {
        return write(format("%s%c", text, QL720NW_TEXT_NEWLINE), options);
    }

    function newline() {
        _buffer.writen(QL720NW_TEXT_NEWLINE, 'b');
        return this;
    }

    function pageFeed () {
        _buffer.writen(QL720NW_PAGE_FEED, 'b');
        return this;
    }

    // Barcode commands
    // --------------------------------------------------------------------------

    function writeBarcode(data, config = {}) {
        // Check data 
        if (typeof data == "integer") data = data.tostring();
        if (typeof data != "string") throw ERROR_INVALID_BARCODE_DATA_TYPE;

        // Store barcode type locally
        local type = (!("type" in config)) ? QL720NW_BARCODE_CODE39 : config.type;
        // Write barcode command and parameters to buffer
        _buffer.writestring(QL720NW_CMD_BARCODE);
        _buffer.writestring(type);
        _buffer.writestring((!("charsBelowBarcode" in config) || config.charsBelowBarcode) ? QL720NW_BARCODE_CHARS : QL720NW_BARCODE_NO_CHARS);
        _buffer.writestring((!("width" in config)) ? QL720NW_BARCODE_WIDTH_XS : config.width); 
        _buffer.writestring((!("height" in config)) ? _getBarcodeHeightCmd(QL720NW_BARCODE_DEFAULT_HEIGHT) : _getBarcodeHeightCmd(config.height));
        _buffer.writestring((!("ratio" in config)) ? QL720NW_BARCODE_RATIO_2_1 : config.ratio);

        // Write data & ending command to buffer
        local endBarcode = (type == QL720NW_BARCODE_CODE128 || type == QL720NW_BARCODE_GS1_128 || type == QL720NW_BARCODE_CODE93) ? format("%c%c%c", QL720NW_BACKSLASH, QL720NW_BACKSLASH, QL720NW_BACKSLASH) : QL720NW_BACKSLASH.tochar();
        _buffer.writestring(format("%s%s%s", QL720NW_CMD_BARCODE_DATA, data, endBarcode));

        return this;
    }

    function write2dBarcode(data, type, config = {}) {
        // Check data 
        if (typeof data == "integer") data = data.tostring();
        if (typeof data != "string") throw ERROR_INVALID_BARCODE_DATA_TYPE;

        // Note for 2d barcodes the order of the paramters matters
        local cell_size = (!("cell_size" in config)) ? QL720NW_BARCODE_DEFAULT_CELL_SIZE : config.cell_size;
        // Organize and check parameters for errors before writing to print buffer 
        local paramsBuffer = blob();
        // Set barcode command and parameters
        paramsBuffer.writestring(QL720NW_CMD_BARCODE);
        switch (type) {
            case QL720NW_BARCODE_2D_QR :
                paramsBuffer.writen(QL720NW_BARCODE_2D_QR, 'b');
                paramsBuffer.writen(cell_size, 'b');
                _setQRParams(config, paramsBuffer);
                break;
            case QL720NW_BARCODE_2D_DATAMATRIX : 
                paramsBuffer.writen(QL720NW_BARCODE_2D_DATAMATRIX, 'b');
                paramsBuffer.writen(cell_size, 'b');
                _setDMParams(config, paramsBuffer);
                break;
            default : 
                throw ERROR_2D_BARCODE_NOT_SUPPORTED;
        }

        // Write the barcode parameters to buffer
        _buffer.writeblob(paramsBuffer);
        // Write the barcode to buffer
        _buffer.writestring(format("%s%c%c%c", data, QL720NW_BACKSLASH, QL720NW_BACKSLASH, QL720NW_BACKSLASH));

        return this;
    }

    // Prints Command
    // --------------------------------------------------------------------------

    function print() {
        _buffer.writen(QL720NW_PAGE_FEED, 'b');
        _uart.write(_buffer);
        // Clear buffer
        _buffer = blob();
    }

    // Private Functions
    // ------------------------------------------------------------------------------------------------------

    function _setDMParams(config, paramsBuffer) {
        // Note for 2d barcodes the order of the paramters matters

        local sType = QL720NW_BARCODE_2D_DM_SYMBOL_SQUARE;
        if ("symbol_type" in config && config.symbol_type == QL720NW_BARCODE_2D_DM_SYMBOL_RECTANGLE) sType = QL720NW_BARCODE_2D_DM_SYMBOL_RECTANGLE;

        local vSize = QL720NW_BARCODE_DEFAULT_SIZE_AUTO;
        if ("vertical_size" in config) vSize = config.vertical_size;

        local hSize = QL720NW_BARCODE_DEFAULT_SIZE_AUTO;
        if (sType == QL720NW_BARCODE_2D_DM_SYMBOL_SQUARE) {
            hSize = vSize;
        } else if ("horizontal_size" in config) {
            hSize = config.horizontal_size;
        }

        // Write Data Matrix parameters to buffer
        paramsBuffer.writen(sType, 'b');
        paramsBuffer.writen(vSize, 'b');
        paramsBuffer.writen(hSize, 'b');
        paramsBuffer.writestring(QL720NW_BARCODE_2D_DM_RESERVED);
    }

    function _setQRParams(config, paramsBuffer) {
        // Note for 2d barcodes the order of the paramters matters

        // Write QR parameters to buffer
        paramsBuffer.writen((!("symbol_type" in config)) ? QL720NW_BARCODE_2D_QR_SYMBOL_MODEL_2 : config.symbol_type, 'b');
        
        // Configure structure append partitioned or not partitioned paramters
        if (!("structured_append_partitioned" in config) || !config.structured_append_partitioned) { 
            paramsBuffer.writen(QL720NW_BARCODE_2D_QR_STRUCTURE_NOT_PARTITIONED, 'b');
            paramsBuffer.writen(QL720NW_DEFAULT_CODE_NUMBER, 'b');
            paramsBuffer.writen(QL720NW_DEFAULT_NUM_PARTITIONS, 'b');
            paramsBuffer.writen(QL720NW_DEFAULT_PARITY_DATA, 'b');
        } else {
            paramsBuffer.writen(QL720NW_BARCODE_2D_QR_STRUCTURE_PARTITIONED, 'b');
            if (!("code_number" in config) || config.code_number < 1 || config.code_number > 16) { 
                throw ERROR_INVALID_CODE_NUMBER; 
            } else {
                paramsBuffer.writen(config.code_number, 'b');
            }
            if (!("num_partitions" in config) || config.num_partitions < 2 || config.num_partitions > 16) { 
                throw ERROR_INVALID_NUMBER_OF_PARTITIONS; 
            } else {
                paramsBuffer.writen(config.num_partitions, 'b');
            }
            if (!("parity_data" in config)) { 
                paramsBuffer.writen(QL720NW_DEFAULT_PARITY_DATA, 'b');
            } else {
                paramsBuffer.writen(config.parity_data, 'b');
            }
        }

        // Write QR parameters to buffer
        paramsBuffer.writen((!("error_correction" in config)) ? QL720NW_BARCODE_2D_QR_ERROR_CORRECTION_STANDARD : config.error_correction, 'b');
        paramsBuffer.writen((!("data_input_method" in config)) ? QL720NW_BARCODE_2D_QR_DATA_INPUT_AUTO : config.data_input_method, 'b');
    }

    function _getBarcodeHeightCmd(height) {
        // set to defualt height if non-numeric height was passed in
        if (typeof height != "integer" && typeof height != "float") height = QL720NW_BARCODE_DEFAULT_HEIGHT; 
        // Convert height (in inches) to dots
        height = (height * QL720NW_DOTS_PER_INCH).tointeger();
        // Height marker command "h", height lower bit, height upper bit
        return format("h%c%c", height & 0xFF, (height >> 8) & 0xFF);
    }

    function _setMargin(command, margin) {
        _uart.write(format("%s%c", command, margin & 0xFF));
        return this;
    }

    function _typeof() {
        return "QL720NW";
    }
}

// USB FTDI Driver
class FtdiUsbDriver extends USB.DriverBase {

    // FTDI vid and pid
    static VID = 0x0403;
    static PID = 0x6001;

    // FTDI driver
    static FTDI_REQUEST_FTDI_OUT = 0x40;
    static FTDI_SIO_SET_BAUD_RATE = 3;
    static FTDI_SIO_SET_FLOW_CTRL = 2;
    static FTDI_SIO_DISABLE_FLOW_CTRL = 0;

    _deviceAddress = null;
    _bulkIn = null;
    _bulkOut = null;


    // 
    // Metafunction to return class name when typeof <instance> is run
    // 
    function _typeof() {
        return "FtdiUsbDriver";
    }


    // 
    // Returns an array of VID PID combination tables.
    // 
    // @return {Array of Tables} Array of VID PID Tables
    // 
    function getIdentifiers() {
        local identifiers = {};
        identifiers[VID] <-[PID];
        return [identifiers];
    }


    // 
    // Write string or blob to usb
    // 
    // @param  {String/Blob} data data to be sent via usb
    // 
    function write(data) {
        local _data = null;

        // Convert strings to blobs
        if (typeof data == "string") {
            _data = blob();
            _data.writestring(data);
        } else if (typeof data == "blob") {
            _data = data;
        } else {
            throw "Write data must of type string or blob";
            return;
        }

        // Write data via bulk transfer
        _bulkOut.write(_data);
    }
    

    // 
    // Handle a transfer complete event
    // 
    // @param  {Table} eventdetails Table with the transfer event details
    // 
    function _transferComplete(eventdetails) {
        local direction = (eventdetails["endpoint"] & 0x80) >> 7;
        if (direction == USB_DIRECTION_IN) {
            local readData = _bulkIn.done(eventdetails);
            if (readData.len() >= 3) {
                readData.seek(2);
                _onEvent("data", readData.readblob(readData.len()));
            }
            // Blank the buffer
            _bulkIn.read(blob(64 + 2));
        } else if (direction == USB_DIRECTION_OUT) {
            _bulkOut.done(eventdetails);
        }
    }


    // 
    // Initialize the buffer.
    // 
    function _start() {
        _bulkIn.read(blob(64 + 2));
    }
}


class AcceleratorTestingFactory {

    constructor(ssid, password) {

        FactoryTools.isFactoryFirmware(function(isFactoryEnv) {
            if (isFactoryEnv) {
                FactoryTools.isFactoryImp() ? RunFactoryFixture(ssid, password) : RunDeviceUnderTest(ssid, password);
            } else {
              server.log("This firmware is not running in the Factory Environment");
            }
        }.bindenv(this))
    }


    RunFactoryFixture = class {

        static FIXTURE_BANNER = "FB GWY Tests";

        // How long to wait (seconds) after triggering BlinkUp before allowing another
        static BLINKUP_TIME = 5;

        // Flag used to prevent new BlinkUp triggers while BlinkUp is running
        sendingBlinkUp = false;

        impFactory_005 = null;
        lcd = null;
        printer = null;

        _ssid = null;
        _password = null;

        constructor(ssid, password) {
            imp.enableblinkup(true);
            _ssid = ssid;
            _password = password;

            // impFactory_005 Factory Fixture HAL
            impFactory_005 = {
                "LED_RED"          : hardware.pinF,
                "LED_GREEN"        : hardware.pinE,
                "BLINKUP_PIN"      : hardware.pinM,
                "GREEN_BTN"        : hardware.pinC,
                "FOOTSWITCH"       : hardware.pinH,
                "LCD_DISPLAY_UART" : hardware.uart2,
                "USB_PWR_EN"       : hardware.pinR,
                "USB_LOAD_FLAG"    : hardware.pinW,
                "RS232_UART"       : hardware.uart0,
                "FTDI_UART"        : hardware.uart1,
            }

            // Initialize front panel LEDs to Off
            impFactory_005.LED_RED.configure(DIGITAL_OUT, 0);
            impFactory_005.LED_GREEN.configure(DIGITAL_OUT, 0);

            // Intiate factory BlinkUp on either a front-panel button press or footswitch press
            configureBlinkUpTrigger(impFactory_005.GREEN_BTN);
            configureBlinkUpTrigger(impFactory_005.FOOTSWITCH);

            lcd = CFAx33KL(impFactory_005.LCD_DISPLAY_UART);
            setDefaultDisply();
            configurePrinter();

            // Open agent listener
            agent.on("data.to.print", printLabel.bindenv(this));
        }

        function configureBlinkUpTrigger(pin) {
            // Register a state-change callback for BlinkUp Trigger Pins
            pin.configure(DIGITAL_IN, function() {
                // Trigger only on rising edges, when BlinkUp is not already running
                if (pin.read() && !sendingBlinkUp) {
                    sendingBlinkUp = true;
                    imp.wakeup(BLINKUP_TIME, function() {
                        sendingBlinkUp = false;
                    }.bindenv(this));

                    // Send factory BlinkUp
                    server.factoryblinkup(_ssid, _password, impFactory_005.BLINKUP_PIN, BLINKUP_FAST | BLINKUP_ACTIVEHIGH);
                }
            }.bindenv(this));
        }

        function setDefaultDisply() {
            lcd.clearAll();
            lcd.setLine1("Electric Imp");
            lcd.setLine2(FIXTURE_BANNER);
            lcd.setBrightness(100);
            lcd.storeCurrentStateAsBootState();
        }

        function configurePrinter() {
            impFactory_005.RS232_UART.configure(9600, 8, PARITY_NONE, 1, NO_CTSRTS, function() {
                server.log(uart.readstring());
            });

            printer = QL720NW(impFactory_005.RS232_UART).setOrientation(QL720NW_PORTRAIT);
        }

        function configurePinterFontSettings() {
                printer.setFont(QL720NW_FONT_HELSINKI)
                       .setFontSize(QL720NW_FONT_SIZE_48);
        }

        function printLabel(data) {
            // confugure printer if it is not instantiated
            if (printer == null) configurePrinter();

            if ("mac" in data) {
                // Set label font settings
                configurePinterFontSettings();
                // Add 2D barcode of mac address to label
                printer.write2dBarcode(data.mac, QL720NW_BARCODE_2D_QR, {"cell_size": 5 });
                // Add mac address to label
                printer.write(data.mac);
                // Print label
                printer.print();
                // Log status
                server.log("Printed: " + data.mac);
            }
        }
    }

    RunDeviceUnderTest = class {

        static LED_FEEDBACK_AFTER_TEST = 1;
        static PAUSE_BTWN_TESTS = 0.5;

        test = null;
        
        constructor(ssid, password) {
            test = AcceleratorTestingFactory.RunDeviceUnderTest.FieldbusGatewayTesting(LED_FEEDBACK_AFTER_TEST, PAUSE_BTWN_TESTS, ssid, password, testsDone.bindenv(this));
            test.run();
        }

        function testsDone(passed) {
            // Only print label for passing hardware
            if (passed) {
                local deviceData = {};
                deviceData.mac <- imp.getmacaddress();
                deviceData.id <- hardware.getdeviceid();
                server.log("Sending Label Data: " + deviceData.mac);
                agent.send("set.label.data", deviceData);
            }

            // Clear wifi credentials on power cycle
            imp.clearconfiguration();
        }

        AcceleratorTestSuite = class {

            // NOTE: LED test are not included in this class
            
            // Requires an echo server (RasPi)
            // Test opens a connection and receiver
            // Sends the test string
            // Checks resp for test string
            // Closes the connection
            function wiznetEchoTest(wiz) {
                server.log("Wiznet test.");
                local wiznetTestStr = "SOMETHING";

                return Promise(function(resolve, reject) {
                    wiz.onReady(function() {
                        // Connection settings
                        local destIP   = "192.168.201.3";
                        local destPort = 4242;
                        local sourceIP = "192.168.201.2";
                        local subnet_mask = "255.255.255.0";
                        local gatewayIP = "192.168.201.1";
                        wiz.configureNetworkSettings(sourceIP, subnet_mask, gatewayIP);

                        server.log("Attemping to connect via LAN...");
                        // Start Timer
                        local started = hardware.millis();
                        wiz.openConnection(destIP, destPort, function(err, connection) {
                            // 
                            local dur = hardware.millis() - started;

                            if (err) {
                                local errMsg = format("Connection failed to %s:%d in %d ms: %s", destIP, destPort, dur, err.tostring());
                                if (connection) {
                                    connection.close(function() {
                                        return reject(errMsg);
                                    });
                                } else {
                                    return reject(errMsg);
                                }
                            } else {
                                // Create event handlers for this connection
                                connection.onReceive(function(err, resp) {
                                    connection.close(function() {
                                        server.log("Connection closed. Ok to disconnect cable.")
                                    });
                                    local respStr = "";
                                    resp.seek(0, 'b');
                                    respStr = resp.readstring(9);

                                    local index = respStr.find(wiznetTestStr); 
                                    return (index != null) ? resolve("Received expected response") : reject("Expected response not found");
                                }.bindenv(this));
                                connection.transmit(wiznetTestStr, function(err) {
                                    if (err) {
                                        return reject("Send failed: " + err);
                                    } else {
                                        server.log("Send successful");
                                    }
                                }.bindenv(this))
                            }
                        }.bindenv(this))
                    }.bindenv(this));   
                }.bindenv(this))
            }

            // Requires a PLC Click 
            // Reads a register
            // Writes that register with new value
            // Reads that register and checks for new value
            function RS485ModbusTest(modbus, devAddr) {
                server.log("RS485 test.");
                return Promise(function(resolve, reject) {
                    local registerAddr = 4;
                    local expected = null;
                    modbus.read(devAddr, MODBUSRTU_TARGET_TYPE.HOLDING_REGISTER, registerAddr, 1, function(err, res) {
                        if (err) return reject("Modbus read error: " + err);
                        expected = (typeof res == "array") ? res[0] : res;
                        // adjust the value
                        (expected > 100) ? expected -- : expected ++;
                        modbus.write(devAddr, MODBUSRTU_TARGET_TYPE.HOLDING_REGISTER, registerAddr, 1, expected, function(e, r) {
                            if (e) return reject("Modbus write error: " + e);
                            modbus.read(devAddr, MODBUSRTU_TARGET_TYPE.HOLDING_REGISTER, registerAddr, 1, function(error, resp) {
                                if (error) return reject("Modbus read error: " + error);
                                if (typeof resp == "array") resp = resp[0];
                                return (resp == expected) ? resolve("RS485 test passed.") : reject("RS485 test failed.");
                            }.bindenv(this))
                        }.bindenv(this))
                    }.bindenv(this))
                }.bindenv(this))
            }

            // Requires special cable to loop pin 1 on both groves together and pin 2 on both groves together
            function analogGroveTest(in1, in2, out1, out2) {
                server.log("Analog Grove Connectors test.");
                return Promise(function(resolve, reject) {
                    local ones = 1;
                    local twos = 0;
                    out1.write(ones);
                    out2.write(twos);
                    return (in1.read() == ones && in2.read() == twos) ? resolve("Analog grove test passed.") : reject("Analog grove test failed.");
                }.bindenv(this))
            }

            function ADCTest(adc, chan, expected, range) {
                server.log("ADC test.");
                return Promise(function(resolve, reject) {
                    local lower = expected - range;
                    local upper = expected + range;
                    local reading = adc.readADC(chan);
                    return (reading > lower && reading < upper) ? resolve("ADC readings on chan " + chan + " in range.") : reject("ADC readings not in range. Chan : " + chan + " Reading: " + reading);
                }.bindenv(this))
            }

            // Scan doesn't work on an imp005
            function scanI2CTest(i2c, addr) {
                // note scan doesn't currently work on an imp005
                server.log("i2c bus scan.");
                local count = 0;
                return Promise(function(resolve, reject) {  
                    for (local i = 2 ; i < 256 ; i+=2) {
                        local val = i2c.read(i, "", 1);
                        if (val != null) {
                            count ++;
                            server.log(val);
                            server.log(format("Device at address: 0x%02X", i));
                            if (i == addr) {
                                if (count == 1) {
                                    return resolve(format("Found I2C sensor at address: 0x%02X", i));
                                } else {
                                    return resolve(format("Found I2C sensor at address: 0x%02X and %i sensors", i, count));
                                }
                            }
                        }
                    }
                    return reject(format("I2C scan did not find sensor at address: 0x%02X", addr));
                }.bindenv(this));
            }

            function ic2test(i2c, addr, reg, expected) {
                server.log("i2c read register test.");
                return Promise(function(resolve, reject) {
                    local result = i2c.read(addr, reg.tochar(), 1);
                    if (result == null) reject("i2c read error: " + i2c.readerror());
                    return (result == expected.tochar()) ? resolve("I2C read returned expected value.") : reject("I2C read returned " + result);
                }.bindenv(this))
            }

            // Requires a USB FTDI device
            // Initializes USB host and FTDI driver
            // Looks for an onConnected FTDI device
            function usbFTDITest() {
                server.log("USB test.");
                return Promise(function(resolve, reject) {
                    // Setup usb
                    local usbHost = USB.Host(hardware.usb);
                    usbHost.registerDriver(FtdiUsbDriver, FtdiUsbDriver.getIdentifiers());
                    local timeout = imp.wakeup(5, function() {
                        return reject("FTDI USB Driver not found. USB test failed.");
                    }.bindenv(this))
                    usbHost.on("connected", function(device) {
                        imp.cancelwakeup(timeout);
                        if (typeof device == "FtdiUsbDriver") {
                            return resolve("FTDI USB Driver found. USB test passed.");
                        } else {
                            return reject("FTDI USB Driver not found. USB test failed.");
                        }
                    }.bindenv(this));
                }.bindenv(this))
            }

            // Checks that wifi connection has been tested, then
            // Clears wifi credential to force a connection to ethernet
            function ethernetConnectionTest(bootConnection) {
                server.log("Ethernet connection test.");
                return Promise(function(resolve, reject) {
                    if (bootConnection == "wifi") {
                        // Clear wifi configuration settings to force a connection to ethernet
                        imp.setwificonfiguration("", "");
                        imp.wakeup(1, function() {
                            return (getConnectionType() == "ethernet") ? resolve("Connected via ethernet.") : reject("Connection to ethernet failed.");
                        }.bindenv(this));
                    } else {
                        return reject("Wifi connection not tested");
                    }
                }.bindenv(this))
            }

            // NETWORK TESTING HELPER
            // -----------------------------------------------------------------------------
            // Not this is not a test, and so does not return a promise!!!
            function getConnectionType() {
                local networkInfo = imp.net.info();
                if ("active" in networkInfo) {
                    return networkInfo.interface[networkInfo.active].type;
                }
                return null;
            }
        }

        FieldbusGatewayTesting = class {

            // NOTE: LED tests are included in this class not the tests class, 
            //       because they are specific to the hardware being tested

            static LED_ON = 0;
            static LED_OFF = 1;

            feedbackTimer = null;
            pauseTimer = null;
            done = null;

            accelerator = null;
            tests = null;       
            wiz = null;
            modbus = null;
            connectionTypeOnBoot = null;

            passLED = null;
            failLED = null;
            testsCompleteLED = null;
            
            _ssid = null;
            _password = null;

            failedCount = 0;

            constructor(_feedbackTimer, _pauseTimer, ssid, password, _done) {
                _ssid = ssid;
                _password = password;
                
                // Time in seconds LED is on after a test
                feedbackTimer = _feedbackTimer;
                // Time in secondes between tests
                pauseTimer = _pauseTimer;
                // Callback that is run when all tests have run
                done = _done;

                // Set pointer to Test Class
                tests = AcceleratorTestingFactory.RunDeviceUnderTest.AcceleratorTestSuite;
                connectionTypeOnBoot = tests.getConnectionType();

                // Fieldbus Accelerator HAL here 
                accelerator = { "LED_RED" : hardware.pinP,
                                "LED_GREEN" : hardware.pinT,
                                "LED_YELLOW" : hardware.pinQ,

                                "MIKROBUS_AN" : hardware.pinM,
                                "MIKROBUS_RESET" : hardware.pinH,
                                "MIKROBUS_SPI" : hardware.spiBCAD,
                                "MIKROBUS_CS" : hardware.pinD,
                                "MIKROBUS_PWM" : hardware.pinU,
                                "MIKROBUS_INT" : hardware.pinXD,
                                "MIKROBUS_UART" : hardware.uart1,
                                "MIKROBUS_I2C" : hardware.i2cJK,

                                "XBEE_RESET" : hardware.pinH,
                                "XBEE_AND_RS232_UART": hardware.uart0,
                                "XBEE_DTR_SLEEP" : hardware.pinXD,

                                "RS485_UART" : hardware.uart2,
                                "RS485_nRE" : hardware.pinL,

                                "WIZNET_SPI" : hardware.spi0,
                                "WIZNET_RESET" : hardware.pinXA,
                                "WIZNET_INT" : hardware.pinXC,

                                "USB_EN" : hardware.pinR,
                                "USB_LOAD_FLAG" : hardware.pinW }

                // Configure Hardware
                configureLEDs();
                configureWiznet();
                configureModbusRS485();
            }

            // This method runs all tests
            // When testing complete should call done with one param - allTestsPassed (bool)
            function run() {
                pause()
                    .then(function(msg) {
                        server.log(msg);
                        return ledTest();
                    }.bindenv(this))
                    .then(passed.bindenv(this), failed.bindenv(this))
                    .then(function(msg) {
                        server.log(msg);
                        return tests.wiznetEchoTest(wiz);
                    }.bindenv(this))
                    .then(passed.bindenv(this), failed.bindenv(this))
                    .then(function(msg) {
                        server.log(msg);
                        return tests.usbFTDITest();
                    }.bindenv(this))
                    .then(passed.bindenv(this), failed.bindenv(this))
                    .then(function(msg) {   
                        server.log(msg);
                        local deviceAddr = 0x01;
                        return tests.RS485ModbusTest(modbus, deviceAddr);
                    }.bindenv(this))
                    .then(passed.bindenv(this), failed.bindenv(this))
                    .then(function(msg) {
                        server.log(msg);  
                        // Run test
                        local result = tests.ethernetConnectionTest(connectionTypeOnBoot);
                        // Reset wifi credentials
                        imp.setwificonfiguration(_ssid, _password);
                        server.connect();
                        return result;  
                    }.bindenv(this))
                    .then(passed.bindenv(this), failed.bindenv(this))                               
                    .then(function(msg) {
                        local passing = (failedCount == 0);
                        (passing) ? passLED.write(LED_ON) : failLED.write(LED_ON);
                        testsCompleteLED.write(LED_ON);
                        done(passing); 
                    }.bindenv(this))
            }

            // HARDWARE CONFIGURATION HELPERS
            // -----------------------------------------------------------------------------
            function configureLEDs() {
                accelerator.LED_RED.configure(DIGITAL_OUT, LED_OFF);
                accelerator.LED_GREEN.configure(DIGITAL_OUT, LED_OFF);
                accelerator.LED_YELLOW.configure(DIGITAL_OUT, LED_OFF);

                passLED = accelerator.LED_GREEN;
                failLED = accelerator.LED_RED;
                testsCompleteLED = accelerator.LED_YELLOW;
            }

            function configureWiznet() {
                local speed = 1000;
                local spi = accelerator.WIZNET_SPI;
                spi.configure(CLOCK_IDLE_LOW | MSB_FIRST | USE_CS_L, speed);
                wiz = W5500(accelerator.WIZNET_INT, spi, null, accelerator.WIZNET_RESET);
            }

            function configureModbusRS485() {
                local opts = {};
                opts.baudRate <- 38400;
                opts.parity <- PARITY_ODD;
                modbus = Modbus485Master(accelerator.RS485_UART, accelerator.RS485_nRE, opts);
            }

            // TESTING HELPERS
            // -----------------------------------------------------------------------------

            // Used to space out tests
            function pause(double = false) {
                local pauseTime = (double) ? pauseTimer * 2 : pauseTimer;
                return Promise(function(resolve, reject) {
                    imp.wakeup(pauseTime, function() {
                        return resolve("Start...");
                    });
                }.bindenv(this))
            }

            function passed(msg) {
                server.log(msg);
                return Promise(function (resolve, reject) {
                    passLED.write(LED_ON);
                    imp.wakeup(feedbackTimer, function() {
                        passLED.write(LED_OFF);
                        imp.wakeup(pauseTimer, function() {
                            return resolve("Start...");
                        });
                    }.bindenv(this));
                }.bindenv(this))
            }

            function failed(errMsg) {
                server.error(errMsg);   
                return Promise(function (resolve, reject) {
                    failLED.write(LED_ON);
                    failedCount ++;
                    imp.wakeup(feedbackTimer, function() {
                        failLED.write(LED_OFF);
                        imp.wakeup(pauseTimer, function() {
                            return resolve("Start...");
                        });
                    }.bindenv(this));
                }.bindenv(this))
            }

            function ledTest() {
                server.log("Testing LEDs.");
                // turn LEDs on one at a time
                // then pass a passing test result  
                return Promise(function (resolve, reject) {
                    failLED.write(LED_ON);
                    imp.wakeup(feedbackTimer, function() {
                        failLED.write(LED_OFF);
                        imp.wakeup(pauseTimer, function() {
                            testsCompleteLED.write(LED_ON);
                            imp.wakeup(feedbackTimer, function() {
                                testsCompleteLED.write(LED_OFF);
                                imp.wakeup(pauseTimer, function() {
                                    passLED.write(LED_ON);
                                    imp.wakeup(feedbackTimer, function() {
                                        passLED.write(LED_OFF);
                                        return resolve("LEDs Testing Done.");
                                    }.bindenv(this))
                                }.bindenv(this))
                            }.bindenv(this))
                        }.bindenv(this))
                    }.bindenv(this))
                }.bindenv(this))
            }
        }

    }
}

// // Factory Code
// // ------------------------------------------
server.log("Device Running...");

const SSID = "";
const PASSWORD = "";

AcceleratorTestingFactory(SSID, PASSWORD);