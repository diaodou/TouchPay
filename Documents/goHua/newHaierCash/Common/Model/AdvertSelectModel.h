//
//  AdvertSelectModel.h
//  personMerchants
//
//  Created by LLM on 16/9/24.
//  Copyright © 2016年 海尔金融. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AdvertSelectHead,AdvertSelectBody,Kpad,Jdad;
@interface AdvertSelectModel : NSObject

@property (nonatomic, strong) AdvertSelectHead *head;

@property (nonatomic, strong) AdvertSelectBody *body;

@end
@interface AdvertSelectHead : NSObject

@property (nonatomic, copy) NSString *retFlag;

@property (nonatomic, copy) NSString *retMsg;

@end

@interface AdvertSelectBody : NSObject

@property (nonatomic, strong) NSArray <Jdad *>*jdAd;

@property (nonatomic, strong) Kpad *kpAd;

@end

@interface Kpad : NSObject

@property (nonatomic, copy) NSString *adId;

@property (nonatomic, copy) NSString *showTime;

@property (nonatomic, copy) NSString *photoId;

@end

@interface Jdad : NSObject

@property (nonatomic,copy) NSString *adId;

@property (nonatomic,copy) NSString *photoId;

@property (nonatomic,copy) NSString *showTime;

@end

