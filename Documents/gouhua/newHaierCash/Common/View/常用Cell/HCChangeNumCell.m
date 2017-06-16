//
//  HCChangeNumCell.m
//  newHaierCash
//
//  Created by Will on 2017/6/3.
//  Copyright © 2017年 haier. All rights reserved.
//

#import "HCMacro.h"
#import "UIColor+DefineNew.h"
#import "UIFont+AppFont.h"

#import "HCChangeNumCell.h"

@interface HCChangeNumCell() {
    UILabel *_titleLbl;
    UIButton *_minNumBtn;
    UILabel *_countNumLbl;
    UIButton *_addBtn;
    
    UIView *_lineView;
    CGFloat _viewScale;
    NSDictionary *_model;


}


@end

@implementation HCChangeNumCell

- (void)generateCellWithModel:(NSDictionary *)model {
    _model = model;
    _titleLbl.text = model[@"title"];
    if ([model[@"value"] integerValue] > 0) {
        _countNumLbl.text = model[@"value"];
    } else {
        _countNumLbl.text = @"0";
    }
}

- (void)generateCellWithTitle:(NSString *)title andGoodsNum:(NSString *)num {
    _titleLbl.text = title;
    if ([num integerValue] > 0) {
        _countNumLbl.text = num;
    } else {
        _countNumLbl.text = @"0";
    }
}

- (void)resetNumLbl:(NSInteger)num {
    _countNumLbl.text = [NSString stringWithFormat:@"%ld",num];
}

- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _viewScale = iphone6P ? scale6PAdapter : scaleAdapter;
        
        _titleLbl = [UILabel new];
        _titleLbl.font = [UIFont appFontRegularOfSizePx:21 * _viewScale];
        _titleLbl.textColor = [UIColor blackColor];
        [self.contentView addSubview:_titleLbl];
        
        _minNumBtn = [self _generateBtnWithImageName:@"订单确认_减少"];
        
        _countNumLbl = [[UILabel alloc] init];
        _countNumLbl.layer.borderWidth = 1;
        _countNumLbl.layer.borderColor = [UIColor UIColorWithHexColorString:@"0xeeeeee" AndAlpha:1].CGColor;
        _countNumLbl.textAlignment = NSTextAlignmentCenter;
        _countNumLbl.font = [UIFont systemFontOfSize:14 * _viewScale];
        [self.contentView addSubview:_countNumLbl];
        
        _addBtn = [self _generateBtnWithImageName:@"订单确认_添加"];
        
        _lineView = [UIView new];
        _lineView.backgroundColor = [UIColor grayColor];
        [self.contentView addSubview:_lineView];
        
    }
    
    return self;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _viewScale = iphone6P ? scale6PAdapter : scaleAdapter;
        
        _titleLbl = [UILabel new];
        _titleLbl.font = [UIFont appFontRegularOfSize:15 * _viewScale];
        _titleLbl.textColor = [UIColor blackColor];
        [self.contentView addSubview:_titleLbl];
        
        _minNumBtn = [self _generateBtnWithImageName:@"订单确认_减少"];
        
        _countNumLbl = [[UILabel alloc] init];
        _countNumLbl.textAlignment = NSTextAlignmentCenter;
        _countNumLbl.font = [UIFont appFontRegularOfSize:13 * _viewScale];
        [self.contentView addSubview:_countNumLbl];
        
        _addBtn = [self _generateBtnWithImageName:@"订单确认_添加"];
        
        _lineView = [UIView new];
        _lineView.backgroundColor = [UIColor grayColor];
        [self.contentView addSubview:_lineView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat cellHeight = iphone6P ? 50 : 45 * _viewScale;

    _titleLbl.frame = CGRectMake(15 * _viewScale, 0, 80 * _viewScale, cellHeight);

    _addBtn.frame = CGRectMake(Width(self.contentView) - 45 * _viewScale,(cellHeight - 30 * _viewScale) / 2, 30 *_viewScale, 30 *_viewScale);
    _countNumLbl.frame = CGRectMake(Width(self.contentView) - 80 * _viewScale, (cellHeight - 30 * _viewScale) / 2, 35 *_viewScale, 30 *_viewScale);
    _minNumBtn.frame = CGRectMake(Width(self.contentView) - 110 * _viewScale, (cellHeight - 30 * _viewScale) / 2, 30 *_viewScale, 30 *_viewScale);
    
    _lineView.frame = CGRectMake(0, cellHeight - thinLineHeight, Width(self), thinLineHeight);

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - Private Method
- (UIButton *)_generateBtnWithImageName:(NSString *)name {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    //[button.titleLabel setFont:[UIFont systemFontOfSize:12 * _viewScale]];
    [button setImage:[UIImage imageNamed:name] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(_changeNumBtnDidClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:button];
    
    return button;
}

#pragma mark - Button Event
- (void)_changeNumBtnDidClick:(UIButton *)button {
    NSInteger goodsNum = [_countNumLbl.text integerValue];
    if (button == _minNumBtn) {
        if (goodsNum > 1) {
            goodsNum -- ;
            _countNumLbl.text = [NSString stringWithFormat:@"%ld",goodsNum];
        }
    } else {
        goodsNum ++ ;
        _countNumLbl.text = [NSString stringWithFormat:@"%ld",goodsNum];
    }
    //输入判断
    
    //Model赋值
    if (self.delegate && [self.delegate respondsToSelector:@selector(HCChangeNumCellGetModel:)]) {
        [self.delegate HCChangeNumCellGetModel:_model];
    }else if (self.delegate && [self.delegate respondsToSelector:@selector(HCChangeNumCellChangeNum:withTitle:)]) {
        [self.delegate HCChangeNumCellChangeNum:[_countNumLbl.text integerValue] withTitle:_titleLbl.text];
    }
    
}
@end
