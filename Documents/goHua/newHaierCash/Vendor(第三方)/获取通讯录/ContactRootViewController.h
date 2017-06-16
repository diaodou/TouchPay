//
//  RootViewController.h
//  读取通讯录
//
//  Created by mac on 15/4/16.
//  Copyright (c) 2015年 MAC. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SendPhoneNumDelegate <NSObject>

@optional
-(void)sendPhone:(NSString *)number;

-(void)sendName:(NSString *)name;

-(void)sendPhoneNumBack;

@end



@interface ContactRootViewController : UIViewController

@property(nonatomic,weak)id<SendPhoneNumDelegate> delegate;

@property(nonatomic,strong) NSMutableArray *newaArray;

@property(nonatomic,assign)NSInteger kiss;  //判断返回名字还是号码
@end

