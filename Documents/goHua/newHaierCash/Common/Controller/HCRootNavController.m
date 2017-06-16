//
//  HCRootNavController.m
//  newHaierCash
//
//  Created by Will on 2017/5/27.
//  Copyright © 2017年 haier. All rights reserved.
//

#import "UIColor+DefineNew.h"
#import "UIFont+AppFont.h"

#import "DefineSystemTool.h"
#import "HCRootNavController.h"


@interface HCRootNavController ()

@end

@implementation HCRootNavController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationBar.translucent = NO;
    //注意皮肤的更改逻辑
    /*
    //改变导航栏背景色f
    [[UINavigationBar appearance] setBarTintColor:[DefineSystemTool naviColor]];
    
    //改变导航栏返回和按钮色
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    //改变导航栏标题色
    [[UINavigationBar appearance]  setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0], NSForegroundColorAttributeName,[UIFont appFontRegularOfSize:19], NSFontAttributeName,nil]];
    */
    
    UIColor *defaultColor = [UIColor UIColorWithHexColorString:@"#666666" AndAlpha:1];
    //改变导航栏背景色f
    [[UINavigationBar appearance] setBarTintColor:[UIColor whiteColor]];
    
    //改变导航栏返回和按钮色
    [[UINavigationBar appearance] setTintColor:defaultColor];
    //改变导航栏标题色
    [[UINavigationBar appearance]  setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:defaultColor, NSForegroundColorAttributeName,[UIFont appFontRegularOfSize:19], NSFontAttributeName,nil]];
    
    //视图控制器，四条边不指定
    self.extendedLayoutIncludesOpaqueBars = NO;//不透明的操作栏
    self.modalPresentationCapturesStatusBarAppearance = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [[UINavigationBar appearance] setBackgroundImage:[[UIImage alloc] init] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setShadowImage:[[UIImage alloc] init]];
    
    //[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    self.navigationItem.backBarButtonItem.enabled = NO;
    [self.navigationItem setHidesBackButton:YES];
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    
    return UIStatusBarStyleLightContent;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (UIViewController *)naviRootControl {
    NSArray *arr = self.viewControllers;
    if (arr.count > 0) {
        return arr[0];
    }else {
        return NULL;
    }
}

@end
