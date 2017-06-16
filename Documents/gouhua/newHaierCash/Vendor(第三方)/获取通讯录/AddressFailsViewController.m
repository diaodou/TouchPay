//
//  AddressFailsViewController.m
//  personMerchants
//
//  Created by 百思为科 on 16/5/7.
//  Copyright © 2016年 海尔金融. All rights reserved.
//

#import "AddressFailsViewController.h"
#import "HCMacro.h"
#import "UIColor+DefineNew.h"
#import "UIFont+AppFont.h"
@interface AddressFailsViewController ()

@end

@implementation AddressFailsViewController

#pragma mark -- lift cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.view.backgroundColor = [UIColor UIColorWithHexColorString:@"0xeeeeee" AndAlpha:1.0];
    
    [self setNavi];
    [self setImage];
    
    [self setLabel];
}
#pragma mark -- 图片
-(void)setImage{

    UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(DeviceWidth/2 - 50*DeviceWidth/414, 53, 130 * DeviceWidth/414, 110*DeviceWidth/414)];
    
    image.image = [UIImage imageNamed:@"通讯录"];
    
    [self.view addSubview:image];
}
#pragma mark -- 文字
-(void)setLabel{
    NSString *string = @"请到设置>隐私>通讯录打开允许访问通讯录";
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 204*DeviceWidth/414, DeviceWidth, [self stringHeight:string])];
    label.font = [UIFont systemFontOfSize:15];
    label.numberOfLines = 0;
    label.lineBreakMode = NSLineBreakByCharWrapping;
    label.textColor = [UIColor UIColorWithHexColorString:@"0x666666" AndAlpha:1.0];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = string;
    [self.view addSubview:label];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark ----- private Method --------
//获取一个矩形的高度
-(CGFloat)stringHeight:(NSString *)aString{
    
    CGRect temp = [aString boundingRectWithSize:CGSizeMake(DeviceWidth, SIZE_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:15]} context:nil];
    return temp.size.height;
    
}

- (void)setNavi
{
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = ReturnRect;
    [backBtn setImage:[UIImage imageNamed:@"返回_黑"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(OnBackBtn:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
}

- (void)OnBackBtn:(UIButton *)btn
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
