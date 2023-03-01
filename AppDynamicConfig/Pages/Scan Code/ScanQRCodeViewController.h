//
//  ScanQRCodeViewController.h
//  AppDynamicConfig
//
//  Created by 吴丹 on 2023/2/28.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^DidFetchScanQRCodeResult)(NSString *result);
@interface ScanQRCodeViewController : UIViewController
@property (nonatomic, copy) DidFetchScanQRCodeResult fetchScanQRCodeResult;
@end

NS_ASSUME_NONNULL_END
