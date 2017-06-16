//
//  ImageTableViewCell.m
//  HaiFu
//
//  Created by 史长硕 on 17/2/9.
//  Copyright © 2017年 百思为科. All rights reserved.
//

#import "ImageTableViewCell.h"
#import "HCMacro.h"
#import "UIFont+AppFont.h"
#import <YYWebImage.h>
#import "AppDelegate.h"
#import "BSVKHttpClient.h"
#import "UIColor+DefineNew.h"
@interface ImageTableViewCell ()

{
    
    float x;
    
    UIImageView *imageView;//加载影像视图
    
    UILabel *leftNumLab;//数量label
    
    UILabel *leftTitleLab;//标题label
    
    UIImageView *rightView;//右侧影像视图
    
    UILabel *rirhtNumLab;//数量label
    
    UILabel *rightTitleLab;//标题label
    
}

@end

@implementation ImageTableViewCell

#pragma mark --> life Cycle


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        x = DeviceWidth/414.0;
        
        [self creatUI];
        
    }
    
    return self;

}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

#pragma mrk --> private Methods

-(void)creatUI{
    
    imageView = [[UIImageView alloc]initWithFrame:CGRectMake((DeviceWidth-256*x)/3, 15*x, 128*x, 83*x)];
    
    imageView.backgroundColor = [UIColor UIColorWithHexColorString:@"0xf1f1f1" AndAlpha:1.0];
    
    [self.contentView addSubview:imageView];
    
    leftNumLab =[[UILabel alloc]initWithFrame:CGRectMake((DeviceWidth-256*x)/3, 15*x, 128*x, 83*x)];
    
    leftNumLab.font = [UIFont appFontRegularOfSize:50*x];
    
    leftNumLab.textAlignment = NSTextAlignmentCenter;
    
    leftNumLab.backgroundColor  = [UIColor UIColorWithHexColorString:@"0x000000" AndAlpha:0.6];
    
    leftNumLab.textColor = [UIColor whiteColor];
    
    [self.contentView addSubview:leftNumLab];
    
    _lefeButton = [[CustomButton alloc]initWithFrame:CGRectMake((DeviceWidth-256*x)/3, 15*x, 128*x, 83*x)];
    
    _lefeButton.backgroundColor = [UIColor clearColor];
    
    [self.contentView addSubview:_lefeButton];
    
    leftTitleLab =[[UILabel alloc]initWithFrame:CGRectMake((DeviceWidth-256*x)/3, 115*x, 128*x, 50*x)];
    
    leftTitleLab.numberOfLines = 0;
    
    leftTitleLab.font = [UIFont appFontRegularOfSize:15];
    
    leftTitleLab.textColor =[UIColor UIColorWithHexColorString:@"0x858585" AndAlpha:1.0];
    
    leftTitleLab.textAlignment  =NSTextAlignmentCenter;
    
    [self.contentView addSubview:leftTitleLab];
    
    rightView = [[UIImageView alloc]initWithFrame:CGRectMake(DeviceWidth-128*x-(DeviceWidth-256*x)/3, 15*x, 128*x, 83*x)];
    
    rightView.backgroundColor =[UIColor UIColorWithHexColorString:@"0xf1f1f1" AndAlpha:1.0];
    
    [self.contentView addSubview:rightView];
  
    rirhtNumLab =[[UILabel alloc]initWithFrame:CGRectMake(DeviceWidth-128*x-(DeviceWidth-256*x)/3, 15*x, 128*x, 83*x)];
    
    rirhtNumLab.font = [UIFont appFontRegularOfSize:50*x];
    
    rirhtNumLab.textAlignment = NSTextAlignmentCenter;
    
    rirhtNumLab.backgroundColor  = [UIColor UIColorWithHexColorString:@"0x000000" AndAlpha:0.6];
    
    rirhtNumLab.textColor = [UIColor whiteColor];
    
    [self.contentView addSubview:rirhtNumLab];
    
    _rightButton = [[CustomButton alloc]initWithFrame:CGRectMake(DeviceWidth-128*x-(DeviceWidth-256*x)/3, 15*x, 128*x, 83*x)];
    
    _rightButton.backgroundColor = [UIColor clearColor];
    
    [self.contentView addSubview:_rightButton];
    
    rightTitleLab =[[UILabel alloc]initWithFrame:CGRectMake(DeviceWidth-128*x-(DeviceWidth-256*x)/3, 115*x, 128*x, 50*x)];
    
    rightTitleLab.numberOfLines = 0;
    
    rightTitleLab.font = [UIFont appFontRegularOfSize:15];
    
    rightTitleLab.textColor = [UIColor UIColorWithHexColorString:@"0x858585" AndAlpha:1.0];
    
    rightTitleLab.textAlignment  =NSTextAlignmentCenter;
    
    [self.contentView addSubview:rightTitleLab];

    
}

-(void)insertArray:(NSArray *)modelArray{
    
    if (modelArray.count > 1) {
        
        NSMutableDictionary *dicOne = modelArray[0];
        
        PortraitBody *body = [dicOne objectForKey:@"PortraitBody"];
        
        CheckMsgList *model = [dicOne objectForKey:@"ChooseNameBody"];
        
        if (body) {
            
            NSString *url = body.ID;
            
            _lefeButton.imageModel = body;
            
            NSData *tempData =(NSData *)[[AppDelegate delegate].imagePutCache objectForKey:ImageUrl(url)];
            
            if (tempData) {
                
                imageView.image = [UIImage imageWithData:tempData];
                
            }else{
                
                [imageView yy_setImageWithURL:[NSURL URLWithString:ImageUrl(url)] placeholder:[UIImage imageNamed:@"加载展位图"] options:YYWebImageOptionIgnoreDiskCache completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
                    
//                    [[AppDelegate delegate].imagePutCache setObject:UIImageJPEGRepresentation(image, 0.6) forKey:url.absoluteString];
                    
                }];
            }
            
            if ([body.attachName isEqualToString:@"身份证正面"]) {
                
                leftNumLab.hidden = YES;
                
            }else if ([body.attachName isEqualToString:@"身份证反面"]){
                
                leftNumLab.hidden = YES;
                
            }else{
                
                leftNumLab.hidden = NO;
                
                leftNumLab.text = [NSString stringWithFormat:@"%ld",(long)body.count];
            }
            
        }else{
            
            imageView.image = [UIImage imageNamed:@"默认照片"];
            
            leftNumLab.hidden = YES;
            
            _lefeButton.imageModel = nil;
            
            
        }
        
        leftTitleLab.text = model.docDesc;
        
        _lefeButton.nameBody = model;
        
        NSMutableDictionary *dicTwo = modelArray[1];
        
        PortraitBody *bodyTwo = [dicTwo objectForKey:@"PortraitBody"];
        
        CheckMsgList *modelTwo = [dicTwo objectForKey:@"ChooseNameBody"];
        
        if (bodyTwo) {
            
            NSString *url = bodyTwo.ID;
            
            NSData *tempData =(NSData *)[[AppDelegate delegate].imagePutCache objectForKey:ImageUrl(url)];
            
            
            if (tempData) {
                
                rightView.image = [UIImage imageWithData:tempData];
                
            }else{
                
                [rightView yy_setImageWithURL:[NSURL URLWithString:ImageUrl(url)] placeholder:[UIImage imageNamed:@"加载展位图"] options:YYWebImageOptionIgnoreDiskCache completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
                    
                    [[AppDelegate delegate].imagePutCache setObject:UIImageJPEGRepresentation(image, 0.6) forKey:url.absoluteString];
                    
                }];
            }
            
            if ([bodyTwo.attachName isEqualToString:@"身份证正面"]) {
                
                rirhtNumLab.hidden = YES;
                
            }else if ([bodyTwo.attachName isEqualToString:@"身份证反面"]){
                
                rirhtNumLab.hidden = YES;
                
            }else{
                
                rirhtNumLab.hidden = NO;
                
                rirhtNumLab.text = [NSString stringWithFormat:@"%ld",(long)bodyTwo.count];
            }
            
            _rightButton.imageModel = bodyTwo;
            
        }else{
            
            rightView.image = [UIImage imageNamed:@"默认照片"];
            
            rirhtNumLab.hidden = YES;
            
            _rightButton.imageModel = nil;
            
            
        }
        
        rightTitleLab.text = modelTwo.docDesc;

        _rightButton.nameBody = modelTwo;
        
        
        
    }else if (modelArray.count > 0){
        
        NSMutableDictionary *dicOne = modelArray[0];
        
        rightTitleLab.hidden = YES;
        
        rightView.hidden = YES;
        
        rirhtNumLab.hidden = YES;
        
        _rightButton.hidden = YES;
        
        PortraitBody *body = [dicOne objectForKey:@"PortraitBody"];
        
        CheckMsgList *model = [dicOne objectForKey:@"ChooseNameBody"];
        
        _lefeButton.nameBody = model;
        
        if (body) {
            
            _lefeButton.imageModel = body;
            
            NSString *url = body.ID;
            
            NSData *tempData =(NSData *)[[AppDelegate delegate].imagePutCache objectForKey:ImageUrl(url)];
            
            
            if (tempData) {
                
                imageView.image = [UIImage imageWithData:tempData];
                
            }else{
                
                [imageView yy_setImageWithURL:[NSURL URLWithString:ImageUrl(url)] placeholder:[UIImage imageNamed:@"加载展位图"] options:YYWebImageOptionIgnoreDiskCache completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
                    
                    [[AppDelegate delegate].imagePutCache setObject:UIImageJPEGRepresentation(image, 0.6) forKey:url.absoluteString];
                    
                }];
            }
            
            if ([body.attachName isEqualToString:@"身份证正面"]) {
                
                leftNumLab.hidden = YES;
                
            }else if ([body.attachName isEqualToString:@"身份证反面"]){
                
                leftNumLab.hidden = YES;
                
            }else{
                
                leftNumLab.hidden = NO;
                
                leftNumLab.text = [NSString stringWithFormat:@"%ld",(long)body.count];
            }
            
        }else{
            
            imageView.image = [UIImage imageNamed:@"默认照片"];
            
            leftNumLab.hidden = YES;
            
            _lefeButton.imageModel = nil;
            
            
        }
        
        leftTitleLab.text = model.docDesc;
        
 
        
    }
    
}

-(void)insertImageModel:(PortraitBody *)body nameModel:(ChooseNameBody *)model{
    
    if (body) {
        
        NSString *url = body.ID;
        
        NSData *tempData =(NSData *)[[AppDelegate delegate].imagePutCache objectForKey:ImageUrl(url)];
        
        
        if (tempData) {
            
            imageView.image = [UIImage imageWithData:tempData];
            
        }else{
            
            [imageView yy_setImageWithURL:[NSURL URLWithString:ImageUrl(url)] placeholder:[UIImage imageNamed:@"加载展位图"] options:YYWebImageOptionIgnoreDiskCache completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
                
                [[AppDelegate delegate].imagePutCache setObject:UIImageJPEGRepresentation(image, 0.6) forKey:url.absoluteString];
                
            }];
        }
        
        if ([body.attachName isEqualToString:@"身份证正面"]) {
            
            leftNumLab.hidden = YES;
            
        }else if ([body.attachName isEqualToString:@"身份证反面"]){
            
            leftNumLab.hidden = YES;
            
        }else{
            
            leftNumLab.text = [NSString stringWithFormat:@"%ld",(long)body.count];
        }
        
    }else{
        
        imageView.image = [UIImage imageNamed:@"默认照片"];
        
        leftNumLab.hidden = YES;
        
        
    }
    
    leftTitleLab.text = model.docDesc;

    
}

@end
