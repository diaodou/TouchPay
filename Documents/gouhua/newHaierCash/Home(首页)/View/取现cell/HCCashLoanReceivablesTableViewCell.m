//
//  CashLoanReceivablesTableViewCell.m
//  newHaierCash
//
//  Created by 百思为科 on 2017/6/2.
//  Copyright © 2017年 haier. All rights reserved.
//

#import "HCCashLoanReceivablesTableViewCell.h"
#import "HCMacro.h"
#import "UIFont+AppFont.h"
@implementation HCCashLoanReceivablesTableViewCell

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
#pragma Mark - private Methods
- (void)setUI{
    if (iphone6P) {
        UIView * bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DeviceWidth, 73)];
        bottomView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:bottomView];
        
        _cardImage = [[UIImageView alloc]initWithFrame:CGRectMake(15, 19, 35, 40)];
                
        [bottomView addSubview:_cardImage];
        
        UILabel * fixedLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_cardImage.frame) + 20, 19, 100, 15)];
        
        fixedLabel.text = @"收款账户";
        
        fixedLabel.textColor = UIColorFromRGB(0x333333, 1.0);
        
        fixedLabel.font = [UIFont appFontRegularOfSize:15];
        
        [bottomView addSubview:fixedLabel];
        
        _cardNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_cardImage.frame) + 20, CGRectGetMaxY(fixedLabel.frame) + 10, DeviceWidth - CGRectGetMaxX(_cardImage.frame) - 40, 15)];
        
        _cardNameLabel.font = [UIFont appFontRegularOfSize:14];
        
        _cardNameLabel.textColor = UIColorFromRGB(0x666666, 1.0);
        
        [bottomView addSubview:_cardNameLabel];
        
        _cardNumberLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, DeviceWidth - 30, 73)];
        
        _cardNumberLabel.font = [UIFont appFontRegularOfSize:14];
        
        _cardNumberLabel.textAlignment = NSTextAlignmentRight;
        
        _cardNumberLabel.textColor = UIColorFromRGB(0x666666, 1.0);
        
        [bottomView addSubview:_cardNumberLabel];
        
        UIImageView * arrowImage = [[UIImageView alloc]initWithFrame:CGRectMake(DeviceWidth - 23, 30, 8, 13)];
        
        arrowImage.image = [UIImage imageNamed:@"箭头"];
        
        [bottomView addSubview:arrowImage];

    }else{
        
        float x = DeviceWidth/375;
        
        UIView * bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DeviceWidth, 66 *x)];
        bottomView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:bottomView];
        
        _cardImage = [[UIImageView alloc]initWithFrame:CGRectMake(14 *x, 14.5 *x, 37 *x, 37 *x)];
        
        [bottomView addSubview:_cardImage];
        
        UILabel * fixedLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_cardImage.frame) + 18 *x, 14.5 *x, 100 *x, 15 *x)];
        
        fixedLabel.text = @"收款账户";
        
        fixedLabel.textColor = UIColorFromRGB(0x333333, 1.0);
        
        fixedLabel.font = [UIFont appFontRegularOfSize:14 *x];
        
        [bottomView addSubview:fixedLabel];
        
        _cardNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_cardImage.frame) + 18 *x, CGRectGetMaxY(fixedLabel.frame) + 5 *x, DeviceWidth - CGRectGetMaxX(_cardImage.frame) - 58 *x, 20 *x)];
        
        _cardNameLabel.font = [UIFont appFontRegularOfSize:12 *x];
        
        _cardNameLabel.textColor = UIColorFromRGB(0x666666, 1.0);
        
        [bottomView addSubview:_cardNameLabel];
        
        _cardNumberLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, DeviceWidth - 31 *x, 66 *x)];
        
        _cardNumberLabel.font = [UIFont appFontRegularOfSize:14 *x];
        
        _cardNumberLabel.textAlignment = NSTextAlignmentRight;
        
        _cardNumberLabel.textColor = UIColorFromRGB(0x666666, 1.0);
        
        [bottomView addSubview:_cardNumberLabel];
        
        UIImageView * arrowImage = [[UIImageView alloc]initWithFrame:CGRectMake(DeviceWidth - 21 *x, 27 *x, 7 *x, 12 *x)];
        
        arrowImage.image = [UIImage imageNamed:@"箭头"];
        
        [bottomView addSubview:arrowImage];
    }
    
}
@end
