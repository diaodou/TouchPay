//
//  HCMessageCenterTableViewCell.h
//  newHaierCash
//
//  Created by 百思为科 on 2017/6/7.
//  Copyright © 2017年 haier. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HCMessageCenterTableViewCell : UITableViewCell

@property (nonatomic, strong)UILabel * titleLabel;  //标题
@property (nonatomic, strong)UILabel * timeLabel;   //时间
@property (nonatomic, strong)UILabel * contentLabel;//内容
@property (nonatomic, strong)UIView *circularView;  //图标
@end
