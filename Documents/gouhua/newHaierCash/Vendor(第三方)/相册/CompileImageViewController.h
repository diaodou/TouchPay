//
//  CompileImageViewController.h
//  编辑影像
//
//  Created by 史长硕 on 16/4/14.
//  Copyright © 2016年 史长硕. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PortraitImageModel.h"
#import "UpImagesTypes.h"
//#import "EnumCollection.h"
#import "BoostGesture.h"
@protocol SendImageDelegate <NSObject>

-(void)sendResultNumber:(NSInteger )number array:(NSMutableArray *)imgArray;

@end

@interface CompileImageViewController : UIViewController

@property(nonatomic,assign)NSInteger kissNum;//用来判断图片返回给那个cell

@property(nonatomic,strong)NSMutableArray *imageArray;//图片数组

@property(nonatomic,weak)id<SendImageDelegate> delegate;

@property (nonatomic, copy) NSString *strOrder; //订单号

@property (nonatomic, strong) UpImageTypeBody *imageType;

@property(nonatomic,strong)UITableView *selectTable;//可选影像名称列表

@property(nonatomic,strong)PortraitBody *lookBody;

@property(nonatomic,strong) NSMutableArray *selectNameArray;

@property(nonatomic,copy)NSString *typCde;//贷款品种代码

@property(nonatomic,copy)NSString *flowName;

@property(nonatomic,copy)NSString *selectCount;

@property(nonatomic,assign)BOOL usePhoto;//是否只能使用相机
@end


