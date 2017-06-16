//
//  DictionarisModel.h
//  personMerchants
//
//  Created by 百思为科 on 16/9/20.
//  Copyright © 2016年 海尔金融. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DictionarisHead,DictionarisBody,Local_Resid,Marr_Sts,Ppty_Live_Opt,Relation,Edu_Typ,Position_Opt,Curr_Situation,Com_Kind,Position,Mail_Addr;
@interface DictionarisModel : NSObject


@property (nonatomic, strong) DictionarisHead *head;

@property (nonatomic, strong) DictionarisBody *body;




@end
@interface DictionarisHead : NSObject

@property (nonatomic, copy) NSString *retFlag;

@property (nonatomic, copy) NSString *retMsg;

@end

@interface DictionarisBody : NSObject

@property (nonatomic, strong) NSArray<Local_Resid *> *LOCAL_RESID;

@property (nonatomic, strong) NSArray<Marr_Sts *> *MARR_STS;

@property (nonatomic, strong) NSArray<Ppty_Live_Opt *> *PPTY_LIVE_OPT;

@property (nonatomic, strong) NSArray<Relation *> *RELATION;

@property (nonatomic, strong) NSArray<Edu_Typ *> *EDU_TYP;

@property (nonatomic, strong) NSArray<Position_Opt *> *POSITION_OPT;

@property (nonatomic, strong) NSArray<Curr_Situation *> *CURR_SITUATION;

@property (nonatomic, strong) NSArray<Com_Kind *> *COM_KIND;

@property (nonatomic, strong) NSArray<Position *> *POSITION;

@property (nonatomic, strong) NSArray<Mail_Addr *> *MAIL_ADDR;

@end

@interface Local_Resid : NSObject

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *code;

@end

@interface Marr_Sts : NSObject

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *code;

@end

@interface Ppty_Live_Opt : NSObject

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *code;

@end

@interface Relation : NSObject

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *code;

@end

@interface Edu_Typ : NSObject

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *code;

@end

@interface Position_Opt : NSObject

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *code;

@end

@interface Curr_Situation : NSObject

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *code;

@end

@interface Com_Kind : NSObject

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *code;

@end

@interface Position : NSObject

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *code;

@end

@interface Mail_Addr : NSObject

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *code;

@end

