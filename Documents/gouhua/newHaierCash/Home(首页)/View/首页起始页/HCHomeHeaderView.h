//
//  HCHomeHeaderView.h
//  newHaierCash
//
//  Created by Will on 2017/5/31.
//  Copyright © 2017年 haier. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HCHomeUserModel;

typedef  NS_ENUM(NSInteger, HCHomeHeaderViewButtonType) {
    buttonTypeMessage = 1,
    buttonTypeScan,
    buttonTypeLogin,
    buttonTypeIncreaseAmount,
    buttonTypeActiveAmount,
    buttonTypeAmountProgress,
    buttonTypeCommitAmount,
    
};


@protocol HCHomeHeaderViewDelegate;

@interface HCHomeHeaderView : UIView

@property (nonatomic,weak)id<HCHomeHeaderViewDelegate> delegate;

- (void)generateViewWithModel:(HCHomeUserModel *)userModel andIsRealName:(BOOL)isRealName;

@end

@protocol HCHomeHeaderViewDelegate <NSObject>

- (void)HCHomeHeaderViewDidClickButton:(UIButton *)button;

@end
