//
//  HCChoiceTopView.m
//  newHaierCash
//
//  Created by 史长硕 on 2017/5/31.
//  Copyright © 2017年 haier. All rights reserved.
//

#import "HCChoiceTopView.h"
#import "HCMacro.h"
#import "UIFont+AppFont.h"
#import "UIColor+DefineNew.h"
@interface HCChoiceTopView ()

{
    
    float x;//屏幕适配比例
    
    NSInteger _nowSelectButton;//记录所选中button的tag值
    
}

@property(nonatomic,strong)UIView *lineView;//下标视图

@end

@implementation HCChoiceTopView

#pragma mark --> life Cycle

-(instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        if (iphone6P) {
            
            x = scale6PAdapter;
            
        }else{
            
            x = DeviceWidth/375.0;
            
        }
        
    }
    
    return self;
    
}

-(void)setNameArray:(NSArray *)nameArray{
    
    _nameArray = nameArray;
    
    [self creatLineView];
    
    [self creatBaseButton];
    
}

#pragma mark --> private Methods

//创建下标视图
-(void)creatLineView{
    
    float width = DeviceWidth/_nameArray.count;
    
    _lineView = [[UIView alloc]initWithFrame:CGRectMake(0, self.bounds.size.height-1, width, 2)];
    
    _lineView.backgroundColor = [UIColor UIColorWithHexColorString:@"0x32beff" AndAlpha:1.0];
    
    [self addSubview:_lineView];
    
}

//创建基本视图，用button按钮创建
-(void)creatBaseButton{
    
    float width = DeviceWidth/_nameArray.count;
    
    for (int i = 0; i<_nameArray.count; i++) {
        
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(i*width, 0, width, self.bounds.size.height-1)];
        
        [button setTitle:_nameArray[i] forState:UIControlStateNormal];
        
        [button setTitleColor:[UIColor UIColorWithHexColorString:@"0x999999" AndAlpha:1.0] forState:UIControlStateNormal];
        
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
        
        [button addTarget:self action:@selector(buildChoiceType:) forControlEvents:UIControlEventTouchUpInside];
        
        button.tag = 10+i;
        
        button.titleLabel.font = [UIFont appFontRegularOfSize:15];
        
        if (i == 0) {
            
            button.selected = YES;
            
            _nowSelectButton = 10;
            
        }
        
        [self addSubview:button];
        
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(i*width, 0, 0.5, self.bounds.size.height-1)];
        
        view.backgroundColor = UIColorFromRGB(0xdddddd, 1.0);
        
        [self addSubview:view];
        
    }
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 0.5)];
    
    view.backgroundColor = UIColorFromRGB(0xdddddd, 1.0);
    
    [self addSubview:view];
}

#pragma mark --> event Methods
//选择栏目中的内容
-(void)buildChoiceType:(UIButton *)sender{
    
    UIButton *button = (UIButton *)[self viewWithTag:_nowSelectButton];
    
    if ([button isEqual:sender]) {
        
        return;
        
    }else{
        
        button.selected = NO;
        
        sender.selected = !sender.selected;
        
        _nowSelectButton = sender.tag;
        
        WEAKSELF
        
        float width = DeviceWidth/_nameArray.count;
        
        [UIView animateWithDuration:0.3 animations:^{
            
            STRONGSELF
            
            if (strongSelf) {
                
                strongSelf.lineView.frame = CGRectMake(sender.frame.origin.x, strongSelf.bounds.size.height-1, width, 1);
                
            }
            
        }];
        
        if (_delegate && [_delegate respondsToSelector:@selector(sendChoiceType:)]) {
            
            [_delegate sendChoiceType:sender.tag-10];
            
        }
        
    }
    
}


@end
