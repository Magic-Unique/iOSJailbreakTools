//
//  UIControl+DebugLib.m
//  Cycript-Reveal
//
//  Created by 冷秋 on 2018/3/9.
//

#import "UIControl+DebugLib.h"

//typedef NS_OPTIONS(NSUInteger, UIControlEvents) {
//    UIControlEventTouchDown                                         = 1 <<  0,      // on all touch downs
//    UIControlEventTouchDownRepeat                                   = 1 <<  1,      // on multiple touchdowns (tap count > 1)
//    UIControlEventTouchDragInside                                   = 1 <<  2,
//    UIControlEventTouchDragOutside                                  = 1 <<  3,
//    UIControlEventTouchDragEnter                                    = 1 <<  4,
//    UIControlEventTouchDragExit                                     = 1 <<  5,
//    UIControlEventTouchUpInside                                     = 1 <<  6,
//    UIControlEventTouchUpOutside                                    = 1 <<  7,
//    UIControlEventTouchCancel                                       = 1 <<  8,
//
//    UIControlEventValueChanged                                      = 1 << 12,     // sliders, etc.
//    UIControlEventPrimaryActionTriggered NS_ENUM_AVAILABLE_IOS(9_0) = 1 << 13,     // semantic action: for buttons, etc.
//
//    UIControlEventEditingDidBegin                                   = 1 << 16,     // UITextField
//    UIControlEventEditingChanged                                    = 1 << 17,
//    UIControlEventEditingDidEnd                                     = 1 << 18,
//    UIControlEventEditingDidEndOnExit                               = 1 << 19,     // 'return key' ending editing
//
//    UIControlEventAllTouchEvents                                    = 0x00000FFF,  // for touch events
//    UIControlEventAllEditingEvents                                  = 0x000F0000,  // for UITextField
//    UIControlEventApplicationReserved                               = 0x0F000000,  // range available for application use
//    UIControlEventSystemReserved                                    = 0xF0000000,  // range reserved for internal framework use
//    UIControlEventAllEvents                                         = 0xFFFFFFFF
//};

static NSString *NSStringFromUIControlEvent(UIControlEvents event) {
    switch (event) {
#define CaseEvent(event) case UIControlEvent##event: return @#event;
            CaseEvent(TouchDown);
            CaseEvent(TouchDownRepeat);
            CaseEvent(TouchDragInside);
            CaseEvent(TouchDragOutside);
            CaseEvent(TouchDragEnter);
            CaseEvent(TouchDragExit);
            CaseEvent(TouchUpInside);
            CaseEvent(TouchUpOutside);
            CaseEvent(TouchCancel);
            CaseEvent(ValueChanged);
            CaseEvent(EditingDidBegin);
            CaseEvent(EditingChanged);
            CaseEvent(EditingDidEnd);
            CaseEvent(EditingDidEndOnExit);
#undef CaseEvent
            case UIControlEventPrimaryActionTriggered:
            case UIControlEventAllTouchEvents:
            case UIControlEventAllEditingEvents:
            case UIControlEventApplicationReserved:
            case UIControlEventSystemReserved:
            case UIControlEventAllEvents:
        default:break;
    }
    if (UIDevice.currentDevice.systemVersion.floatValue >= 9.0 && event == UIControlEventPrimaryActionTriggered) {
        return @"PrimaryActionTriggered";
    }
    return nil;
}

@implementation UIControl (DebugLib)

- (NSDictionary *)dlib_eventActions {
    UIControlEvents events = self.allControlEvents;
    NSArray *targets = self.allTargets.allObjects;
    NSMutableDictionary *map = [NSMutableDictionary dictionary];
    for (NSUInteger i = 0; i < 20; i++) {
        UIControlEvents currentEvent = 1 << i;
        if ((events & currentEvent) == 0) {
            continue;
        }
        NSString *currentEventName = NSStringFromUIControlEvent(currentEvent);
        if (currentEventName == nil) {
            continue;
        }
        NSMutableArray *targetActions = [NSMutableArray array];
        for (id target in targets) {
            NSString *className = NSStringFromClass([target class]);
            NSArray *actions = [self actionsForTarget:target forControlEvent:currentEvent];
            for (NSString *action in actions) {
                NSString *targetAction = [NSString stringWithFormat:@"-[%@ %@]", className, action];
                [targetActions addObject:targetAction];
            }
        }
        if (targetActions.count) {
            map[currentEventName] = targetActions;
        }
    }
    return [map copy];
}

@end
