//
//  HCFreeTicketCell.m
//  newHaierCash
//
//  Created by Will on 2017/6/5.
//  Copyright © 2017年 haier. All rights reserved.
//

#import "HCMacro.h"
#import "UIFont+AppFont.h"

#import "HCFreeTicketCell.h"
@interface HCFreeTicketCell() {
    CGFloat _viewScale;
    NSDictionary *_model;
    
    UIImageView *_freeTicketImgView;
    UIButton *_getTicketBtn;
    UIView *_lineView;
}

@end

@implementation HCFreeTicketCell

-(void)generateCellWithModel:(NSDictionary *)model andAlreadyGet:(BOOL)isGet{
    _model = model;
    [_freeTicketImgView setImage:[UIImage imageNamed:model[@"image"]]];
    if (isGet) {
        [_getTicketBtn setSelected:YES];
        [_getTicketBtn setTitle:NSLocalizedString(@"已领取", nil) forState:UIControlStateNormal];
    }
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _viewScale = iphone6P ? scale6PAdapter : scaleAdapter;
        
        _freeTicketImgView = [UIImageView new];
        _freeTicketImgView.backgroundColor = [UIColor clearColor];
        _freeTicketImgView.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:_freeTicketImgView];
        
        _getTicketBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_getTicketBtn setSelected:NO];
        [_getTicketBtn setTitle:NSLocalizedString(@"领取", nil) forState:UIControlStateNormal];
        [_getTicketBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _getTicketBtn.titleLabel.font = [UIFont appFontRegularOfSizePxSys:21 * _viewScale];
        [_getTicketBtn addTarget:self action:@selector(_getTicketBtnDidClick) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_getTicketBtn];
        
        _lineView = [UIView new];
        _lineView.backgroundColor = [UIColor grayColor];
        [self addSubview:_lineView];
        
    }
    return self;
}

-(void)layoutSubviews {
    [super layoutSubviews];
    
    _freeTicketImgView.frame = CGRectMake(15 * _viewScale, 10 *_viewScale, DeviceWidth - 135 *_viewScale, 60 * _viewScale);
    
    _getTicketBtn.frame = CGRectMake(DeviceWidth - 105 * _viewScale, 24 * _viewScale, 90 * _viewScale, 21 * _viewScale);
    
    _lineView.frame = CGRectMake(0, 70 * _viewScale - thinLineHeight, Width(self.contentView), thinLineHeight);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

#pragma mark - ButtonEvent
- (void)_getTicketBtnDidClick {
    if (_getTicketBtn.isSelected) {
        return;
    }
    [_getTicketBtn setSelected:YES];
    [_getTicketBtn setTitle:NSLocalizedString(@"已领取", nil) forState:UIControlStateNormal];
    
    //领取免息券逻辑
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(HCFreeTicketCellGetFreeTicket:)]) {
        [self.delegate HCFreeTicketCellGetFreeTicket:_model];
    }

}
@end
