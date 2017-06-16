//
//  UIButton+LazyButton.h
//  personMerchants
//
//  Created by xuxie on 17/2/16.
//  Copyright © 2017年 海尔金融. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (LazyButton)

@property (nonatomic, assign) NSTimeInterval lazyEventInterval; //间隔时间  （可不设置有默认值）
@property (nonatomic, assign) BOOL bIgnoreEvent;   //忽略点击事件 (设为NO)

@end
