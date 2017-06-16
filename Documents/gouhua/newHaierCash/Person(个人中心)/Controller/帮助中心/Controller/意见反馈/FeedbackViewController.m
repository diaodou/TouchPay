//
//  FeedbackViewController.m
//  personMerchants
//
//  Created by Apple on 16/3/31.
//  Copyright © 2016年 海尔金融. All rights reserved.
//

#import "FeedbackViewController.h"
#import "HCMacro.h"
#import "RMUniversalAlert.h"
#import "UIFont+AppFont.h"
#import <IQKeyboardManager.h>
#import <YYTextView.h>
#import "MBProgressHUD.h"
#import "RMUniversalAlert.h"
#import "AppDelegate.h"
#import "BSVKHttpClient.h"
#import "NSString+CheckConvert.h"
#import <MJExtension.h>
#import <MJRefresh.h>
#import "MJRefreshGifHeader.h"
@interface FeedbackViewController ()<YYTextViewDelegate,BSVKHttpClientDelegate>{
    YYTextView *topTextView;
    
    UIScrollView *scrollView;
}

@end

@implementation FeedbackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title =@"意见反馈";
    self.view.backgroundColor = UIColorFromRGB(0xf6f6f6, 1.0);
    scrollView = [[UIScrollView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    scrollView.backgroundColor = UIColorFromRGB(0xf6f6f6, 1);
    [self.view addSubview:scrollView];
    
    [self creattextView];//输入框
    [self creatSubmit];//提交
    [self setNavi];//导航
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [[IQKeyboardManager sharedManager]setEnable:NO];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[IQKeyboardManager sharedManager]setEnable:YES];
}

//输入框
-(void)creattextView{
    topTextView = [[YYTextView alloc]initWithFrame:CGRectMake(41*scale6PAdapter, 32.3*scale6PAdapter, DeviceWidth - 82*scale6PAdapter, 233.3*scale6PAdapter)];
    topTextView.font = [UIFont systemFontOfSize:14];
    topTextView.delegate = self;
    topTextView.backgroundColor = [UIColor whiteColor];
    topTextView.editable = YES;
    topTextView.scrollEnabled = YES;
    topTextView.returnKeyType = UIReturnKeyDefault;//返回键的类型
    topTextView.keyboardType = UIKeyboardTypeDefault;//键盘类型
    
    [scrollView addSubview:topTextView];
    
    topTextView.placeholderFont = [UIFont appFontRegularOfSize:15];
    topTextView.placeholderText =  @"请输入您需要帮助的问题";
    topTextView.placeholderTextColor = [UIColor colorWithRed:0.9098 green:0.9176 blue:0.9216 alpha:1.0];
    
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
//提交
-(void)creatSubmit{
    UIButton *submitButton = [UIButton buttonWithType:UIButtonTypeSystem];
    if (iphone6P) {
        submitButton.frame = CGRectMake(48, 314*scale6PAdapter, DeviceWidth-96, 50);
        submitButton.layer.cornerRadius = 25.f;
    }else{
        submitButton.frame=CGRectMake(48, 314*scale6PAdapter, DeviceWidth-96, 45);
        submitButton.layer.cornerRadius = 22.5f;
    }
    submitButton.backgroundColor=UIColorFromRGB(0x32beff, 1);
    [submitButton setTitle:@"提 交" forState:UIControlStateNormal];
    [submitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [submitButton addTarget:self action:@selector(submit) forControlEvents:UIControlEventTouchUpInside];
    submitButton.titleLabel.font = [UIFont appFontRegularOfSize:17];
    [scrollView addSubview:submitButton];
}
-(void)submit{
    
    NSString *str = [topTextView.text deleteSpeaceString];
    
    if (str.length > 400) {
        WEAKSELF
        [RMUniversalAlert showAlertInViewController:self withTitle:@"提示" message:@"请输入400字以内的反馈意见" cancelButtonTitle:@"知道了" destructiveButtonTitle:nil otherButtonTitles:nil tapBlock:^(RMUniversalAlert * _Nonnull alert, NSInteger buttonIndex) {
            STRONGSELF
            if (strongSelf) {
                if (buttonIndex == 0) {
                    
                }
            }
        }];
        return;
    }else if (str.length < 10){
        WEAKSELF
        [RMUniversalAlert showAlertInViewController:self withTitle:@"提示" message:@"请输入10字以上的反馈意见" cancelButtonTitle:@"知道了" destructiveButtonTitle:nil otherButtonTitles:nil tapBlock:^(RMUniversalAlert * _Nonnull alert, NSInteger buttonIndex) {
            STRONGSELF
            if (strongSelf) {
                if (buttonIndex == 0) {
                    
                }
            }
        }];
        return;
    }else{
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        [BSVKHttpClient shareInstance].delegate = self;
        
        [[BSVKHttpClient shareInstance]postInfo:@"app/appmanage/feedback/save" requestArgument:@{@"feedbackContent":topTextView.text,@"userMobile":[AppDelegate delegate].userInfo.userTel} requestTag:1 requestClass:NSStringFromClass([self class])];
    }
}
#pragma mark - Text View delegates
-(void)textViewDidChange:(UITextView *)textView{
    
//    if ([textView.text isEqualToString:@" "]) {
//        WEAKSELF
//        [RMUniversalAlert showAlertInViewController:self withTitle:@"提示" message:@"请不要输入空格" cancelButtonTitle:@"知道了" destructiveButtonTitle:nil otherButtonTitles:nil tapBlock:^(RMUniversalAlert * _Nonnull alert, NSInteger buttonIndex) {
//            STRONGSELF
//            if (strongSelf) {
//                if (buttonIndex == 0) {
//                    textView.text = nil;
//                    
//                }
//            }
//        }];
//        
//    }
    
    
}
-(void)textViewDidBeginEditing:(UITextView *)textView{

    if (IPHONE4) {
            [UIView animateWithDuration:0.27 animations:^{
                
                topTextView.frame = CGRectMake(41*scale6PAdapter, 0, DeviceWidth - 82*scale6PAdapter,170);
                
            }];
            
        }else {
        
        
    
    }

}
-(void)textViewDidEndEditing:(UITextView *)textView{
    
    topTextView.frame = CGRectMake(41*scale6PAdapter, 32.3*scale6PAdapter, DeviceWidth - 82*scale6PAdapter, 233.3*scale6PAdapter);
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:
(NSRange)range replacementText:(NSString *)text{

    if ([text isEqualToString:@"\n"]) {

        [topTextView resignFirstResponder];
    }
    return YES;
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [topTextView resignFirstResponder];
}
-(void)requestSucess:(NSInteger)requestTag requestResult:(id)responseObject requestClass:(NSString *)className{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    if (requestTag == 1){
        
        if ([className isEqualToString:NSStringFromClass([self class])]) {
            
            _feedBackModel = [FeedBackModel mj_objectWithKeyValues:responseObject];
            
            if ([_feedBackModel.head.retFlag isEqualToString:@"00000"]) {
                
                WEAKSELF
                [topTextView resignFirstResponder];
                [RMUniversalAlert showAlertInViewController:self withTitle:@"提示" message:@"提交成功" cancelButtonTitle:@"知道了" destructiveButtonTitle:nil otherButtonTitles:nil tapBlock:^(RMUniversalAlert * _Nonnull alert, NSInteger buttonIndex) {
                    STRONGSELF
                    if (strongSelf) {
                        if (buttonIndex == 0) {
                            [strongSelf.navigationController popViewControllerAnimated:YES];
                            
                        }
                    }
                }];
            }else{
            
                WEAKSELF
                [topTextView resignFirstResponder];
                [RMUniversalAlert showAlertInViewController:self withTitle:@"提示" message:_feedBackModel.head.retMsg cancelButtonTitle:@"知道了" destructiveButtonTitle:nil otherButtonTitles:nil tapBlock:^(RMUniversalAlert * _Nonnull alert, NSInteger buttonIndex) {
                    STRONGSELF
                    if (strongSelf) {
                        if (buttonIndex == 0) {
                            
                        }
                    }
                }];
            }
        }
    }
}

-(void)requestFail:(NSInteger)requestTag requestError:(NSError *)error httpCode:(NSInteger)httpCode requestClass:(NSString *)className{
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    if ([className isEqualToString:NSStringFromClass([self class])]) {
        
        NSLog(@"%@",error);
        
        NSLog(@"%ld",(long)requestTag);
        
        if ([className isEqualToString:NSStringFromClass([self class])]) {
            
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            if(httpCode != 0)
            {
                [self buildHeadError:[NSString stringWithFormat:@"网络环境异常，请检查网络并重试(%ld)",(long)httpCode]];
            }
            else
            {
                [self buildHeadError:@"网络环境异常，请检查网络并重试"];
            }
        }
        
    }
}
//连接服务器成功后，返回的报文头信息
-(void)buildHeadError:(NSString *)error{
    
    WEAKSELF
    [RMUniversalAlert showAlertInViewController:self withTitle:@"提示" message:error cancelButtonTitle:@"知道了" destructiveButtonTitle:nil otherButtonTitles:nil tapBlock:^(RMUniversalAlert * _Nonnull alert, NSInteger buttonIndex) {
        STRONGSELF
        if (strongSelf) {
            if (buttonIndex == 0) {
                
            }
        }
    }];
    
    
}


@end
