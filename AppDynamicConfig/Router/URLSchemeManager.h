//
//  URLSchemeManager.h
//  AppDynamicConfig
//
//  Created by 吴丹 on 2023/2/27.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

static NSString * const kData_JSON_key  = @"dataJSON";    ///< url中的DataJSON参数


@interface URLSchemeManager : NSObject
+ (BOOL)checkIsInnerPagWithURLString:(NSString *)URLString;

+ (NSString *)getSechemsWithURL:(NSURL *)url;
+ (NSDictionary *)getParameterWithURL:(NSURL *)url;

/// 打开页面
/// @param URLString 路径
/// @param controller 当前控制器
+ (void)openPageWithURLString:(NSString *)URLString controller:(nullable UIViewController *)controller;


/// 打开页面
/// @param URLString 路径
/// @param controller 当前控制器
/// @param completion 执行结束回调
+ (void)openPageWithURLString:(NSString *)URLString
                   controller:(UIViewController *)controller
                   completion:(void(^)(BOOL success))completion;


/// 显示不支持的Sechems
+ (void)showNoSupportAlertWithController:(UIViewController *)controller;
@end

NS_ASSUME_NONNULL_END
