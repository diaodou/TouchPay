//
//  YuQiViewController.h
//  personMerchants
//
//  Created by 张久健 on 16/4/3.
//  Copyright © 2016年 海尔金融. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger ,YuQiType) {
    
    fromAllLoan,            //来自全部贷款
    fromMsg,                //来自消息中心
    RecentlySevenDay        //来自近七日
};
@interface YuQiViewController : UIViewController
@property(nonatomic,strong) NSString *applSeq;//流水号
@property(nonatomic,copy)NSString *loanNoStr;//借据号
@property(nonatomic,copy)NSString *msgId;//消息已读标示
@property(nonatomic,copy)NSString *haveContract;//查看合同
@property(nonatomic,assign)YuQiType yuqiType; //
@end
