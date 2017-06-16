//
//  DSComposePhotosView.m
//  DSLolita
//
//  Created by 赛 丁 on 15/5/28.
//  Copyright (c) 2015年 samDing. All rights reserved.
//

#import "DSComposePhotosView.h"
#import "DSComposePhotoViewCell.h"


#define kSizeThumbnailCollectionView  ([UIScreen mainScreen].bounds.size.width-37)/3
@interface DSComposePhotosView()<JKImagePickerControllerDelegate , UICollectionViewDataSource , UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>


@end

@implementation DSComposePhotosView



- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self){
        self.userInteractionEnabled =  YES;
    }
    
    return self;
}

-(void)runInMainQueue:(void (^)())queue{
    dispatch_async(dispatch_get_main_queue(), queue);
}

-(void)runInGlobalQueue:(void (^)())queue{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), queue);
}

-(void)setAssetsArray:(NSMutableArray *)assetsArray {
    
    _assetsArray = assetsArray;
    
    NSMutableArray *tempbox = [NSMutableArray array];
    for(JKAssets *asset in assetsArray){
        if (asset.photo) {
            [tempbox addObject:asset.photo];
        }
    }
    
    self.selectedPhotos = [NSArray arrayWithArray:tempbox];
}

static NSString *kPhotoCellIdentifier = @"kPhotoCellIdentifier";

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (self.assetsArray.count == 0 || self.assetsArray.count == 3) {
        return self.assetsArray.count;
    }
    else
    {
        return [self.assetsArray count] + 1;
    }
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
     DSComposePhotoViewCell *cell = (DSComposePhotoViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:kPhotoCellIdentifier forIndexPath:indexPath];
    if (self.assetsArray.count == 3)
    {
       
        cell.asset = [self.assetsArray objectAtIndex:[indexPath row]];
        
        cell.deletePhotoButton.tag = indexPath.row;
        cell.indexpath = indexPath;
        cell.deletePhotoButton.hidden = NO;
        [cell.deletePhotoButton addTarget:self action:@selector(deleteView:) forControlEvents:UIControlEventTouchUpInside];
//        return cell;
    }
    else
    {
        
        if (indexPath.row < self.assetsArray.count) {
//            DSComposePhotoViewCell *cell = (DSComposePhotoViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:kPhotoCellIdentifier forIndexPath:indexPath];
            cell.asset = [self.assetsArray objectAtIndex:[indexPath row]];
            
            cell.deletePhotoButton.tag = indexPath.row;
            cell.indexpath = indexPath;
            cell.deletePhotoButton.hidden = NO;
            [cell.deletePhotoButton addTarget:self action:@selector(deleteView:) forControlEvents:UIControlEventTouchUpInside];
//            return cell;
        }
        else
        {
//            DSComposePhotoViewCell *cell = (DSComposePhotoViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:kPhotoCellIdentifier forIndexPath:indexPath];
            cell.imageView.image = [UIImage imageNamed:@"添加"];
            cell.deletePhotoButton.hidden = YES;
            cell.indexpath = indexPath;
//            return cell;
        }
    }
    return cell;
}

- (void)deleteView:(id)sender{
    
    NSInteger deletedPhoto = ((UIButton *)sender).tag;
    for (DSComposePhotoViewCell *currentCell in [self.collectionView subviews]){
        
        if (deletedPhoto == currentCell.indexpath.row){
            
            if (self.assetsArray.count > 0){
                [self.assetsArray removeObjectAtIndex:deletedPhoto];
                [UIView animateWithDuration:1 animations:^{
            
                    
                }completion:^(BOOL finished) {
                    
                }];

            }
            
        }
        
        
    }
    [self.collectionView reloadData];

    

}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(kSizeThumbnailCollectionView, kSizeThumbnailCollectionView);
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%ld",(long)[indexPath row]);
    if (indexPath.row  < self.assetsArray.count) {
        [self previewPhotoesSelected:indexPath.row];
    }
    else
    {
        if ([self.delegate respondsToSelector:@selector(collectClick:withObject:)]) {
            [self.delegate collectClick:NO withObject:nil];
        }
    }
}
- (ALAssetsLibrary *)assetsLibrary{
    if (!_assetsLibrary) {
        _assetsLibrary = [[ALAssetsLibrary alloc] init];
    }
    return _assetsLibrary;
}

- (void)previewPhotoesSelected:(NSInteger)page
{
    [self passSelectedAssets:page];
}
#pragma mark - Managing Assets
- (void)passSelectedAssets:(NSInteger)page
{
    // Load assets from URLs
    __block NSMutableArray *assets = [NSMutableArray array];
    
    for (JKAssets *jka in self.assetsArray) {
        __weak typeof(self) weakSelf = self;
        [self.assetsLibrary assetForURL:jka.assetPropertyURL
                            resultBlock:^(ALAsset *asset) {
                                // Add asset
                                [assets addObject:asset];
                                // Check if the loading finished
                                if (assets.count == weakSelf.assetsArray.count) {
                                    [weakSelf browerPhotoes:assets page:page];
                                }
                            } failureBlock:^(NSError *error) {
                                
                            }];
    }
}

- (void)browerPhotoes:(NSArray *)array page:(NSInteger)page
{
    JKPhotoBrowser  *photoBorwser = [[JKPhotoBrowser alloc] initWithFrame:[UIScreen mainScreen].bounds isSelect:NO];
    photoBorwser.delegate = self;
    photoBorwser.currentPage = page;
    photoBorwser.assetsArray = [NSMutableArray arrayWithArray:array];
    [photoBorwser show:YES];
}

- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 3.0;
        layout.minimumInteritemSpacing = 3.0;
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(3.5, 30, CGRectGetWidth(self.frame)-7, CGRectGetHeight(self.frame)-70) collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor clearColor];
        [_collectionView registerClass:[DSComposePhotoViewCell class] forCellWithReuseIdentifier:kPhotoCellIdentifier];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.userInteractionEnabled = YES;
        [self addSubview:_collectionView];
        
        
    }
    return _collectionView;
}


@end
