//
//  CommonFuntionViewController.m
//  AppDynamicConfig
//
//  Created by 吴丹 on 2023/2/27.
//

#import "CommonFuntionViewController.h"
#import "NSDictionary+Router.h"
@interface CommonFuntionViewController ()

@end

@implementation CommonFuntionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor orangeColor];
    self.title = @"默认标题1";
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.title = [NSString stringWithFormat:@"默认标题1---->%@", self.params[@"a"]];
    });
    
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
