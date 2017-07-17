//
//  Person.h
//  TestEditView
//
//  Created by Denis Slipko on 12.03.17.
//  Copyright © 2017 rudd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Person : NSObject

@property (strong, nonatomic) UIImage *image;
@property (copy, nonatomic) NSString *firstName;
@property (copy, nonatomic) NSString *lastName;
@property (copy, nonatomic) NSString *country;
@property (strong, nonatomic) NSDate* age;
@property (assign, nonatomic) BOOL sex;

@end
