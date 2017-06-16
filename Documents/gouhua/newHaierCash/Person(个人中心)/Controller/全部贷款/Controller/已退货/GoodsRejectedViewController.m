//
//  GoodsRejectedViewController.m
//  personMerchants
//
//  Created by 张久健 on 17/4/21.
//  Copyright © 2017年 海尔金融. All rights reserved.
//

#import "GoodsRejectedViewController.h"
#import "HCMacro.h"
#import "UIFont+AppFont.h"
#import "BSVKHttpClient.h"
#import <MBProgressHUD.h>
#import "RMUniversalAlert.h"
#import "AppDelegate.h"
#import "UILabel+SizeForStr.h"
#import <YYWebImage.h>
#import "ChangDefaultBankView.h"
#import "LoanDetailModel.h"
#import "ContractShowViewController.h"
#import <MJExtension.h>
@interface GoodsRejectedViewController ()<UITableViewDelegate,UITableViewDataSource, BSVKHttpClientDelegate>
{
    
    NSString * _haveMenu; //判断有无套餐
    
    NSString *applCde;//贷款编号

}
@property(nonatomic,strong) UIButton * contractBtn;//合同按钮
@property(nonatomic,strong) UIView * mbView;
@property(nonatomic,strong) UIView * contractView;

@property (nonatomic,strong) UILabel *timeLabel;

@property (nonatomic,strong) NSArray *arrGoods;

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic, strong) LoanDetailModel * loanDetailModel;
@property (nonatomic,strong)UIView *topView;
@property (nonatomic,strong)UIImageView *stateImage;
@property (nonatomic,strong)UILabel *stateLabel;//状态
@end

@implementation GoodsRejectedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title  =@"订单详情";
    self.view.backgroundColor = UIColorFromRGB(0xf6f6f6, 1.0);
    
    if (_msgId) {

        [self updateMsgStatus];
    }
    
    [self setNavi];
    
    [self creatDetailReq];
    
    [self creatContractBtn];

}

#pragma mark -- setting and getting
// 表头
-(void)setTableViewHeaderView{
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DeviceWidth, 70)];
    
    headerView.backgroundColor =UIColorFromRGB(0xffffff,1.0);
    
    _topView = [[UIView alloc]init];
    
    _topView.frame = CGRectMake(0, 0, DeviceWidth, 40);
    
    _topView.backgroundColor = [UIColor whiteColor];
    
    [headerView addSubview:_topView];
    _stateImage = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 18,20)];
    
    _stateImage.image = [UIImage imageNamed:@"订单详情－图标"];
    
    [_topView addSubview:_stateImage];
    
    UILabel *fixedStateLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_stateImage.frame) + 5, 0, 100, 40)];
    
    fixedStateLabel.text = @"订单状态";
    
    fixedStateLabel.textColor = UIColorFromRGB(0x32beff, 1.0);
    
    fixedStateLabel.font = [UIFont appFontRegularOfSize:14];
    
    [_topView addSubview:fixedStateLabel];
    
    _stateLabel = [[UILabel alloc]initWithFrame:CGRectMake(DeviceWidth/2, 0, DeviceWidth/2 - 20, 40)];
    
    _stateLabel.numberOfLines = 0;
    
    _stateLabel.textColor = UIColorFromRGB(0x32beff, 1.0);
    
    _stateLabel.textAlignment = NSTextAlignmentRight;
    
    _stateLabel.font = [UIFont appFontRegularOfSize:14];
    
    _stateLabel.text = @"已退货";
    
    [_topView addSubview:_stateLabel];

    
    UILabel *numberLabel = [[UILabel alloc]initWithFrame:CGRectMake(8, CGRectGetMaxY(_topView.frame), 200, 30)];
    if (iphone6P || iphone6) {
        numberLabel.font = [UIFont appFontRegularOfSize:12];
    }else{
        numberLabel.font = [UIFont appFontRegularOfSize:11];
    }
    
    numberLabel.text = [NSString stringWithFormat:@"贷款编号：%@",applCde];
    [headerView addSubview:numberLabel];
    
    UILabel *timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(DeviceWidth - 150, CGRectGetMaxY(_topView.frame), 140, 30)];
    timeLabel.font = [UIFont appFontRegularOfSize:12];
    timeLabel.textAlignment = NSTextAlignmentRight;
    timeLabel.text = _timeLabel.text;
    [headerView addSubview:timeLabel];
    _tableView.tableHeaderView = headerView;
}
-(void)setTableView{
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,0,DeviceWidth, DeviceHeight - 64) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.tableFooterView = [[UITableView alloc]initWithFrame:CGRectZero];
    _tableView.backgroundColor = UIColorFromRGB(0xf6f6f6, 1.0);
    [self.view addSubview:_tableView];
    
    [self setTableViewHeaderView];
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
        
        UIImageView *img = [[UIImageView alloc]initWithFrame:CGRectMake(15 * DeviceWidth/375, 5*scaleAdapter, 80*scaleAdapter, 70*scaleAdapter)];
        img.tag = 10;
        [bjView addSubview:img];
        
        UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(100 *DeviceWidth/375, 0, 150, 80*scaleAdapter)];
        nameLabel.tag = 11;
        nameLabel.font = [UIFont appFontRegularOfSize:13];
        [bjView addSubview:nameLabel];
        
        UILabel *moneyLabel = [[UILabel alloc]initWithFrame:CGRectMake(DeviceWidth -  130, 0, 110, 80*scaleAdapter)];
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
    
    bjView.backgroundColor = UIColorFromRGB(0xffffff, 1.0);
    
    UIImageView *img = [(UIImageView *)bjView viewWithTag:10];
    
    UILabel *nameLabel = [(UILabel *)bjView viewWithTag:11];
    
    NSString * nameStr;
    
    if([_loanDetailModel.body.goods[indexPath.row].goodsName rangeOfString:@"goodname"].location !=NSNotFound)//_roaldSearchText
    {
        NSRange range  = [_loanDetailModel.body.goods[indexPath.row].goodsName rangeOfString:@"goodname"];
        
        nameStr = [_loanDetailModel.body.goods[indexPath.row].goodsName substringFromIndex:range.location+range.length];  //名称
    }
    else
    {
        nameStr = _loanDetailModel.body.goods[indexPath.row].goodsName;
    }
    nameLabel.text = [NSString stringWithFormat:@"%@",nameStr];
    
    [img yy_setImageWithURL:[NSURL URLWithString:@""] placeholder:[UIImage imageNamed:@"贷款列表默认图片"] options:YYWebImageOptionProgressiveBlur completion:nil];
    
    UIView *bottomView = [(UIView *)cell.contentView viewWithTag:13];
    
    bottomView.backgroundColor = UIColorFromRGB(0xffffff, 1.0);
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
    
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
    
    [AppDelegate delegate].userInfo.bReturn = YES;
    
    [_mbView removeFromSuperview];
    _mbView = nil;
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)creatContractBtn
{
    _contractBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _contractBtn.frame = CGRectMake(DeviceWidth - 40, 10, 40, 40);
    [_contractBtn setImage:[UIImage imageNamed:@"邀请圆"] forState:UIControlStateNormal];
    [_contractBtn addTarget:self action:@selector(comeContract) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:_contractBtn];
}
- (void)comeContract
{
    _mbView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DeviceWidth, DeviceHeight - 64)];
    
    _mbView.backgroundColor = [UIColor colorWithRed:0.30f green:0.30f blue:0.30f alpha:0.50f];
    
    [self.view addSubview:_mbView];
    _contractBtn.userInteractionEnabled = NO;
    _contractView = [[UIView alloc]initWithFrame:CGRectMake(0, DeviceHeight - 85 - 64, DeviceWidth, 85)];
    _contractView.backgroundColor = UIColorFromRGB(0xf6f6f6, 1.0);
    [_mbView addSubview:_contractView];
    
    UIView *topView = [[UIView alloc]initWithFrame:CGRectMake(0, 4.5, DeviceWidth, 38)];
    topView.backgroundColor = [UIColor whiteColor];
    [_contractView addSubview:topView];
    
    UIButton *cancelbutton = [UIButton buttonWithType:UIButtonTypeSystem];
    cancelbutton.frame = CGRectMake(0, 0, DeviceWidth, 38);
    [cancelbutton setTitle:@"查看合同" forState:UIControlStateNormal];
    [cancelbutton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [cancelbutton addTarget:self action:@selector(seeContract) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:cancelbutton];
    
    UIView *bbottomView = [[UIView alloc]initWithFrame:CGRectMake(0, 47.5, DeviceWidth, 38)];
    
    bbottomView.backgroundColor = [UIColor whiteColor];
    [_contractView addSubview:bbottomView];
    
    UIButton *disAppearBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    disAppearBtn.frame = CGRectMake(0, 0, DeviceWidth, 40);
    [disAppearBtn setTitle:@"取消" forState:UIControlStateNormal];
    [disAppearBtn addTarget:self action:@selector(disappear:) forControlEvents:UIControlEventTouchUpInside];
    [bbottomView addSubview:disAppearBtn];
}

- (void)disappear:(UIButton *)btn
{
    NSLog(@"取消");
    [_mbView removeFromSuperview];
    _mbView = nil;
    _contractBtn.userInteractionEnabled = YES;
    [_contractView removeFromSuperview];
    _contractView = nil;
}
- (void)seeContract{//个人借款合同
    [_mbView removeFromSuperview];
    _mbView = nil;
    _contractView.hidden = YES;
    _contractBtn.userInteractionEnabled = YES;
    //File Url
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSString* fileUrl = [NSString stringWithFormat:@"%@app/appserver/downContractPdf?applseq=%@",baseUrl,[AppDelegate delegate].userInfo.applSeq];
    [BSVKHttpClient shareInstance].delegate = self;
    [[BSVKHttpClient shareInstance]downFile:fileUrl requestArgument:@{@"applseq":[AppDelegate delegate].userInfo.applSeq} requestTag:1000 requestClass:NSStringFromClass([self class])];
    
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
    [dict setObject:StringOrNull([AppDelegate delegate].userInfo.applSeq) forKey:@"applSeq"];
    [detailClint getInfo:@"app/appserver/apporder/queryAppLoanAndGoods" requestArgument:dict requestTag:10 requestClass:NSStringFromClass([self class])];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
}
#pragma mark - BSVKHttpClientDelegate
//成功
- (void)requestSucess:(NSInteger)requestTag requestResult:(id)responseObject requestClass:(NSString *)className {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    if ([className isEqualToString:NSStringFromClass([self class])]) {
        
        if (requestTag == 10) {
            
            _loanDetailModel = [LoanDetailModel mj_objectWithKeyValues:responseObject];
            
            [self analySisOrdeDetailsModel];
        }
    }
}
//失败
- (void)requestFail:(NSInteger)requestTag requestError:(NSError *)error httpCode:(NSInteger)httpCode requestClass:(NSString *)className {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    if ([className isEqualToString:NSStringFromClass([self class])]) {
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

- (void)downFile:(NSInteger)requestTag theFilePath:(NSURL *)filePath requestError:(NSError *)error {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    if (error.code == 200 || !error) {
        [self jumpShowPdf:filePath];
    }else if (error.code == 404){
        [self buildHeadError:@"文件不存在"];
    }else {
        [self buildHeadError:error.localizedDescription];
    }
}
- (void)jumpShowPdf:(NSURL *)targetPath
{
    ContractShowViewController *vc = [[ContractShowViewController alloc]init];
    vc.path = targetPath;
    vc.title = @"个人借款合同";
    vc.quote = zhanshi;
    vc.showState = @"show";
    HCRootNavController *navi = [[HCRootNavController alloc]initWithRootViewController:vc];
    [self.navigationController presentViewController:navi animated:YES completion:^{
    } ];
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
- (void)analySisOrdeDetailsModel{
    if ([_loanDetailModel.head.retFlag isEqualToString:SucessCode]) {
        
        _arrGoods = _loanDetailModel.body.goods;
        
        _timeLabel = [[UILabel alloc]init];
        
        _timeLabel.text = _loanDetailModel.body.applyDt;
        
        applCde = _loanDetailModel.body.applCde;
        
        [self setTableView];
    }else{
        
        WEAKSELF
        [RMUniversalAlert showAlertInViewController:self withTitle:@"提示" message:_loanDetailModel.head.retMsg cancelButtonTitle:@"知道了" destructiveButtonTitle:nil otherButtonTitles:nil tapBlock:^(RMUniversalAlert * _Nonnull alert, NSInteger buttonIndex) {
            STRONGSELF
            if (strongSelf) {
                if (buttonIndex == 0) {
                    [strongSelf.navigationController popViewControllerAnimated:YES];
                }
            }
        }];
    }
}
@end

