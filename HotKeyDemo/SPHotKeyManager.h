//
// Created by shiweifu on 9/30/14.
// Copyright (c) 2014 weifu. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SPHotKey;

extern UInt32 CarbonModifierFlagsFromCocoaModifiers(NSUInteger flags);

@interface SPHotKeyManager : NSObject

+ (SPHotKeyManager *)instance;

- (void)unregisterHotKey:(SPHotKey *)hotKey;

- (SPHotKey *)registerHotKey:(SPHotKey *)hotKey;

- (void)unregisterAllHotKeys;

@end
