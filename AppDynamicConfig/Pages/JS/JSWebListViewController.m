//
//  JSWebListViewController.m
//  AppDynamicConfig
//
//  Created by 吴丹 on 2023/2/28.
//

#import "JSWebListViewController.h"
#import "JSWebViewController.h"

@interface JSWebListViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation JSWebListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"JS 交互";
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class]) forIndexPath:indexPath];
    cell.textLabel.text = @"普通配置";
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    JSWebViewController *vc = [[JSWebViewController alloc] init];
//    vc.remoteURLString = @"https://www.baidu.com";
    vc.localURLString = [[NSBundle mainBundle] pathForResource:@"index" ofType:@"html"];
    [self.navigationController showViewController:vc sender:nil];
}

@end
