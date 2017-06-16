//
//  BorrowingMethodsTableViewCell.h
//  newHaierCash
//
//  Created by 百思为科 on 2017/6/6.
//  Copyright © 2017年 haier. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HCBorrowingMethodsTableViewCell : UITableViewCell

@property (nonatomic,strong)UILabel * timeLabel;   //左上角 时间
@property (nonatomic,strong)UILabel * typeLabel;   //左下角 方式
@property (nonatomic,strong)UILabel * interestLabel;  //右边 利息
@end
