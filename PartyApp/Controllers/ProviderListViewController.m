//
//  ProviderListViewController.m
//  PartyApp
//
//  Created by Admin on 12/9/17.
//  Copyright © 2017 Vijay King. All rights reserved.
//

#import "ProviderListViewController.h"
#import "MFSideMenu.h"
#import "AppConstants.h"
#import "ProviderTableViewCell.h"
#import "ProviderDetailsViewController.h"
#import "SearchViewController.h"
#import "SearchProvider.h"

@interface ProviderListViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *searchField;
@property (nonatomic, strong) NSMutableArray *providerList;

@property (nonatomic, weak)  UIRefreshControl *refreshControl;
@end

@implementation ProviderListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController.navigationController setNavigationBarHidden:true];
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refresh1:) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:refreshControl];
    self.refreshControl = refreshControl;
    
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 305;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] init];
    
    UIImageView *image = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"search"] add_tintedImageWithColor:[UIColor whiteColor] style:ADDImageTintStyleKeepingAlpha]];
    image.frame = CGRectMake(0, 0, 40, 40);
    image.contentMode = UIViewContentModeCenter;
    _searchField.leftView = image;
    _searchField.leftViewMode = UITextFieldViewModeAlways;
    
//    UIStoryboard *loginStoryBoard = [UIStoryboard storyboardWithName:@"Login" bundle:[NSBundle mainBundle]];
//    UIViewController *viewController = [loginStoryBoard instantiateInitialViewController];
//
//    [self presentViewController:viewController animated:false completion:^{
//
//    }];
    // Do any additional setup after loading the view.
    [self loadProviderListFromServer];
}

- (void)refresh1:(UIRefreshControl *)refreshControl
{
    [self loadProviderListFromServer];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController.navigationController setNavigationBarHidden:true];
}

- (void)didPressedSeachButton;
{
    [self loadProviderListFromServer];
}

-(void)loadProviderListFromServer {
    [MBProgressHUD showHUDAddedTo:self.view animated:NO];
    [WSMANAGER post:@"searchprovider"
        parameters:[[SearchProvider sharedInstance] searchDict]
    withComplition:^(BOOL success, NSURLSessionDataTask *task, id response, NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
        [self.refreshControl endRefreshing];
        if (success) {
            [self addProviderListInMainList:response[@"data"]];
        }
        else {
            [self showAlertWithError:error];
        }
    }];
}

-(void)addProviderListInMainList:(NSArray *)list {
//    if (!_providerList) {
        _providerList = [NSMutableArray array];
//    }
    [_providerList addObjectsFromArray:list];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Textfield methods

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField;
{
    if (textField == _searchField) {
        SearchViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"SearchViewController"];
        vc.providerList = _providerList;
        vc.delegate = self;
        [self presentViewController:vc animated:true completion:^{
            
        }];
        return NO;
    }
    return YES;
}
- (void)searchDidDismisWithData:(NSMutableArray*)data;
{

    //do whatever you want with the data
    _providerList = (NSMutableArray *)[data copy];
    [self.tableView reloadData];
    
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    return UITableViewAutomaticDimension;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _providerList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ProviderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];

    NSDictionary *provider = _providerList[indexPath.row];
    cell.providerName.text = provider[@"provider_name"];
    cell.providerDesc.text = provider[@"provider_desc"];
    
    NSArray *images = provider[@"images"];
    NSDictionary *imageData = nil;
    if ([images isKindOfClass:[NSArray class]]) {
    if (images.count > 0) {
       imageData = [images firstObject];
    }
    }
    [cell.providerImageView sd_setShowActivityIndicatorView:true];
    if (imageData) {
        [cell.providerImageView sd_setImageWithURL:[NSURL URLWithString:imageData[@"thumb_url"]] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    }
    else {
        [cell.providerImageView sd_setImageWithURL:nil placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    }
    
    [cell setNeedsLayout];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
//    UIStoryboard *loginStoryBoard = [UIStoryboard storyboardWithName:@"Login" bundle:[NSBundle mainBundle]];
//    UIViewController *viewController = [loginStoryBoard instantiateInitialViewController];
//
//    [self presentViewController:viewController animated:true completion:^{
//
//    }];
    ProviderDetailsViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ProviderDetailsViewController"];
    
    NSDictionary *provider = _providerList[indexPath.row];
    vc.productId = provider[@"provider_id"];
    [self.navigationController pushViewController:vc animated:true];
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
