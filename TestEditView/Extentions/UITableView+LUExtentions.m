//
//  UITableView+LUExtentions.m
//  TableView
//
//  Created by Daria on 3/29/17.
//  Copyright © 2017 Daria. All rights reserved.
//

#import "UITableView+LUExtentions.h"

@implementation UITableView (LUExtentions)

- (void)perfomUpdates:(void(^)(void))handler {
    if (handler) {
        [self beginUpdates];
        handler();
        [self endUpdates];
    }
}

@end
