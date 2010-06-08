
@import <Foundation/Foundation.j>
@import "TProtocol.j"

@implementation TProtocolUtil : CPObject
{
}

+ (void)skipType:(int)type onProtocol:(TProtocol) protocol
{
  switch (type) {
  case TType_BOOL:
    [protocol readBool];
    break;
  case TType_BYTE:
    [protocol readByte];
    break;
  case TType_I16:
    [protocol readI16];
    break;
  case TType_I32:
    [protocol readI32];
    break;
  case TType_I64:
    [protocol readI64];
    break;
  case TType_DOUBLE:
    [protocol readDouble];
    break;
  case TType_STRING:
    [protocol readString];
    break;
  case TType_STRUCT:
    [protocol readStructBeginReturningName];
    while (true) {
      var fieldType;
      var fieldBegin = [protocol readFieldBeginReturningNameTypeFieldID];
      fieldType = fieldBegin[1];
      if (fieldType == TType_STOP) {
        break;
      }
      [TProtocolUtil skipType: fieldType onProtocol: protocol];
      [protocol readFieldEnd];
    }
    [protocol readStructEnd];
    break;
  case TType_MAP:
  {
    var keyType;
    var valueType;
    var size;
    var mapBegin = [protocol readMapBeginReturningKeyTypeValueTypeSize];
    keyType = mapBegin[0];
    valueType = mapBegin[1];
    size = mapBegin[2];
    var i;
    for (i = 0; i < size; i++) {
      [TProtocolUtil skipType: keyType onProtocol: protocol];
      [TProtocolUtil skipType: valueType onProtocol: protocol];
    }
    [protocol readMapEnd];
  }
    break;
    case TType_SET:
    {
      var elemType;
      var size;
      var setBegin = [protocol readSetBeginReturningElementTypeSize];
      elemType = setBegin[0];
      size = setBegin[1];
      var i;
      for (i = 0; i < size; i++) {
        [TProtocolUtil skipType: elemType onProtocol: protocol];
      }
      [protocol readSetEnd];
    }
      break;
    case TType_LIST:
    {
      var elemType;
      var size;
      var listBegin = [protocol readListBeginReturningElementTypeSize];
      elemType = listBegin[0];
      size = listBegin[1];
      var i;
      for (i = 0; i < size; i++) {
        [TProtocolUtil skipType: elemType onProtocol: protocol];
      }
      [protocol readListEnd];
    }
      break;
    default:
      return;
  }
}

@end