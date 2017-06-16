//
//  UILabel+SizeForStr.m
//  HaiercashMerchantsAPP
//
//  Created by 百思为科 on 16/3/28.
//  Copyright © 2016年 海尔金融. All rights reserved.
//

#import "UILabel+SizeForStr.h"

@implementation UILabel (SizeForStr)
- (CGSize)boundingRectWithSize:(CGSize)size
{
    CGSize retSize;
    NSDictionary *attribute = @{NSFontAttributeName: self.font};
    
    retSize = [self.text boundingRectWithSize:size
                                      options:\
               NSStringDrawingTruncatesLastVisibleLine |
               NSStringDrawingUsesLineFragmentOrigin |
               NSStringDrawingUsesFontLeading
                                   attributes:attribute
                                      context:nil].size;
    
    return retSize;
}
@end
