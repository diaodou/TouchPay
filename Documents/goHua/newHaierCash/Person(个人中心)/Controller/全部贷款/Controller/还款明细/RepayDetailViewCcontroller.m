//
//  RepayDetailViewCcontroller.m
//  personMerchants
//
//  Created by LLM on 16/11/16.
//  Copyright © 2016年 海尔金融. All rights reserved.
//

#import "RepayDetailViewCcontroller.h"
#import "HCMacro.h"
#import "ConfirmPayViewController.h"
#import "UIButton+UnifiedStyle.h"
@implementation RepayDetailViewCcontroller
#pragma mark - left cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"应还明细";
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = [UIColor colorWithRed:0.94 green:0.94 blue:0.94 alpha:1.00];
    
    [self initContentView];
    
    [self setNavi];
}

#pragma mark - setting and getting
- (void)initContentView
{
    UIView *baseView = [[UIView alloc] init];
    baseView.frame = CGRectMake(0, 0, DeviceWidth, 360*scaleAdapter);
    baseView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:baseView];
    
    UILabel *totalLabel = [[UILabel alloc] init];
    totalLabel.frame = CGRectMake(30*scaleAdapter, 20*scaleAdapter, DeviceWidth/2-30*scaleAdapter, 50*scaleAdapter);
    totalLabel.text = @"还款总额:";
    totalLabel.textAlignment = NSTextAlignmentLeft;
    totalLabel.font = [UIFont systemFontOfSize:17];
    [baseView addSubview:totalLabel];
    
    UILabel *totalMoneyLabel = [[UILabel alloc] init];
    totalMoneyLabel.frame = CGRectMake(DeviceWidth/2, 20*scaleAdapter, DeviceWidth/2-30*scaleAdapter, 50*scaleAdapter);
    self.totalAmt = [NSString stringWithFormat:@"%.2f",[self.totalAmt floatValue]];
    totalMoneyLabel.attributedText = [self formatTotalMoney:self.totalAmt];
    totalMoneyLabel.textAlignment = NSTextAlignmentRight;
    [baseView addSubview:totalMoneyLabel];
    
    NSArray *nameArray = [NSArray arrayWithObjects:@"剩余应还本金",@"提前还款手续费1%",@"息费总额",nil];
    
    NSArray *numArray;
    if(self.principal && self.counterFee && self.interest)
    {
        numArray = [[NSArray alloc] initWithObjects:self.principal,self.counterFee,self.interest,nil] ;
    }
    
    //分隔线
    UIView *lineView = [[UIView alloc] init];
    lineView.frame = CGRectMake(30*scaleAdapter, 69.5f*scaleAdapter, DeviceWidth-60*scaleAdapter, 0.5f);
    lineView.backgroundColor = [UIColor colorWithRed:0.84 green:0.84 blue:0.84 alpha:1.00];
    [baseView addSubview:lineView];
    
    for (int i = 0; i<numArray.count; i++)
    {
        UILabel *leftLabel = [[UILabel alloc] init];
        leftLabel.frame = CGRectMake(35*scaleAdapter, 70*scaleAdapter+45*scaleAdapter*i, DeviceWidth/2-35*scaleAdapter, 45*scaleAdapter);
        leftLabel.text = nameArray[i];
        leftLabel.textAlignment = NSTextAlignmentLeft;
        leftLabel.font = [UIFont systemFontOfSize:15];
        leftLabel.textColor = [UIColor colorWithRed:0.70 green:0.70 blue:0.70 alpha:1.00];
        [baseView addSubview:leftLabel];
        
        UILabel *rightLabel = [[UILabel alloc] init];
        rightLabel.frame = CGRectMake(DeviceWidth/2, 70*scaleAdapter+45*scaleAdapter*i, DeviceWidth/2-35*scaleAdapter, 45*scaleAdapter);
        rightLabel.text = [NSString stringWithFormat:@"%.2f",[numArray[i] floatValue]];
        rightLabel.textAlignment = NSTextAlignmentRight;
        rightLabel.font = [UIFont systemFontOfSize:15];
        rightLabel.textColor = [UIColor colorWithRed:0.70 green:0.70 blue:0.70 alpha:1.00];
        [baseView addSubview:rightLabel];
    }
    
    UILabel *tipLabel = [[UILabel alloc] init];
    tipLabel.frame = CGRectMake(35*scaleAdapter, 75*scaleAdapter+45*scale6PAdapter*nameArray.count, DeviceWidth-70*scaleAdapter, 15*scaleAdapter);
    tipLabel.text = @"(由于您已逾期,费用总额包含滞纳金,违约金,罚息等)";
    tipLabel.font = [UIFont systemFontOfSize:10];
    tipLabel.textColor = [UIColor colorWithRed:0.70 green:0.70 blue:0.70 alpha:1.00];
    [baseView addSubview:tipLabel];
    
    if(self.isOverdue)
    {
        tipLabel.hidden = NO;
    }else
    {
        tipLabel.hidden = YES;
    }
    
    UIButton *submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    submitBtn.frame = CGRectMake(30*scaleAdapter, 390*scaleAdapter, DeviceWidth-60*scaleAdapter, 44*scaleAdapter);
    [submitBtn setButtonTitle:@"确认还款" titleFont:14 buttonHeight:44*scaleAdapter];
    submitBtn.layer.masksToBounds = YES;
    [submitBtn addTarget:self action:@selector(submit) forControlEvents:UIControlEventTouchUpInside];
    [submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:submitBtn];
}

- (void)setNavi {
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = ReturnRect;
    [backBtn setImage:[UIImage imageNamed:@"返回_黑"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(OnBackBtn:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
}

- (void)OnBackBtn:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - private methods
- (void)submit
{
    ConfirmPayViewController *vc = [[ConfirmPayViewController alloc]init];
    vc.loanNo = self.loanNo;          //借据号
    vc.totalAmt = self.totalAmt;     //总额
    vc.payMode = self.payMode;       //还款方式
    [self.navigationController pushViewController:vc animated:YES];
}


- (NSMutableAttributedString *)formatTotalMoney:(NSString *)totalMoney
{
    if(!totalMoney)
    {
        return nil;
    }
    
    NSRange range = [totalMoney rangeOfString:@"."];

    NSMutableAttributedString *attriText = [[NSMutableAttributedString alloc] initWithString:totalMoney attributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:0.01 green:0.55 blue:0.90 alpha:1.00],NSFontAttributeName:[UIFont systemFontOfSize:17]}];
    
    if(range.location != NSNotFound)
    {
        [attriText addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} range:NSMakeRange(range.location, totalMoney.length-range.location)];
    }
    
    return attriText;
}
@end
