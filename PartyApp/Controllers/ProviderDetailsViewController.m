//
//  ProviderDetailsViewController.m
//  PartyApp
//
//  Created by Admin on 12/21/17.
//  Copyright © 2017 Vijay King. All rights reserved.
//

#import "ProviderDetailsViewController.h"
#import "ResponsiveLabel.h"
#import "AppConstants.h"
#import "NSAttributedString+Processing.h"
#import "AboutProviderCell.h"
#import "ProviderOfferTableViewCell.h"
#import "PhotosTableViewCell.h"
#import "UserPhotosViewController.h"

@interface ProviderDetailsViewController () <SwipeViewDataSource, SwipeViewDelegate, AboutProviderCellDelegate, UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate, PhotoTableViewCellDelegate>

@property (weak, nonatomic) IBOutlet UIView *productImageView;
@property (weak, nonatomic) IBOutlet SwipeView *swipeImageView;
@property (weak, nonatomic) IBOutlet UIPageControl *imagePageControl;
@property (nonatomic, strong) NSArray *images;
@property (nonatomic, strong) NSDictionary *productDetails;
@property (weak, nonatomic) IBOutlet ResponsiveLabel *lblAbout;
@property (atomic) BOOL isAboutExpanded;
@property (weak, nonatomic) IBOutlet UILabel *ageLabel;
@property (weak, nonatomic) IBOutlet UILabel *providerName;
@property (weak, nonatomic) IBOutlet UILabel *providerDescLabel;
@property (weak, nonatomic) IBOutlet UIButton *btnDone;
@property (weak, nonatomic) IBOutlet UITextField *userDetailsTextField;
@property (atomic) BOOL isheaderExpanded;
@property (weak, nonatomic) IBOutlet UIView *pickerView;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UIPickerView *kidsPicker;
@property (weak, nonatomic) IBOutlet UISegmentedControl *pickerSegment;
@property (nonatomic, strong) NSDate *selectedDate;
@property (atomic) NSInteger kidsCount;
@property (atomic) NSInteger maxKids;
@property (atomic) NSInteger minKids;
@property (nonatomic, strong) NSArray *timeArray;
@property (nonatomic, strong) NSArray *dateArray;

- (IBAction)pageControlValueChanged:(UIPageControl *)pageControl;
- (IBAction)pickerSegmentValueChanged:(id)sender;
- (IBAction)datePickerValueChanged:(id)sender;
- (IBAction)btnDonePressed:(id)sender;
- (IBAction)textFieldClicked:(id)sender;

@end

@implementation ProviderDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.ageLabel.text = @"";
    _timeArray = @[@"12:00 AM",@"1:00 AM",@"2:00 AM",@"3:00 AM",@"4:00 AM",@"5:00 AM",
                   @"6:00 AM",@"7:00 AM",@"8:00 AM",@"9:00 AM",@"10:00 AM",@"11:00 AM",
                   @"12:00 PM",@"1:00 PM",@"2:00 PM",@"3:00 PM",@"4:00 PM",@"5:00 PM",
                   @"6:00 PM",@"7:00 PM",@"8:00 PM",@"9:00 PM",@"10:00 PM",@"11:00 PM"];
    
    NSMutableArray *date_array = [NSMutableArray array];
    NSDateFormatter  *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"MMMM d', 'yyyy"];
    
    NSDateComponents *componants = [[NSCalendar currentCalendar] components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:[NSDate date]];
    
    [date_array addObject:[dateFormat stringFromDate:[NSDate date]]];
    
    for (int i =0; i < 90; i++ ) {
        componants.day += 1;
        NSDate *date = [[NSCalendar currentCalendar] dateFromComponents:componants];
        [date_array addObject:[dateFormat stringFromDate:date]];
    }
    
    _dateArray = date_array;
    
    self.providerName.text = @"";
    self.providerDescLabel.text = @"";
//    [self loadHeaderData];
    _kidsCount = 12;
    self.imagePageControl.numberOfPages = 0;
    // Do any additional setup after loading the view.
    _isAboutExpanded = NO;
    UIView *headerView = [self.tableView tableHeaderView];
    headerView.hidden = true;
    _pickerView.hidden = true;
    _btnDone.hidden = true;
    _datePicker.minimumDate = [NSDate date];
    [self loadProviderDetailFromServer];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] init];
}

-(void)loadProviderDetailFromServer {
    [MBProgressHUD showHUDAddedTo:self.view animated:NO];
    [WSMANAGER post:@"provider"
         parameters:@{@"id":self.productId}
     withComplition:^(BOOL success, NSURLSessionDataTask *task, id response, NSError *error) {
         [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
         if (success) {
             [self loadProductDetailsWithData:response[@"data"]];
         }
         else {
             [self showAlertWithError:error];
         }
     }];
}

-(void)loadProductDetailsWithData:(NSDictionary *)productdict {
    self.productDetails = productdict;
    self.images = [productdict[@"images"] valueForKey:@"url"];
    [self loadHeaderData];
    self.providerName.text = productdict[@"provider_name"];
    self.providerDescLabel.text = productdict[@"provider_desc"];
    
    NSString *ageLimitStr = [NSString stringWithFormat:@"Ages %@ - %@",productdict[@"age_min"],productdict[@"age_max"]];
    self.ageLabel.text = ageLimitStr;
    [self.tableView reloadData];
}

-(void)loadHeaderData {
    self.imagePageControl.numberOfPages = self.images.count;
    self.swipeImageView.wrapEnabled = (self.images.count > 1);
    self.swipeImageView.currentItemIndex = 0;
    [self.swipeImageView reloadData];
    UIView *headerView = [self.tableView tableHeaderView];
    headerView.hidden = false;
    [self reloadTextField];
    CGRect headerFrame = headerView.frame;
    headerFrame.size.height = ([UIScreen mainScreen].bounds.size.width*2.0/3.0)+76+50;
    [headerView setFrame:headerFrame];
    [self.tableView setTableHeaderView:headerView];
    [self.view setNeedsLayout];
    [self.view layoutIfNeeded];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - SwipeViewDataSource

- (NSInteger)numberOfItemsInSwipeView:(SwipeView *)swipeView {
    return self.images.count;
}

- (UIView *)swipeView:(SwipeView *)swipeView viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view {
    PVImageView *imageView = [view isKindOfClass:[PVImageView class]] ? (PVImageView *)view : [[PVImageView alloc] initWithFrame:swipeView.bounds];
    
    if (index < self.images.count) {
        [imageView sd_setImageWithURL:[self.images objectAtIndex:index] placeholderImage:imageView.placeholderImage];
        return imageView;
    }
    
    return [[UIView alloc] init];
}

#pragma mark - SwipeViewDelegate

- (void)swipeViewCurrentItemIndexDidChange:(SwipeView *)swipeView {
    self.imagePageControl.currentPage = swipeView.currentItemIndex;
}

- (void)swipeView:(SwipeView *)swipeView didSelectItemAtIndex:(NSInteger)index {
    IDMPhotoBrowser *browser = [[IDMPhotoBrowser alloc] initWithPhotoURLs:self.images animatedFromView:self.swipeImageView];
    PVImageView *imageView = (PVImageView *)[self.swipeImageView itemViewAtIndex:index];
    
    // image browser controller
    browser.scaleImage = imageView.image;
    browser.displayCounterLabel = YES;
    browser.forceHideStatusBar = YES;
    browser.displayActionButton = false;
    browser.useWhiteBackgroundColor = YES;
    [browser setInitialPageIndex:index];
//    browser.view.tintColor = [UIColor blackColor];
    
    [self presentViewController:browser animated:true completion:^{
        
    }];
}


#pragma mark - Page Control

- (IBAction)pageControlValueChanged:(UIPageControl *)pageControl {
    [self.swipeImageView scrollToItemAtIndex:pageControl.currentPage duration:0.3];
}

#pragma mark - PickerView and Methods

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField;
{
    if (textField == self.userDetailsTextField) {
        [self textFieldClicked:textField];
        return false;
    }
    return true;
}
// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView; {
    return 3;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component; {
    if (!self.productDetails) {
        return 0;
    }
    switch (component) {
        case 0:
            return 100;
            break;
        case 1:
            return _dateArray.count;
            break;
        case 2:
            return _timeArray.count;
            
        default:
            return 0;
            break;
    }
    return 100;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(nullable UIView *)view;
{
    UILabel *label = nil;
    if ([view isKindOfClass:[UILabel class]]) {
        label = view;
    }
    if (!label) {
        label = [[UILabel alloc] init];
        label.textColor = RGBCOLOR(51, 51, 51);
        label.font = [UIFont systemFontOfSize:15];
        label.textAlignment = NSTextAlignmentCenter;
    }
    
    NSString *rstring = @"";
    switch (component) {
        case 0:
            rstring=  [NSString stringWithFormat:@"%ld Kids", row+1];
            break;
        case 1:
            rstring =  [[_dateArray[row] componentsSeparatedByString:@","] firstObject];
            break;
        case 2:
            rstring = _timeArray[row];
            break;
        default:
            rstring = @"";
            break;
    }
    label.text = rstring;
    return label;
}

- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow2:(NSInteger)row forComponent:(NSInteger)component
{
    switch (component) {
        case 0:
            return [NSString stringWithFormat:@"%ld Kids", row+1];
            break;
        case 1:
            return [[_dateArray[row] componentsSeparatedByString:@","] firstObject];
            break;
        case 2:
            return _timeArray[row];
            
        default:
            return @"";
            break;
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    switch (component) {
        case 0:
            _kidsCount = row+1;
            break;
        default:
            break;
    }
    [self reloadTextField];
}

-(void)reloadTextField {
    NSString *str = [NSString stringWithFormat:@"Party for %ld kids",_kidsCount];
//    if (_selectedDate) {
//        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
//        [dateFormat setDateFormat:@"MMMM dd, yyyy 'at' HH:mma"];
//        str = [str stringByAppendingFormat:@", %@",[dateFormat stringFromDate:_selectedDate]];
//    }
    
    NSString *dateStr = _dateArray[[self.kidsPicker selectedRowInComponent:1]];
    NSString *timeStr = _timeArray[[self.kidsPicker selectedRowInComponent:2]];

    str = [str stringByAppendingFormat:@", %@ at %@",dateStr,timeStr];
    
    _userDetailsTextField.text = str;
}

- (IBAction)pickerSegmentValueChanged:(UISegmentedControl *)sender {
    if (sender.selectedSegmentIndex == 0) {
        self.datePicker.hidden = true;
        self.kidsPicker.hidden = false;
    }
    else {
        self.datePicker.hidden = false;
        self.kidsPicker.hidden = true;
    }
}

- (IBAction)datePickerValueChanged:(id)sender {
    
    _selectedDate = _datePicker.date;
    [self reloadTextField];
}

- (IBAction)btnDonePressed:(id)sender {
    [self.btnDone setHidden:true];
    [self.pickerView setHidden:true];
    
    [self reloadHeader];
    [UIView animateWithDuration:0.25 animations:^{
        [self.view setNeedsLayout];
    }];
}

- (IBAction)textFieldClicked:(id)sender {
    if (!self.pickerView.hidden) {
        return;
    }
    [self.pickerView setHidden:false];
    self.btnDone.hidden = false;
    [self reloadHeader];
    [self.kidsPicker reloadAllComponents];
    [UIView animateWithDuration:0.25 animations:^{
        [self.view setNeedsLayout];
    }];
}

-(void)reloadHeader
{
    UIView *headerView = [self.tableView tableHeaderView];
    headerView.hidden = false;
    CGRect headerFrame = headerView.frame;
    headerFrame.size.height = ([UIScreen mainScreen].bounds.size.width*2.0/3.0)+76+50;
    if (!_pickerView.hidden) {
        headerFrame.size.height += 206;
    }
    [headerView setFrame:headerFrame];
    [self.tableView setTableHeaderView:headerView];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (!self.productDetails) return 0;
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section; {
    return 0.1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section;
{
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    return UITableViewAutomaticDimension;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) return 1;
    if (section == 1) {
        NSArray *offersArray = self.productDetails[@"offers"];
        return offersArray.count;
    }
    if (section == 2) return 1;
    if (section == 3) return 1;
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
    AboutProviderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"aboutcell" forIndexPath:indexPath];
    
    NSString *textstr = @"text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text ";
//    textstr = @"text text text text text text text text text text text text text text text text ";
        textstr = self.productDetails[@"provider_desc"];
    [cell configureText:textstr forExpandedState:self.isAboutExpanded];
    
    cell.delegate = self;
    [cell setNeedsLayout];
    return cell;
    }
    else if (indexPath.section == 1) {
        NSArray *offersArray = self.productDetails[@"offers"];
        ProviderOfferTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"offercell" forIndexPath:indexPath];
       
        NSDictionary *offer = offersArray[indexPath.row];
        cell.offerTitleText.text = offer[@"offer_name"];
        NSArray *offerFeatures = offer[@"offer_features"];
        if (offerFeatures.count>0) {
            NSString *featuresStr =@"• ";
            featuresStr = [featuresStr stringByAppendingString:[offer[@"offer_features"] componentsJoinedByString:@"\n• "]];
            cell.offerDetailsText.text = featuresStr;
        }
        else {
            cell.offerDetailsText.text = @"";
        }
        [cell setNeedsLayout];
        return cell;
    }
    else if (indexPath.section == 2) {
        ProviderOfferTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"notescell" forIndexPath:indexPath];
        cell.offerDetailsText.text = self.productDetails[@"general_notes"];
        [cell setNeedsLayout];
        return cell;
    }
    else {
        PhotosTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"imagecell" forIndexPath:indexPath];
        [cell setNeedsLayout];
        cell.delegate = self;
        return cell;
    }
}

-(void)cell:(AboutProviderCell *)cell isExpanded:(BOOL)expanded;
{
    self.isAboutExpanded = expanded;
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
-(void)didPressedSeeAllPhotosForCell:(PhotosTableViewCell *)cell;
{
    UserPhotosViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"UserPhotosViewController"];
    [self.navigationController pushViewController:vc animated:true];
}

-(void)cell:(PhotosTableViewCell *)cell didPressedPhoto:(UIButton *)btn {
    
}

@end
