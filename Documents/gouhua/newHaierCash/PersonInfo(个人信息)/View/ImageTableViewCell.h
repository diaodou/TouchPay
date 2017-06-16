//
//  ImageTableViewCell.h
//  HaiFu
//
//  Created by 史长硕 on 17/2/9.
//  Copyright © 2017年 百思为科. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PortraitImageModel.h"
#import "ChooseNameModel.h"
#import "CheckMsgModel.h"
#import "CustomButton.h"
@interface ImageTableViewCell : UITableViewCell


@property(nonatomic,strong)CustomButton *lefeButton;//左侧图像按钮

@property(nonatomic,strong)CustomButton *rightButton;//右侧图像按钮

-(void)insertArray:(NSArray *)modelArray;


@end
