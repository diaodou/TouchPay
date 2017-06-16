//
//  HCOpeningBranchTableViewCell.m
//  newHaierCash
//
//  Created by 百思为科 on 2017/6/8.
//  Copyright © 2017年 haier. All rights reserved.
//

#import "HCOpeningBranchTableViewCell.h"
#import "HCMacro.h"
#import "UIFont+AppFont.h"
@implementation HCOpeningBranchTableViewCell

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
        
        UILabel * fixedLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, 50, 50)];
        fixedLabel.font = [UIFont appFontRegularOfSize:15];
        fixedLabel.text = @"支行";
        fixedLabel.textColor = UIColorFromRGB(0x333333, 1.0);
        fixedLabel.textAlignment = NSTextAlignmentLeft;
        [bottomView addSubview:fixedLabel];
        
        _branchLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(fixedLabel.frame) + 8, 0, DeviceWidth - CGRectGetMaxX(fixedLabel.frame) - 40, 50)];
        
        _branchLabel.font = [UIFont appFontRegularOfSize:15];
        
        
        _branchLabel.textColor = UIColorFromRGB(0x666666, 1.0);
        
        [bottomView addSubview:_branchLabel];
        
        UIImageView * arrowImage = [[UIImageView alloc]initWithFrame:CGRectMake(DeviceWidth - 23, 18.5, 8, 13)];
        
        arrowImage.image = [UIImage imageNamed:@"箭头"];
        
        [bottomView addSubview:arrowImage];

    }else{
        
        float x = DeviceWidth/375;
        
        UIView * bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DeviceWidth, 44 *x)];
        
        bottomView.backgroundColor = [UIColor whiteColor];
        
        [self.contentView addSubview:bottomView];
        
        UILabel * fixedLabel = [[UILabel alloc]initWithFrame:CGRectMake(10 *x, 0, 30 *x, 44 *x)];
        fixedLabel.font = [UIFont appFontRegularOfSize:14 *x];
        fixedLabel.text = @"支行";
        fixedLabel.textColor = UIColorFromRGB(0x333333, 1.0);
        
        [bottomView addSubview:fixedLabel];
        
        _branchLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(fixedLabel.frame) + 28 *x, 0, DeviceWidth - CGRectGetMaxX(fixedLabel.frame) - 40 *x, 44 *x)];
        
        _branchLabel.font = [UIFont appFontRegularOfSize:14 *x];
        
        _branchLabel.textColor = UIColorFromRGB(0x666666, 1.0);
        
        [bottomView addSubview:_branchLabel];
        
        UIImageView * arrowImage = [[UIImageView alloc]initWithFrame:CGRectMake(DeviceWidth - 21 *x, 15 *x, 7 *x, 12 *x)];
        
        arrowImage.image = [UIImage imageNamed:@"箭头"];
        
        [bottomView addSubview:arrowImage];
    }
}
@end
