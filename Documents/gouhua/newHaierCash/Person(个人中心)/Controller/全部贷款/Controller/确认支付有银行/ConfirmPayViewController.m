//
//  ConfirmPayViewController.m
//  personMerchants
//
//  Created by 陈相孔 on 16/3/31.
//  Copyright © 2016年 海尔金融. All rights reserved.
//

#import "ConfirmPayViewController.h"
#import "HCMacro.h"
#import "UIFont+AppFont.h"
#import "ResetPasswordViewController.h"
#import "AddBankViewController.h"
#import "BSVKHttpClient.h"
#import "RMUniversalAlert.h"
#import "RememberPasswordViModel.h"
#import <MJExtension.h>
#import "AppDelegate.h"
#import <MBProgressHUD.h>
#import "ActivePayLoanModel.h"
#import <MJExtension.h>
#import "BankIardInformation.h"
#import "ActivePayErModel.h"
#import "EnterAES.h"
#import "DefaultCardModel.h"
#import <MJExtension.h>
#import "RealNameViewController.h"
#import "ChangeDefaultBankModel.h"
@interface ConfirmPayViewController ()<UITableViewDelegate,UITableViewDataSource,CreditBankCardDelegate,BSVKHttpClientDelegate>{
    UILabel *bankMessage;
    
    UILabel *LastNumber;
    
    NSInteger currentSelected;
    
    UITextField * pwdTextField;
    
    NSMutableDictionary *_optionDic;
    
    NSInteger _putNumber;//记录请求次数
    
    ActivePayErModel *ERmodel;
    
    ActivePayLoanModel *FNmodel;
    
    NSString *cardSubNumber;//银行卡后四位
    NSString *changedCardNumber;//修改后的银行卡号
    DefaultCardModel *cardModel ;//默认还款卡model
}
@property(nonatomic,strong)UITableView *PayTable;

@end

@implementation ConfirmPayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.PayTable = [[UITableView alloc]initWithFrame:(CGRectMake(0, 10 * DeviceWidth/375, DeviceWidth,  115)) style:(UITableViewStylePlain)];
    self.navigationItem.title = @"确认支付";
    self.view.backgroundColor = [UIColor colorWithRed:237/255.0 green:238/255.0 blue:239/255.0 alpha:1.0];
    
    _optionDic = [[NSMutableDictionary alloc]init];
    
    if (_parmCard && _parmCard.length > 0) {
        if (_bankTyp && _bankTyp.length > 0) {
            
            [_optionDic setObject:_bankTyp forKey:@"bankType"];
        }else{
            //    查看银行卡类型
            [self searchBanktype];
        }
        if (_parmCard && _parmCard.length > 0) {
            
            cardSubNumber = [_parmCard substringFromIndex:_parmCard.length - 4];
            
        }
        
        [_optionDic setObject:StringOrNull(_bankName) forKey:@"bankName"];
    }else{
    
        [self getDefaultCard];//查询默认还款卡
    }
    [self setNavi];
    [self.PayTable registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    self.PayTable.delegate = self;
    self.PayTable.dataSource = self;
    
    self.PayTable.scrollEnabled = NO;
    
    self.PayTable.tableFooterView = [[UIView alloc]init];
    
    [self.view addSubview:self.PayTable];
    
    [self creatBtn];
    
    [self creatLabel];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 60;
    }else{
        return 55;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *reuseID = @"cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:reuseID];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    for (UIView *sub in cell.contentView.subviews) {
        
        [sub removeFromSuperview];
        
    }
    
    if (indexPath.row == 0) {
        
        
        UILabel * bankName = [[UILabel alloc]initWithFrame:(CGRectMake(18 *DeviceWidth/375, 10, 200, 20))];
        
        bankName.font = [UIFont systemFontOfSize:15];
        
        bankName.textColor = UIColorFromRGB(0x333333, 1.0);
        
        if ([_optionDic objectForKey:@"bankName"]) {
            
            bankName.text = [_optionDic objectForKey:@"bankName"];
            
        }
        
        //        截取银行卡后四位
        
        UILabel * _bankMessage = [[UILabel alloc]initWithFrame:(CGRectMake(CGRectGetMinX(bankName.frame), CGRectGetMaxY(bankName.frame) + 10, 40, 15))];
        
        _bankMessage.font = [UIFont systemFontOfSize:12];
        
        if ( [_optionDic objectForKey:@"bankType"]) {
            
            _bankMessage.text = [_optionDic objectForKey:@"bankType"];
            
        }
        
        _bankMessage.textColor = UIColorFromRGB(0xf6f6f6f, 1.0);
        
        UILabel  *_LastNumber = [[UILabel alloc]initWithFrame:(CGRectMake(CGRectGetMaxX(_bankMessage.frame)+ 8, CGRectGetMinY(_bankMessage.frame), 100, 15))];
        
        _LastNumber.font = [UIFont systemFontOfSize:12];
        
        if (cardSubNumber && cardSubNumber.length > 0) {
            
            _LastNumber.text = [NSString stringWithFormat:@"尾号为%@",cardSubNumber];
            
        }
        
        _LastNumber.textColor = UIColorFromRGB(0xf6f6f6f, 1.0);
        
        UIImageView * aceess = [[UIImageView alloc]initWithFrame:(CGRectMake(CGRectGetMaxX(self.PayTable.frame)- 30 *DeviceWidth/375, 22.5, 10, 15))];
        aceess.image = [UIImage imageNamed:@"箭头_右_灰"];
        
        [cell.contentView addSubview:bankName];
        
        [cell.contentView addSubview:_bankMessage];
        
        [cell.contentView addSubview:_LastNumber];
        
        [cell.contentView addSubview:aceess];
        
    }else if (indexPath.row == 1){
        
        UILabel *pwd = [[UILabel alloc]initWithFrame:(CGRectMake(18 *DeviceWidth/375,0, 100 *DeviceWidth/375, 55))];
        pwd.text = @"支付密码:";
        pwd.font = [UIFont systemFontOfSize:15];
        [cell.contentView addSubview:pwd];
        UITextField *txt = [[UITextField alloc]initWithFrame:(CGRectMake(CGRectGetMaxX(pwd.frame), CGRectGetMinY(pwd.frame), DeviceWidth - CGRectGetMaxX(pwd.frame), CGRectGetHeight(pwd.frame))) ];
        
        txt.font = [UIFont systemFontOfSize:14];
        txt.textAlignment = NSTextAlignmentLeft;
        txt.placeholder = @"请输入支付密码";
        txt.secureTextEntry = YES;
        pwdTextField = txt;
        [cell.contentView addSubview:txt];
        
    }
    
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        AddBankViewController *vc  =[[AddBankViewController alloc]init];
        
        vc.sumbitStr = @"1";
        
        vc.creditBankCardDelegate = self;
        
        [self.navigationController pushViewController:vc animated:YES];
    }
}
-(void)creatLabel{
    UILabel *fixedLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 160 *scaleAdapter, DeviceWidth - 10 *scaleAdapter, 20)];
    fixedLabel.text = @"忘记支付密码？";
    fixedLabel.textColor = UIColorFromRGB(0x32beff, 1.0);
    fixedLabel.textAlignment = NSTextAlignmentRight;
    fixedLabel.font = [UIFont appFontRegularOfSize:14];
    fixedLabel.userInteractionEnabled = YES;
    [self.view addSubview:fixedLabel];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(SingTap:)];
    tap.numberOfTapsRequired = 1;
    [fixedLabel addGestureRecognizer:tap];
}
-(void)creatBtn{
    UIButton *next = [[UIButton alloc]initWithFrame:(CGRectMake(25*DeviceWidth/375, 190*DeviceWidth/375, DeviceWidth - 50*DeviceWidth/375, 43))];
    next.backgroundColor = [UIColor colorWithRed:23/255.0 green:142/255.0 blue:227/255.0 alpha:1.0];
    next.layer.cornerRadius = 5;
    [next setTitle:@"确认支付" forState:(UIControlStateNormal)];
    [next addTarget:self action:@selector(nextStep:) forControlEvents:(UIControlEventTouchUpInside)];
    next.tintColor = [UIColor whiteColor];
    
    [self.view addSubview:next];
}
#pragma mark ----下一步
-(void)nextStep:(UIButton *)sender{
    
    [pwdTextField resignFirstResponder];
    
    BSVKHttpClient * client = [BSVKHttpClient shareInstance];
    
    client.delegate = self;
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    
    NSString *userId = StringOrNull([AppDelegate delegate].userInfo.userId);
    
    [dict setObject:[EnterAES simpleEncrypt:userId] forKey:@"userId"];
    
    [dict setObject:[EnterAES simpleEncrypt:pwdTextField.text] forKey:@"payPasswd"];
    
    [client getInfo:@"app/appserver/uauth/validatePayPasswd" requestArgument:dict requestTag:1 requestClass:NSStringFromClass([self class])];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark ----设置导航
- (void)setNavi {
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = ReturnRect;
    [backBtn setImage:[UIImage imageNamed:@"返回_黑"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(OnBackBtn:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
}

- (void)OnBackBtn:(UIButton *)btn {
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark -- 分割线
- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    if ([self.PayTable respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.PayTable setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([self.PayTable respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.PayTable setLayoutMargins:UIEdgeInsetsZero];
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

-(void)SingTap:(UITapGestureRecognizer *)recognizer{
    
    RealNameViewController *real = [[RealNameViewController alloc]init];
//    real.flowName = changeDealPwdByNoRemeber;
    [self.navigationController pushViewController:real animated:YES];
}
#pragma mark ----改变银行卡的代理方法-------
-(void)changeBank:(NSString *)sumbit last:(NSString *)num bankName:(NSString *)name{
    
    NSString * message = [num substringFromIndex:num.length - 4];
    
    if (sumbit && sumbit.length > 0) {
        
        [_optionDic setObject:sumbit forKey:@"bankType"];
        
    }
    
    if (name && name.length > 0) {
        
        [_optionDic setObject:name forKey:@"bankName"];
        
    }
    
    _parmCard = num;
    
    cardSubNumber = message;
    
    [self.PayTable reloadData];
}
#pragma mark ---- 密码验证delegate---------
- (void)requestFail:(NSInteger)requestTag requestError:(NSError *)error httpCode:(NSInteger)httpCode requestClass:(NSString *)className{
    if ([className isEqualToString:NSStringFromClass([self class])]) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        NSString *errorStr;
        if(httpCode != 0)
        {
            errorStr = [NSString stringWithFormat:@"网络环境异常，请检查网络并重试(%ld)",(long)httpCode];
        }
        else
        {
            errorStr = @"网络环境异常，请检查网络并重试";
        }

        WEAKSELF
        [RMUniversalAlert showAlertInViewController:self withTitle:@"提示" message:errorStr cancelButtonTitle:@"确定" destructiveButtonTitle:nil otherButtonTitles:nil tapBlock:^(RMUniversalAlert * _Nonnull alert, NSInteger buttonIndex) {
            STRONGSELF
            if (strongSelf) {
                if (buttonIndex == 0) {
                    
                    return ;
                }
            }
        }];
    }
}
- (void)requestSucess:(NSInteger)requestTag requestResult:(id)responseObject requestClass:(NSString *)className{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    if ([className isEqualToString:NSStringFromClass([self class])]) {
        if (requestTag == 1) {
            RememberPasswordViModel *model = [RememberPasswordViModel mj_objectWithKeyValues:responseObject];
            if ([model.head.retFlag isEqualToString:@"00000"]) {
                //            进行还款
                [self payAllLoanActively];
                
            }else{
            
                [self buildHeadError:model.head.retMsg];
            }
        }else if (requestTag == 3){//主动还款
            
            FNmodel = [ActivePayLoanModel mj_objectWithKeyValues:responseObject];
            
            ERmodel = [ActivePayErModel mj_objectWithKeyValues:responseObject];
            if ([FNmodel.head.retFlag isEqualToString:@"00000"]) {
                WEAKSELF
                [RMUniversalAlert showAlertInViewController:self withTitle:@"提示" message:@"申请还款成功!" cancelButtonTitle:@"知道了" destructiveButtonTitle:nil otherButtonTitles:nil tapBlock:^(RMUniversalAlert * _Nonnull alert, NSInteger buttonIndex) {
                    STRONGSELF
                    if (strongSelf) {
                        if (buttonIndex == 0) {
                            NSArray*vcArr = strongSelf.navigationController.viewControllers;
                            [strongSelf.navigationController popToViewController:vcArr[0] animated:YES];
                            ;
                        }
                    }
                    
                }];
                
            }else{
            
                [self buildHeadError:FNmodel.head.retMsg];
            }
        }else if (requestTag == 30){
            
            ActivePayLoanModel *model = [ActivePayLoanModel mj_objectWithKeyValues:responseObject];
            
            if ([model.head.retFlag isEqualToString:@"00000"]) {
                BOOL isSuccess = YES;
                for (ActivePayLoanInfo *info in model.body.activePayLoanList) {
                    if ([info.isSuccess isEqualToString:@"N"]) {
                        isSuccess = NO;
                        break;
                    }
                }
                NSString *warningMessage;
                if (isSuccess) {
                    warningMessage = @"申请还款成功!";
                } else {
                    warningMessage = @"部分还款成功。";
                }
                
                WEAKSELF
                [RMUniversalAlert showAlertInViewController:self withTitle:@"提示" message:warningMessage cancelButtonTitle:@"知道了" destructiveButtonTitle:nil otherButtonTitles:nil tapBlock:^(RMUniversalAlert * _Nonnull alert, NSInteger buttonIndex) {
                    STRONGSELF
                    if (strongSelf) {
                        if (buttonIndex == 0) {
                            
                            [strongSelf.navigationController popToRootViewControllerAnimated:YES];
                            
                        }
                    }
                    
                }];
                
                
            }else{
            
                [self buildHeadError:model.head.retMsg];
            }
        }else if (requestTag == 4){//查看银行卡类型
            
            BankIardInformation *banktype = [BankIardInformation mj_objectWithKeyValues:responseObject];
            
            if ([banktype.head.retFlag isEqualToString:@"00000"]) {
                
                if (banktype.body.cardType && banktype.body.cardType.length > 0) {
                    
                    [_optionDic setObject:banktype.body.cardType forKey:@"bankType"];
                    
                }
                
                [self.PayTable reloadData];
                
            }
        }else if (requestTag == 12){
            //        查询默认还款卡
            cardModel = [DefaultCardModel mj_objectWithKeyValues:responseObject];
            if ([cardModel.head.retFlag isEqualToString:@"00000"]) {
                
                NSString *cardNum = [cardModel.body.cardNo substringWithRange:NSMakeRange(cardModel.body.cardNo.length - 4, 4)];
                
                cardSubNumber = cardNum;//卡号
                
                _parmCard = cardModel.body.cardNo;
                
                if ( cardModel.body.cardTypeName && cardModel.body.cardTypeName.length > 0) {
                    
                    [_optionDic setObject:cardModel.body.cardTypeName forKey:@"bankType"];
                    
                }
                
                if (cardModel.body.bankName && cardModel.body.bankName.length > 0) {
                    
                    [_optionDic setObject:cardModel.body.bankName forKey:@"bankName"];
                    
                }
                
                [self.PayTable reloadData];
                
            }else{
                
//                NSString * temporary = [AppDelegate delegate].userInfo.cardType;
                
//                if (temporary && temporary.length > 0) {
//                    
//                    [_optionDic setObject:temporary forKey:@"还款卡类型"];
//                    
//                }
                
                NSString *bank = [AppDelegate delegate].userInfo.bankName;
                
                if (bank && bank.length > 0) {
                    
                    [_optionDic setObject:bank forKey:@"银行"];
                    
                }
                
                NSString *cardNum = [[AppDelegate delegate].userInfo.realCard substringWithRange:NSMakeRange([AppDelegate delegate].userInfo.realCard.length - 4, 4)];
                cardSubNumber = cardNum;//卡号
                _parmCard = [AppDelegate delegate].userInfo.realCard;
                [self.PayTable reloadData];
                
            }
        }
    }
}
#pragma mark----进行还款-------
- (void)payAllLoanActively{
    
    
    if (_parmAray && _parmAray.count > 0) {
        
        _putNumber = 0;
        
        NSMutableArray *listArray = [[NSMutableArray alloc]init];
        
        for (NSMutableDictionary *parm  in _parmAray) {
            
            if (_parmCard && _parmCard.length  >0) {
                
                [parm setObject:_parmCard forKey:@"cardNo"];
                
            }
            
            [listArray addObject:parm];
            
        }
        
        BSVKHttpClient *payClient = [BSVKHttpClient shareInstance];
        
        payClient.delegate = self;
        
        //        NSMutableDictionary *parm = _parmAray[_putNumber];
        
        [payClient postInfo:@"app/appserver/customer/zdhkResByList" requestArgument:@{@"list":listArray} requestTag:30 requestClass:NSStringFromClass([self class])];
        
    }else{
        
        BSVKHttpClient *payClient = [BSVKHttpClient shareInstance];
        
        payClient.delegate = self;
        
        NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
        
        [parmDict setObject:_loanNo forKey:@"LOAN_NO"];//借据号
        
        [parmDict setObject:_payMode forKey:@"PAYM_MODE"];//还款模式
        
        [parmDict setObject:[NSString stringWithFormat:@"%@",_totalAmt]forKey:@"ACTV_PAY_AMT"];//还款金额
        if (_parmCard && _parmCard.length > 0) {
            
            [parmDict setObject:_parmCard forKey:@"cardNo"];
            
        }
        //    主动还款
        [payClient postInfo:@"app/appserver/customer/zdhkRes" requestArgument:parmDict requestTag:3 requestClass:NSStringFromClass([self class])];
    }
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}
#pragma mark ---查看银行卡类型
- (void)searchBanktype{
    BSVKHttpClient *client = [BSVKHttpClient shareInstance];
    client.delegate = self;
    NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
    [parmDict setObject:StringOrNull(_parmCard) forKey:@"cardNo"];
    [client getInfo:@"app/appserver/crm/cust/getBankInfo" requestArgument:parmDict requestTag:4 requestClass:NSStringFromClass([self class])];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}
//查询默认还款卡
-(void)getDefaultCard{
    BSVKHttpClient *client = [BSVKHttpClient shareInstance];
    client.delegate = self;
    NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
    [parmDict setObject:[AppDelegate delegate].userInfo.custNum forKey:@"custNo"];
    [client getInfo:@"app/appserver/crm/cust/getDefaultBankCard" requestArgument:parmDict requestTag:12 requestClass:NSStringFromClass([self class])];
    
}

//连接服务器成功后，返回的报文头信息
- (void)buildHeadError:(NSString *)error
{
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
