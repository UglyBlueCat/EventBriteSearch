//
//  TableViewController.m
//  EventBriteSearch
//
//  Created by Robin Spinks on 02/06/2016.
//  Copyright © 2016 Robin Spinks. All rights reserved.
//

#import "TableViewController.h"
#import "DataHandler.h"
#import "Event.h"
#import "EventCell.h"
#import "DataFetcher.h"

@interface TableViewController () <UITableViewDelegate, UITableViewDataSource>

@property UITableView* tableView;
@property NSArray* events;
@property UIButton* backButton;

@end

@implementation TableViewController {
    CGFloat _horizontalSpacer;
    CGFloat _verticalSpacer;
    CGFloat _rowHeight;
    CGFloat _buttonHeight;
}

#pragma mark ViewController methods

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureView];
    self.events = [[DataHandler sharedInstance] eventsForCity:self.city];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark UITableViewDelegate methods

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

#pragma mark UITableViewDataSource methods

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString* reuseIdentifier = NSStringFromClass([EventCell class]);;
    EventCell* cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    Event* event = self.events[indexPath.row];
    [cell.nameLabel setText:event.name];
    
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy'-'MM'-'dd'T'HH':'mm':'ss'Z'"];
    
    NSDate* startDate = [dateFormatter dateFromString:event.start];
    NSDate* endDate = [dateFormatter dateFromString:event.end];
    [dateFormatter setDateStyle:NSDateFormatterShortStyle];
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    
    NSString* startDateStr = [dateFormatter stringFromDate:startDate];
    NSString* endDateStr = [dateFormatter stringFromDate:endDate];
    
    NSString* labelText = [NSString stringWithFormat:@"%@ - %@", startDateStr, endDateStr];
    
    [cell.dateLabel setText:labelText];
    
    if (event.logo) {
        [cell.imageHolder setImage:[self loadOrFetchImageForCellAt:indexPath]];
    }

    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    return self.events.count;
}

#pragma mark Custom methods

- (void)configureView {
    [self.view setBackgroundColor:[UIColor colorWithRed:1 green:0 blue:1 alpha:1]];
    _horizontalSpacer = 20;
    _verticalSpacer = 5;
    _rowHeight = 88;
    _buttonHeight = 40;
    [self configureTableView];
    [self configureButtons];
}

- (void)configureTableView {
    CGRect tableFrame = CGRectMake(_verticalSpacer,
                                   _horizontalSpacer,
                                   CGRectGetWidth(self.view.bounds) - 2*_verticalSpacer,
                                   CGRectGetHeight(self.view.bounds) - 2*_horizontalSpacer - _buttonHeight);
    self.tableView = [[UITableView alloc] initWithFrame:tableFrame];
    [self.tableView setDataSource:self];
    [self.tableView setDelegate:self];
    
    NSString* reuseIdentifier = NSStringFromClass([EventCell class]);;
    UINib* nib = [UINib nibWithNibName:reuseIdentifier bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:reuseIdentifier];
    [self.tableView setRowHeight:_rowHeight];
    
    [self.tableView setBackgroundColor:[UIColor clearColor]];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    [self.view addSubview:self.tableView];
}

- (void)configureButtons {
    CGFloat buttonWidth = 200;
    CGFloat buttonSpacer = (CGRectGetWidth(self.view.bounds) - buttonWidth)/2;
    CGFloat buttonTop = CGRectGetMaxY(self.tableView.frame) + _horizontalSpacer;
    CGRect backButtonFrame = CGRectMake(buttonSpacer, buttonTop, buttonWidth, _buttonHeight);
    
    self.backButton = [[UIButton alloc] initWithFrame:backButtonFrame];
    [self.backButton setTitle:@"Back" forState:UIControlStateNormal];
    [self.backButton addTarget:self action:@selector(backButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.backButton];
}

- (void)backButtonTapped {
    [self dismissViewControllerAnimated:YES completion:nil];
}

/**
 * Load an image from filesystem 
 * Download image if it doesn't exist
 *
 * @param:(NSIndexPath *)indexPath
 *      - The indexPath of the cell the image is for
 *
 * @return:UIImage*
 *      - The image object to display
 */
- (UIImage*)loadOrFetchImageForCellAt:(NSIndexPath *)indexPath {
    Event* event = self.events[indexPath.row];
    __block NSIndexPath* localIndexPath = indexPath;
    NSString* imageName = [NSString stringWithFormat:@"%@.png", event.eventid];
    NSString* pathComponent = [NSString stringWithFormat:@"Documents/%@", imageName];
    NSString* imagePath = [NSHomeDirectory() stringByAppendingPathComponent:pathComponent];
    UIImage* image = [UIImage imageWithContentsOfFile:imagePath];
    if (!image) {
        NSString* imageURL = event.logo;
        [[DataFetcher sharedInstance] downloadDataFromURL:imageURL
                                                  success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                                      [self saveImageFromData:responseObject
                                                                    forCellAt:localIndexPath
                                                                     withName:imageName];
                                                  }];
    }
    return image;
}

/**
 * Save an image from downloaded data
 * 
 * @param:(NSData*)data 
 *      - The data object
 *
 * @param:(NSIndexPath *)indexPath
 *      - The indexPath of the cell to display the image
 *
 * @param:(NSString*)imageName
 *      - The name of the image
 */
- (void)saveImageFromData:(NSData*)data forCellAt:(NSIndexPath *)indexPath withName:(NSString*)imageName {
    UIImage* image = [UIImage imageWithData:data];
    NSString* pathComponent = [NSString stringWithFormat:@"Documents/%@", imageName];
    NSString* imagePath = [NSHomeDirectory() stringByAppendingPathComponent:pathComponent];
    [UIImagePNGRepresentation(image) writeToFile:imagePath atomically:YES];
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

@end
