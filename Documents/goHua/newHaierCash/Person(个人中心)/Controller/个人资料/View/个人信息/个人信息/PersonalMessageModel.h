//
//  PersonalMessageModel.h
//  personMerchants
//
//  Created by 张久健 on 16/5/5.
//  Copyright © 2016年 海尔金融. All rights reserved.
//

#import <Foundation/Foundation.h>


@class personHead,personBody;
@interface PersonalMessageModel : NSObject

@property (nonatomic, strong) personHead *head;

@property (nonatomic, strong) personBody *body;

@end

@interface personHead : NSObject

@property (nonatomic, copy) NSString *retFlag;

@property (nonatomic, copy) NSString *retMsg;

@end

@interface personBody : NSObject 

@property (nonatomic, copy) NSString *education;

@property (nonatomic, copy) NSString *postAddr;

@property (nonatomic, copy) NSString *regArea;

@property (nonatomic, copy) NSString *regAddr;

@property (nonatomic, copy) NSString *custno;

@property (nonatomic, copy) NSString *postProvince;

@property (nonatomic, copy) NSString *liveArea;

@property (nonatomic, copy) NSString *maxAmount;

@property (nonatomic, copy) NSString *maritalStatus;

@property (nonatomic, copy) NSString *liveAddr;

@property (nonatomic, copy) NSString *regLiveInd;

@property (nonatomic, copy) NSString *localResid;

@property (nonatomic, copy) NSString *postQtInd;

@property (nonatomic, copy) NSString *fmlyTel;

@property (nonatomic, copy) NSString *liveProvince;

@property (nonatomic, copy) NSString *postCity;

@property (nonatomic, copy) NSString *email;

@property (nonatomic, copy) NSString *regProvince;

@property (nonatomic, copy) NSString *creditCount;

@property (nonatomic, copy) NSString *fmlyZone;

@property (nonatomic, copy) NSString *liveCity;

@property (nonatomic, copy) NSString *regCity;

@property (nonatomic, copy) NSString *postArea;

@property(nonatomic,copy)   NSString *providerNum;
@property(nonatomic,copy)   NSString *liveInfo;

@end

