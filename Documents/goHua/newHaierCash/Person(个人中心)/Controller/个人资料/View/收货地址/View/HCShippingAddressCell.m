//
//  HCShippingAddressCell.m
//  newHaierCash
//
//  Created by BSVK on 2017/6/13.
//  Copyright © 2017年 haier. All rights reserved.
//

#import "HCShippingAddressCell.h"
#import "HCMacro.h"
#import "UIColor+DefineNew.h"

@implementation HCShippingAddressCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

#pragma mark --init method

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if([super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        [self creatUI];
    }
    return self;
}

-(void)creatUI{
    if (iphone6P) {
        _nameLbl = [[UILabel alloc]initWithFrame:CGRectMake(15, 17, 130, 15)];
        _nameLbl.font= [UIFont systemFontOfSize:15];
        _nameLbl.textColor =[UIColor UIColorWithHexColorString:@"#333333" AndAlpha:1];
        [self addSubview:_nameLbl];
        _phoneNumberLbl = [[UILabel alloc]initWithFrame:CGRectMake(150, 17, 120, 15)];
        _phoneNumberLbl.font = [UIFont systemFontOfSize:15];
        _phoneNumberLbl.textColor = [UIColor UIColorWithHexColorString:@"#333333" AndAlpha:1];
        [self addSubview:_phoneNumberLbl];
        _adressLbl = [[UILabel alloc]initWithFrame:CGRectMake(10, 45, DeviceWidth-20, 14)];
        _adressLbl.font = [UIFont systemFontOfSize:14];
        _adressLbl.textColor = [UIColor UIColorWithHexColorString:@"#999999" AndAlpha:1];
        [self addSubview:_adressLbl];
        _defaultImgV = [[UIImageView alloc]initWithFrame:CGRectMake(DeviceWidth-40, 0, 40, 40)];
        _defaultImgV.image = [UIImage imageNamed:@"还款卡_默认"];
//        [self addSubview:_defaultImgV];
        _bottomImgV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 80-6, DeviceWidth, 6)];
//        [self addSubview:_bottomImgV];
        
    }else{
        CGFloat x = DeviceWidth/375;
        _nameLbl = [[UILabel alloc]initWithFrame:CGRectMake(13, 13*x, 120, 14)];
        _nameLbl.font= [UIFont systemFontOfSize:14];
        _nameLbl.textColor =[UIColor UIColorWithHexColorString:@"#333333" AndAlpha:1];
        [self addSubview:_nameLbl];
        _phoneNumberLbl = [[UILabel alloc]initWithFrame:CGRectMake(140, 13*x, 140, 14)];
        _phoneNumberLbl.font= [UIFont systemFontOfSize:15];
        _phoneNumberLbl.textColor =[UIColor UIColorWithHexColorString:@"#333333" AndAlpha:1];
        [self addSubview:_phoneNumberLbl];
        _adressLbl = [[UILabel alloc]initWithFrame:CGRectMake(13, 42*x, DeviceWidth-26, 13)];
        _adressLbl.font = [UIFont systemFontOfSize:13];
        _adressLbl.textColor = [UIColor UIColorWithHexColorString:@"#999999" AndAlpha:1];
        [self addSubview:_adressLbl];
        _defaultImgV = [[UIImageView alloc]initWithFrame:CGRectMake(DeviceWidth-40, 0, 40, 40)];
        _defaultImgV.image = [UIImage imageNamed:@"还款卡_默认"];
//        [self addSubview:_defaultImgV];
        _bottomImgV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 70*x-5*x, DeviceWidth, 5*x)];
//        [self addSubview:_bottomImgV];
        
    }
}

-(void)setMethod{
    _nameLbl.text = @"收件人：XXX";
    _phoneNumberLbl.text = @"1111111111";
    _adressLbl.text = @"山东省青岛市崂山区裕龙国际中心";
    _bottomImgV.image = [UIImage imageNamed:@"地址花边"];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
