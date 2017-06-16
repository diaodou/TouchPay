//
//  UpImagesTypes.h
//  HaiercashMerchantsAPP
//
//  Created by xuxie on 16/5/19.
//  Copyright © 2016年 海尔金融. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UpImageTypeHead,UpImageTypeBody;
@interface UpImagesTypes : NSObject

@property (nonatomic, strong) UpImageTypeHead *head;

@property (nonatomic, strong) NSArray<UpImageTypeBody *> *body;

@end
@interface UpImageTypeHead : NSObject

@property (nonatomic, copy) NSString *retFlag;

@property (nonatomic, copy) NSString *retMsg;

@end

@interface UpImageTypeBody : NSObject

@property (nonatomic, copy) NSString *docDesc;

@property (nonatomic, copy) NSString *docCde;

@end

