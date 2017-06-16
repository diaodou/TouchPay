//
//  CheckMsgModel.m
//  personMerchants
//
//  Created by 百思为科 on 16/11/21.
//  Copyright © 2016年 海尔金融. All rights reserved.
//

#import "CheckMsgModel.h"

@implementation CheckMsgModel

@end



@implementation CheckMsgHead

@end


@implementation CheckMsgBody

+ (NSDictionary *)objectClassInArray{
    return @{@"QTYX" : [CheckMsgQtyx class]};
}

@end


@implementation CheckMsgGjj

@end


@implementation CheckMsgYhls

@end


@implementation CheckMsgClxx

@end


@implementation CheckMsgBcyx

+ (NSDictionary *)objectClassInArray{
    return @{@"list" : [CheckMsgList class]};
}

@end


@implementation CheckMsgList

@end


@implementation CheckMsgFcxx

@end


@implementation CheckMsgRlsb

+ (NSDictionary *)objectClassInArray{
    return @{@"attachList" : [CheckMsgAttachlist class]};
}

@end


@implementation CheckMsgAttachlist

- (instancetype)initWith:(FaceSuccessAttachlist *)faceAttachlist
{
    self = [super init];
    if(self)
    {
        self.docCde = faceAttachlist.docCde;
        self.docDesc = faceAttachlist.docDesc;
        self.countMaterial = faceAttachlist.countMaterial;
    }
    
    return self;
}

@end


@implementation CheckMsgQtyx

@end


