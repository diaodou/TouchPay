//
//  UpLimitInfoViewController.m
//  HaiFu
//
//  Created by 史长硕 on 17/2/14.
//  Copyright © 2017年 百思为科. All rights reserved.
//

#import "UpLimitInfoViewController.h"
#import "HCMacro.h"
#import "UIFont+AppFont.h"
#import "BSVKHttpClient.h"
#import "RMUniversalAlert.h"
#import <MBProgressHUD.h>
#import "LimitInfoTableViewCell.h"
#import "PersonalDataViewController.h"
#import "AppDelegate.h"
#import "PeosonInfoType.h"
#import "ReplaceViewController.h"
#import "RealNameViewController.h"
#import "DictionarisModel.h"
#import "FaceVerityViewController.h"
#import "PeopleViewController.h"
#import "MustSendImageViewController.h"
//#import "PasswordProtocolViewController.h"
//#import "RememberPasswordViewController.h"
#import "ChooseSendImageViewController.h"
//#import "StatusViewController.h"
#import "MoxieSDK.h"
#import "DefineSystemTool.h"
#import "ConfirmPayNoBankViewController.h"
//以下需要修改为您平台的信息
//启动SDK必须的参数
//Apikey,您的APP使用SDK的API的权限
//#define theApiKey @"75805d4f35de4bbbba1c58c2b2d97549"//生产
#define theApiKey @"51f5eed2f64f467a9a20f15d2ce26038"
//用户ID,您APP中用以识别的用户ID
//#define theUserID @"moxietest_iosdemo"
static CGFloat const CheckPersonInfo =100;//校验信息完整性
static CGFloat const getDict =110;//校验信息完整性
@interface UpLimitInfoViewController ()<UITableViewDelegate,UITableViewDataSource,SendCellNameDelegate,BSVKHttpClientDelegate,MoxieSDKDelegate>

{
    
    UICollectionView *_infoCollectionView;//底部视图
    
    UITableView *_infoTableView;//底部视图
    
    NSArray *_nameArray;//组头名称数组
    
    NSMutableArray *_titleArray;//item名称数组
    
    UIView *_headerView;//头部视图
    
    UIView *_footView;//足部视图
    
    NSInteger _nowSelect;//当前选择视图
    
    NSMutableDictionary *_successDic;//记录信息完善情况
    
    float x;
    
}

@end

@implementation UpLimitInfoViewController

#pragma mark --> life Cycle

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.navigationItem.title = @"完善资料";
    self.view.backgroundColor = UIColorFromRGB(0xeeeeee, 1.0);
    self.edgesForExtendedLayout = UIRectEdgeNone;

    [AppDelegate delegate].userInfo.fundTaskId =nil;
    [AppDelegate delegate].userInfo.unionPayTaskId = nil;
//    /***必须配置的基本参数*/
    [MoxieSDK shared].delegate = self;
    [MoxieSDK shared].mxUserId = [AppDelegate delegate].userInfo.userId;
    [MoxieSDK shared].mxApiKey = theApiKey;
    [MoxieSDK shared].fromController = self;
    [MoxieSDK shared].backImageName = @"返回1";
    [MoxieSDK shared].refreshImageName = @"refresh";
    [self creatDataArray];
    
    if (FromTE == _fromViewClass) {
        
        [self creatHeaderView];
    }

    [self creatFootView];
    
    [self creatInfoTable];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    if (!_successDic) {
        
        _successDic = [[NSMutableDictionary alloc]init];
        
    }

    [self buildGetPersonInfo];
    
}

#pragma mark --> private Methods

//获取个人信息
-(void)buildGetPersonInfo{
    
    NSMutableDictionary *parm = [[NSMutableDictionary alloc]init];
    
    BSVKHttpClient *client = [BSVKHttpClient shareInstance];
    
    client.delegate = self;
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [parm setObject:@"N" forKey:@"isOrder"];
    
    AppDelegate *dele = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    if (dele.userInfo.userId.length > 0) {
        
        [parm setObject:dele.userInfo.userId forKey:@"userId"];
        
    }
    
    if (dele.userInfo.realName.length > 0) {
        
        [parm setObject:dele.userInfo.realName forKey:@"custName"];
        
    }
    
    if (dele.userInfo.custNum.length > 0) {
        
        [parm setObject:dele.userInfo.custNum forKey:@"custNo"];
        
    }
    
    if (dele.userInfo.realId.length > 0) {
        
        [parm setObject:dele.userInfo.realId forKey:@"idNo"];
        
    }
    
    if (_firstMentionQuote == NO) {
        
        [parm setObject:StringOrNull([AppDelegate delegate].userInfo.applSeq) forKey:@"applSeq"];
        
    }
    
    NSString *type;
    
    if (FromPersonData == _fromViewClass) {
      
        type = @"GRXX";
        
    }else{
        
        type = @"TE";
    }
    
    if (dele.userInfo.whiteType == WhiteA) {
        
        [client postInfo:[NSString stringWithFormat:@"app/appserver/A/%@/checkIfMsgComplete",type] requestArgument:parm requestTag:CheckPersonInfo requestClass:NSStringFromClass([self class])];
        
    }else if (dele.userInfo.whiteType == WhiteB){
       
        [client postInfo:[NSString stringWithFormat:@"app/appserver/B/%@/checkIfMsgComplete",type] requestArgument:parm requestTag:CheckPersonInfo requestClass:NSStringFromClass([self class])];
        
    }else if (dele.userInfo.whiteType == WhiteCReason ||dele.userInfo.whiteType == WhiteCNoReason){
        
        [client postInfo:[NSString stringWithFormat:@"app/appserver/C/%@/checkIfMsgComplete",type] requestArgument:parm requestTag:CheckPersonInfo requestClass:NSStringFromClass([self class])];
        
    }else{
      
        [client postInfo:[NSString stringWithFormat:@"app/appserver/SHH/%@/checkIfMsgComplete",type] requestArgument:parm requestTag:CheckPersonInfo requestClass:NSStringFromClass([self class])];
        
    }
    
}

//创建数据数组
-(void)creatDataArray{
    
    
    _nameArray = [NSArray arrayWithObjects:@"身份信息",@"基本信息",@"授权认证", nil];
    
    NSArray *arrayOne = [NSArray arrayWithObjects:@"实名认证",@"人脸识别", nil];
    
    NSArray *arrayTwo = [NSArray arrayWithObjects:@"单位信息",@"个人信息",@"居住信息",@"联系人信息", nil];
    
    NSArray *arrayFour = [NSArray arrayWithObjects:@"必传影像",@"选传影像", nil];
    
    NSArray *arrayThree = [NSArray arrayWithObjects:@"公积金",@"银联", nil];
    
    NSArray *arraySix = [NSArray arrayWithObjects:arrayOne, nil];
    
    NSArray *arraySeven = [NSArray arrayWithObjects:arrayThree, nil];
    
    NSArray *arrayFive = [NSArray arrayWithObjects:arrayTwo,arrayFour, nil];
    
    _titleArray = [NSMutableArray arrayWithObjects:arraySix,arrayFive,arraySeven, nil];
    
}

//创建头部视图
-(void)creatHeaderView{
    
    _headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DeviceWidth, 45)];
    
    _headerView.backgroundColor = UIColorFromRGB(0xeeeeee, 1.0);
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(15, 15, DeviceWidth-15, 15)];
    
    label.text = @"完善资料可获得更多额度";
    
    label.font = [UIFont appFontRegularOfSize:14];
    
    [_headerView addSubview:label];
    
}

//创建足部视图
-(void)creatFootView{
    
    _footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DeviceWidth, 125)];
    
    _footView.backgroundColor = [UIColor clearColor];
    
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(46, 50, DeviceWidth-92, 50)];
    
    button.layer.cornerRadius = 25;
    
    if (FromTE == _fromViewClass) {
    
        [button setTitle:@"申请提额" forState:UIControlStateNormal];
        
    }else{
      
        [button setTitle:@"保存" forState:UIControlStateNormal];
        
    }
    
    button.titleLabel.font = [UIFont appFontRegularOfSize:15];
    
    [button addTarget:self action:@selector(buildNextAction:) forControlEvents:UIControlEventTouchUpInside];
    
    button.backgroundColor = UIColorFromRGB(0x32beff, 1.0);
    
    [_footView addSubview:button];
    
}

//创建表视图
-(void)creatInfoTable{
    
    _infoTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, DeviceWidth, DeviceHeight-64) style:UITableViewStyleGrouped];
    
    _infoTableView.dataSource = self;
    
    _infoTableView.delegate = self;
    
    _infoTableView.showsVerticalScrollIndicator = NO;
    
    if (FromTE == _fromViewClass) {
      _infoTableView.tableHeaderView = _headerView;
    }
    
    _infoTableView.tableFooterView = _footView;
    
    [self.view addSubview:_infoTableView];
    
}

- (void)setNavi
{
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = ReturnRect;
    [backBtn setImage:[UIImage imageNamed:@"返回_黑"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(OnBackBtn:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
}

#pragma mark --> response Methods
//点击申请提额按钮
-(void)buildNextAction:(UIButton *)sender{
    
    if (FromTE == _fromViewClass) {
        
        
        for (int i = 0; i<2; i++) {
            
            NSArray *array = _titleArray[i];
            
            for (NSArray *arrayTwo in array) {
                
                for (NSString *string in arrayTwo) {
                    
                    if ([string isEqualToString:@"人脸识别"]) {
                        
                        CheckMsgRlsb *rlsb = [_successDic objectForKey:string];
                        
                        if (![rlsb.code isEqualToString:@"00"]) {
                            
                            [self buildHeadError:@"请完善人脸识别"];
                            
                            return;
                        }
                        
                        
                        
                    }else if ([string isEqualToString:@"必传影像"]){
                        
                        CheckMsgBcyx *bcyx = [_successDic objectForKey:string];
                        
                        if (![bcyx.BCYX isEqualToString:@"Y"]) {
                            
                            [self buildHeadError:@"请完善必传影像"];
                            
                            return;
                            
                        }
                        
                        
                        
                    }else if (![string isEqualToString:@"选传影像"]){
                        
                        NSString *jack = [_successDic objectForKey:string];
                        
                        if (![jack isEqualToString:@"Y"]) {
                            
                            [self buildHeadError:[NSString stringWithFormat:@"请完善%@",string]];
                            
                            return;
                            
                        }
                        
                        
                    }
                    
                    
                }
                
            }
            
        }
 
    }
    
    if (FromTE == _fromViewClass) {
#warning mark -->暂时注释以后恢复
        if ([AppDelegate delegate].userInfo.bsetPayPwd)
        {//有支付密码
            
//            RememberPasswordViewController *vc = [[RememberPasswordViewController alloc]init];
//            vc.flowName = _flowName;
//            vc.firstMentionQuote = _firstMentionQuote;
//            vc.title = @"请输入支付密码";
//            [self.navigationController pushViewController:vc animated:YES];
            
        }else
        {//没有支付密码
//            PasswordProtocolViewController * vc = [[PasswordProtocolViewController alloc]init];
//            
//            vc.flowName = _flowName;
//            vc.firstMentionQuote = _firstMentionQuote;
//            [self.navigationController pushViewController:vc animated:YES];
        }
        
    }else{
       
        
        WEAKSELF
        
        [RMUniversalAlert showAlertInViewController:self withTitle:@"提示" message:@"保存成功" cancelButtonTitle:@"我知道了" destructiveButtonTitle:nil otherButtonTitles:nil tapBlock:^(RMUniversalAlert * _Nonnull alert, NSInteger buttonIndex) {
           
            STRONGSELF
            
            if (strongSelf) {
                NSArray * array = strongSelf.navigationController.viewControllers;
                
                for (UIViewController * vc  in array) {
                    
                    if ([vc isKindOfClass:[PersonalDataViewController class]]) {
                        
                        [strongSelf.navigationController popToViewController:vc animated:YES];
                        
                    }
                }
 
            }
            
        }];
        
    }
}

//跳转至个人信息页面
-(void)buildToPeopleInfo:(NSInteger)tag{
    
    PeopleViewController *vc = [[PeopleViewController alloc]init];

    if (FromTE == _fromViewClass) {
        vc.ifFromTe = YES;
    }
   
    vc.currentIndex = tag;
    
    [self.navigationController pushViewController:vc animated:YES];
    
}

//跳转 必传影像
- (void)toMustImageViewController{
    
    MustSendImageViewController *mustVC = [[MustSendImageViewController alloc] init];
    if (FromTE == _fromViewClass) {
        mustVC.ifFromTE = YES;
    }else{
        
        mustVC.ifFromTE = NO;
    }
    mustVC.firstMentionQuote = self.firstMentionQuote;
    CheckMsgBcyx *bcyx = [_successDic objectForKey:@"必传影像"];
    mustVC.mustSendTypeArray = bcyx.list;
    [self.navigationController pushViewController:mustVC animated:YES];
}

//去选传影像
- (void)toChooseImage
{
    ChooseSendImageViewController *chooseVC = [[ChooseSendImageViewController alloc] init];
    if (FromTE == _fromViewClass) {
        chooseVC.isFromTE = YES;
    }else{
        
        chooseVC.isFromTE = NO;
    }
    chooseVC.firstMentionQuote = self.firstMentionQuote;
    
    chooseVC.chooseSendTypeArray = [_successDic objectForKey:@"选传影像"];
    [self.navigationController pushViewController:chooseVC animated:YES];
}

//实名认证方法
- (void)toRealName
{
#warning mark -->暂时注释
//    RealNameViewController *vc = [[RealNameViewController alloc]init];
//    
//    vc.flowName = fromMoney;
//    
//    [self.navigationController pushViewController:vc animated:YES];
}

//前往身份验证页面
-(void)toStatusView{
   #warning mark -->暂时注释
//    StatusViewController *staVc = [[StatusViewController alloc]init];
//    
//    [self.navigationController pushViewController:staVc animated:YES];
    
}

-(CheckMsgBcyx *)buildJudgeImage:(CheckMsgBcyx *)model{
    
    CheckMsgBcyx *bcyx = [[CheckMsgBcyx alloc]init];
    
    NSMutableArray *array = [NSMutableArray arrayWithArray:model.list];
    
    for (int i =0; i<array.count; i++) {
        
        CheckMsgList *list = array[i];
        
        if ([list.docDesc isEqualToString:@"身份证正面"]||[list.docDesc isEqualToString:@"身份证反面"]) {
            
            [array removeObject:list];
            
            i--;
            
        }
        
    }
    
    bcyx.BCYX = model.BCYX;
    
    bcyx.list = array;
    
    return bcyx;
    
}

//点击返回按钮
-(void)OnBackBtn:(UIButton *)btn{
    
    if (FromPersonData == _fromViewClass) {
        
        NSArray * array = self.navigationController.viewControllers;
        
        for (UIViewController * vc  in array) {
            
            if ([vc isKindOfClass:[PersonalDataViewController class]]) {
                
                [self.navigationController popToViewController:vc animated:YES];
                
            }
        }

        
    }else{
        
        [self.navigationController popViewControllerAnimated:YES];
        
    }
    
}

#pragma mark --> tableView代理协议

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return _nameArray.count;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    NSArray *array = _titleArray[section];
    
    return array.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    LimitInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (cell == nil) {
        
        cell = [[LimitInfoTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.delegate = self;
        
        
    }
    
    NSArray *array = _titleArray[indexPath.section];
        
    NSArray *rose = array[indexPath.row];
    
    [cell insertTitleArray:rose success:_successDic];
        
    return cell;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return DeviceWidth/4;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 33;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    if (section == 2) {
        
        return 0.00000000008;
        
    }else{
     
         return 10;
        
    }
    
   
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DeviceWidth, 33)];
    
    view.backgroundColor = [UIColor whiteColor];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, DeviceWidth-15, 33)];
    
    label.font = [UIFont appFontRegularOfSize:14];
    
    label.text = _nameArray[section];
    
    [view addSubview:label];
    
    return view;
    
}

#pragma mark -->网络代理协议

-(void)requestSucess:(NSInteger)requestTag requestResult:(id)responseObject requestClass:(NSString *)className{
    
    if ([className isEqualToString:NSStringFromClass([self class])]) {
        
        if (requestTag == CheckPersonInfo) {
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            //校验信息完整性
            CheckMsgModel *model = [CheckMsgModel mj_objectWithKeyValues:responseObject];
            
            [self buildHandleCheckInfo:model];
            
        }else if (requestTag == getDict){
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            DictionarisModel * model = [DictionarisModel mj_objectWithKeyValues:responseObject];
            
            [self analySisDictionarisModel:model];
            
        }
        
    }
    
}

//请求失败（参数错误）
-(void)requestFail:(NSInteger)requestTag requestError:(NSError *)error httpCode:(NSInteger)httpCode requestClass:(NSString *)className{
    
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

//连接服务器成功后，返回的报文头信息
-(void)buildHeadError:(NSString *)error{
    
    WEAKSELF
    [RMUniversalAlert showAlertInViewController:self withTitle:@"提示" message:error cancelButtonTitle:@"知道了" destructiveButtonTitle:nil otherButtonTitles:nil tapBlock:^(RMUniversalAlert * _Nonnull alert, NSInteger buttonIndex) {
        STRONGSELF
        if (strongSelf) {
            if (buttonIndex == 0) {
                return;
            }
        }
    }];
    
    
}

#pragma mark --> 处理网络请求成功后的逻辑

//  字典项查询
- (void)queryGetDictionaryData{
    
    [BSVKHttpClient shareInstance].delegate = self;
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [[BSVKHttpClient shareInstance]getInfo:@"app/appserver/cmis/getDict" requestArgument:nil requestTag:getDict requestClass:NSStringFromClass([self class])];
}

-(void)analySisDictionarisModel:(DictionarisModel *)model{
    
    if ([model.head.retFlag isEqualToString:SucessCode]) {
        
        [AppDelegate delegate].userInfo.haveDictionary = YES;
        
        [DefineSystemTool insert:model];
        
        [self buildToPeopleInfo:_nowSelect];
        
    }else{
        
        [AppDelegate delegate].userInfo.haveDictionary = NO;
        
        [self buildHeadError:model.head.retMsg];
    }
    
    
}

//校验个人信息处理
-(void)buildHandleCheckInfo:(CheckMsgModel *)model{
    
    if ([model.head.retFlag isEqualToString:@
        "00000"]) {
        
        if (!_successDic) {
            
            _successDic = [[NSMutableDictionary alloc]init];
            
        }else{
            
            [_successDic removeAllObjects];
            
        }
        
        if (model.body.SMRZ.length > 0) {
            
            [_successDic setObject:model.body.SMRZ forKey:@"实名认证"];
            
        }
        
        if (model.body.CERTFLAG.length > 0) {
            
            if ([model.body.CERTFLAG isEqualToString:@"Y"]) {
                
                NSArray *arrayOne = [NSArray arrayWithObjects:@"实名认证",@"人脸识别", nil];
                
                NSArray *arraySix = [NSArray arrayWithObjects:arrayOne, nil];
                
                [_titleArray replaceObjectAtIndex:0 withObject:arraySix];
                
                
            }else {
               
                NSArray *arrayOne = [NSArray arrayWithObjects:@"实名认证",@"人脸识别",@"身份验证", nil];
                
                NSArray *arraySix = [NSArray arrayWithObjects:arrayOne, nil];
                
                [_titleArray replaceObjectAtIndex:0 withObject:arraySix];
                
            }
            
             [_successDic setObject:model.body.CERTFLAG forKey:@"身份验证"];
            
        }
        
        if (model.body.RLSB) {
            
            [_successDic setObject:model.body.RLSB forKey:@"人脸识别"];
            
        }
        
        if (model.body.DWXX.length > 0) {
            
            [_successDic setObject:model.body.DWXX forKey:@"单位信息"];
            
        }
        
        if (model.body.GRJBXX.length > 0) {
            
            [_successDic setObject:model.body.GRJBXX forKey:@"个人信息"];
            
        }
        
        if (model.body.JZXX.length > 0) {
            
            [_successDic setObject:model.body.JZXX forKey:@"居住信息"];
            
        }
        
        if (model.body.LXRXX.length > 0) {
            
            [_successDic setObject:model.body.LXRXX forKey:@"联系人信息"];
            
        }
        
        CheckMsgBcyx *bcyx = [self buildJudgeImage:model.body.BCYX];
        
        if (bcyx.list && bcyx.list.count > 0) {
            
            [_successDic setObject:bcyx forKey:@"必传影像"];
            
        }else{
            
            NSArray *arrayTwo = [NSArray arrayWithObjects:@"单位信息",@"个人信息",@"居住信息",@"联系人信息", nil];
            
            NSArray *arrayFour = [NSArray arrayWithObjects:@"选传影像", nil];
            
            NSArray *array = [NSArray arrayWithObjects:arrayTwo,arrayFour, nil];
            
            [_titleArray replaceObjectAtIndex:1 withObject:array];
            
        }
        
        if (model.body.QTYX) {
            
            [_successDic setObject:model.body.QTYX forKey:@"选传影像"];
            
        }

        if ([AppDelegate delegate].userInfo.fundTaskId.length >0 && [AppDelegate delegate].userInfo.fundTaskId) {
            //判断是否是从我的嗨付（个人资料）进来（从个人资料进入公积金，银联，不是必传）
            
            [_successDic setObject:@"Y" forKey:@"公积金"];
            
        }
        
        if ([AppDelegate delegate].userInfo.unionPayTaskId.length > 0 &&[AppDelegate delegate].userInfo.unionPayTaskId){
            
            [_successDic setObject:@"Y" forKey:@"银联"];
            
        }

        
        [_infoTableView reloadData];
        
    }else{
        
        [self buildHeadError:model.head.retMsg];
        
    }
    
}

#pragma mark --> cell的传值代理
-(void)sendCellName:(NSString *)name{
    
    if (![name isEqualToString:@"实名认证"]) {
        
        NSString *jack = [_successDic objectForKey:@"实名认证"];
        
        if (![jack isEqualToString:@"Y"]) {
            
            [self buildHeadError:@"请先进行实名认证"];
            
            return;
            
        }
    }
        
        if ([name isEqualToString:@"实名认证"]){
            
           [self toRealName];
            
        }else if ([name isEqualToString:@"身份验证"]){
            
            [self toStatusView];
            
        }else{
            
            if ([name isEqualToString:@"人脸识别"]) {
                
                CheckMsgRlsb *rlsb = [_successDic objectForKey:name];
                
                if ([rlsb.code isEqualToString:@"00"]) {
                    
                    if (rlsb.attachList.count > 0) {
                        
                        ReplaceViewController *repVc = [[ReplaceViewController alloc]init];
                        
                        repVc.imageArray = rlsb.attachList;
                        
                        if (FromTE == _fromViewClass) {
                            repVc.ifFromTE = YES;
                        }else{
                            repVc.ifFromPerson = YES;
                        }
                        
                        HCRootNavController *nav = [[HCRootNavController alloc] initWithRootViewController:repVc];
                        [self presentViewController:nav animated:YES completion:nil];
                        
                    }else{
                        
                        [self buildHeadError:@"您已有过人脸识别"];
                        
                    }
                    return;
                    
                }else if ([rlsb.code isEqualToString:@"02"]){
                    
                    ReplaceViewController *repVc = [[ReplaceViewController alloc]init];
                    
                    repVc.imageArray = rlsb.attachList;
                    
                    if (FromTE == _fromViewClass) {
                        repVc.ifFromTE = YES;
                    }else{
                        repVc.ifFromPerson = YES;
                    }
                    
                    HCRootNavController *nav = [[HCRootNavController alloc] initWithRootViewController:repVc];
                    [self presentViewController:nav animated:YES completion:nil];
                    
                }else if ([rlsb.code isEqualToString:@"10"]){
#warning mark -->暂时注释
//                    FaceVerityViewController *faceVc = [[FaceVerityViewController alloc]init];
//                    
//                    faceVc.flowName = _flowName;
//                    
//                    CustomNavigationController *nav = [[CustomNavigationController alloc] initWithRootViewController:faceVc];
//                    [self presentViewController:nav animated:YES completion:nil];
                    
                }else{
                    
                    [self buildHeadError:@"人脸识别已超过上限次数，暂不能继续办理，详询4000187777"];
                    
                }
                
            }else if ([name isEqualToString:@"个人信息"]){
                
                if ([AppDelegate delegate].userInfo.haveDictionary) {
                    
                    [self buildToPeopleInfo:1];
                    
                }else{
                    
                    _nowSelect = 1;
                    
                    [self queryGetDictionaryData];
                    
                }
                
            }else if ([name isEqualToString:@"单位信息"]){
                
                if ([AppDelegate delegate].userInfo.haveDictionary) {
                    
                    [self buildToPeopleInfo:0];
                    
                }else{
                    
                    _nowSelect = 0;
                    
                    [self queryGetDictionaryData];
                    
                }
                
            }else if ([name isEqualToString:@"居住信息"]){
                
                if ([AppDelegate delegate].userInfo.haveDictionary) {
                    
                    [self buildToPeopleInfo:2];
                    
                }else{
                    
                    _nowSelect = 2;
                    
                    [self queryGetDictionaryData];
                    
                }
                
            }else if ([name isEqualToString:@"联系人信息"]){
                
                if ([AppDelegate delegate].userInfo.haveDictionary) {
                    
                    [self buildToPeopleInfo:3];
                    
                }else{
                    
                    _nowSelect = 3;
                    
                    [self queryGetDictionaryData];
                    
                }
                
            }else if ([name isEqualToString:@"必传影像"]){
                
                [self toMustImageViewController];
                
            }else if ([name isEqualToString:@"选传影像"]){
                
                [self toChooseImage];
                
            }else if ([name isEqualToString:@"公积金"]){

                [MoxieSDK shared].taskType = @"fund";
                NSLog(@"mxSDKVersion:%@",[MoxieSDK shared].mxSDKVersion);
                [[MoxieSDK shared] startFunction];
                
            }else{
                        /***必须配置的基本参数*/
                        [MoxieSDK shared].delegate = self;
                        [MoxieSDK shared].mxUserId = [AppDelegate delegate].userInfo.userId;
                        [MoxieSDK shared].mxApiKey = theApiKey;
                        [MoxieSDK shared].fromController = self;

                [MoxieSDK shared].taskType = @"bank";
                [[MoxieSDK shared] startFunction];
                
            }
            
            
        }
        
    
   
    
}
#pragma MoxieSDK Delegate

-(void)receiveMoxieSDKResult:(NSDictionary*)resultDictionary{
    int code = [resultDictionary[@"code"] intValue];
    NSString *taskType = resultDictionary[@"taskType"];
    NSString *taskId = resultDictionary[@"taskId"];
    NSString *searchId = resultDictionary[@"searchId"];
    NSString *message = resultDictionary[@"message"];
    NSString *account = resultDictionary[@"account"];
    NSLog(@"get import result---code:%d,taskType:%@,taskId:%@,searchId:%@,message:%@,account:%@",code,taskType,taskId,searchId,message,account);
    NSLog(@"Version:%@ 杭州魔蝎数据科技有限公司",[MoxieSDK shared].mxSDKVersion);
    //用户没有做任何操作
    if(code == -1){
        NSLog(@"用户未进行操作");
        
    }
    //假如code是2则继续查询该任务进展
    else if(code == 2){
        NSLog(@"任务进行中，可以继续轮询");
        
    }
    //假如code是1则成功
    else if(code == 1){
        NSLog(@"任务成功");
        if ([taskType isEqualToString:@"fund"]) {
            [AppDelegate delegate].userInfo.fundTaskId =taskId;
        }else{
            [AppDelegate delegate].userInfo.unionPayTaskId = taskId;
        }
    }
    //该任务失败按失败处理
    else{
        NSLog(@"任务失败");
        
    }
    NSLog(@"任务结束，可以根据taskid，在租户管理系统查询该次任何的最终数据，在魔蝎云监控平台查询该任务的整体流程信息。SDK只会回调状态码及部分基本信息，完整数据会最终通过服务端回调。（记得将本demo的apikey修改成公司对应的正确的apikey）");
}


#pragma mark -- 分割线
- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    if ([_infoTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [_infoTableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([_infoTableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [_infoTableView setLayoutMargins:UIEdgeInsetsZero];
    }
    
    
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}



@end
