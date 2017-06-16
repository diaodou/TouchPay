//
//  updateRiskInfoModel.h
//  personMerchants
//
//  Created by 百思为科 on 16/6/12.
//  Copyright © 2016年 海尔金融. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MJExtension.h>
@class UpdateRiskInforesponse,UpdateRiskInfoHead,UpdateRiskInfoBody;
@interface UpdateRiskInfoModel : NSObject

@property (nonatomic, strong) UpdateRiskInforesponse *response;

@end

@interface UpdateRiskInforesponse : NSObject

@property (nonatomic, strong) UpdateRiskInfoHead *head;

@property (nonatomic, strong) UpdateRiskInfoBody *body;

@end

@interface UpdateRiskInfoHead : NSObject

@property (nonatomic, copy) NSString *retFlag;

@property (nonatomic, copy) NSString *retMsg;

@property (nonatomic, copy) NSString *serno;

@end


@interface UpdateRiskInfoBody : NSObject

@property (nonatomic, copy) NSString *reserved3;

@property (nonatomic, copy) NSString *reserved2;

@property (nonatomic, copy) NSString *reserved1;

@property (nonatomic, copy) NSString *idNo;

@property (nonatomic, copy) NSString *reserved5;

@property (nonatomic, copy) NSString *reserved4;


@end
