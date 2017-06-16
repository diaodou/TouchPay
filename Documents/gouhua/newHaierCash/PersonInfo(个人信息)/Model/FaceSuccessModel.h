//
//  FaceSuccessModel.h
//  HaiercashMerchantsAPP
//
//  Created by 2 on 16/6/10.
//  Copyright © 2016年 海尔金融. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ChooseNameModel.h"
@class FaceSuccessHead,FaceSuccessBody,FaceSuccessAttachlist;
@interface FaceSuccessModel : NSObject

@property(nonatomic,strong)FaceSuccessHead *head;
@property(nonatomic,strong)FaceSuccessBody *body;
@end
@interface FaceSuccessHead : NSObject

@property(nonatomic,copy)NSString *retFlag;

@property(nonatomic,copy)NSString *retMsg;

@end
@interface FaceSuccessBody : NSObject

@property(nonatomic,copy)NSString *isOK;

@property(nonatomic,copy)NSString *isRetry;

@property(nonatomic,copy)NSString *isResend;

@property(nonatomic,strong)NSArray<FaceSuccessAttachlist *> *attachList;

@end

@interface FaceSuccessAttachlist : NSObject

@property (nonatomic, copy) NSString *docDesc;

@property (nonatomic, copy) NSString *docCde;

@property (nonatomic, copy) NSString *countMaterial;

@end