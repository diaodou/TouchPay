//
//  HCWeekRepayCell.m
//  newHaierCash
//
//  Created by Will on 2017/6/2.
//  Copyright © 2017年 haier. All rights reserved.
//

#import "HCMacro.h"

#import "HCWeekRepayCell.h"
@interface HCWeekRepayCell() {
    NSDictionary *_model;
    CGFloat _viewScale;
    
    UIButton *_markBtn;
    UILabel *_repayLbl;
    UILabel *_nameLbl;
    UILabel *_infoLbl;
    UIImageView *_moreInfoImgView;
    
    UIView *_lineView;
}

@end

@implementation HCWeekRepayCell

-(void)generateCellWithModel:(NSDictionary *)model {
    _model = model;
    _repayLbl.text = model[@"repay"];
    _nameLbl.text = model[@"name"];
    _infoLbl.text = model[@"info"];
}

- (void)changeSelectBtnState:(BOOL)isSelect {
    if (!isSelect) {
        [_markBtn setImage:[UIImage imageNamed:@"图标_未选中"] forState:UIControlStateNormal];
        _markBtn.selected = NO;
    } else {
        [_markBtn setImage:[UIImage imageNamed:@"图标_选中"] forState:UIControlStateNormal];
        _markBtn.selected = YES;
    }
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _viewScale = iphone6P ? scale6PAdapter : scaleAdapter;
        _markBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _markBtn.selected = NO;
        [_markBtn setImage:[UIImage imageNamed:@"图标_未选中"] forState:UIControlStateNormal];
        [_markBtn addTarget:self action:@selector(_markBtnDidClick) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_markBtn];
        
        _repayLbl = [UILabel new];
        _repayLbl.textColor = [UIColor orangeColor];
        _repayLbl.textAlignment = NSTextAlignmentLeft;
        _repayLbl.font = [UIFont systemFontOfSize:14 * _viewScale];
        [self.contentView addSubview:_repayLbl];
        
        _nameLbl = [UILabel new];
        _nameLbl.textColor = [UIColor grayColor];
        _nameLbl.textAlignment = NSTextAlignmentLeft;
        _nameLbl.font = [UIFont systemFontOfSize:12 * _viewScale];
        [self.contentView addSubview:_nameLbl];
        
        _infoLbl = [UILabel new];
        _infoLbl.textColor = [UIColor grayColor];
        _infoLbl.textAlignment = NSTextAlignmentRight;
        _infoLbl.font = [UIFont systemFontOfSize:12 *_viewScale];
        [self.contentView addSubview:_infoLbl];
        
        _moreInfoImgView = [UIImageView new];
        [_moreInfoImgView setImage:[UIImage imageNamed:@"箭头_右_灰"]];
        _moreInfoImgView.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:_moreInfoImgView];
        
        _lineView = [UIView new];
        _lineView.backgroundColor = [UIColor grayColor];
        [self addSubview:_lineView];
        
    }
    return self;
}


-(void)layoutSubviews {
    [super layoutSubviews];
    if (iphone6P) {
        //64
        _markBtn.frame = CGRectMake(15, 23, 18 , 18);
        _repayLbl.frame = CGRectMake(43, 15, 160 , 15);
        _nameLbl.frame = CGRectMake(43, 37, 160 , 13);
        _moreInfoImgView.frame = CGRectMake(Width(self.contentView) - 24, 24, 9, 16);
        _infoLbl.frame = CGRectMake(Width(self.contentView) - 100, 25, 65, 14);
        _lineView.frame = CGRectMake(0, 63, Width(self), 1);
    } else {
        //64
        _markBtn.frame = CGRectMake(13 * _viewScale, 23 * _viewScale, 17 *_viewScale , 17 *_viewScale);
        _repayLbl.frame = CGRectMake(37 * _viewScale, 15 * _viewScale, 160 *_viewScale , 15 *_viewScale);
        _nameLbl.frame = CGRectMake(37 * _viewScale, 37 * _viewScale, 160 *_viewScale , 13 *_viewScale);
        _moreInfoImgView.frame = CGRectMake(Width(self.contentView) - 23 * _viewScale, 24 * _viewScale, 8 * _viewScale, 16 * _viewScale);
        _infoLbl.frame = CGRectMake(Width(self) - 100 * _viewScale, 24 * _viewScale, 65 * _viewScale, 14 * _viewScale);
        
        _lineView.frame = CGRectMake(0, 63 * _viewScale, Width(self), 1 * _viewScale);
    }
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)_markBtnDidClick {
    if (_markBtn.selected) {
        [_markBtn setImage:[UIImage imageNamed:@"图标_未选中"] forState:UIControlStateNormal];
        _markBtn.selected = NO;
    } else {
        [_markBtn setImage:[UIImage imageNamed:@"图标_选中"] forState:UIControlStateNormal];
        _markBtn.selected = YES;
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(HCWeekReplayCellGetModel:withIsSelect:)]) {
        [self.delegate HCWeekReplayCellGetModel:_model withIsSelect:_markBtn.selected];
    }

}

@end
