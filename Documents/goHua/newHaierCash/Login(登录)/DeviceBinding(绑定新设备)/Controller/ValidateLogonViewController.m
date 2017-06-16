//
//  ValidateLogonViewController.m
//  personMerchants
//
//  Created by 张久健 on 17/3/3.
//  Copyright © 2017年 海尔金融. All rights reserved.
//

#import "ValidateLogonViewController.h"
#import "HCMacro.h"
#import "UIFont+AppFont.h"
#import "VerifyPhoneNumberViewController.h"
@interface ValidateLogonViewController ()
{
    NSString *number;//手机号
}
@end

@implementation ValidateLogonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"解锁账户";
    self.view.backgroundColor = UIColorFromRGB(0xf6f6f6, 1.0);
    
    NSString *one = [_mobile substringToIndex:3];
    
    NSString *two = [_mobile substringFromIndex:7];
    
    number = [NSString stringWithFormat:@"%@****%@",one,two];
    [self createUI];
}

-(void)createUI{
    UIView *showView = [[UIView alloc]initWithFrame:CGRectMake(0, 10, DeviceWidth, 406*scale6PAdapter)];
    showView.backgroundColor = UIColorFromRGB(0xffffff, 1);
    [self.view addSubview:showView];
    
    UIImageView * flowimage = [[UIImageView alloc]initWithFrame:CGRectMake(DeviceWidth/2-70*scale6PAdapter,20*scale6PAdapter,140*scale6PAdapter,140 *scale6PAdapter)];
    flowimage.image = [UIImage imageNamed:@"验证"];
    [showView addSubview:flowimage];
    
    UILabel *showLabel = [[UILabel alloc]initWithFrame:CGRectMake(30*scale6PAdapter, 204*scale6PAdapter, DeviceWidth-60*scale6PAdapter, 40*scale6PAdapter)];
    showLabel.textColor = UIColorFromRGB(0x666666, 1);
    showLabel.text = @"为了保证您的金融账户安全，当前设备需要进行安全验证，通过后，下次无需验证";
    showLabel.textAlignment = NSTextAlignmentLeft;
    showLabel.numberOfLines = 0;
    showLabel.font =[UIFont appFontRegularOfSize:11];
    [showView addSubview:showLabel];
    
    UILabel *numberLabel = [[UILabel alloc]initWithFrame:CGRectMake(30*scale6PAdapter, 260*scale6PAdapter, DeviceWidth-60*scale6PAdapter, 20*scale6PAdapter)];
    numberLabel.textColor = UIColorFromRGB(0x666666, 1);
    numberLabel.text = [NSString stringWithFormat:@"保密手机号：%@",number];
    numberLabel.textAlignment = NSTextAlignmentLeft;
    numberLabel.numberOfLines = 0;
    numberLabel.font =[UIFont appFontRegularOfSize:11];
    [showView addSubview:numberLabel];
    
    UIButton *nextButton = [[UIButton alloc]initWithFrame:CGRectMake(42*scale6PAdapter, 320*scale6PAdapter, DeviceWidth-84*scale6PAdapter, 45*scale6PAdapter)];
    if (iphone6P) {
        nextButton.frame = CGRectMake(48, 320*scale6PAdapter, DeviceWidth-96, 50);
        nextButton.layer.cornerRadius = 25.f;
    } else {
        nextButton.frame = CGRectMake(40, 320*scale6PAdapter, DeviceWidth-80, 45);
        nextButton.layer.cornerRadius = 22.5f;
    }

    nextButton.layer.masksToBounds = YES;
    nextButton.backgroundColor = UIColorFromRGB(0x32beff, 1.0);
    nextButton.tag = 10;
    [nextButton setTitle:@"下一步" forState:(UIControlStateNormal)];
    nextButton.tintColor = [UIColor whiteColor];
    [nextButton addTarget:self action:@selector(nextButton:) forControlEvents:(UIControlEventTouchUpInside)];
    nextButton.titleLabel.font = [UIFont appFontRegularOfSize:15];
    [self.view addSubview:nextButton];
}
- (void)OnBackBtn:(UIButton *)btn {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}
// 点击下一步
- (void)nextButton:(UIButton *)button{
    VerifyPhoneNumberViewController *Vc = [[VerifyPhoneNumberViewController alloc]init];
    Vc.mobile = _mobile;
    Vc.fieldPass = _fieldPass;
    Vc.fieldName = _fieldName;
    if (_boRemember == YES) {
        Vc.boRemember = _boRemember;
    }
    [self.navigationController pushViewController:Vc animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    
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
