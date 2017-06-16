//
//  HCChoiceTopView.h
//  newHaierCash
//
//  Created by 史长硕 on 2017/5/31.
//  Copyright © 2017年 haier. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,ChoiceType){
    
    ChoiceAll,//选择全部
    
    ChoiceHousehold,//选择家电
    
    ChoiceSelected,//选择精选
    
    ChoiceTourism,//选择旅游
    
};

@protocol SendChoiceTypeDelegate <NSObject>

-(void)sendChoiceType:(NSInteger)type;

@end

@interface HCChoiceTopView : UIView

@property(nonatomic,weak)id<SendChoiceTypeDelegate> delegate;//选择类型时调用的代理

@property(nonatomic,copy)NSArray *nameArray;//名称数组


@end
