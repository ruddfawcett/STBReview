//
//  SheetDrillDownViewController.h
//  STBReview
//
//  Created by Rudd Fawcett on 11/14/12.
//  Copyright (c) 2012 Rudd Fawcett. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "MBProgressHUD.h"

@interface SheetDrillDownViewController : UITableViewController<MBProgressHUDDelegate, UIActionSheetDelegate, MFMailComposeViewControllerDelegate>
{
	MBProgressHUD *HUD;
    
	long long expectedLength;
	long long currentLength;
    
    NSString *selectedItem;
    NSInteger selectedIndex;
}

-(IBAction)initActionSheet:(id)sender;
@property (nonatomic) NSInteger selectedIndex;
@property (nonatomic, retain) NSString *selectedItem;
@property (strong, nonatomic) NSMutableArray* detailDataSourceDict;
@end
