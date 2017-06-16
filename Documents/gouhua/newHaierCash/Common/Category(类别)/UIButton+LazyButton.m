//
//  UIButton+LazyButton.m
//  personMerchants
//
//  Created by xuxie on 17/2/16.
//  Copyright © 2017年 海尔金融. All rights reserved.
//

#import "UIButton+LazyButton.h"
#import <objc/runtime.h>


static const char * UIControl_acceptEventInterval = "UIControl_acceptEventInterval";

static const char *UIcontrol_ignoreEvent = "UIcontrol_ignoreEvent";

//static const float defaultInterval = 0.5f;  //默认时间0.5s

@implementation UIButton (LazyButton)

- (NSTimeInterval)lazyEventInterval {
    return [objc_getAssociatedObject(self, UIControl_acceptEventInterval)doubleValue];
}

- (void)setLazyEventInterval:(NSTimeInterval)lazyEventInterval {
    objc_setAssociatedObject(self, UIControl_acceptEventInterval, @(lazyEventInterval), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)bIgnoreEvent {
    return [objc_getAssociatedObject(self, UIcontrol_ignoreEvent)boolValue];
}


- (void)setBIgnoreEvent:(BOOL)bIgnoreEvent {
    objc_setAssociatedObject(self, UIcontrol_ignoreEvent, @(bIgnoreEvent), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

+ (void)load {
    
    Method systemMethod = class_getInstanceMethod(self, @selector(sendAction:to:forEvent:));
    
    SEL sysSEL = @selector(sendAction:to:forEvent:);
    
    Method customMethod = class_getInstanceMethod(self, @selector(lazy_sendAction:to:forEvent:));
    SEL customSEL = @selector(lazy_sendAction:to:forEvent:);
    
    BOOL didAddMethod = class_addMethod(self, sysSEL, method_getImplementation(customMethod), method_getTypeEncoding(customMethod));
    //如果系统中该方法已经存在了，则替换系统的方法  语法：IMP class_replaceMethod(Class cls, SEL name, IMP imp,const char *types)
    if (didAddMethod) {
        class_replaceMethod(self, customSEL, method_getImplementation(systemMethod), method_getTypeEncoding(systemMethod));
    }else{
        method_exchangeImplementations(systemMethod, customMethod);
    }
    
}

- (void)lazy_sendAction:(SEL)action to:(id)target forEvent:(UIEvent *)even{
    if (self.bIgnoreEvent) {
        return;
    }else {
        if (self.lazyEventInterval > 0) {
            self.bIgnoreEvent = YES;
            [self performSelector:@selector(setNoIngore) withObject:nil afterDelay:self.lazyEventInterval];
        }
        [self lazy_sendAction:action to:target forEvent:even];
    }
}

- (void)setNoIngore {
    objc_setAssociatedObject(self, UIcontrol_ignoreEvent, @(NO), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
