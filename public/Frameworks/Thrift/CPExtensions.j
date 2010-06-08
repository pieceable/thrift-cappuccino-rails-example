
@implementation CPSet (EnhancedDescriptions)

/*!
    CPSet doesn't provide a description method that pretty prints the contents.
*/
- (CPString)description
{
    return "[ " + [[self allObjects] componentsJoinedByString:", "] + "]";
}

@end

@implementation CPInvocation (Extensions)

/*!
    CPInvocation has _methodSignature as a member variable, but wasn't exposing the getter.
*/
- (CPMethodSignature)methodSignature
{
    return self._methodSignature;
}

@end