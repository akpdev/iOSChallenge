//
//  TableViewCell.h
//  iOSChallenge
//
//  Created by Aaron Perry on 8/23/18.
//  Copyright © 2018 Aaron Perry. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *comments;
@property (weak, nonatomic) IBOutlet UILabel *author;

@end
