//
//  ApprovalProgressTableViewCell.m
//  newHaierCash
//
//  Created by 张久健 on 2017/6/5.
//  Copyright © 2017年 haier. All rights reserved.
//

#import "ApprovalProgressTableViewCell.h"
#import "HCMacro.h"
#import "UIFont+AppFont.h"
@implementation ApprovalProgressTableViewCell

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
    UIView * bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DeviceWidth, 66)];
    bottomView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:bottomView];
    
    _roundView =[[UIView alloc]initWithFrame:CGRectMake(26, 28, 14, 14)];
    _roundView.layer.cornerRadius = 7.0f;
    _roundView.backgroundColor = UIColorFromRGB(0xd9d9d9, 1);
    [bottomView addSubview:_roundView];
    
    _oneView = [[UIView alloc]initWithFrame:CGRectMake(33, 0, 1, 28)];
    _oneView.backgroundColor = UIColorFromRGB(0xd9d9d9, 1);
    [bottomView addSubview:_oneView];
    
    _twoView = [[UIView alloc]initWithFrame:CGRectMake(33, 42, 1, 24)];
    _twoView.backgroundColor = UIColorFromRGB(0xd9d9d9, 1);
    [bottomView addSubview:_twoView];
    
    _wfiNodeName = [[UILabel alloc]initWithFrame:CGRectMake(57, 26, 110, 16)];
    _wfiNodeName.textColor = UIColorFromRGB(0x333333, 1.0);
    _wfiNodeName.font = [UIFont appFontRegularOfSize:15];
    _wfiNodeName.textAlignment = NSTextAlignmentLeft;
    [bottomView addSubview:_wfiNodeName];
    
    _timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(57, 52, 200, 12)];
    _timeLabel.textColor = UIColorFromRGB(0x999999, 1.0);
    _timeLabel.font = [UIFont appFontRegularOfSize:11];
    _timeLabel.textAlignment = NSTextAlignmentLeft;
    [bottomView addSubview:_timeLabel];
}


@end
