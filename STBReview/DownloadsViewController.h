//
//  DownloadsViewController.h
//  STBReview
//
//  Created by Rudd Fawcett on 11/17/12.
//  Copyright (c) 2012 Rudd Fawcett. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import <QuickLook/QuickLook.h>

@interface DownloadsViewController : UITableViewController <QLPreviewControllerDataSource>

@property (strong, nonatomic) NSMutableDictionary* detailDataSourceDict;
@property (strong, nonatomic) NSMutableArray* detailDataSource;

@end
