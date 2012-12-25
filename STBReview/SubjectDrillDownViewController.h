//
//  SubjectDrillDownViewController.h
//  STBReview
//
//  Created by Rudd Fawcett on 11/11/12.
//  Copyright (c) 2012 Rudd Fawcett. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SubjectDrillDownViewController : UITableViewController
{
    NSString *selectedItem;
    NSInteger selectedIndex;
}

@property (nonatomic) NSInteger selectedIndex;
@property (nonatomic, retain) NSString *selectedItem;
@property (strong, nonatomic) NSMutableDictionary* detailDataSourceDict;
@property (strong, nonatomic) NSMutableArray* detailDataSource;
@end
