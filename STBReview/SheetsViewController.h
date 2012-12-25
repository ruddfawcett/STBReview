//
//  SheetsViewController.h
//  STBReview
//
//  Created by Rudd Fawcett on 11/3/12.
//  Copyright (c) 2012 Rudd Fawcett. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface SheetsViewController : UITableViewController <MBProgressHUDDelegate> {
	MBProgressHUD *HUD;
    
	long long expectedLength;
	long long currentLength;
}
@property (strong, nonatomic) NSMutableArray* tableDataSource;
-(IBAction)btnLogout:(id)sender;
-(IBAction)refresh:(id)sender;

@end