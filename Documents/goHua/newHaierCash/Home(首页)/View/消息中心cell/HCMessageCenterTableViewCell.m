//
//  HCMessageCenterTableViewCell.m
//  newHaierCash
//
//  Created by 百思为科 on 2017/6/7.
//  Copyright © 2017年 haier. All rights reserved.
//

#import "HCMessageCenterTableViewCell.h"
#import "HCMacro.h"
#import "UIFont+AppFont.h"
@implementation HCMessageCenterTableViewCell

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
       
        UIView * bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DeviceWidth, 64)];
        
        bottomView.backgroundColor = [UIColor whiteColor];
        
        [self.contentView addSubview:bottomView];
        
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(55, 10, DeviceWidth - 300, 16)];
        
        _titleLabel.font = [UIFont appFontRegularOfSize:15];
        
        _titleLabel.textColor = UIColorFromRGB(0x000000, 1.0);
        
        [bottomView addSubview:_titleLabel];
        
        _timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(DeviceWidth - 60, 12, 60, 10)];
        
        _timeLabel.font = [UIFont appFontRegularOfSize:9];
        
        _timeLabel.textColor = UIColorFromRGB(0x999999, 1.0);
        
        [bottomView addSubview:_timeLabel];
        
        _contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(55, CGRectGetMaxY(_timeLabel.frame) + 9, DeviceWidth - 65, 13)];
        
        _contentLabel.font = [UIFont appFontRegularOfSize:12];
        
        _contentLabel.textColor = UIColorFromRGB(0x666666, 1.0);
        
        [bottomView addSubview:_contentLabel];
        
        _circularView=[[UIView alloc]initWithFrame:CGRectMake(27, 13, 10, 10)];
        
        _circularView.backgroundColor=UIColorFromRGB(0x028de3, 1);
        
        _circularView.layer.cornerRadius=5;
        
        [bottomView addSubview:_circularView];
    }else{
        
        UIView * bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DeviceWidth, 58)];
        
        bottomView.backgroundColor = [UIColor whiteColor];
        
        [self.contentView addSubview:bottomView];
        
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(55, 8, DeviceWidth - 300, 16)];
        
        _titleLabel.font = [UIFont appFontRegularOfSize:15];
        
        _titleLabel.textColor = UIColorFromRGB(0x000000, 1.0);
        
        [bottomView addSubview:_titleLabel];
        
        _timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(DeviceWidth - 60, 10, 60, 10)];
        
        _timeLabel.font = [UIFont appFontRegularOfSize:9];
        
        _timeLabel.textColor = UIColorFromRGB(0x999999, 1.0);
        
        [bottomView addSubview:_timeLabel];
        
        _contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(55, CGRectGetMaxY(_timeLabel.frame) + 9, DeviceWidth - 65, 13)];
        
        _contentLabel.font = [UIFont appFontRegularOfSize:12];
        
        _contentLabel.textColor = UIColorFromRGB(0x666666, 1.0);
        
        [bottomView addSubview:_contentLabel];
        
        _circularView=[[UIView alloc]initWithFrame:CGRectMake(27, 13, 10, 10)];
        
        _circularView.backgroundColor=UIColorFromRGB(0x028de3, 1);
        
        _circularView.layer.cornerRadius=5;
        
        [bottomView addSubview: _circularView];
    }
}
@end
