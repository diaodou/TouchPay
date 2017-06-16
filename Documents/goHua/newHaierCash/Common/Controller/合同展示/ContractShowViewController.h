//
//  ContractShowViewController.h
//  personMerchants
//
//  Created by 张久健 on 16/6/4.
//  Copyright © 2016年 海尔金融. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HCBaseViewController.h"

typedef NS_ENUM(NSInteger, Quote) {
    isQuote,//有额度
    noQuote,//无额度
    zhiFuSetting,//支付密码修改或者设置
    zhucexieyi,//注册协议
    zhengxin,//征信协议
    nextstep,// 下一步
    zhanshi//只是展示合同
};

typedef NS_ENUM(NSInteger, TransitionType) {
    pushType,
    modelType
};

@interface ContractShowViewController : HCBaseViewController
@property (nonatomic, copy) NSString *strOnLineUrl;
@property (nonatomic, assign) TransitionType transitionType;
@property(nonatomic,strong) NSString *applCde; //流水CODE
@property (nonatomic, copy) NSString *appl_seq;//流水号
@property(nonatomic,strong) NSString *IdentifyCode;//验证吗
@property(nonatomic,assign) Quote quote;//额度
@property(nonatomic,copy) NSString *showState;//展示合同状态
@property(nonatomic,strong) NSURL *path;//下载地址
@end
