//
// Created by shiweifu on 9/30/14.
// Copyright (c) 2014 weifu. All rights reserved.
//


#import <Carbon/Carbon.h>
#import <objc/runtime.h>
#import "SPHotKeyManager.h"
#import "SPHotKey.h"

OSStatus hotKeyHandler(EventHandlerCallRef nextHandler, EventRef theEvent, void *userData);

@implementation SPHotKeyManager
{
  NSMutableSet *_registeredHotKeys;
  UInt32 _nextHotKeyID;
}

+ (SPHotKeyManager *)instance
{
  static SPHotKeyManager *_instance = nil;

  @synchronized (self)
  {
    if (_instance == nil)
    {
      _instance = [[self alloc] init];
      EventTypeSpec eventSpec;
      eventSpec.eventClass = kEventClassKeyboard;
      eventSpec.eventKind = kEventHotKeyReleased;
      InstallApplicationEventHandler(&hotKeyHandler, 1, &eventSpec, NULL, NULL);
    }
  }

  return _instance;
}

- (id)init {
  self = [super init];
  if (self) {
    _registeredHotKeys = [[NSMutableSet alloc] init];
    _nextHotKeyID = 1;
  }
  return self;
}

- (NSSet *)hotKeysMatching:(BOOL(^)(SPHotKey *hotkey))matcher {
  NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
    return matcher(evaluatedObject);
  }];
  return [_registeredHotKeys filteredSetUsingPredicate:predicate];
}

- (SPHotKey *)registerHotKey:(SPHotKey *)hotKey {
  if ([_registeredHotKeys containsObject:hotKey]) {
    return hotKey;
  }

  EventHotKeyID keyID;
  keyID.signature = 'htk1';
  keyID.id = _nextHotKeyID;

  EventHotKeyRef carbonHotKey;
  UInt32 flags = CarbonModifierFlagsFromCocoaModifiers([hotKey modifierFlags]);
  OSStatus err = RegisterEventHotKey([hotKey keyCode], flags, keyID, GetEventDispatcherTarget(), 0, &carbonHotKey);

  //error registering hot key
  if (err != 0) { return nil; }

  NSValue *refValue = [NSValue valueWithPointer:carbonHotKey];
  [hotKey setHotKeyRef:refValue];
  [hotKey setHotKeyID:_nextHotKeyID];

  _nextHotKeyID++;
  [_registeredHotKeys addObject:hotKey];

  return hotKey;
}

- (void)unregisterHotKey:(SPHotKey *)hotKey {
  NSValue *hotKeyRef = [hotKey hotKeyRef];
  if (hotKeyRef) {
    EventHotKeyRef carbonHotKey = (EventHotKeyRef)[hotKeyRef pointerValue];
    UnregisterEventHotKey(carbonHotKey);
    [hotKey setHotKeyRef:nil];
  }

  [_registeredHotKeys removeObject:hotKey];
}

- (void)unregisterAllHotKeys {
  NSSet *keys = [_registeredHotKeys copy];
  for (SPHotKey *key in keys) {
    [self unregisterHotKey:key];
  }
}

@end

OSStatus hotKeyHandler(EventHandlerCallRef nextHandler, EventRef theEvent, void *userData) {
  @autoreleasepool {
    EventHotKeyID hotKeyID;
    GetEventParameter(theEvent, kEventParamDirectObject, typeEventHotKeyID, NULL, sizeof(hotKeyID), NULL, &hotKeyID);

    UInt32 keyID = hotKeyID.id;

    NSSet *matchingHotKeys = [[SPHotKeyManager instance] hotKeysMatching:^BOOL(SPHotKey *hotkey) {
      return hotkey.hotKeyID == keyID;
    }];
    if ([matchingHotKeys count] > 1) { NSLog(@"ERROR!"); }
    SPHotKey *matchingHotKey = [matchingHotKeys anyObject];

    NSEvent *event = [NSEvent eventWithEventRef:theEvent];
    NSEvent *keyEvent = [NSEvent keyEventWithType:NSKeyUp
                                         location:[event locationInWindow]
                                    modifierFlags:[event modifierFlags]
                                        timestamp:[event timestamp]
                                     windowNumber:-1
                                          context:nil
                                       characters:@""
                      charactersIgnoringModifiers:@""
                                        isARepeat:NO
                                          keyCode:[matchingHotKey keyCode]];

    [matchingHotKey invokeWithEvent:keyEvent];
  }

  return noErr;
}

UInt32 CarbonModifierFlagsFromCocoaModifiers(NSUInteger flags) {
  UInt32 newFlags = 0;
  if ((flags & NSControlKeyMask) > 0) { newFlags |= controlKey; }
  if ((flags & NSCommandKeyMask) > 0) { newFlags |= cmdKey; }
  if ((flags & NSShiftKeyMask) > 0) { newFlags |= shiftKey; }
  if ((flags & NSAlternateKeyMask) > 0) { newFlags |= optionKey; }
  if ((flags & NSAlphaShiftKeyMask) > 0) { newFlags |= alphaLock; }
  return newFlags;
}

