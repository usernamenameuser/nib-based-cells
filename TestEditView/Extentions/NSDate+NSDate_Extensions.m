//
//  NSDate+NSDate_Extensions.m
//  TestEditView
//
//  Created by Владислав  on 05.06.17.
//  Copyright © 2017 rudd. All rights reserved.
//

#import "NSDate+NSDate_Extensions.h"

@implementation NSDate (NSDate_Extensions)

- (NSString *)ageString {
    NSString *dateString = [NSDateFormatter localizedStringFromDate:self
                                                          dateStyle:NSDateFormatterLongStyle
                                                          timeStyle:NSDateFormatterNoStyle];
 	return dateString;
}

@end
