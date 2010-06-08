
@import <Foundation/Foundation.j>

@implementation TTransport : CPObject
{
}

- (id)init {
    if (self = [super init])
    {
    }
    return self;
}

/*!
    Subclasses should override.
*/
- (int)readAll:(CPArray)buffer offset:(int)offset length:(int)length
{
    [CPException raise:CPUnsupportedMethodException reason:"readAll:offset:length not implemented"];
}

/*!
    Subclasses should override.
*/
- (void)write:(CPArray)buffer offset:(int)offset length:(int)length
{
    [CPException raise:CPUnsupportedMethodException reason:"write:offset:length not implemented"];
}

- (void)writeByte:(int)value
{
    [self write:[value] offset:0 length:1];
}

/*!
    Subclasses should override.
*/
- (void)flush
{
}

@end