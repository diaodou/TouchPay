//
//  QuoteStateViewController.m
//  personMerchants
//
//  Created by 百思为科 on 16/7/28.
//  Copyright © 2016年 海尔金融. All rights reserved.
//

#import "QuoteStateViewController.h"
#import "HCMacro.h"
#import "UIFont+AppFont.h"
#import "ApprovalProgressViewController.h"
#import "AppDelegate.h"
#import "BSVKHttpClient.h"
#import <MBProgressHUD.h>
#import "RMUniversalAlert.h"
#import "UpLimitInfoViewController.h"
#import "MentionQuoteModel.h"
#import <MJExtension.h>
@interface QuoteStateViewController ()<BSVKHttpClientDelegate>

@end

@implementation QuoteStateViewController
#pragma mark -- lift cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"提额状态";
    self.view.backgroundColor = UIColorFromRGB(0xf6f6f6, 1.0);
    [self creatSpeed];
    [self creatBeReturn];
    [self creatFail];
    if (!_mentionModel)
    {

        [self getEdApplProgress];
    }else{
    
        [self chooseView];
    }
}
- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}
#pragma mark -- setting and getting
-(void)creatSpeed{

    UIView * bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DeviceWidth, 200)];
    
    bottomView.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:bottomView];
    
    UILabel * quotaLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 10, DeviceWidth, 20)];
    
    quotaLabel.text = @"额度审批中";
    
    quotaLabel.textAlignment = NSTextAlignmentCenter;
    
    quotaLabel.font = [UIFont appFontRegularOfSize:16];
    
    [bottomView addSubview:quotaLabel];
    
    UILabel * stateLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 40, DeviceWidth, 35)];
    
    stateLabel.numberOfLines = 2;
    
    stateLabel.text = @"小嗨正在给您快马加鞭的审核\n中，请稍候哦";
    
    stateLabel.textAlignment = NSTextAlignmentCenter;
    
    stateLabel.font = [UIFont appFontRegularOfSize:14];
        
    [bottomView addSubview:stateLabel];
    
    UIButton * speedBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    
    speedBtn.frame = CGRectMake(100, 120, DeviceWidth - 200 , 30);
    
    [speedBtn setTitle:@"审批进度 >" forState:UIControlStateNormal];
    
    [speedBtn setBackgroundColor:UIColorFromRGB(0x028ce5, 1.0)];
    
    [speedBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [speedBtn addTarget:self action:@selector(toSpeed) forControlEvents:UIControlEventTouchUpInside];
    
    speedBtn.layer.cornerRadius = 4;
    
    [bottomView addSubview:speedBtn];
    
    bottomView.tag = 10002;
    
    bottomView.hidden = YES;
}
-(void)creatBeReturn{

    UIView * bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DeviceWidth, 200)];
    
    bottomView.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:bottomView];
    
    UILabel * quotaLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 10, DeviceWidth, 20)];
    
    if ([_mentionModel.body.outSts isEqualToString:@"22"]) {
        
        quotaLabel.text = @"提额被退回";
        
    }
    quotaLabel.textAlignment = NSTextAlignmentCenter;
    quotaLabel.font = [UIFont appFontRegularOfSize:16];
    
    [bottomView addSubview:quotaLabel];
    
    UILabel * stateLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 40, DeviceWidth, 30)];
    
    stateLabel.numberOfLines = 2;
    
    stateLabel.text = @"您的申请资料有点小瑕疵，请修复";
    stateLabel.textAlignment = NSTextAlignmentCenter;
    stateLabel.font = [UIFont appFontRegularOfSize:14];
    
    [bottomView addSubview:stateLabel];
    
    UIButton * leftButton = [UIButton buttonWithType:UIButtonTypeSystem];
    
    leftButton.layer.cornerRadius = 4;
    
    leftButton.frame = CGRectMake(DeviceWidth/9, 120, DeviceWidth/3, 30);
    
    [leftButton setTitle:@"完善资料 >" forState:UIControlStateNormal];
    
    [leftButton setBackgroundColor:UIColorFromRGB(0x028ce5, 1.0)];
    
    [leftButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [leftButton addTarget:self action:@selector(toPerfect) forControlEvents:UIControlEventTouchUpInside];
    
    [bottomView addSubview:leftButton];
    
    UIButton * rightButton = [UIButton buttonWithType:UIButtonTypeSystem];
    
    rightButton.layer.cornerRadius = 4;
    
    rightButton.frame = CGRectMake(DeviceWidth * 5/9, 120, DeviceWidth/3, 30);
    
    [rightButton setTitle:@"查看原因 >" forState:UIControlStateNormal];
    
    [rightButton setBackgroundColor:UIColorFromRGB(0x028ce5, 1.0)];
    
    [rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [rightButton addTarget:self action:@selector(toReason) forControlEvents:UIControlEventTouchUpInside];
    
    [bottomView addSubview:rightButton];
    
    bottomView.tag = 10000;
    
    bottomView.hidden = YES;
}
-(void)creatFail{
    
    UIView * bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DeviceWidth, 200)];
    
    bottomView.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:bottomView];
    
    UILabel * quotaLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 30, DeviceWidth, 20)];
    
    if ([_mentionModel.body.outSts isEqualToString:@"27"]) {
        
        quotaLabel.text = @"额度审批中，暂不能提额";
        
    }else if ([_mentionModel.body.outSts isEqualToString:@"03"]) {
        
        quotaLabel.text = @"贷款已取消";
        
    }else if([_mentionModel.body.outSts isEqualToString:@"25"]){
        
        quotaLabel.text = @"提额申请被拒绝";
        
    }else if ([_mentionModel.body.outSts isEqualToString:@"26"]){
        
        quotaLabel.text = @"提额申请已取消";
        
    }

    quotaLabel.textAlignment = NSTextAlignmentCenter;
    quotaLabel.font = [UIFont appFontRegularOfSize:16];
    
    [bottomView addSubview:quotaLabel];
    
    if ([_mentionModel.body.outSts isEqualToString:@"25"]) {
     
        UILabel * timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 60, DeviceWidth, 50)];
        
        timeLabel.textAlignment = NSTextAlignmentCenter;
        
        timeLabel.font = [UIFont appFontRegularOfSize:15];
        
        timeLabel.text = [NSString stringWithFormat:@"拒绝时间:%@\n请6个月后重新申请",_mentionModel.body.operateTime];
        
        timeLabel.numberOfLines = 0;
        
        [bottomView addSubview:timeLabel];
        
    }
    
    UIButton * speedBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    
    speedBtn.frame = CGRectMake(100, 120, DeviceWidth - 200 , 30);
    
    [speedBtn setTitle:@"审批进度 >" forState:UIControlStateNormal];
    
    [speedBtn setBackgroundColor:UIColorFromRGB(0x028ce5, 1.0)];
    
    [speedBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [speedBtn addTarget:self action:@selector(toSpeed) forControlEvents:UIControlEventTouchUpInside];
    
    speedBtn.layer.cornerRadius = 4;
    
    [bottomView addSubview:speedBtn];
     bottomView.tag = 10001;
    bottomView.hidden = YES;
}
#pragma mark -- private Methods
- (void)chooseView{
    
    //    提额状态待确定
    if ([_mentionModel.body.outSts isEqualToString:@"22"]) {
        //        被退回  完善资料 原因
        UIView *bottom = [self.view viewWithTag:10000];
        
        bottom.hidden = NO;
    }
    if ([_mentionModel.body.outSts isEqualToString:@"01"] ) {
        //        审批中
        UIView *bottom = [self.view viewWithTag:10002];
        
        bottom.hidden = NO;
        
    }
    if ([_mentionModel.body.outSts isEqualToString:@"25"]|| [_mentionModel.body.outSts isEqualToString:@"27"] ) {
        //        贷款已取消 额度申请已取消 额度申请被拒绝  通过
        UIView *bottom = [self.view viewWithTag:10001];
        
        bottom.hidden = NO;
    }
}
-(void)toSpeed{
    
    ApprovalProgressViewController *vc = [[ApprovalProgressViewController alloc]init];
//    vc.flowName = fromMoney;
//    vc.mentionModel = _mentionModel;
    if (_msg) {
//        vc.msg = _msg;
    }
    [self.navigationController pushViewController:vc animated:YES];
    NSLog(@"查看审批进度");
}
-(void)toPerfect{
    
    UpLimitInfoViewController * vc = [[UpLimitInfoViewController alloc]init];
//    vc.flowName = fromMoney;
    vc.firstMentionQuote = NO;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
   
    NSLog(@"去完善资料");
}
-(void)toReason{
    ApprovalProgressViewController *vc = [[ApprovalProgressViewController alloc]init];
//    vc.flowName = fromMoney;
//    vc.hidesBottomBarWhenPushed = YES;
//    vc.mentionModel = _mentionModel;
//    vc.stateStr = @"提额被退回";
    [self.navigationController pushViewController:vc animated:YES];
    
    NSLog(@"去查看原因");
}
#pragma mark - request Methods
- (void)getEdApplProgress{
    BSVKHttpClient *client = [BSVKHttpClient shareInstance];
    client.delegate = self;
    NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
    [parmDict setObject:@"20" forKey:@"idTyp"];
    [parmDict setObject:[AppDelegate delegate].userInfo.realId forKey:@"idNo"];
    
    [client postInfo:@"app/appserver/apporder/getEdApplProgress" requestArgument:parmDict requestTag:666 requestClass:NSStringFromClass([self class])];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}
#pragma mark - BSVK Delegate
-(void)requestSucess:(NSInteger)requestTag requestResult:(id)responseObject requestClass:(NSString *)className{

    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    if ([className isEqualToString:NSStringFromClass([self class])]) {
        
        if (requestTag == 666) {//查询提额状态
            MentionQuoteModel *model = [MentionQuoteModel mj_objectWithKeyValues:responseObject];
            
            [self analySisMentionQuoteModel:model];
            
        }
    }
}
-(void)requestFail:(NSInteger)requestTag requestError:(NSError *)error httpCode:(NSInteger)httpCode requestClass:(NSString *)className{
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    if ([className isEqualToString:NSStringFromClass([self class])]) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        if(httpCode != 0)
        {
            [self buildHeadError:[NSString stringWithFormat:@"网络环境异常，请检查网络并重试(%ld)",httpCode] AndType:nil];
        }
        else
        {
            [self buildHeadError:@"网络环境异常，请检查网络并重试" AndType:nil];
        }

    }
}
//连接服务器成功后，返回的报文头信息
-(void)buildHeadError:(NSString *)error AndType:(NSString *)type{
    
    WEAKSELF
    [RMUniversalAlert showAlertInViewController:self withTitle:@"提示" message:error cancelButtonTitle:@"知道了" destructiveButtonTitle:nil otherButtonTitles:nil tapBlock:^(RMUniversalAlert * _Nonnull alert, NSInteger buttonIndex) {
        STRONGSELF
        if (strongSelf) {
            if (buttonIndex == 0) {
                if ([type isEqualToString:@"fail"]) {
                    
                }
                
            }
        }
    }];
}
- (void)analySisMentionQuoteModel:(MentionQuoteModel *)model{
    if ([model.head.retFlag isEqualToString:@"00000"]) {
        
        _mentionModel = model;
        
        [self chooseView];
    }else{
        
        [self buildHeadError:model.head.retMsg AndType:nil];
    }
}
@end
