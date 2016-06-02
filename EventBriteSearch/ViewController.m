//
//  ViewController.m
//  EventBriteSearch
//
//  Created by Robin Spinks on 30/05/2016.
//  Copyright © 2016 Robin Spinks. All rights reserved.
//

#import "ViewController.h"
#import "DataFetcher.h"
#import "DataHandler.h"
#import "TableViewController.h"

/**
 * Define city names in a macro for now
 * A full implementation would use a data source
 * This way makes it easier to change in the future
 */
#define CITIES @[@"London", @"Madrid", @"New York"]

@interface ViewController () <UIPickerViewDelegate, UIPickerViewDataSource>

@property (strong, nonatomic) IBOutlet UILabel* titleLabel;
@property (strong, nonatomic) IBOutlet UILabel* cityLabel;
@property (strong, nonatomic) IBOutlet UIPickerView* cityPicker;
@property (strong, nonatomic) IBOutlet UIButton* searchButton;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView* activityIndicator;
@property (strong, nonatomic) IBOutletCollection (UILabel) NSArray* labels;

@end

@implementation ViewController

#pragma mark ViewController methods

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(showTable:)
                                                 name:@"kDataDidFinishloading"
                                               object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark UIPickerViewDelegate methods

- (NSString *)pickerView:(UIPickerView *)pickerView
             titleForRow:(NSInteger)row
            forComponent:(NSInteger)component {
    return CITIES[row];
}

#pragma mark UIPickerViewDataSource methods

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView
numberOfRowsInComponent:(NSInteger)component {
    return CITIES.count;
}

#pragma mark IBAction methods

- (IBAction)searchButtonTapped:(id)sender {
    NSString* city = CITIES[[self.cityPicker selectedRowInComponent:0]];
    [self.activityIndicator startAnimating];
    [self.searchButton setEnabled:NO];
    [[DataFetcher sharedInstance] downloadEventsForCity:city
                                      completionHandler:^(AFHTTPRequestOperation *operation, id responseObject) {
        [[DataHandler sharedInstance] saveData:(NSData *)responseObject withCity:city];
    }];
}

#pragma mark Custom methods

- (void)showTable:(NSNotification*)notification {
    [self.activityIndicator stopAnimating];
    [self.searchButton setEnabled:YES];
    
    TableViewController* tableVC = [TableViewController new];
    tableVC.city = CITIES[[self.cityPicker selectedRowInComponent:0]];
    
    if (notification.userInfo[@"didComplete"]) {
        [self presentViewController:tableVC animated:YES completion:^{
            //
        }];
    }
}

@end
