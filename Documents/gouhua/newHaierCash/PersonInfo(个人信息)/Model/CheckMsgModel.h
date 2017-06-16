//
//  CheckMsgModel.h
//  personMerchants
//
//  Created by 百思为科 on 16/11/21.
//  Copyright © 2016年 海尔金融. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FaceSuccessModel.h"

@class CheckMsgHead,CheckMsgBody,CheckMsgGjj,CheckMsgYhls,CheckMsgClxx,CheckMsgBcyx,CheckMsgList,CheckMsgFcxx,CheckMsgRlsb,CheckMsgAttachlist,CheckMsgQtyx;
@interface CheckMsgModel : NSObject


@property (nonatomic, strong) CheckMsgHead *head;

@property (nonatomic, strong) CheckMsgBody *body;


@end@interface CheckMsgHead : NSObject

@property (nonatomic, copy) NSString *retFlag;

@property (nonatomic, copy) NSString *retMsg;

@end

@interface CheckMsgBody : NSObject

@property (nonatomic, strong) CheckMsgBcyx *BCYX;

@property (nonatomic, strong) CheckMsgYhls *YHLS;

@property (nonatomic, copy) NSString *DWXX;

@property (nonatomic, copy) NSString *SMRZ;

@property (nonatomic, strong) CheckMsgFcxx *FCXX;

@property (nonatomic, strong) CheckMsgRlsb *RLSB;

@property (nonatomic, copy) NSString *GZZM;

@property (nonatomic, copy) NSString *LXRXX;

@property (nonatomic, strong) CheckMsgGjj *GJJ;

@property (nonatomic, copy) NSString *GRJBXX;
 
@property (nonatomic, copy) NSString *JZXX;

@property (nonatomic, copy) NSString *CERTFLAG;

@property (nonatomic, strong) NSArray<CheckMsgQtyx *> *QTYX;

@property (nonatomic, strong) CheckMsgClxx *CLXX;

@end

@interface CheckMsgGjj : NSObject

@property (nonatomic, copy) NSString *docDesc;

@property (nonatomic, copy) NSString *GJJ;

@property (nonatomic, copy) NSString *docCde;

@end

@interface CheckMsgYhls : NSObject

@property (nonatomic, copy) NSString *docDesc;

@property (nonatomic, copy) NSString *YHLS;

@property (nonatomic, copy) NSString *docCde;

@end

@interface CheckMsgClxx : NSObject

@property (nonatomic, copy) NSString *docDesc;

@property (nonatomic, copy) NSString *CLXX;

@property (nonatomic, copy) NSString *docCde;

@end

@interface CheckMsgBcyx : NSObject

@property (nonatomic, copy) NSString *BCYX;

@property (nonatomic, strong) NSArray<CheckMsgList *> *list;

@end

@interface CheckMsgList : NSObject

@property (nonatomic, copy) NSString *docDesc;

@property (nonatomic, copy) NSString *docRevInd;

@property (nonatomic, copy) NSString *docCde;

@property (nonatomic,copy)  NSString *countMaterial;

@end

@interface CheckMsgFcxx : NSObject

@property (nonatomic, copy) NSString *docDesc;

@property (nonatomic, copy) NSString *FCXX;

@property (nonatomic, copy) NSString *docCde;

@end

@interface CheckMsgRlsb : NSObject

@property (nonatomic, copy) NSString *code;

@property (nonatomic, copy) NSString *flag;

@property (nonatomic, copy) NSString *isPass;

@property (nonatomic, strong) NSArray<CheckMsgAttachlist *> *attachList;

@end

@interface CheckMsgAttachlist : NSObject

@property (nonatomic, copy) NSString *docDesc;

@property (nonatomic, copy) NSString *docCde;

@property (nonatomic, copy) NSString *countMaterial;

- (instancetype)initWith:(FaceSuccessAttachlist *)faceAttachlist;

@end

@interface CheckMsgQtyx : NSObject

@property (nonatomic, copy) NSString *countMaterial;

@property (nonatomic, copy) NSString *docDesc;

@property (nonatomic, copy) NSString *docCde;

@property (nonatomic, copy) NSString *docAccInd;

@end

