//
//  HCSpecialLoanTableViewCell.h
//  newHaierCash
//
//  Created by 百思为科 on 2017/6/6.
//  Copyright © 2017年 haier. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HCSpecialLoanTableViewCell : UITableViewCell

@property (nonatomic,strong)UIImageView * bottomImage; //背景图

@property (nonatomic,strong)UILabel * titleLabel;   //类别

@property (nonatomic,strong)UILabel * introduceLabel; //介绍

@property (nonatomic,strong)UIButton * applyBtn;   //立即申请

@end
