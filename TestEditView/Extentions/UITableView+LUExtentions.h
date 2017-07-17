//
//  UITableView+LUExtentions.h
//  TableView
//
//  Created by Daria on 3/29/17.
//  Copyright © 2017 Daria. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableView (LUExtentions)

- (void)perfomUpdates:(void(^)(void))handler;

@end
