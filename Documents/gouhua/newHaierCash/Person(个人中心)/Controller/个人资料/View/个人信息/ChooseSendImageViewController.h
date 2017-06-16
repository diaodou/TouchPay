//
//  ChooseSendImageViewController.h
//  personMerchants
//
//  Created by LLM on 16/11/26.
//  Copyright © 2016年 海尔金融. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CheckMsgModel.h"

@interface ChooseSendImageViewController : UIViewController

@property (nonatomic,assign) BOOL firstMentionQuote;          //判断是否是第一次提额

@property (nonatomic,strong) NSArray <CheckMsgQtyx *>*chooseSendTypeArray;      //选传影像类型列表

@property(nonatomic,assign)BOOL isFromTE;//是否从提额进入



@end
