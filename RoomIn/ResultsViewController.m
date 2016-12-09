//
//  ResultsViewController.m
//  RoomIn
//
//  Created by Jonathan Wang on 12/6/16.
//  Copyright © 2016 JonathanWang. All rights reserved.
//

#import "ResultsViewController.h"
#import "RoomInUser.h"
#import "SearchResultCell.h"
@import Firebase;

@interface ResultsViewController ()
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) FIRDatabaseReference *ref;
@property (strong, nonatomic) NSMutableArray* searchResults;
@end

@implementation ResultsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _searchResults = [[NSMutableArray alloc] init];
    // Do any additional setup after loading the view.
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    _searchBar.delegate = self;
    _ref = [[FIRDatabase database] reference];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)filterClicked:(id)sender {
    
}

- (void) displayNoSearchResults {
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"No results"message:@"Sorry! There are no results in the city you entered. We're currently growing and appreciate you being one of the first in your city to use our app! Keep roomin'!" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {}];
    
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void) searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
    [_searchResults removeAllObjects];
    NSString * city = searchBar.text;
    [[[self.ref child:@"Cities"] child:city] observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        // Get user value
        if([snapshot exists]){
            for (FIRDataSnapshot* child in snapshot.children) {
                [_searchResults addObject:child.value];
            }
            if([_searchResults count] == 0){
                [self displayNoSearchResults];
            } else {
                [_tableView reloadData];
            }
        } else {
            [self displayNoSearchResults];
        }
        
    } withCancelBlock:^(NSError * _Nonnull error) {
        NSLog(@"%@", [error debugDescription]);
    }];

}
- (IBAction)switchChanged:(id)sender {
    if([sender isOn]){
        FIRDatabaseReference * matchDB = [_ref child:@"Matches"];
        [[matchDB child: _searchResults[0]] setValue:@"Matched!"];
    }
}

- (void) searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _searchResults.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SearchResultCell* cell = [tableView dequeueReusableCellWithIdentifier: @"Result Cell"];

    cell.fullName.text = _searchResults[indexPath.row];

    return cell;
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

