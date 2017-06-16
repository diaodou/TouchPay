//
//  CityRangeModel.h
//  personMerchants
//
//  Created by 百思为科 on 16/5/30.
//  Copyright © 2016年 海尔金融. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CityRangeHead,CityRangeBody;
@interface CityRangeModel : NSObject

@property (nonatomic, strong) CityRangeHead *head;

@property (nonatomic, strong) NSArray<CityRangeBody *> *body;

@end



@interface CityRangeHead : NSObject

@property (nonatomic, copy) NSString *retFlag;

@property (nonatomic, copy) NSString *retMsg;

@end

@interface CityRangeBody : NSObject

@property (nonatomic, copy) NSString *provinceCode;

@property (nonatomic, copy) NSString *cityCode;

@end

