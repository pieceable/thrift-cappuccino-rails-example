
@import <Foundation/Foundation.j>

TMessageType_CALL = 1;
TMessageType_REPLY = 2;
TMessageType_EXCEPTION = 3;
TMessageType_ONEWAY = 4;

TType_STOP   = 0;
TType_VOID   = 1;
TType_BOOL   = 2;
TType_BYTE   = 3;
TType_DOUBLE = 4;
TType_I16    = 6;
TType_I32    = 8;
TType_I64    = 10;
TType_STRING = 11;
TType_STRUCT = 12;
TType_MAP    = 13;
TType_SET    = 14;
TType_LIST   = 15;

@implementation TProtocol : CPObject
{
}

- (id)init {
    if (self = [super init])
    {
    }
    return self;
}

@end
