
#import <UIKit/UIKit.h>
#import "HCBaseViewController.h"
//#import "GestureDelegate.h"
//#import "FrozenModel.h"
//#import "EnumCollection.h"
typedef enum{
    GestureViewControllerTypeSetting = 1,  //设置
    GestureViewControllerTypeLogin,  //后台验证
    GestureViewControllerTypeAutomatic   //自动验证
}GestureViewControllerType;

typedef enum{
    buttonTagReset = 1,
    buttonTagManager,
    buttonTagForget
    
}buttonTag;
//设置完手势去向
typedef enum{
    whereRoot,  //返回底部视图
    whereother   //从哪来回哪去
}WhereToGoType;

@interface GestureViewController : UIViewController

/**
 *  控制器来源类型
 */
@property (nonatomic, assign) GestureViewControllerType type;

@property (nonatomic, assign) WhereToGoType whereType;

@property (nonatomic,copy)NSString *pwdStr;

@property (nonatomic,assign) BOOL isFromAdert;//是否来自广告页面流程

@end
