//
//  HCLeadFaveViewController.m
//  newHaierCash
//
//  Created by 史长硕 on 2017/6/5.
//  Copyright © 2017年 haier. All rights reserved.
//

#import "HCLeadFaveViewController.h"
#import "HCMacro.h"
#import "UIFont+AppFont.h"
@interface HCLeadFaveViewController ()

{
    
    float x;
    
}

@end

@implementation HCLeadFaveViewController

#pragma mark --> life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [self creatBaseUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark --> private Meyhods

//
-(void)creatBaseUI{
    
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(100, 100, 100, 50)];
    
    [button addTarget:self action:@selector(buildToNextView:) forControlEvents:UIControlEventTouchUpInside];
    
    button.backgroundColor = [UIColor redColor];
    
    [self.view addSubview:button];
    
}

#pragma mark --> event Methods

-(void)buildToNextView:(UIButton *)sender{
    
    if (_delegate && [_delegate respondsToSelector:@selector(sendSaveInfoViewType:)]) {
        
        [_delegate sendSaveInfoViewType:ToFaceVerification];
        
    }
    
}

@end
