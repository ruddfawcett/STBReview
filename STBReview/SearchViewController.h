//
//  SearchViewController.h
//  STBReview
//
//  Created by Rudd Fawcett on 11/3/12.
//  Copyright (c) 2012 Rudd Fawcett. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface SearchViewController : UITableViewController <MBProgressHUDDelegate, UISearchBarDelegate,UISearchDisplayDelegate,UITableViewDataSource,UITableViewDelegate> {
	MBProgressHUD *HUD;
    
	long long expectedLength;
	long long currentLength;
}
@property (strong, nonatomic) NSMutableArray* tableDataSource;
@property (strong, nonatomic) NSArray* tableDataSourceArray;
@property (strong, nonatomic) NSMutableArray* searchSource;
//@property (strong, nonatomic) NSArray* searchResults;
-(IBAction)btnLogout:(id)sender;
-(IBAction)refresh:(id)sender;

@end