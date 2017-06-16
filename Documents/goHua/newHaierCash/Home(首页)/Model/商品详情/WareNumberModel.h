//
//  WareNumberModel.h
//  personMerchants
//
//  Created by 史长硕 on 2017/4/24.
//  Copyright © 2017年 海尔金融. All rights reserved.
//

#import <Foundation/Foundation.h>
@class WareNumberBody,WareNumberHead;
@interface WareNumberModel : NSObject

@property(nonatomic,strong)WareNumberHead *head;

@property(nonatomic,strong) WareNumberBody *body;//NSArray<WareNumberBody *> *body;

@end

@interface WareNumberHead : NSObject

@property(nonatomic,copy)NSString *retFlag;

@property(nonatomic,copy)NSString *retMsg;

@end

@interface WareNumberBody : NSObject

@property(nonatomic,copy)NSString *inventory;
@property(nonatomic,copy)NSString *price;


//@property(nonatomic,copy)NSString *goodsCode;
//
//@property(nonatomic,copy)NSString *goodsName;
//
//@property(nonatomic,copy)NSString *provinceCode;
//
//@property(nonatomic,copy)NSString *cityCode;
//
//@property(nonatomic,copy)NSString *areaCode;
//
//@property(nonatomic,copy)NSString *remark;

@end
