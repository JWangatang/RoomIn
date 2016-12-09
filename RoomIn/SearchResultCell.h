//
//  SearchResultCell.h
//  RoomIn
//
//  Created by Jonathan Wang on 12/6/16.
//  Copyright © 2016 JonathanWang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchResultCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *fullName;
@property (strong, nonatomic) IBOutlet UILabel *industryAndCompany;
@property (strong, nonatomic) IBOutlet UISwitch *matchSwitch;

@end
