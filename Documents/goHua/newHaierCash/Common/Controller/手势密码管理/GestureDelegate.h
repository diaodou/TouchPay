//
//  GestureDelegate.h
//  personMerchants
//
//  Created by xuxie on 16/4/13.
//  Copyright © 2016年 海尔金融. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol GestureDelegate <NSObject>
@optional
- (void)forgotGuestPwd;
- (void)loginUserOther;
- (void)loginSucess;
@end
