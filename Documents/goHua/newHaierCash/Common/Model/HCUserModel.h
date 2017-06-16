//
//  HCUserModel.h
//  newHaierCash
//
//  Created by Will on 2017/5/31.
//  Copyright © 2017年 haier. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef NS_ENUM(NSInteger, BusFlowName) {
    Undefined,         //未定义
    QuotaApply,        //额度激活
    QuotaReturned,     //额度退回
    CashLoanCreate,    //现金贷创建
    CashLoanWait,      //现金贷待提交
    CashLoanReturned,  //现金贷被退回
    GoodsLoanCreate,   //商品贷创建
    GoodsLoanWait,     //商品贷待提交
    GoodsReturnedByMerchant, //商品贷商户退回
    GoodsReturnedByCredit, //商品贷信贷退回
    PersonalCenter     //个人中心
};



typedef NS_ENUM(NSInteger , RealNameState) {
    realNameNoRequest, //没有网络请求
    realNameRequestFail, //网络请求失败
    realNameRequestSucess, //网络请求成功
    realNameYes,   //已经实名认证  (用它判断)
    realNameNo     //没有实名认证
};

typedef NS_ENUM (NSInteger, WhiteType) {
    WhiteNoCheck,
    BlackMan,             //黑名单(不允许借款)
    WhiteA,               //白名单A(海尔)
    WhiteB,               //白名单B(等级比A低，加地理位置限制条件，只允许在中国)
    WhiteSocityReason,    //白名单社会化有原因(没有地理位置限制)
    WhiteSocityNoReason,  //没原因(等级比B低，加地理位置限制，只允许固定城市)
    WhiteCReason,               //白名单C有原因
    WhiteCNoReason,               //白名单C无原因
    
};
typedef NS_ENUM(NSInteger, HaierVipState) {
    
    NoHaierVip,            //非会员
    IsHaierVip          //海尔会员
};

typedef NS_ENUM(NSInteger, LimitState) {
    
    LimitSearchFail,      //额度查询失败
    
    LimitNoApply, //没有申请额度(最高可借200000)
    
    LimitHasApply //有额度（最高可借额度的最大允许借款）
    
};



// 用于管理用户信息的通用类
@interface HCUserModel : NSObject

/*
 枚举
 */

@property (nonatomic, assign) RealNameState myRealNameState;  //实名认证状态

@property (nonatomic, assign) WhiteType whiteType;            //白名单状态

@property (nonatomic, assign) HaierVipState haierVipState;    //海尔会员状态

@property (nonatomic, assign) BusFlowName busFlowName;        //业务流程

@property (nonatomic, assign) LimitState limitState;         //额度状态

/*
 设置类
 */
@property (nonatomic, assign) BOOL bLoginOK;   //是否是登录状态

@property (nonatomic, assign) BOOL bsetGuestPwd;     //是否设置了手势密码

@property (nonatomic, assign) BOOL bsetPayPwd;       //是否设置了支付密码

@property (nonatomic, assign) BOOL haveDictionary;   //是否请求了字典项

/*
 用户信息类
 */
@property (nonatomic, copy) NSString *userId;  //用户登录后返回的那个ID

@property (nonatomic, copy) NSString *realName;//用户姓名

@property (nonatomic, copy) NSString *userHeader;//头像

@property (nonatomic, copy) NSString *realId;  //用户证件号

@property (nonatomic, copy) NSString *realType;  //用户证件类型


@property (nonatomic, copy) NSString *realTel; //用户实名手机号

@property (nonatomic, copy) NSString *userTel; //绑定手机号

@property (nonatomic, copy) NSString *custNum; //客户编号

@property (nonatomic, copy) NSString *bankName;//银行名称

@property (nonatomic, copy) NSString *realCard;//银行卡号

@property (nonatomic, copy) NSString *acctBankNo;//银行编号

@property (nonatomic, copy) NSString *acctCityCode;//开户城市编码

@property (nonatomic, copy) NSString *acctProvinceCode;  //开户省份编码

@property (nonatomic, copy) NSString *marryStatues;  //婚姻状态

@property (nonatomic, copy) NSString *af_swift_number;//百融登录采集信息

/*
 订单信息
 */

@property(nonatomic,copy)NSString *orderNo;//订单号

@property(nonatomic,copy)NSString *applSeq;//流水号

@property(nonatomic,copy)NSString *expectCredit; //期望额度

@property (nonatomic, copy) NSString *fundTaskId;//提额的公积金信息

@property (nonatomic, copy) NSString *unionPayTaskId;//提额的银联信息

/*
 判断信息
 */
@property (nonatomic, assign) BOOL bReturn;          //全部贷款界面判断返回是否刷新 Y不刷新  N刷新

- (void)initRealNameInfo:(id)dataModel;

@end
