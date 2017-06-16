//
//  TopCollectionViewCell.m
//  newHaierCash
//
//  Created by 史长硕 on 2017/6/2.
//  Copyright © 2017年 haier. All rights reserved.
//

#import "TopCollectionViewCell.h"
#import "HCMacro.h"
#import "UIFont+AppFont.h"

@interface TopCollectionViewCell ()

{
    
    float x;
    
}

@end

@implementation TopCollectionViewCell

#pragma mark --> life Cycle

-(instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        if (iphone6P) {
            
            x = scale6PAdapter;
            
        }else{
            
            x = scaleAdapter;
            
        }
        
        [self creatBaseUI];
    }
    
    return self;
    
}

#pragma mark --> private Methods

//创建基本控件
-(void)creatBaseUI{
    
    _titleImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 20*x, 40*x, 40*x)];
    
    _titleImage.layer.cornerRadius = 20*x;
    
    [self.contentView addSubview:_titleImage];
    
    _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 62*x, 40*x, 20*x)];
    
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    
    _titleLabel.font = [UIFont appFontRegularOfSize:10*x];
    
    [self.contentView addSubview:_titleLabel];
    
    
}

//插入数据
-(void)insertInfomodel:(PeosonInfoType *)model{
    
    if (model.isFinish) {
        
        _titleImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"注册_%@_选中",model.title]];
        
        _titleLabel.textColor = [UIColor blackColor];
        
    }else{
        
         _titleImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"注册_%@_未选中",model.title]];
        
        _titleLabel.textColor = UIColorFromRGB(0x999999, 1.0);
        
    }
    
    _titleLabel.text = model.title;
}

@end
