//
//  WDAlterManager.h
//  AppDynamicConfig
//
//  Created by 吴丹 on 2023/2/27.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^buttonDidSelectedHandle)(NSInteger);

@interface WDAlterManager : NSObject
+ (void)showAlterWithTitle:(NSString *)title message:(NSString *)message buttons:(NSArray *)buttons didSelectedHandle:(buttonDidSelectedHandle)handel inController:(UIViewController *)controller;
@end

NS_ASSUME_NONNULL_END
