//
//  PersonList.h
//  TestEditView
//
//  Created by Denis on 14.05.17.
//  Copyright © 2017 rudd. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Person;

@interface PersonList : NSObject

@property (nonatomic, strong, readonly) NSArray *allPersons;
@property (nonatomic, strong, readonly) NSDictionary *sortedPersonsGroups;
@property (nonatomic, strong, readonly) NSArray *firstCharacters;

+ (instancetype)sharedList;

- (void)addPerson:(Person *)person;
- (void)movePersonAtIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex;
- (void)removePerson:(Person *)person;
- (void)updatePerson:(Person *)person atIndex:(NSInteger)index;

- (void)updatePersonsGroups;
@end
