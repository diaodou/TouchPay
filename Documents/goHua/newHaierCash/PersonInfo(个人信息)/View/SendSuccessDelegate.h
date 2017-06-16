//
//  SendSuccessDelegate.h
//  HaiercashMerchantsAPP
//
//  Created by 史长硕 on 17/1/12.
//  Copyright © 2017年 海尔金融. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ShowType.h"
//#import "EnumCollection.h"
//#import "CheckEdApplModel.h"
@protocol SendSuccessDelegate <NSObject>

- (void)sendSaveInfoViewType:(ShowUnlockType)type;

-(void)sendViewShow:(BOOL)show;



//- (void)toApplySuccessViewController:(QuoteApplyStatus)applyStatus CheckEdApplModel:(CheckEdApplModel *)model;

@optional

-(void)sendHaveLimit;

@end
