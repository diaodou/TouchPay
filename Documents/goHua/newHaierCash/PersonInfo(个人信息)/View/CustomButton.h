//
//  CustomButton.h
//  HaiFu
//
//  Created by 史长硕 on 17/2/8.
//  Copyright © 2017年 百思为科. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PortraitImageModel.h"
#import "CheckMsgModel.h"

@interface CustomButton : UIButton

@property(nonatomic,assign) NSInteger oldNumber;//记录旧的点击位置

@property(nonatomic,assign) NSInteger newNumber;//记录新的点击位置

@property(nonatomic,strong)CheckMsgList *nameBody;//影像数据

@property(nonatomic,strong)PortraitBody *imageModel;

@property(nonatomic,copy)NSString *storeName;

@end
