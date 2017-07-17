//
//  ViewController.h
//  TestEditView
//
//  Created by user06 on 06.03.17.
//  Copyright © 2017 rudd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Person.h"

@class ViewController;

@protocol ViewControllerDelegate <NSObject>
- (void)controller:(ViewController *)controller didFillPerson:(Person *)person;
@end

typedef void (^PersonBlock)(Person *person);

@interface ViewController : UIViewController <UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UIView *pickerOfCountry;
@property (strong, nonatomic) IBOutlet UIView *pickerOfAge;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *topOffSet;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *topOffSetForAge;

@property (strong, nonatomic) Person *person;
@property (nonatomic, copy) PersonBlock personHandler;

@property (weak, nonatomic) id <ViewControllerDelegate> delegate;

@end

