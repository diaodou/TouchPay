//
//  CashLoanPlanTableViewCell.m
//  newHaierCash
//
//  Created by 百思为科 on 2017/6/2.
//  Copyright © 2017年 haier. All rights reserved.
//

#import "HCCashLoanPlanTableViewCell.h"
#import "HCMacro.h"
#import "UIFont+AppFont.h"

@implementation HCCashLoanPlanTableViewCell

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
#pragma mark - privte Methods
- (void)setUI{
    if (iphone6P) {
        
        UIView * bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DeviceWidth, 50)];
        
        bottomView.backgroundColor = [UIColor whiteColor];
        
        [self.contentView addSubview:bottomView];
        
        _tapLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, DeviceWidth - 15, 50)];
        
        _tapLabel.text = @"详细还款计划>>";
        
        _tapLabel.textColor = UIColorFromRGB(0x32beff, 1.0);
        
        _tapLabel.font = [UIFont appFontRegularOfSize:14];
        
        _tapLabel.textAlignment = NSTextAlignmentRight;
        
        [bottomView addSubview:_tapLabel];
    }else{
        
        float x = DeviceWidth/375;
        
        UIView * bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DeviceWidth, 44 *x)];
        
        bottomView.backgroundColor = [UIColor whiteColor];
        
        [self.contentView addSubview:bottomView];
        
        _tapLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, DeviceWidth - 14 *x, 44 *x)];
        
        _tapLabel.text = @"详细还款计划>>";
        
        _tapLabel.textColor = UIColorFromRGB(0x32beff, 1.0);
        
        _tapLabel.font = [UIFont appFontRegularOfSize:14 *x];
        
        _tapLabel.textAlignment = NSTextAlignmentRight;
        
        [bottomView addSubview:_tapLabel];
    }
}

@end
