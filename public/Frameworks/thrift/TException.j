
@import <Foundation/Foundation.j>

@implementation TException : CPObject
{
    CPString _name @accessors(property = name);
    CPString _reason @accessors(property = reason);
    CPDictionary _userInfo @accessors(property = userInfo);
}

+ (id) exceptionWithName: (CPString) aName
{
  return [self exceptionWithName: aName reason: @"unknown" error: nil];
}


+ (id) exceptionWithName: (CPString) aName
                  reason: (CPString) aReason
{
    return [self exceptionWithName: aName reason: aReason error: nil];
}


+ (id) exceptionWithName: (CPString) aName
                  reason: (CPString) aReason
                   error: (id) anError
{
    var userInfo = nil;
    if (anError != nil) {
        userInfo = [CPDictionary dictionaryWithObject: anError forKey: @"error"];
    }

    return [super exceptionWithName: aName
                             reason: aReason
                           userInfo: anError];
}

- (id)initWithName:name reason:reason userInfo:userInfo
{
    if (self = [super init])
    {
        _name = name;
        _reason = reason;
        _userInfo = userInfo;
    }
    return self;
}

- (CPString) description
{
    var result = [self name];
    result = result + [CPString stringWithFormat: ": %@", [self reason]];
    if ([self userInfo] != nil) {
        result = result + [CPString stringWithFormat: @"\n  userInfo = %@", [self userInfo]];
    }

    return result;
}

@end

