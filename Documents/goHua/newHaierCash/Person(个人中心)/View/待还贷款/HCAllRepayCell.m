//
//  HCAllRepayCell.m
//  newHaierCash
//
//  Created by Will on 2017/6/2.
//  Copyright © 2017年 haier. All rights reserved.
//

#import "HCMacro.h"

#import "HCAllRepayCell.h"

@interface HCAllRepayCell() {
    CGFloat _viewScale;
    
    UILabel *_typeLbl;
    UILabel *_nameLbl;
    UILabel *_dateLbl;
    UILabel *_repayLbl;
    UIImageView *_moreImgView;
    
    UIView *_lineView;
}

@end

@implementation HCAllRepayCell


-(void)generateCellWithModel:(NSDictionary *)model {
    _typeLbl.text = model[@"type"];
    _nameLbl.text = model[@"name"];
    _dateLbl.text = model[@"date"];
    NSString *infoSrt = model[@"info"];
    NSMutableAttributedString * string = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@",infoSrt]];
    [string addAttribute:NSForegroundColorAttributeName value:[UIColor orangeColor] range:NSMakeRange(2, infoSrt.length - 4)];
    _repayLbl.attributedText = string;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _viewScale = iphone6P ? scale6PAdapter : scaleAdapter;
        
        _typeLbl = [UILabel new];
        _typeLbl.textColor = [UIColor blackColor];
        _typeLbl.textAlignment = NSTextAlignmentLeft;
        _typeLbl.font = [UIFont systemFontOfSize:14 * _viewScale];
        [self.contentView addSubview:_typeLbl];
        
        _nameLbl = [UILabel new];
        _nameLbl.textColor = [UIColor grayColor];
        _nameLbl.textAlignment = NSTextAlignmentLeft;
        _nameLbl.font = [UIFont systemFontOfSize:12 * _viewScale];
        [self.contentView addSubview:_nameLbl];
        
        _dateLbl = [UILabel new];
        _dateLbl.textColor = [UIColor grayColor];
        _dateLbl.textAlignment = NSTextAlignmentLeft;
        _dateLbl.font = [UIFont systemFontOfSize:12 * _viewScale];
        [self.contentView addSubview:_dateLbl];
        
        _repayLbl = [UILabel new];
        _repayLbl.textColor = [UIColor grayColor];
        _repayLbl.textAlignment = NSTextAlignmentRight;
        _repayLbl.font = [UIFont systemFontOfSize:13 *_viewScale];
        [self.contentView addSubview:_repayLbl];
        
        _moreImgView = [UIImageView new];
        _moreImgView.backgroundColor = [UIColor clearColor];
        [_moreImgView setImage:[UIImage imageNamed:@"箭头_右_灰"]];
        [self.contentView addSubview:_moreImgView];
        
        _lineView = [UIView new];
        _lineView.backgroundColor = [UIColor grayColor];
        [self addSubview:_lineView];
        
    }
    return self;
}

-(void)layoutSubviews {
    [super layoutSubviews];
    
    if (iphone6P) {
        //70
        _typeLbl.frame = CGRectMake(15, 18, 70, 15);
        _nameLbl.frame = CGRectMake(90, 19, DeviceWidth - 225, 14);
        
        _dateLbl.frame = CGRectMake(15, 44, DeviceWidth - 150, 13);
        
        _moreImgView.frame = CGRectMake(DeviceWidth - 25, 28, 10, 14);
        
        _repayLbl.frame = CGRectMake(DeviceWidth - 125, 28, 95, 14);
        
        _lineView.frame = CGRectMake(0, 70 - thinLineHeight, DeviceWidth, thinLineHeight);
    } else {
        //65
        _typeLbl.frame = CGRectMake(15 * _viewScale, 16 * _viewScale, 65 * _viewScale , 15 *_viewScale);
        
        _nameLbl.frame = CGRectMake(85 * _viewScale, 18 * _viewScale, DeviceWidth - 218 * _viewScale , 15 *_viewScale);
        
        _dateLbl.frame = CGRectMake(15 * _viewScale, 40 * _viewScale, DeviceWidth - 148 * _viewScale , 13 *_viewScale);
        
        _moreImgView.frame = CGRectMake(DeviceWidth - 24 * _viewScale, 26 * _viewScale, 9 * _viewScale, 12 * _viewScale);

        _repayLbl.frame = CGRectMake(Width(self) - 123 * _viewScale, 25 * _viewScale, 95 * _viewScale, 14 * _viewScale);
        
        _lineView.frame = CGRectMake(0, 65 * _viewScale - thinLineHeight, Width(self), thinLineHeight);
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
