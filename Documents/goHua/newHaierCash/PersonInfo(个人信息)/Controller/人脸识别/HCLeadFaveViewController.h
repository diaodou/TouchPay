//
//  HCLeadFaveViewController.h
//  newHaierCash
//
//  Created by 史长硕 on 2017/6/5.
//  Copyright © 2017年 haier. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SendSuccessDelegate.h"
#import "UnlockAccountViewController.h"

@interface HCLeadFaveViewController : UIViewController

@property(nonatomic,weak)id<SendSuccessDelegate> delegate;

@property (nonatomic,assign) FaceStatus faceStatus;//人脸识别是否完善

@property(nonatomic,copy) NSArray *imageArray;//替代影像数组

@property(nonatomic,copy) NSString *typCde;

@end
