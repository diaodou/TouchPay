//
//  AnyTimeBackController.h
//  personMerchants
//
//  Created by 张久健 on 16/4/13.
//  Copyright © 2016年 海尔金融. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface AnyTimeBackController : UIViewController

@property(nonatomic,strong) NSString *applSeq;//申请编号
@property(nonatomic,copy) NSString * loanNoStr; //借据号
@property(nonatomic,copy) NSString * sybjStr;  //剩余本金
@property(nonatomic,copy) NSString * haveContract;  //查看合同
@end
