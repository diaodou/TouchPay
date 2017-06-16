//
//  PayHistoryTableViewCell.h
//  newHaierCash
//
//  Created by 张久健 on 2017/6/2.
//  Copyright © 2017年 haier. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PayHistoryTableViewCell : UITableViewCell
@property (strong, nonatomic) UILabel *returnMoneyLabel;//还款类型
@property (strong, nonatomic) UILabel *timeLabel;//还款日期
@property (strong, nonatomic) UILabel *moneyLabel;//还款金额
@property (strong, nonatomic) UILabel *stateLabel;//还款状态
@property (strong, nonatomic) UIImageView *typeImageView;//类型图标
@end
