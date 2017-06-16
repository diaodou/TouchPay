
//
//  ShowPersonInfoViewController.m
//  HaiFu
//
//  Created by 史长硕 on 17/2/8.
//  Copyright © 2017年 百思为科. All rights reserved.
//

#import "HCShowPersonInfoViewController.h"
#import "HCMacro.h"
#import "PeosonInfoType.h"
#import "PersonInfoModel.h"
#import "CustomButton.h"
#import "InputTextTableViewCell.h"
#import "DefineSystemTool.h"
#import "SearchCityOrCode.h"
#import <MBProgressHUD.h>
#import "NSString+CheckConvert.h"
//#import "SCCaptureCameraController.h"
#import "RMUniversalAlert.h"
#import "UIFont+AppFont.h"
#import "TopSelectView.h"
#import "ImageTableViewCell.h"
#import "LMSTakePhotoController.h"
#import "AppDelegate.h"
#import "JKImagePickerController.h"
#import "BSVKHttpClient.h"
#import "SelectNameModel.h"
#import "UserSettingModel.h"
#import "PortraitImageModel.h"
#import "ReadManager.h"
#import "AddressFailsViewController.h"
#import "ContactRootViewController.h"
#import "HCRootNavController.h"
#import "CheckMsgModel.h"
#import "CompileImageViewController.h"
#import "StatusProvingView.h"
#import <AVFoundation/AVCaptureDevice.h>
#import <AVFoundation/AVMediaFormat.h>
#import <ContactsUI/ContactsUI.h>
#import <Contacts/Contacts.h>
#import "PostSuccessModel.h"
#import "UIColor+DefineNew.h"
static CGFloat const SaveOneImage = 110;
static CGFloat const getSelectImage = 160;
static CGFloat const ReloadImage = 120;
static CGFloat const SaveMuchImage = 130;
static CGFloat const SavePeopleInfo = 150;
static CGFloat const GetPeopleInfo = 140;
static CGFloat const SaveContactInfo = 180;
static CGFloat const GetImageInfo = 170;
static CGFloat const SaveScanInfo = 190;
static CGFloat const SaveFinishInfo = 200;
static CGFloat const SendSacnImage = 210;
static CGFloat const SendSacnTwoImage = 220;
@interface HCShowPersonInfoViewController ()<UITableViewDelegate,UITableViewDataSource,UIPickerViewDelegate,UIPickerViewDataSource,SendSelectDelegate,SendTextDelegate,BSVKHttpClientDelegate,UITextFieldDelegate,LMSTakePhotoControllerDelegate,JKImagePickerControllerDelegate,SendPhoneNumDelegate,SendImageDelegate,SendStatusOpenDelegate>

{
    
    UITableView *_showInfoTable;//主体展示信息表视图
    
    NSArray *_nameArray;//名称数组
    
    ShowPickViewType _typePicker;      //当前选择器的类型
    
    UIView *_headerView;//头部视图
    
    NSMutableArray *_dataArray;//数据数组
    
    NSMutableArray *_infoTypeArray;//保存信息数组
    
    NSString *_nowSelectNum;//当前点击的位置
    
    PersonInfoModel *_personInfo;//数据源类
    
    //    SCCaptureCameraController *_sccap;
    
    NSString *strProvinceNameTemp;
    
    UIPickerView *_selectPickerView;//选择视图
    
    NSIndexPath *_nowIndexPath;//当前点击的单元格位置
    
    ShowPickViewType _nowSelectType;//当前选择器的类型
    
    SearchCityOrCode *_search;//城市搜索
    
    GoodTextField *_nowTextField;//当前正在编辑的输入
    
    TopSelectView *_topSelectView;//选择器上方的按钮视图
    
    NSMutableArray *_selectArray;//选择器数组
    
    NSMutableArray *_imageArray;//盛放照片的数组
    
    UIView *_footView;//足部视图
    
    NSMutableArray *_selectNameArray;//影像二级小类数组
    
    NSMutableDictionary *_saveContactDic;//保存联系人数据
    
    NSInteger _nowSelectSection;//当前选择头部视图
    
    NSString *_type;//
    
    StatusProvingView *_statusView;//身份验证视图
    
    TouchType _provingType;
    
    UIView *_pickerBackView;
    
    UIPickerView *_pickerViw;
    
    NSString *_stringType;//婚姻状况类型
    
    float _statusHeight;
    
    BOOL _hasGetInfo;//请求个人信息是否成功
    
    BOOL _hasGetImage;//请求影像数据是否成功
    
    BOOL _finishLeftImage;//判断身份证正面照片是否已完成
    
    BOOL _finishRightImage;
    
    float x;
    
    NSMutableDictionary *_scanParmDic;//扫描之后的证件信息
    
    NSString *_showCertString;//
    
}

@property (nonatomic,strong) NSMutableArray <NSArray *>*pickDataArr;//选择器的数据源

@property(nonatomic,strong)UITableView *selectTable;//可选影像名称列表

@property(nonatomic,strong)CheckMsgList *nowSelectBody;//当前选中的图像数据

@property(nonatomic,copy)NSString *selectName;//上传多张图片时需要记住的影像类型名称

@property(nonatomic,strong)UIView *ligthView;//灰色视图

@property(nonatomic,copy) NSString *cardIdSring;//保存选中

@property(nonatomic,strong)MBProgressHUD *hud;

@property(nonatomic,assign)NSInteger saveMuchNum;

@property(nonatomic,strong)NSMutableArray *saveDataArray;//存放照片数组

@property(nonatomic,strong)NSMutableArray *saveInfoArray;//用于盛放多张影像的数据
@property(nonatomic,copy) NSString *selectString;//选择照片的名称

@property(nonatomic,assign) NSInteger nowCount;

@property(nonatomic,assign)NSInteger warnCount;//提示通讯录权限次数

@end

@implementation HCShowPersonInfoViewController

#pragma mark --> life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // self.navigationItem.title = @"个人信息";
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets =NO;
    if (iphone6P) {
        x = scale6PAdapter;
        
    }else{
        
        x = scaleAdapter;
    }
    
    [self creatDataArray];
    [self creatTopView];
    [self creatFootView];
    [self creatShowInfoTable];
    [self creatSelectPickerView];
    [self buildGetPersonInfo];
    [self buildGetMustSendImage];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(sendPhoneNumBack) name:@"canWrite" object:nil];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [[UIApplication sharedApplication]setStatusBarHidden:NO];
    
    //[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackTranslucent animated:YES];
    
}

-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    
}

-(MBProgressHUD *)hud{
    
    if (!_hud) {
        
        _hud = [[MBProgressHUD alloc]initWithView:self.view];
        
        
    }
    
    [self.view bringSubviewToFront:_hud];
    
    [self.view addSubview:_hud];
    
    return _hud;
}

-(UITableView *)selectTable{
    
    if (!_selectTable) {
        
        _selectTable = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        
        _selectTable.dataSource = self;
        
        _selectTable.delegate = self;
        
        _selectTable.tag = 250;
        
        _selectTable.scrollEnabled = NO;
        
        _selectTable.showsVerticalScrollIndicator = NO;
        
        _selectTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        _selectTable.backgroundColor = [UIColor UIColorWithHexColorString:@"0xf6f6f6" AndAlpha:1.0];
        
        [self.view addSubview:_selectTable];
        
    }
    
    return _selectTable;
}

//创建可选影像名称列表


-(UIView *)ligthView{
    
    if (!_ligthView) {
        
        _ligthView = [[UIView alloc]initWithFrame:CGRectMake(0, 0,DeviceWidth , DeviceHeight)];
        
        _ligthView.backgroundColor  = [UIColor UIColorWithHexColorString:@"0x7f7f7f" AndAlpha:0.8];
        
        _ligthView.hidden = YES;
        
        [self.view addSubview:_ligthView];
        
    }
    
    return _ligthView;
    
}

#pragma mark --> private Methods

-(void)creatTopView{
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 97*x, DeviceWidth, 10*x)];
    
    view.backgroundColor = UIColorFromRGB(0xeeeeee, 1.0);
    
    [self.view addSubview:view];
    
}

//创建基本数据
-(void)creatDataArray{
    
    _nameArray = [NSArray arrayWithObjects:@"单位信息",@"个人信息",@"联系人",@"必传影像", nil];
    
    _infoTypeArray = [[NSMutableArray alloc]init];
    
    for (NSString *jack in _nameArray) {
        
        PeosonInfoType *type = [[PeosonInfoType alloc]init];
        
        type.isOpen = NO;
        
        type.isFinish = NO;
        
        type.showType = jack;
        
        [_infoTypeArray addObject:type];
        
    }
    
    _imageArray = [[NSMutableArray alloc]init];
    
}

//创建表视图
-(void)creatShowInfoTable{
    
    
    _showInfoTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 107*x, DeviceWidth, DeviceHeight-64-97*x) style:UITableViewStyleGrouped];
    
    _showInfoTable.dataSource = self;
    
    _showInfoTable.delegate = self;
    
    _showInfoTable.tableFooterView = _footView;
    
    _showInfoTable.showsVerticalScrollIndicator = NO;
    
    _showInfoTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.view addSubview:_showInfoTable];
    
}

//创建头部视图
-(void)creatHeaderView{
    
    _scanParmDic = [[NSMutableDictionary alloc]init];
    
    _statusView = [[StatusProvingView alloc]initWithFrame:CGRectMake(0, 0, DeviceWidth, 50)];
    
    [_statusView creatHeaderView];
    
    _statusView.delegate = self;
    
}

//创建足部视图
-(void)creatFootView{
    
    _footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DeviceWidth, 105*x)];
    
    _footView.backgroundColor = [UIColor clearColor];
    
    UIButton *_nextBtn = [[UIButton alloc]initWithFrame:CGRectMake(47*x, 48*x, DeviceWidth-94*x, 50*x)];
    
    [_nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
    
    _nextBtn.backgroundColor = [UIColor UIColorWithHexColorString:@"0x32beff" AndAlpha:1.0];
    
    _nextBtn.layer.cornerRadius = 25.0;
    
    _nextBtn.titleLabel.font = [UIFont appFontRegularOfSize:14];
    
    [_nextBtn addTarget:self action:@selector(buildNextAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [_footView addSubview:_nextBtn];
    
    
}


//创建选择器视图
-(void)creatSelectPickerView{
    
    
    _search = [[SearchCityOrCode alloc]init];
    
    _selectPickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, DeviceHeight-64-200*x, DeviceWidth, 200*x)];
    
    _selectPickerView.backgroundColor = [UIColor UIColorWithRed:243 green:243 blue:243 alpha:1.0];
    
    _selectPickerView.dataSource = self;
    
    _selectPickerView.delegate = self;
    
    _selectPickerView.hidden = YES;
    
    [self.view addSubview:_selectPickerView];
    
    _topSelectView = [[TopSelectView alloc]initWithFrame:CGRectMake(0, 0, DeviceWidth, DeviceHeight-64-200*x)];
    
    _topSelectView.hidden = YES;
    
    _topSelectView.delegate = self;
    
    [self.view addSubview:_topSelectView];
    
}


#pragma mark --> event Response

//对表视图点击进行细化处理
-(void)buildToSelectPicker:(TypeClass *)type{
    
    if ([type.title isEqualToString:@"联系电话"]) {
        
        [self buildHandleContactPath:_nowIndexPath];
        
    }else{
        
        if (_delegate && [_delegate respondsToSelector:@selector(sendViewShow:)]) {
            
            [_delegate sendViewShow:YES];
            
        }
        
        _selectPickerView.hidden = NO;
        
        _topSelectView.hidden = NO;
        
        if (!_selectArray) {
            
            _selectArray = [NSMutableArray arrayWithArray:type.showArray];
            
        }else{
            
            [_selectArray removeAllObjects];
            
            [_selectArray addObjectsFromArray:type.showArray];
            
        }
        
        _nowSelectType = type.showType;
        
        [_selectPickerView reloadAllComponents];
        
        if (_selectArray.count == 3) {
            
            [_selectPickerView selectRow:0 inComponent:0 animated:NO];
            
            [_selectPickerView selectRow:0 inComponent:1 animated:NO];
            
            [_selectPickerView selectRow:0 inComponent:2 animated:NO];
            
        }else{
            
            [_selectPickerView selectRow:0 inComponent:0 animated:NO];
            
        }
        
        
        
        
        
    }
    
    
}

//点击组头所调用的方法
-(void)buildSelectItem:(UIButton *)sender{
    
    if (sender.tag == 3) {
        
        if (_hasGetImage) {
            
            PeosonInfoType *type = _infoTypeArray[sender.tag];
            
            BOOL judge = type.isOpen;
            
            for (int i =0; i<_infoTypeArray.count; i++) {
                
                PeosonInfoType *info = _infoTypeArray[i];
                
                info.isOpen = NO;
                
                [_infoTypeArray replaceObjectAtIndex:i withObject:info];
                
            }
            
            type.isOpen = !judge;
            
            [_infoTypeArray replaceObjectAtIndex:sender.tag withObject:type];
            
            if (_statusView.frame.size.height != 50 && _statusView) {
                
                _statusView.frame = CGRectMake(0, 0, DeviceWidth, 50);
                
                _showInfoTable.tableHeaderView = nil;
                
                _showInfoTable.tableHeaderView = _statusView;
                
                _statusView.arrowImage.image = [UIImage imageNamed:@"箭头_下"];
                
                _statusView.button.selected = !_statusView.button.selected;
                
                _statusView.baseView.hidden = YES;
                
            }
            
            
            [_showInfoTable reloadData];
            
        }else{
            
            _nowSelectSection = sender.tag;
            
            _type = @"单元格";
            
            [self buildGetMustSendImage];
            
        }
        
        
    }else{
        
        _hasGetInfo = YES;
        
        if (_hasGetInfo) {
            
            PeosonInfoType *type = _infoTypeArray[sender.tag];
            
            BOOL judge = type.isOpen;
            
            for (int i =0; i<_infoTypeArray.count; i++) {
                
                PeosonInfoType *info = _infoTypeArray[i];
                
                info.isOpen = NO;
                
                [_infoTypeArray replaceObjectAtIndex:i withObject:info];
                
            }
            
            if (_statusView.frame.size.height != 50 && _statusView) {
                
                _statusView.frame = CGRectMake(0, 0, DeviceWidth, 50);
                
                _showInfoTable.tableHeaderView = nil;
                
                _showInfoTable.tableHeaderView = _statusView;
                
                _statusView.arrowImage.image = [UIImage imageNamed:@"箭头_下"];
                
                _statusView.button.selected = !_statusView.button.selected;
                
                _statusView.baseView.hidden = YES;
                
            }
            
            type.isOpen = !judge;
            
            [_infoTypeArray replaceObjectAtIndex:sender.tag withObject:type];
            
            [_showInfoTable reloadData];
            
        }else{
            
            _nowSelectSection = sender.tag;
            
            _type = @"单元格";
            
            [self buildGetPersonInfo];
            
        }
        
        
    }
    
    
}

//点击下一步所调用的方法
-(void)buildNextAction:(UIButton *)sender{
    
    if (_delegate && [_delegate respondsToSelector:@selector(sendSaveInfoViewType:)]) {
        
        [_delegate sendSaveInfoViewType:ShowPersonType];
        
    }
    
    return;
    
    if (!_hasGetImage) {
        
        [self buildGetMustSendImage];
        
        return;
        
    }
    
    if ([self buildJudgeCertInfo]) {
        
        BOOL isjudgeImage = YES;
        
        if (_nowTextField) {
            
            [self sendText:_nowTextField.text index:_nowIndexPath];
            
        }
        
        for (NSArray *array in _imageArray) {
            
            for (NSMutableDictionary *dic in array) {
                
                if (dic.count < 2) {
                    
                    isjudgeImage = NO;
                    
                    break;
                    
                }
                
            }
            
        }
        
        if ([[_personInfo strInfoJudge]isEqualToString:@"sucess"]) {
            
            if (isjudgeImage) {
                
                NSString *string;
                
                if ([AppDelegate delegate].userInfo.busFlowName == PersonalCenter || [AppDelegate delegate].userInfo.busFlowName == QuotaApply || [AppDelegate delegate].userInfo.busFlowName == QuotaReturned) {
                    
                    string = [AppDelegate delegate].userInfo.realTel;
                    
                }else{
                    
                    string = [AppDelegate delegate].userInfo.userTel;
                }
                
                
                NSArray *array = [_personInfo getDataArray][2];
                
                TypeClass *jack = array[2];
                
                if ([string isEqualToString:jack.result]) {
                    
                    [self buildHeadError:@"联系人手机号不能与申请人手机号一样，请修改"];
                    
                    return;
                    
                }
                
                if ([_stringType isEqualToString:@"已婚"]) {
                    
                    NSArray *array = [_personInfo getDataArray][2];
                    
                    TypeClass *class = array[0];
                    
                    if (![class.result isEqualToString:@"夫妻"]) {
                        
                        [self buildHeadError:@"你已已婚，联系人请选择夫妻"];
                        
                        return;
                        
                    }
                    
                }
                
                if ([_showCertString isEqualToString:@"N"]) {
                    
                    [self buildSendScanImage];
                    
                }else{
                    
                    [self buildSaveInfo];
                    
                }
                
                
                
                
            }else{
                
                [self buildHeadError:@"请完善必传影像信息"];
                
            }
            
            
        }else{
            
            [self buildHeadError:[_personInfo strInfoJudge]];
            
        }
        
        
    }
    
}

//点击图像调用的方法
-(void)buildTouchImageAction:(CustomButton *)sender{
    
    if (sender.imageModel) {
        
        _selectString = sender.nameBody.docDesc;
        
        if ([sender.nameBody.docDesc isEqualToString:@"身份证正面"]||[sender.nameBody.docDesc isEqualToString:@"身份证反面"]) {
            
            _nowSelectBody = sender.nameBody;
            
            _cardIdSring = sender.imageModel.ID;
            
            _selectString = sender.nameBody.docDesc;
            
            if ([sender.nameBody.countMaterial integerValue] > 0) {
                
                [self buildGetSelectImage:sender.nameBody.docCde];
                
            }else{
                
                [self buildCamera];
                
            }
            
            
        }else{
            
            CompileImageViewController *imgVc = [[CompileImageViewController alloc]init];
            
            imgVc.delegate = self;
            
            UpImageTypeBody *type = [[UpImageTypeBody alloc]init];
            
            type.docCde = sender.imageModel.attachType;
            
            type.docDesc = sender.imageModel.attachName;
            
            imgVc.imageType = type;
            
            [self.navigationController pushViewController:imgVc animated:YES];
            
        }
        
    }else{
        
        _nowSelectBody = sender.nameBody;
        
        _selectString = sender.nameBody.docDesc;
        
        if ([sender.nameBody.countMaterial integerValue] > 0) {
            
            [self buildGetSelectImage:sender.nameBody.docCde];
            
        }else{
            
            if ([sender.nameBody.docDesc isEqualToString:@"身份证正面"]||[sender.nameBody.docDesc isEqualToString:@"身份证反面"]) {
                
                [self buildCamera];
                
            }else{
                
                WEAKSELF
                
                [RMUniversalAlert showActionSheetInViewController:self withTitle:@"选择一张照片" message:@"" cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@[@"拍照",@"从相册中选取"] popoverPresentationControllerBlock:^(RMPopoverPresentationController * _Nonnull popover) {
                    popover.sourceView = self.view;
                    popover.sourceRect = self.view.frame;
                    
                } tapBlock:^(RMUniversalAlert * _Nonnull alert, NSInteger buttonIndex) {
                    
                    STRONGSELF
                    
                    if (strongSelf) {
                        
                        if (buttonIndex == 2) {
                            
                            [strongSelf buildCamera];
                            
                        }else if (buttonIndex == 3){
                            
                            [strongSelf buildPhoto];
                            
                        }else{
                            
                            return ;
                        }
                        
                    }
                    
                }];
                
                
            }
            
            
            
            
        }
        
        
    }
    
    
}

//调用拍照功能
-(void)buildCamera{
    
    if (![DefineSystemTool isGetCameraPermission]) {
        
        float sysVer = [[[UIDevice currentDevice] systemVersion] floatValue];
        
        if (sysVer >= 10) {
            
            [RMUniversalAlert showAlertInViewController:self withTitle:@"提示" message:@"未获得相机权限，请前往设置中心开放照片权限" cancelButtonTitle:@"放弃" destructiveButtonTitle:@"设置" otherButtonTitles:nil tapBlock:^(RMUniversalAlert * _Nonnull alert, NSInteger buttonIndex) {
                
                if (buttonIndex == 1) {
                    
                    NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                    if ([[UIApplication sharedApplication] canOpenURL:url]) {
                        [[UIApplication sharedApplication] openURL:url];
                    }
                    
                }else{
                    
                    return ;
                }
                
                
            }];
            
            
        }else{
            
            [RMUniversalAlert showAlertInViewController:self withTitle:@"提示" message:@"未获得相机权限，请前往设置中心开放相机权限" cancelButtonTitle:@"放弃" destructiveButtonTitle:@"设置" otherButtonTitles:nil tapBlock:^(RMUniversalAlert * _Nonnull alert, NSInteger buttonIndex) {
                
                if (buttonIndex == 1) {
                    
                    NSURL *url = [NSURL URLWithString:@"prefs:root=Privacy&path=CAMERA"];
                    
                    if ([[UIApplication sharedApplication]canOpenURL:url]) {
                        
                        [[UIApplication sharedApplication]openURL:url];
                        
                    }
                }else{
                    
                    return ;
                }
                
                
            }];
            
            
        }
        
        
        
    }else{
        
        if ([_selectString isEqualToString:@"身份证正面"]||[_selectString isEqualToString:@"身份证反面"]) {
            
            _provingType = Camera;
            
            [self scanning];
            
        }else{
            
            LMSTakePhotoController *lmsVc =[[LMSTakePhotoController alloc]init];
            
            lmsVc.delegate = self;
            
            [self presentViewController:lmsVc animated:YES completion:nil];
            
        }
        
        
        
        /*
         
         
         */
    }
    
    
}

//调用相册功能
-(void)buildPhoto{
    
    if (![DefineSystemTool isGetPhotoPermission]) {
        
        float sysVer = [[[UIDevice currentDevice] systemVersion] floatValue];
        
        if (sysVer >= 10) {
            
            [RMUniversalAlert showAlertInViewController:self withTitle:@"提示" message:@"未获得照片权限，请前往设置中心开放照片权限" cancelButtonTitle:@"放弃" destructiveButtonTitle:@"设置" otherButtonTitles:nil tapBlock:^(RMUniversalAlert * _Nonnull alert, NSInteger buttonIndex) {
                
                if (buttonIndex == 1) {
                    
                    NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                    if ([[UIApplication sharedApplication] canOpenURL:url]) {
                        [[UIApplication sharedApplication] openURL:url];
                    }
                    
                }else{
                    
                    return ;
                }
                
                
            }];
            
            
        }else{
            
            [RMUniversalAlert showAlertInViewController:self withTitle:@"提示" message:@"未获得照片权限，请前往设置中心开放照片权限" cancelButtonTitle:@"放弃" destructiveButtonTitle:@"设置" otherButtonTitles:nil tapBlock:^(RMUniversalAlert * _Nonnull alert, NSInteger buttonIndex) {
                
                if (buttonIndex == 1) {
                    
                    NSURL *url = [NSURL URLWithString:@"prefs:root=Privacy&path=PHOTOS"];
                    
                    if ([[UIApplication sharedApplication]canOpenURL:url]) {
                        
                        [[UIApplication sharedApplication]openURL:url];
                        
                    }
                }else{
                    
                    return ;
                }
                
                
            }];
            
            
        }
        
        
        
        
    }else{
        
        JKImagePickerController *imagePickerController = [[JKImagePickerController alloc] init];
        imagePickerController.delegate = self;
        imagePickerController.showsCancelButton = YES;
        imagePickerController.allowsMultipleSelection = YES;
        
        imagePickerController.minimumNumberOfSelection = 1;
        
        if ([_selectString isEqualToString:@"身份证正面"]) {
            
            imagePickerController.maximumNumberOfSelection = 1;
            
        }else if ([_selectString isEqualToString:@"身份证反面"]){
            
            imagePickerController.maximumNumberOfSelection = 1;
            
        }else{
            
            imagePickerController.maximumNumberOfSelection = 10;
            
        }
        
        
        imagePickerController.selectedAssetArray = nil;
        
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:imagePickerController];
        navigationController.navigationBar.translucent = NO;
        //改变导航栏背景色f
        [[UINavigationBar appearance] setBarTintColor:[UIColor UIColorWithHexColorString:@"0x32beff" AndAlpha:1.0]];
        [self presentViewController:navigationController animated:YES completion:NULL];
        
        
        
    }
    
}

//刷新影像二级名称小类表视图
-(void)buildFreshTable{
    
    if (_selectNameArray.count > 0) {
        
        NSArray *jack = _selectNameArray[0];
        
        NSInteger rose = jack.count+1;
        
        float height;
        
        if (iphone6P) {
            
            height = 70;
            
        }else{
            
            height = 45;
        }
        
        self.ligthView.frame = CGRectMake(0, 0,DeviceWidth , DeviceHeight-64);
        
        self.selectTable.frame = CGRectMake(0, DeviceHeight-(rose*40)-15-64-height, DeviceWidth, 40*rose+15);
        
        self.ligthView.hidden = NO;
        
        self.selectTable.hidden = NO;
        
        [self.selectTable reloadData];
        
    }else{
        
        self.selectTable.hidden = YES;
        
    }
    
}


//点击二级影像列表
-(void)buildTouchAction:(CustomButton *)sender{
    
    if ([sender.storeName isEqualToString:@"取消"]) {
        
        self.selectTable.hidden = YES;
        
        self.ligthView.hidden = YES;
        
        
    }else{
        
        self.ligthView.hidden = YES;
        
        self.selectTable.hidden = YES;
        
        if ([_selectString isEqualToString:@"身份证正面"]||[_selectString isEqualToString:@"身份证反面"]) {
            
            [self buildCamera];
            
        }else{
            
            WEAKSELF
            
            [RMUniversalAlert showActionSheetInViewController:self withTitle:@"选择一张照片" message:@"" cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@[@"拍照",@"从相册中选取"] popoverPresentationControllerBlock:^(RMPopoverPresentationController * _Nonnull popover) {
                
            } tapBlock:^(RMUniversalAlert * _Nonnull alert, NSInteger buttonIndex) {
                
                STRONGSELF
                
                if (strongSelf) {
                    
                    if (buttonIndex == 2) {
                        
                        [strongSelf buildCamera];
                        
                    }else if (buttonIndex == 3){
                        
                        [strongSelf buildPhoto];
                        
                    }else{
                        
                        return ;
                    }
                    
                }
                
            }];
            
            
        }
        
        
        
        
    }
    
}

//刷细当前页面所有影像信息
-(void)buildReloadImage{
    
    BSVKHttpClient *client = [BSVKHttpClient shareInstance];
    
    client.delegate = self;
    
    AppDelegate *dele = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    NSMutableDictionary *parm = [[NSMutableDictionary alloc]init];
    
    [self.hud showAnimated:YES];
    
    if (dele.userInfo.custNum && dele.userInfo.custNum.length > 0) {
        
        [parm setObject:dele.userInfo.custNum forKey:@"custNo"];
        
    }
    
    [client getInfo:@"app/appserver/attachSearchPerson" requestArgument:parm requestTag:ReloadImage requestClass:NSStringFromClass([self class])];
}

//处理联系人电话逻辑
-(void)buildHandleContactPath:(NSIndexPath *)indexPath{
    
    WEAKSELF
    [ReadManager shouquan:^(bool bGrant) {
        
        STRONGSELF
        
        if (strongSelf) {
            
            if (bGrant) {
                
                [strongSelf buildHandleHavePower];
                
            }else {
                
                if ([AppDelegate delegate].userInfo.whiteType == WhiteA) {
                    
                    if (strongSelf.warnCount >= 1) {
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [strongSelf sendPhoneNumBack];
                        });
                        
                        
                    }else{
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [RMUniversalAlert showAlertInViewController:self withTitle:@"提示" message:@"您是否要开启通讯录权限" cancelButtonTitle:@"取消" destructiveButtonTitle:@"确定" otherButtonTitles:nil tapBlock:^(RMUniversalAlert * _Nonnull alert, NSInteger buttonIndex) {
                                if (strongSelf) {
                                    
                                    if (buttonIndex == 1) {
                                        
                                        [strongSelf showSettingContactCont];
                                        
                                    }else{
                                        
                                        [strongSelf sendPhoneNumBack];
                                        
                                    }
                                }
                            }];
                            
                        });
                        
                    }
                    
                    strongSelf.warnCount++;
                    
                }else{
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [RMUniversalAlert showAlertInViewController:self withTitle:@"提示" message:@"请允许访问您的通讯录，否则会影响您的后续操作" cancelButtonTitle:@"取消" destructiveButtonTitle:@"确定" otherButtonTitles:nil tapBlock:^(RMUniversalAlert * _Nonnull alert, NSInteger buttonIndex) {
                            if (strongSelf) {
                                
                                if (buttonIndex == 1) {
                                    
                                    [strongSelf showSettingContactCont];
                                    
                                }
                            }
                        }];
                        
                    });
                    
                    
                }
                
            }
            
        }
    }];
    
    
    
}

//获取通讯录权限后的处理
-(void)buildHandleHavePower{
    
    if (IOS9_OR_LATER) {
        
        // 3.1.创建联系人仓库
        CNContactStore *store = [[CNContactStore alloc] init];
        // keys决定这次要获取哪些信息,比如姓名/电话
        NSArray *fetchKeys = @[CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey];
        CNContactFetchRequest *request = [[CNContactFetchRequest alloc] initWithKeysToFetch:fetchKeys];
        
        NSError *error = nil;
        
        NSMutableArray *array = [[NSMutableArray alloc]init];
        
        [store enumerateContactsWithFetchRequest:request error:&error usingBlock:^(CNContact * _Nonnull contact, BOOL * _Nonnull stop) {
            // stop是决定是否要停止
            // 1.获取姓名
            
            AddressBook* addressBook = [[AddressBook alloc]init];
            NSString *firstname = contact.givenName;
            NSString *lastname = contact.familyName;
            addressBook.fullName = [NSString stringWithFormat:@"%@%@",lastname,firstname];
            
            // 2.获取电话号码
            NSArray *phones = contact.phoneNumbers;
            
            NSMutableArray *jack = [[NSMutableArray alloc]init];
            
            // 3.遍历电话号码
            for (CNLabeledValue *labelValue in phones) {
                PhoneModel *model = [[PhoneModel alloc]init];
                
                NSString *test = [CNLabeledValue localizedStringForLabel:labelValue.label];
                model.telName =test;
                CNPhoneNumber *phoneNumber = labelValue.value;
                model.telNo = phoneNumber.stringValue;
                
                [jack addObject:model];
            }
            
            addressBook.phone = [NSArray arrayWithArray:jack];
            
            [array addObject:addressBook];
            
        }];
        
        int judget = 0;
        
        if ([AppDelegate delegate].userInfo.whiteType == WhiteB)
        {
            judget = 3;
            
        }
        else if ([AppDelegate delegate].userInfo.whiteType == WhiteSocityReason || [AppDelegate delegate].userInfo.whiteType == WhiteSocityNoReason)
        {
            judget = 10;
        }
        else if ([AppDelegate delegate].userInfo.whiteType == WhiteCReason || [AppDelegate delegate].userInfo.whiteType == WhiteCNoReason)
        {
            judget = 20;
        }
        else
        {
            judget = 0;
        }
        
        
        if (array.count >= judget) {
            
            
            ContactRootViewController *rootVc = [[ContactRootViewController alloc]init];
            
            rootVc.newaArray = array;
            
            rootVc.delegate = self;
            
            HCRootNavController *cust = [[HCRootNavController alloc]initWithRootViewController:rootVc];
            
            rootVc.kiss = 2;
            
            [self presentViewController:cust animated:YES completion:nil];
            
        }else{
            
            [self buildHeadError:@"您暂不符合业务准入标准，请稍后进行申请"];
            
            
        }
        
        
        return;
        
    }
    
    
    if ([ReadManager readUserPhoneAddress]) {
        
        NSMutableArray *array = [[NSMutableArray alloc]init];
        
        [array addObjectsFromArray:[ReadManager readUserPhoneAddress]];
        
        int judget = 0;
        
        if ([AppDelegate delegate].userInfo.whiteType == WhiteB)
        {
            judget = 3;
            
        }
        else if ([AppDelegate delegate].userInfo.whiteType == WhiteSocityReason || [AppDelegate delegate].userInfo.whiteType == WhiteSocityNoReason)
        {
            judget = 10;
        }else if ([AppDelegate delegate].userInfo.whiteType == WhiteCReason || [AppDelegate delegate].userInfo.whiteType == WhiteCNoReason){
            
            judget = 20;
            
        }else
        {
            judget = 0;
        }
        
        if (array.count >= judget) {
            
            ContactRootViewController *rootVc = [[ContactRootViewController alloc]init];
            
            rootVc.newaArray = array;
            
            rootVc.delegate = self;
            
            HCRootNavController *cust = [[HCRootNavController alloc]initWithRootViewController:rootVc];
            
            rootVc.kiss = 2;
            
            [self presentViewController:cust animated:YES completion:nil];
            
            
        }else{
            
            [self buildHeadError:@"您暂不符合业务准入标准，请稍后进行申请"];
            
        }
        
    }
    
}

//不给予联系人权限后跳转的页面
- (void)showSettingContactCont {
    
    AddressFailsViewController *addrVc =[[AddressFailsViewController alloc]init];
    
    addrVc.title = @"联系人";
    //取出根视图控制器
    HCRootNavController *nav = [[HCRootNavController alloc] initWithRootViewController:addrVc];
    
    [self presentViewController:nav animated:YES completion:nil];
}

//电话格式
-(NSString *)SeparatedByString:(NSMutableString*)string{
    
    for (int i = 0; i < string.length; i ++) {
        
        NSString *s = [string substringWithRange:NSMakeRange(i, 1)];
        if ([s isEqualToString:@"-"]) {
            
            [string deleteCharactersInRange:NSMakeRange(i, 1)];
            
        }
        
    }
    
    NSMutableString *stringTemp = string;
    
    NSString *jack = [stringTemp substringToIndex:3];
    
    if ([jack isEqualToString:@"+86"]) {
        
        NSRange rangeOne = [stringTemp rangeOfString:@"1"];
        if (rangeOne.location != NSNotFound) {
            [stringTemp deleteCharactersInRange:NSMakeRange(0, rangeOne.location)];
        }
    }
    
    
    NSString *kill = [NSString stringWithString:stringTemp];
    
    return kill;
}
// 扫描
- (void)scanning{
    
    if ([self isCameraAvailable] && [self doesCameraSupportTakingPhotos]&&[self isCamareAuthorization]) {
        //        _sccap = [[SCCaptureCameraController alloc] init];
        //        _sccap.scNaigationDelegate = self;
        //        _sccap.iCardType = TIDCARD2;
        //        _sccap.isDisPlayTxt = YES;
        //       // CustomNavigationController *custNav = [[CustomNavigationController alloc]initWithRootViewController:_sccap];
        //        [self presentViewController:_sccap animated:YES completion:NULL];
    }else{
        WEAKSELF
        [RMUniversalAlert showAlertInViewController:self withTitle:@"提示" message:@"你还未开启相机权限，请前往设置中心开启" cancelButtonTitle:@"取消" destructiveButtonTitle:@"设置" otherButtonTitles:nil tapBlock:^(RMUniversalAlert * _Nonnull alert, NSInteger buttonIndex) {
            STRONGSELF
            if (strongSelf) {
                if (buttonIndex == 1) {
                    
                    [strongSelf toCamera];
                }
            }
        }];
    }
    
    
}

//判断身份验证信息是否完善
-(BOOL)buildJudgeCertInfo{
    
    if (![_showCertString isEqualToString:@"N"]) {
        
        return YES;
        
    }else if(!_statusView.leftimage.image) {
        
        [self buildHeadError:@"请上传身份验证的身份证正面照片"];
        
        return NO;
        
    }else if (!_statusView.rightImage.image){
        
        [self buildHeadError:@"请上传身份验证的身份证反面照片"];
        
        return NO;
        
    }else if (_statusView.genderLabel.text.length == 0 || !_statusView.genderLabel.text){
        
        [self buildHeadError:@"请选择身份验证的性别"];
        
        return NO;
        
    }else if (_statusView.birthLabel.text.length == 0 || !_statusView.birthLabel.text){
        
        [self buildHeadError:@"请上传身份验证的出生年月"];
        
        return NO;
        
    }else if (_statusView.addressText.text.length == 0 || !_statusView.addressText.text){
        
        [self buildHeadError:@"请输入身份验证的家庭住址"];
        
        return NO;
        
    }else if (_statusView.officeText.text.length == 0 || !_statusView.officeText.text){
        
        [self buildHeadError:@"请输入身份验证的签发机关"];
        
        return NO;
        
    }else if (_statusView.validLabel.text.length == 0 || !_statusView.validLabel.text){
        
        [self buildHeadError:@"请选择身份验证的有效期"];
        
        return NO;
        
    }else{
        
        return YES;
    }
    
}


#pragma mark --> 发起的网络请求



//请求必传影像信息
-(void)buildGetMustSendImage{
    
    if (_checkMsgModel) {
        
        [self buildHandleGetImage:_checkMsgModel];
        
    }else{
        
        BSVKHttpClient *client = [BSVKHttpClient shareInstance];
        
        client.delegate = self;
        
        [self.hud showAnimated:YES];
        
        NSMutableDictionary *parm = [[NSMutableDictionary alloc]init];
        
        if ([AppDelegate delegate].userInfo.custNum.length > 0) {
            
            [parm setObject:[AppDelegate delegate].userInfo.custNum forKey:@"custNo"];
            
        }
        
        if ([AppDelegate delegate].userInfo.realName.length > 0) {
            
            [parm setObject:[AppDelegate delegate].userInfo.realName forKey:@"custName"];
            
        }
        
        if ([AppDelegate delegate].userInfo.userId.length > 0) {
            
            [parm setObject:[AppDelegate delegate].userInfo.userId forKey:@"userId"];
            
        }
        
        if ([AppDelegate delegate].userInfo.realId.length > 0) {
            
            [parm setObject:[AppDelegate delegate].userInfo.realId forKey:@"idNo"];
            
        }

        if ([AppDelegate delegate].userInfo.busFlowName == CashLoanCreate || [AppDelegate delegate].userInfo.busFlowName == CashLoanWait|| [AppDelegate delegate].userInfo.busFlowName == CashLoanReturned){
        
                    [parm setObject:[AppDelegate delegate].userInfo.orderNo forKey:@"orderNo"];
            
                    [parm setObject:@"Y" forKey:@"isOrder"];
            
                    [parm setObject:[AppDelegate delegate].userInfo.applSeq forKey:@"applSeq"];
            
            if (_typCde.length > 0 && _typCde) {
                
                 [parm setObject:_typCde forKey:@"typCde"];
                
            }
            
            
        
                    if ([AppDelegate delegate].userInfo.whiteType == WhiteA) {
        
                        [client postInfo:@"app/appserver/A/XJD/checkIfMsgComplete" requestArgument:parm requestTag:GetImageInfo requestClass:NSStringFromClass([self class])];
        
                    }else if ([AppDelegate delegate].userInfo.whiteType == WhiteB){
        
                        [client postInfo:@"app/appserver/B/XJD/checkIfMsgComplete" requestArgument:parm requestTag:GetImageInfo requestClass:NSStringFromClass([self class])];
        
                    }else if ([AppDelegate delegate].userInfo.whiteType == WhiteCReason ||[AppDelegate delegate].userInfo.whiteType == WhiteCNoReason){
        
                        [client postInfo:@"app/appserver/C/XJD/checkIfMsgComplete" requestArgument:parm requestTag:GetImageInfo requestClass:NSStringFromClass([self class])];
        
                    }else{
        
                        [client postInfo:@"app/appserver/SHH/XJD/checkIfMsgComplete" requestArgument:parm requestTag:GetImageInfo requestClass:NSStringFromClass([self class])];
                    }
        
        
                }else if ([AppDelegate delegate].userInfo.busFlowName == GoodsLoanCreate || [AppDelegate delegate].userInfo.busFlowName == GoodsLoanWait || [AppDelegate delegate].userInfo.busFlowName == GoodsReturnedByCredit || [AppDelegate delegate].userInfo.busFlowName == GoodsReturnedByMerchant ){
        
                    [parm setObject:[AppDelegate delegate].userInfo.orderNo forKey:@"orderNo"];
                    
                    [parm setObject:@"Y" forKey:@"isOrder"];
                    
                    [parm setObject:[AppDelegate delegate].userInfo.applSeq forKey:@"applSeq"];
                    if (_typCde.length > 0 && _typCde) {
                        
                        [parm setObject:_typCde forKey:@"typCde"];
                        
                    }
                    
                   
        
                    if ([AppDelegate delegate].userInfo.whiteType == WhiteA) {
        
                        [client postInfo:@"app/appserver/A/SPFQ/checkIfMsgComplete" requestArgument:parm requestTag:GetImageInfo requestClass:NSStringFromClass([self class])];
        
                    }else if ([AppDelegate delegate].userInfo.whiteType == WhiteB){
        
                        [client postInfo:@"app/appserver/B/SPFQ/checkIfMsgComplete" requestArgument:parm requestTag:GetImageInfo requestClass:NSStringFromClass([self class])];
        
                    }else if ([AppDelegate delegate].userInfo.whiteType == WhiteCReason ||[AppDelegate delegate].userInfo.whiteType == WhiteCNoReason){
        
                        [client postInfo:@"app/appserver/C/SPFQ/checkIfMsgComplete" requestArgument:parm requestTag:GetImageInfo requestClass:NSStringFromClass([self class])];
        
                    }else{
        
                        [client postInfo:@"app/appserver/SHH/SPFQ/checkIfMsgComplete" requestArgument:parm requestTag:GetImageInfo requestClass:NSStringFromClass([self class])];
                    }
        
        
                }else if ([AppDelegate delegate].userInfo.busFlowName == QuotaApply || [AppDelegate delegate].userInfo.busFlowName == QuotaReturned){
        
                    if ([AppDelegate delegate].userInfo.busFlowName == QuotaReturned) {
        
                        [parm setObject:StringOrNull([AppDelegate delegate].userInfo.applSeq) forKey:@"applSeq"];
        
                    }
        
                    [parm setObject:@"N" forKey:@"isOrder"];
        
                    if ([AppDelegate delegate].userInfo.whiteType == WhiteA) {
        
                        [client postInfo:@"app/appserver/A/EDJH/checkIfMsgComplete" requestArgument:parm requestTag:GetImageInfo requestClass:NSStringFromClass([self class])];
        
                    }else if ([AppDelegate delegate].userInfo.whiteType == WhiteB){
        
                        [client postInfo:@"app/appserver/B/EDJH/checkIfMsgComplete" requestArgument:parm requestTag:GetImageInfo requestClass:NSStringFromClass([self class])];
        
                    }else if ([AppDelegate delegate].userInfo.whiteType == WhiteCReason ||[AppDelegate delegate].userInfo.whiteType == WhiteCNoReason){
        
                        [client postInfo:@"app/appserver/C/EDJH/checkIfMsgComplete" requestArgument:parm requestTag:GetImageInfo requestClass:NSStringFromClass([self class])];
        
                    }else{
        
                        [client postInfo:@"app/appserver/SHH/EDJH/checkIfMsgComplete" requestArgument:parm requestTag:GetImageInfo requestClass:NSStringFromClass([self class])];
                    }
        
        
                }
        
        
        
    }
    
    
    
}

//请求个人信息
-(void)buildGetPersonInfo{
    
    NSMutableDictionary *parm = [[NSMutableDictionary alloc]init];
    
    if ([AppDelegate delegate].userInfo.custNum.length > 0 && [AppDelegate delegate].userInfo.custNum) {
        [parm setObject:[AppDelegate delegate].userInfo.custNum forKey:@"custNo"];
    }
    
    [parm setObject:@"Y" forKey:@"flag"];
    
    BSVKHttpClient *client = [BSVKHttpClient shareInstance];
    
    client.delegate = self;
    
    [self.hud showAnimated:YES];
    
    [client getInfo:@"app/appserver/getAllCustExtInfo" requestArgument:parm requestTag:GetPeopleInfo requestClass:NSStringFromClass([self class])];
    
}

//请求影像二级小类
-(void)buildGetSelectImage:(NSString *)docCde{
    
    NSMutableDictionary *parm = [[NSMutableDictionary alloc]init];
    
    if (_typCde && _typCde.length > 0) {
        
        [parm setObject:_typCde forKey:@"typCde"];
        
    }
    
    if (docCde && docCde.length > 0) {
        
        [parm setObject:docCde forKey:@"docCde"];
        
    }
    
    BSVKHttpClient *client = [BSVKHttpClient shareInstance];
    
    client.delegate = self;
    
    [self.hud showAnimated:YES];
    
    [client getInfo:@"app/appserver/cmis/typImagesList" requestArgument:parm requestTag:getSelectImage requestClass:NSStringFromClass([self class])];
    
}

//保存联系人信息
-(void)buildSaveContactInfo{
    
    NSMutableDictionary *parm = [[NSMutableDictionary alloc]init];
    
    NSArray *array = [_personInfo getDataArray][2];
    
    for (TypeClass *class in array) {
        
        if (class.code.length > 0) {
            
            [parm setObject:class.code forKey:class.saveHttpKey];
            
        }else if (class.result.length > 0){
            
            [parm setObject:class.result forKey:class.saveHttpKey];
        }
        
        if (class.friendId) {
            
            [parm setObject:class.friendId forKey:@"id"];
            
        }
        
    }
    
    if ([AppDelegate delegate].userInfo.custNum.length > 0 && [AppDelegate delegate].userInfo.custNum) {
        [parm setObject:[AppDelegate delegate].userInfo.custNum forKey:@"custNo"];
    }
    
    BSVKHttpClient *client = [BSVKHttpClient shareInstance];
    
    client.delegate = self;
    
    [self.hud showAnimated:YES];
    
    [client postInfo:@"app/appserver/crm/saveCustFCiCustContact" requestArgument:parm requestTag:SaveContactInfo requestClass:NSStringFromClass([self class])];
}

//发起保存扫描后的身份验证信息
-(void)buildSaveScanInfo{
    
    if ([AppDelegate delegate].userInfo.realId.length > 0 && [AppDelegate delegate].userInfo.realId) {
        
        [_scanParmDic setObject:[AppDelegate delegate].userInfo.realId forKey:@"certNo"];
        
    }
    
    if ([AppDelegate delegate].userInfo.realName.length > 0 && [AppDelegate delegate].userInfo.realName) {
        
        [_scanParmDic setObject:[AppDelegate delegate].userInfo.realName forKey:@"custName"];
        
    }
    
    
    if (![[_scanParmDic objectForKey:@"regAddr"]isEqualToString:_statusView.addressText.text]) {
        
        if (_statusView.addressText.text > 0) {
            
            [_scanParmDic setObject:_statusView.addressText.text forKey:@"afterRegAddr"];
            
        }
        
    }
    
    if (![[_scanParmDic objectForKey:@"gender"]isEqualToString:_statusView.genderLabel.text]) {
        
        if (_statusView.genderLabel.text.length > 0) {
            
            if ([_statusView.genderLabel.text isEqualToString:@"男"]) {
                
                [_scanParmDic setObject:@"10" forKey:@"afterGender"];
                
            }else{
                
                [_scanParmDic setObject:@"20" forKey:@"afterGender"];
                
            }
            
        }
        
    }
    
    
    
    NSString *stringTwo = [_statusView.birthLabel.text buildChangeDay];
    
    
    if (![[_scanParmDic objectForKey:@"birthDt"]isEqualToString:stringTwo]) {
        
        if (stringTwo.length > 0) {
            
            [_scanParmDic setObject:stringTwo forKey:@"afterBirthDt"];
            
        }
    }
    
    if (![[_scanParmDic objectForKey:@"certOrga"]isEqualToString:_statusView.officeText.text]) {
        
        if (_statusView.officeText.text > 0) {
            
            [_scanParmDic setObject:_statusView.officeText.text forKey:@"afterCertOrga"];
            
        }
        
    }
    
    
    NSString *start = [_statusView.validLabel.text buildReplaceCertStartDt];
    
    if (![[_scanParmDic objectForKey:@"certStrDt"]isEqualToString:start]) {
        
        if (start.length > 0) {
            
            [_scanParmDic setObject:start forKey:@"afterCertStrDt"];
            
        }
    }
    
    
    
    NSString *end = [_statusView.validLabel.text buildReplaceCertEndDt];
    
    if (![[_scanParmDic objectForKey:@"certEndDt"]isEqualToString:end]) {
        
        if (end.length > 0) {
            
            [_scanParmDic setObject:end forKey:@"afterCertEndDt"];
            
        }
        
    }
    
    
    BSVKHttpClient *client = [BSVKHttpClient shareInstance];
    
    client.delegate = self;
    
    [self.hud showAnimated:YES];
    
    [client postInfo:@"app/appserver/saveCardMsg" requestArgument:_scanParmDic requestTag:SaveScanInfo requestClass:NSStringFromClass([self class])];
    
    
}

//保存最终确认的身份验证信息
-(void)buildSaveFinishInfo{
    
    NSMutableDictionary *parm = [[NSMutableDictionary alloc]init];
    
    BSVKHttpClient *client = [BSVKHttpClient shareInstance];
    
    client.delegate = self;
    
    [self.hud showAnimated:YES];
    
    
    
    [client postInfo:@"app/appserver/saveCardMsg" requestArgument:parm requestTag:SaveFinishInfo requestClass:NSStringFromClass([self class])];
    
    
}

//上传身份验证正反面图片
-(void)buildSendScanImage{
    
    
    NSMutableDictionary *parm = [[NSMutableDictionary alloc]init];
    
    NSData *data = UIImageJPEGRepresentation(_statusView.leftimage.image, ImageUpZScale);
    
    
    NSString *strm = [DefineSystemTool md5StringWithData:data];
    
    NSString *name = @"DOC53.jpg";
    
    if ([AppDelegate delegate].userInfo.custNum.length > 0 && [AppDelegate delegate].userInfo.custNum) {
        
        [parm setObject:[AppDelegate delegate].userInfo.custNum forKey:@"custNo"];
        
    }
    
    [parm setObject:[AppDelegate delegate].userInfo.realId forKey:@"idNo"];
    
    [parm setObject:@"DOC53" forKey:@"attachType"];
    
    [parm setObject:@"身份证正面" forKey:@"attachName"];
    
    
    if (strm.length > 0 && strm) {
        
        [parm setObject:strm forKey:@"md5"];
        
    }
    
    [parm setObject:@"" forKey:@"commonCustNo"];
    
    BSVKHttpClient *client = [BSVKHttpClient shareInstance];
    
    client.delegate = self;
    
    [self.hud showAnimated:YES];
    
    [client puFile:@"app/appserver/attachUploadPerson" requestArgument:parm fileData:data fileName:name name:@"multipartFile" mimeType:@"image/jpeg" requestTag:SendSacnImage requestClass:NSStringFromClass([self class])];
    
    
}

//上传扫描后的身份证反面照片
-(void)buildSendScanTwoImage{
    
    NSMutableDictionary *parm = [[NSMutableDictionary alloc]init];
    
    NSData *data = UIImageJPEGRepresentation(_statusView.rightImage.image, ImageUpZScale);
    
    NSString *strm = [DefineSystemTool md5StringWithData:data];
    
    NSString *name = @"DOC54.jpg";
    
    if ([AppDelegate delegate].userInfo.custNum.length > 0 && [AppDelegate delegate].userInfo.custNum) {
        
        [parm setObject:[AppDelegate delegate].userInfo.custNum forKey:@"custNo"];
        
    }
    
    [parm setObject:@"DOC54" forKey:@"attachType"];
    
    [parm setObject:@"身份证反面" forKey:@"attachName"];
    
    [parm setObject:[AppDelegate delegate].userInfo.realId forKey:@"idNo"];
    
    if (strm.length > 0 && strm) {
        
        [parm setObject:strm forKey:@"md5"];
        
    }
    
    [parm setObject:@"" forKey:@"commonCustNo"];
    
    BSVKHttpClient *client = [BSVKHttpClient shareInstance];
    
    client.delegate = self;
    
    [self.hud showAnimated:YES];
    
    [client puFile:@"app/appserver/attachUploadPerson" requestArgument:parm fileData:data fileName:name name:@"multipartFile" mimeType:@"image/jpeg" requestTag:SendSacnTwoImage requestClass:NSStringFromClass([self class])];
    
    
}

-(void)buildSaveInfo{
    
    //保存单位，个人，联系人信息
    
    NSMutableDictionary *parm = [[NSMutableDictionary alloc]init];
    
    BSVKHttpClient *cliet = [BSVKHttpClient shareInstance];
    
    cliet.delegate = self;
    
    [self.hud showAnimated:YES];
    
    for (NSArray *array in [_personInfo getDataArray]) {
        
        for (TypeClass *model in array) {
            
            if ([model.title isEqualToString:@"单位地址"]) {
                
                for (NSString *string in [model.CompanyCityDic allKeys]) {
                    
                    if ([model.CompanyCityDic objectForKey:string]) {
                        
                        [parm setObject:[model.CompanyCityDic objectForKey:string] forKey:string];
                    }
                    
                }
                
            }else if ([model.title isEqualToString:@"居住地址"]){
                
                for (NSString *string in [model.PeopleCityDic allKeys]) {
                    
                    if ([model.PeopleCityDic objectForKey:string]) {
                        
                        [parm setObject:[model.PeopleCityDic objectForKey:string] forKey:string];
                    }
                    
                }
                
                
            }else if ([model.title isEqualToString:@"关系"]||[model.title isEqualToString:@"姓名"]||[model.title isEqualToString:@"联系电话"]){
                
                if (model.code.length > 0) {
                    
                    [_saveContactDic setObject:model.code forKey:model.saveHttpKey];
                    
                }else if (model.result.length > 0){
                    
                    [_saveContactDic setObject:model.result forKey:model.saveHttpKey];
                    
                }
                
            }else{
                
                if (model.code.length > 0) {
                    
                    [parm setObject:model.code forKey:model.saveHttpKey];
                    
                }else if (model.result.length > 0){
                    
                    [parm setObject:model.result forKey:model.saveHttpKey];
                    
                }
                
            }
            
        }
        
    }
    
    if ([AppDelegate delegate].userInfo.custNum.length > 0) {
        
        [parm setObject:[AppDelegate delegate].userInfo.custNum forKey:@"custNo"];
        
    }
    
    [parm setObject:@"app_person" forKey:@"dataFrom"];
    
    [cliet postInfo:@"app/appserver/crm/cust/saveAllCustExtInfo" requestArgument:parm requestTag:SavePeopleInfo requestClass:NSStringFromClass([self class])];
    
}

#pragma mark - camer utility
- (BOOL) isCameraAvailable{
    
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
}
- (BOOL) doesCameraSupportTakingPhotos {
    return [self cameraSupportsMedia:(__bridge NSString *)kUTTypeImage sourceType:UIImagePickerControllerSourceTypeCamera];
}
//判断相机的访问权限
- (BOOL)isCamareAuthorization{
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusRestricted || authStatus ==AVAuthorizationStatusDenied)
    {
        return NO;
        
    }else{
        return YES;
    }
}
- (BOOL) canUserPickVideosFromPhotoLibrary{
    return [self
            cameraSupportsMedia:(__bridge NSString *)kUTTypeMovie sourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}
- (BOOL) canUserPickPhotosFromPhotoLibrary{
    return [self
            cameraSupportsMedia:(__bridge NSString *)kUTTypeImage sourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}

- (BOOL) cameraSupportsMedia:(NSString *)paramMediaType sourceType:(UIImagePickerControllerSourceType)paramSourceType{
    __block BOOL result = NO;
    if ([paramMediaType length] == 0) {
        return NO;
    }
    NSArray *availableMediaTypes = [UIImagePickerController availableMediaTypesForSourceType:paramSourceType];
    [availableMediaTypes enumerateObjectsUsingBlock: ^(id obj, NSUInteger idx, BOOL *stop) {
        NSString *mediaType = (NSString *)obj;
        if ([mediaType isEqualToString:paramMediaType]){
            result = YES;
            *stop= YES;
        }
    }];
    return result;
}


- (void)toCamera{
    
    float sysVer = [[[UIDevice currentDevice] systemVersion] floatValue];
    
    if (sysVer >= 10.0) {
        NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        
        if ([[UIApplication sharedApplication] canOpenURL:url]) {
            
            [[UIApplication sharedApplication]openURL:url];
        }
        
    }else{
        
        NSURL *url = [NSURL URLWithString:@"prefs:root=Privacy&path=CAMERA"];
        
        if ([[UIApplication sharedApplication]canOpenURL:url]) {
            
            [[UIApplication sharedApplication]openURL:url];
            
        }
        
    }
}

#pragma mark --> tabelView代理方法

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    if (tableView.tag == 250) {
        
        return _selectNameArray.count;
        
    }else{
        
        return _nameArray.count;
        
    }
    
    
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    
    if (tableView.tag == 250) {
        
        NSArray *array = _selectNameArray[section];
        
        return array.count;
        
    }else{
        
        PeosonInfoType *type = _infoTypeArray[section];
        
        if (!type.isOpen) {
            
            return 0;
            
        }else{
            
            if (section == 3) {
                
                return _imageArray.count;
                
            }else{
                
                if ([_personInfo getDataArray]) {
                    
                    NSArray *array = [_personInfo getDataArray][section];
                    
                    return array.count;
                    
                }else{
                    
                    return 0;
                }
                
            }
            
        }
        
        
    }
    
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView.tag == 250) {
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"kiss"];
        
        if (cell == nil) {
            
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"kiss"];
            
            cell.selectionStyle =  UITableViewCellSelectionStyleNone;
            
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 10, DeviceWidth, 20)];
            
            label.font = [UIFont appFontRegularOfSize:15];
            
            label.tag = 190;
            
            label.textAlignment = NSTextAlignmentCenter;
            
            [cell.contentView addSubview:label];
            
            CustomButton *button = [[CustomButton alloc]initWithFrame:CGRectMake(0, 0, DeviceWidth, 40)];
            
            button.tag = 101;
            
            [button addTarget:self action:@selector(buildTouchAction:) forControlEvents:UIControlEventTouchUpInside];
            
            [cell.contentView addSubview:button];
            
            UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 39, DeviceWidth, 1)];
            lineView.backgroundColor = [UIColor UIColorWithHexColorString:@"0xf6f6f6" AndAlpha:1.0];
            [cell.contentView addSubview:lineView];
            
        }
        
        UILabel *lab = (UILabel *)[cell.contentView viewWithTag:190];
        
        NSArray *array = _selectNameArray[indexPath.section];
        
        SelectNameBody *body = array[indexPath.row];
        
        lab.text = body.docDesc;
        
        CustomButton *btn = (CustomButton*)[cell.contentView viewWithTag:101];
        
        btn.storeName = body.docDesc;
        
        return cell;
        
    }else{
        
        if (indexPath.section == 3) {
            
            ImageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"rose"];
            
            if (cell == nil) {
                
                cell = [[ImageTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"rose"];
                
            }
            
            cell.selectionStyle = UITableViewScrollPositionNone;
            
            [cell insertArray:_imageArray[indexPath.row]];
            
            NSArray *array = _imageArray[indexPath.row];
            
            if (array.count > 1) {
                
                [cell.lefeButton addTarget:self action:@selector(buildTouchImageAction:) forControlEvents:UIControlEventTouchUpInside];
                
                [cell.rightButton addTarget:self action:@selector(buildTouchImageAction:) forControlEvents:UIControlEventTouchUpInside];
                
            }else{
                
                [cell.lefeButton addTarget:self action:@selector(buildTouchImageAction:) forControlEvents:UIControlEventTouchUpInside];
                
            }
            
            return cell;
            
        }else{
            
            InputTextTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"jack"];
            
            if (cell == nil) {
                
                cell = [[InputTextTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"jack"];
                
                cell.contentView.backgroundColor = [UIColor UIColorWithHexColorString:@"0xf6f6f6" AndAlpha:1.0];
                
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                cell.delegate = self;
                
            }
            
            NSArray *array = [_personInfo getDataArray][indexPath.section];
            
            if (indexPath.row == array.count - 1) {
                
                [cell inserModelCompanyModel:array[indexPath.row] view:YES];
                
            }else{
                
                [cell inserModelCompanyModel:array[indexPath.row] view:NO];
                
            }
            
            
            
            return cell;
            
        }
        
        
        
    }
    
    
    
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if (tableView.tag != 250) {
        
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DeviceWidth, 50)];
        
        view.backgroundColor = [UIColor whiteColor];
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(28, 15, DeviceWidth-10, 20)];
        
        label.text = _nameArray[section];
        
        label.font = [UIFont appFontRegularOfSize:14];
        
        [view addSubview:label];
        
        UIButton *button = [[UIButton alloc]initWithFrame:view.bounds];
        
        button.backgroundColor = [UIColor clearColor];
        
        [button addTarget:self action:@selector(buildSelectItem:) forControlEvents:UIControlEventTouchUpInside];
        
        button.tag = section;
        
        [view addSubview:button];
        
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 49, DeviceWidth, 1)];
        
        lineView.backgroundColor =[UIColor UIColorWithHexColorString:@"0xe1e1e1" AndAlpha:1.0];
        
        [view addSubview:lineView];
        
        UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(DeviceWidth-50*x, 21, 14, 8)];
        
        PeosonInfoType *type = _infoTypeArray[section];
        
        if (type.isOpen) {
            
            imgView.image = [UIImage imageNamed:@"箭头_上"];
            
        }else{
            
            imgView.image = [UIImage imageNamed:@"箭头_下"];
            
        }
        
        [view addSubview:imgView];
        
        return view;
        
        
    }else {
        
        return nil;
        
    }
    
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (tableView.tag == 250) {
        
        return 0.0000000009;
        
    }else{
        
        return 50;
    }
    
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    if (tableView.tag == 250) {
        
        return 15;
        
    }
    
    return 0.0000009;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView.tag == 250) {
        
        return 40;
        
    }else{
        
        if (indexPath.section == 3) {
            
            return 165*x;
        }
        
        return 45;
        
        
    }
    
    
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView.tag != 250) {
        
        
        if (indexPath.section == 3) {
            
            
            
        }else{
            
            _nowIndexPath = indexPath;
            
            if (_nowTextField) {
                
                [_nowTextField resignFirstResponder];
                
            }
            
            NSArray *array = [_personInfo getDataArray][indexPath.section];
            
            TypeClass *info = array[indexPath.row];
            
            if (!info.isEdit) {
                
                [self buildToSelectPicker:info];
                
            }
            
        }
        
        
        
    }
    
    
}

#pragma mark --> pickerView代理方法

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    
    return _selectArray.count;
    
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    
    NSArray *array = _selectArray[component];
    
    return array.count;
    
}

-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    
    
    UILabel *pickerLab = (UILabel *)view;
    
    if (!pickerLab) {
        
        pickerLab = [[UILabel alloc]init];
        
        pickerLab.textAlignment = NSTextAlignmentCenter;
        
        pickerLab.font = [UIFont appFontRegularOfSize:13];
        
        pickerLab.textColor = [UIColor blackColor];
        
        float sysVer = [[[UIDevice currentDevice] systemVersion] floatValue];
        
        if (sysVer >= 10.0) {
            
            for (UIView *sub in pickerView.subviews) {
                
                if (sub.frame.size.height<1.0) {
                    
                    sub.backgroundColor = [UIColor lightGrayColor];
                    
                }
                
            }
        }
        
        
    }
    
    NSArray *array = _selectArray[component];
    
    pickerLab.text = array[row];
    
    
    return pickerLab;
    
}

//选中某列某行的时候调用
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    
    if (_nowSelectType == LiveAddressCityPickType || _nowSelectType == WorkAddressCityPickType) {
        
        SearchCityOrCode *transfor =[[SearchCityOrCode alloc]init];
        
        if (component == 0) {
            
            strProvinceNameTemp = _selectArray[0][row];
            
            NSArray *arrayCity = [transfor cityAllFromProv:StringOrNull(strProvinceNameTemp)];
            
            [_selectArray replaceObjectAtIndex:1 withObject:arrayCity];
            
            [pickerView reloadComponent:1];
            
            [pickerView selectRow:0 inComponent:1 animated:YES];
            
            NSString *strCityName = _selectArray[1][0];
            
            NSArray *arrayArea = [transfor areaAllFromProv:strProvinceNameTemp andCityName:strCityName];
            
            [_selectArray replaceObjectAtIndex:2 withObject:arrayArea];
            
            [pickerView reloadComponent:2];
            
            [pickerView selectRow:0 inComponent:2 animated:YES];
            
            
        }else if (component == 1){
            
            NSString *strCityName = _selectArray[1][row];
            
            NSArray *areaArr = [transfor areaAllFromProv:StringOrNull(strProvinceNameTemp) andCityName:strCityName];
            
            [_selectArray replaceObjectAtIndex:2 withObject:areaArr];
            
            //刷新2列
            [pickerView reloadComponent:2];
            
            //滚动到0行
            [pickerView selectRow:0 inComponent:2 animated:YES];
            
        }else{
            
            //不需要更新
        }
        
    }
    
    
}

#pragma mark --> textField代理协议

-(BOOL)textFieldShouldReturn:(GoodTextField *)textField{
    
    [textField resignFirstResponder];
    
    return YES;
    
}

#pragma mark --> 点击取消、确定的代理协议
-(void)sendSelect:(BOOL)selectResult{
    
    if (selectResult) {
        
        //点击了确定按钮
        
        NSMutableArray *array =  [NSMutableArray arrayWithArray: [_personInfo getDataArray][_nowIndexPath.section]];
        
        TypeClass *type = array[_nowIndexPath.row];
        
        if (_nowSelectType == LiveAddressCityPickType) {
            //省市选择
            [type searchCityNameArray:_selectArray proNum:[_selectPickerView selectedRowInComponent:0] cityNum:[_selectPickerView selectedRowInComponent:1] araeNum:[_selectPickerView selectedRowInComponent:2]];
            
            [array replaceObjectAtIndex:_nowIndexPath.row withObject:type];
            
            [_personInfo.dataArray replaceObjectAtIndex:_nowIndexPath.section withObject:array];
            
        }else if (_nowSelectType == WorkAddressCityPickType){
            
            [type searchCityNameArray:_selectArray proNum:[_selectPickerView selectedRowInComponent:0] cityNum:[_selectPickerView selectedRowInComponent:1] araeNum:[_selectPickerView selectedRowInComponent:2]];
            
            [array replaceObjectAtIndex:_nowIndexPath.row withObject:type];
            
            [_personInfo.dataArray replaceObjectAtIndex:_nowIndexPath.section withObject:array];
            
        }else {
            
            if (_selectArray.count > 0) {
                
                NSArray *jack = _selectArray[0];
                
                if (jack.count > [_selectPickerView selectedRowInComponent:0]) {
                    
                    type.result = _selectArray[0][[_selectPickerView selectedRowInComponent:0]];
                    
                    type.code = [DefineSystemTool codeWithString:type.result WithType:type.key];
                    
                    [array replaceObjectAtIndex:_nowIndexPath.row withObject:type];
                    
                    [_personInfo.dataArray replaceObjectAtIndex:_nowIndexPath.section withObject:array];
                    
                    if ([type.title isEqualToString:@"婚姻状况"]) {
                        
                        _stringType = type.result;
                        
                        if ([type.result isEqualToString:@"已婚"]) {
                            
                            [self buildHeadError:@"你已已婚，联系人请选择夫妻"];
                            
                        }
                        
                    }
                    
                    
                }
                
            }
            
            
        }
        
        
        [_showInfoTable reloadData];
        
        
    }
    
    if (_delegate && [_delegate respondsToSelector:@selector(sendViewShow:)]) {
        
        [_delegate sendViewShow:NO];
        
    }
    
    _selectPickerView.hidden = YES;
    
    _topSelectView.hidden = YES;
    
}

#pragma mark --> 选择联系电话后的代理协议

-(void)sendPhoneNumBack{
    
    if ([AppDelegate delegate].userInfo.whiteType == WhiteA) {
        
        InputTextTableViewCell *cell = [_showInfoTable cellForRowAtIndexPath:_nowIndexPath];
        
        cell.optionText.enabled = YES;
        
        [cell.optionText becomeFirstResponder];
        
    }
    
    
}

-(void)sendPhone:(NSString *)number{
    
    NSMutableArray *array =  [NSMutableArray arrayWithArray: [_personInfo getDataArray][_nowIndexPath.section]];
    
    TypeClass *type = array[_nowIndexPath.row];
    
    type.result = [number stringByReplacingOccurrencesOfString:@"-" withString:@""];
    
    [array replaceObjectAtIndex:_nowIndexPath.row withObject:type];
    
    [_personInfo.dataArray replaceObjectAtIndex:_nowIndexPath.section withObject:array];
    
    [_showInfoTable reloadData];
    
}

#pragma mark -->拍照完成后所调用的代理方法
////获取拍照的图片
//- (void)sendTakeImage:(TCARD_TYPE) iCardType image:(UIImage *)cardImage
//{
//
//    if (cardImage) {
//
//        if (_provingType == LeftImage || _provingType == Address || _provingType == Gender || _provingType == Time) {
//
//            if (_finishLeftImage) {
//               _statusView.leftimage.image = cardImage;
//            }
//
//        }else if (_provingType == RightImage || _provingType == Office | _provingType == Valid){
//
//            if (_finishRightImage) {
//             _statusView.rightImage.image = cardImage;
//            }
//
//        }else if (_provingType == Camera){
//
//            AppDelegate *dele = (AppDelegate *)[UIApplication sharedApplication].delegate;
//
//            NSMutableDictionary *parm = [[NSMutableDictionary alloc]init];
//
//            NSData *data = UIImageJPEGRepresentation(cardImage, ImageUpZScale);
//
//            NSString *strm = [DefineSystemTool md5StringWithData:data];
//
//            NSString *name = [NSString stringWithFormat:@"%@.jpg",_nowSelectBody.docCde];
//
//            if (dele.userInfo.custNum.length > 0 && dele.userInfo.custNum) {
//
//                [parm setObject:dele.userInfo.custNum forKey:@"custNo"];
//
//            }
//
//
//            if (_nowSelectBody.docCde.length > 0 && _nowSelectBody.docCde) {
//
//                [parm setObject:_nowSelectBody.docCde forKey:@"attachType"];
//
//            }
//
//            if (_nowSelectBody.docDesc.length > 0 && _nowSelectBody.docDesc) {
//
//                [parm setObject:_nowSelectBody.docDesc forKey:@"attachName"];
//
//            }
//
//            if (strm.length > 0 && strm) {
//
//                [parm setObject:strm forKey:@"md5"];
//
//            }
//
//            [parm setObject:@"" forKey:@"commonCustNo"];
//
//            if (_cardIdSring && _cardIdSring.length > 0) {
//
//                [parm setObject:_cardIdSring forKey:@"id"];
//
//            }
//
//            if ([AppDelegate delegate].userInfo.realId.length > 0) {
//
//                [parm setObject:[AppDelegate delegate].userInfo.realId forKey:@"idNo"];
//
//            }
//
//            if (!_saveDataArray) {
//
//                _saveDataArray = [[NSMutableArray alloc]init];
//
//            }else{
//
//                [_saveDataArray removeAllObjects];
//            }
//
//            [_saveDataArray addObject:data];
//
//            BSVKHttpClient *client = [BSVKHttpClient shareInstance];
//
//            client.delegate = self;
//
//            [self.hud showAnimated:YES];
//
//            [client puFile:@"app/appserver/attachUploadPerson" requestArgument:parm fileData:data fileName:name name:@"multipartFile" mimeType:@"image/jpeg" requestTag:SaveOneImage requestClass:NSStringFromClass([self class])];
//
//        }
//
//
//    }else{
//
//        [self buildHeadError:@"获取照片失败，请重新拍摄"];
//
//    }
//
//
//}

-(void)didFinishPickingImage:(UIImage *)image{
    
    AppDelegate *dele = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    NSMutableDictionary *parm = [[NSMutableDictionary alloc]init];
    
    NSData *data = UIImageJPEGRepresentation(image, ImageUpZScale);
    
    NSString *strm = [DefineSystemTool md5StringWithData:data];
    
    NSString *name = [NSString stringWithFormat:@"%@.jpg",_nowSelectBody.docCde];
    
    if (dele.userInfo.custNum.length > 0 && dele.userInfo.custNum) {
        
        [parm setObject:dele.userInfo.custNum forKey:@"custNo"];
        
    }
    
    
    if (_nowSelectBody.docCde.length > 0 && _nowSelectBody.docCde) {
        
        [parm setObject:_nowSelectBody.docCde forKey:@"attachType"];
        
    }
    
    if (_nowSelectBody.docDesc.length > 0 && _nowSelectBody.docDesc) {
        
        [parm setObject:_nowSelectBody.docDesc forKey:@"attachName"];
        
    }
    
    if (strm.length > 0 && strm) {
        
        [parm setObject:strm forKey:@"md5"];
        
    }
    
    [parm setObject:@"" forKey:@"commonCustNo"];
    
    if (_cardIdSring && _cardIdSring.length > 0) {
        
        [parm setObject:_cardIdSring forKey:@"id"];
        
    }
    
    if (!_saveDataArray) {
        
        _saveDataArray = [[NSMutableArray alloc]init];
        
    }else{
        
        [_saveDataArray removeAllObjects];
    }
    
    [_saveDataArray addObject:data];
    
    BSVKHttpClient *client = [BSVKHttpClient shareInstance];
    
    client.delegate = self;
    
    [self.hud showAnimated:YES];
    
    [client puFile:@"app/appserver/attachUploadPerson" requestArgument:parm fileData:data fileName:name name:@"multipartFile" mimeType:@"image/jpeg" requestTag:SaveOneImage requestClass:NSStringFromClass([self class])];
}

#pragma mark --> 从影像编辑页面返回后所执行的方法
-(void)sendResultNumber:(NSInteger)number array:(NSMutableArray *)imgArray{
    
    [self buildReloadImage];
    
}

#pragma mark -->相册代理协议
- (void)imagePickerController:(JKImagePickerController *)imagePicker didSelectAsset:(JKAssets *)asset isSource:(BOOL)source
{
    [imagePicker dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)imagePickerController:(JKImagePickerController *)imagePicker didSelectAssets:(NSArray *)assets isSource:(BOOL)source
{
    WEAKSELF
    
    [imagePicker dismissViewControllerAnimated:YES completion:^{
        
        STRONGSELF
        
        if (strongSelf) {
            
            if (!strongSelf.saveDataArray) {
                
                strongSelf.saveDataArray = [[NSMutableArray alloc]init];
                
            }else{
                
                [strongSelf.saveDataArray removeAllObjects];
                
            }
            
            if (!strongSelf.saveInfoArray) {
                
                strongSelf.saveInfoArray = [[NSMutableArray alloc]init];
                
            }else{
                
                [strongSelf.saveInfoArray removeAllObjects];
                
            }
            
            CheckMsgList *body = strongSelf.nowSelectBody;
            
            AppDelegate *dele = (AppDelegate *)[UIApplication sharedApplication].delegate;
            
            strongSelf.selectName = [NSString stringWithFormat:@"%@.jpg",body.docCde];
            
            if (assets.count>0) {
                
                for (JKAssets *kiss in assets) {
                    
                    NSMutableDictionary *parmDic = [[NSMutableDictionary alloc]init];
                    
                    NSData *data = UIImageJPEGRepresentation(kiss.photo, ImageUpZScale);
                    
                    NSString *strm = [DefineSystemTool md5StringWithData:data];
                    
                    if (dele.userInfo.custNum && dele.userInfo.custNum.length > 0) {
                        
                        [parmDic setObject:dele.userInfo.custNum forKey:@"custNo"];
                        
                    }
                    
                    if (body.docCde && body.docCde.length > 0) {
                        
                        [parmDic setObject:body.docCde forKey:@"attachType"];
                        
                    }
                    
                    if (body.docDesc && body.docDesc.length > 0) {
                        
                        [parmDic setObject:body.docDesc forKey:@"attachName"];
                        
                    }
                    
                    if (strm && strm.length > 0) {
                        
                        [parmDic setObject:strm forKey:@"md5"];
                        
                    }
                    
                    [parmDic setObject:@"" forKey:@"commonCustNo"];
                    
                    if (strongSelf.cardIdSring && strongSelf.cardIdSring.length > 0) {
                        
                        [parmDic setObject:strongSelf.cardIdSring forKey:@"id"];
                        
                    }
                    
                    
                    if (parmDic && parmDic.count > 0) {
                        
                        [strongSelf.saveInfoArray addObject:parmDic];
                        
                    }
                    
                    if (data ) {
                        
                        [strongSelf.saveDataArray addObject:data];
                        
                    }
                    
                }
                
            }
            
            if (strongSelf.saveDataArray.count > 0 && strongSelf.saveInfoArray.count > 0) {
                
                strongSelf.saveMuchNum = 0;
                
                [strongSelf buildSaveMuchImageNum:0];
                
            }
            
        }
        
    }];
    
    
}

- (void)imagePickerControllerDidCancel:(JKImagePickerController *)imagePicker
{
    
    [imagePicker dismissViewControllerAnimated:YES completion:^{
        
    }];
}

//上传多张影像
-(void)buildSaveMuchImageNum:(NSInteger)postNum{
    
    BSVKHttpClient *client = [BSVKHttpClient shareInstance];
    
    client.delegate = self;
    
    [self.hud showAnimated:YES];
    [client puFile:@"app/appserver/attachUploadPerson" requestArgument:_saveInfoArray[postNum] fileData:_saveDataArray[postNum] fileName:_selectName name:@"multipartFile" mimeType:@"image/jpeg" requestTag:SaveMuchImage requestClass:NSStringFromClass([self class])];
    
}


#pragma mark --> cell的代理方法

-(void)sendNowGoodText:(GoodTextField *)field index:(NSIndexPath *)indexPath{
    
    _nowTextField = field;
    
    _nowIndexPath = indexPath;
    
}

-(void)sendText:(NSString *)string index:(NSIndexPath *)path{
    
    _nowTextField = nil;
    
    NSMutableArray *array =  [NSMutableArray arrayWithArray: [_personInfo getDataArray][path.section]];
    
    TypeClass *info = array[path.row];
    
    info.result = string;
    
    [array replaceObjectAtIndex:path.row withObject:info];
    
    [_personInfo.dataArray replaceObjectAtIndex:path.section withObject:array];
    
}

#pragma mark --> 头部视图的代理方法

-(void)sendSelectType:(TouchType)type{
    
    _provingType = type;
    
    [self scanning];
    
}

-(void)sendTouchType:(TouchType)type open:(BOOL)isOpen num:(NSInteger)number{
    
    if (isOpen) {
        
        for (int i =0; i<_infoTypeArray.count; i++) {
            
            PeosonInfoType *info = _infoTypeArray[i];
            
            info.isOpen = NO;
            
            [_infoTypeArray replaceObjectAtIndex:i withObject:info];
            
        }
        
        if (number == 0) {
            
            // [_statusView creatHeaderView];
            
            [_statusView creatBaseUI:CGRectMake(0, 50, DeviceWidth, 364+90*x)];
            
            [_statusView creatBaseText];
            
            [_statusView creatNameView];
            
        }
        
        if (_statusHeight) {
            
            _statusView.frame = CGRectMake(0, 0, DeviceWidth, _statusHeight);
            
        }else{
            
            _statusView.frame = CGRectMake(0, 0, DeviceWidth, 414+90*x);
            
        }
        
        _showInfoTable.tableHeaderView = nil;
        
        _showInfoTable.tableHeaderView = _statusView;
        
        _statusView.baseView.hidden = NO;
        
        
    }else{
        
        _statusView.frame = CGRectMake(0, 0, DeviceWidth, 50);
        
        _showInfoTable.tableHeaderView = nil;
        
        _showInfoTable.tableHeaderView = _statusView;
        
        _statusView.baseView.hidden = YES;
        
    }
    
    [_showInfoTable reloadData];
    
}

-(void)sendTextViewHeight:(float)height{
    
    _statusHeight = height;
    
    _statusView.frame = CGRectMake(0, 0, DeviceWidth, height);
    
    _showInfoTable.tableHeaderView = nil;
    
    _showInfoTable.tableHeaderView = _statusView;
    
    [_showInfoTable reloadData];
    
}

#pragma mark --> 扫描身份证之后的代理方法

#pragma mark - 身份证正面识别
// 获取身份证正面信息
- (void)sendIDCValue:(NSString *)name SEX:(NSString *)sex FOLK:(NSString *)folk BIRTHDAY:(NSString *)birthday ADDRESS:(NSString *) address NUM:(NSString *)num{
    
    if (_provingType != Camera) {
        
        if (_provingType == Office || _provingType == Valid || _provingType == RightImage) {
            
            _finishLeftImage = NO;
            
            // [_sccap dismissBtnPressed:NULL];
            WEAKSELF
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW,
                                         
                                         (int64_t)(0.8 * NSEC_PER_SEC)),
                           
                           dispatch_get_main_queue(), ^{
                               STRONGSELF
                               [strongSelf buildHeadError:@"请扫描身份证正面"];
                               
                           });
            
            
        }else{
            
            if ([[AppDelegate delegate].userInfo.realId isEqualToString:[num deleteSpeaceString]]) {
                
                _finishLeftImage = YES;
                
                _statusView.genderLabel.text = [sex deleteSpeaceString];
                
                if (_statusView.genderLabel.text.length > 0 && _statusView.genderLabel.text) {
                    
                    if ([_statusView.genderLabel.text isEqualToString:@"男"]) {
                        
                        [_scanParmDic setObject:@"10" forKey:@"gender"];
                        
                    }else if ([_statusView.genderLabel.text isEqualToString:@"女"]){
                        
                        [_scanParmDic setObject:@"20" forKey:@"gender"];
                        
                    }
                    
                    
                    
                }
                
                if (folk.length > 0) {
                    
                    [_scanParmDic setObject:folk forKey:@"ethnic"];
                    
                }
                
                _statusView.birthLabel.text = [birthday deleteSpeaceString];
                
                NSString *string = [_statusView.birthLabel.text buildChangeDay];
                
                if (string.length > 0 && string) {
                    
                    [_scanParmDic setObject:string forKey:@"birthDt"];
                    
                }
                
                if (_statusView.addressText.text.length > 0 && _statusView.addressText.text) {
                    [_scanParmDic setObject:_statusView.addressText.text forKey:@"regAddr"];
                }
                
                [_statusView buildNowTimeChangeViewHeight:address];
                
            }else{
                //                [_sccap dismissBtnPressed:NULL];
                _finishLeftImage = NO;
                [self buildHeadError:@"扫描后的身份证信息不匹配"];
                
            }
            
            
        }
        
        
    }
    
    
}

#pragma mark --> 身份证反面识别

// 获取身份证反面信息
- (void)sendIDCBackValue:(NSString *)issue PERIOD:(NSString *) period{
    
    if (_provingType != Camera) {
        
        if (_provingType == LeftImage || _provingType == Gender || _provingType == Time || _provingType == Address) {
            _finishRightImage = NO;
            // [_sccap dismissBtnPressed:NULL];
            [self buildHeadError:@"请扫描身份证反面"];
            
        }else{
            
            _finishRightImage = YES;
            
            _statusView.officeText.text = [issue deleteSpeaceString];
            
            if (_statusView.officeText.text.length > 0 && _statusView.officeText.text) {
                [_scanParmDic setObject:_statusView.officeText.text forKey:@"certOrga"];
            }
            
            _statusView.validLabel.text = [period deleteSpeaceString];
            
            NSString *string = [period buildReplaceCertStartDt];
            
            if (string.length > 0 && string) {
                
                [_scanParmDic setObject:string forKey:@"certStrDt"];
                
            }
            
            NSString *stringTwo = [period buildReplaceCertEndDt];
            
            if (stringTwo.length > 0 && stringTwo) {
                
                [_scanParmDic setObject:stringTwo forKey:@"certEndDt"];
                
            }
            
            
        }
        
        
        
    }
    
    
}

#pragma mark --> 网络代理协议

-(void)requestSucess:(NSInteger)requestTag requestResult:(id)responseObject requestClass:(NSString *)className{
    
    if ([className isEqualToString:NSStringFromClass([self class])]) {
        
        if (requestTag == SaveOneImage) {
            
            [self.hud hideAnimated:YES];
            
            PostSuccessModel *model = [PostSuccessModel mj_objectWithKeyValues:responseObject];
            
            [self buildHandleOneImage:model];
            
        }else if (requestTag == GetImageInfo){
            
            [self.hud hideAnimated:YES];
            
            CheckMsgModel *model = [CheckMsgModel mj_objectWithKeyValues:responseObject];
            
            [self buildHandleGetImage:model];
            
        }else if (requestTag == getSelectImage){
            
            [self.hud hideAnimated:YES];
            
            SelectNameModel *model = [SelectNameModel mj_objectWithKeyValues:responseObject];
            
            [self buildHandleSelectImage:model];
            
        }else if (requestTag == ReloadImage){
            
            [self.hud hideAnimated:YES];
            
            PortraitImageModel *model = [PortraitImageModel mj_objectWithKeyValues:responseObject];
            
            [self buildHandelReloadImage:model];
            
        }else if (requestTag == SaveMuchImage){
            
            [self.hud hideAnimated:YES];
            
            PostSuccessModel *model = [PostSuccessModel mj_objectWithKeyValues:responseObject];
            
            [self buildHandleMuchImage:model];
            
        }else if (requestTag == GetPeopleInfo){
            
            [self.hud hideAnimated:YES];
            
            AllPersonInfo *model = [AllPersonInfo mj_objectWithKeyValues:responseObject];
            
            [self buildHandleGetCompanyInfo:model];
            
        }else if (requestTag == SavePeopleInfo){
            
            [self.hud hideAnimated:YES];
            
            PortraitImageModel *model = [PortraitImageModel mj_objectWithKeyValues:responseObject];
            
            [self buildHandleSaveInfo:model];
            
        }else if (requestTag == SaveContactInfo){
            
            [self.hud hideAnimated:YES];
            
            PortraitImageModel *model = [PortraitImageModel mj_objectWithKeyValues:responseObject];
            
            [self buildHandleSaveContactInfo:model];
            
        }else if (requestTag == SaveScanInfo){
            
            [self.hud hideAnimated:YES];
            
            UserSettingModel *model = [UserSettingModel mj_objectWithKeyValues:responseObject];
            
            [self buildHandleSaveScanInfo:model];
            
        }else if (requestTag == SaveFinishInfo){
            
            [self.hud hideAnimated:YES];
            
            UserSettingModel *model = [UserSettingModel mj_objectWithKeyValues:responseObject];
            
            [self buildHandleSaveFinishInfo:model];
            
        }else if (requestTag == SendSacnImage){
            
            [self.hud hideAnimated:YES];
            
            PortraitImageModel *model = [PortraitImageModel mj_objectWithKeyValues:responseObject];
            
            [self buildHandleSendSacnImage:model];
            
        }else if (requestTag == SendSacnTwoImage){
            
            [self.hud hideAnimated:YES];
            
            PortraitImageModel *model = [PortraitImageModel mj_objectWithKeyValues:responseObject];
            
            [self buildHandleSendSacnTwoImage:model];
            
            
        }
        
    }
    
}

//请求失败（参数错误）
-(void)requestFail:(NSInteger)requestTag requestError:(NSError *)error httpCode:(NSInteger)httpCode requestClass:(NSString *)className{
    
    if ([className isEqualToString:NSStringFromClass([self class])]) {
        
        [self.hud hideAnimated:YES];
        
        if (requestTag == GetPeopleInfo) {
            
            _hasGetInfo = NO;
            
            _personInfo = [[PersonInfoModel alloc]initWithInfoModel:nil];
            
        }else if (requestTag == GetImageInfo){
            
            _hasGetImage = NO;
            
        }else if (requestTag == ReloadImage){
            
            _hasGetImage = NO;
            
        }
        
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

#pragma mark --> 网络请求后的处理方法
//上传扫描后的身份证反面
-(void)buildHandleSendSacnTwoImage:(PortraitImageModel *)model{
    
    if ([model.head.retFlag isEqualToString:@"00000"]) {
        
        [self buildSaveScanInfo];
        
    }else{
        
        [self buildHeadError:model.head.retMsg];
        
    }
    
}
//上传扫描后的身份证正面
-(void)buildHandleSendSacnImage:(PortraitImageModel *)model{
    
    if ([model.head.retFlag isEqualToString:@"00000"]) {
        
        [self buildSendScanTwoImage];
        
    }else{
        
        [self buildHeadError:model.head.retMsg];
        
    }
    
}

-(void)buildHandleSaveFinishInfo:(UserSettingModel *)model{
    
    if ([model.head.retFlag isEqualToString:@"00000"]) {
        
        [self buildSaveInfo];
        
    }else{
        
        [self buildHeadError:model.head.retMsg];
        
    }
    
}

-(void)buildHandleSaveScanInfo:(UserSettingModel *)model{
    
    if ([model.head.retFlag isEqualToString:@"00000"]) {
        
        [self buildSaveInfo];
        
    }else{
        
        [self buildHeadError:model.head.retMsg];
        
    }
    
}

//处理请求必传影像信息的接口
-(void)buildHandleGetImage:(CheckMsgModel *)model{
    
    if ([model.head.retFlag isEqualToString:@"00000"]) {
        
        if ([model.body.CERTFLAG isEqualToString:@"N"] && ![_certFlag isEqualToString:@"Y"]) {
            
            _showCertString = model.body.CERTFLAG;
            
            [self creatHeaderView];
            
            _showInfoTable.tableHeaderView = _statusView;
        }else{
            
            _showCertString = @"Y";
            
        }
        
        if (!_imageArray ) {
            
            _imageArray = [[NSMutableArray alloc]init];
            
        }else{
            
            [_imageArray removeAllObjects];
        }
        
        NSMutableArray *array = [NSMutableArray arrayWithArray:model.body.BCYX.list];
        
        for (int i =0; i<array.count; i++) {
            
            CheckMsgList *list = array[i];
            
            if ([list.docDesc isEqualToString:@"身份证正面"] || [list.docDesc isEqualToString:@"身份证反面"]) {
                
                [array removeObject:list];
                
                i--;
                
            }
            
        }
        
        if (array.count > 0) {
            
            if (array.count %2 == 0) {
                
                int num = 0;
                
                for (int i =0; i<(array.count/2); i++) {
                    
                    CheckMsgList *body = array[num];
                    
                    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
                    
                    [dic setObject:body forKey:@"ChooseNameBody"];
                    
                    num++;
                    
                    //  NSArray *array = [NSArray arrayWithObjects:dic, nil];
                    
                    CheckMsgList *rose = array[num];
                    
                    NSMutableDictionary *dicTwo = [[NSMutableDictionary alloc]init];
                    
                    [dicTwo setObject:rose forKey:@"ChooseNameBody"];
                    
                    num++;
                    
                    NSArray *arrayTwo = [NSArray arrayWithObjects:dic, dicTwo, nil];
                    
                    [_imageArray addObject:arrayTwo];
                    
                    
                }
                
            }else{
                
                int num = 0;
                
                for (int i =1; i<(array.count/2+2); i++) {
                    
                    if (i == array.count/2 +1) {
                        
                        CheckMsgList *body = array[num];
                        
                        NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
                        
                        [dic setObject:body forKey:@"ChooseNameBody"];
                        
                        NSArray *array = [NSArray arrayWithObjects:dic, nil];
                        
                        [_imageArray addObject:array];
                        
                        
                    }else{
                        
                        CheckMsgList *body = array[num];
                        
                        NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
                        
                        [dic setObject:body forKey:@"ChooseNameBody"];
                        
                        num++;
                        
                        CheckMsgList *rose = array[num];
                        
                        NSMutableDictionary *dicTwo = [[NSMutableDictionary alloc]init];
                        
                        [dicTwo setObject:rose forKey:@"ChooseNameBody"];
                        
                        num++;
                        
                        NSArray *arrayTwo = [NSArray arrayWithObjects:dic,dicTwo, nil];
                        
                        [_imageArray addObject:arrayTwo];
                        
                    }
                    
                }
                
            }
            
            
        }else{
            
            _nameArray = [NSArray arrayWithObjects:@"单位信息",@"个人信息",@"联系人", nil];
            
            [_showInfoTable reloadData];
            
        }
        
        
        if (array.count > 0) {
            
            [self buildReloadImage];
            
        }else{
            
            _hasGetImage = YES;
            
        }
        
    }else{
        
        _hasGetImage = NO;
        
        [self buildHeadError:model.head.retMsg];
        
    }
    
    
    
    
}

//处理保存联系人信息后的逻辑
-(void)buildHandleSaveContactInfo:(PortraitImageModel *)model{
    
    if ([model.head.retFlag isEqualToString:@"00000"]) {
        
        if (_delegate && [_delegate respondsToSelector:@selector(sendSaveInfoViewType:)]) {
            
            
            
            [_delegate sendSaveInfoViewType:ShowPersonType];
            
        }
        
    }else{
        
        [self buildHeadError:model.head.retMsg];
        
    }
}

//处理保存信息后的逻辑
-(void)buildHandleSaveInfo:(PortraitImageModel*)model{
    
    if ([model.head.retFlag isEqualToString:@"00000"]) {
        
        [self buildSaveContactInfo];
        
    }else{
       
        [self buildHeadError:model.head.retMsg];
        
    }
    
}

//处理上传单张影像后的逻辑
-(void)buildHandleOneImage:(PostSuccessModel *)model{
    
    if ([model.head.retFlag isEqualToString:@"00000"]) {
        
        NSData *data = _saveDataArray[0];
        
        NSString *url = [NSString stringWithFormat:@"%ld",(long)model.body.ID];
        
        [[AppDelegate delegate].imagePutCache setObject:data forKey:ImageUrl(url)];
        
        [self buildReloadImage];
        
    }else{
        
        [self buildHeadError:model.head.retMsg];
        
    }
    
}

//处理二级小类列表
-(void)buildHandleSelectImage:(SelectNameModel *)model{
    
    if ([model.head.retFlag isEqualToString:@"00000"]) {
        
        if (!_selectNameArray) {
            
            _selectNameArray = [NSMutableArray array];
            
        }else{
            
            [_selectNameArray removeAllObjects];
            
        }
        
        if (model.body.count > 0) {
            
            NSArray *array = [NSArray arrayWithArray:model.body];
            
            [_selectNameArray addObject:array];
            
            SelectNameBody *body = [[SelectNameBody alloc]init];
            
            body.docDesc = @"取消";
            
            [_selectNameArray addObject:@[body]];
            
            [self buildFreshTable];
            
        }else{
            
            WEAKSELF
            
            [RMUniversalAlert showActionSheetInViewController:self withTitle:@"选择一张照片" message:@"" cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@[@"拍照",@"从相册中选取"] popoverPresentationControllerBlock:^(RMPopoverPresentationController * _Nonnull popover) {
                
            } tapBlock:^(RMUniversalAlert * _Nonnull alert, NSInteger buttonIndex) {
                
                STRONGSELF
                
                if (strongSelf) {
                    
                    if (buttonIndex == 2) {
                        
                        [strongSelf buildCamera];
                        
                    }else if (buttonIndex == 3){
                        
                        [strongSelf buildPhoto];
                        
                    }
                    
                }
                
            }];
            
            
        }
        
    }else{
        
        [self buildHeadError:model.head.retMsg];
        
    }
    
}

//处理上传多张影像的逻辑
-(void)buildHandleMuchImage:(PostSuccessModel *)model{
    
    if ([model.head.retFlag isEqualToString:@"00000"]) {
        
        NSData *data = _saveDataArray[_saveMuchNum];
        
        NSString *url = [NSString stringWithFormat:@"%ld",(long)model.body.ID];
        
        [[AppDelegate delegate].imagePutCache setObject:data forKey:ImageUrl(url)];
        
    }else{
        
        [self buildHeadError:[NSString stringWithFormat:@"第%ld张图片上传失败,原因:%@",(long)_saveMuchNum+1,model.head.retMsg]];
        
    }
    
    _saveMuchNum++;
    
    if (_saveMuchNum == _saveInfoArray.count) {
        
        [self buildReloadImage];
        
    }else{
        
        [self buildSaveMuchImageNum:_saveMuchNum];
        
    }
    
}


//处理刷新影像视图
-(void)buildHandelReloadImage:(PortraitImageModel *)model{
    
    if ([model.head.retFlag isEqualToString:@"00000"]) {
        
        for (int i =0; i<_imageArray.count; i++) {
            
            NSMutableArray *array =  [NSMutableArray arrayWithArray: _imageArray[i]];
            
            for (int j = 0;j<array.count ; j++) {
                
                NSMutableDictionary *dic = array[j];
                
                [dic removeObjectForKey:@"PortraitBody"];
                
                [array replaceObjectAtIndex:j withObject:dic];
                
            }
            
            [_imageArray replaceObjectAtIndex:i withObject:array];
            
        }
        
        
        for (PortraitBody *imageBody in model.body) {
            
            for (int i =0; i<_imageArray.count; i++) {
                
                NSMutableArray *array =  [NSMutableArray arrayWithArray: _imageArray[i]];
                
                for (int j = 0;j<array.count ; j++) {
                    
                    NSMutableDictionary *dic = array[j];
                    
                    CheckMsgList *body = [dic objectForKey:@"ChooseNameBody"];
                    
                    if ([body.docCde isEqualToString:imageBody.attachType]) {
                        
                        [dic setObject:imageBody forKey:@"PortraitBody"];
                        
                        [array replaceObjectAtIndex:j withObject:dic];
                        
                    }
                    
                }
                
                [_imageArray replaceObjectAtIndex:i withObject:array];
                
            }
            
        }
        
        _hasGetImage = YES;
        
        if ([_type isEqualToString:@"单元格"]) {
            
            PeosonInfoType *type = _infoTypeArray[_nowSelectSection];
            
            BOOL judge = type.isOpen;
            
            for (int i =0; i<_infoTypeArray.count; i++) {
                
                PeosonInfoType *info = _infoTypeArray[i];
                
                info.isOpen = NO;
                
                [_infoTypeArray replaceObjectAtIndex:i withObject:info];
                
            }
            
            
            type.isOpen = !judge;
            
            [_infoTypeArray replaceObjectAtIndex:_nowSelectSection withObject:type];
        }
        
        
        [_showInfoTable reloadData];
        
    }else{
        
        _hasGetImage = NO;
        
        [self buildHeadError:model.head.retMsg];
        
    }
    
}

//处理请求下来的个人基本信息
-(void)buildHandleGetCompanyInfo:(AllPersonInfo *)model{
    
    if ([model.head.retFlag isEqualToString:@"00000"]) {
        
        _hasGetInfo = YES;
        
        _stringType = [DefineSystemTool stringForCode:model.body.maritalStatus WithType:@"MARR_STS"];
        
        _personInfo = [[PersonInfoModel alloc]initWithInfoModel:model.body];
        
        if ([_type isEqualToString:@"单元格"]) {
            
            PeosonInfoType *type = _infoTypeArray[_nowSelectSection];
            
            BOOL judge = type.isOpen;
            
            for (int i =0; i<_infoTypeArray.count; i++) {
                
                PeosonInfoType *info = _infoTypeArray[i];
                
                info.isOpen = NO;
                
                [_infoTypeArray replaceObjectAtIndex:i withObject:info];
                
            }
            
            
            type.isOpen = !judge;
            
            [_infoTypeArray replaceObjectAtIndex:_nowSelectSection withObject:type];
        }
        
        [_showInfoTable reloadData];
        
    }else if ([model.head.retFlag isEqualToString:@"C1109"]){
        
        _hasGetInfo = YES;
        
        _personInfo = [[PersonInfoModel alloc]initWithInfoModel:nil];
        
        if ([_type isEqualToString:@"单元格"]) {
            
            PeosonInfoType *type = _infoTypeArray[_nowSelectSection];
            
            BOOL judge = type.isOpen;
            
            for (int i =0; i<_infoTypeArray.count; i++) {
                
                PeosonInfoType *info = _infoTypeArray[i];
                
                info.isOpen = NO;
                
                [_infoTypeArray replaceObjectAtIndex:i withObject:info];
                
            }
            
            type.isOpen = !judge;
            
            [_infoTypeArray replaceObjectAtIndex:_nowSelectSection withObject:type];
        }
        
        [_showInfoTable reloadData];
        
    }else{
        
        _hasGetInfo = NO;
        
        [self buildHeadError:model.head.retMsg];
        
        _personInfo = [[PersonInfoModel alloc]initWithInfoModel:nil];
        
        [_showInfoTable reloadData];
        
    }
    
}


@end
