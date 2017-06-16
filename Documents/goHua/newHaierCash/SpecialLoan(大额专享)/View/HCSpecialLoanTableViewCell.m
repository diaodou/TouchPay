//
//  HCSpecialLoanTableViewCell.m
//  newHaierCash
//
//  Created by 百思为科 on 2017/6/6.
//  Copyright © 2017年 haier. All rights reserved.
//

#import "HCSpecialLoanTableViewCell.h"
#import "HCMacro.h"
#import "UIFont+AppFont.h"
@implementation HCSpecialLoanTableViewCell

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
        UIView * bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DeviceWidth, 152)];
        
        [self.contentView addSubview:bottomView];
        
        _bottomImage = [[UIImageView alloc]initWithFrame:CGRectMake(15, 10, DeviceWidth - 26, 142)];
        
        _bottomImage.layer.cornerRadius = 5;
        
        _bottomImage.layer.masksToBounds = YES;
        
        _bottomImage.userInteractionEnabled = YES;
        
        [self.contentView addSubview:_bottomImage];
        
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(32, 30, DeviceWidth, 25)];
        
        _titleLabel.font = [UIFont appFontBoldOfSize:20];
        
        [_bottomImage addSubview: _titleLabel];
        
        _introduceLabel = [[UILabel alloc]initWithFrame:CGRectMake(32, CGRectGetMaxY(_titleLabel.frame) + 7, DeviceWidth, 16)];
                
        _introduceLabel.font = [UIFont appFontRegularOfSize:15];
        
        _introduceLabel.textColor = [UIColor whiteColor];
        
        [_bottomImage addSubview:_introduceLabel];
        
        _applyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        _applyBtn.frame = CGRectMake(32, CGRectGetMaxY(_introduceLabel.frame) + 14, 90, 32);
        
        _applyBtn.layer.cornerRadius = 16;
                
        [_bottomImage addSubview:_applyBtn];
    }else{
        UIView * bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DeviceWidth, 138)];
        
        [self.contentView addSubview:bottomView];
        
        _bottomImage = [[UIImageView alloc]initWithFrame:CGRectMake(13, 9.5, DeviceWidth - 26, 129)];
        
        _bottomImage.layer.cornerRadius = 5;
        
        _bottomImage.layer.masksToBounds = YES;
        
        _bottomImage.userInteractionEnabled = YES;
        
        [self.contentView addSubview:_bottomImage];
        
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(28, 27, DeviceWidth - 28 - 26, 25)];
        
        _titleLabel.font = [UIFont appFontBoldOfSize:18];
        
        [_bottomImage addSubview: _titleLabel];
        
        _introduceLabel = [[UILabel alloc]initWithFrame:CGRectMake(28, CGRectGetMaxY(_titleLabel.frame) + 6, DeviceWidth - 26 - 28, 15)];
        
        _introduceLabel.font = [UIFont appFontRegularOfSize:12];
        
        _introduceLabel.textColor = [UIColor whiteColor];
        
        [_bottomImage addSubview:_introduceLabel];
        
        _applyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        _applyBtn.frame = CGRectMake(28, CGRectGetMaxY(_introduceLabel.frame) + 13, 81, 29);
        
        _applyBtn.layer.cornerRadius = 14.5;
                
        [_bottomImage addSubview:_applyBtn];
    }
}
@end
