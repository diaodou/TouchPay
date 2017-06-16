//
//  ContractConfirmModel.h
//  personMerchants
//
//  Created by 张久健 on 16/6/4.
//  Copyright © 2016年 海尔金融. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ContactConfirmHead,ContactConfirmBody;
@interface ContractConfirmModel : NSObject

@property (nonatomic, strong) ContactConfirmHead *head;

@property(nonatomic,strong)  ContactConfirmBody *body;

@end
@interface ContactConfirmHead : NSObject

@property (nonatomic, copy) NSString *retFlag;

@property (nonatomic, copy) NSString *retMsg;

@end
@interface ContactConfirmBody : NSObject

@property (nonatomic, copy) NSString *appl_seq;

@property (nonatomic, copy) NSString *applCde;

@end

