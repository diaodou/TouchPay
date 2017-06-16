//
//  LoanTopView.m
//  personMerchants
//
//  Created by 百思为科 on 16/3/31.
//  Copyright © 2016年 海尔金融. All rights reserved.
//

#import "LoanTopView.h"
#import "HCMacro.h"
#import "UIFont+AppFont.h"

@implementation LoanTopView
{
    UIView *viewBg;
}
@synthesize scale,xSpace,twelfthFont;
#pragma mark - lift Cycle
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        scale = DeviceWidth / 375;
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
    
    self.labelTime = [[UILabel alloc]initWithFrame:CGRectMake(10, (35 * scale - 20) / 2 , 160, 20)];
    if (iphone6P) {
        
        self.labelTime.frame = CGRectMake(20, (35 * scale - 20) / 2 , 160, 20);
    }
    self.labelTime.font = twelfthFont;
    self.labelTime.textColor = UIColorFromRGB(0x666666, 1.0);
    
    self.labelState = [[UILabel alloc]initWithFrame:CGRectMake(DeviceWidth - 210, CGRectGetMinY(self.labelTime.frame), 200, CGRectGetHeight(self.labelTime.frame))];
    if (iphone6P) {
        
        self.labelState.frame = CGRectMake(DeviceWidth - 220, CGRectGetMinY(self.labelTime.frame), 200, CGRectGetHeight(self.labelTime.frame));
    }
    self.labelState.textAlignment = NSTextAlignmentRight;
    self.labelState.textColor = UIColorFromRGB(0xea3937, 1.0f);
    self.labelState.font = twelfthFont;
    
    viewBg = [[UIView alloc]initWithFrame:CGRectMake(0, 35 * scale, DeviceWidth, 80 * scale)];
    self.viewIcon = [[UIImageView alloc]initWithFrame:CGRectMake(10, 5, CGRectGetHeight(viewBg.frame) - 10, CGRectGetHeight(viewBg.frame) - 10)];
    if (iphone6P) {
        
        self.viewIcon.frame = CGRectMake(20, 5, CGRectGetHeight(viewBg.frame) - 10, CGRectGetHeight(viewBg.frame) - 10);
    }
    viewBg.backgroundColor = UIColorFromRGB(0xfafafa, 1.0);
    viewBg.userInteractionEnabled = YES;
    [viewBg addSubview:self.viewIcon];
    
    self.labelRight = [[UILabel alloc]initWithFrame:CGRectMake(DeviceWidth - 110, CGRectGetHeight(viewBg.frame) / 2 - 25, 100, 50)];
    if (iphone6P) {
        self.labelRight.frame = CGRectMake(DeviceWidth - 120, CGRectGetHeight(viewBg.frame) / 2 - 25, 100, 50);
    }
    self.labelRight.numberOfLines = 2;
    self.labelRight.textAlignment = NSTextAlignmentRight;
    self.labelRight.textColor = UIColorFromRGB(0x666666, 1.0);
    self.labelRight.font = twelfthFont;
    self.labelRight.backgroundColor = [UIColor clearColor];
    [viewBg addSubview:self.labelRight];
    
    
    self.labelMidContent = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(_viewIcon.frame) + CGRectGetWidth(_viewIcon.frame) + 8 , CGRectGetHeight(viewBg.frame) / 2 - 25 , CGRectGetMinX(self.labelRight.frame) - CGRectGetMaxX(_viewIcon.frame) - 8 - 3, 50)];
    self.labelMidContent.font = twelfthFont;
    self.labelMidContent.numberOfLines = 2;
    self.labelMidContent.backgroundColor = [UIColor clearColor];
    [viewBg addSubview:self.labelMidContent];
    
    self.viewArrow = [[UIImageView alloc]initWithFrame:CGRectMake(DeviceWidth - 27, CGRectGetHeight(viewBg.frame) / 2 - 7.5, 10, 15)];
    self.viewArrow.image = [UIImage imageNamed:@""];
    
    
    self.labelTopContent = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.viewIcon.frame) + 14 * scale, CGRectGetHeight(viewBg.frame) / 2 - 25, CGRectGetMinX(self.viewArrow.frame) - CGRectGetMaxX(self.viewIcon.frame) - xSpace - 4, 20)];
    self.labelTopContent.font = twelfthFont;
    self.labelTopContent.textColor = UIColorFromRGB(0x3e4346, 1.0);
    self.labelBottomContent = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(self.labelTopContent.frame), CGRectGetMaxY(self.labelTopContent.frame) + 5, CGRectGetWidth(self.labelTopContent.frame), CGRectGetHeight(self.labelTopContent.frame))];
    self.labelBottomContent.font = twelfthFont;
    self.labelBottomContent.textColor = UIColorFromRGB(0x3e4346, 1.0);
    
    [viewBg addSubview:self.viewArrow];
    [viewBg addSubview:self.labelTopContent];
    [viewBg addSubview:self.labelBottomContent];
    
    self.viewArrow.hidden = YES;
    self.labelTopContent.hidden = YES;
    self.labelBottomContent.hidden = YES;
    self.labelRight.hidden = YES;
    self.labelMidContent.hidden = YES;
    self.labelTopContent.backgroundColor = [UIColor clearColor];
    self.labelBottomContent.backgroundColor = [UIColor clearColor];
    
    [self addSubview:self.labelTime];
    [self addSubview:self.labelState];
    [self addSubview:viewBg];
}

- (UIView *)returnBgView{
    return viewBg;
}

+ (CGFloat)heightTopView {
    return 115 * DeviceWidth / 375;
}

@end
