//
//  DetailsViewController.h
//  读取通讯录
//
//  Created by 2 on 16/4/16.
//  Copyright © 2016年 MAC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddressBook.h"
#import "HCBaseViewController.h"

@protocol SendPhoneDelegate <NSObject>

-(void)sendPhone:(NSString *)number;

@end

@interface DetailsViewController : HCBaseViewController

@property(nonatomic,weak)id<SendPhoneDelegate> delegate;

@property (nonatomic, strong) AddressBook *address;
@end
