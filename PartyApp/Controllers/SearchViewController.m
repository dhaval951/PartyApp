//
//  SearchViewController.m
//  PartyApp
//
//  Created by Admin on 12/28/17.
//  Copyright © 2017 Vijay King. All rights reserved.
//

#import "SearchViewController.h"
#import "AppConstants.h"
#import "SPGooglePlacesAutocompleteQuery.h"
#import "SPGooglePlacesAutocompletePlace.h"
#import "SearchProvider.h"

@interface SearchViewController () <UITextFieldDelegate , UITableViewDelegate, UITableViewDataSource>
{
    NSArray *searchResultPlaces;
    SPGooglePlacesAutocompleteQuery *searchQuery;
    
}
@property (weak, nonatomic) IBOutlet UITextField *searchField;
@property (weak, nonatomic) IBOutlet UITextField *locationField;
@property (weak, nonatomic) IBOutlet UITextField *dateField;
@property (weak, nonatomic) IBOutlet UITextField *kidsField;
@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;
@property (nonatomic, weak) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *LocationList;
@property (nonatomic, strong) NSMutableArray *SearchDataList;


@property (weak, nonatomic) IBOutlet UIView *pickerView;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UIPickerView *kidsPicker;
@property (weak, nonatomic) IBOutlet UISegmentedControl *pickerSegment;
@property (nonatomic, strong) NSDate *selectedDate;
@property (atomic) NSInteger kidsCount;
@property (nonatomic, strong) NSDictionary *productDetails;
@property (nonatomic, strong) NSString  *StrSelect;
@property (nonatomic, strong) NSString  *StrLat;
@property (nonatomic, strong) NSString  *StrLong;

- (IBAction)btnClosePressed:(id)sender;

- (IBAction)pickerSegmentValueChanged:(id)sender;
- (IBAction)datePickerValueChanged:(id)sender;
- (IBAction)btnDonePressed:(id)sender;
- (IBAction)textFieldClicked:(id)sender;

@end

@implementation SearchViewController
@synthesize providerList;

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:self.locationField];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:self.searchField];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _StrSelect = @"";
    [self leftImage:@"search" forTextField:self.searchField];
    [self leftImage:@"location" forTextField:self.locationField];
    [self leftImage:@"calendar" forTextField:self.dateField];
    [self leftImage:@"child" forTextField:self.kidsField];
    NSString *str = [[[SearchProvider sharedInstance] searchDict] valueForKey:@"providertype"];
    _searchField.text = (str)?str:@"";
    str = [[[SearchProvider sharedInstance] searchDict] valueForKey:@"state"];
    _locationField.text = (str)?str:@"";
    
    str = [[[SearchProvider sharedInstance] searchDict] valueForKey:@"kides"];
    _kidsField.text = (str)?str:@"";
    
    searchQuery = [[SPGooglePlacesAutocompleteQuery alloc] init];
    searchQuery.radius = 100;
    
    self.searchField.delegate = self;
    self.locationField.delegate = self;
    self.dateField.delegate = self;
    self.kidsField.delegate = self;
    _kidsCount = 0;
//    [self.locationField in]
    //self.locationField.inputView = searchQuery;
//    [self.keybordView removeFromSuperview];
//    self.inputAccessoryView = self.keybordView;
    [_datePicker removeFromSuperview];
    self.dateField.inputView = _datePicker;
    _datePicker.minimumDate = [NSDate date];

    [_kidsPicker removeFromSuperview];
    self.kidsField.inputView = _kidsPicker;
//    self.searchField.inputView = _kidsPicker;
//    self.locationField.inputView = _kidsPicker;
    
    _pickerView.hidden = true;
    
    NSArray<UIColor *> *colours = @[RGBCOLOR(0, 174, 239),GRADIENTCOLOR2];
    
    UIImage *background = [UIImage add_imageWithGradient:colours size:[UIScreen mainScreen].bounds.size direction:ADDImageGradientDirectionLeftSlanted];
    
    _bgImageView.image = background;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(locationFieldValueDidChange:) name:UITextFieldTextDidChangeNotification object:self.locationField];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(searchFieldValueDidChange:) name:UITextFieldTextDidChangeNotification object:self.searchField];

    // Do any additional setup after loading the view.
    [self loadSearchLocationListFromServer];
    
}

-(void)loadSearchLocationListFromServer {
    [MBProgressHUD showHUDAddedTo:self.view animated:NO];
    [WSMANAGER get:@"metadatalist"
        parameters:nil
    withComplition:^(BOOL success, NSURLSessionDataTask *task, id response, NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
        if (success) {
            [self addLocationListInMainList:[[response[@"data"] objectAtIndex:0] valueForKey:@"States"]];
            [self addProvidertypesListInMainList:[[response[@"data"] objectAtIndex:0] valueForKey:@"Providertypes"]];
             [_kidsPicker reloadAllComponents];

        }
        else {
            [self showAlertWithError:error];
        }
    }];
}
-(void)addProvidertypesListInMainList:(NSArray *)list {
  
    self.providerList = [NSMutableArray array];
   
    [self.providerList addObjectsFromArray:list];
     // [self.tableView reloadData];
     }
-(void)addLocationListInMainList:(NSArray *)list {
  
    _LocationList = [NSMutableArray array];
   
    [_LocationList addObjectsFromArray:list];
   // [self.tableView reloadData];
}
-(void)leftImage:(NSString *)imageName forTextField:(UITextField *)textField {
    UIImageView *image = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:imageName] add_tintedImageWithColor:[UIColor whiteColor] style:ADDImageTintStyleKeepingAlpha]];
    image.frame = CGRectMake(0, 0, 40, 40);
    image.contentMode = UIViewContentModeCenter;
    textField.leftView = image;
    textField.leftViewMode = UITextFieldViewModeAlways;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnClosePressed:(id)sender {
    [self dismissViewControllerAnimated:true
                             completion:^{
                                 
                             }];
}

-(void)locationFieldValueDidChange:(NSNotification *)notification {
    NSMutableArray *searchArray = [NSMutableArray array];
    NSString *searchStr = self.locationField.text;
    searchStr = [[searchStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] lowercaseString];
    if ([searchStr isEqualToString:@""]) {
        searchArray = _LocationList;
    }
    else {
        for (NSString *str in _LocationList) {
            if ([str.lowercaseString containsString:searchStr]) {
                [searchArray addObject:str];
            }
        }
    }
    searchResultPlaces = searchArray;
    [self.tableView reloadData];
}

-(void)searchFieldValueDidChange:(NSNotification *)notification {
    ;
    NSMutableArray *searchArray = [NSMutableArray array];
    NSString *searchStr = self.searchField.text;
    searchStr = [[searchStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] lowercaseString];
    if ([searchStr isEqualToString:@""]) {
        searchArray = providerList;
    }
    else {
    for (NSString *str in providerList) {
        if ([str.lowercaseString containsString:searchStr]) {
            [searchArray addObject:str];
        }
    }
    }
    searchResultPlaces = searchArray;
    [self.tableView reloadData];
}

- (void)handleSearchForSearchString:(NSString *)searchString {
    
    searchQuery.input = searchString;
    [searchQuery fetchPlaces:^(NSArray *places, NSError *error) {
        if (error) {
            
        } else {
            searchResultPlaces = places;
            [self.tableView reloadData];
        }
    }];
}
#pragma mark - PickerView and Methods

-(BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    if (textField == self.locationField) {
        [self FindLatandLongFromAddress:textField.text];
    }
    return true;

}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField;
{
    if (textField == self.searchField) {
        [self.searchField resignFirstResponder];
        _StrSelect = @"search";
//        [_kidsPicker selectRow:0 inComponent:0 animated:false];
//        [_kidsPicker reloadAllComponents];
        [self searchFieldValueDidChange:nil];
        
    }
    else if (textField == self.locationField) {
        [self.locationField resignFirstResponder];
        _StrSelect = @"location";
//        [_kidsPicker selectRow:0 inComponent:0 animated:false];
//        [_kidsPicker reloadAllComponents];
        [self locationFieldValueDidChange:nil];
    }
    else if (textField == self.kidsField) {
        [self.kidsField resignFirstResponder];
        _StrSelect = @"kids";
        [_kidsPicker selectRow:0 inComponent:0 animated:false];
        [_kidsPicker reloadAllComponents];
    }
    else if (textField ==self.dateField) {
        [self.dateField resignFirstResponder];
        _StrSelect = @"date";
        [_datePicker reloadInputViews];
    }
    else{
        [self.pickerView setHidden:true];
    }
    return true;
}


// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView; {
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component; {
    if ( [_StrSelect isEqualToString:@"search"]) {
        return [self.providerList count];
    }
    else if ( [_StrSelect isEqualToString:@"location"]) {
        return [self.LocationList count];
    }
    else if ( [_StrSelect isEqualToString:@"kids"]) {
        return 100;
    }
  
    return 100;
}

- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if ( [_StrSelect isEqualToString:@"search"]) {
        return [self.providerList objectAtIndex:row];
    }
    else if ( [_StrSelect isEqualToString:@"location"]) {
        return [self.LocationList objectAtIndex:row] ;
    }
    else if ( [_StrSelect isEqualToString:@"kids"]) {
        return [NSString stringWithFormat:@"%ld Kids", row+1];
    }
    return [NSString stringWithFormat:@"%ld Kids", row+1];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
    if ( [_StrSelect isEqualToString:@"search"]) {
        _searchField.text = [self.providerList objectAtIndex:row] ;
    }
    else if ( [_StrSelect isEqualToString:@"location"]) {
        _locationField.text = [self.LocationList objectAtIndex:row] ;
    }
    else if ( [_StrSelect isEqualToString:@"kids"]) {
        _kidsCount = row+1;
        [self reloadTextField];
    }
 
}

-(void)reloadTextField {
    
        NSString *str = [NSString stringWithFormat:@"%ld kids",_kidsCount];
        _kidsField.text = str;
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
    NSString *str = @"";
    if (_selectedDate) {
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"MMMM dd, yyyy 'at' HH:mma"];
        str = [str stringByAppendingFormat:@"%@",[dateFormat stringFromDate:_selectedDate]];
    }
    _dateField.text = str;
//    [self reloadTextField];
}

- (IBAction)btnDonePressed:(id)sender {
    [_pickerView setHidden:true];
    
    [UIView animateWithDuration:0.25 animations:^{
        [self.view setNeedsLayout];
    }];
}
- (IBAction)btnClearAllPressed:(id)sender {
    self.searchField.text = @"";
    self.locationField.text = @"";
    self.dateField.text = @"";
    self.kidsField.text = @"";
    [self.view endEditing:YES];
    //[self loadSearchDataFromServer];
}

- (IBAction)textFieldClicked:(id)sender {
//    if (!self.pickerView.hidden) {
//        return;
//    }
    [self.pickerView setHidden:false];
    [self.datePicker setHidden:true];
    [self.kidsPicker reloadAllComponents];
    [UIView animateWithDuration:0.25 animations:^{
        [self.view setNeedsLayout];
    }];
}

-(void)FindLatandLongFromAddress: (NSString *)address
{
    NSString *city = address;
    CLGeocoder *geocoder = [CLGeocoder new];
    [geocoder geocodeAddressString:city completionHandler:^(NSArray *placemarks, NSError *error) {
        if (error) {
            NSLog(@"Error: %@", [error localizedDescription]);
            return; // Bail!
        }
        
        if ([placemarks count] > 0) {
            CLPlacemark *placemark = [placemarks lastObject]; // firstObject is iOS7 only.
            NSLog(@"Location is: %@", placemark.location);
            
            NSLog(@"latitude is: %f", placemark.location.coordinate.latitude);
            NSLog(@"longitude is: %f", placemark.location.coordinate.longitude);

            _StrLat = [NSString stringWithFormat:@"%f",placemark.location.coordinate.latitude];
            _StrLong = [NSString stringWithFormat:@"%f",placemark.location.coordinate.longitude];


           // placemark.location.coordinate.latitude; will returns latitude
            //    placemark.location.coordinate.longitude; will returns longitude
        }
    }];
    
}
-(void)loadSearchDataFromServer {
    [MBProgressHUD showHUDAddedTo:self.view animated:NO];
    NSMutableDictionary *SearchDict = [NSMutableDictionary dictionary];
    NSString *strKids=[NSString stringWithFormat:@"%ld",_kidsCount];
    NSString *searchStr = [_searchField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (![searchStr isEqualToString:@""]) {
        SearchDict[@"providertype"] = searchStr;
    }
   
    NSString *locationStr = [_locationField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (![locationStr isEqualToString:@""]) {
        SearchDict[@"state"] = locationStr;
        SearchDict[@"latitude"] = _StrLat;
        SearchDict[@"longitude"] = _StrLong;
    }
    if (_kidsCount>0) {
        SearchDict[@"kides"] = strKids;
    }
    NSLog(@"dict is:%@",SearchDict);
    
    [SearchProvider sharedInstance].searchDict = SearchDict;
    
    [self dismissViewControllerAnimated:true completion:^{
    }];
    [self.delegate didPressedSeachButton];
    
//    [WSMANAGER post:@"searchprovider"
//         parameters:SearchDict
//     withComplition:^(BOOL success, NSURLSessionDataTask *task, id response, NSError *error) {
//         [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
//         if (success) {
//             [self loadSearchDataDetailsWithData:response[@"data"]];
//         }
//         else {
//             [self showAlertWithError:error];
//         }
//     }];
}

- (IBAction)btnSearchPressed:(id)sender {
    [self.view endEditing:YES];
    [self loadSearchDataFromServer];
}
-(void) loadSearchDataDetailsWithData: (NSArray *)List
{
    _SearchDataList = [NSMutableArray array];
    _SearchDataList = [List copy];
    //[self.navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:true completion:^{
        if(_delegate && [_delegate respondsToSelector:@selector(searchDidDismisWithData:)])
        {
            [_delegate searchDidDismisWithData:_SearchDataList];
        }
    }];

   
}
//SearchDataList
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [searchResultPlaces count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"GooglePlacesAutocompleteCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    cell.backgroundColor = [UIColor clearColor];
    cell.contentView.backgroundColor = [UIColor clearColor];
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.textLabel.textColor = [UIColor whiteColor];
//    cell.textLabel.text = [self placeAtIndexPath:indexPath];
    cell.textLabel.text =searchResultPlaces[indexPath.row];
    return cell;
}

- (SPGooglePlacesAutocompletePlace *)placeAtIndexPath:(NSIndexPath *)indexPath {
    return [searchResultPlaces objectAtIndex:indexPath.row];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    

    if ([_StrSelect isEqualToString:@"search"]) {
        _searchField.text = searchResultPlaces[indexPath.row];
    }
    else if ([_StrSelect isEqualToString:@"location"]) {
        _locationField.text = searchResultPlaces[indexPath.row];
    }
    [self.locationField resignFirstResponder];
    [self.searchField resignFirstResponder];
    _StrSelect = @"";
    
    searchResultPlaces = nil;
    [self.tableView reloadData];
}


@end
