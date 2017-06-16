//
//  BaseButton.m
//  完善信息模块
//
//  Created by apple on 16/3/31.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "BaseButton.h"

@implementation BaseButton

-(void)layoutSubviews{
    
    [super layoutSubviews];
    
    CGPoint center = self.imageView.center;
    
    center.x = self.frame.size.width/2;
    
    center.y = self.frame.size.height/2-5;
    
    self.imageView.center = center;
    
    CGRect new = [self titleLabel].frame;
    
    new.origin.x = 0;
    
    new.origin.y = self.imageView.frame.size.height+self.imageView.frame.origin.y +5;
    
    new.size.width = self.frame.size.width;
    
    self.titleLabel.frame = new;
    
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    
}
@end
