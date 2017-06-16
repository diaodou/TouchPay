//
//  TopSelectView.m
//  HaiercashMerchantsAPP
//
//  Created by 史长硕 on 17/1/11.
//  Copyright © 2017年 海尔金融. All rights reserved.
//

#import "TopSelectView.h"
#import "HCMacro.h"
#import "UIFont+AppFont.h"
#import "UIColor+DefineNew.h"
@implementation TopSelectView

#pragma mark --> life Cycle

-(instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        [self creatBaseUI];
        
    }
    
    return self;
}

#pragma mark --> private Methods

-(void)creatBaseUI{
    
    self.backgroundColor = [UIColor UIColorWithHexColorString:@"0x7f7f7f" AndAlpha:0.8];
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, self.frame.size.height-35, DeviceWidth, 35)];
    
    view.backgroundColor = [UIColor whiteColor];
    
    [self addSubview:view];
    
    UIButton *sureBtn  = [[UIButton alloc]initWithFrame:CGRectMake(DeviceWidth-65, self.frame.size.height-35, 35, 35)];
    
    [sureBtn setTitle:@"确定" forState:UIControlStateNormal];

    [sureBtn setTitleColor:UIColorFromRGB(0x32beff, 1.0) forState:UIControlStateNormal];
    
    sureBtn.tag = 76;
    
    sureBtn.titleLabel.font = [UIFont appFontRegularOfSize:14];
    
    [sureBtn addTarget:self action:@selector(creatSureAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:sureBtn];
    
    UIButton *releaseBtn  = [[UIButton alloc]initWithFrame:CGRectMake(30, self.frame.size.height-35, 35, 35)];
    
    releaseBtn.tag = 77;
    
    releaseBtn.titleLabel.font = [UIFont appFontRegularOfSize:14];
    
    [releaseBtn setTitle:@"取消" forState:UIControlStateNormal];
    
    [releaseBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [releaseBtn addTarget:self action:@selector(creatSureAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:releaseBtn];
    
}

#pragma mark --> event Methods

-(void)creatSureAction:(UIButton *)sender{
    
    if (sender.tag == 77) {
        
        if (_delegate && [_delegate respondsToSelector:@selector(sendSelect:)]) {
            
            [_delegate sendSelect:NO];
            
        }
        
    }else{
        
        if (_delegate && [_delegate respondsToSelector:@selector(sendSelect:)]) {
            
            [_delegate sendSelect:YES];
            
        }
        
    }
    
}

@end
