//
//  HCBaseViewController.m
//  newHaierCash
//
//  Created by Will on 2017/6/1.
//  Copyright © 2017年 haier. All rights reserved.
//

#import "HCMacro.h"

#import "HCBaseViewController.h"

@interface HCBaseViewController ()

{
    
    UITextField *_changeTextField;
    
}

@end

@implementation HCBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    self.edgesForExtendedLayout = UIRectEdgeBottom;

    [self setNavi];

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    
    self.view.frame = CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 64);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//设置导航
- (void)setNavi {
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = ReturnRect;
    [backBtn setImage:[UIImage imageNamed:@"返回_黑"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(OnBackBtn:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
}

- (void)OnBackBtn:(UIButton *)btn {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)addKeyBoardFrameAndTextField:(UITextField *)field{
    
      _changeTextField = field;
    
      [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(buildChangeKeyBoardFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
}

-(void)colseKeyBoardFrameAndTextField:(UITextField *)field{
    
     [[NSNotificationCenter defaultCenter]removeObserver:self];
    
}

//frame通知变化所调用的方法
-(void)buildChangeKeyBoardFrame:(NSNotification *)tion{
    
    NSDictionary *dic = [tion userInfo];
    
    //键盘停止后的frame
    CGRect keyboardEndFrame = [[dic objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    //获得当前视图的view
    
    UIView *view = self.view;
    
    //获得当前textField相对于视图的
    CGRect selfFrameFromUIWindow = [_changeTextField convertRect:_changeTextField.bounds toView:self.view];
    
    //获得当前textField到屏幕底部的距离
    
    if (keyboardEndFrame.origin.y < (selfFrameFromUIWindow.origin.y+selfFrameFromUIWindow.size.height)) {
        
        [UIView animateWithDuration:0.5 animations:^{
            view.frame = CGRectMake(0, keyboardEndFrame.origin.y-(selfFrameFromUIWindow.origin.y+selfFrameFromUIWindow.size.height), DeviceWidth, DeviceHeight);
        }];
        
    }else{
        
        [UIView animateWithDuration:0.5 animations:^{
            view.frame = CGRectMake(0,0, DeviceWidth, DeviceHeight);
        }];
        
        
    }
    
}


@end
