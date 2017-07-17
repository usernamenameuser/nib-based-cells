//
//  Person.m
//  TestEditView
//
//  Created by Denis Slipko on 12.03.17.
//  Copyright © 2017 rudd. All rights reserved.
//

#import "Person.h"

@implementation Person

- (NSString *)description
{
    NSString *formatedBirtday = [NSDateFormatter localizedStringFromDate:self.age dateStyle:NSDateFormatterLongStyle timeStyle:NSDateFormatterNoStyle];
    return [NSString stringWithFormat:@"%@\n%@\n%@\n%@\n%@", self.firstName,self.lastName , formatedBirtday , self.country ,(self.sex)? @"Male" : @"Female"];
}
@end
