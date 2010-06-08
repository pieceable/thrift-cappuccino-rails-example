
@import <Foundation/Foundation.j>
@import "TTransport.j"

@implementation TMemoryBuffer : TTransport
{
    CPMutableArray _bytes;
    int _readPosition;
}

+ (TMemoryBuffer)memoryBufferFromBase64:(CPString)base64
{
    var buffer = [[TMemoryBuffer alloc] init];
    buffer._bytes = CFData.decodeBase64ToArray(base64);
    return buffer;
}

- (id)init {
    if (self = [super init])
    {
        [self setBufferContents:[CPArray array]];
    }
    return self;
}

- (void)setBufferContents:(CPArray)bytes
{
    _bytes = bytes;
    _readPosition = 0;
}

- (int)readAll:(CPArray)buffer offset:(int)offset length:(int)length
{
    var bytesAvailable = _bytes.length - _readPosition;
    
    if (length > bytesAvailable)
    {
        [CPException raise:CPInvalidArgumentException reason:"Asked to read " + length + " bytes, but only " + bytesAvailable + " bytes are available."];
    }
    else
    {
        for (var i = 0; i < length; i++)
        {
            buffer[offset + i] = _bytes[_readPosition++];
        }
    }
}

- (void)write:(CPArray)buffer offset:(int)offset length:(int)length
{
    if ((offset + length) > buffer.length)
    {
        [CPException raise:CPInvalidArgumentException reason:"(offset + length) == " + (offset + length) + " which is > bufffer.length of " + buffer.length];
    }
    else
    {
        for (var i = 0; i < length; i++)
        {
            [_bytes addObject:buffer[offset + i]];
        }
    }
}

- (CPString)contentsAsBase64
{
    return CFData.encodeBase64Array(_bytes);
}

@end