//
//  HCMonthRepayCell.m
//  newHaierCash
//
//  Created by Will on 2017/6/2.
//  Copyright © 2017年 haier. All rights reserved.
//

#import "HCMacro.h"
#import "UIColor+DefineNew.h"

#import "HCMonthRepayCell.h"

@interface HCMonthRepayCell() {
    CGFloat _viewScale;
    
    UILabel *_repayLbl;
    UILabel *_nameLbl;
    UILabel *_infoLbl;
    UIImageView *_moreImgView;
    
    UIView *_lineView;
}

@end

@implementation HCMonthRepayCell

-(void)generateCellWithModel:(NSDictionary *)model {
    _repayLbl.text = [NSString stringWithFormat:@"¥%@",model[@"repay"]];
    _nameLbl.text = model[@"name"];
    _infoLbl.text = model[@"info"];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _viewScale = iphone6P ? scale6PAdapter : scaleAdapter;
        
        _repayLbl = [UILabel new];
        _repayLbl.textColor = UIColorFromRGB(0xfda253, 1);
        _repayLbl.textAlignment = NSTextAlignmentLeft;
        _repayLbl.font = [UIFont systemFontOfSize:13 * _viewScale];
        [self.contentView addSubview:_repayLbl];
        
        _nameLbl = [UILabel new];
        _nameLbl.textColor = UIColorFromRGB(0x999999, 1);
        _nameLbl.textAlignment = NSTextAlignmentLeft;
        _nameLbl.font = [UIFont systemFontOfSize:13 * _viewScale];
        [self.contentView addSubview:_nameLbl];
        
        _infoLbl = [UILabel new];
        _infoLbl.textColor = UIColorFromRGB(0x999999, 1);
        _infoLbl.textAlignment = NSTextAlignmentRight;
        _infoLbl.font = [UIFont systemFontOfSize:14 * _viewScale];
        [self.contentView addSubview:_infoLbl];
        
        _moreImgView = [UIImageView new];
        _moreImgView.backgroundColor = [UIColor clearColor];
        [_moreImgView setImage:[UIImage imageNamed:@"箭头_右_灰"]];
        [self.contentView addSubview:_moreImgView];
        
        _lineView = [UIView new];
        _lineView.backgroundColor = UIColorFromRGB(0xeeeeee, 1);
        [self addSubview:_lineView];
        
    }
    return self;
}

-(void)layoutSubviews {
    [super layoutSubviews];
    
    if (iphone6P) {
        //72
        _repayLbl.frame = CGRectMake(15, 17, DeviceWidth - 135 , 14);
        _nameLbl.frame = CGRectMake(15, 42, DeviceWidth - 135 , 14 *_viewScale);
        
        _moreImgView.frame = CGRectMake(DeviceWidth - 25, 29, 10, 14);

        _infoLbl.frame = CGRectMake(DeviceWidth - 115, 0, 80, 72);
        
        _lineView.frame = CGRectMake(0, 72 * _viewScale - thinLineHeight, DeviceWidth, thinLineHeight);
    } else {
        //65
        _repayLbl.frame = CGRectMake(15 * _viewScale, 16 * _viewScale, DeviceWidth - 140 * _viewScale , 14 *_viewScale);
        _nameLbl.frame = CGRectMake(15 * _viewScale, 36 * _viewScale, DeviceWidth - 140 * _viewScale , 14 *_viewScale);
        
        _moreImgView.frame = CGRectMake(DeviceWidth - 24 * _viewScale, 26 * _viewScale, 9 * _viewScale, 12 * _viewScale);
        
        _infoLbl.frame = CGRectMake(Width(self) - 114 * _viewScale, 0, 80 * _viewScale, 65 * _viewScale);
        
        _lineView.frame = CGRectMake(0, 65 * _viewScale - thinLineHeight, DeviceWidth, thinLineHeight);
    }
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
