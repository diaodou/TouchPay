//
//  HCTextInfoCell.m
//  newHaierCash
//
//  Created by Will on 2017/6/15.
//  Copyright © 2017年 haier. All rights reserved.
//

#import "HCMacro.h"
#include "UIColor+DefineNew.h"
#import "UIFont+AppFont.h"

#import "HCTextInfoCell.h"


@interface HCTextInfoCell()<UITextFieldDelegate> {
    UILabel *_titleLbl;
    
    UIImageView *_moreInfoImgView;
    UIView *_lineView;
    
    CGFloat _viewScale;
    NSDictionary *_model;
    
}


@end

@implementation HCTextInfoCell

- (void)generateCellWithTitle:(NSString *)title andPlaceStr:(NSString *) placeStr orContent:(NSString *)content {
    _titleLbl.text = title;
    _contentTxt.placeholder = placeStr;
    _contentTxt.text = content;
    
    _contentTxt.enabled = YES;
    [_moreInfoImgView setHidden:YES];
    
}

- (void)generateCellWithModel:(NSDictionary *)model {
    _model = model;
    _titleLbl.text = model[@"title"];
    _contentTxt.text = model[@"value"];
    _contentTxt.placeholder = model[@"place"];
    
    _contentTxt.enabled = YES;
    [_moreInfoImgView setHidden:YES];
}

- (void)generateCellWithTitle:(NSString *)title andInfo:(NSString *)info {
    _titleLbl.text = title;
    _contentTxt.text = info;
    
    _contentTxt.enabled = NO;
    [_moreInfoImgView setHidden:NO];
}

- (NSString *)cellTitle {
    return _titleLbl.text;
}

- (void)setImgHidden:(BOOL)hidden {
    [_moreInfoImgView setHidden:hidden];
}

- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _viewScale = iphone6P ? scale6PAdapter : scaleAdapter;
        
        _titleLbl = [UILabel new];
        _titleLbl.font = [UIFont appFontRegularOfSize:15 * _viewScale];
        _titleLbl.textColor = [UIColor blackColor];
        [self.contentView addSubview:_titleLbl];
        
        _contentTxt = [UITextField new];
        _contentTxt.delegate = self;
        _contentTxt.textColor = [UIColor UIColorWithHexColorString:@"0x5e5d5d" AndAlpha:1];
        _contentTxt.font = [UIFont systemFontOfSize:13 * _viewScale];
        [self.contentView addSubview:_contentTxt];
        //配置提示语
        //[_contentTxt setValue:[UIColor redColor] forKey:@"_placeholderLabel.textColor"];
        //[_contentTxt setValue:[UIFont boldSystemFontOfSize:14] forKeyPath:@"_placeholderLabel.font"];
        
        _moreInfoImgView = [UIImageView new];
        [_moreInfoImgView setImage:[UIImage imageNamed:@"箭头_右_灰"]];
        _moreInfoImgView.contentMode = UIViewContentModeScaleAspectFit;
        [_moreInfoImgView setHidden:YES];
        [self.contentView addSubview:_moreInfoImgView];
        
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
    
    _moreInfoImgView.frame = CGRectMake(Width(self.contentView) - 23 * _viewScale, (cellHeight - 16 * _viewScale) / 2, 8 * _viewScale, 16 * _viewScale);
    
    _contentTxt.frame = CGRectMake(105 * _viewScale, 0, Width(self.contentView) - 133 * _viewScale, cellHeight);
    
    _lineView.frame = CGRectMake(0, cellHeight - thinLineHeight, Width(self.contentView), thinLineHeight);
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
}

#pragma mark -
- (void)textFieldDidEndEditing:(UITextField *)textField {
    //输入判断
    
    //Model赋值
    if (self.delegate && [self.delegate respondsToSelector:@selector(HCTextInfoCellGetModel:)]) {
        [self.delegate HCTextInfoCellGetModel:_model];
    }else if (self.delegate && [self.delegate respondsToSelector:@selector(HCTextInfoInput:withTitle:)]) {
        [self.delegate HCTextInfoInput:_contentTxt.text withTitle:_titleLbl.text];
    }
}
@end
