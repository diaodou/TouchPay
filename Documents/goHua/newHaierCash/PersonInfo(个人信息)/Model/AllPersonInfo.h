//
//  AllPersonInfo.h
//  HaiFu
//
//  Created by 史长硕 on 17/2/9.
//  Copyright © 2017年 百思为科. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MJExtension.h>
@class AllPersonInfoBody,AllPersonInfoHead,ContactItem;
@interface AllPersonInfo : NSObject

@property(nonatomic,strong)AllPersonInfoHead *head;

@property(nonatomic,strong)AllPersonInfoBody *body;

@end

@interface AllPersonInfoHead : NSObject

@property(nonatomic,copy)NSString *retMsg;

@property(nonatomic,copy)NSString *retFlag;

@end

@interface AllPersonInfoBody : NSObject

@property (nonatomic, copy) NSString *officeAddr;

@property (nonatomic, copy) NSString *officeName;

@property (nonatomic, copy) NSString *officeArea;

@property (nonatomic, copy) NSString *officeTel;

@property (nonatomic, copy) NSString *mthInc;

@property (nonatomic, copy) NSString *officeCity;

@property (nonatomic, copy) NSString *officeProvince;

@property (nonatomic, copy) NSString *position;

@property (nonatomic, copy) NSString *liveArea;

@property (nonatomic, copy) NSString *maritalStatus;

@property (nonatomic, copy) NSString *liveAddr;

@property (nonatomic, copy) NSString *liveCity;

@property (nonatomic, copy) NSString *liveProvince;

@property (nonatomic, strong) NSArray<ContactItem *> *lxrList;

@end

@interface ContactItem : NSObject

@property (nonatomic, assign) NSInteger Id;

@property (nonatomic, copy) NSString *contactNo;

@property (nonatomic, copy) NSString *contactAddr;

@property (nonatomic, copy) NSString *custNo;

@property (nonatomic, copy) NSString *contactMobile;

@property (nonatomic, copy) NSString *contactName;

@property (nonatomic, copy) NSString *certType;

@property (nonatomic, copy) NSString *createUser;

@property (nonatomic, copy) NSString *createDt;

@property (nonatomic, copy) NSString *officeName;

@property (nonatomic, copy) NSString *relationType;

@property (nonatomic, copy) NSString *certNo;

@property (nonatomic, copy) NSString *updateDt;

@property (nonatomic, copy) NSString *updateUser;

@property (nonatomic, copy) NSString *apptType;

@property (nonatomic, copy) NSString *status;



@end

