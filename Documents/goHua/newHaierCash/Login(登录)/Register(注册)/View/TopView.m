//
//  TopView.m
//  HaiFu
//
//  Created by 百思为科 on 17/2/8.
//  Copyright © 2017年 百思为科. All rights reserved.
//

#import "TopView.h"
#import "HCMacro.h"
@implementation TopView
#pragma mark - lift cycle
- (instancetype)initWithFrame:(CGRect)frame{

    if (self = [super initWithFrame:frame]) {
        [self setUI];
    }
    return self;
}
#pragma mark - setting and getting 
- (void)setUI{
    
    if (iphone6P) {
        
        UIView * bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DeviceWidth/4 + 5.5, 70 )];
        
        [self addSubview:bottomView];
        
        _titleImage = [[UIImageView alloc]initWithFrame:CGRectMake(DeviceWidth/8 - 13, 14 , 26, 26)];
        
        [bottomView addSubview:_titleImage];
        
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_titleImage.frame), DeviceWidth/4, 26)];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        
        _titleLabel.font = [UIFont systemFontOfSize:10];
        
        [bottomView addSubview:_titleLabel];
        
        _arrowImage = [[UIImageView alloc]initWithFrame:CGRectMake(DeviceWidth/4, 30, 5.5, 10.5)];
        
        [bottomView addSubview:_arrowImage];
    }else{
        
        UIView * bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DeviceWidth/4 + 5.5, 45)];
        
        [self addSubview:bottomView];
        
        _titleImage = [[UIImageView alloc]initWithFrame:CGRectMake(DeviceWidth/8 - 10, 0, 20, 20)];
        
        [bottomView addSubview:_titleImage];
        
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_titleImage.frame), DeviceWidth/4, 13)];
        
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        
        _titleLabel.font = [UIFont systemFontOfSize:9];
        
        [bottomView addSubview:_titleLabel];
        
        _arrowImage = [[UIImageView alloc]initWithFrame:CGRectMake(DeviceWidth/4, 10, 5.5, 10.5)];
        
        [bottomView addSubview:_arrowImage];
    }
}
@end
