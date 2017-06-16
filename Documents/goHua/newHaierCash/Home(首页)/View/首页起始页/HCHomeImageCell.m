//
//  HCHomeImageCell.m
//  newHaierCash
//
//  Created by Will on 2017/6/3.
//  Copyright © 2017年 haier. All rights reserved.
//

#import "HCMacro.h"

#import <SDCycleScrollView.h>
#import "UIColor+DefineNew.h"

#import "HCHomeInfoModel.h"

#import "HCHomeImageCell.h"

@interface HCHomeImageCell() <SDCycleScrollViewDelegate>{
    
    SDCycleScrollView *_goodsCycleView;
    CGFloat _viewScale;
    NSArray *_models;
}

@end

@implementation HCHomeImageCell

- (void)generateCellWithModels:(NSArray *)models {
    if (models.count <= 0) {
        return;
    }
    _models = models;
    NSMutableArray *imgArray = [NSMutableArray new];
    for (HomeChildModel *model in models) {
        if (model.picPath.length > 0) {
            [imgArray addObject:model.picPath];
        }
    }
    
    if (imgArray.count > 0) {
        _goodsCycleView.autoScrollTimeInterval = 3;
        if (imgArray.count == 1) {
            _goodsCycleView.infiniteLoop = NO;
        }
        _goodsCycleView.imageURLStringsGroup = imgArray;
    }

}

- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _viewScale = iphone6P ? scale6PAdapter : scaleAdapter;
        
        UIImage *placeImage = [[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/首页焦点默认图.png",[[NSBundle mainBundle] resourcePath]]];
        _goodsCycleView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, DeviceWidth, 132 * _viewScale) delegate:self placeholderImage:placeImage];
        _goodsCycleView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
        _goodsCycleView.pageDotColor = [UIColor whiteColor];
        _goodsCycleView.currentPageDotColor = [UIColor UIColorWithHexColorString:@"0x32beff" AndAlpha:1.0];
        _goodsCycleView.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
        _goodsCycleView.delegate = self;
        [self.contentView addSubview:_goodsCycleView];
    }
    
    return self;
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - SDCycleScrollViewDelegate

//点击图片回调
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    //逻辑处理
    HomeChildModel *model = _models[index];
    
    if (self.cellDelegate && [self.cellDelegate respondsToSelector:@selector(ADImageViewDidClcik:)]) {
        [self.cellDelegate ADImageViewDidClcik:model];
    }
}

@end
