//
//  UIButton+LargeEdge.h
//  XZB
//
//  Created by lmondi on 16/9/29.
//  Copyright © 2016年 Rich. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (LargeEdge)
- (void)setLargeEdge:(CGFloat) size;
- (void)setLargeEdgeWithTop:(CGFloat) top right:(CGFloat) right bottom:(CGFloat) bottom left:(CGFloat) left;
@end
