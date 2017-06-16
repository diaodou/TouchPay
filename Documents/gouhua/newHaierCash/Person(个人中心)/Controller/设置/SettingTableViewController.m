//
//  SettingTableViewController.m
//  personMerchants
//
//  Created by 陈相孔 on 16/3/30.
//  Copyright © 2016年 海尔金融. All rights reserved.
//

#import "SettingTableViewController.h"
#import "HCMacro.h"
#import <CoreLocation/CoreLocation.h>
#import "RMUniversalAlert.h"
#import "AppDelegate.h"
#import <MBProgressHUD.h>
#import "DefineSystemTool.h"
@interface SettingTableViewController ()<UITableViewDataSource,UITableViewDelegate,MBProgressHUDDelegate>
{
    MBProgressHUD *hud;
}
@property(nonatomic,strong)UILabel *message;
@property(nonatomic,strong)UILabel *pushState;
@property(nonatomic,strong)NSArray *nameArr;

@end

@implementation SettingTableViewController
#pragma mark - lift Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    NSArray *nameArr = @[@"接受新消息通知",@"要开启或者停用，您可以在设置>通知中心>嗨付中手动设置",@"开启位置服务",@"清除缓存",@"当前版本"];
    
   // [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(becomeActive) name:UIApplicationWillEnterForegroundNotification object:nil];
    self.nameArr = nameArr;
    self.view.backgroundColor =UIColorFromRGB(0xf6f6f6, 1);
    [self setNavi];
    self.message = [[UILabel alloc]initWithFrame:(CGRectMake(0, 0, 0, 0))];
    self.pushState = [[UILabel alloc]initWithFrame:(CGRectMake(0, 0, 0, 0))];
//    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"SettingCell"];
    self.tableView.frame = CGRectMake(0, 5*DeviceWidth/375, DeviceWidth, DeviceHeight);
    //    却掉多余的cell
    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    //    去除分割线
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;

    self.tableView.bounces = NO;
    //    判断是否开启接受新消息通知
    if ([self isAllowedNotification]) {
        self.pushState.text = @"已开启";
    }else{
        self.pushState.text = @"未开启";
    }
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.navigationItem.title = @"设置";
    hud = [[MBProgressHUD alloc]initWithView:self.view];
    hud.delegate = self;
}

//设置导航
- (void)setNavi {
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = ReturnRect;
    [backBtn setImage:[UIImage imageNamed:@"返回_黑"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(OnBackBtn:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
}

- (void)OnBackBtn:(UIButton *)btn {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 1) {
        return 40;
    }else{
        return 46;
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}
#pragma mark ---cell设置
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * reuseID = @"SettingCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:reuseID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UISwitch *locationSwitch = [[UISwitch alloc]init];
        locationSwitch.frame = CGRectMake(DeviceWidth - CGRectGetWidth(locationSwitch.frame) - 10, (46 - CGRectGetHeight(locationSwitch.frame))/2, 40, 28);
        [locationSwitch addTarget:self action:@selector(toLocation:) forControlEvents:(UIControlEventTouchUpInside)];
        locationSwitch.tag = 10;
        locationSwitch.hidden = YES;
        [cell.contentView addSubview:locationSwitch];
        

        
    }
    //    点击cell
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //    布局
    if (indexPath.row == 0) {
        self.message.frame = CGRectMake( 23*DeviceWidth/375,  14.5 , 290*DeviceWidth/375,  15);
        self.message.text = self.nameArr[indexPath.row];
        self.message.font = [UIFont systemFontOfSize:15];
        self.message.textColor = UIColorFromRGB(0x3d4245, 1);
        self.pushState.frame = CGRectMake(DeviceWidth/2,14.5,DeviceWidth/2 - 18*DeviceWidth/375,15);
        self.pushState.textAlignment = NSTextAlignmentRight;
        self.pushState.font = [UIFont systemFontOfSize:15];
        self.pushState.textColor = UIColorFromRGB(0x999999, 1);
        [cell.contentView addSubview:self.pushState];
        [cell.contentView addSubview:self.message];
    }else if (indexPath.row == 1){
        cell.backgroundColor = UIColorFromRGB(0xf6f6f6, 1);
        UILabel *temp = [[UILabel alloc]initWithFrame:CGRectMake(23*DeviceWidth/375, 16, DeviceWidth - 50*DeviceWidth/375, 12)];
        temp.adjustsFontSizeToFitWidth = YES;
        temp.text = self.nameArr[indexPath.row];
        temp.font = [UIFont systemFontOfSize:12];
        temp.textColor = UIColorFromRGB(0x999999, 1);
        temp.lineBreakMode = NSLineBreakByCharWrapping;
        [cell.contentView addSubview:temp];
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self.nameArr[1]];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:6];
        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [self.nameArr[1] length])];
        temp.attributedText = attributedString;
    }else if (indexPath.row == 3){
        UILabel *locate = [[UILabel alloc]initWithFrame:CGRectMake(23*DeviceWidth/375,14.5,180*DeviceWidth/375,15)];
        locate.textColor = UIColorFromRGB(0x3d4245, 1);
        locate.text = self.nameArr[indexPath.row];
        locate.font = [UIFont systemFontOfSize:15];
        [cell.contentView addSubview:locate];
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 45.5, DeviceWidth, 0.5)];
        lineView.backgroundColor = UIColorFromRGB(0xf6f6f6, 1);
        [cell.contentView addSubview:lineView];
        //        缓存右侧
        UILabel *detaile = [[UILabel alloc]initWithFrame:CGRectMake(0, 14.5, DeviceWidth -18*DeviceWidth/375, 15)];
        detaile.textAlignment = NSTextAlignmentRight;
        detaile.text = @"包括图片，数据等";
        detaile.textColor = UIColorFromRGB(0x999999, 1);
        detaile.font = [UIFont systemFontOfSize:15];
        [cell.contentView addSubview:detaile];
    }else if (indexPath.row == 2){
        UILabel *cache = [[UILabel alloc]initWithFrame:CGRectMake(23*DeviceWidth/375, 14.5, 180*DeviceWidth/375, 15)];
        cache.text = self.nameArr[indexPath.row];
        cache.font = [UIFont systemFontOfSize:15];
        cache.textColor = UIColorFromRGB(0x3d4245, 1);
        [cell.contentView addSubview:cache];
        _locationSwitch = [cell.contentView viewWithTag:10];
        _locationSwitch.hidden = NO;
        if ([self isLocationOpen]) {
            [_locationSwitch setOn:YES animated:NO];
        }else {
            [_locationSwitch setOn:NO animated:NO];
        }
        
        
    }else if (indexPath.row == 4){
    
        UILabel *cache = [[UILabel alloc]initWithFrame:CGRectMake(23*DeviceWidth/375, 14.5, 180*DeviceWidth/375, 15)];
        cache.text = self.nameArr[indexPath.row];
        cache.font = [UIFont systemFontOfSize:15];
        cache.textColor = UIColorFromRGB(0x3d4245, 1);
        [cell.contentView addSubview:cache];
        
        UILabel *editionLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 14.5, DeviceWidth -30*DeviceWidth/375, 15)];
        editionLabel.textAlignment = NSTextAlignmentRight;
        NSString *strVersion = [DefineSystemTool VersionShort];
        editionLabel.text = [NSString stringWithFormat:@"V%@",strVersion];
        editionLabel.textColor = UIColorFromRGB(0x999999, 1);
        editionLabel.font = [UIFont systemFontOfSize:15];
        [cell.contentView addSubview:editionLabel];
        
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 3) {
        NSString *path = HFCachesPath;
        NSFileManager *fileManager=[NSFileManager defaultManager];
        float folderSize = [AppDelegate delegate].imagePutCache.diskCache.totalCount;
        if ([fileManager fileExistsAtPath:path]) {
            //拿到算有文件的数组
            NSArray *childerFiles = [fileManager subpathsAtPath:path];
            //拿到每个文件的名字,如有有不想清除的文件就在这里判断
            for (NSString *fileName in childerFiles) {
                //将路径拼接到一起
                NSString *fullPath = [path stringByAppendingPathComponent:fileName];
                folderSize += [self fileSizeAtPath:fullPath];
            }
            if (folderSize <= 0) {
                [RMUniversalAlert showAlertInViewController:self withTitle:@"提示" message:@"暂无缓存" cancelButtonTitle:@"知道了" destructiveButtonTitle:nil otherButtonTitles:nil tapBlock:nil];
            }else {
                WEAKSELF
                [RMUniversalAlert showAlertInViewController:self withTitle:@"清理缓存" message:[NSString stringWithFormat:@"缓存大小为%.2fM,确定要清理缓存吗?", folderSize] cancelButtonTitle:@"取消" destructiveButtonTitle:@"确定" otherButtonTitles:nil tapBlock:^(RMUniversalAlert * _Nonnull alert, NSInteger buttonIndex) {
                    STRONGSELF
                    if (strongSelf) {
                        [strongSelf clearCacheMemory];
                    }
                }];
            }
        }
    }
}

#pragma  mark ----设置导航栏不隐藏
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [self.tableView reloadData];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}


- (void)becomeActive {
    [self.tableView reloadData];
}

//判断定位服务是否开启
- (BOOL)isLocationOpen {
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    if (kCLAuthorizationStatusDenied == status || kCLAuthorizationStatusRestricted == status) {
        return NO;
    }else {
        return YES;
    }
}

#pragma mark------ 判断是否开启推送
- (BOOL)isAllowedNotification
{
    //iOS8 check if user allow notification
    if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0")) {// system is iOS8
            UIUserNotificationSettings *setting = [[UIApplication sharedApplication] currentUserNotificationSettings];
            if
                (UIUserNotificationTypeNone != setting.types) {
                    return YES;
                }
        }
    else
    {//iOS7
        UIRemoteNotificationType type = [[UIApplication sharedApplication] enabledRemoteNotificationTypes];
        if(UIRemoteNotificationTypeNone != type)
            return YES;
    }
    return
    NO;
}

//计算单个文件夹的大小
-(float)fileSizeAtPath:(NSString *)path{
    
    NSFileManager *fileManager=[NSFileManager defaultManager];
    
    if([fileManager fileExistsAtPath:path]){
        
        long long size=[fileManager attributesOfItemAtPath:path error:nil].fileSize;
        return size/1024.0/1024.0;
    }
    return 0;
}

- (void)clearCacheMemory {
    
    //点击了确定,遍历整个caches文件,将里面的缓存清空
    NSString *path = HFCachesPath;
    NSFileManager *fileManager=[NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:path]) {
        NSArray *childerFiles=[fileManager subpathsAtPath:path];
        for (NSString *fileName in childerFiles) {
            //如有需要，加入条件，过滤掉不想删除的文件
            NSString *absolutePath=[path stringByAppendingPathComponent:fileName];
            [fileManager removeItemAtPath:absolutePath error:nil];
        }
    }
    [[AppDelegate delegate].imagePutCache.diskCache removeAllObjects];
}

#pragma  mark ---- 定位跳转
- (void)toLocation:(UISwitch *)sender{
    NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reloadTableView) name:UIApplicationWillEnterForegroundNotification object:nil];
        [[UIApplication sharedApplication] openURL:url];
    }
}

- (void)reloadTableView{
    [self.tableView reloadData];
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIApplicationWillEnterForegroundNotification object:nil];
}
#pragma mark -- 分割线
- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}
- (void)hudWasHidden:(MBProgressHUD *)hud {
    
}
@end
