//
//  WDAlterManager.m
//  AppDynamicConfig
//
//  Created by 吴丹 on 2023/2/27.
//

#import "WDAlterManager.h"

@implementation WDAlterManager
+ (void)showAlterWithTitle:(NSString *)title
                   message:(NSString *)message
                   buttons:(NSArray *)buttons
         didSelectedHandle:(buttonDidSelectedHandle)handel
              inController:(UIViewController *)controller {
    
    UIAlertController *alter = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    [buttons enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIAlertAction *action = [UIAlertAction actionWithTitle:obj style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            handel(idx);
        }];
        [alter addAction:action];
    }];
    
    [controller presentViewController:alter animated:YES completion:nil];
}
@end
