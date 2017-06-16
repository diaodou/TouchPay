//
//  TopSelectView.h
//  HaiercashMerchantsAPP
//
//  Created by 史长硕 on 17/1/11.
//  Copyright © 2017年 海尔金融. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SendSelectDelegate <NSObject>

-(void)sendSelect:(BOOL)selectResult;

@end

@interface TopSelectView : UIView

@property(nonatomic,weak)id<SendSelectDelegate> delegate;

@end
