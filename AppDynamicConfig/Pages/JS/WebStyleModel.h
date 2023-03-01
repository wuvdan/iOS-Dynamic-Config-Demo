//
//  WebStyleModel.h
//  AppDynamicConfig
//
//  Created by 吴丹 on 2023/3/1.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WebStyleButtonModel : NSObject
@property (nonatomic, copy) NSString *action;
@property (nonatomic, copy) NSString *icon;
@property (nonatomic, copy) NSString *text;
@end

@interface WebStyleModel : NSObject
@property (nonatomic, copy) NSArray<WebStyleButtonModel *> *rightButtons;
@property (nonatomic, copy) NSString *backgroundColor;
@property (nonatomic, copy) NSString *barTinColor;
@property (nonatomic, assign) BOOL notSupportBounces;
@property (nonatomic, assign) BOOL notSupportGesture;
@property (nonatomic, assign) BOOL scrollNavigationBar;
@property (nonatomic, assign) BOOL showNavigationBar;
@property (nonatomic, assign) BOOL statusBarBlack;

@end

NS_ASSUME_NONNULL_END
