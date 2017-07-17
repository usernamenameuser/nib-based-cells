//
//  PersonList.m
//  TestEditView
//
//  Created by Denis on 14.05.17.
//  Copyright © 2017 rudd. All rights reserved.
//

#import "PersonList.h"
#import "Person.h"

@interface PersonList ()

@property (nonatomic, strong) NSMutableArray *privatePersons;
@property (nonatomic, strong) NSMutableDictionary *privateSortedPersonsGroups;
@property (nonatomic, strong) NSMutableArray *privateFirstCharacters;

@end

@implementation PersonList

+ (instancetype)sharedList{
    static PersonList *sharedList = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedList = [[self alloc] initPrivate];
    });
    return sharedList;
}

- (instancetype)init{
    @throw [NSException exceptionWithName:@"Singleton" reason:@"Use [PersonsList sharedList]" userInfo:nil];
    return nil;
}

- (instancetype)initPrivate{
    self = [super init];
    if (self) {
        _privatePersons = [[NSMutableArray alloc] init];
        _privateFirstCharacters = [[NSMutableArray alloc] init];
        _privateSortedPersonsGroups = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (NSArray *)allPersons{
    return [self.privatePersons copy];
}

- (NSDictionary *)sortedPersonsGroups{
    return [self.privateSortedPersonsGroups copy];
}

- (NSArray *)firstCharacters{
    return [self.privateFirstCharacters copy];
}

- (void)addPerson:(Person *)person{
    [self.privatePersons addObject:person];
    [self updatePersonsGroups];
}

- (void)movePersonAtIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex{
    if(fromIndex == toIndex) return;
    
    Person *person = self.privatePersons[fromIndex];
    [self.privatePersons removeObjectAtIndex:fromIndex];
    [self.privatePersons insertObject:person atIndex:toIndex];
}

- (void)removePerson:(Person *)person{
    //[[ImageStore sharedStore] deleteImageForKey:person.imageKey];
    [self.privatePersons removeObjectIdenticalTo:person];
    [self updatePersonsGroups];
}

- (void)updatePerson:(Person *)person atIndex:(NSInteger)index {
    self.privatePersons[index] = person;
    [self updatePersonsGroups];
}

- (void)updatePersonsGroups{
    [self.privateFirstCharacters removeAllObjects];
    [self.privateSortedPersonsGroups removeAllObjects];
    
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"lastName" ascending:YES selector:@selector(caseInsensitiveCompare:)];
    NSArray *sortedPersons = [self.privatePersons sortedArrayUsingDescriptors:@[sort]];
    
    for (Person *person in sortedPersons) {
        NSString *firstCharacter = [[person.lastName substringToIndex:1] uppercaseString];
        
        if (![self.privateFirstCharacters containsObject:firstCharacter]) {
            [self.privateFirstCharacters addObject:firstCharacter];
            NSMutableArray *group = [NSMutableArray arrayWithObject:person];
            [self.privateSortedPersonsGroups setObject:[group mutableCopy] forKey:firstCharacter];
        } else {
            [self.privateSortedPersonsGroups[firstCharacter] addObject:person];
        }
    }
}

@end

