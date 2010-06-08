
@import "TException.j"
@import "TProtocol.j"

TApplicationException_UNKNOWN = 0;
TApplicationException_UNKNOWN_METHOD = 1;
TApplicationException_INVALID_MESSAGE_TYPE = 2;
TApplicationException_WRONG_METHOD_NAME = 3;
TApplicationException_BAD_SEQUENCE_ID = 4;
TApplicationException_MISSING_RESULT = 5;

@implementation TApplicationException : TException
{
    int _type;
}

- (id) initWithType: (int) type
             reason: (CPString) reason
{
    _type = type;

    var name;
    switch (type) {
        case TApplicationException_UNKNOWN_METHOD:
            name = @"Unknown method";
            break;
        case TApplicationException_INVALID_MESSAGE_TYPE:
            name = @"Invalid message type";
            break;
        case TApplicationException_WRONG_METHOD_NAME:
            name = @"Wrong method name";
            break;
        case TApplicationException_BAD_SEQUENCE_ID:
            name = @"Bad sequence ID";
            break;
        case TApplicationException_MISSING_RESULT:
            name = @"Missing result";
            break;
        default:
            name = @"Unknown";
            break;
    }

    self = [super initWithName: name reason: reason userInfo: nil];
    return self;
}


+ (TApplicationException) read: (TProtocol) protocol
{
    var reason;
    var type = TApplicationException_UNKNOWN;
    var fieldType;
    var fieldID;

    [protocol readStructBeginReturningName];

    while (true) {
        var fieldBegin = [protocol readFieldBeginReturningNameTypeFieldID];
        fieldType = fieldBegin[1];
        fieldID = fieldBegin[2];
        
        if (fieldType == TType_STOP) {
          break;
        }
        switch (fieldID) {
            case 1:
                if (fieldType == TType_STRING) {
                    reason = [protocol readString];
                } else {
                    [TProtocolUtil skipType: fieldType onProtocol: protocol];
                }
                break;
            case 2:
                if (fieldType == TType_I32) {
                    type = [protocol readI32];
                } else {
                    [TProtocolUtil skipType: fieldType onProtocol: protocol];
                }
                break;
            default:
                [TProtocolUtil skipType: fieldType onProtocol: protocol];
          break;
        }
        [protocol readFieldEnd];
    }
    [protocol readStructEnd];

    return [TApplicationException exceptionWithType: type reason: reason];
}


- (void) write: (TProtocol) protocol
{
    [protocol writeStructBeginWithName: @"TApplicationException"];

    if ([self reason] != nil) {
        [protocol writeFieldBeginWithName: @"message"
                    type: TType_STRING
                    fieldID: 1];
        [protocol writeString: [self reason]];
        [protocol writeFieldEnd];
    }

    [protocol writeFieldBeginWithName: @"type"
                   type: TType_I32
                   fieldID: 2];
    [protocol writeI32: mType];
    [protocol writeFieldEnd];

    [protocol writeFieldStop];
    [protocol writeStructEnd];
}


+ (TApplicationException) exceptionWithType: (int) type
                                     reason: (CPString) reason
{
  return [[TApplicationException alloc] initWithType: type
                                              reason: reason];
}

@end
