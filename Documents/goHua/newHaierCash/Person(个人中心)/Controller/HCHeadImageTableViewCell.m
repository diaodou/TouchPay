//
//  HCHeadImageTableViewCell.m
//  newHaierCash
//
//  Created by 百思为科 on 2017/5/27.
//  Copyright © 2017年 haier. All rights reserved.
//

#import "HCMacro.h"
#import "UIColor+DefineNew.h"
#import "UIFont+AppFont.h"
#import "HCHeadImageTableViewCell.h"

@implementation HCHeadImageTableViewCell

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
        
        UIView * bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DeviceWidth, 98)];
        
        bottomView.backgroundColor = [UIColor whiteColor];
        
        [self.contentView addSubview:bottomView];
        
        _headImageView = [[UIImageView alloc]initWithFrame:CGRectMake(15, 15, 65, 65)];
        
        _headImageView.layer.cornerRadius = 32.5;
        // 超出部分截取
        _headImageView.layer.masksToBounds = YES;

        [bottomView addSubview:_headImageView];
        
        UIImageView * fixImageView = [[UIImageView alloc]initWithFrame:CGRectMake(60, 60, 22, 22)];
        
        fixImageView.image = [UIImage imageNamed:@"钻石"];
        
        [bottomView addSubview:fixImageView];
        
        _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(100, 27, 150, 20)];
        
        _nameLabel.font = [UIFont appFontRegularOfSize:16];
        
        _nameLabel.textColor = [UIColor UIColorWithHexColorString:@"0x333333" AndAlpha:1.0];
        
        [bottomView addSubview:_nameLabel];
        
        _numberLabel = [[UILabel alloc]initWithFrame:CGRectMake(100, CGRectGetMaxY(_nameLabel.frame) + 11, DeviceWidth - 130, 15)];
        
        _numberLabel.font = [UIFont appFontRegularOfSize:11];
        
        _numberLabel.textColor = [UIColor UIColorWithHexColorString:@"0x999999" AndAlpha:1.0];
        
        [bottomView addSubview:_numberLabel];
        
        UIImageView * arrowImage = [[UIImageView alloc]initWithFrame:CGRectMake(DeviceWidth - 25, 42, 8, 13)];
        
        arrowImage.image = [UIImage imageNamed:@"箭头"];
        
        [bottomView addSubview:arrowImage];
        
        _loginLabel = [[UILabel alloc]initWithFrame:CGRectMake(100, 38, 100, 30)];
        
        _loginLabel.text = @"登录/注册";
        
        _loginLabel.textColor = UIColorFromRGB(0x333333, 1.0);
        
        _loginLabel.font = [UIFont appFontRegularOfSize:14];
        
        [bottomView addSubview:_loginLabel];
    }else{
        
        float x = DeviceWidth/375;
        
        UIView * bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DeviceWidth, 65 *x)];
        
        bottomView.backgroundColor = [UIColor whiteColor];
        
        [self.contentView addSubview:bottomView];
        
        _headImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10 *x, 10 *x, 45 *x, 45 *x)];
        
        _headImageView.layer.cornerRadius = 22.5 *x;
        // 超出部分截取
        _headImageView.layer.masksToBounds = YES;
        
        [bottomView addSubview:_headImageView];
        
        UIImageView * fixImageView = [[UIImageView alloc]initWithFrame:CGRectMake(38 *x, 38 *x, 20 *x, 20 *x)];
        
        fixImageView.image = [UIImage imageNamed:@"钻石"];
        
        [bottomView addSubview:fixImageView];
        
        _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(67 *x, 14 *x, 150 *x, 18 *x)];
        
        _nameLabel.font = [UIFont appFontRegularOfSize:15 *x];
        
        _nameLabel.textColor = [UIColor UIColorWithHexColorString:@"0x333333" AndAlpha:1.0];
        
        [bottomView addSubview:_nameLabel];
        
        _numberLabel = [[UILabel alloc]initWithFrame:CGRectMake(67 *x, CGRectGetMaxY(_nameLabel.frame) + 5 *x, DeviceWidth - 67 *x, 15 *x)];
        
        _numberLabel.font = [UIFont appFontRegularOfSize:11 *x];
        
        _numberLabel.textColor = [UIColor UIColorWithHexColorString:@"0x999999" AndAlpha:1.0];
        
        [bottomView addSubview:_numberLabel];
        
        UIImageView * arrowImage = [[UIImageView alloc]initWithFrame:CGRectMake(DeviceWidth - 16 *x, 28 *x, 7 *x, 12 *x)];
        
        arrowImage.image = [UIImage imageNamed:@"箭头"];
        
        [bottomView addSubview:arrowImage];
        
        _loginLabel = [[UILabel alloc]initWithFrame:CGRectMake(67 *x, 22.5 *x, 100 *x, 20 *x)];
        
        _loginLabel.text = @"登录/注册";
        
        _loginLabel.textColor = UIColorFromRGB(0x333333, 1.0);
        
        _loginLabel.font = [UIFont appFontRegularOfSize:14];
        
        [bottomView addSubview:_loginLabel];
    }
    
    
}

@end
