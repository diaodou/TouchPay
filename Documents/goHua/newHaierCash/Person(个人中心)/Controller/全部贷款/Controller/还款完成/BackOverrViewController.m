//
//  BackOverrViewController.m
//  personMerchants
//
//  Created by 张久健 on 16/4/7.
//  Copyright © 2016年 海尔金融. All rights reserved.
//

#import "BackOverrViewController.h"
#import "LoanDetailCommonView.h"
#import "HCMacro.h"
#import "UIFont+AppFont.h"
#import <MJExtension.h>
#import "RMUniversalAlert.h"
#import <MBProgressHUD.h>
#import "LoanDetailModel.h"
#import "BSVKHttpClient.h"
#import "AppDelegate.h"
#import <YYWebImage.h>
@interface BackOverrViewController ()<BSVKHttpClientDelegate>
@property(nonatomic,strong)LoanDetailCommonView  * loanView;// 中部的view
@end

@implementation BackOverrViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setView];
    self.title = @"还款完成";
    
    [self setNavi];
    self.view.backgroundColor = [UIColor whiteColor];
    [self creatDetailReq];
}
#pragma mark ----设置导航
- (void)setNavi {
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = ReturnRect;
    [backBtn setImage:[UIImage imageNamed:@"返回_黑"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(OnBackBtn:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
}
#pragma mark----返回
- (void)OnBackBtn:(UIButton *)btn {
    [AppDelegate delegate].userInfo.bReturn = YES;
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -- setting 表头
-(void)setView{
    
    LoanDetailCommonView  * loanView = [[LoanDetailCommonView alloc]initWithFrame:(CGRectMake(0, 10, DeviceWidth, [LoanDetailCommonView heightView:loanOutDate]))];
    loanView.loanHandlingType = loanOutDate;
    _loanView = loanView;
    [self.view addSubview:loanView];
    
//    赋值
//    loanView.loanTopView.labelTime.text = @"2015-12-30";
//    loanView.loanTopView.labelState.text = @"贷款编号234543234554";
//    loanView.loanTopView.labelMidContent.text = @"欧洲七日游";
//    loanView.summary.text = @"应还还3000，已还3000，待还0";
//    loanView.priManey.text = @"3500";
//    loanView.divManey.text = @"500元";
//    loanView.totalManey.text = @"35500.00";
//    loanView.interestDays.text = @"（10天）";
    loanView.loanTopView.labelState.textColor = UIColorFromRGB(0x333333, 1.0);
    loanView.loanTopView.viewIcon.backgroundColor = [UIColor grayColor];
//    分期账单Label
    UILabel * fenqiZhangDan = [[UILabel alloc]initWithFrame:(CGRectMake(20, CGRectGetMinY(loanView.summary.frame), 60, 40))];
    fenqiZhangDan.font = [UIFont systemFontOfSize:12];
    fenqiZhangDan.textColor = UIColorFromRGB(0x333333, 1.0);
    fenqiZhangDan.text = @"分期账单";
    [loanView addSubview:fenqiZhangDan];
    
}
//创建请求
- (void)creatDetailReq{
    BSVKHttpClient * detailClint = [BSVKHttpClient shareInstance];
    detailClint.delegate = self;
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];

    [dict setValue:[AppDelegate delegate].userInfo.applSeq forKey:@"applSeq"];
    [detailClint getInfo:@"app/appserver/apporder/queryAppLoanAndGoods" requestArgument:dict requestTag:10 requestClass:NSStringFromClass([self class])];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
}
//成功
- (void)requestSucess:(NSInteger)requestTag requestResult:(id)responseObject requestClass:(NSString *)className{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    if ([className isEqualToString:NSStringFromClass([self class])]) {
        if (requestTag == 10) {
            LoanDetailModel *model = [LoanDetailModel mj_objectWithKeyValues:responseObject];
            if ([model.head.retFlag isEqualToString:@"00000"]) {
                [self setValuesForLoanView:model];
            }
        }
    }
    
    
}
//失败
- (void)requestFail:(NSInteger)requestTag requestError:(NSError *)error httpCode:(NSInteger)httpCode requestClass:(NSString *)className{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    if ([className isEqualToString:NSStringFromClass([self class])]) {
        if(httpCode != 0)
        {
            [self buildHeadError:[NSString stringWithFormat:@"网络环境异常，请检查网络并重试(%ld)",httpCode]];
        }
        else
        {
            [self buildHeadError:@"网络环境异常，请检查网络并重试"];
        }        
    }
}
- (void)setValuesForLoanView:(LoanDetailModel*)model{
    //    赋值
    
    //    分期本金
    _loanView.priManey.text = [NSString stringWithFormat:@"%.2f",[model.body.applyAmt floatValue]];
    //    息费
    _loanView.divManey.text = [NSString stringWithFormat:@"%.2f",[model.body.psNormIntAmt floatValue] + [model.body.feeAmt floatValue]];
    //    借款总额
    _loanView.totalManey.text = [NSString stringWithFormat:@"%.2f",[model.body.applyAmt floatValue] + [model.body.psNormIntAmt floatValue] + [model.body.feeAmt floatValue]];
    //  每期还款  总金额/期数
    float moneyOne = [_loanView.totalManey.text floatValue]/[model.body.applyTnr floatValue];
    //    利息天数
    _loanView.interestDays.hidden = YES;
    //    日期
    _loanView.loanTopView.labelTime.text = model.body.applyDt;
    //    贷款编号
    _loanView.loanTopView.labelState.text = [NSString stringWithFormat:@"贷款编号%@",model.body.applCde];
    _loanView.loanTopView.viewIcon.backgroundColor = [UIColor yellowColor];
    //    中间的标题
    _loanView.loanTopView.labelMidContent.text = model.body.goods[0].goodsName;
    //    头部的view
    //    每期多少钱
    _loanView.loanTopView.labelRight.text = [NSString stringWithFormat:@"¥%.2f&%@期",moneyOne,model.body.applyTnr];
    _loanView.loanTopView.labelRight.font = [UIFont systemFontOfSize:12];
    _loanView.summary.text = [NSString stringWithFormat:@"已还%.2f元，待还0元",model.body.proPurAmt];
    if (model.body.goods.count > 0) {
        if(model.body.goods[0].goodsCode && model.body.goods[0].goodsCode.length > 0)
        {
            if([(id)[[AppDelegate delegate].imagePutCache objectForKey:[NSString stringWithFormat:@"%@pub/gm/getGoodsPic?goodsCode=%@",baseUrl,model.body.goods[0].goodsCode]] isKindOfClass:[UIImage class]])
            {
                UIImage *tempData =(UIImage *)[[AppDelegate delegate].imagePutCache objectForKey:[NSString stringWithFormat:@"%@pub/gm/getGoodsPic?goodsCode=%@",baseUrl,model.body.goods[0].goodsCode]];
                _loanView.loanTopView.viewIcon.image = tempData;
            }else if ([(id)[[AppDelegate delegate].imagePutCache objectForKey:[NSString stringWithFormat:@"%@pub/gm/getGoodsPic?goodsCode=%@",baseUrl,model.body.goods[0].goodsCode]] isKindOfClass:[NSData class]])
            {
                NSData *tempData =(NSData *)[[AppDelegate delegate].imagePutCache objectForKey:[NSString stringWithFormat:@"%@pub/gm/getGoodsPic?goodsCode=%@",baseUrl,model.body.goods[0].goodsCode]];
                _loanView.loanTopView.viewIcon.image = [UIImage imageWithData:tempData];
            }else
            {
                _loanView.loanTopView.viewIcon.image = [UIImage imageNamed:@"贷款列表默认图片"];
                [[YYWebImageManager sharedManager]requestImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@pub/gm/getGoodsPic?goodsCode=%@",baseUrl,model.body.goods[0].goodsCode]] options:YYWebImageOptionShowNetworkActivity progress:nil transform:nil completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
                    if (image) {
                        [[AppDelegate delegate].imagePutCache setObject:image forKey:url.absoluteString];
                        _loanView.loanTopView.viewIcon.image = image;
                    }
                }];
            }
        }
        else
        {
            _loanView.loanTopView.viewIcon.image = [UIImage imageNamed:@"贷款列表默认图片"];
        }
    }else{
        _loanView.loanTopView.viewIcon.image = [UIImage imageNamed:@"贷款列表默认图片"];
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
