//
//  SPHotKey.h
//  ModalMenu
//
//  Created by Odin Dutton on 17/07/2014.
//  Copyright (c) 2014 Odin Dutton. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <Carbon/Carbon.h>

@interface SPHotKey : NSObject

@property (nonatomic, assign) id target;
@property (nonatomic, strong) id object;

@property (nonatomic, assign) unsigned short keyCode;
@property (nonatomic, assign) NSUInteger modifierFlags;

@property (nonatomic, retain) NSValue *hotKeyRef;
@property (nonatomic) UInt32 hotKeyID;


@property (nonatomic) SEL action;

- (instancetype)initWithTarget:(id)target
                        action:(SEL)action
                        object:(id)object
                       keyCode:(unsigned short)keyCode
                 modifierFlags:(NSUInteger)modifierFlags;

+ (instancetype)hotkeyWithTarget:(id)target
                       action:(SEL)action
                       object:(id)object
                      keyCode:(unsigned short)keyCode
                modifierFlags:(NSUInteger)modifierFlags;

- (void)invokeWithEvent:(NSEvent *)event;

@end
