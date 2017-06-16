//
//  SpecialButton.h
//  HaiercashMerchantsAPP
//
//  Created by 史长硕 on 16/5/3.
//  Copyright © 2016年 海尔金融. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SpecialButton : UIButton

@property(nonatomic,strong)NSIndexPath *index;

@property(nonatomic,copy)NSString *typeName;

@property(nonatomic,copy)NSString *storeName;

@property(nonatomic,assign)NSInteger num;

@property(nonatomic,copy)NSString *days;

@end
