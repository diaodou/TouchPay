//
//  DSComposePhotoViewCell.m
//  DSLolita
//
//  Created by 赛 丁 on 15/6/1.
//  Copyright (c) 2015年 samDing. All rights reserved.
//

#import "DSComposePhotoViewCell.h"
#import <AssetsLibrary/AssetsLibrary.h>


@interface DSComposePhotoViewCell()

//@property (nonatomic , strong) UIImageView *imageView;

@end

@implementation DSComposePhotoViewCell


- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if(self){
        
        self.backgroundColor = [UIColor clearColor];
        

        [self imageView];
    }

    return self;
}


- (void)setAsset:(JKAssets *)asset {
    
    if (asset){
        _asset = asset;
        
//        ALAssetsLibrary *lib = [[ALAssetsLibrary alloc] init];
//        
//        [lib assetForURL:_asset.assetPropertyURL resultBlock:^(ALAsset *asset){
//            if (asset) {
//                self.imageView.image = [UIImage imageWithCGImage:[[asset defaultRepresentation] fullScreenImage]];
//            }
//        }failureBlock:^(NSError *error){
//            
//        }];

        self.imageView.image  = asset.photo;
    }
    
}


- (UIImageView *)imageView{
    
    if(!_imageView){
        
        _imageView = [[UIImageView alloc] initWithFrame:self.contentView.bounds];
        _imageView.backgroundColor = [UIColor clearColor];
        _imageView.clipsToBounds = YES;
        _imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        //_imageView.layer.cornerRadius = 6.0f;
        _imageView.layer.borderColor = [UIColor clearColor].CGColor;
//        _imageView.layer.borderWidth = 0.5;
        
        
        UIButton *buttonClose = [[UIButton alloc] init];
        UIImageView *imgCloseButton = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 23, 23)];
        imgCloseButton.image = [UIImage imageNamed:@"关闭"];
        [buttonClose addSubview:imgCloseButton];
        //[buttonClose addTarget:self action:@selector(deletePhoto) forControlEvents:UIControlEventTouchUpInside];

        
        buttonClose.frame = CGRectMake(_imageView.frame.size.width-25, 2, 23, 23);
        self.deletePhotoButton = buttonClose;
        [self.contentView addSubview:_imageView];
        [self.contentView addSubview:buttonClose];
    }
    return _imageView;
}

@end
