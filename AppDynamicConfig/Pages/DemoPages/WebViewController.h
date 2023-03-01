//
//  WebViewController.h
//  AppDynamicConfig
//
//  Created by 吴丹 on 2023/2/27.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WebViewController : UIViewController
@property (nonatomic, copy) NSString *urlString;
@property (nonatomic, copy) NSString *htmlString;
@property (nonatomic, copy) NSString *fileString;
@property (nonatomic, copy) NSDictionary *params;
@end

NS_ASSUME_NONNULL_END
