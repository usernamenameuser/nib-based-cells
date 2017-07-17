//
//  PersonCell.m
//  TestEditView
//
//  Created by Denis on 14.05.17.
//  Copyright © 2017 rudd. All rights reserved.
//

#import "PersonCell.h"
#import "Person.h"

@implementation PersonCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)fillWithPerson:(Person *)person {
    self.fullNameLabel.text = [NSString stringWithFormat:@"%@ %@", person.firstName, person.lastName];
    self.countryLabel.text = person.country;
    if (person.age != nil) {
        self.ageLabel.text = [NSDateFormatter localizedStringFromDate:person.age
                                                            dateStyle:NSDateFormatterLongStyle
                                                            timeStyle:NSDateFormatterNoStyle];
    }
    
    self.photoImageView.image = person.image;
}

@end
