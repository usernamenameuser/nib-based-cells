//
//  ViewController.m
//  TestEditView
//
//  Created by user06 on 06.03.17.
//  Copyright © 2017 rudd. All rights reserved.
//

#import "ViewController.h"
#import "Person.h"
#import "NSDate+NSDate_Extensions.h"

static const CGFloat LUPickerHeight = 304;
static const CGFloat LUPickerTopOffSet = -99;
static const CGFloat LUAnimationDuration = 1.20;

@interface ViewController () <UITextViewDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (weak, nonatomic) IBOutlet UIButton *imageButton;
@property (weak, nonatomic) IBOutlet UIButton *toFillButton;
@property (strong, nonatomic) IBOutlet UITextField *nameField;
@property (strong, nonatomic) IBOutlet UITextField *lastNameField;
@property (strong, nonatomic) IBOutlet UITextField *ageField;
@property (strong, nonatomic) IBOutlet UITextField *countryField;
@property (strong, nonatomic) IBOutlet UISwitch *switchButton;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *valueOfConstraint;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIDatePicker *datePicker;

@property (strong,nonatomic) NSString* country;
@property (nonatomic, strong) NSArray *countries;

//@property (strong, nonatomic) Person *person;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupViewController];
    [self subscribeToKeyboardNotifications];
    self.countries = [NSLocale ISOCountryCodes];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)setupViewController {
    self.nameField.text = self.person.firstName;
    self.lastNameField.text = self.person.lastName;
    self.countryField.text = self.person.country;
    if (self.person.age != nil) {
        self.ageField.text = [self.person.age ageString];
    } else {
        self.ageField.text = @"";
    }
    if (self.person.image != nil) {
        [self.imageButton
         setImage:self.person.image forState:UIControlStateNormal];
    }
    self.toFillButton.enabled = [self areNameFieldsValid];
}

- (BOOL)areNameFieldsValid {
    if (self.nameField.text.length > 0 && self.lastNameField.text.length > 0) {
        return YES;
    }
    return NO;
}

#pragma mark - TextField delegate

- (IBAction)textFieldEditingChanged:(UITextField *)sender {
    self.toFillButton.enabled = [self areNameFieldsValid];
}


- (BOOL) textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];

    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    BOOL isPickerField = (textField == self.countryField || textField == self.ageField);
    if (isPickerField) {
        [self testHidePicker:textField];
        [self.view endEditing:YES];
    }
    
    return !isPickerField;
}
#pragma -mark Actions

- (IBAction)showPickerAge:(id)sender {
    [self performViewAnimations:^{
        self.topOffSetForAge.constant = (self.topOffSetForAge.constant == LUPickerTopOffSet) ? LUPickerHeight : LUPickerTopOffSet;
    }];
}

- (void)performViewAnimations:(void (^)(void))animations {
    if (animations) {
        animations();
        [UIView animateWithDuration:LUAnimationDuration animations:^{
            [self.view layoutIfNeeded];
        }];
    }
}

- (IBAction)doneForAge:(id)sender {
    [self pickerHide];
    NSString *dateString = [NSDateFormatter localizedStringFromDate:self.datePicker.date
                                                          dateStyle:NSDateFormatterLongStyle
                                                          timeStyle:NSDateFormatterNoStyle];
    self.ageField.text = [NSString stringWithFormat:@"%@",dateString];
    self.person.age = self.datePicker.date;
}

- (IBAction)showPickerCountry:(id)sender {
    [self performViewAnimations:^{
        self.topOffSet.constant = (self.topOffSet.constant == LUPickerTopOffSet) ? LUPickerHeight : LUPickerTopOffSet;
    }];
}


- (IBAction)doneAndCloseThePicker:(id)sender {
    [self pickerHide];
    self.countryField.text = self.country;
}

- (void)pickerHide{
    self.topOffSet.constant =  LUPickerHeight;
    self.topOffSetForAge.constant =  LUPickerHeight;
        
    self.scrollView.contentInset = UIEdgeInsetsMake(0, 0, LUPickerTopOffSet, 0);
    [UIView animateWithDuration:LUAnimationDuration animations:^{
        [self.scrollView scrollRectToVisible:CGRectMake(self.scrollView.contentSize.width - 1,
                                                            self.scrollView.contentSize.height - 1, 1, 1) animated:YES];
        [self.view layoutIfNeeded];
    }];
}


- (IBAction)showTheInformation:(UIButton*)sender {
    
    self.person.firstName = self.nameField.text;
    self.person.lastName = self.lastNameField.text;
    self.person.age = self.datePicker.date;
    self.person.country = self.countryField.text;
    self.person.sex = self.switchButton.isOn;
    self.person.image = self.imageButton.imageView.image;
    [self.delegate controller:self didFillPerson:self.person];

    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)takeImageClicked:(id)sender {
    UIAlertController *selectionController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [selectionController addAction:[UIAlertAction actionWithTitle:@"Камера" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self showPickerForSource:UIImagePickerControllerSourceTypeCamera];
        }]];
    }
    
    [selectionController addAction:[UIAlertAction actionWithTitle:@"Выбрать фото" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self showPickerForSource:UIImagePickerControllerSourceTypePhotoLibrary];
    }]];
    [selectionController addAction:[UIAlertAction actionWithTitle:@"Отмена" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {}]];
    [self presentViewController:selectionController animated:YES completion:nil];
}

#pragma -mark Notifications of keyboard

- (void)subscribeToKeyboardNotifications {
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter addObserver:self
                           selector:@selector(keyboarDidChange:)
                               name:UIKeyboardWillShowNotification
                             object:nil];
    [notificationCenter addObserver:self
                           selector:@selector(keyboarDidChange:)
                               name:UIKeyboardWillChangeFrameNotification
                             object:nil];
    [notificationCenter addObserver:self
                           selector:@selector(keyboardDidHide:)
                               name:UIKeyboardWillHideNotification
                             object:nil];
}

- (void)unsubscribeFromKeyboardNotifications {
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter removeObserver:self
                                  name:UIKeyboardWillShowNotification
                                object:nil];
    [notificationCenter removeObserver:self
                                  name:UIKeyboardWillChangeFrameNotification
                                object:nil];
    [notificationCenter removeObserver:self
                                  name:UIKeyboardWillHideNotification
                                object:nil];
}

- (void)keyboarDidChange:(NSNotification *)notification {
    NSDictionary *userInfo = notification.userInfo;
    NSTimeInterval duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    CGRect keyboardFrame = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    self.scrollView.contentInset = UIEdgeInsetsMake(0, 0, keyboardFrame.size.height, 0);
    [UIView animateWithDuration:duration animations:^{
        [self.scrollView scrollRectToVisible:CGRectMake(self.scrollView.contentSize.width - 1,
                                                        self.scrollView.contentSize.height - 1, 1, 1) animated:YES];
    }];
    [self pickerHide];
}


#pragma mark - Picker delegate methods

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    self.country = [[NSLocale currentLocale] displayNameForKey:NSLocaleCountryCode value:self.countries[row]];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.countries.count;
}

- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [[NSLocale currentLocale] displayNameForKey:NSLocaleCountryCode value:self.countries[row]];
}

#pragma -mark Picker

- (void)showPickerForSource:(UIImagePickerControllerSourceType)sourceType{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.sourceType = sourceType;
    imagePicker.editing = YES;
    imagePicker.delegate = self;
    [self presentViewController:imagePicker animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    [self.imageButton setImage:image forState:UIControlStateNormal];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)keyboardDidHide:(NSNotification *)notification {
    NSDictionary *userInfo = notification.userInfo;
    NSTimeInterval duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    [UIView animateWithDuration:duration animations:^{
        self.scrollView.contentInset = UIEdgeInsetsZero;
    }];
}

- (void) testHidePicker:(UITextField*)textField {
    if (textField == self.countryField) {
        self.topOffSet.constant =  0;
        self.topOffSetForAge.constant =  LUPickerHeight;
    } else {
        self.topOffSetForAge.constant =  0;
        self.topOffSet.constant =  LUPickerHeight;
    }
    self.scrollView.contentInset = UIEdgeInsetsMake(0, 0, LUPickerHeight, 0);
    [UIView animateWithDuration:LUAnimationDuration animations:^{
        [self.scrollView scrollRectToVisible:CGRectMake(self.scrollView.contentSize.width - 1,
                                                        self.scrollView.contentSize.height - 1, 1, 1) animated:YES];
        [self.view layoutIfNeeded];
    }];
}


@end
