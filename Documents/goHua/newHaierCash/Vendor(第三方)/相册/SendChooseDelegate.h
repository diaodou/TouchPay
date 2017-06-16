//
//  SendChooseDelegate.h
//  personMerchants
//
//  Created by 百思为科 on 16/6/2.
//  Copyright © 2016年 海尔金融. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SendChooseDelegate <NSObject>
-(void)sendChooseDic:(NSMutableDictionary *)parmDic fileData:(NSData *)fileData fileName:(NSString *)fileName count:(NSInteger)count;

-(void)sendChooseArray:(NSMutableArray *)parmArray fileData:(NSMutableArray *)fileDataArray fileName:(NSString *)fileName count:(NSInteger)count;

-(void)sendSelectImageNameDictory:(NSMutableDictionary *)parm;

@end
