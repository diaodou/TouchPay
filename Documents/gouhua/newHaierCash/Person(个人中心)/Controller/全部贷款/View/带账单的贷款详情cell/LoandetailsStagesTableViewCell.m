//
//  LoandetailsStagesTableViewCell.m
//  personMerchants
//
//  Created by Apple on 16/3/18.
//  Copyright © 2016年 海尔金融. All rights reserved.
//

#import "LoandetailsStagesTableViewCell.h"
#import "RMUniversalAlert.h"
@implementation LoandetailsStagesTableViewCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    [self.iconBtn setImage:[UIImage imageNamed:@"图标_未选中"] forState:UIControlStateNormal];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
@end
