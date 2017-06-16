//
//  LogisticsView.m
//  物流信息
//
//  Created by 史长硕 on 2017/4/14.
//  Copyright © 2017年 史长硕. All rights reserved.
//

#import "LogisticsView.h"
#import "HCMacro.h"
#import "UIFont+AppFont.h"
@interface LogisticsView ()
{
    
    float x ;
    
}

@end

@implementation LogisticsView

#pragma mark --> life Cycle

-(instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        if (iphone6P) {
            
            x = 1;
            
        }else{
            
            x = scaleAdapter;
        }
        
        [self creatUI];
        
    }
    
    return self;
    
}

#pragma mark --> private Methods

//创建基本视图
-(void)creatUI{
    
    _wareImage = [[UIImageView alloc]initWithFrame:CGRectMake(23, 18*x, 76*x, 76*x)];
    
    _wareImage.image = [UIImage imageNamed:@"贷款列表默认图片"];
    
    [self addSubview:_wareImage];
    
    _officeLabel = [[UILabel alloc]initWithFrame:CGRectMake(115*x, 28*x, DeviceWidth-115*x, 20*x)];
    
    _officeLabel.font = [UIFont appFontRegularOfSize:14*x];
    
    [self addSubview:_officeLabel];
    
    _numberLabel = [[UILabel alloc]initWithFrame:CGRectMake(115*x, 62*x, DeviceWidth-115*x, 20*x)];
    
    _numberLabel.font = [UIFont appFontRegularOfSize:14*x];
    
    [self addSubview:_numberLabel];
    
}

@end
