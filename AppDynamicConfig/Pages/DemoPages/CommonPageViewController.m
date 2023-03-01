//
//  CommonPageViewController.m
//  AppDynamicConfig
//
//  Created by 吴丹 on 2023/2/27.
//

#import "CommonPageViewController.h"

@interface CommonPageViewController ()

@end

@implementation CommonPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor darkGrayColor];
    self.title = @"默认标题2";
    
    NSLog(@"%@", self.params);
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
