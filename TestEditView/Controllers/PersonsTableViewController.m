//
//  PersonsTableViewController.m
//  TestEditView
//
//  Created by Denis on 14.05.17.
//  Copyright © 2017 rudd. All rights reserved.
//

#import "PersonsTableViewController.h"
#import "PersonCell.h"
#import "Person.h"
#import "ViewController.h"
#import "PersonList.h"
#import "UITableView+LUExtentions.h"

static NSString *PersonViewControllerShow = @"PersonViewControllerShow";

@interface PersonsTableViewController () <ViewControllerDelegate>

@end


@implementation PersonsTableViewController

#pragma mark - View life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    
    NSString *cellIdentifier = NSStringFromClass([PersonCell class]);
    [self.tableView registerNib:[UINib nibWithNibName:cellIdentifier bundle:[NSBundle mainBundle]] forCellReuseIdentifier:cellIdentifier];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    id destinationController = [segue destinationViewController];
    BOOL isNewPerson = ![sender isKindOfClass:[Person class]];
    Person *selectedPerson =  isNewPerson ? [[Person alloc] init] : sender;
    if ([destinationController isKindOfClass:[ViewController class]]) {
        [destinationController setDelegate:self];
        [destinationController setPerson:selectedPerson];
        NSString *title = isNewPerson ? selectedPerson.firstName: @"Новый человк";
        [destinationController setTitle:title];
        
        [destinationController setPersonHandler:^(Person *person){
            if (isNewPerson) {
                [self insertPerson:person];
            } else {
                [self updatePerson:person];
            }
        }];
    }
}

- (void)insertPerson:(Person *)person {
    [[PersonList sharedList] addPerson:person];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[[[PersonList sharedList] allPersons] count]-1 inSection:0];
    __weak typeof(self) weakSelf = self;
    [self.tableView perfomUpdates:^{
        __strong typeof(self) self = weakSelf;
        [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];
    }];
}

- (void)updatePerson:(Person *)person {
    NSInteger index = [[[PersonList sharedList] allPersons] indexOfObject:person];
    
    if (index != NSNotFound && index < [self.tableView numberOfRowsInSection:0]) {
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
    } else {
        [self.tableView reloadData];
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSString *key =  [[PersonList sharedList] sortedPersonsGroups].allKeys[section];
    NSArray *objects = [[[PersonList sharedList] sortedPersonsGroups] objectForKey:key];
    return objects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *key =  [[PersonList sharedList] sortedPersonsGroups].allKeys[indexPath.section];
    NSArray *persons = [[[PersonList sharedList] sortedPersonsGroups] objectForKey:key];
//    NSArray *persons = [[PersonList sharedList] allPersons];
    Person *person = persons[indexPath.row];
    
    NSString *identifier = NSStringFromClass([PersonCell class]);
    PersonCell *personCell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    [personCell fillWithPerson:person];
    
    return personCell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [[PersonList sharedList] sortedPersonsGroups].allKeys.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70.0;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *key =  [[PersonList sharedList] sortedPersonsGroups].allKeys[indexPath.section];
    NSArray *objects = [[[PersonList sharedList] sortedPersonsGroups] objectForKey:key];
    Person *selectedPerson = [objects objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:PersonViewControllerShow sender:selectedPerson];
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSArray *persons = [[PersonList sharedList] allPersons];
        Person *person = persons[indexPath.row];
        [[PersonList sharedList] removePerson:person];
        
        [self.tableView perfomUpdates:^{
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }];
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSString *key = [[PersonList sharedList] sortedPersonsGroups].allKeys[section];
    return key;
}

// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
    [[PersonList sharedList] movePersonAtIndex:fromIndexPath.row toIndex:toIndexPath.row];
}

#pragma mark - Actions

- (IBAction)addNewPerson:(id)sender {
    [self performSegueWithIdentifier:PersonViewControllerShow sender:nil];
    
}

#pragma mark - <ViewControllerDelegate>

- (void)controller:(ViewController *)controller didFillPerson:(Person *)person {
    Person *personToInsert = nil;
    NSInteger indexCounter = 0;
    for (Person *personObject in [[PersonList sharedList] allPersons]) {
        if (personObject == person) {
            personToInsert = personObject;
            break;
        }
        indexCounter++;
    }
    if (personToInsert == nil) {
        [[PersonList sharedList] addPerson:person];
    } else {
        [[PersonList sharedList] updatePerson:personToInsert atIndex:indexCounter];
    }
    [self.tableView reloadData];
}

@end
