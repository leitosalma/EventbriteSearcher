//
//  EVSSearchViewController.m
//  EventbriteSearcher
//
//  Created by Leonardo Salmaso on 5/4/16.
//  Copyright © 2016 Leonardo Salmaso. All rights reserved.
//

#import "EVSSearchViewController.h"
#import "EVSSearchResultTableViewCell.h"
#import "EVSSearchResultDTO.h"
#import "EVSManager.h"
#import "UIImageView+AFNetworking.h"
#import "EVSEventDetailViewController.h"

@interface EVSSearchViewController ()

@property (atomic) int currentPage;
@property (nullable, strong, nonatomic) NSString *detailToShow;
@property (nullable, strong, nonatomic) NSMutableArray *events;
@property (nullable, strong, nonatomic) NSDateFormatter *formatter;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UILabel *noItemsLabel;
@property (weak, nonatomic) IBOutlet UISearchBar *searchControl;

@end

@implementation EVSSearchViewController

static NSString * const cellIdentifier = @"SearchResultIdentifier";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.events = [[NSMutableArray alloc] init];
    
    //Configure tableView
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 300;
    
    self.formatter = [[NSDateFormatter alloc] init];
    NSTimeZone *gmt = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
    [self.formatter setDateFormat:@"EEE, MMM dd, hh:mm"];
    [self.formatter setTimeZone:gmt];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self fetchEvents:@"" forPage:0];
}

- (void)fetchEvents:(NSString *)query forPage:(int)pageNumber {
    
    if (pageNumber == 0) {
        self.tableView.hidden = true;
        self.noItemsLabel.hidden = true;
        [self.activityIndicator startAnimating];
    }
    
    [[EVSManager sharedInstance] searchEventsForQuery:query sinceDate:[NSDate date] pageNumber:pageNumber completionBlock:^(id  _Nullable response, NSError * _Nullable error) {
       
        self.tableView.hidden = false;
        [self.activityIndicator stopAnimating];
        
        if(error == nil) {
            
            if(pageNumber == 0) {
                self.events = response;
            } else {
                [self.events addObjectsFromArray:response];
            }
            
            if (self.events.count == 0) {
                self.noItemsLabel.hidden = false;
            } else {
                self.noItemsLabel.hidden = true;
            }
            [self.tableView reloadData];
        } else {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Error", "")message:NSLocalizedString(@"Error trying to fetch events", "") preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                
            }];
            
            [alert addAction:okAction];
            
            [self presentViewController:alert animated:YES completion:nil];
        }
    }];
}


-(void)loadMoreSearchItems:(int)rowNumber {
    if (rowNumber == self.events.count - 10) {
        self.currentPage++;
        [self fetchEvents:self.searchControl.text forPage:self.currentPage];
    }
}

#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.events.count;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    EVSSearchResultDTO *currentEvent = self.events[indexPath.row];
    EVSSearchResultTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    cell.eventTitle.text = currentEvent.title;
    cell.eventDate.text = [self.formatter stringFromDate:currentEvent.date];
    
    NSURLRequest *imageRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:currentEvent.imageUrl]
                                                  cachePolicy:NSURLRequestReturnCacheDataElseLoad
                                              timeoutInterval:240];
    
    [cell.eventImage setImageWithURLRequest:imageRequest
                               placeholderImage:[UIImage imageNamed:@"Placeholder"]
                                        success:nil
                                        failure:nil];
    
    
    [self loadMoreSearchItems:(int)indexPath.row];
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    return 300;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    EVSSearchResultDTO *dto = self.events[indexPath.row];
    self.detailToShow = dto.detail;
    [self performSegueWithIdentifier:@"showEventDetail" sender:self];
}

#pragma mark UISearchBarDelegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [self performSelector:@selector(sendSearchRequest:) withObject:searchText afterDelay:0.5f];
}

-(void)sendSearchRequest:(NSString*)searchText {
    //Search always starts in page 0
    [self fetchEvents:searchText forPage:0];
}

#pragma mark Navigation

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"showEventDetail"]) {
        EVSEventDetailViewController *vc = segue.destinationViewController;
        vc.detail = self.detailToShow;
    }
}

@end
