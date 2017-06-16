//
//  HCOrderInfoCell.m
//  newHaierCash
//
//  Created by Will on 2017/6/15.
//  Copyright © 2017年 haier. All rights reserved.
//

#import "HCMacro.h"
#import "UIColor+DefineNew.h"

#import "HCOrderInfoCell.h"
@interface HCOrderInfoCell() {
    UILabel *_titleLbl;
    UILabel *_typeLbl;
    UILabel *_infoLbl;
    UIImageView *_moreInfoImg;
    
    CGFloat _viewScale;
}

@end

@implementation HCOrderInfoCell

- (void)generateCellWithTitle:(NSString *)title andType:(NSString *)type andInfo:(NSString *)info andHiddenImg:(BOOL)isHidden {
    _titleLbl.text = title;
    _typeLbl.text = type;
    _infoLbl.text = info;
    [_moreInfoImg setHidden:isHidden];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _viewScale = iphone6P ? scale6PAdapter : scaleAdapter;

        _titleLbl = [[UILabel alloc]init];
        _titleLbl.font = [UIFont systemFontOfSize:14 * _viewScale];
        [self.contentView addSubview:_titleLbl];
        
        _typeLbl = [[UILabel alloc]init];
        _typeLbl.textAlignment = NSTextAlignmentRight;
        _typeLbl.font = [UIFont systemFontOfSize:11 * _viewScale];
        [self.contentView addSubview:_typeLbl];
        
        _infoLbl = [[UILabel alloc]init];
        _infoLbl.font = [UIFont systemFontOfSize:12 * _viewScale];
        _infoLbl.textColor = [UIColor UIColorWithHexColorString:@"0x5e5d5d" AndAlpha:1];
        [self.contentView addSubview:_infoLbl];
        
        //            箭头
        _moreInfoImg = [[UIImageView alloc]init];
        _moreInfoImg.image = [UIImage imageNamed:@"箭头"];
        [self.contentView addSubview:_moreInfoImg];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    _titleLbl.frame = CGRectMake(15 * _viewScale, 10 * _viewScale, 95 * _viewScale, 14 * _viewScale);
    
    _moreInfoImg.frame = CGRectMake(DeviceWidth - 23 * _viewScale, 22 * _viewScale, 8 * _viewScale, 16 * _viewScale);
    _typeLbl.frame = CGRectMake(115 * _viewScale, 12 * _viewScale, DeviceWidth - 145 * _viewScale, 12 * _viewScale);
    
    _infoLbl.frame = CGRectMake(CGRectGetMinX(_titleLbl.frame), CGRectGetMaxY(_typeLbl.frame) + 12, DeviceWidth - 45 * _viewScale, 12 * _viewScale);
}

@end
