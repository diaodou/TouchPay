//
//  LoanBottomView.m
//  personMerchants
//
//  Created by Apple on 16/4/1.
//  Copyright © 2016年 海尔金融. All rights reserved.
//

#import "LoanBottomView.h"
#import "HCMacro.h"
#import "UIFont+AppFont.h"
@implementation LoanBottomView

@synthesize scale,xSpace,twelfthFont;
#pragma mark - lift Cycle
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        scale = DeviceWidth / 375.0;
        if (scale < 1) {
            twelfthFont = [UIFont appFontRegularOfSize:11];
        }else {
            twelfthFont = [UIFont appFontRegularOfSize:12];
        }
        xSpace = 14.0 * scale;
        [self setUI];
    }
    return self;
}
#pragma mark - setting and getting
- (void)setUI {
    if (iphone6 || iphone6P) {
    
    //合计
    self.bottomLabel = [[UILabel alloc]initWithFrame:CGRectMake(10*DeviceWidth/375, 30*scale6PAdapter, 348.5*DeviceWidth/375, 14)];
    self.bottomLabel.font = twelfthFont;
    self.bottomLabel.textColor = [UIColor blackColor];
    self.bottomLabel.font = [UIFont systemFontOfSize:13];
    self.bottomLabel.textAlignment =  NSTextAlignmentRight;
    self.bottomLabel.textColor = UIColorFromRGB(0x333333, 1.0);
    [self addSubview:self.bottomLabel];
    //       虚线
    self.lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 50, DeviceWidth, 1)];
    self.lineView.backgroundColor = [UIColor colorWithRed:0.8392 green:0.8392 blue:0.8392 alpha:1.0];
   [self addSubview:self.lineView];
    //        3个按钮
    self.leftBottomButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.leftBottomButton.frame = CGRectMake(145.5*DeviceWidth/375, 57, 67*DeviceWidth/375 , 29);
    self.leftBottomButton.layer.cornerRadius = 14.5;
    self.leftBottomButton.layer.borderColor = UIColorFromRGB(0x9e9e9e, 1).CGColor;
    self.leftBottomButton.layer.borderWidth = 0.5;
    self.leftBottomButton.titleLabel.font = twelfthFont;
    [self.leftBottomButton setTitleColor:UIColorFromRGB(0x656565, 1) forState:UIControlStateNormal];
    [self addSubview:self.leftBottomButton];
    
    self.centerBottomButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.centerBottomButton.layer.cornerRadius = 14.5;

    self.centerBottomButton.frame = CGRectMake(145.5*DeviceWidth/375 + 73*DeviceWidth/375, 57, 67*DeviceWidth/375 , 29);
    self.centerBottomButton.layer.borderColor = UIColorFromRGB(0x9e9e9e, 1).CGColor;
    self.centerBottomButton.layer.borderWidth = 0.5;
    self.centerBottomButton.titleLabel.font = twelfthFont;
    [self.centerBottomButton setTitleColor:UIColorFromRGB(0x656565, 1) forState:UIControlStateNormal];
    [self addSubview:self.centerBottomButton];
    
    self.rightBottomButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.rightBottomButton.frame = CGRectMake(145.5*DeviceWidth/375 + 73*DeviceWidth/375 + 73*DeviceWidth/375, 57, 67*DeviceWidth/375 , 29);
    self.rightBottomButton.layer.cornerRadius = 14.5;
    self.rightBottomButton.titleLabel.font = twelfthFont;
    [self.rightBottomButton setBackgroundColor:UIColorFromRGB(0x028de5, 1)];
    [self.rightBottomButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
   [self addSubview:self.rightBottomButton];
    //    下方灰色阴影
    self.bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, 92, DeviceWidth, 8)];
    self.bottomView.backgroundColor = [UIColor colorWithRed:0.8392 green:0.8392 blue:0.8392 alpha:1.0];
    [self addSubview:self.bottomView];
    
    self.bottomLabel.hidden = YES;
    self.lineView.hidden = YES;
    self.leftBottomButton.hidden = YES;
    self.centerBottomButton.hidden = YES;
    self.rightBottomButton.hidden = YES;
    self.bottomView.hidden = YES;
    }else{
        //合计
        self.bottomLabel = [[UILabel alloc]initWithFrame:CGRectMake(10*DeviceWidth/375,0, 348.5*DeviceWidth/375, 12)];
        self.bottomLabel.font = twelfthFont;
        self.bottomLabel.textColor = [UIColor blackColor];
        self.bottomLabel.font = [UIFont systemFontOfSize:11];
        self.bottomLabel.textAlignment =  NSTextAlignmentRight;
        self.bottomLabel.textColor = UIColorFromRGB(0x333333, 1.0);
        [self addSubview:self.bottomLabel];
        //       虚线
        self.lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 18, DeviceWidth, 0.5)];
        self.lineView.backgroundColor = [UIColor colorWithRed:0.8392 green:0.8392 blue:0.8392 alpha:1.0];
        [self addSubview:self.lineView];
        //        3个按钮
        self.leftBottomButton = [UIButton buttonWithType:UIButtonTypeSystem];
        self.leftBottomButton.frame = CGRectMake(145.5*DeviceWidth/375, 22, 67*DeviceWidth/375 , 27);
        self.leftBottomButton.layer.cornerRadius = 13.5;
        self.leftBottomButton.layer.borderColor = UIColorFromRGB(0x9e9e9e, 1).CGColor;
        self.leftBottomButton.layer.borderWidth = 0.5;
        self.leftBottomButton.titleLabel.font = twelfthFont;
        [self.leftBottomButton setTitleColor:UIColorFromRGB(0x656565, 1) forState:UIControlStateNormal];
        [self addSubview:self.leftBottomButton];
        
        self.centerBottomButton = [UIButton buttonWithType:UIButtonTypeSystem];
        self.centerBottomButton.frame = CGRectMake(145.5*DeviceWidth/375 + 73*DeviceWidth/375, 22, 67*DeviceWidth/375 , 27);
        self.centerBottomButton.layer.cornerRadius = 13.5;
        self.centerBottomButton.layer.borderColor = UIColorFromRGB(0x9e9e9e, 1).CGColor;
        self.centerBottomButton.layer.borderWidth = 0.5;
        self.centerBottomButton.titleLabel.font = twelfthFont;
        [self.centerBottomButton setTitleColor:UIColorFromRGB(0x656565, 1) forState:UIControlStateNormal];
        [self addSubview:self.centerBottomButton];
        
        self.rightBottomButton = [UIButton buttonWithType:UIButtonTypeSystem];
        self.rightBottomButton.frame = CGRectMake(145.5*DeviceWidth/375 + 73*DeviceWidth/375 + 73*DeviceWidth/375, 22, 67*DeviceWidth/375 , 27);
        self.rightBottomButton.layer.cornerRadius = 13.5;
        self.rightBottomButton.titleLabel.font = twelfthFont;
        self.rightBottomButton.layer.borderWidth = 0.5;
        self.rightBottomButton.layer.borderColor = UIColorFromRGB(0x32beff, 1).CGColor;
        [self.rightBottomButton setTitleColor:UIColorFromRGB(0x32beff, 1.0) forState:UIControlStateNormal];
        [self addSubview:self.rightBottomButton];
        //    下方灰色阴影
        self.bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, 53, DeviceWidth, 8)];
        self.bottomView.backgroundColor = [UIColor colorWithRed:0.8392 green:0.8392 blue:0.8392 alpha:1.0];
        [self addSubview:self.bottomView];
        
        self.bottomLabel.hidden = YES;
        self.lineView.hidden = YES;
        self.leftBottomButton.hidden = YES;
        self.centerBottomButton.hidden = YES;
        self.rightBottomButton.hidden = YES;
        self.bottomView.hidden = YES;

    }
}
@end
