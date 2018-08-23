//
//  TableViewController.h
//  iOSChallenge
//
//  Created by Aaron Perry on 8/23/18.
//  Copyright © 2018 Aaron Perry. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TableViewController : UITableViewController <UISearchBarDelegate, UISearchControllerDelegate, UISearchResultsUpdating>

@property NSArray *jsonArray;
@property (nonatomic, strong) NSMutableArray * filteredFeed;
@property (nonatomic, weak) NSArray * displayedFeed;

@property (strong, nonatomic) UISearchController *searchController;



@end
