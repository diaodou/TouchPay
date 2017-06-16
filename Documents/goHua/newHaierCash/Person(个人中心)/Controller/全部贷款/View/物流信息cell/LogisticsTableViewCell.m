//
//  LogisticsTableViewCell.m
//  物流信息
//
//  Created by 史长硕 on 2017/4/15.
//  Copyright © 2017年 史长硕. All rights reserved.
//

#import "LogisticsTableViewCell.h"
#import "HCMacro.h"
#import "UIFont+AppFont.h"
#import "UILabel+SizeForStr.h"
@interface LogisticsTableViewCell ()
{
    
    UIView *_leftView;//左侧圆圈
    
    UILabel *_timeLabel;//时间label
    
    UILabel *_reasonLabel;//原因label
    
    UILabel *_stateLabel;//当前状态label
    
    UIView *_lineView;//左侧竖线view
    
    float x;
    
}

@end

@implementation LogisticsTableViewCell

#pragma mark --> life Cycle

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        if (iphone6P) {
            
            x = 1;
        }else{
            
            x = scaleAdapter;
        }
        
        [self creatUI];
        
    }
    
    return self;
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark --> private Methods

-(void)creatUI{
    
    _leftView = [[UIView alloc]initWithFrame:CGRectMake(40*x, 0, 20*x, 20*x)];
    
    _leftView.layer.cornerRadius = 10*x;
    
    _leftView.backgroundColor = UIColorFromRGB(0x9aa7b3, 1.0);
    
    [self.contentView addSubview:_leftView];
    
    _lineView = [[UIView alloc]initWithFrame:CGRectMake(50*x, 20*x, 1, 80*x)];
    
    _lineView.backgroundColor = UIColorFromRGB(0x9aa7b3, 1.0);
    
    [self.contentView addSubview:_lineView];
    
    _stateLabel = [[UILabel alloc]initWithFrame:CGRectMake(72*x, 3*x, DeviceWidth-72*x, 20*x)];
    
    _stateLabel.backgroundColor = [UIColor whiteColor];
    
    _stateLabel.numberOfLines = 0;
    
    _stateLabel.font = [UIFont appFontRegularOfSize:14*x];
    
    [self.contentView addSubview:_stateLabel];
    
    _timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(72*x, 33*x, DeviceWidth-72*x, 20*x)];
    
    _timeLabel.font = [UIFont appFontRegularOfSize:14*x];
    
    [self.contentView addSubview:_timeLabel];
    
}

-(float)insertLogisticsModel:(TimeActionDetail *)model number:(NSInteger)num{
    
    _stateLabel.text = model.nodeDesc;
    
    _timeLabel.text = model.nodeTime;
    
     CGSize size = [_stateLabel boundingRectWithSize:CGSizeMake(DeviceWidth-72*x, NSIntegerMax)];
    
    _stateLabel.frame = CGRectMake(72*x, 3*x, DeviceWidth-72*x, size.height);
    
    if (num == 0) {
        
        _leftView.backgroundColor = UIColorFromRGB(0x32beff, 1.0);
        
        _stateLabel.textColor = UIColorFromRGB(0x32beff, 1.0);
        
        _timeLabel.textColor = UIColorFromRGB(0x32beff, 1.0);
        
    }
    
    _timeLabel.frame = CGRectMake(72*x, size.height+18*x, DeviceWidth-72*x, 20*x) ;
    
    _lineView.frame = CGRectMake(50*x, 20*x, 1, size.height+33*x);
    
    return size.height+53*x;
    
}

- (void)prepareForReuse{
    
    [super prepareForReuse];
    
    _stateLabel.text = @"";
    
    _stateLabel.frame = CGRectMake(72*x, 3*x, DeviceWidth-72*x, 20*x);
    
    _timeLabel.textColor = [UIColor blackColor];
    
    _timeLabel.text = @"";
    
    _leftView.backgroundColor =UIColorFromRGB(0x9aa7b3, 1.0);
    
    _stateLabel.textColor = [UIColor blackColor];
    
    _timeLabel.frame = CGRectMake(72*x, 33*x, DeviceWidth-72*x, 20*x);
    
    _lineView.frame = CGRectMake(50*x, 20*x, 1, 80*x);
    
    if (_reasonLabel) {
        _reasonLabel.textColor = [UIColor blackColor];
        _reasonLabel.frame = CGRectZero;
    }
    
}

@end
