//
//  HCMyNotesViewController.m
//  newHaierCash
//
//  Created by 史长硕 on 2017/6/14.
//  Copyright © 2017年 haier. All rights reserved.
//

#import "HCMyNotesViewController.h"

@interface HCMyNotesViewController ()

@end

#pragma mark --> life Cycle

@implementation HCMyNotesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"兑换记录";
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark --> private Methods

@end
