//
//  HCSpecialGoodsCell.m
//  newHaierCash
//
//  Created by Will on 2017/6/13.
//  Copyright © 2017年 haier. All rights reserved.
//

#import "HCMacro.h"
#import "UIColor+DefineNew.h"
#import "UIFont+AppFont.h"

#import "HCSpecialGoodsCell.h"

@interface HCSpecialGoodsCell() {
    UIImageView *_homeInfoImgView;
    UILabel *_homeTitleLbl;
    UILabel *_homeInfoLbl;
    UIView *_lineView;
    UIImageView *_moreInfoImgView;
    
    CGFloat _viewScale;
}

@end

@implementation HCSpecialGoodsCell
- (void)generateCellWithModel:(NSDictionary *)model {
    [_homeInfoImgView setImage:[UIImage imageNamed:model[@"image"]]];
    _homeTitleLbl.text = model[@"title"];
    _homeInfoLbl.text = model[@"info"];
}

- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        _viewScale = iphone6P ? scale6PAdapter : scaleAdapter;
        
        _homeInfoImgView = [UIImageView new];
        _homeInfoImgView.backgroundColor = [UIColor clearColor];
        _homeInfoImgView.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:_homeInfoImgView];
        
        _homeTitleLbl = [UILabel new];
        _homeTitleLbl.font = [UIFont appFontRegularOfSize:15 * _viewScale];
        _homeTitleLbl.textColor = [UIColor blackColor];
        [self.contentView addSubview:_homeTitleLbl];
        
        _homeInfoLbl = [UILabel new];
        _homeInfoLbl.font = [UIFont appFontRegularOfSize:12 * _viewScale];
        _homeInfoLbl.textColor =  [UIColor UIColorWithHexColorString:@"#989898" AndAlpha:1];
        [self.contentView addSubview:_homeInfoLbl];
        
        _moreInfoImgView = [UIImageView new];
        [_moreInfoImgView setImage:[UIImage imageNamed:@"箭头_右_灰"]];
        _moreInfoImgView.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:_moreInfoImgView];
        
        _lineView = [UIView new];
        _lineView.backgroundColor = [UIColor UIColorWithHexColorString:@"#dddddd" AndAlpha:1];
        [self.contentView addSubview:_lineView];
        
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (iphone6P) {
        //95
        _lineView.frame = CGRectMake(0, 0, DeviceWidth, thinLineHeight);
        
        _homeInfoImgView.frame = CGRectMake(15, 14, 121, 68);
        
        _moreInfoImgView.frame = CGRectMake(DeviceWidth - 24, 41, 9, 13);
        
        _homeTitleLbl.frame = CGRectMake(146, 24, DeviceWidth - 180, 17);
        
        _homeInfoLbl.frame = CGRectMake(146, 49, DeviceWidth - 180, 14);
    } else {
        //87
        _lineView.frame = CGRectMake(0, 0, DeviceWidth, thinLineHeight);
        _homeInfoImgView.frame = CGRectMake(13 * _viewScale, 13 * _viewScale, 109 * _viewScale, 62 * _viewScale);
        
        _moreInfoImgView.frame = CGRectMake(DeviceWidth - 21 * _viewScale, 37 * _viewScale, 8 * _viewScale, 12 * _viewScale);
        
        _homeTitleLbl.frame = CGRectMake(132 * _viewScale, 24 * _viewScale, DeviceWidth - 163 * _viewScale, 17 * _viewScale);
        
        _homeInfoLbl.frame = CGRectMake(132 * _viewScale, 46 * _viewScale, Width(self) - 163 * _viewScale, 14 * _viewScale);
    }
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
