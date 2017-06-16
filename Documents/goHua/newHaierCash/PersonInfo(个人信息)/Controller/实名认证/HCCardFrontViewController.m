//
//  HCCardFrontViewController.m
//  newHaierCash
//
//  Created by 史长硕 on 2017/6/6.
//  Copyright © 2017年 haier. All rights reserved.
//

#import "HCCardFrontViewController.h"
#import "UIFont+AppFont.h"
#import "HCMacro.h"
#import "RMUniversalAlert.h"
#import "AppDelegate.h"
#import <MBProgressHUD.h>
#import "BSVKHttpClient.h"
#import "UITextField+AdaptFrame.h"

#import "CheckIdNoModel.h"
#import "NSString+CheckConvert.h"
#import "DefineSystemTool.h"
#import "SCCaptureCameraController.h"
static CGFloat const CheckIDNumber = 110;   //身份证号码校验
@interface HCCardFrontViewController ()<BSVKHttpClientDelegate,UITextFieldDelegate,SCNavigationControllerDelegate>

{
    
    float x;//屏幕适配比例
    
  
}

@property(nonatomic,strong)  UIImageView *topImgView;//顶部拍照视图

@property(nonatomic,strong) UIScrollView *baseScrollView;//基础滑动视图(6p以上尺寸的不用)

@end

@implementation HCCardFrontViewController

#pragma mark --> life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [self creatTopImageView];
    
    [self creatBaseUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    
    UITextField *text = (UITextField *)[self.view viewWithTag:20];
    
    [text addKeyBoardFrame];;
    
}

-(void)viewDidDisappear:(BOOL)animated{
    
    [super viewDidDisappear:animated];
    
    UITextField *text = (UITextField *)[self.view viewWithTag:20];
    
    [text closeKeyBoardFrame];
    
}

#pragma mark --> private Methods

//创建顶部照片视图
-(void)creatTopImageView{
    
    if (iphone6P) {
        
        x = scale6PAdapter;
        
    }else{
        
        x = scaleAdapter;
        
    }
    
    _topImgView = [[UIImageView alloc]initWithFrame:CGRectMake(70*x, 127*x, DeviceWidth-140*x, 143*x)];
    
    _topImgView.image = [UIImage imageNamed:@"身份证正面"];
    
    _topImgView.userInteractionEnabled = YES;
    
    [self.view addSubview:_topImgView];
    
    UITapGestureRecognizer *gest = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(buildTouchTopImage:)];
    
    [_topImgView addGestureRecognizer:gest];
    
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 97*x, DeviceWidth, 10*x)];
    
    lineView.backgroundColor = UIColorFromRGB(0xeeeeee, 1.0);
    
    [self.view addSubview:lineView];

    
}
//创建基本视图
-(void)creatBaseUI{
    
    float height;
    
    if (iphone6P) {
        
    height = _topImgView.frame.origin.y+_topImgView.frame.size.height+25*x;
        
    }else{
        
        _baseScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, _topImgView.frame.origin.y+_topImgView.frame.size.height+25*x, DeviceWidth, DeviceHeight-64-_topImgView.frame.origin.y-_topImgView.frame.size.height-25*x)];
        
        _baseScrollView.showsVerticalScrollIndicator = NO;
        
        height = 0;
        
        [self.view addSubview:_baseScrollView];
        
        
    }
    
    NSArray *array = @[@"姓名",@"性别",@"出生年月",@"家庭住址",@"证件号码"];
    
    for (int i = 0; i<array.count; i++) {
        
        //左侧标题
        UILabel *leftLabel = [[UILabel alloc]initWithFrame:CGRectMake(15*x, (height+15*x)+50*i*x, 100*x, 20*x)];
        
        leftLabel.text = array[i];
        
        leftLabel.tag = 10+i;
        
        leftLabel.font = [UIFont appFontRegularOfSize:14*x];
        
        //下划线
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(15*x, (49*x+height)+50*i*x, DeviceWidth-30*x, 1*x)];
        
        line.backgroundColor = UIColorFromRGB(0xdddddd, 1.0);
        
        line.tag = 30+i;
        
        if (i == 0) {
        //姓名输入框
        UITextField *leftText = [[UITextField alloc]initWithFrame:CGRectMake(125*x, (height+15*x)+50*i*x, DeviceWidth-140*x, 20*x)];
        
        leftText.textColor = UIColorFromRGB(0x999999, 1.0);
            
        leftText.font = [UIFont appFontRegularOfSize:14*x];
            
        leftText.delegate = self;
            
        leftText.returnKeyType = UIReturnKeyDone;
            
        leftText.textAlignment = NSTextAlignmentRight;
            
        leftText.tag = 20+i;
            
        if (iphone6P) {
            
            [self.view addSubview:leftText];
            
        }else{
            
            [_baseScrollView addSubview:leftText];
            
        }
    
            
        }else{
          
            //右侧展示信息label
            UILabel *rightLabel = [[UILabel alloc]init];
            
            rightLabel.textColor = UIColorFromRGB(0x999999, 1.0);
            
            rightLabel.font = [UIFont appFontRegularOfSize:14*x];
            
            rightLabel.tag = 20+i;
            
            rightLabel.textAlignment = NSTextAlignmentRight;
            
            if (i==1||i==2) {
                
                rightLabel.frame = CGRectMake(125*x, (height)+50*i*x, DeviceWidth-158*x, 50*x);
                
                rightLabel.numberOfLines = 0;
                
                UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(DeviceWidth-30*x, (17.5*x+height)+50*i*x, 9*x, 15*x)];
                
                imgView.backgroundColor = [UIColor clearColor];
                
                imgView.image = [UIImage imageNamed:@"首页_箭头右"];
                
                if (iphone6P) {
                    
                    [self.view addSubview:imgView];
                    
                }else{
                    
                    [_baseScrollView addSubview:imgView];
                    
                }
                
            }else{
                
                rightLabel.frame = CGRectMake(125*x, (height)+50*i*x, DeviceWidth-140*x, 50*x);
                
                rightLabel.numberOfLines = 0;
                
            }
            
            if (iphone6P) {
                
                [self.view addSubview:rightLabel];
                
            }else{
               
                [_baseScrollView addSubview:rightLabel];
                
            }

            
        }
        
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(15*x, height+50*i*x, DeviceWidth, 50*x)];
        
        button.backgroundColor = [UIColor clearColor];
        
        button.tag = 70+i;
        
        [button addTarget:self action:@selector(buildTouchTypeAction:) forControlEvents:UIControlEventTouchUpInside];
        
        if (iphone6P) {
            
            [self.view addSubview:leftLabel];
            
            [self.view addSubview:line];
            
            [self.view addSubview:button];
            
        }else{
            
            [_baseScrollView addSubview:leftLabel];
            
            [_baseScrollView addSubview:button];
            
            [_baseScrollView addSubview:line];
            
        }
        
    }
    
    UIButton *nextButton = [[UIButton alloc]initWithFrame:CGRectMake(47*x, height+290*x, DeviceWidth-94*x, 50*x)];
    
    nextButton.layer.cornerRadius = 25*x;
    
    [nextButton setTitle:@"下一步" forState:UIControlStateNormal];
    
    [nextButton addTarget:self action:@selector(buildToNextView:) forControlEvents:UIControlEventTouchUpInside];
    
    nextButton.titleLabel.font = [UIFont appFontRegularOfSize:14*x];
    
    nextButton.backgroundColor = UIColorFromRGB(0x32beff, 1.0);
    
    if (iphone6P) {
        
        [self.view addSubview:nextButton];
        
    }else{
        
        [_baseScrollView addSubview:nextButton];
        
        _baseScrollView.contentSize = CGSizeMake(DeviceWidth, nextButton.frame.origin.y+80*x);
        
    }
    
}

#pragma mark --> event Methods

//点击顶部照片视图
-(void)buildTouchTopImage:(UITapGestureRecognizer *)gest{
    
    if ([DefineSystemTool isGetCameraPermission]) {
       
        SCCaptureCameraController *con = [[SCCaptureCameraController alloc] init];
        con.scNaigationDelegate = self;
        con.iCardType = TIDCARD2;
        con.isDisPlayTxt = YES;
        [self presentViewController:con animated:YES completion:NULL];

        
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

// 获取身份证正面信息
- (void)sendIDCValue:(NSString *)name SEX:(NSString *)sex FOLK:(NSString *)folk BIRTHDAY:(NSString *)birthday ADDRESS:(NSString *) address NUM:(NSString *)num
{
    NSLog(@"idc  = %@\n%@\n%@\n%@\n%@\n%@\n",name,sex,folk,birthday,address,num);
    
    UIView *baseView;
    
    if (iphone6P) {
        
        baseView = self.view;
        
    }else{
        
        baseView = _baseScrollView;
        
    }
   
    //姓名
     UITextField *nameTextField = (UITextField *)[baseView viewWithTag:20];
    nameTextField.text = [name deleteSpeaceString];;
    //性别
    UILabel *sexLab = (UILabel *)[baseView viewWithTag:21];
    sexLab.text = [sex deleteSpeaceString];
    //出生年月
    UILabel *birthLab = (UILabel *)[baseView viewWithTag:22];
    birthLab.text = [birthday deleteSpeaceString];
    //家庭住址
    UILabel *addreLab = (UILabel *)[baseView viewWithTag:23];
    addreLab.text = [address deleteSpeaceString];
    
    
    
    //身份证号
    UILabel *numLab = (UILabel *)[baseView viewWithTag:24];
    numLab.text = [num deleteSpeaceString];
    
    _cardDictionary = [[NSMutableDictionary alloc]init];
    
    if (folk && folk.length > 0) {
        
        [_cardDictionary setObject:folk forKey:@"民族"];
    }
    
    if (nameTextField.text.length > 0) {
        
        [_cardDictionary setObject:nameTextField.text forKey:@"姓名"];
    }
    
    if ([sexLab.text isEqualToString:@"男"]) {
        
        [_cardDictionary setObject:@"10" forKey:@"性别"];
    }else if([sexLab.text isEqualToString:@"女"]){
        
        [_cardDictionary setObject:@"20" forKey:@"性别"];
    }else{
        
        sexLab.text = @"";
    }
    
    if (addreLab.text.length > 0) {
        
        [_cardDictionary setObject:addreLab.text forKey:@"家庭地址"];
    }
    
    if (birthLab.text.length > 0) {
        [_cardDictionary setObject:[birthLab.text buildChangeDay] forKey:@"出生年月"];
    }
    
    if (numLab.text.length > 0) {
        
        [_cardDictionary setObject:numLab.text forKey:@"身份号码"];
        
    }
    
}

//获取拍照的图片
- (void)sendTakeImage:(TCARD_TYPE) iCardType image:(UIImage *)cardImage
{
    
    if (cardImage) {
        
        NSData *data = UIImageJPEGRepresentation(_topImgView.image, ImageUpZScale);
        
        if (data && data.length > 0) {
            
            [[AppDelegate delegate].imagePutCache setObject:data forKey:@"身份证正面"];
            
            _topImgView.image = cardImage;
            
        }else{
           
            [self buildHeadError:@"证件识别错误，请重新识别"];
            
        }
   
        
    }else{
        
        [self buildHeadError:@"证件识别错误，请重新识别"];
    }
}


//点击姓名，性别等
-(void)buildTouchTypeAction:(UIButton *)sender{
    
    if (sender.tag == 70) {
        
        UITextField *text = (UITextField *)[self.view viewWithTag:20];
        
        if (text.text.length > 0) {
            
            text.userInteractionEnabled = YES;
            
            sender.userInteractionEnabled = NO;
            
        }else{
            
           [self buildTouchTopImage:nil];
            
        }
        
    }else{
        
        [self buildTouchTopImage:nil];
        
    }
    
}

//点击下一步方法
-(void)buildToNextView:(UIButton *)sender{
    
    UIView *baseView;
    
    if (iphone6P) {
        
        baseView = self.view;
        
    }else{
        
        baseView = _baseScrollView;
        
    }
    
    UITextField *textField = (UITextField *)[baseView viewWithTag:20];
    
    BOOL judge = YES;
    
    for (int i =1; i<5; i++) {
        
        UILabel *label = (UILabel *)[baseView viewWithTag:i+20];
        
        if (label.text.length == 0) {
            
            judge = NO;
            
            break;
            
        }
        
    }
    
    if (textField.text.length == 0) {
        
        [self buildHeadError:@"请使用扫描功能上传身份证信息"];
        
    }else if (!judge){
        
        [self buildHeadError:@"请使用扫描功能上传身份证信息"];
        
    }else{
        
        NSString *string = [_cardDictionary objectForKey:@"姓名"];
        
        if (![string isEqualToString:textField.text]) {
          
             [_cardDictionary setObject:textField.text forKey:@"最后姓名"];
            
        }else{
            
            if ([_cardDictionary objectForKey:@"最后姓名"]) {
                
             [_cardDictionary removeObjectForKey:@"最后姓名"];
                
            }
            
        }
        
        [self checkIDNumber];
        
    }

    
}

#pragma mark -->textField代理方法

-(void)textFieldDidEndEditing:(UITextField *)textField{
    
    textField.userInteractionEnabled = NO;
    
    UIButton *button = (UIButton *)[self.view viewWithTag:70];
    
    button.userInteractionEnabled = YES;
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    
    return YES;
    
}

#pragma mark --> 发起网络请求
- (void)checkIDNumber{
    //判断身份证号
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [BSVKHttpClient shareInstance].delegate = self;
    
    UIView *baseView;
    
    if (iphone6P) {
        
        baseView = self.view;
        
    }else{
        
        baseView = _baseScrollView;
        
    }
    
    UILabel *label = (UILabel *)[baseView viewWithTag:24];
    
    NSMutableDictionary *parm = [[NSMutableDictionary alloc]init];
    
    if (label.text.length > 0) {
        
        [parm setObject:label.text forKey:@"idNo"];
        
    }
    
    [[BSVKHttpClient shareInstance]getInfo:@"app/appserver/validate/checkIdNo" requestArgument:parm requestTag:CheckIDNumber requestClass:NSStringFromClass([self class])];
}

#pragma mark --> 网络代理协议

-(void)requestSucess:(NSInteger)requestTag requestResult:(id)responseObject requestClass:(NSString *)className{
    
    if ([className isEqualToString:NSStringFromClass([self class])]) {
        
        if (requestTag == CheckIDNumber) {
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            CheckIdNoModel *checkModel = [CheckIdNoModel mj_objectWithKeyValues:responseObject];
            
            [self analySisCheckModel:checkModel];
            
        }
        
    }
    
}

- (void)requestFail:(NSInteger)requestTag requestError:(NSError *)error httpCode:(NSInteger)httpCode requestClass:(NSString *)className
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    if ([className isEqualToString:NSStringFromClass([self class])])
    {
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

#pragma mark -- > 网络请求成功后的逻辑处理
- (void)analySisCheckModel:(CheckIdNoModel *)model{
    
    if ([model.head.retFlag isEqualToString:SucessCode]) {
        if ([model.body.flag isEqualToString:@"Y"]) {
           
            if (_delegate && [_delegate respondsToSelector:@selector(sendSaveInfoViewType:)]) {
                
                [_delegate sendSaveInfoViewType:CardPositiveType];
                
            }
           
        }else
        {
            
            [self buildHeadError:@"身份证输入有误，请检查"];
        }
    }else{
        
        [self buildHeadError:model.head.retMsg];
    }
}


@end
