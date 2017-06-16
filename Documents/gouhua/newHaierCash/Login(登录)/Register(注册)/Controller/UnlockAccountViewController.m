//
//  UnlockAccountViewController.m
//  newHaierCash
//
//  Created by 张久健 on 2017/6/1.
//  Copyright © 2017年 haier. All rights reserved.
//

#import "UnlockAccountViewController.h"
#import "HCMacro.h"
#import "TopView.h"
#import "RegisterViewController.h"
#import "RegCodeViewController.h"
#import "AppDelegate.h"
#import "TopCollectionViewCell.h"
#import "HCShowPersonInfoViewController.h"
#import "HCRegSetPassNumViewController.h"
#import "HCCardFrontViewController.h"
#import "HCCardSideViewController.h"
#import "AllloanViewController.h"
#import "RMUniversalAlert.h"
#import "UIColor+DefineNew.h"
#import "HCCheckBankViewController.h"
#import "HCSetPayPassViewController.h"
#import "HCLeadFaveViewController.h"
#import "ConfirmPayNoBankViewController.h"
#import "HCPayCodeViewController.h"
#import "ApprovalProgressViewController.h"
@interface UnlockAccountViewController ()<UICollectionViewDelegateFlowLayout,UICollectionViewDataSource,UICollectionViewDelegate,SendSuccessDelegate>

{
    
    float x;//屏幕适配比例
    
    float width;;
    
}


@property (nonatomic,assign)float height;

/*
 数据存放
 */
@property (nonatomic,strong) NSMutableArray *modelArray;               //标题数组

@property (nonatomic,assign) NowWhere nowWhere;//当前所在视图

@property (nonatomic,strong) UIView *lightView;//笼罩视图

/*
 顶部界面搭建
 */

@property (nonatomic,strong) UICollectionView *topCollection;   //顶部展示视图

/*
 子ViewController
 */
@property (nonatomic,strong) RegisterViewController *registerViewController;//注册界面输入手机号

@property (nonatomic,strong) RegCodeViewController *regCodeViewController;//注册界面填写验证码

@property (nonatomic,strong) HCRegSetPassNumViewController *hcRegSetPassNumViewController;//设置登录密码

@property (nonatomic,strong) HCShowPersonInfoViewController *hcShowPersonInfoViewController;//填写个人资料

@property (nonatomic,strong)HCCardFrontViewController *hcCardFrontViewController;//身份证正面识别

@property (nonatomic,strong) HCCardSideViewController *hcCardSideViewController;//身份证反面识别

@property (nonatomic,strong) HCCheckBankViewController *hcCheckBankViewController;//校验银行卡

@property (nonatomic,strong)HCLeadFaveViewController *hcLeadFaveViewController;//人脸识别

@property (nonatomic,strong)HCSetPayPassViewController *hcSetPayPassViewController;//设置支付密码

@property (nonatomic,strong)HCPayCodeViewController *hcPayCodeViewController;//支付密码验证码


@end

#pragma mark --> life Cycle

@implementation UnlockAccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.edgesForExtendedLayout = UIRectEdgeBottom;
    
    //导航
    [self setNavi];
    //标题
    [self initTitleArray];
    
    [self addControllers];
    
    [self creatJudgeViewStart];
    
    //顶部视图
    [self creatTopCollectionView];
    
     [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(addFaceNotice:) name:@"FaceSuccessState" object:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
}

-(void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    
   
    
}

-(void)dealloc{
   
     [[NSNotificationCenter defaultCenter]removeObserver:self];
    
}

#pragma  mark - private Methods

//创建返回按钮
- (void)setNavi{
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = ReturnRect;
    [backBtn setImage:[UIImage imageNamed:@"返回_黑"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(OnBackBtn:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
}

//创建顶部展示视图
-(void)creatTopCollectionView{
    
    if (iphone6P) {
        
        x = scale6PAdapter;
        
    }else{
        
        x = scaleAdapter;
        
    }
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    
    
    layout.itemSize = CGSizeMake(40*x, 97*x);
    

    
    if (_showType == ShowRegAndRealInfo) {
        
        width = (DeviceWidth -80*x)/3.0;
        
    }else if (_showType == ShowPerAndFaceInfo){
       
        width =  (DeviceWidth -120*x)/4.0;
        
    }else{
        
        width =  (DeviceWidth -200*x)/6.0;
        
    }
    
    layout.footerReferenceSize = CGSizeMake(width, 97*x);
    
    _height = layout.footerReferenceSize.height;
    
    layout.minimumLineSpacing = 0;
    
    layout.minimumInteritemSpacing = 0;
    
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    if (_showType == ShowAllInfo) {
        
        _topCollection = [[UICollectionView alloc]initWithFrame:CGRectMake((DeviceWidth-200*x-4*width)/2, 0, 200*x+width*4, 97*x)collectionViewLayout:layout];
        
    }else if (_showType == ShowPerAndFaceInfo){
        
        _topCollection = [[UICollectionView alloc]initWithFrame:CGRectMake((DeviceWidth-120*x-width*2)/2, 0, 120*x+width*2, 97*x) collectionViewLayout:layout];
        
    }else{
        
        _topCollection = [[UICollectionView alloc]initWithFrame:CGRectMake((DeviceWidth-80*x-width)/2, 0, 80*x+width, 97*x) collectionViewLayout:layout];
        
    }
    
    _topCollection.delegate = self;
    
    _topCollection.dataSource = self;
    
    _topCollection.backgroundColor = [UIColor whiteColor];
    
    _topCollection.showsHorizontalScrollIndicator = NO;
    
    [_topCollection registerClass:[TopCollectionViewCell class] forCellWithReuseIdentifier:@"top"];
    
    [_topCollection registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"foot"];
    
    [self.view addSubview:_topCollection];
}

//添加子视图控制器
-(void)addControllers{
    
    //注册视图
    _registerViewController = [[RegisterViewController alloc]init];
    
    _registerViewController.delegate = self;
    
    [self addChildViewController:_registerViewController];
    
    _hcRegSetPassNumViewController = [[HCRegSetPassNumViewController alloc]init];
    
    _hcRegSetPassNumViewController.delegate = self;
    
    [self addChildViewController:_hcRegSetPassNumViewController];
    
    _regCodeViewController = [[RegCodeViewController alloc]init];
    
    _regCodeViewController.delegate = self;
    
    [self addChildViewController:_regCodeViewController];
    
    //实名认证视图
    _hcCardFrontViewController = [[HCCardFrontViewController alloc]init];
    
    _hcCardFrontViewController.delegate = self;
    
    [self addChildViewController:_hcCardFrontViewController];
    
    _hcCardSideViewController = [[HCCardSideViewController alloc]init];
    
    _hcCardSideViewController.delegate = self;
    
    [self addChildViewController:_hcCardSideViewController];
    
    _hcCheckBankViewController = [[HCCheckBankViewController alloc]init];
    
    _hcCheckBankViewController.delegate = self;
    
    [self addChildViewController:_hcCheckBankViewController];
    
    //个人信息视图
    _hcShowPersonInfoViewController = [[HCShowPersonInfoViewController alloc]init];
    
    _hcShowPersonInfoViewController.typCde = _typeCde;
    
    _hcShowPersonInfoViewController.delegate = self;
    
    [self addChildViewController:_hcShowPersonInfoViewController];
    
    //人脸识别视图
    _hcLeadFaveViewController = [[HCLeadFaveViewController alloc]init];
    
    _hcLeadFaveViewController.delegate = self;

    _hcLeadFaveViewController.faceStatus = _faceInfoSuccess;
    
    if (_faceImgArray) {
        _hcLeadFaveViewController.imageArray = _faceImgArray;
    }
    
    [self addChildViewController:_hcLeadFaveViewController];
    
    //设置支付密码
    _hcSetPayPassViewController = [[HCSetPayPassViewController alloc]init];
    
    _hcSetPayPassViewController.delegate = self;
    
    [self addChildViewController:_hcSetPayPassViewController];
    
    _hcPayCodeViewController = [[HCPayCodeViewController alloc]init];
    
    _hcPayCodeViewController.delegate = self;
    
    [self addChildViewController:_hcPayCodeViewController];
    
    
}

//判断从哪个页面开始显示
-(void)creatJudgeViewStart{
    
    if (_startType == FromRegister) {
        
        self.navigationItem.title = @"注册";
        
        [self.view addSubview:self.registerViewController.view];
        
        _nowWhere = NowRegister;
        
    }else if (_startType == FromRealName){
        
        self.navigationItem.title = @"实名认证";
        
        [self.view addSubview:_hcCardFrontViewController.view];
        
        _nowWhere = NowCardFront;
        
    }else if (_startType == FromPersonInfo){
        
        self.navigationItem.title = @"个人资料";
        
        [self.view addSubview:self.hcShowPersonInfoViewController.view];
        
        _nowWhere = NowPersonInfo;
        
    }else if (_startType == FromFace){
        
        self.navigationItem.title = @"人脸识别";
        
        [self.view addSubview:self.hcLeadFaveViewController.view];
        
        _nowWhere = NowFace;
        
    }else if (_startType == FromSetPayNum){
        
        self.navigationItem.title = @"密码设置";
        
        [self.view addSubview:self.hcSetPayPassViewController.view];
        
        _nowWhere = NowSetPayNum;
        
    }
    
}

//创建标题数据
- (void)initTitleArray{
    
    NSArray *_titleArray;
    
    if (_showType == ShowAllInfo) {
        
        _titleArray = @[@"注册",@"实名认证",@"个人资料",@"人脸识别",@"密码设置"];
        
    }else if (_showType == ShowPerAndFaceInfo){
        
        _titleArray = @[@"个人资料",@"人脸识别",@"密码设置"];
        
    }else{
        
        _titleArray = @[@"注册",@"实名认证"];
        
    }
    
    _modelArray = [NSMutableArray array];
    
    for (NSString *string in _titleArray) {
        
        PeosonInfoType *type = [[PeosonInfoType alloc]init];
        
        type.title = string;
        
        if ([string isEqualToString:@"注册"]) {
            
            if (_startType == FromRegister) {
                
                type.isFinish = YES;
                
            }else{
                
                type.isFinish = YES;
                
            }
            
        }else if ([string isEqualToString:@"实名认证"]){
            
            if ([AppDelegate delegate].userInfo.myRealNameState == realNameYes || _startType == FromRealName) {
                
                type.isFinish = YES;
                
            }else{
                
                type.isFinish = NO;
                
            }
            
        }else if ([string isEqualToString:@"个人资料"]){
            
            if (_personInfoSuccess || _startType == FromPersonInfo) {
                
                type.isFinish = YES;
                
            }else{
                
                type.isFinish = NO;
                
            }
            
        }else if ([string isEqualToString:@"人脸识别"]){
            
            if (_faceInfoSuccess == FacePassed || _startType == FromFace) {
                
                type.isFinish = YES;
                
            }else{
                
                type.isFinish = NO;
                
            }
            
        }else if ([string isEqualToString:@"密码设置"]){
            
            if ([AppDelegate delegate].userInfo.bsetPayPwd || _startType == FromSetPayNum) {
                
                type.isFinish = YES;
                
            }else{
                
                type.isFinish = NO;
                
            }
            
        }
        
        NSArray *array = @[type];
        
        [_modelArray addObject:array];
        
    }
    
}

-(UIView *)lightView{
    
    if (!_lightView) {
        
        _lightView  = [[UIView alloc]initWithFrame:_topCollection.frame];
        
        _lightView.backgroundColor = [UIColor UIColorWithHexColorString:@"0x7f7f7f" AndAlpha:0.8];
        
        [self.view addSubview:_lightView];
        
    }
    
    return _lightView;
    
}

#pragma mark --> event Methods

//返回按钮方法
-(void)OnBackBtn:(UIButton *)sender{
    
    if (_nowWhere == NowRegister) {
        //输入注册账号时点击返回
        [self.navigationController popViewControllerAnimated:YES];
        
    }else if (_nowWhere == NowVerification){
        //注册验证码时点击返回
        
        [self.view bringSubviewToFront:_registerViewController.view];
        
        [self.view bringSubviewToFront:_topCollection];
        
        _nowWhere = NowRegister;
        
        
    }else if (_nowWhere == NowSetPass){
        //设置登录密码时点击返回
        [self.view bringSubviewToFront:_regCodeViewController.view];
        
        [self.view bringSubviewToFront:_topCollection];
        
        _nowWhere = NowVerification;
        
    }else if (_nowWhere == NowCardFront){
        
        //身份证正面时点击返回
        if (_startType == FromRegister && !_ifFromGesture) {
            
            [self dismissViewControllerAnimated:YES completion:nil];
            
        }else if (_startType == FromRegister && _ifFromGesture){
            
            UIViewController *rootVC = self.presentingViewController;
            
            while (rootVC.presentingViewController) {
                
                rootVC = rootVC.presentingViewController;
                
            }
            
            [rootVC dismissViewControllerAnimated:NO completion:nil];

        }else{
            
            [self.navigationController popViewControllerAnimated:YES];
            
        }
        
        
    }else if (_nowWhere == NowSide){
        
        //身份证反面点击返回
        [self.view bringSubviewToFront:_hcCardFrontViewController.view];
        
        [self.view bringSubviewToFront:_topCollection];
        
        _nowWhere = NowCardFront;
        
    }else if (_nowWhere == NowCheckBank){
        
        //校验银行卡点击返回
        [self.view bringSubviewToFront:_hcCardSideViewController.view];
        
        [self.view bringSubviewToFront:_topCollection];
        
        _nowWhere = NowSide;
        
    }else if (_nowWhere == NowPersonInfo){
        
        [self buildHandlePersonBack];
        
    }else if (_nowWhere == NowFace){
        
        if (self.startType == FromRegister) {
            
            [self dismissViewControllerAnimated:YES completion:nil];
            
        }else{
            
            [self.navigationController popViewControllerAnimated:YES];
            
        }
        
    }else if (_nowWhere == NowSetPayNum){
        
        if (self.startType == FromRegister) {
            
            [self dismissViewControllerAnimated:YES completion:nil];
            
        }else{
            
            [self.navigationController popViewControllerAnimated:YES];
            
        }
        
    }else if (_nowWhere == NowCommit){
        
        //身份证反面点击返回
        [self.view bringSubviewToFront:_hcSetPayPassViewController.view];
        
        [self.view bringSubviewToFront:_topCollection];
        
        _nowWhere = NowSetPayNum;

    }
    
    
}

//处理个人资料点击返回按钮逻辑
-(void)buildHandlePersonBack{
    
    if ([AppDelegate delegate].userInfo.busFlowName == QuotaApply || [AppDelegate delegate].userInfo.busFlowName == QuotaReturned) {
        
        [self.navigationController popToRootViewControllerAnimated:YES];
        
    }else if ([AppDelegate delegate].userInfo.busFlowName == CashLoanCreate){
        
        
        WEAKSELF
        [RMUniversalAlert showAlertInViewController:self withTitle:@"提示" message:@"订单已保存，可到个人中心待提交订单中查看,是否返回?" cancelButtonTitle:@"取消" destructiveButtonTitle:@"确定" otherButtonTitles:nil tapBlock:^(RMUniversalAlert * _Nonnull alert, NSInteger buttonIndex) {
            STRONGSELF
            if (strongSelf) {
                
                [strongSelf.navigationController popToRootViewControllerAnimated:YES];
            }
            
            
        }];
        
        
    }else if ([AppDelegate delegate].userInfo.busFlowName == CashLoanWait || [AppDelegate delegate].userInfo.busFlowName == CashLoanReturned){
        
        for (UIViewController *vc in self.tabBarController.viewControllers) {
            
            if ([vc isKindOfClass:[AllloanViewController class]]) {
                
                [self.navigationController popToViewController:vc animated:YES];
                
            }
            
        }
        
    }else{
        
        if (_startType == FromRegister) {
            
            [self dismissViewControllerAnimated:YES completion:nil];
            
        }else{
            
            [self.navigationController popViewControllerAnimated:YES];
            
        }
        
        
        
    }
    
    
}

#pragma mark --> collection代理方法

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return _modelArray.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return 1;
    
}


- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    TopCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"top" forIndexPath:indexPath];
    
    NSArray *array = _modelArray[indexPath.section];
    
    [cell insertInfomodel:array[indexPath.row]];
    
    return cell;
    
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"foot" forIndexPath:indexPath];
    
    if (view == nil) {
        
        view = [[UICollectionReusableView alloc]init];
        
        view.backgroundColor = [UIColor whiteColor];
    }
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(3*x, 40*x, width-6*x, 1)];
    
    lineView.backgroundColor = UIColorFromRGB(0xdddddd, 1.0);
    
    [view addSubview:lineView];
    
    return view;
    
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    
    if (section == _modelArray.count-1) {
        
        return CGSizeMake(0, 0);
        
    }else{
        
        return CGSizeMake(width, _height);
    }
    
}

#pragma mark --> 显示笼罩视图
-(void)sendViewShow:(BOOL)show{
    
    if (show) {
        
        self.lightView.hidden = NO;
        
    }else{
        
        self.lightView.hidden = YES;
        
        
    }
    
}

#pragma mark --> 视图点击下一步所调用的代理方法
-(void)sendSaveInfoViewType:(ShowUnlockType)type{
    
    if (type == MobileType) {
        
        //输入注册号完成
        [self buildHandleMobileType];
        
    }else if (type == VerificationType){
        
        //输入注册验证码完成
        [self buildHandleVerificationType];
        
    }else if (type == PassWordType){
        
        //设置登录密码
        [self buildHandlePassWordType];
        
    }else if (type == CardPositiveType){
        
        //身份证正面识别完成
        [self buildHaandleCardPositiveType];
        
    }else if (type == CardTheOtherType){
        
        //身份证反面识别完成
        
        [self buildHandleCardTheOtherType];
        
    }else if (type == CheckBankType){
        
        //校验银行卡完成
        [self buildHandleCheckBankType];
    }else if (type == ShowPersonType){
        
        //个人信息完善
        [self buildHandlePersonInfo];
        
    }else if (type == ToFaceVerification){
        //人脸识别完善
        [self buildHandleToFace];
        
    }else if (type == SetPayPassword){
        //设置支付密码
        [self buildHandleSetPayPass];
        
    }else if (type == PasswordVericationType){
        
        //支付密码验证码
        [self buildHandlePasswordVericationType];
    }
    
    [self.view bringSubviewToFront:_topCollection];
    
}

//输入注册账号逻辑处理
-(void)buildHandleMobileType{
    
    if ([self.view.subviews containsObject:_regCodeViewController.view]) {
        
        if (![_regCodeViewController.number isEqualToString:[AppDelegate delegate].userInfo.userId]) {
            
            _regCodeViewController.ifJudgeAgainSend = YES;
            
        }
        
        [self.view bringSubviewToFront:_regCodeViewController.view];
        
    }else{
        
        [self.view addSubview:_regCodeViewController.view];
        
    }
    
    _nowWhere = NowVerification;
    
}

//输入注册验证码逻辑处理
-(void)buildHandleVerificationType{
    
    _hcRegSetPassNumViewController.verifyNo = _regCodeViewController.verifyNo;
    if ([self.view.subviews containsObject:_hcRegSetPassNumViewController.view]) {
        
        [self.view bringSubviewToFront:_hcRegSetPassNumViewController.view];
        
    }else{
        
        [self.view addSubview:_hcRegSetPassNumViewController.view];
    }
    
    _nowWhere = NowSetPass;
    
}

//设置登录密码逻辑处理
-(void)buildHandlePassWordType{
    
    self.navigationItem.title = @"实名认证";
    
    [self replaceTopModel:1 name:@"实名认证"];
    
    //设置登录密码完成
    if ([self.view.subviews containsObject:_hcCardFrontViewController.view]) {
        
        [self.view bringSubviewToFront:_hcCardFrontViewController.view];
        
    }else{
        
        [self.view addSubview:_hcCardFrontViewController.view];
        
    }
    
    [_topCollection reloadData];
    
    _nowWhere = NowPersonInfo;
}

//身份证正面识别完成逻辑处理
-(void)buildHaandleCardPositiveType{
    
    if (!_hcCardSideViewController.cardDictionary) {
        
      _hcCardSideViewController.cardDictionary = _hcCardFrontViewController.cardDictionary;
        
    }else{
        
        for (NSString *string in _hcCardFrontViewController.cardDictionary.allKeys ) {
            
            [_hcCardSideViewController.cardDictionary setObject:[_hcCardFrontViewController.cardDictionary objectForKey:string] forKey:string];
            
        }
        
    }
    
    if ([self.view.subviews containsObject:_hcCardSideViewController.view]) {
        
        [self.view bringSubviewToFront:_hcCardSideViewController.view];
        
    }else{
        
    
        [self.view addSubview:_hcCardSideViewController.view];
        
    }
    
    _nowWhere  = NowSide;
    
}

//身份证反面识别完成逻辑处理
-(void)buildHandleCardTheOtherType{
    
    _hcCheckBankViewController.cardDic = _hcCardSideViewController.cardDictionary;
    
    if ([self.view.subviews containsObject:_hcCheckBankViewController.view]) {
        
        [self.view bringSubviewToFront:_hcCheckBankViewController.view];
        
    }else{
        
        [self.view addSubview:_hcCheckBankViewController.view];
        
    }
    
    _nowWhere = NowCheckBank;
    
}

//校验银行卡逻辑处理
-(void)buildHandleCheckBankType{
    
    
    if (_showType == ShowAllInfo) {
        
         [self replaceTopModel:2 name:@"个人资料"];
        
        self.navigationItem.title = @"个人资料";
        
        //设置登录密码完成
        if ([self.view.subviews containsObject:_hcShowPersonInfoViewController.view]) {
            
            [self.view bringSubviewToFront:_hcShowPersonInfoViewController.view];
            
        }else{
            
            [self.view addSubview:_hcShowPersonInfoViewController.view];
            
        }
        
        _nowWhere = NowPersonInfo;
        
        [_topCollection reloadData];
        
        
    }else{
        
        if (_startType == FromRegister) {
            
            [self dismissViewControllerAnimated:YES completion:nil];
            
        }else{
            
            [self.navigationController popViewControllerAnimated:YES];
            
        }
        
        
        
    }
    
}

//处理个人资料完善后的逻辑
-(void)buildHandlePersonInfo{
    
    //判断人脸识别是否成功
    if (_faceInfoSuccess) {
        //判断用户是否已设置支付密码
        if ([AppDelegate delegate].userInfo.bsetPayPwd) {
            
            if ([AppDelegate delegate].userInfo.busFlowName == QuotaApply ||[AppDelegate delegate].userInfo.busFlowName == QuotaReturned ) {
                
                
                
            }else{
                
                ConfirmPayNoBankViewController *conVc = [[ConfirmPayNoBankViewController alloc]init];
                
                [self.navigationController pushViewController:conVc animated:YES];
                
            }
            
            
        }else{
            
            self.navigationItem.title = @"密码设置";
            
            if ([self.view.subviews containsObject:_hcSetPayPassViewController.view]) {
                
                [self.view bringSubviewToFront:_hcSetPayPassViewController.view];
                
            }else{
                
                [self.view addSubview:_hcSetPayPassViewController.view];
                
            }
            
            _nowWhere = NowSetPayNum;
            
            [_topCollection reloadData];
            
        }
        
    }else{
        
        if (_showType == ShowAllInfo) {
            
            [self replaceTopModel:3 name:@"人脸识别"];
            
        }else{
            
            [self replaceTopModel:1 name:@"人脸识别"];
            
        }
        self.navigationItem.title = @"人脸识别";
        
        if ([self.view.subviews containsObject:_hcLeadFaveViewController.view]) {
            
            [self.view bringSubviewToFront:_hcLeadFaveViewController.view];
            
        }else{
            
            [self.view addSubview:_hcLeadFaveViewController.view];
            
        }
        
        _nowWhere = NowFace;
        
        [_topCollection reloadData];
        
    }
    
}

//人脸识别成功后的逻辑处理

-(void)addFaceNotice:(NSNotification *)center{
    
    NSDictionary *dic = (NSDictionary *)[center object];
    
    NSString *face = [dic objectForKey:@"face"];
    
    if ([face isEqualToString:@"pass"]) {
        
        _hcLeadFaveViewController.faceStatus = FacePassed;
        
        [self buildHandleToFace];
        
    }else if ([face isEqualToString:@"notPass"]){
        
        _hcLeadFaveViewController.faceStatus = FaceNotPass;
        
    }else if ([face isEqualToString:@"image"]){
        
        _hcLeadFaveViewController.faceStatus = FaceReplaceImage;
        
        _hcLeadFaveViewController.imageArray = [dic objectForKey:@"image"];
        
    }else if ([face isEqualToString:@"noCheck"]){
        
        _hcLeadFaveViewController.faceStatus = FaceNotDo;
        
    }
    
}

-(void)buildHandleToFace{
    
    if (_showType == ShowAllInfo) {
        
        [self replaceTopModel:4 name:@"人脸识别"];
        
    }else{
        
        [self replaceTopModel:1 name:@"人脸识别"];
        
    }
    
    if ([AppDelegate delegate].userInfo.bsetPayPwd) {
        
        if ([AppDelegate delegate].userInfo.busFlowName == QuotaApply ||[AppDelegate delegate].userInfo.busFlowName == QuotaReturned ) {
            
            
            
        }else{
            
            ConfirmPayNoBankViewController *conVc = [[ConfirmPayNoBankViewController alloc]init];
            
            [self.navigationController pushViewController:conVc animated:YES];
            
        }
        
        
        
    }else{
        
        self.navigationItem.title = @"密码设置";
        
        if ([self.view.subviews containsObject:_hcSetPayPassViewController.view]) {
            
            [self.view bringSubviewToFront:_hcSetPayPassViewController.view];
            
        }else{
            
            [self.view addSubview:_hcSetPayPassViewController.view];
            
        }
        
        _nowWhere = NowSetPayNum;
        
        [_topCollection reloadData];
        
        [self.view bringSubviewToFront:_topCollection];
        
        
    }
    
}

//支付密码设置成功后的逻辑处理
-(void)buildHandleSetPayPass{
    
    _hcPayCodeViewController.passWord = _hcSetPayPassViewController.passWord;
    
    if (_startType == FromRegister) {
        
        _hcPayCodeViewController.ifCommitOrder = YES;
        
    }
    
    if ([self.view.subviews containsObject:_hcPayCodeViewController.view]) {
        
        [self.view bringSubviewToFront:_hcPayCodeViewController.view];
        
    }else{
        
        [self.view addSubview:_hcPayCodeViewController.view];
        
    }
    
    _nowWhere = NowCommit;

    
}

//支付密码验证码设置成功后的逻辑处理
-(void)buildHandlePasswordVericationType{

    [_topCollection reloadData];
    
    if (_startType == FromRegister) {
        
        [self dismissViewControllerAnimated:YES completion:nil];
        
    }else{
      
        ApprovalProgressViewController *appVc = [[ApprovalProgressViewController alloc]init];
        
        [self.navigationController pushViewController:appVc animated:YES];

        
    }
    
}

//替换信息是否完善视图
-(void)replaceTopModel:(NSInteger )index name:(NSString *)string{
    
    PeosonInfoType *type = [[PeosonInfoType alloc]init];
    
    type.isFinish = YES;
    
    type.title = string;
    
    NSArray *array = @[type];
    
    [_modelArray replaceObjectAtIndex:index withObject:array];
 
    
}

@end
