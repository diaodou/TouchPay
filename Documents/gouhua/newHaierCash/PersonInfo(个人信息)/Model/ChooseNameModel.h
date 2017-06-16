//
//  ChooseNameModel.h
//  HaiercashMerchantsAPP
//
//  Created by 史长硕 on 16/5/24.
//  Copyright © 2016年 海尔金融. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"
@class ChooseNameHead,ChooseNameBody;
@interface ChooseNameModel : NSObject

@property (nonatomic, strong) ChooseNameHead *head;

@property (nonatomic, strong) NSArray<ChooseNameBody *> *body;

@end
@interface ChooseNameHead : NSObject

@property (nonatomic, copy) NSString *retFlag;

@property (nonatomic, copy) NSString *retMsg;

@end

@interface ChooseNameBody : NSObject

@property (nonatomic, copy) NSString *docDesc;

@property (nonatomic, copy) NSString *docCde;

@property(nonatomic,copy)NSString *docRevInd;

@property(nonatomic,copy)NSString *countMaterial;

@end

