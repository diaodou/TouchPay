//
//  QuoteStateViewController.h
//  personMerchants
//
//  Created by 百思为科 on 16/7/28.
//  Copyright © 2016年 海尔金融. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HCBaseViewController.h"
#import "MentionQuoteModel.h"
@interface QuoteStateViewController : HCBaseViewController
@property(nonatomic,strong)MentionQuoteModel *mentionModel;
@property(nonatomic,copy)NSString *msg; //提示信息
@end
