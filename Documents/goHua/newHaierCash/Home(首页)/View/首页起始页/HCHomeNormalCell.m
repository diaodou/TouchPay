//
//  HCHomeInfoCell.m
//  newHaierCash
//
//  Created by Will on 2017/5/31.
//  Copyright © 2017年 haier. All rights reserved.
//

#import "HCMacro.h"
#import "UIColor+DefineNew.h"
#import "UIFont+AppFont.h"

#import "HCHomeInfoModel.h"

#import "HCHomeNormalCell.h"

@interface HCHomeNormalCell() {
    UIImageView *_homeInfoImgView;
    UILabel *_homeTitleLbl;
    UILabel *_homeInfoLbl;
    UIView *_lineView;
    
    CGFloat _viewScale;
}

@end

@implementation HCHomeNormalCell

- (void)generateCellWithModel:(HomeChildModel *)model {
    [_homeInfoImgView setImage:[UIImage imageNamed:model.picPath]];
    _homeTitleLbl.text = model.title;
    _homeInfoLbl.text = [NSString stringWithFormat:@"%@ %@",StringOrNull(model.secondTitle),StringOrNull(model.note)];
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
        
        _lineView = [UIView new];
        _lineView.backgroundColor = [UIColor UIColorWithHexColorString:@"#dddddd" AndAlpha:1];
        [self.contentView addSubview:_lineView];
        
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (iphone6P) {
        _lineView.frame = CGRectMake(15, 0, Width(self) - 30, thinLineHeight);

        _homeInfoImgView.frame = CGRectMake(15, 14, 120, 68);
        
        _homeTitleLbl.frame = CGRectMake(146, 24, DeviceWidth - 161, 17);
        
        _homeInfoLbl.frame = CGRectMake(146, 49, DeviceWidth - 161, 14 * _viewScale);
    } else {
        _lineView.frame = CGRectMake(13 * _viewScale, 0, Width(self) - 26 * _viewScale, thinLineHeight);

        _homeInfoImgView.frame = CGRectMake(13 * _viewScale, 13 * _viewScale, 109 * _viewScale, 62 * _viewScale);
        
        _homeTitleLbl.frame = CGRectMake(132 * _viewScale, 24 * _viewScale, Width(self) - 147 * _viewScale, 17 * _viewScale);
        
        _homeInfoLbl.frame = CGRectMake(132 * _viewScale, 46 * _viewScale, Width(self) - 147 * _viewScale, 14 * _viewScale);
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
