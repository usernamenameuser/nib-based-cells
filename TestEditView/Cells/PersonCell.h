//
//  PersonCell.h
//  TestEditView
//
//  Created by Denis on 14.05.17.
//  Copyright © 2017 rudd. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Person;

@interface PersonCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *fullNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *countryLabel;
@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;
@property (weak, nonatomic) IBOutlet UILabel *ageLabel;


- (void)fillWithPerson:(Person *)person;

@end
