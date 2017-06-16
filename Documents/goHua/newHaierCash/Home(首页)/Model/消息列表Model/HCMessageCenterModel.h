//
//  MessageCenterModel.h
//  newHaierCash
//
//  Created by 百思为科 on 2017/6/7.
//  Copyright © 2017年 haier. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MessageCenterHead,MessageCenterBody;
@interface HCMessageCenterModel : NSObject

@property (nonatomic, strong) MessageCenterHead *head;

@property (nonatomic, strong) NSArray<MessageCenterBody *> *body;

@end
@interface MessageCenterHead : NSObject

@property (nonatomic, copy) NSString *retFlag;

@property (nonatomic, copy) NSString *retMsg;

@end

@interface MessageCenterBody : NSObject

@property (nonatomic, copy) NSString *ID;

@property (nonatomic, copy) NSString *scooprCde;

@property (nonatomic, copy) NSString *reserved2;

@property (nonatomic, copy) NSString *message;

@property (nonatomic, copy) NSString *msgTitil;

@property (nonatomic, copy) NSString *reserved5;

@property (nonatomic, copy) NSString *cooprCde;

@property (nonatomic, copy) NSString *reserved3;

@property (nonatomic, copy) NSString *pullDate;

@property (nonatomic, copy) NSString *userId;

@property (nonatomic, copy) NSString *flag;

@property (nonatomic, copy) NSString *idNo;

@property (nonatomic, copy) NSString *usrCde;

@property (nonatomic, copy) NSString *reserved4;

@property (nonatomic, copy) NSString *reserved1;

@property (nonatomic, copy) NSString *applSeq;

@property (nonatomic, copy) NSString *status;

@property (nonatomic, copy) NSString *msgTyp;

@property (nonatomic, copy) NSString *typGrp;

@property (nonatomic, copy) NSString *msgId;


@end
