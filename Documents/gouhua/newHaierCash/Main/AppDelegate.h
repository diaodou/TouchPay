//
//  AppDelegate.h
//  newHaierCash
//
//  Created by xuxie on 2017/4/19.
//  Copyright © 2017年 haier. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <YYCache.h>
#import <SDWebImageManager.h>
#import "HCUserModel.h"
#import "HCRecordedModel.h"
#import "HCRootNavController.h"
#import "HCMapLocation.h"
#import "GestureViewController.h"
@class SignModel;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, strong) HCUserModel *userInfo;

@property (nonatomic, strong) HCRecordedModel *recordedInfo;

@property (strong, nonatomic) YYCache *imagePutCache;

@property (strong, nonatomic) SDImageCache *imageCacheM;

@property (nonatomic, strong) HCMapLocation *mapLocation;

@property (nonatomic, strong) GestureViewController *verityGestureCon;

+(AppDelegate *)delegate;

@end

