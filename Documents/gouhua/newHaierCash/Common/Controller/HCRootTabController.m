//
//  HCRootTabController.m
//  newHaierCash
//
//  Created by Will on 2017/5/27.
//  Copyright © 2017年 haier. All rights reserved.
//

#import "DefineSystemTool.h"

#import "HCMerchandiseController.h"
#import "HCMySelfController.h"
#import "HCSpecialLoanController.h"

#import "HCRootNavController.h"
#import "HCRootTabController.h"

@interface HCRootTabController ()

@end

@implementation HCRootTabController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self createTabBarItem];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)createTabBarItem {
    // 首页
    _homeCon = [HCHomeController new];
    HCRootNavController *homeNav = [[HCRootNavController alloc] initWithRootViewController:_homeCon];
    
    //精选商品
    HCMerchandiseController *merCon = [HCMerchandiseController new];
    HCRootNavController *merNav = [[HCRootNavController alloc] initWithRootViewController:merCon];
    
    //大额专享
    HCSpecialLoanController *loanCon = [HCSpecialLoanController new];
    HCRootNavController *loanNav = [[HCRootNavController alloc] initWithRootViewController:loanCon];
    
    //个人中心
    HCMySelfController *myCon = [HCMySelfController new];
    HCRootNavController *myNav = [[HCRootNavController alloc] initWithRootViewController:myCon];

    self.viewControllers = @[homeNav,merNav,loanNav,myNav];
    
    UITabBar *tabBar = self.tabBar;
    UITabBarItem *homeItem = [tabBar.items objectAtIndex:0];
    
    homeItem.title = @"首页";
    homeItem.titlePositionAdjustment = UIOffsetMake(0, -4);
    homeItem.image = [UIImage imageNamed:@"首页_选中"];
    homeItem.selectedImage = [UIImage imageNamed:@"首页_未选中"];
    
    UITabBarItem *merItem = [tabBar.items objectAtIndex:1];
    merItem.titlePositionAdjustment = UIOffsetMake(0, -4);
    merItem.title = @"精选商品";
    merItem.image = [UIImage imageNamed:@"精选商品_选中"];
    merItem.selectedImage = [UIImage imageNamed:@"精选商品_未选中"];
    
    UITabBarItem *loanItem = [tabBar.items objectAtIndex:2];
    loanItem.titlePositionAdjustment = UIOffsetMake(0, -4);
    loanItem.title = @"大额专享";
    loanItem.image = [UIImage imageNamed:@"大额专享_选中"];
    loanItem.selectedImage = [UIImage imageNamed:@"大额专享_未选中"];
    
    UITabBarItem *myItem = [tabBar.items objectAtIndex:3];
    myItem.titlePositionAdjustment = UIOffsetMake(0, -4);
    myItem.title = @"个人中心";
    myItem.image = [UIImage imageNamed:@"个人中心_选中"];
    myItem.selectedImage = [UIImage imageNamed:@"个人中心_未选中"];
    
    self.tabBar.translucent = NO;
    [[UITabBar appearance] setTintColor:[DefineSystemTool tabBarColor]];
}

@end
