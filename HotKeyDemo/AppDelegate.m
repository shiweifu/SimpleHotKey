//
//  AppDelegate.m
//  HotKeyDemo
//
//  Created by shiweifu on 9/30/14.
//  Copyright (c) 2014 weifu. All rights reserved.
//

#import "AppDelegate.h"
#import "SPHotKey.h"
#import "SPHotKeyManager.h"

@interface AppDelegate ()

@property (weak) IBOutlet NSWindow *window;
@end

@implementation AppDelegate

SPHotKey *hkStop;
SPHotKey *hkPause;
SPHotKey *hk;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
  // Insert code here to initialize your application



}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
  // Insert code here to tear down your application
  [self unRegAll:nil];
}

- (void)testMethod
{
  NSLog(@"%@", @"test method");
}

- (void)testMethodStop
{
  NSLog(@"%@", @"test stop");
}

- (void)testMethodPause
{
  NSLog(@"%@", @"test pause");
}

- (IBAction)reg:(id)sender {
  SPHotKeyManager *hotKeyManager = [SPHotKeyManager instance];
  //  [hotKeyManager reister]
  hk = [[SPHotKey alloc] initWithTarget:self
                               action:@selector(testMethod)
                               object:nil
                              keyCode:kVK_ANSI_0
                        modifierFlags:(NSControlKeyMask)];

  [hotKeyManager registerHotKey:hk];


  hkStop = [[SPHotKey alloc] initWithTarget:self
                               action:@selector(testMethodStop)
                               object:nil
                              keyCode:kVK_ANSI_1
                        modifierFlags:(NSControlKeyMask)];

  [hotKeyManager registerHotKey:hkStop];


  hkPause = [[SPHotKey alloc] initWithTarget:self
                                   action:@selector(testMethodPause)
                                   object:nil
                                  keyCode:kVK_ANSI_2
                            modifierFlags:(NSControlKeyMask)];

  [hotKeyManager registerHotKey:hkPause];
}

- (IBAction)unReg:(id)sender {
  SPHotKeyManager *hotKeyManager = [SPHotKeyManager instance];

  if(hk)
  {
    [hotKeyManager unregisterHotKey:hk];
    hk = nil;
  }
  else if(hkPause)
  {
    [hotKeyManager unregisterHotKey:hkPause];
    hkPause = nil;
  }
  else if(hkStop)
  {
    [hotKeyManager unregisterHotKey:hkStop];
    hkStop = nil;
  }
}

- (IBAction)unRegAll:(id)sender {
  SPHotKeyManager *hotKeyManager = [SPHotKeyManager instance];
  [hotKeyManager unregisterAllHotKeys];
  hk = nil;
  hkPause = nil;
  hkStop = nil;
}

@end
