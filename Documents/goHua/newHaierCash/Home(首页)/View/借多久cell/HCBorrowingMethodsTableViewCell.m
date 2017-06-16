//
//  BorrowingMethodsTableViewCell.m
//  newHaierCash
//
//  Created by 百思为科 on 2017/6/6.
//  Copyright © 2017年 haier. All rights reserved.
//

#import "HCBorrowingMethodsTableViewCell.h"
#import "HCMacro.h"
#import "UIFont+AppFont.h"
@implementation HCBorrowingMethodsTableViewCell

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
        UIView * bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DeviceWidth, 72)];
        
        bottomView.backgroundColor = [UIColor whiteColor];
        
        [self.contentView addSubview:bottomView];
        
        _timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(16, 18, DeviceWidth, 16)];
        
        _timeLabel.font = [UIFont appFontRegularOfSize:15];
        
        _timeLabel.textColor = UIColorFromRGB(0xfda253, 1.0);
        
        [bottomView addSubview: _timeLabel];
        
        _typeLabel = [[UILabel alloc]initWithFrame:CGRectMake(16, CGRectGetMaxY(_timeLabel.frame) + 10, DeviceWidth, 14)];
        
        _typeLabel.font = [UIFont appFontRegularOfSize:13];
        
        _typeLabel.textColor = UIColorFromRGB(0x999999, 1.0);
        
        [bottomView addSubview:_typeLabel];
        
        _interestLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, DeviceWidth - 36, 72)];
        
        _interestLabel.font = [UIFont appFontRegularOfSize:13];
        
        _interestLabel.textAlignment = NSTextAlignmentRight;
        
        _interestLabel.textColor = UIColorFromRGB(0x999999, 1.0);
        
        [bottomView addSubview:_interestLabel];
        
        UIImageView * image = [[UIImageView alloc]initWithFrame:CGRectMake(DeviceWidth - 36, 29.5, 8, 13)];
        
        image.image = [UIImage imageNamed:@"箭头"];
        
        [bottomView addSubview:image];
    }else{
        UIView * bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DeviceWidth, 65)];
        
        bottomView.backgroundColor = [UIColor whiteColor];
        
        [self.contentView addSubview:bottomView];
        
        _timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 16, DeviceWidth, 14)];
        
        _timeLabel.font = [UIFont appFontRegularOfSize:14];
        
        _timeLabel.textColor = UIColorFromRGB(0xfda253, 1.0);
        
        [bottomView addSubview: _timeLabel];
        
        _typeLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(_timeLabel.frame) + 9, DeviceWidth, 13)];
        
        _typeLabel.font = [UIFont appFontRegularOfSize:12];
        
        _typeLabel.textColor = UIColorFromRGB(0x999999, 1.0);
        
        [bottomView addSubview:_typeLabel];
        
        _interestLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, DeviceWidth - 20, 65)];
        
        _interestLabel.font = [UIFont appFontRegularOfSize:12];
        
        _interestLabel.textAlignment = NSTextAlignmentRight;

        _interestLabel.textColor = UIColorFromRGB(0x999999, 1.0);
        
        [bottomView addSubview:_interestLabel];
        
        UIImageView * image = [[UIImageView alloc]initWithFrame:CGRectMake(DeviceWidth - 20, 26.5, 7, 12)];
        
        image.image = [UIImage imageNamed:@"箭头"];
        
        [bottomView addSubview:image];
    }
    
}
@end
