//
//  SuccessViewController.m
//  newHaierCash
//
//  Created by 张久健 on 2017/6/5.
//  Copyright © 2017年 haier. All rights reserved.
//

#import "SuccessViewController.h"
#import "HCMacro.h"
#import "UIFont+AppFont.h"
#import "AppDelegate.h"
#import "ApprovalProgressViewController.h"
#import "PayHistoryViewController.h"
@interface SuccessViewController ()
{
    UIImageView *successImageView;
    UILabel *successLab;
    UILabel *numberLab;
    UILabel *describeLab;
    UIButton *nextButton;
    CGFloat _viewScale;//适配比例

}

@end

@implementation SuccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"提交成功";
    _viewScale = iphone6P ? scale6PAdapter : scaleAdapter;
    [self createUI];
}

#pragma mark - private Methods
-(void)createUI{

    successImageView = [[UIImageView alloc]initWithFrame:CGRectMake(DeviceWidth/2-73 *_viewScale, 47 *_viewScale, 146 *_viewScale, 146 *_viewScale)];
    successImageView.layer.cornerRadius = 73.f *_viewScale;
    successLab = [[UILabel alloc]initWithFrame:CGRectMake(20 *_viewScale, 215 *_viewScale, DeviceWidth-40 *_viewScale, 30 *_viewScale)];
    
    if ([_comeFrom isEqualToString:@"权益详情"]) {
        describeLab = [[UILabel alloc]initWithFrame:CGRectMake(20 *_viewScale, 300 *_viewScale, DeviceWidth-40 *_viewScale, 16 *_viewScale)];
        nextButton = [[UIButton alloc]initWithFrame:CGRectMake(44 *_viewScale,352 *_viewScale, DeviceWidth-88 *_viewScale, 46 *_viewScale)];
        numberLab = [[UILabel alloc]initWithFrame:CGRectMake(20 *_viewScale, 255 *_viewScale, DeviceWidth-40 *_viewScale, 17 *_viewScale)];
        successLab.text = @"兑换成功";
        numberLab.text = @"-1000积分";
        describeLab.text = @"恭喜你，兑换成功";
        [nextButton setTitle:@"立即查看" forState:UIControlStateNormal];


    }else if ([_comeFrom isEqualToString:@"有额度现金分期"]){
        describeLab = [[UILabel alloc]initWithFrame:CGRectMake(20 *_viewScale, 260 *_viewScale, DeviceWidth-40 *_viewScale, 16 *_viewScale)];
        nextButton = [[UIButton alloc]initWithFrame:CGRectMake(44 *_viewScale,312 *_viewScale, DeviceWidth-88 *_viewScale, 46 *_viewScale)];
        successLab.text = @"申请提交成功";
        describeLab.text = @"2小时后，钱会到达您的账户，请注意查收";
        [nextButton setTitle:@"查看进度" forState:UIControlStateNormal];

    }else if ([_comeFrom isEqualToString:@"首页与精品"]){
        describeLab = [[UILabel alloc]initWithFrame:CGRectMake(20 *_viewScale, 260 *_viewScale, DeviceWidth-40 *_viewScale, 16 *_viewScale)];
        nextButton = [[UIButton alloc]initWithFrame:CGRectMake(44 *_viewScale,312 *_viewScale, DeviceWidth-88 *_viewScale, 46 *_viewScale)];
        successLab.text = @"订单提交成功";
        describeLab.text = @"审批通过后，商品会在3-5天送至您手中";
        [nextButton setTitle:@"查看进度" forState:UIControlStateNormal];

    }else if ([_comeFrom isEqualToString:@"专项贷款"]){
        describeLab = [[UILabel alloc]initWithFrame:CGRectMake(20 *_viewScale, 260 *_viewScale, DeviceWidth-40 *_viewScale, 16 *_viewScale)];
        nextButton = [[UIButton alloc]initWithFrame:CGRectMake(44 *_viewScale,312 *_viewScale, DeviceWidth-88 *_viewScale, 46 *_viewScale)];
        successLab.text = @"申请提交成功";
        describeLab.text = @"审批通过后，系统会自动帮您支付";
        [nextButton setTitle:@"查看进度" forState:UIControlStateNormal];

    }else if ([_comeFrom isEqualToString:@"扫码分期现金"]){
        describeLab = [[UILabel alloc]initWithFrame:CGRectMake(20 *_viewScale, 260 *_viewScale, DeviceWidth-40 *_viewScale, 16 *_viewScale)];
        nextButton = [[UIButton alloc]initWithFrame:CGRectMake(44 *_viewScale,312 *_viewScale, DeviceWidth-88 *_viewScale, 46 *_viewScale)];
        successLab.text = @"申请提交成功";
        describeLab.text = @"2小时后，钱会到达您的账户，请注意查收";
        [nextButton setTitle:@"查看进度" forState:UIControlStateNormal];

    }else if ([_comeFrom isEqualToString:@"扫码分期商品"]){
        describeLab = [[UILabel alloc]initWithFrame:CGRectMake(20 *_viewScale, 260 *_viewScale, DeviceWidth-40 *_viewScale, 16 *_viewScale)];
        nextButton = [[UIButton alloc]initWithFrame:CGRectMake(44 *_viewScale,312 *_viewScale, DeviceWidth-88 *_viewScale, 46 *_viewScale)];
        successLab.text = @"申请提交成功";
        describeLab.text = @"审批通过后，系统会自动帮您支付";
        [nextButton setTitle:@"查看进度" forState:UIControlStateNormal];

    }else if ([_comeFrom isEqualToString:@"还款"]){
        describeLab = [[UILabel alloc]initWithFrame:CGRectMake(20 *_viewScale, 260 *_viewScale, DeviceWidth-40 *_viewScale, 16 *_viewScale)];
        nextButton = [[UIButton alloc]initWithFrame:CGRectMake(44 *_viewScale,312 *_viewScale, DeviceWidth-88 *_viewScale, 46 *_viewScale)];
        successLab.text = @"支付成功";
        describeLab.text = @"您可以到还款记录中查看还款状态";
        [nextButton setTitle:@"还款记录" forState:UIControlStateNormal];
        
    }
    nextButton.layer.cornerRadius = 23.f *_viewScale;

    successImageView.image = [UIImage imageNamed:@"图标_选中"];
    [self.view addSubview:successImageView];

    successLab.textAlignment = NSTextAlignmentCenter;
    successLab.textColor = UIColorFromRGB(0x333333, 1);
    successLab.font = [UIFont appFontRegularOfSize:20];
    [self.view addSubview:successLab];
    
    numberLab.textAlignment = NSTextAlignmentCenter;
    numberLab.textColor = UIColorFromRGB(0xf15a4a, 1);
    numberLab.font = [UIFont appFontRegularOfSize:14];
    [self.view addSubview:numberLab];
    
    describeLab.textAlignment = NSTextAlignmentCenter;
    describeLab.textColor = UIColorFromRGB(0x999999, 1);
    describeLab.font = [UIFont appFontRegularOfSize:13];
    [self.view addSubview:describeLab];
    
    nextButton.titleLabel.font = [UIFont appFontRegularOfSize:17];
    nextButton.backgroundColor = UIColorFromRGB(0x32beff, 1);
    [nextButton addTarget:self action:@selector(buildLookOrder) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nextButton];
    
}

#pragma mark - event response
//跳转
-(void)buildLookOrder{
    if ([_comeFrom isEqualToString:@"权益详情"]) {
        
    }else if ([_comeFrom isEqualToString:@"还款"]){
        PayHistoryViewController *approvaiVC = [[PayHistoryViewController alloc]init];
        
        [self.navigationController pushViewController:approvaiVC animated:YES];
    }else {
        ApprovalProgressViewController *approvaiVC = [[ApprovalProgressViewController alloc]init];
        
        [self.navigationController pushViewController:approvaiVC animated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
