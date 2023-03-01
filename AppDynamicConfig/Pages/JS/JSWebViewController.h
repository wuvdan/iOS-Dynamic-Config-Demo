//
//  JSWebViewController.h
//  AppDynamicConfig
//
//  Created by 吴丹 on 2023/2/28.
//

#import "ZXNavigationBarController.h"
#import <WebKit/WebKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JSWebViewController : ZXNavigationBarController
@property (nonatomic, copy) NSString *remoteURLString;
@property (nonatomic, copy) NSString *localURLString;
@end

NS_ASSUME_NONNULL_END
