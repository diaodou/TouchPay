//
//  HCAddBankTableViewCell.m
//  newHaierCash
//
//  Created by 百思为科 on 2017/6/12.
//  Copyright © 2017年 haier. All rights reserved.
//

#import "HCAddBankTableViewCell.h"
#import "HCMacro.h"
#import "UIFont+AppFont.h"
@implementation HCAddBankTableViewCell

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
        UIView * bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DeviceWidth, 100)];
        
        UIView * bjView = [[UIView alloc]initWithFrame:CGRectMake(15, 0, DeviceWidth - 30, 90)];
        
        bjView.layer.cornerRadius = 3;
        
        bjView.layer.borderWidth = 0.3;
        
        bjView.layer.borderColor = UIColorFromRGB(0x999999, 1.0).CGColor;
        
        [bottomView addSubview:bjView];

        _leftImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 6, 90)];
        
        [bjView addSubview:_leftImage];
        
        _logoImage = [[UIImageView alloc]initWithFrame:CGRectMake(18, 15, 29, 29)];
        
        [bjView addSubview:_logoImage];
        
        _bankNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_logoImage.frame) + 20, 15, DeviceWidth - CGRectGetMaxX(_logoImage.frame) - 20, 14)];
        
        _bankNameLabel.font = [UIFont appFontRegularOfSize:14];
        
        [bjView addSubview:_bankNameLabel];
        
        _bankTypeLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_logoImage.frame) + 20, CGRectGetMaxY(_bankNameLabel.frame) + 9, DeviceWidth - CGRectGetMaxX(_logoImage.frame) - 20, 14)];
        
        _bankTypeLabel.font = [UIFont appFontRegularOfSize:14];
        
        [bjView addSubview:_bankTypeLabel];
        
        _bankNumberLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_logoImage.frame) + 20, CGRectGetMaxY(_bankTypeLabel.frame) + 13, DeviceWidth - CGRectGetMaxX(_logoImage.frame) - 20, 14)];
        
        _bankNumberLabel.font = [UIFont appFontRegularOfSize:14];
        
        [bjView addSubview:_bankNumberLabel];
        
        [self.contentView addSubview:bottomView];
        
        _defaultImage = [[UIImageView alloc]initWithFrame:CGRectMake(DeviceWidth - 30 - 40, 0, 40, 40)];
        
        _defaultImage.image = [UIImage imageNamed:@"还款卡_默认"];
        
        [bjView addSubview:_defaultImage];
    }else{
        
        CGFloat x = DeviceWidth/375;
        
        UIView * bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DeviceWidth, 91 *x)];
        
        [self.contentView addSubview:bottomView];

        UIView * bjView = [[UIView alloc]initWithFrame:CGRectMake(15 *x, 0, DeviceWidth - 30 *x, 82 *x)];
        
        bjView.layer.cornerRadius = 3;
        
        bjView.layer.borderWidth = .5;
        
        bjView.layer.borderColor = UIColorFromRGB(0x999999, 1.0).CGColor;
        
        [bottomView addSubview:bjView];
        
        _leftImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 6 *x, 82 *x)];
        
        [bjView addSubview:_leftImage];
        
        _logoImage = [[UIImageView alloc]initWithFrame:CGRectMake(13 *x, 13 *x, 26 *x, 26 *x)];
        
        [bjView addSubview:_logoImage];
        
        _bankNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_logoImage.frame) + 18 *x, 14 *x, DeviceWidth - CGRectGetMaxX(_logoImage.frame) - 18 *x, 13 *x)];
        
        _bankNameLabel.font = [UIFont appFontRegularOfSize:12 *x];
        
        [bjView addSubview:_bankNameLabel];
        
        _bankTypeLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_logoImage.frame) + 18 *x, CGRectGetMaxY(_bankNameLabel.frame) + 8 *x, DeviceWidth - CGRectGetMaxX(_logoImage.frame) - 18 *x, 13 *x)];
        
        _bankTypeLabel.font = [UIFont appFontRegularOfSize:12 *x];
        
        [bjView addSubview:_bankTypeLabel];
        
        _bankNumberLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_logoImage.frame) + 18 *x, CGRectGetMaxY(_bankTypeLabel.frame) + 11 *x, DeviceWidth - CGRectGetMaxX(_logoImage.frame) - 18 *x, 13 *x)];
        
        _bankNumberLabel.font = [UIFont appFontRegularOfSize:12 *x];
        
        [bjView addSubview:_bankNumberLabel];
        
        
        _defaultImage = [[UIImageView alloc]initWithFrame:CGRectMake(DeviceWidth - 30*x - 36*x, 0, 36*x, 36*x)];
        
        _defaultImage.image = [UIImage imageNamed:@"还款卡_默认"];
        
        [bjView addSubview:_defaultImage];
    }
}
@end
