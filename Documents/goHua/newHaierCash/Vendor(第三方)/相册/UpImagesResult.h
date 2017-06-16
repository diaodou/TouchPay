//
//  UpImagesResult.h
//  HaiercashMerchantsAPP
//
//  Created by xuxie on 16/5/20.
//  Copyright © 2016年 海尔金融. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UpImageTypeHead,UpImageResultBody;
@interface UpImagesResult : NSObject

@property (nonatomic, strong) UpImageTypeHead *head;

@property (nonatomic, strong) UpImageResultBody *body;

@end


@interface UpImageResultBody : NSObject

@property (nonatomic, copy) NSString *ID;


@end