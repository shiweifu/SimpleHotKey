#import "SPHotKey.h"

@implementation SPHotKey

@synthesize action = _action;

- (void)invokeWithEvent:(NSEvent *)event {
  if (_target != nil && _action != nil && [_target respondsToSelector:_action]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    [_target performSelector:_action withObject:event withObject:_object];
#pragma clang diagnostic pop
  }
}


- (instancetype)initWithTarget:(id)target
                        action:(SEL)action
                        object:(id)object
                       keyCode:(unsigned short)keyCode
                 modifierFlags:(NSUInteger)modifierFlags
{
  self = [super init];
  if (self)
  {
    _target = target;
    _object = object;
    _keyCode = keyCode;
    _modifierFlags = modifierFlags;
    _action = action;
  }

  return self;
}

+ (instancetype)hotkeyWithTarget:(id)target
                       action:(SEL)action
                       object:(id)object
                      keyCode:(unsigned short)keyCode
                modifierFlags:(NSUInteger)modifierFlags
{
  return [[self alloc] initWithTarget:target
                               action:action
                               object:object
                              keyCode:keyCode
                        modifierFlags:modifierFlags];
}


@end
