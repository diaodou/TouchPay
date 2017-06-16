//
//  PeosonInfoType.h
//  HaiFu
//
//  Created by 史长硕 on 17/2/8.
//  Copyright © 2017年 百思为科. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PeosonInfoType : NSObject

@property(nonatomic,assign)BOOL isOpen;//是否需要展开

@property(nonatomic,assign)BOOL isFinish;//信息是否已经完善

@property(nonatomic,copy)NSString *showType;//记录是哪一分组

@property(nonatomic,copy)NSString *title;//名称标题

@end
