//
//  TableViewController.m
//  iOSChallenge
//
//  Created by Aaron Perry on 8/23/18.
//  Copyright © 2018 Aaron Perry. All rights reserved.
//

#import "TableViewController.h"
#import "TableViewCell.h"

@interface TableViewController ()

@property (strong, nonatomic) IBOutlet UITableView *redditTableView;

@end

@implementation TableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupSearchController];
    
    [self loadData];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) setupSearchController {
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    self.searchController.searchResultsUpdater = self;
    self.searchController.searchBar.delegate = self;
    self.searchController.dimsBackgroundDuringPresentation = NO;
    [self.searchController.searchBar sizeToFit];
    self.tableView.tableHeaderView = self.searchController.searchBar;
}

-(void)loadData{
    
    NSURL *redditURL = [NSURL URLWithString:@"https://www.reddit.com/r/iosdev.json"];
    
    NSData *jsonData = [NSData dataWithContentsOfURL:redditURL];
    
    if (!jsonData) {
        NSLog(@"Error getting data from url %@", redditURL);
        return;
    }
    
    NSError *err;
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:&err];
    
    if (err) {
        NSLog(@"Error parsing JSON from url %@", redditURL);
        return;
    }
    
    self.jsonArray = [[dict objectForKey:@"data"] objectForKey:@"children"];
    
    self.displayedFeed = self.jsonArray;
    self.filteredFeed = [[NSMutableArray alloc] init];
    
    [self.redditTableView reloadData];
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.displayedFeed.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    NSDictionary *dict = [[self.displayedFeed objectAtIndex:indexPath.row] objectForKey:@"data"];
    
    cell.title.text = [dict objectForKey:@"title"];
    
    cell.comments.text = [[dict objectForKey:@"num_comments"] stringValue];
    
    cell.author.text = [dict objectForKey:@"author"];
    
    return cell;
}

- (void) tableView: (UITableView *) tableView didSelectRowAtIndexPath: (NSIndexPath *) indexPath {
    
    NSDictionary *dict = [[self.displayedFeed objectAtIndex:indexPath.row] objectForKey:@"data"];
    
    UIAlertAction *actionOK = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        //dismiss alert
        
    }];
    
    NSString *selftext = [dict objectForKey:@"selftext"];
    
    if (selftext.length == 0) {
        selftext = @"No description available.";
    }
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Description" message:selftext preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addAction:actionOK];
    
    if (self.searchController.active) {
        [self.searchController presentViewController:alert animated:YES completion:nil];
    } else {
        [self presentViewController:alert animated:YES completion:nil];
    }
    
}

- (void)updateSearchResultsForSearchController:(UISearchController *)aSearchController {
    
    NSString *searchString = aSearchController.searchBar.text;
    NSLog(@"searchString=%@", searchString);
    
    if (searchString.length > 0) {
        
        [self.filteredFeed removeAllObjects];
        
        for (NSDictionary *dict in self.jsonArray) {
            
            NSString *selftext = [[dict objectForKey:@"data"] objectForKey:@"selftext"];
            
            if ([selftext localizedCaseInsensitiveContainsString:searchString]) {
                [self.filteredFeed addObject:dict];
            }
            
        }
        
        self.displayedFeed = self.filteredFeed;
        
    } else {
        
        self.displayedFeed = self.jsonArray;
        
    }
    
    [self.redditTableView reloadData];
    
}

@end
