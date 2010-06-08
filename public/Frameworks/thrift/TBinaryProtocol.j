
@import <Foundation/Foundation.j>
@import "TProtocol.j"
@import "CPNumberIEEE754Additions.j"

var VERSION_1 = 0x80010000;
var VERSION_MASK = 0xffff0000;

@implementation TBinaryProtocol : TProtocol
{
    TTransport _transport @accessors(property=transport);
    BOOL _strictWrite;
    BOOL _strictRead;
    int _messageSizeLimit;
}

- (id)initWithTransport:(TTransport)transport {
    if (self = [super init])
    {
        _transport = transport;
        _strictRead = YES;
        _strictWrite = YES;
    }
    return self;
}

- (void)writeByte:(int)value
{
    [_transport writeByte:value];
}

- (int)readByte
{
    var buf = [ -1 ];
    [_transport readAll:buf offset:0 length:1];
    
    var value = buf[0];
    
    if (value > 0x7f)
    {
        value = 0 - ((value - 1) ^ 0xff);
    }
    
    return value;
}

- (void)writeBool:(BOOL)value
{
    [self writeByte:(value ? 1 : 0)];
}

- (BOOL)readBool
{
    return ([self readByte] == 1);
}

- (void)writeI16:(short)value
{
    var buf = [
        (value & 0xff00) >> 8,
        (value & 0xff)
    ]
    
    [_transport write:buf offset:0 length:2];
}

- (short)readI16
{
    var buf = [ -1, -1 ];
    
    [_transport readAll:buf offset:0 length:2];
    
    var value = (buf[0] << 8) | buf[1];
    
    if (value > 0x7fff)
    {
        value = 0 - ((value - 1) ^ 0xffff);
    }
    
    return value;
}

- (void)writeI32:(int)value
{
    var buf = [
        (value & 0xff000000) >> 24,
        (value & 0x00ff0000) >> 16,
        (value & 0x0000ff00) >> 8,
        (value & 0x000000ff),
    ]
    
    [_transport write:buf offset:0 length:4];
}

- (int)readI32
{
    var buf = [ -1, -1, -1, -1 ];
    
    [_transport readAll:buf offset:0 length:4];
    
    var value =
        (buf[0] << 24) | 
        (buf[1] << 16) |
        (buf[2] << 8) |
        (buf[3]);

    if (value > 0x7fffffff)
    {
        value = 0 - ((value - 1) ^ 0xffffffff);
    }
        
    return value;
}

- (void)writeI64:(long)value
{
    var hi = value / Math.pow(2, 32);
    var lo = value & 0xffffffffff;
    
    var buf = [
        (hi & 0xff000000) >> 24,
        (hi & 0x00ff0000) >> 16,
        (hi & 0x0000ff00) >> 8,
        (hi & 0x000000ff),
        (lo & 0xff000000) >> 24,
        (lo & 0x00ff0000) >> 16,
        (lo & 0x0000ff00) >> 8,
        (lo & 0x000000ff)
    ]

    [_transport write:buf offset:0 length:8];
}

- (int)readI64
{
    var buf = [ -1, -1, -1, -1, -1, -1, -1, -1 ];

    [_transport readAll:buf offset:0 length:8];
    
    var value = 0;
    value = (value * 256) + (buf[0] & 0xff);
    value = (value * 256) + (buf[1] & 0xff);
    value = (value * 256) + (buf[2] & 0xff);
    value = (value * 256) + (buf[3] & 0xff);
    value = (value * 256) + (buf[4] & 0xff);
    value = (value * 256) + (buf[5] & 0xff);
    value = (value * 256) + (buf[6] & 0xff);
    value = (value * 256) + (buf[7] & 0xff);
        
    return value;
}

- (void)writeDouble:(double)value
{
    var valueAsHex = [value doubleValueAsHexString];
    
    for (var i = 0; i < 8; i++)
    {
        var byteInHex = [valueAsHex substringWithRange:CPMakeRange(i * 2, 2)];
        [self writeByte:parseInt(byteInHex, 16)];
    }
}

- (double)readDouble
{
    var hexValue = "";
    var bytes = new Array(8);
    
    [_transport readAll:bytes offset:0 length:8];
    
    for (var i = 0; i < 8; i++)
    {
        var byteAsHex = bytes[i].toString(16);
        hexValue = hexValue + (byteAsHex.length == 1 ? "0" + byteAsHex : byteAsHex);
    }

    return [CPNumber numberWithDoubleInHex:hexValue];
}

- (void)writeString:(CPString)value
{
    [self writeI32:value.length];
    
    for (var i = 0; i < value.length; i++)
    {
        [self writeByte:value.charCodeAt(i)];
    }
}

- (CPString)readStringBody:(int)size
{
    var buf = [CPArray arrayWithCapacity:size];
    [_transport readAll:buf offset:0 length:size];
    return CFData.bytesToString(buf);
}

- (CPString)readString
{
    var size = [self readI32];
    return [self readStringBody:size];
}

- (void)writeBinary:(CPData)value
{
    [self writeString:[value rawString]];
}

- (CPData)readBinary
{
    return [CPData dataWithRawString:[self readString]];
}

- (void)writeStructBeginWithName:(CPString)name
{
    // This does nothing in the Cocoa and Java implementations.  Not sure why it's here at all.
}

- (CPString)readStructBeginReturningName
{
    return "";
}

- (void)writeStructEnd {}

- (void)readStructEnd {}

- (void)writeFieldBeginWithName:(CPString)name
                           type:(int)fieldType
                         fieldID:(int)fieldID
{
    [self writeByte:fieldType];
    [self writeI16:fieldID];
}

- (void)writeFieldEnd {}

- (void)readFieldEnd {}

- (CPArray)readFieldBeginReturningNameTypeFieldID
{
    var type = [self readByte];
    var fieldID = -1;
    
    if (type != TType_STOP)
    {
        fieldID = [self readI16];
    }
    
    return [
        "",     // name is always empty
        type,
        fieldID
    ];
}

- (void)writeMessageBeginWithName:(CPString)name
                             type:(int)messageType
                       sequenceID:(int)sequenceID
{
    if (_strictWrite)
    {
        var version = VERSION_1 | messageType;
        [self writeI32:version];
        [self writeString:name];
        [self writeI32:sequenceID];
    }
    else
    {
        [self writeString:name];
        [self writeByte:messageType];
        [self writeI32:sequenceID];
    }
}

- (void)writeMessageEnd {}

- (void)readMessageEnd {}

- (CPArray)readMessageBeginReturningNameTypeSequenceID
{
    var name,
        type,
        sequenceID;
    
    var size = [self readI32];

    if (size & 0x80000000)
    {
        var version = (size >> 16) & 0xffff;
        
        if (version != (((VERSION_1) >> 16) & 0xffff))
        {
            [CPException raise:"TProtocolException" reason:"Bad version (" + version + ") in readMessageBegin"];
        }
        
        type = size & 0x00ff;
        name = [self readString];
        sequenceID = [self readI32];
    }
    else
    {
        if (_strictRead)
        {
            [CPException raise:"TProtocolException" reason:"Missing version in readMessageBegin, old client?"];
        }
        
        if (_messageSizeLimit > 0 && size > _messageSizeLimit)
        {
            [CPException raise:"TProtocolException" 
                        reason:[CPString stringWithFormat: @"Message too big.  Size limit is: %d Message size is: %d", _messageSizeLimit, size]];
        }
        
        name = [self readStringBody:size];
        type = [self readByte];
        sequenceID = [self readI32];
    }
    
    return [name, type, sequenceID];
}

- (void)writeListBeginWithElementType:(int)elementType
                                 size:(int)size
{
    [self writeByte:elementType];
    [self writeI32:size];
}

- (void)writeListEnd {}

- (void)writeFieldStop
{
    [self writeByte:TType_STOP];
}

- (void)writeFieldEnd {}

- (void)readListBeginReturningElementTypeSize
{
    var elementType = [self readByte];
    var size = [self readI32];
    
    return [elementType, size];
}

- (void)readListEnd {}

- (void)writeSetBeginWithElementType:(int)elementType
                                 size:(int)size
{
    [self writeByte:elementType];
    [self writeI32:size];
}

- (void)writeSetEnd {}

- (void)writeMapBeginWithKeyType:(int)keyType
                        valueType:(int)valueType
                             size:(int)size
{
    [self writeByte:keyType];
    [self writeByte:valueType];
    [self writeI32:size];
}

- (void)writeMapEnd {}

- (void) readMapBeginReturningKeyTypeValueTypeSize
{
    var keyType = [self readByte];
    var valueType = [self readByte];
    var size = [self readI32];

    return [keyType, valueType, size];
}

- (void) readMapEnd {}

- (void) readSetBeginReturningElementTypeSize
{
    var elementType = [self readByte];
    var size = [self readI32];
    return [elementType, size];
}

- (void) readSetEnd {}

@end