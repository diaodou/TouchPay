//
//  BankViewController.h
//  Information
//
//  Created by 百思为科iOS on 16/3/31.
//  Copyright © 2016年 百思为科iOS. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "EnumCollection.h"
#import "BankLIstMode.h"

@protocol CreditBankCardDelegate <NSObject>
@optional
-(void)changeBank:(NSString *)sumbit last:(NSString *)num bankName:(NSString *)name;
- (void)changeBank:(BankInfo *)backinfo;

@end

@protocol ChoiceDefaultBankDelegate <NSObject>

- (void)choiceBank:(BankInfo *)backinfo;

@end
typedef NS_ENUM(NSInteger, ChoiceBank){
    
    choiceCreditCard = 1,  //选择放款卡
    
    choiceDefaultCard,    //选择默认还款卡
    choicePayCard         //贷款详情节点选择默认还款卡
};
@interface AddBankViewController : UIViewController

@property(nonatomic,copy)NSString *sumbitStr;

@property(nonatomic,weak)id<CreditBankCardDelegate>creditBankCardDelegate;

@property(nonatomic,weak)id<ChoiceDefaultBankDelegate>choiceDefaultDelegate;

//@property(nonatomic,assign)MineFlowName flowName;

@property(nonatomic,assign)ChoiceBank choiceBank;

@property(nonatomic,copy)NSString *payMaxMoney;

@end
