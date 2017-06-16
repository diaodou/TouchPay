//
//  PayBackBottomView.m
//  personMerchants
//
//  Created by LLM on 16/11/14.
//  Copyright © 2016年 海尔金融. All rights reserved.
//

#import "PayBackBottomView.h"
#import "HCMacro.h"

#define Width self.frame.size.width
#define Height self.frame.size.height

@interface PayBackBottomView ()

@end

@implementation PayBackBottomView

- (void)createViewWithPayBackMoney:(NSAttributedString *)money andIconAction:(SEL)iconSEl andDetailAction:(SEL)detailSel andPayBackAction:(SEL)payBackSel andObject:(NSObject *)obj
{
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = [UIColor lightGrayColor];
    lineView.frame = CGRectMake(0, 0, Width, 0.5);
    [self addSubview:lineView];
    
    //图标
    UIButton *iconBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    iconBtn.frame = CGRectMake(10, (Height-30)/2, 30, 30);
    [iconBtn setImage:[UIImage imageNamed:@"图标_未选中"] forState:UIControlStateNormal];
    [iconBtn setImage:[UIImage imageNamed:@"图标_选中"] forState:UIControlStateSelected];
    [iconBtn addTarget:obj action:iconSEl forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:iconBtn];
    
    self.iconButton = iconBtn;
    [self.iconButton addObserver:self forKeyPath:@"hidden" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
    
    //金额
    self.moneyLabel = [[UILabel alloc] init];
    self.moneyLabel.attributedText = money;
    CGFloat width = [self.moneyLabel.attributedText boundingRectWithSize:CGSizeMake(0, Height) options:\
                     NSStringDrawingTruncatesLastVisibleLine |
                     NSStringDrawingUsesLineFragmentOrigin |
                     NSStringDrawingUsesFontLeading context:nil].size.width;
    self.moneyLabel.frame = CGRectMake(40, 0, width, Height);
    [self addSubview:self.moneyLabel];
    
    [self.moneyLabel addObserver:self forKeyPath:@"attributedText" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
    
    //还款明细按钮
    self.detailBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.detailBtn.frame = CGRectMake(CGRectGetMaxX(self.moneyLabel.frame), (Height-18)/2, 18, 18);
    [self.detailBtn setImage:[UIImage imageNamed:@"还款明细"] forState:UIControlStateNormal];
    [self.detailBtn addTarget:obj action:detailSel forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.detailBtn];
    
    //确认还款
    UIButton *payBackBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    payBackBtn.frame = CGRectMake(Width-145*scaleAdapter, 8, 125*scaleAdapter, Height - 16);
    payBackBtn.backgroundColor = UIColorFromRGB(0x028de5, 1.0);
    [payBackBtn setTitle:@"立即还款" forState:UIControlStateNormal];
    [payBackBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [payBackBtn addTarget:obj action:payBackSel forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:payBackBtn];
}


//当观察到keypath值改变的时候执行的方法
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if([keyPath isEqualToString:@"attributedText"])
    {
        CGFloat width = [self.moneyLabel.attributedText boundingRectWithSize:CGSizeMake(0, Height) options:\
                         NSStringDrawingTruncatesLastVisibleLine |
                         NSStringDrawingUsesLineFragmentOrigin |
                         NSStringDrawingUsesFontLeading context:nil].size.width;
        //如果数额太大,就不展示全部信息了
        if(width > Width-10-145*scaleAdapter-self.iconButton.frame.size.width-self.detailBtn.frame.size.width)
        {
            self.moneyLabel.frame = CGRectMake(CGRectGetMaxX(self.iconButton.frame), 0, Width-10-145*scaleAdapter-self.iconButton.frame.size.width-self.detailBtn.frame.size.width, Height);
        }else
        {
            self.moneyLabel.frame = CGRectMake(CGRectGetMaxX(self.iconButton.frame), 0, width, Height);
        }
        
        //重新得到明细按钮的位置
        self.detailBtn.frame = CGRectMake(CGRectGetMaxX(self.moneyLabel.frame), (Height-18)/2, 18, 18);
    }else if ([keyPath isEqualToString:@"hidden"])
    {
        if(self.iconButton.hidden)
        {
            CGRect moneyLabelFrame = self.moneyLabel.frame;
            CGRect detailFrame = self.detailBtn.frame;
            
            self.iconButton.frame = CGRectMake(10, (Height-30)/2, 0, 30);
            self.moneyLabel.frame = CGRectMake(CGRectGetMaxX(self.iconButton.frame), moneyLabelFrame.origin.y, moneyLabelFrame.size.width, moneyLabelFrame.size.height);
            self.detailBtn.frame = CGRectMake(CGRectGetMaxX(self.moneyLabel.frame), detailFrame.origin.y, detailFrame.size.width, detailFrame.size.height);
        }else
        {
            self.iconButton.frame = CGRectMake(10, (Height-30)/2, 30, 30);
            [self.iconButton setImage:[UIImage imageNamed:@"图标_未选中"] forState:UIControlStateNormal];
            [self.iconButton setImage:[UIImage imageNamed:@"图标_选中"] forState:UIControlStateSelected];
            CGFloat width = [self.moneyLabel.attributedText boundingRectWithSize:CGSizeMake(0, Height) options:\
                             NSStringDrawingTruncatesLastVisibleLine |
                             NSStringDrawingUsesLineFragmentOrigin |
                             NSStringDrawingUsesFontLeading context:nil].size.width;
            self.moneyLabel.frame = CGRectMake(40, 0, width, Height);
            self.detailBtn.frame = CGRectMake(CGRectGetMaxX(self.moneyLabel.frame), (Height-18)/2, 18, 18);
        }
    }
}


- (void)dealloc
{
    [self.moneyLabel removeObserver:self forKeyPath:@"attributedText"];
    [self.iconButton removeObserver:self forKeyPath:@"hidden"];
}
@end
