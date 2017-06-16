//
//  BoostGesture.h
//  HaiercashMerchantsAPP
//
//  Created by 史长硕 on 16/8/28.
//  Copyright © 2016年 海尔金融. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BoostGesture : UIPinchGestureRecognizer

@property(nonatomic,strong)UIImageView *imgView;

@property(nonatomic,assign)CGFloat lastScale;


@end
