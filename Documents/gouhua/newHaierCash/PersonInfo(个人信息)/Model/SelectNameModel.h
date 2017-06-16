//
//  SelectNameModel.h
//  HaiercashMerchantsAPP
//
//  Created by 史长硕 on 16/8/5.
//  Copyright © 2016年 海尔金融. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SelectNameHead,SelectNameBody;
@interface SelectNameModel : NSObject

@property (nonatomic, strong) SelectNameHead *head;

@property (nonatomic, strong) NSArray<SelectNameBody *> *body;

@end

@interface SelectNameHead : NSObject

@property (nonatomic, copy) NSString *retFlag;

@property (nonatomic, copy) NSString *retMsg;

@end

@interface SelectNameBody : NSObject

@property (nonatomic, copy) NSString *docDesc;

@property (nonatomic, copy) NSString *docRevInd;

@property (nonatomic, copy) NSString *docCde;

@end

