//
//  CashLoanCostTableViewCell.m
//  newHaierCash
//
//  Created by 百思为科 on 2017/6/2.
//  Copyright © 2017年 haier. All rights reserved.
//

#import "HCCashLoanCostTableViewCell.h"
#import "HCMacro.h"
#import "UIFont+AppFont.h"
@implementation HCCashLoanCostTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
#pragma mark - lift cycle
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self setUI];
    }
    return self;
}
#pragma mark - private Methods
- (void)setUI{
    if (iphone6P) {
        
        UIView * bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DeviceWidth, 50)];
        
        bottomView.backgroundColor = [UIColor whiteColor];
        
        [self.contentView addSubview:bottomView];
        
        UILabel * fixedLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, 100, 50)];
        fixedLabel.font = [UIFont appFontRegularOfSize:15];
        fixedLabel.text = @"息费总额";
        fixedLabel.textColor = UIColorFromRGB(0x333333, 1.0);
        fixedLabel.textAlignment = NSTextAlignmentLeft;
        [bottomView addSubview:fixedLabel];
        
        _costLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, DeviceWidth - 15, 50)];
        
        _costLabel.font = [UIFont appFontRegularOfSize:15];
        
        _costLabel.textAlignment = NSTextAlignmentRight;
        
        _costLabel.textColor = UIColorFromRGB(0x666666, 1.0);
        
        [bottomView addSubview:_costLabel];
    }else{
        
        float x = DeviceWidth/375;
        
        UIView * bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DeviceWidth, 44 *x)];
        
        bottomView.backgroundColor = [UIColor whiteColor];
        
        [self.contentView addSubview:bottomView];
        
        UILabel * fixedLabel = [[UILabel alloc]initWithFrame:CGRectMake(14 *x, 0, 100 *x, 44 *x)];
        fixedLabel.font = [UIFont appFontRegularOfSize:15 *x];
        fixedLabel.text = @"息费总额";
        fixedLabel.textColor = UIColorFromRGB(0x333333, 1.0);
        
        [bottomView addSubview:fixedLabel];
        
        _costLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(fixedLabel.frame) + 10 *x, 0, DeviceWidth - CGRectGetMaxX(fixedLabel.frame) - 40 *x, 44 *x)];
        
        _costLabel.font = [UIFont appFontRegularOfSize:15 *x];
        
        _costLabel.textAlignment = NSTextAlignmentRight;
        
        _costLabel.textColor = UIColorFromRGB(0x666666, 1.0);
        
        [bottomView addSubview:_costLabel];
    }
}
@end
