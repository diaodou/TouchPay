//
//  CashLoanReceivablesTableViewCell.h
//  newHaierCash
//
//  Created by 百思为科 on 2017/6/2.
//  Copyright © 2017年 haier. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HCCashLoanReceivablesTableViewCell : UITableViewCell

@property (nonatomic, strong)UIImageView *cardImage;   //银行卡图标

@property (nonatomic, strong)UILabel * cardNameLabel;  //银行卡名

@property (nonatomic, strong)UILabel * cardNumberLabel;//银行卡号
@end
