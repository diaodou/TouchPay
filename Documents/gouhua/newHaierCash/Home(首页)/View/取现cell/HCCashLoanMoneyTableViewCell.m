//
//  CashLoanMoneyTableViewCell.m
//  newHaierCash
//
//  Created by 百思为科 on 2017/6/2.
//  Copyright © 2017年 haier. All rights reserved.
//

#import "HCCashLoanMoneyTableViewCell.h"
#import "HCMacro.h"
#import "UIFont+AppFont.h"
@implementation HCCashLoanMoneyTableViewCell

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

#pragma mark - pricate Methods
- (void)setUI{

    if (iphone6P) {
        
        UIView * bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DeviceWidth, 103)];
        
        bottomView.backgroundColor = [UIColor whiteColor];
        
        [self.contentView addSubview:bottomView];
        
        
        
        UILabel * fixedLabel = [[UILabel alloc]initWithFrame:CGRectMake(16, 13, 60, 15)];
        fixedLabel.font = [UIFont appFontRegularOfSize:15];
        fixedLabel.text = @"金额";
        fixedLabel.textColor = UIColorFromRGB(0x999999, 1.0);
        fixedLabel.textAlignment = NSTextAlignmentLeft;
        [bottomView addSubview:fixedLabel];
        
        _moneyTextField = [[UITextField alloc]initWithFrame:CGRectMake(16, CGRectGetMaxY(fixedLabel.frame) + 24, DeviceWidth - 36, 30)];
        
        _moneyTextField.textColor = UIColorFromRGB(0x666666, 1.0);
        
        _moneyTextField.font = [UIFont systemFontOfSize:27];
        
        _moneyTextField.keyboardType = UIKeyboardTypeDecimalPad;
        
        _moneyTextField.leftViewMode = UITextFieldViewModeAlways;
        [bottomView addSubview:_moneyTextField];
        
        UILabel * rightLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 20, 30)];
        
        rightLabel.text = @"¥";
        
        rightLabel.font = [UIFont systemFontOfSize:27];
        
        rightLabel.textColor = UIColorFromRGB(0x666666, 1.0);

        _moneyTextField.leftView = rightLabel;
    }else{
        
        float x = DeviceWidth/375;
        
        UIView * bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DeviceWidth, 93 *x)];
        
        bottomView.backgroundColor = [UIColor whiteColor];
        
        [self.contentView addSubview:bottomView];
        
        UILabel * fixedLabel = [[UILabel alloc]initWithFrame:CGRectMake(14 *x, 12 *x, 60*x, 16*x)];
        fixedLabel.font = [UIFont appFontRegularOfSize:15*x];
        fixedLabel.text = @"金额";
        fixedLabel.textColor = UIColorFromRGB(0x999999, 1.0);
        
        [bottomView addSubview:fixedLabel];
        
        _moneyTextField = [[UITextField alloc]initWithFrame:CGRectMake(14, CGRectGetMaxY(fixedLabel.frame) + 16 *x, DeviceWidth - 30 *x, 30 *x)];
        
        _moneyTextField.textColor = UIColorFromRGB(0x666666, 1.0);
        
        _moneyTextField.font = [UIFont systemFontOfSize:25 *x];
        
        _moneyTextField.keyboardType = UIKeyboardTypeDecimalPad;
        
        _moneyTextField.leftViewMode = UITextFieldViewModeAlways;

        [bottomView addSubview:_moneyTextField];
        
        UILabel * rightLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 20 *x, 30 *x)];
        
        rightLabel.text = @"¥";
        
        rightLabel.textColor = UIColorFromRGB(0x666666, 1.0);
        
        rightLabel.font = [UIFont systemFontOfSize:25 *x];
        
        _moneyTextField.leftView = rightLabel;
    }
    
}
@end
