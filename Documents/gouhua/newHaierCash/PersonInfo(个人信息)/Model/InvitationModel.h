//
//  InvitationModel.h
//  personMerchants
//
//  Created by xuxie on 16/6/3.
//  Copyright © 2016年 海尔金融. All rights reserved.
//

#import <Foundation/Foundation.h>

@class InvitationHead,InvitationBody;
@interface InvitationModel : NSObject

@property (nonatomic, strong) InvitationHead *head;

@property (nonatomic, strong) InvitationBody *body;

@end
@interface InvitationHead : NSObject

@property (nonatomic, copy) NSString *retFlag;

@property (nonatomic, copy) NSString *retMsg;

@end

@interface InvitationBody : NSObject

@property (nonatomic, copy) NSString *isExits;

@end

