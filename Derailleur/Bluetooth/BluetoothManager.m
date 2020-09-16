//
//	Derailleur
//	Copyright (c) 2020 Ben Smith
//
//	Permission is hereby granted, free of charge, to any person obtaining a copy
//	of this software and associated documentation files (the "Software"), to deal
//	in the Software without restriction, including without limitation the rights
//	to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//	copies of the Software, and to permit persons to whom the Software is
//	furnished to do so, subject to the following conditions:
//
//	The above copyright notice and this permission notice shall be included in all
//	copies or substantial portions of the Software.
//
//	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//	OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//	SOFTWARE.
//

#import "BluetoothManager.h"
#import "BikeData.h"
#import "TrackPoint.h"
#import "NSData+HexRepresentation.h"
#import "NSString+Extensions.h"

@implementation BluetoothManager
{
    /* CoreBluetooth properties */
    CBCentralManager *_centralManager;
    CBPeripheral *_connectedPeripheral;
    CBCharacteristic *_currentCharacteristic;
    
    /* Connection timer */
    NSTimer *_pollTimer;
}

/* General properties */
int dataPacketLength;
int dataPacketIndex;
DecoderErrorState errorState;
DecoderRXState rxState;
BikeDataframe bikeData;

- (instancetype) init
{
    self = [super init];
    if (self) {
        _centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
    }
    return self;
}

- (void)centralManagerDidUpdateState:(nonnull CBCentralManager *)central
{
    switch (central.state) {
        case CBManagerStateUnsupported:
            [_delegate didUpdateStatus:BLUETOOTH_UNSUPPORTED];
            break;
            
        case CBManagerStateUnauthorized:
            [_delegate didUpdateStatus:BLUETOOTH_UNAUTHORISED];
            break;
            
        case CBManagerStatePoweredOff:
            [_delegate didUpdateStatus:BLUETOOTH_POWERED_OFF];
            break;
            
        case CBManagerStatePoweredOn:
            [self startConnectAttempt];
            break;
            
        default:
            break;
    }
}

/* Start to try to connect to Flywheel bikes. Times out after 60 seconds. */
- (void)startConnectAttempt
{
    [_delegate didUpdateStatus:BLUETOOTH_POWERED_ON_SCANNING];
    [_centralManager scanForPeripheralsWithServices:nil options:nil];
    
    _pollTimer = [NSTimer scheduledTimerWithTimeInterval:SCAN_TIMEOUT target:self selector:@selector(didTimeoutWhileScanning) userInfo:nil repeats:NO];
}

/* Disconnect from the Flywheel bike, if it is connected */
- (void)disconnectBike
{
    if (_connectedPeripheral != nil)
    {
        [_delegate didUpdateStatus:BIKE_DISCONNECT_REQUEST];
        [_centralManager cancelPeripheralConnection:_connectedPeripheral];
        _connectedPeripheral = nil;
    }
}

/* Called if and when the Bluetooth scan does not find a Flywheel bike */
- (void)didTimeoutWhileScanning
{
    [_delegate didUpdateStatus:BIKE_UNABLE_TO_DISCOVER];
    [_pollTimer invalidate];
    
    [_centralManager stopScan];
}

- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary<NSString *,id> *)advertisementData RSSI:(NSNumber *)RSSI
{
    NSString *deviceName;
    if (peripheral.name != NULL) {
        deviceName = peripheral.name;
    } else {
        deviceName = [advertisementData objectForKey:CBAdvertisementDataLocalNameKey];
    }
    
    if ([[deviceName lowercaseString] containsString:@"flywheel"]) {
        [_pollTimer invalidate];
        [_centralManager stopScan];
        
        _connectedPeripheral = peripheral;
        _connectedPeripheral.delegate = self;
        
        [_centralManager connectPeripheral:_connectedPeripheral options:nil];
        _pollTimer = [NSTimer scheduledTimerWithTimeInterval:CONNECT_TIMEOUT target:self selector:@selector(didTimeoutWhileConnecting) userInfo:nil repeats:NO];
        
        [_delegate didUpdateStatus:BIKE_DISCOVERED];
    } else {
        /* Let's log this so we can see what devices were found other than Flywheel bikes... */
        
    }
}

- (void)didTimeoutWhileConnecting
{
    [_delegate didUpdateStatus:BIKE_UNABLE_TO_CONNECT];
    [_pollTimer invalidate];
    
    [_centralManager cancelPeripheralConnection:_connectedPeripheral];
}

- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    if (peripheral == _connectedPeripheral) {
        [_connectedPeripheral discoverServices: @[[CBUUID UUIDWithString:ICG_SERVICE_UUID]]];
        [_delegate didUpdateStatus:BIKE_CONNECTED];
        [_pollTimer invalidate];
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
{
    for (CBService* currentService in peripheral.services)
    {
        if ([[currentService.UUID UUIDString] isEqual:ICG_SERVICE_UUID]) {
            [peripheral discoverCharacteristics:nil forService:currentService];
            return;
        }
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
{
    for (CBCharacteristic* characteristic in service.characteristics)
    {
        if (characteristic.properties & CBCharacteristicPropertyNotify) {
            [peripheral setNotifyValue:YES forCharacteristic:characteristic];
            
            if ([[characteristic.UUID UUIDString] isEqual:ICG_RX_UUID]) {
                _currentCharacteristic = characteristic;
                [_delegate didUpdateStatus:BIKE_CONNECTED_RECEIVING];
            }
        }
    }
}

TrackPoint * decodeHexData(NSString *data)
{
    NSRange powerRange;
    powerRange.location = 8;
    powerRange.length = 2;
    
    NSRange cadenceRange;
    cadenceRange.location = 24;
    cadenceRange.length = 2;
    
    NSRange speedRange;
    speedRange.location = 26;
    speedRange.length = 4;
    
    NSRange resistanceRange;
    resistanceRange.location = 30;
    resistanceRange.length = 2;
    
    NSString *hexPower = [data substringWithRange:powerRange];
    NSString *hexCadence = [data substringWithRange:cadenceRange];
    NSString *hexSpeed = [data substringWithRange:speedRange];
    NSString *hexResistance = [data substringWithRange:resistanceRange];
    
    NSNumber *power = [hexPower hexToInt];
    NSNumber *cadence = [hexCadence hexToInt];
    NSNumber *speed = [hexSpeed hexToFloat];
    NSNumber *resistance = [hexResistance hexToInt];
    
    NSDate *currentTimestamp = [NSDate date];
            
    return [[TrackPoint alloc] initWithTime:currentTimestamp andSpeed:speed andCadence:cadence andPower:power andResistance:resistance];
}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    NSData *receivedData = characteristic.value;
    
    TrackPoint *point;
    NSString *hexData = [receivedData hexString];
    if (hexData.length == 40) {
        point = decodeHexData(hexData);
        [_delegate didReceiveData:point];
        return;
    }
}

@end
