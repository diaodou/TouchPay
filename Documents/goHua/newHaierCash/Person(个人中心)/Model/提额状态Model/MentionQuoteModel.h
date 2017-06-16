//
//  MentionQuoteModel.h
//  personMerchants
//
//  Created by 张久健 on 16/8/3.
//  Copyright © 2016年 海尔金融. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MentionQuoteHead,MentionQuoteBody;
@interface MentionQuoteModel : NSObject

@property (nonatomic, strong) MentionQuoteHead *head;

@property (nonatomic, strong) MentionQuoteBody *body;

@end
@interface MentionQuoteHead : NSObject

@property (nonatomic, copy) NSString *retFlag;

@property (nonatomic, copy) NSString *retMsg;

@end

@interface MentionQuoteBody : NSObject

@property (nonatomic, copy) NSString *apprvCrdAmt;

@property (nonatomic, copy) NSString *applyDt;

@property (nonatomic, copy) NSString *appOutAdvice;

@property (nonatomic, copy) NSString * applSeq;

@property (nonatomic, copy) NSString * outSts;

@property (nonatomic, copy) NSString *operateTime;

@end

