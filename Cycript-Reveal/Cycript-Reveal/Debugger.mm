//
//  Debugger.mm
//  Cycript-Reveal
//
//  Created by Magic-Unique on 7/8/16.
//  Copyright (c) 2016 Unique. All rights reserved.
//

#import <Cycript/Cycript.h>
#import <UIKit/UIKit.h>

#define CYCRIPT_PORT 8888

@interface MUDebugger : NSObject
@end

@implementation MUDebugger

+ (void)load {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationDidFinishLaunching:)
                                                 name:UIApplicationDidFinishLaunchingNotification
                                               object:nil];
}

+ (void)applicationDidFinishLaunching:(NSNotification *)notification {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self runReveal];
    [self runCycript];
}

+ (void)runReveal {
    NSLog(@"## Debugger: Start Reveal");
}

+ (void)runCycript {
    NSFileManager *fmgr = [NSFileManager defaultManager];
    short port = CYCRIPT_PORT;
    NSString *LocalPortFile = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:@"cycrypt.port"];
    if ([fmgr fileExistsAtPath:LocalPortFile]) {
        NSString *content = [NSString stringWithContentsOfFile:LocalPortFile encoding:NSUTF8StringEncoding error:nil];
        if (content.length) {
            NSInteger newPort = [content integerValue];
            if (newPort > 0) {
                port = newPort;
            }
        }
    } else {
        LocalPortFile = [NSBundle.mainBundle pathForResource:@"cycript" ofType:@"port"];
        if ([fmgr fileExistsAtPath:LocalPortFile]) {
            NSString *content = [NSString stringWithContentsOfFile:LocalPortFile encoding:NSUTF8StringEncoding error:nil];
            if (content.length) {
                NSInteger newPort = [content integerValue];
                if (newPort > 0) {
                    port = newPort;
                }
            }
        }
    }
    CYListenServer(port);
    NSLog(@"## Debugger: Start Cycript at %d", port);
}

@end
