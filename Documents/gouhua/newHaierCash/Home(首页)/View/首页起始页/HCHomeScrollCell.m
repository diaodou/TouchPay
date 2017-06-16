//
//  HCHomeScrollCell.m
//  newHaierCash
//
//  Created by Will on 2017/6/3.
//  Copyright © 2017年 haier. All rights reserved.
//

#import "HCMacro.h"

#import "HCHomeScrollCell.h"
#import "UIFont+AppFont.h"
#import "UIColor+DefineNew.h"

#import "HCHomeInfoModel.h"

@interface HCHomeScrollCellView : UIView {
    UIImageView *_groundImgView;
    UIView *_backView;
    UILabel *_titleLbl;
    UILabel *_infoLbl;
    
    CGFloat _viewScale;
}

- (void)generateViewWithTitle:(NSString *)title andInfo:(NSString *)info andimgStr:(NSString *)imgStr andViewTag:(NSInteger) tag;
@end

@implementation HCHomeScrollCellView

- (void)generateViewWithTitle:(NSString *)title andInfo:(NSString *)info andimgStr:(NSString *)imgStr andViewTag:(NSInteger) tag {
    _titleLbl.text = title;
    _infoLbl.text = info;
    [_groundImgView setImage:[UIImage imageNamed:imgStr]];
    self.tag = tag;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _viewScale = iphone6P ? scale6PAdapter : scaleAdapter;
        self.layer.borderWidth = 1 / [UIScreen mainScreen].scale;
        self.layer.borderColor = [UIColor UIColorWithHexColorString:@"#dddddd" AndAlpha:1].CGColor;
        
        _groundImgView = [UIImageView new];
        _groundImgView.contentMode = UIViewContentModeScaleAspectFit;
        _groundImgView.backgroundColor = [UIColor clearColor];
        [self addSubview:_groundImgView];
        
        _backView = [UIView new];
        _backView.backgroundColor = [UIColor blackColor];
        _backView.alpha = 0.3;
        [self addSubview:_backView];
        
        _titleLbl = [self _generateLblWithFont:[UIFont appFontBoldOfSize:15 * _viewScale] andTextColor:[UIColor whiteColor]];
        
        _infoLbl = [self _generateLblWithFont:[UIFont appFontRegularOfSize:11 * _viewScale] andTextColor:[UIColor whiteColor]];
        _infoLbl.numberOfLines = 2;
        
        self.userInteractionEnabled = YES;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    _backView.frame = _groundImgView.frame = CGRectMake(0, 0, Width(self), Height(self));
    
    _titleLbl.frame = CGRectMake(15 * _viewScale, 29 * _viewScale, Width(self) - 30 * _viewScale, 17 * _viewScale);
    
    _infoLbl.frame =  CGRectMake(15 * _viewScale, 54 * _viewScale, Width(self) - 30 * _viewScale, 30 * _viewScale);
    

}

- (UILabel *)_generateLblWithFont:(UIFont *)font andTextColor:(UIColor *)color {
    UILabel *lbl = [UILabel new];
    lbl.numberOfLines = 1;
    lbl.textAlignment = NSTextAlignmentCenter;
    lbl.font = font;
    lbl.textColor = color;
    
    [self addSubview:lbl];
    return lbl;
}

@end

@interface HCHomeScrollCell() {
    UIView *_lineView;
    UIScrollView *_scrollView;
    CGFloat _viewScale;
    NSArray *_models;
}

@end

@implementation HCHomeScrollCell

- (void)generateCellWithModels:(NSArray *)models {
    _models = models;
    if (_scrollView.subviews.count > 0) {
        for (UIView *view in _scrollView.subviews) {
            [view removeFromSuperview];
        }
    }
    if (_models.count > 0) {
        for (NSInteger index = 0; index < _models.count; index ++) {
            HomeChildModel *model = _models[index];
            
            HCHomeScrollCellView *cellView = [HCHomeScrollCellView new];
            [_scrollView addSubview:cellView];
            [cellView generateViewWithTitle:model.title andInfo:model.secondTitle andimgStr:model.picPath andViewTag:index];
            [cellView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewDidClick:)]];
            cellView.frame = CGRectMake((15 + 164 * index) * _viewScale, 14 * _viewScale, 154 * _viewScale, 102 * _viewScale);
            
        }
        if ((30 + 164 * _models.count - 10) * _viewScale > Width(self.contentView)) {
            _scrollView.contentSize = CGSizeMake((20 + 164 * _models.count) * _viewScale, 0);
        } else {
            _scrollView.contentSize = CGSizeMake(Width(self.contentView), 0);
        }
        
        //155
    }


}

- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _viewScale = iphone6P ? scale6PAdapter : scaleAdapter;
        
        _lineView = [UIView new];
        _lineView.backgroundColor = [UIColor UIColorWithHexColorString:@"#dddddd" AndAlpha:1];
        [self.contentView addSubview:_lineView];
        
        _scrollView = [[UIScrollView alloc] init];
        [self.contentView addSubview:_scrollView];

    }
    
    return self;
}

-(void)layoutSubviews {
    [super layoutSubviews];
    _lineView.frame = CGRectMake(15 * _viewScale, 0, Width(self.contentView) - 30 * _viewScale, thinLineHeight);
    
    _scrollView.frame = CGRectMake(0, thinLineHeight, Width(self.contentView), Height(self.contentView) - thinLineHeight);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)viewDidClick:(UITapGestureRecognizer *)gesture {
    HomeChildModel *model = _models[gesture.view.tag];

    if (self.cellDelegate && [self.cellDelegate respondsToSelector:@selector(ProfitViewDidClcik:)]) {
        [self.cellDelegate ProfitViewDidClcik:model];
    }
}

@end
