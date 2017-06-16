//
//  AddressDetailViewController.h
//  HaiercashMerchantsAPP
//
//  Created by 史长硕 on 16/4/19.
//  Copyright © 2016年 海尔金融. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HCBaseViewController.h"

typedef NS_ENUM(NSInteger,AddressType)
{
    RegAddressType = 1,        //户籍地址
    PostAddressType,           //通讯地址
    HouseAddressType,          //房产地址
};


@interface AddressDetailViewController : HCBaseViewController

@property (nonatomic,copy) void(^sendAddress)(NSDictionary *);

@property (nonatomic,assign) AddressType addressType;    //选择的地址类型

@end
