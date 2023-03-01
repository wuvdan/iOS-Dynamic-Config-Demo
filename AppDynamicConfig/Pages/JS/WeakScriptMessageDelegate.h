//
//  WeakScriptMessageDelegate.h
//  AppDynamicConfig
//
//  Created by 吴丹 on 2023/2/28.
//

#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface WeakScriptMessageDelegate : NSObject<WKScriptMessageHandler>
@property (nonatomic, weak) id<WKScriptMessageHandler> scriptDelegate;

- (instancetype)initWithDelegate:(id<WKScriptMessageHandler>)scriptDelegate;
@end

NS_ASSUME_NONNULL_END
