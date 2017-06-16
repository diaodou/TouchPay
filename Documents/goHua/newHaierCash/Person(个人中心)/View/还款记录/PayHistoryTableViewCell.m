//
//  PayHistoryTableViewCell.m
//  newHaierCash
//
//  Created by 张久健 on 2017/6/2.
//  Copyright © 2017年 haier. All rights reserved.
//

#import "PayHistoryTableViewCell.h"
#import "HCMacro.h"
#import "UIFont+AppFont.h"
CGFloat _viewScale;//适配比例

@implementation PayHistoryTableViewCell

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
        _viewScale = iphone6P ? scale6PAdapter : scaleAdapter;
        [self setUI];
    }
    return self;
}
#pragma Mark - private Methods
- (void)setUI{
    UIView * bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DeviceWidth, 71.5 *_viewScale)];
    
    bottomView.backgroundColor = [UIColor whiteColor];
    
    [self.contentView addSubview:bottomView];
    
    _typeImageView = [[UIImageView alloc]initWithFrame:CGRectMake(15*_viewScale, 19*_viewScale, 26*_viewScale, 20*_viewScale)];
    [bottomView addSubview:_typeImageView];
    
    _returnMoneyLabel = [[UILabel alloc]initWithFrame:CGRectMake(5*_viewScale, 41*_viewScale, 46*_viewScale, 14*_viewScale)];
    
    _returnMoneyLabel.font = [UIFont appFontRegularOfSize:12];
    
    _returnMoneyLabel.textAlignment = NSTextAlignmentCenter;
    
    [bottomView addSubview:_returnMoneyLabel];
    
    _timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(DeviceWidth-120*_viewScale, 29*_viewScale, 105*_viewScale, 14*_viewScale)];
    
    _timeLabel.textColor = UIColorFromRGB(0x999999, 1.0);
    
    _timeLabel.font = [UIFont appFontRegularOfSize:11];
    
    _timeLabel.textAlignment = NSTextAlignmentRight;
    
    [bottomView addSubview:_timeLabel];
    
    _moneyLabel = [[UILabel alloc]initWithFrame:CGRectMake(80*_viewScale, 17*_viewScale, DeviceWidth-200*_viewScale, 14*_viewScale)];
    
    _moneyLabel.textColor = UIColorFromRGB(0x333333, 1.0);
    
    _moneyLabel.font = [UIFont appFontRegularOfSize:12];
    
    _moneyLabel.textAlignment = NSTextAlignmentLeft;
    
    [bottomView addSubview:_moneyLabel];
    
    _stateLabel = [[UILabel alloc]initWithFrame:CGRectMake(80*_viewScale, 42*_viewScale, DeviceWidth-200*_viewScale, 14*_viewScale)];
    
    _stateLabel.textColor = UIColorFromRGB(0x999999, 1.0);
    
    _stateLabel.font = [UIFont appFontRegularOfSize:12];
    
    _stateLabel.textAlignment = NSTextAlignmentLeft;
    
    [bottomView addSubview:_stateLabel];


}


@end
