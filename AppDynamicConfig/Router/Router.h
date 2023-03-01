//
//  Router.h
//  AppDynamicConfig
//
//  Created by 吴丹 on 2023/2/27.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

static NSString * const NavigationVC  = @"navigationVC";    ///< 当前控制器的导航栏控制器
static NSString * const CurrnetVC  = @"currentVC";          ///< 当前控制器
static NSString * const DataJsonDic  = @"dic";              ///< urlScheme后缀附带的json数据
static NSString * const kShowType  = @"showType";           ///< 打开方式

/// 演示注册路径

static NSString *kRouter_Base_Path = @"appscheme://"; // 根路径不存在情况下提示

static NSString *kRouter_Demo1_Path = @"appscheme://demo/page1"; // 普通页面1
static NSString *kRouter_Demo2_Path = @"appscheme://demo/page2"; // 普通页面2
static NSString *kRouter_Web_Path = @"appscheme://demo/web"; // 网页
static NSString *kRouter_Share_Path = @"appscheme://demo/share"; // 分享
static NSString *kRouter_Alert_Path = @"appscheme://demo/alert"; // alert
static NSString *kRouter_Sheet_Path = @"appscheme://demo/sheet"; // sheet
static NSString *kRouter_OPEN_URL_Path = @"appscheme://demo/openURL"; // open url
static NSString *kRouter_MAP_NAVI_Path = @"appscheme://demo/mapNavi"; // 打开第三方地图
static NSString *kRouter_ScanCode_Path = @"appscheme://demo/scanCode"; // 扫一扫
static NSString *kRouter_TokenInvalid_Path = @"appscheme://demo/tokenInvalid"; // token失效

static NSString *kRouter_Action_Close_Path = @"appscheme://demo/action/close"; // token失效

@interface Router : NSObject

@end

NS_ASSUME_NONNULL_END
