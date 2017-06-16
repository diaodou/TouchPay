//
//  UIImagePickControllerSelf.h
//  personMerchants
//
//  Created by xuxie on 16/12/27.
//  Copyright © 2016年 海尔金融. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImagePickControllerSelf : UIImagePickerController
@property(nullable,nonatomic,assign)      id <UINavigationControllerDelegate, UIImagePickerControllerDelegate> delegate;
@end
