//
//  FaceVerityViewController.h
//  personMerchants
//
//  Created by 百思为科 on 16/4/5.
//  Copyright © 2016年 海尔金融. All rights reserved.
//

#import "HCBaseViewController.h"

#import "UpdateRiskInfoModel.h"

@protocol PayPassWordDelegate <NSObject>

-(void)toPayPassWordDelegate:(BOOL)view;

@end

typedef void(^detectBeginBlock)(void);
typedef void(^detectBackBlock)(void);
typedef void(^detectQuitBlock)(void);
typedef void(^detectAginBlock)(void);
typedef void(^wifiShareBlock)(void);



@interface FaceVerityViewController : HCBaseViewController
@property (nonatomic, copy) detectQuitBlock quitBlock;
@property (nonatomic, copy) detectAginBlock againBlock;
@property(nonatomic,weak)id<PayPassWordDelegate>payDelegate;

@property (nonatomic,strong)UpdateRiskInfoModel * updateRiskInfoModel;
@property (nonatomic,assign) BOOL firstMentionQuote;//记录是第一次提交还是被退回提交的

@property (nonatomic,assign) BOOL ifFromTE;//是否来自提额

@property (nonatomic,assign) BOOL ifFromPerson;//是否来自个人资料

@property (nonatomic,copy) NSString *typCde;//贷款品种

@property (nonatomic,assign) BOOL ifFromUnlock;

@end
