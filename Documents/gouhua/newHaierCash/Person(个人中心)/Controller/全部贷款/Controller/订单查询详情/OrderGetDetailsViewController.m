//
//  OrderGetDetailsViewController.m
//  personMerchants
//
//  Created by 百思为科 on 16/6/14.
//  Copyright © 2016年 海尔金融. All rights reserved.
//

#import "OrderGetDetailsViewController.h"
#import "HCMacro.h"
#import "UIFont+AppFont.h"
//#import "StageApplicationViewController.h"
#import "BSVKHttpClient.h"
#import <MBProgressHUD.h>
#import "UIButton+UnifiedStyle.h"
#import "RMUniversalAlert.h"
#import "ConfirmPayNoBankViewController.h"
#import "AppDelegate.h"
//#import "StageViewController.h"
#import "UILabel+SizeForStr.h"
#import "ApprovalProgressViewController.h"
//#import "GoodsStageDetailViewController.h"
#import <YYWebImage.h>
#import "StageApplicationModel.h"
#import "ChangDefaultBankView.h"
#import "AddBankViewController.h"
#import "ChangeDefaultBankModel.h"
#import "BankLIstMode.h"
#import "WhiteSearchModel.h"
#import "IndetityStore.h"
#import "CheckListModel.h"
#import "OrdeDetailsModel.h"
#import "InquiryModel.h"
#import "UpdateMsgStatusModel.h"
//#import "WareDetailModel.h"


@interface OrderGetDetailsViewController ()<UITableViewDelegate,UITableViewDataSource, BSVKHttpClientDelegate,ChoiceDefaultBankDelegate>
{
    
    NSString * _haveMenu; //判断有无套餐
    
    NSString * _bankName;
    
    NSString * _bankNumber;
    
    WhiteSearchModel *_searchModel;
}
@property (nonatomic,strong) UILabel *timeLabel;

@property (nonatomic,strong) NSArray *arrGoods;

@property (nonatomic,strong) UILabel *priManey; //分期本金

@property (nonatomic,strong) UILabel *divManey; //利息

@property (nonatomic,strong) UILabel *totalManey; //总金额

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) ChangDefaultBankView *changeBankView;

@property (nonatomic,strong) OrdeDetailsModel * orderDetailsModel;

@end

@implementation OrderGetDetailsViewController
#pragma mark -- lift cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title  =@"订单详情";
    self.view.backgroundColor = UIColorFromRGB(0xf6f6f6, 1.0);
    
    if (_msgId) {
        
        [self updateMsgStatus];
    }
    [AppDelegate delegate].userInfo.bReturn = YES;

    [self setNavi];

    [self creatDetailReq];
    
}

#pragma mark -- setting and getting
// 表头
-(void)setTableViewHeaderView{
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DeviceWidth, 134)];
    
    _changeBankView = [[ChangDefaultBankView alloc]init];
    
    _changeBankView.frame = CGRectMake(0, 0, DeviceWidth, 104);
    
    [headerView addSubview:_changeBankView];
    
    if (_loanName == waitSubmitCash) {
        _changeBankView.stateLabel.text = @"待提交";
    }
    else if (_loanName == waitSubmitLoan || _loanName == MsgWaitSubmitCash){
        _changeBankView.stateLabel.text = @"待提交";
    }
    else if (_loanName == BeReturnLoanByMerchant){
        _changeBankView.stateLabel.textAlignment = NSTextAlignmentRight;
        _changeBankView.stateLabel.text = @"商户退回";
        
        UILabel *reasonLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(_changeBankView.stateImage.frame), CGRectGetMaxY(_changeBankView.stateImage.frame)+5, DeviceWidth - 20, 20)];
        reasonLabel.text = [NSString stringWithFormat:@"退回原因:%@",_orderDetailsModel.body.backReason];
        
        reasonLabel.textColor = [UIColor whiteColor];
        
        reasonLabel.font = [UIFont appFontRegularOfSize:14];
        
        CGFloat labelHeight = [reasonLabel boundingRectWithSize:CGSizeMake(DeviceWidth - 20,0)].height;
        
        reasonLabel.frame = CGRectMake(CGRectGetMinX(_changeBankView.stateImage.frame), CGRectGetMaxY(_changeBankView.stateImage.frame)+5, DeviceWidth - 20, labelHeight);
        
        reasonLabel.numberOfLines = 0;
        
        [_changeBankView.topView addSubview:reasonLabel];
        
        headerView.frame = CGRectMake(0, 0, DeviceWidth, 134 + 5 + labelHeight);
        
        _changeBankView.frame = CGRectMake(0, 0, DeviceWidth, 104 + 5 + labelHeight);
        
        _changeBankView.topView.frame = CGRectMake(0, 0, DeviceWidth, 40 + 5 +labelHeight);
        
        _changeBankView.bottomView.frame = CGRectMake(0, CGRectGetMaxY(_changeBankView.topView.frame), DeviceWidth, 54);
        
        _changeBankView.thirdView.frame = CGRectMake(0, CGRectGetMaxY(_changeBankView.bottomView.frame), DeviceWidth, 10);
    }
    
    _changeBankView.defaultBankLabel.text = StringOrNull(_orderDetailsModel.body.repayAccBankName);
    
    if (_orderDetailsModel.body.repayApplCardNo.length > 4) {
        NSString * message = [_orderDetailsModel.body.repayApplCardNo substringFromIndex:_orderDetailsModel.body.repayApplCardNo.length - 4];
        
        _changeBankView.bankNumberLabel.text = [NSString stringWithFormat:@"****%@",message];
    }else{
        
        _changeBankView.bankNumberLabel.text = @"";
    }
    
    
    _changeBankView.arrow.hidden = NO;
    
    UITapGestureRecognizer *tapGuest = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(changeBank)];
    
    [_changeBankView.bottomView addGestureRecognizer:tapGuest];
    
    UILabel *timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(_changeBankView.frame), 160, 30)];
    if (iphone6P) {
        timeLabel.frame = CGRectMake(20, CGRectGetMaxY(_changeBankView.frame), 160, 30);
        timeLabel.font = [UIFont appFontRegularOfSize:12];
    }else{
        timeLabel.font = [UIFont appFontRegularOfSize:11];
    }
    
    timeLabel.text = _timeLabel.text;
    [headerView addSubview:timeLabel];
    
    UILabel *numberLabel = [[UILabel alloc]initWithFrame:CGRectMake(DeviceWidth - 160, CGRectGetMaxY(_changeBankView.frame), 140, 30)];
    numberLabel.font = [UIFont appFontRegularOfSize:12];
    numberLabel.textAlignment = NSTextAlignmentCenter;
    [headerView addSubview:numberLabel];
    _tableView.tableHeaderView = headerView;
}
// 表尾
-(void)setTableViewFooterView{
    UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DeviceWidth, 110)];
    UIView *topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DeviceWidth, 0.5)];
    topView.backgroundColor = UIColorFromRGB(0xececec,1.0);
    [footView addSubview:topView];
    
    UILabel * pricipalLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(topView.frame) + 15 , DeviceWidth/3, 14)];
    
    pricipalLabel.textAlignment=NSTextAlignmentCenter;
    
    pricipalLabel.text=@"分期本金（元）";
    
    pricipalLabel.font=[UIFont appFontRegularOfSize:13];
    
    pricipalLabel.textColor=UIColorFromRGB(0x343434, 1.0);
    
    [footView addSubview:pricipalLabel];
    
    _priManey=[[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(pricipalLabel.frame) +13, DeviceWidth/3, CGRectGetHeight(pricipalLabel.frame))];
    
    _priManey.textAlignment=NSTextAlignmentCenter;
    //     分期本金 = 借款总额
    _priManey.text =[NSString stringWithFormat:@"%.2f",[_orderDetailsModel.body.applyAmt floatValue]];
    
    _priManey.font = [UIFont appFontRegularOfSize:13];
    
    _priManey.textColor=UIColorFromRGB(0xff5500, 1.0);
    
    [footView addSubview:_priManey];
    
    UILabel * dividendLabel=[[UILabel alloc]initWithFrame:CGRectMake(DeviceWidth/3, CGRectGetMinY(pricipalLabel.frame), DeviceWidth/3, CGRectGetHeight(pricipalLabel.frame))];
    
    dividendLabel.textAlignment=NSTextAlignmentCenter;
    
    dividendLabel.text=@"息费（元）";
    
    dividendLabel.font=[UIFont appFontRegularOfSize:13];
    
    dividendLabel.textColor=UIColorFromRGB(0x333333, 1.0);
    
    [footView addSubview:dividendLabel];
    
    _divManey=[[UILabel alloc]initWithFrame:CGRectMake(DeviceWidth/3,CGRectGetMinY(_priManey.frame), DeviceWidth/3, CGRectGetHeight(pricipalLabel.frame))];
    _divManey.font=[UIFont appFontRegularOfSize:13];
    
    _divManey.textAlignment=NSTextAlignmentCenter;
    
    
    //    息费总额
    if ([_orderDetailsModel.body.applyTnrTyp isEqualToString:@"D"]||[_orderDetailsModel.body.applyTnrTyp isEqualToString:@"d"]) {
        _divManey.text = [NSString stringWithFormat:@"按日计息\n每日%@元",_orderDetailsModel.body.rlx];
        CGFloat totalManeyHeight = [_divManey boundingRectWithSize:CGSizeMake(DeviceWidth/3,0)].height;
        if (totalManeyHeight < 14) {
            totalManeyHeight = 14;
        }
        _divManey.numberOfLines = 0;
        _divManey.frame = CGRectMake(DeviceWidth/3,CGRectGetMaxY(pricipalLabel.frame) + 8, DeviceWidth/3, totalManeyHeight);
    }else{
        
        _divManey.text= [NSString stringWithFormat:@"%.2f",[_orderDetailsModel.body.xfze floatValue]];
    }
    
    
    _divManey.textColor = UIColorFromRGB(0xff5500, 1.0);
    
    [footView addSubview:_divManey];
    
    UILabel * totalLabel=[[UILabel alloc]initWithFrame:CGRectMake(DeviceWidth*2/3, CGRectGetMinY(pricipalLabel.frame), DeviceWidth/3, CGRectGetHeight(pricipalLabel.frame))];
    
    totalLabel.textAlignment=NSTextAlignmentCenter;
    
    totalLabel.text=@"合计金额（元）";
    
    totalLabel.font=[UIFont appFontRegularOfSize:13];
    
    totalLabel.textColor=UIColorFromRGB(0x343434, 1.0);
    
    [footView addSubview:totalLabel];
    
    _totalManey=[[UILabel alloc]initWithFrame:CGRectMake(DeviceWidth*2/3, CGRectGetMaxY(pricipalLabel.frame) + 13, DeviceWidth/3, CGRectGetHeight(pricipalLabel.frame))];
    _totalManey.font=[UIFont appFontRegularOfSize:13];
    _totalManey.textAlignment=NSTextAlignmentCenter;
    //    合计金额
    if ([_orderDetailsModel.body.applyTnrTyp isEqualToString:@"D"]||[_orderDetailsModel.body.applyTnrTyp isEqualToString:@"d"]) {
        _totalManey.text= [NSString stringWithFormat:@"本金+%@元/日",_orderDetailsModel.body.rlx];
        CGFloat totalManeyHeight = [_totalManey boundingRectWithSize:CGSizeMake(DeviceWidth/3,0)].height;
        if (totalManeyHeight < 14) {
            totalManeyHeight = 14;
        }
        _totalManey.numberOfLines = 0;
        _totalManey.frame = CGRectMake(DeviceWidth*2/3,CGRectGetMaxY(pricipalLabel.frame) +13, DeviceWidth/3, totalManeyHeight);
    }else{
        _totalManey.text=[NSString stringWithFormat:@"%.2f",[_orderDetailsModel.body.applyAmt floatValue] + [_orderDetailsModel.body.xfze floatValue]];
    }
    
    
    _totalManey.textColor = UIColorFromRGB(0xff5500, 1.0);
    
    [footView addSubview:_totalManey];
    
    UIView *viewSep=[[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_totalManey.frame) + 21, DeviceWidth, 1)];
    
    viewSep.backgroundColor=UIColorFromRGB(0xececec, 1.0);
    
    [footView addSubview:viewSep];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    
    button.frame = CGRectMake(DeviceWidth - 90, CGRectGetMaxY(viewSep.frame) + 5, 80, 30);
    if (iphone6P) {
        
        button.frame = CGRectMake(DeviceWidth - 100, CGRectGetMaxY(viewSep.frame) + 5, 80, 30);
    }
    if (_loanName == waitSubmitCash) {
    [button setButtonTitle:@"继续提交" titleFont:13 buttonHeight:30];
    [button addTarget:self action:@selector(toCashViewController) forControlEvents:UIControlEventTouchUpInside];
    }
    
    else if (_loanName == waitSubmitLoan|| _loanName == MsgWaitSubmitCash){
    [button setButtonTitle:@"继续提交" titleFont:13 buttonHeight:30];
    [button addTarget:self action:@selector(toCashViewController) forControlEvents:UIControlEventTouchUpInside];
    }
    else if (_loanName == BeReturnLoanByMerchant){
    [button setButtonTitle:@"修改提交" titleFont:13 buttonHeight:30];

    [button addTarget:self action:@selector(returnToPerfectViewController) forControlEvents:UIControlEventTouchUpInside];
    }
        
    button.layer.borderColor = UIColorFromRGB(0xf6f6f6, 1.0).CGColor;
    
    button.layer.borderWidth = 0.5f;
    
    [footView addSubview:button];
    
    UIView *bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(button.frame) + 5, DeviceWidth, 0.5)];
    
    bottomView.backgroundColor = UIColorFromRGB(0xececec, 1.0);
    
    [footView addSubview:bottomView];
    
    _tableView.tableFooterView = footView;
}
-(void)setTableView{
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,0,DeviceWidth, DeviceHeight - 64) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.tableFooterView = [[UITableView alloc]initWithFrame:CGRectZero];
    [self.view addSubview:_tableView];
    
    [self setTableViewHeaderView];
    
    [self setTableViewFooterView];
}
#pragma mark -- tableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _arrGoods.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 90 * scaleAdapter;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        
        UIView *bjView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DeviceWidth, 80*scaleAdapter)];
        bjView.tag = 1;
        [cell.contentView addSubview:bjView];
        
        UIImageView *img = [[UIImageView alloc]initWithFrame:CGRectMake(10, 5*scaleAdapter, 80*scaleAdapter, 70*scaleAdapter)];
        if (iphone6P) {
            img.frame = CGRectMake(20, 5*scaleAdapter, 80*scaleAdapter, 70*scaleAdapter);
        }
        img.tag = 10;
        [bjView addSubview:img];
        
        UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(img.frame) + 3, 0, 150, 80*scaleAdapter)];
        nameLabel.tag = 11;
        nameLabel.font = [UIFont appFontRegularOfSize:13];
        [bjView addSubview:nameLabel];
        
        UILabel *moneyLabel = [[UILabel alloc]initWithFrame:CGRectMake(DeviceWidth -  120, 0, 110, 80*scaleAdapter)];
        if (iphone6P) {
            
            moneyLabel.frame = CGRectMake(DeviceWidth -  130, 0, 110, 80*scaleAdapter);
        }
        moneyLabel.tag = 12;
        moneyLabel.textAlignment = NSTextAlignmentRight;
        moneyLabel.font = [UIFont systemFontOfSize:12];
        [bjView addSubview:moneyLabel];
        
        UIView *bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, 80*scaleAdapter, DeviceWidth, 10*scaleAdapter)];
        bottomView.tag = 13;
        [cell.contentView addSubview:bottomView];
    }
    
    
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UIView *bjView = [(UIView *)cell.contentView viewWithTag:1];
    
    bjView.backgroundColor = UIColorFromRGB(0xf6f6f6, 1.0);
    
    UIImageView *img = [(UIImageView *)bjView viewWithTag:10];
    
    UILabel *nameLabel = [(UILabel *)bjView viewWithTag:11];
    
    NSString * nameStr;
    
    if([_orderDetailsModel.body.goods[indexPath.row].goodsName rangeOfString:@"goodname"].location !=NSNotFound)//_roaldSearchText
    {
        NSRange range  = [_orderDetailsModel.body.goods[indexPath.row].goodsName rangeOfString:@"goodname"];
        
        nameStr = [_orderDetailsModel.body.goods[indexPath.row].goodsName substringFromIndex:range.location+range.length];  //名称
    }
    else
    {
        nameStr = _orderDetailsModel.body.goods[indexPath.row].goodsName;
    }
    nameLabel.text = [NSString stringWithFormat:@"%@ x %@",nameStr,_orderDetailsModel.body.goods[indexPath.row].goodsNum];
    
    NSString *strUrl = [NSString stringWithFormat:@"%@%@%@",baseUrl,_orderDetailsModel.body.goods[indexPath.row].goodsName,_orderDetailsModel.body.goods[indexPath.row].goodsCode];
    
    [img yy_setImageWithURL:[NSURL URLWithString:strUrl] placeholder:[UIImage imageNamed:@"贷款列表默认图片"] options:YYWebImageOptionProgressiveBlur completion:nil];
    if (_orderDetailsModel.body.goods.count > 0) {
        if(_orderDetailsModel.body.goods[0].goodsCode && _orderDetailsModel.body.goods[0].goodsCode.length > 0)
        {
            if([(id)[[AppDelegate delegate].imagePutCache objectForKey:[NSString stringWithFormat:@"%@pub/gm/getGoodsPic?goodsCode=%@",baseUrl,_orderDetailsModel.body.goods[0].goodsCode]] isKindOfClass:[UIImage class]])
            {
                UIImage *tempData =(UIImage *)[[AppDelegate delegate].imagePutCache objectForKey:[NSString stringWithFormat:@"%@pub/gm/getGoodsPic?goodsCode=%@",baseUrl,_orderDetailsModel.body.goods[0].goodsCode]];
                img.image = tempData;
            }else if ([(id)[[AppDelegate delegate].imagePutCache objectForKey:[NSString stringWithFormat:@"%@pub/gm/getGoodsPic?goodsCode=%@",baseUrl,_orderDetailsModel.body.goods[0].goodsCode]] isKindOfClass:[NSData class]])
            {
                NSData *tempData =(NSData *)[[AppDelegate delegate].imagePutCache objectForKey:[NSString stringWithFormat:@"%@pub/gm/getGoodsPic?goodsCode=%@",baseUrl,_orderDetailsModel.body.goods[0].goodsCode]];
                img.image = [UIImage imageWithData:tempData];
            }else
            {
                img.image = [UIImage imageNamed:@"贷款列表默认图片"];
                [[YYWebImageManager sharedManager]requestImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@pub/gm/getGoodsPic?goodsCode=%@",baseUrl,_orderDetailsModel.body.goods[0].goodsCode]] options:YYWebImageOptionShowNetworkActivity progress:nil transform:nil completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
                    if (image) {
                        [[AppDelegate delegate].imagePutCache setObject:image forKey:url.absoluteString];
                        img.image = image;
                    }
                }];
            }
        }
        else
        {
            img.image = [UIImage imageNamed:@"贷款列表默认图片"];
        }
    }else{
        img.image = [UIImage imageNamed:@"贷款列表默认图片"];
    }
    
    UILabel *moneyLabel = [(UILabel *)bjView viewWithTag:12];
    
    moneyLabel.text = [NSString stringWithFormat:@"%.2f元",[_orderDetailsModel.body.goods[indexPath.row].goodsPrice floatValue]];
    
    UIView *bottomView = [(UIView *)cell.contentView viewWithTag:13];
    
    bottomView.backgroundColor = [UIColor whiteColor];
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}


#pragma mark -private Methods
-(void)toCashViewController{
    
    [self setAllowRequest];
}
- (void)contionToNext{
    //                    跳转到现金贷
//    StageViewController * vc = [[StageViewController alloc]init];
//    vc.orderDetailsBody = _orderDetailsModel.body;
//    vc.flowName = WaitSubmitCashLoan;
//    [self.navigationController pushViewController:vc animated:YES];
}
// 查询无额度用户审批进度
- (void)queryProgress{
    
    ApprovalProgressViewController *vc = [[ApprovalProgressViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)toStageAppViewController
{

//    
//    [AppDelegate delegate].userInfo.applSeq = _orderDetailsModel.body.applseq;
//    NSString *packAgeStr;//套餐名
//    if([_orderDetailsModel.body.goods[0].goodsName rangeOfString:@"goodname"].location != NSNotFound)//
//    {
//        NSRange range  = [_orderDetailsModel.body.goods[0].goodsName rangeOfString:@"goodname"];
//        
//        packAgeStr = [_orderDetailsModel.body.goods[0].goodsName substringToIndex:range.location];  //套餐
//    }
//    else
//    {
//        packAgeStr = @"";
//    }
//    
//    if ([self.formTyp isEqualToString:@"20"]) {
//        GoodsStageDetailViewController *goods = [[GoodsStageDetailViewController alloc]init];
//        
//        goods.flowName = WaitAdvertStage;
//        
//        goods.merchantCode = _orderDetailsModel.body.merchNo;
//        
//        goods.strManagerID = _orderDetailsModel.body.crtUsr;
//        
//        goods.ordeDetailsBody = _orderDetailsModel;
//        
//        [self.navigationController pushViewController:goods animated:YES];
//    }else{
//        
//        StageApplicationViewController *goods = [[StageApplicationViewController alloc]init];
//        
//        goods.flowName = WaitSubmitStage;
//        
//        if (packAgeStr.length > 0)
//        {
//            goods.scantype = goodHasMenuEnter;
//        }else
//        {
//            goods.scantype = goodNoMenuEnter;
//        }
//        goods.merchantCode = _orderDetailsModel.body.merchNo;
//        
//        goods.strManagerID = _orderDetailsModel.body.crtUsr;
//        
//        goods.ordeDetailsBody = _orderDetailsModel;
//        
//        goods.scanInfoModel = [[ScanTableModel alloc]init];
//      
//        goods.scanInfoModel.goodBrand = _orderDetailsModel.body.goods[0].goodsBrand;
//        
//        goods.scanInfoModel.goodKind = _orderDetailsModel.body.goods[0].goodsKind;
//        
//        [self.navigationController pushViewController:goods animated:YES];            }
}

-(void)returnToPerfectViewController
{
//
//    [AppDelegate delegate].userInfo.applSeq = _orderDetailsModel.body.applseq;
//    
//    NSString *packAgeStr;
//    
//    if([_orderDetailsModel.body.goods[0].goodsName rangeOfString:@"goodname"].location != NSNotFound)//_roaldSearchText
//    {
//        NSRange range  = [_orderDetailsModel.body.goods[0].goodsName rangeOfString:@"goodname"];
//        
//        packAgeStr = [_orderDetailsModel.body.goods[0].goodsName substringToIndex:range.location];  //套餐
//    }
//    else
//    {
//        packAgeStr = @"";
//    }
//    if ([self.formTyp isEqualToString:@"20"]) {
//        GoodsStageDetailViewController *goods = [[GoodsStageDetailViewController alloc]init];
//        
//        goods.flowName = AdvertReturnByMerchant;
//        
//        goods.merchantCode = _orderDetailsModel.body.merchNo;
//        
//        goods.strManagerID = _orderDetailsModel.body.crtUsr;
//        
//        goods.ordeDetailsBody = _orderDetailsModel;
//        
//        [self.navigationController pushViewController:goods animated:YES];
//    }else{
//        
//        StageApplicationViewController *goods = [[StageApplicationViewController alloc]init];
//        
//        goods.flowName = BeReturnByMerchant;
//        
//        if (packAgeStr.length > 0)
//        {
//            goods.scantype = goodHasMenuEnter;
//        }else
//        {
//            goods.scantype = goodNoMenuEnter;
//        }
//        goods.merchantCode = _orderDetailsModel.body.merchNo;
//        
//        goods.strManagerID = _orderDetailsModel.body.crtUsr;
//        
//        goods.ordeDetailsBody = _orderDetailsModel;
//        
//        goods.scanInfoModel = [[ScanTableModel alloc]init];
//        
//        goods.scanInfoModel.goodBrand = _orderDetailsModel.body.goods[0].goodsBrand;
//        goods.scanInfoModel.goodKind = _orderDetailsModel.body.goods[0].goodsKind;
//        
//        [self.navigationController pushViewController:goods animated:YES];            }
}
- (void)toStageApplicationViewControllerByGoodNoMenuEnter
{
//    StageApplicationViewController * vc = [[StageApplicationViewController alloc]init];
//    
//    vc.ordeDetailsBody = _orderDetailsModel;
//    vc.strManagerID = StringOrNull(_orderDetailsModel.body.crtUsr);
//    
//    if (_loanName == BeReturnLoanByMerchant) {
//        vc.flowName = BeReturnByMerchant;  //商户被退回商品贷
//    }else if (_loanName == waitSubmitLoan || _loanName == MsgWaitSubmitCash){
//        vc.flowName = WaitSubmitCashLoan;
//    }
//    
//    vc.scantype = goodNoMenuEnter;
//    
//    vc.merchantCode = StringOrNull(_orderDetailsModel.body.merchNo);//商户编码
//    
//    vc.scanInfoModel = [[ScanTableModel alloc]init];
//    vc.scanInfoModel.goodBrand = _orderDetailsModel.body.goods[0].goodsBrand;
//    vc.scanInfoModel.goodKind = _orderDetailsModel.body.goods[0].goodsKind;
//    [self.navigationController pushViewController:vc animated:YES];
}
- (void)toStageApplicationViewControllerByMerchantEnter{
//    StageApplicationViewController * vc = [[StageApplicationViewController alloc]init];
//    
//    vc.ordeDetailsBody = _orderDetailsModel;
//    vc.strManagerID = StringOrNull(_orderDetailsModel.body.crtUsr);
//    
//    if (_loanName == BeReturnLoanByMerchant) {
//        vc.flowName = BeReturnByMerchant;  //商户被退回商品贷
//    }else if (_loanName == waitSubmitLoan || _loanName == MsgWaitSubmitCash){
//        vc.flowName = WaitSubmitCashLoan;
//    }
//    vc.scantype = merchantEnter;
//    vc.merchantCode = StringOrNull(_orderDetailsModel.body.merchNo);//商户编码
//    vc.scanInfoModel = [[ScanTableModel alloc]init];
//    vc.scanInfoModel.goodBrand = _orderDetailsModel.body.goods[0].goodsBrand;
//    vc.scanInfoModel.goodKind = _orderDetailsModel.body.goods[0].goodsKind;
//    [self.navigationController pushViewController:vc animated:YES];
}

//设置导航
- (void)setNavi {
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = ReturnRect;
    [backBtn setImage:[UIImage imageNamed:@"返回_黑"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(OnBackBtn:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
}
// 返回
- (void)OnBackBtn:(UIButton *)btn {
  

    [self.navigationController popViewControllerAnimated:YES];
}

- (void)changeBank{
    
//    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    
//    NSMutableDictionary *parmDic = [NSMutableDictionary dictionary];
//    
//    if ([_orderDetailsModel.body.applyTnrTyp isEqualToString:@"D"] || [_orderDetailsModel.body.applyTnrTyp isEqualToString:@"d"]) {
//        [parmDic setObject:_orderDetailsModel.body.applyTnrTyp forKey:@"applyTnrTyp"];//期限类型
//    }else{
//        [parmDic setObject:StringOrNull(_orderDetailsModel.body.applyTnr) forKey:@"applyTnrTyp"];//期限类型
//    }
//    [parmDic setObject:StringOrNull(_orderDetailsModel.body.applyAmt) forKey:@"apprvAmt"];//贷款金额
//    [parmDic setObject:StringOrNull(_orderDetailsModel.body.applyTnr)  forKey:@"applyTnr"];//贷款期限
//    [parmDic setObject:StringOrNull(_orderDetailsModel.body.typCde) forKey:@"typCde"];//贷款品种代码
//    
//    [BSVKHttpClient shareInstance].delegate = self;
//    
//    [[BSVKHttpClient shareInstance] postInfo:@"app/appserver/customer/getPaySs" requestArgument:parmDic requestTag:101 requestClass:NSStringFromClass([self class])];
    
    AddBankViewController * bank = [[AddBankViewController alloc]init];
    
    bank.choiceBank = choiceDefaultCard;
    
    bank.choiceDefaultDelegate = self;
    
    [self.navigationController pushViewController:bank animated:YES];
    
   
}

#pragma mark -- 请求
- (void)updateMsgStatus{
    [BSVKHttpClient shareInstance].delegate = self;
    
    [[BSVKHttpClient shareInstance]postInfo:@"app/appserver/message/updateMsgStatus" requestArgument:@{@"msgId":_msgId} completion:^(id results, NSError *error) {
        if (results) {
            NSLog(@"成功");
        }
    }];
}
- (void)creatDetailReq{
    
    BSVKHttpClient * detailClint = [BSVKHttpClient shareInstance];
    detailClint.delegate = self;
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    NSLog(@"%@",[AppDelegate delegate].userInfo.applSeq);
    [dict setObject:[AppDelegate delegate].userInfo.orderNo forKey:@"orderNo"];
    [detailClint getInfo:@"app/appserver/apporder/getAppOrderAndGoods" requestArgument:dict requestTag:10 requestClass:NSStringFromClass([self class])];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
}
//录单校验
- (void)checkList{
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSMutableDictionary * dic = [[NSMutableDictionary alloc]init];
    
    if ([AppDelegate delegate].userInfo.whiteType == WhiteA || [AppDelegate delegate].userInfo.whiteType == WhiteSocityReason || [AppDelegate delegate].userInfo.whiteType == WhiteCReason) {
        
        [dic setObject:@"" forKey:@"cityCode"];
        
        [dic setObject:@"" forKey:@"provinceCode"];
        
    }else
    {
        [dic setObject:StringOrNull([AppDelegate delegate].mapLocation.strCityCode) forKey:@"cityCode"];
        
        [dic setObject:StringOrNull([AppDelegate delegate].mapLocation.strProvinceCode) forKey:@"provinceCode"];
    }
    
    [dic setObject:[AppDelegate delegate].userInfo.userId forKey:@"userId"];
    
    [BSVKHttpClient shareInstance].delegate = self;
    
    [[BSVKHttpClient shareInstance]getInfo:@"app/appserver/apporder/getCustInfoAndEdInfoPerson" requestArgument:dic requestTag:11111 requestClass:NSStringFromClass([self class])];
}
- (void)searchStateOrder:(NSString *) strType{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    [dic setObject:[AppDelegate delegate].userInfo.realId forKey:@"idNo"];
    [dic setObject:strType forKey:@"outSts"];
    [dic setObject:@"1" forKey:@"page"];
    [dic setObject:@"1" forKey:@"pageSize"];
    BSVKHttpClient *client = [BSVKHttpClient shareInstance];
    client.delegate = self;
    [client getInfo:@"app/appserver/cmis/queryApplListPerson" requestArgument:dic requestTag:1223 requestClass:NSStringFromClass([self class])];
    
}
// 查询白名单
- (void)setAllowRequest{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSMutableDictionary * dic = [[NSMutableDictionary alloc]init];
    
    if ([AppDelegate delegate].userInfo.realId.length > 0)
    {
        [dic setObject:[AppDelegate delegate].userInfo.realId forKey:@"certNo"];
    }
    
    if ([AppDelegate delegate].userInfo.realName.length > 0)
    {
        [dic setObject:[AppDelegate delegate].userInfo.realName forKey:@"custName"];
    }
    if ([AppDelegate delegate].userInfo.userTel.length > 0)
    {
        [dic setObject:[AppDelegate delegate].userInfo.userTel forKey:@"phonenumber"];
    }
    [dic setObject:@"20" forKey:@"idTyp"];
    BSVKHttpClient *client = [BSVKHttpClient shareInstance];
    client.delegate = self;
    [client getInfo:@"app/appserver/crm/cust/getCustIsPass" requestArgument:dic requestTag:600 requestClass:NSStringFromClass([self class])];
}
//查询邀请原因
- (void)searchInviteReason
{
    //查询邀请原因
    BSVKHttpClient *client = [BSVKHttpClient shareInstance];
    
    client.delegate = self;
    
    [client getInfo:@"app/appserver/crm/cust/getInvitedCustByCustNo" requestArgument:@{@"custNo":[AppDelegate delegate].userInfo.custNum} requestTag:1000 requestClass:NSStringFromClass([self class])];
}
//选择默认还款卡代理
- (void)choiceBank:(BankInfo *)backinfo{
    
    _bankName = backinfo.bankName;
    _bankNumber = backinfo.cardNo;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [BSVKHttpClient shareInstance].delegate = self;
    [[BSVKHttpClient shareInstance]postInfo:@"app/appserver/appInfo/setHkNo" requestArgument:@{@"orderNo":StringOrNull(_orderDetailsModel.body.orderNo),@"cardNo":StringOrNull(backinfo.cardNo)} requestTag:100 requestClass:NSStringFromClass([self class])];
}
#pragma mark - BSVKHttpClientDelegate
//成功
- (void)requestSucess:(NSInteger)requestTag requestResult:(id)responseObject requestClass:(NSString *)className {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    if ([className isEqualToString:NSStringFromClass([self class])]) {
        
        if (requestTag == 10) {
            
            _orderDetailsModel = [OrdeDetailsModel mj_objectWithKeyValues:responseObject];
            
            [self analySisOrdeDetailsModel];
        }
        else if (requestTag == 11111){
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            CheckListModel *model = [CheckListModel mj_objectWithKeyValues:responseObject];
            
            [self analySisCheckListModel:model];
        }else if (requestTag == 600){
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            WhiteSearchModel *allowModel = [WhiteSearchModel mj_objectWithKeyValues:responseObject];
            [self synalizeAllowModel:allowModel];
        }else if (requestTag == 1000) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            IndetityStore *model = [IndetityStore mj_objectWithKeyValues:responseObject];
            [self synalizeSocialReason:model];
        }else if (requestTag == 100){
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            ChangeDefaultBankModel *model = [ChangeDefaultBankModel mj_objectWithKeyValues:responseObject];
            [self analySisChangeDefaultBankModel:model];
        }else if (requestTag == 101){
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            StageApplicationModel *model = [StageApplicationModel mj_objectWithKeyValues:responseObject];
            
            [self setValuesForBottom:model];
            
        }
    }
}
//失败
- (void)requestFail:(NSInteger)requestTag requestError:(NSError *)error httpCode:(NSInteger)httpCode requestClass:(NSString *)className {
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
#pragma mark - Model 解析


//底部view赋值
- (void)setValuesForBottom:(StageApplicationModel *)model{
    
    if ([model.head.retFlag isEqualToString:@"00000"]) {
        
        NSString *_payMaxMoney = @"0";
        
        for (StageApplicationModelMx *max in model.body.mx) {
            
            if ([self isJudgeOneString:max.instmAmt twoString:_payMaxMoney]) {
                
                _payMaxMoney = max.instmAmt;
                
            }
            
        }
        
       

        
    }else{
        
        [self buildHeadError:model.head.retMsg];
        
    }
    
    
}


//比较字符串大小 jack > rose
-(BOOL)isJudgeOneString:(NSString *)jack twoString:(NSString *)rose{
    
    NSDecimalNumber *kiss = [[NSDecimalNumber alloc]initWithString:jack];
    
    NSDecimalNumber *kill  =[[NSDecimalNumber alloc]initWithString:rose];
    
    if (([kiss compare:kill] == NSOrderedDescending)) {
        
        return YES;
        
    }else{
        
        return NO;
    }
    
}

//白名单解析
- (void)synalizeAllowModel:(WhiteSearchModel *)_allowModel
{
    //白名单
    NSLog(@"实名回执%@",_allowModel.head.retFlag);
    
    if ([_allowModel.head.retFlag isEqualToString:@"00000"])
    {
        // 社会化顾客
        _searchModel = _allowModel;
        if ([_allowModel.body.isPass isEqualToString:SocietyUser])
        {
             [AppDelegate delegate].userInfo.haierVipState = NoHaierVip;
            [self searchInviteReason];
        }
        else if ([_allowModel.body.isPass isEqualToString:@"1"])
        {
            //优质白名单  海尔、电信员工
            if ([_allowModel.body.level isEqualToString:Auser])
            {
                [AppDelegate delegate].userInfo.whiteType = WhiteA;
                 [AppDelegate delegate].userInfo.haierVipState = NoHaierVip;
                [self checkList];
            }
            //其他白名单
            else if ([_allowModel.body.level isEqualToString:Buser])
            {
                [AppDelegate delegate].userInfo.whiteType = WhiteB;
                 [AppDelegate delegate].userInfo.haierVipState = NoHaierVip;
                if([AppDelegate delegate].mapLocation.locationStatus == LocationNoAuthority)
                {
                    //提示没有权限
                    [self showNoAuthorityAlert];
                }else if ([AppDelegate delegate].mapLocation.locationStatus == LocationNotInChina)
                {
                    //提示不在中国
                    [self showNotInChinaAlert];
                }else if([AppDelegate delegate].mapLocation.locationStatus == LocationGeoCitySucess )
                {
                    //录单校验
                    [self checkList];
                }else
                {
                    //提示定位失败
                    [self showLocationFailAlert];
                }
            }else if ([_allowModel.body.level isEqualToString:Cuser]){
                //[AppDelegate delegate].userInfo.whiteType = WhiteC;
                 [AppDelegate delegate].userInfo.haierVipState = IsHaierVip;
                [self searchInviteReason];
            }
        }
        else if ([_allowModel.body.isPass isEqualToString:@"-1"]){
            [AppDelegate delegate].userInfo.whiteType = BlackMan;
             [AppDelegate delegate].userInfo.haierVipState = NoHaierVip;
            [self buildHeadError:@"此账号无贷款权限，详情请拨打4000187777"];
        }
    }else{
        
        [self buildHeadError:_allowModel.head.retMsg];
    }
}
//社会化接续
- (void)synalizeSocialReason:(IndetityStore *)model
{
    if ([model.head.retFlag isEqualToString:@"00000"]) {
        if (model.body.count > 0) {
            //有邀请原因 继续走
            if ([_searchModel.body.isPass isEqualToString:@"1"]) {
                [AppDelegate delegate].userInfo.whiteType = WhiteCReason;
            }else{
                [AppDelegate delegate].userInfo.whiteType = WhiteSocityReason;
            }
            [self checkList];
        }
        //没有邀请原因  获取贷款品种 用来判断每日额度
        else
        {
            if ([_searchModel.body.isPass isEqualToString:@"1"]) {
                [AppDelegate delegate].userInfo.whiteType = WhiteCNoReason;
            }else{
                [AppDelegate delegate].userInfo.whiteType = WhiteSocityNoReason;
            }
            
            if([AppDelegate delegate].mapLocation.locationStatus == LocationNoAuthority)
            {
                //提示没有权限
                [self showNoAuthorityAlert];
            }else if ([AppDelegate delegate].mapLocation.locationStatus == LocationNotInChina)
            {
                //提示不在中国
                [self showNotInChinaAlert];
            }else if([AppDelegate delegate].mapLocation.locationStatus == LocationGeoCitySucess )
            {
                //录单校验
                [self checkList];
            }else
            {
                //提示定位失败
                [self showLocationFailAlert];
            }
        }
    }else{
        
        [self buildHeadError:model.head.retMsg];
    }
}
- (void)analySisOrdeDetailsModel{
    if ([_orderDetailsModel.head.retFlag isEqualToString:SucessCode]) {
        
        
        _priManey = [[UILabel alloc]init];
        
        _divManey = [[UILabel alloc]init];
        
        _totalManey = [[UILabel alloc]init];
        //分期本金
        _priManey.text = [NSString stringWithFormat:@"%.2f",[_orderDetailsModel.body.applyAmt floatValue]];
        //息费
        _divManey.text = _orderDetailsModel.body.xfze;
        //总金额
        _totalManey.text = [NSString stringWithFormat:@"%.2f",[_priManey.text floatValue]+[_divManey.text floatValue]];
        
        _arrGoods = _orderDetailsModel.body.goods;
        
        _timeLabel = [[UILabel alloc]init];
        
        _timeLabel.text = _orderDetailsModel.body.applyDt;
        
        [self setTableView];
    }else{
        
        WEAKSELF
        [RMUniversalAlert showAlertInViewController:self withTitle:@"提示" message:_orderDetailsModel.head.retMsg cancelButtonTitle:@"知道了" destructiveButtonTitle:nil otherButtonTitles:nil tapBlock:^(RMUniversalAlert * _Nonnull alert, NSInteger buttonIndex) {
            STRONGSELF
            if (strongSelf) {
                if (buttonIndex == 0) {
                    [strongSelf.navigationController popViewControllerAnimated:YES];
                }
            }
        }];
    }
}

- (void)analySisCheckListModel:(CheckListModel *)model{
    if ([model.head.retFlag isEqualToString:SucessCode]) {
        
        if (_loanName == waitSubmitCash) {
            [self contionToNext];
        }else if (_loanName == waitSubmitLoan || _loanName == MsgWaitSubmitCash){
            [self toStageAppViewController];
        }
    }else if ([model.head.retFlag isEqualToString:@"A1185"]){
        [AppDelegate delegate].userInfo.applSeq = model.body.crdSeq;
        WEAKSELF
        [RMUniversalAlert showAlertInViewController:self withTitle:@"提示" message:model.head.retMsg cancelButtonTitle:@"知道了" destructiveButtonTitle:nil otherButtonTitles:nil tapBlock:^(RMUniversalAlert * _Nonnull alert, NSInteger buttonIndex) {
            STRONGSELF
            if (strongSelf) {
                if (buttonIndex == 0) {
                    [strongSelf queryProgress];
                }
            }
        }];
    }else{
        
        [self buildHeadError:model.head.retMsg];
    }
}
- (void)analySisChangeDefaultBankModel:(ChangeDefaultBankModel *)model{
    if ([model.head.retFlag isEqualToString:SucessCode]) {
        _changeBankView.defaultBankLabel.text = _bankName;
        _orderDetailsModel.body.repayApplCardNo = _bankNumber;
        _orderDetailsModel.body.repayAccBankName = _bankName;
        if (_bankNumber.length > 4) {
            NSString * message = [_bankNumber substringFromIndex:_bankNumber.length - 4];
            
            _changeBankView.bankNumberLabel.text = [NSString stringWithFormat:@"****%@",message];
        }else{
            
            _changeBankView.bankNumberLabel.text = @"";
        }
    }else{
        
        [self buildHeadError:model.head.retMsg];
    }
}
#pragma mark - 卡地理位置的方法
//没有权限的提示框
- (void)showNoAuthorityAlert
{
    WEAKSELF
    [RMUniversalAlert showAlertInViewController:self withTitle:@"提示" message:@"尚未获取您的位置，请开启定位服务或移动至开阔地带！" cancelButtonTitle:@"取消" destructiveButtonTitle:@"设置" otherButtonTitles:nil tapBlock:^(RMUniversalAlert * _Nonnull alert, NSInteger buttonIndex) {
        STRONGSELF
        if (strongSelf) {
            if (buttonIndex == 1)
            {
                //去设置页面
                [strongSelf toSetLocation];
            }
        }
    }];
}

//不在中国的提示框
- (void)showNotInChinaAlert
{
    WEAKSELF
    [RMUniversalAlert showAlertInViewController:self withTitle:@"提示" message:@"当前业务仅支持在中国" cancelButtonTitle:@"知道了" destructiveButtonTitle:nil otherButtonTitles:nil tapBlock:^(RMUniversalAlert * _Nonnull alert, NSInteger buttonIndex) {
        STRONGSELF
        if (strongSelf) {
            if (buttonIndex == 0)
            {
                
            }
        }
    }];
}

//解析失败或者定位失败的提示框
- (void)showLocationFailAlert
{
    WEAKSELF
    [RMUniversalAlert showAlertInViewController:self withTitle:@"提示" message:@"当前无法确认您的位置，请检查网络并重试" cancelButtonTitle:@"知道了" destructiveButtonTitle:nil otherButtonTitles:nil tapBlock:^(RMUniversalAlert * _Nonnull alert, NSInteger buttonIndex) {
        STRONGSELF
        if (strongSelf) {
            if (buttonIndex == 0) {
                [[AppDelegate delegate].mapLocation openLocationService];
            }
        }
    }];
}
//设置定位
- (void)toSetLocation
{
    NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
    if ([[UIApplication sharedApplication] canOpenURL:url])
    {
        [[UIApplication sharedApplication] openURL:url];
    }
}
@end
