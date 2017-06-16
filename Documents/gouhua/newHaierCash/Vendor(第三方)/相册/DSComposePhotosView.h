//
//  DSComposePhotosView.h
//  DSLolita
//
//  Created by 赛 丁 on 15/5/28.
//  Copyright (c) 2015年 samDing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "JKImagePickerController.h"
#import "DSComposePhotoViewCell.h"
#import "JKPhotoBrowser.h"

@protocol DSComposePhotosViewDelegate <NSObject>

@optional
- (void)collectClick:(BOOL)bopen withObject:(JKAssets *)asset; //YES 是预览图片
@end


@interface DSComposePhotosView : UIView<JKPhotoBrowserDelegate,UIImagePickerControllerDelegate>

@property (nonatomic , retain) UICollectionView *collectionView;
@property (nonatomic , strong) NSMutableArray *assetsArray;
@property (nonatomic , strong) UIButton *addButton;
@property (nonatomic , strong) NSArray *selectedPhotos;
//@property (nonatomic, strong) NSMutableArray *assetsArray;
@property (nonatomic, strong) ALAssetsLibrary     *assetsLibrary;
@property (nonatomic , weak) id <DSComposePhotosViewDelegate> delegate;
@end
