//
//  HCListTableViewCell.m
//  newHaierCash
//
//  Created by 百思为科 on 2017/5/31.
//  Copyright © 2017年 haier. All rights reserved.
//

#import "HCMacro.h"
#import "UIColor+DefineNew.h"
#import "UIFont+AppFont.h"

#import "HCListTableViewCell.h"

@implementation HCListTableViewCell

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
        
        _listImage = [[UIImageView alloc]initWithFrame:CGRectMake(15, 15, 21, 21)];
        
        [bottomView addSubview:_listImage];
        
        _listLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_listImage.frame) + 30, 0, DeviceWidth - 69, 50)];
        
        _listLabel.font = [UIFont appFontRegularOfSize:15];
        
        [bottomView addSubview:_listLabel];
        
        _lineView = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMinX(_listLabel.frame), 49.5, DeviceWidth - 69, 1)];
        
        _lineView.backgroundColor = [UIColor UIColorWithHexColorString:@"0xdddddd" AndAlpha:1.0];
        
        _lineView.hidden = YES;
        
        [bottomView addSubview:_lineView];
        
        _arrowImage = [[UIImageView alloc]initWithFrame:CGRectMake(DeviceWidth - 25, 18.5, 8, 13)];
        
        _arrowImage.image = [UIImage imageNamed:@"箭头"];
        
        [bottomView addSubview:_arrowImage];
    }else{
        
        float x = DeviceWidth/375;
        
        UIView * bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DeviceWidth, 44 *x)];
        
        bottomView.backgroundColor = [UIColor whiteColor];
        
        [self.contentView addSubview:bottomView];
        
        _listImage = [[UIImageView alloc]initWithFrame:CGRectMake(15 *x, 11 *x, 20 *x, 20 *x)];
        
        [bottomView addSubview:_listImage];
        
        _listLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_listImage.frame) + 20 *x, 0, DeviceWidth - 69 *x, 44 *x)];
        
        _listLabel.font = [UIFont appFontRegularOfSize:15 *x];
        
        _listLabel.textColor = [UIColor UIColorWithHexColorString:@"0x333333" AndAlpha:1.0];
        
        [bottomView addSubview:_listLabel];
        
        _lineView = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMinX(_listLabel.frame), 43.5 *x, DeviceWidth - 63 *x, 1 *x)];
        
        _lineView.backgroundColor = [UIColor UIColorWithHexColorString:@"0xdddddd" AndAlpha:1.0];
        
        _lineView.hidden = YES;
        
        [bottomView addSubview:_lineView];
        
        _arrowImage = [[UIImageView alloc]initWithFrame:CGRectMake(DeviceWidth - 25 *x, 15.5 *x, 8 *x, 13 *x)];
        
        _arrowImage.image = [UIImage imageNamed:@"箭头"];
        
        [bottomView addSubview:_arrowImage];
    }
    
}
@end
