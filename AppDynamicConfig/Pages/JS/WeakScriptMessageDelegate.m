//
//  WeakScriptMessageDelegate.m
//  AppDynamicConfig
//
//  Created by 吴丹 on 2023/2/28.
//

#import "WeakScriptMessageDelegate.h"

@implementation WeakScriptMessageDelegate

- (instancetype)initWithDelegate:(id<WKScriptMessageHandler>)scriptDelegate {
  self = [super init];
  if (self) {
    _scriptDelegate = scriptDelegate;
  }
  return self;
}

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    [self.scriptDelegate userContentController:userContentController didReceiveScriptMessage:message];
}
@end
