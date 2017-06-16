//
//  GoodGestureRecognizer.h
//  HaiercashMerchantsAPP
//
//  Created by apple on 16/3/21.
//  Copyright © 2016年 海尔金融. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StatusProvingView.h"
@interface GoodGestureRecognizer : UITapGestureRecognizer

@property(nonatomic,assign)NSInteger num;

@property(nonatomic,assign)BOOL isLike;

@property(nonatomic,strong)NSIndexPath *index;

@property(nonatomic,copy)NSString *typeString;

@property(nonatomic,assign)TouchType touch;


@end
