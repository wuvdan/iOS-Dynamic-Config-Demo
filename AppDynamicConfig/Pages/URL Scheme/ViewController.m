//
//  ViewController.m
//  AppDynamicConfig
//
//  Created by 吴丹 on 2023/2/27.
//

#import "ViewController.h"
#import "ConfigModel.h"
#import "URLSchemeManager.h"
#import "MJExtension.h"
#import "ScanQRCodeViewController.h"

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) ConfigDataModel *dataModel;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"动态App配置";
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];
    
    UIBarButtonItem *scanButton = [[UIBarButtonItem alloc] initWithTitle:@"扫一扫" style:(UIBarButtonItemStylePlain) target:self action:@selector(didTappedScanButton:)];
    self.navigationItem.rightBarButtonItem = scanButton;
    
    NSError *error;
    NSString *textFileContents = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"functions" ofType:@"json"] encoding:NSUTF8StringEncoding error:&error];
    self.dataModel = [ConfigDataModel mj_objectWithKeyValues:[textFileContents mj_JSONObject]];
}

- (void)didTappedScanButton:(id)sender {
    ScanQRCodeViewController *vc = [[ScanQRCodeViewController alloc] init];
    __weak __typeof__(vc) vc_Weak = vc;
    [vc setFetchScanQRCodeResult:^(NSString * _Nonnull result) {
        [vc_Weak.navigationController popViewControllerAnimated:NO];
        [URLSchemeManager openPageWithURLString:result controller:self];
    }];
    [self.navigationController pushViewController:vc animated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return section == 0 ? self.dataModel.pages.count : self.dataModel.functions.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return section == 0 ? @"页面示例" : @"功能示例";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class]) forIndexPath:indexPath];
    if (indexPath.section == 0) {
        cell.textLabel.text = self.dataModel.pages[indexPath.row].name;
    } else {
        cell.textLabel.text = self.dataModel.functions[indexPath.row].name;
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        [URLSchemeManager openPageWithURLString:self.dataModel.pages[indexPath.row].path controller:self];
    } else {
        [URLSchemeManager openPageWithURLString:self.dataModel.functions[indexPath.row].path controller:self];
    }    
}

@end
