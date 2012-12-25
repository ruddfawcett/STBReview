//
//  SheetsViewController.m
//  STBReview
//
//  Created by Rudd Fawcett on 11/3/12.
//  Copyright (c) 2012 Rudd Fawcett. All rights reserved.
//

#import "SheetsViewController.h"
#import "API.h"
#import "TDBadgedCell.h"
#import "SubjectDrillDownViewController.h"
//#import "AppDelegate.h"

@interface SheetsViewController(private)
-(void)viewDidAppear:(BOOL)animated;
-(void)viewDidLoad;
-(void)getJSON;
@end

@implementation SheetsViewController;

@synthesize tableDataSource;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(IBAction)btnLogout:(UIButton*)sender {
    [self LogoutAction];
}

-(void)LogoutAction {
    //logout the user from the server, and also upon success destroy the local authorization
	[[API sharedInstance] commandWithParams:[NSMutableDictionary dictionaryWithObjectsAndKeys:@"logout", @"command", nil] onCompletion:^(NSDictionary *json) {
        //logged out from server
        [API sharedInstance].user = nil;
        [self performSegueWithIdentifier:@"ShowLogin" sender:nil];
	}];
    NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
    [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:appDomain];
    NSLog(@"User Defaults cleared...");
    [tableDataSource removeAllObjects];
    [self.tableView reloadData];
}

-(IBAction)refresh:(UIButton*)sender {
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
	[self.navigationController.view addSubview:hud];
	hud.labelText = @"Loading";
	
	[hud showAnimated:YES whileExecutingBlock:^{
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
		[self jsonLoadingData];

	} completionBlock:^{
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
		[hud removeFromSuperview];
		[hud release];
    }];

}

/* -(void)viewDidAppear:(BOOL)animated {
    [self.tableView reloadData];
} */

- (void)viewDidLoad
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *group = [defaults objectForKey:@"group"];
    if (group !=nil) {
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
	[self.navigationController.view addSubview:hud];
	hud.labelText = @"Loading...";
	
	[hud showAnimated:YES whileExecutingBlock:^{
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
		[self jsonLoadingData];
        [self.tableView reloadData];
	} completionBlock:^{
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
		[hud removeFromSuperview];
		[hud release];
    }];
    }
    if (![[API sharedInstance] isAuthorized]) {
        //NSLog(@"No user logged in, showing login view...");
		[self performSegueWithIdentifier:@"ShowLogin" sender:nil];
	}
    else {
        //NSLog(@"User logged in...");
    }
        // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void)viewDidAppear:(BOOL)animated {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *group = [defaults objectForKey:@"group"];
    if (group !=nil && [[defaults objectForKey:@"view"] integerValue]==0) {
        MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
        [self.navigationController.view addSubview:hud];
        hud.labelText = @"Loading...";
        
        [hud showAnimated:YES whileExecutingBlock:^{
            [self jsonLoadingData];
        } completionBlock:^{
            [hud removeFromSuperview];
            [hud release];
        }];
        [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"view"];
    }
    else {
        [self.tableView reloadData];
    }
}

-(void)getJSON {
    //NSLog(@"User logged in...");
    //NSLog(@"View loaded...");
    //NSLog(@"Attempting to connect to JSON feed...");
    //Connect to JSON
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *group = [defaults objectForKey:@"group"];
    NSString *jsonStr = [NSString stringWithFormat:@"http://api.stbreview.com/server.php?json=1&group=%@",group];
    NSLog(@"JSON URL: %@",jsonStr);
    NSURL *jsonURL = [NSURL URLWithString:jsonStr];
    NSOperationQueue *jsonQueue = [[[NSOperationQueue alloc] init] autorelease];
    NSURLRequest *jsonLoaded = [NSURLRequest requestWithURL:jsonURL];
    [NSURLConnection sendAsynchronousRequest:jsonLoaded queue:jsonQueue completionHandler:^(NSURLResponse *jsonResponse, NSData *jsonLoadingData, NSError *jsonLoadingError) {

    if(jsonLoadingData) {
        [self jsonLoadingData];
    }
    }];

}

-(void)jsonLoadingData {
    //NSLog(@"JSON loaded and ready to process...");
    //NSLog(@"Creating NSDictionary from JSON...");
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *group = [defaults objectForKey:@"group"];
    NSString *jsonStr = [NSString stringWithFormat:@"http://api.stbreview.com/server.php?json=1&group=%@",group];
    NSLog(@"JSON URL: %@",jsonStr);
    NSURL *jsonURL = [NSURL URLWithString:jsonStr];
    NSData *jsonData = [NSData dataWithContentsOfURL:jsonURL];
    NSError *jsonError = nil;
    if (jsonData) {
    NSDictionary *rootDict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&jsonError];
        if (rootDict) {
            //NSLog(@"Dictionary created, loading values from JSON...");
            // //NSLog(@"%@",rootDict);
            self.tableDataSource = [NSMutableArray array];
            for (NSString *key in rootDict.allKeys) {
                NSDictionary *subDict = [rootDict valueForKey:key];
                NSMutableDictionary *newDict = [NSMutableDictionary dictionary];
                [newDict setValue:subDict forKey:@"value"];
                [newDict setValue:key forKey:@"key"];
                [self.tableDataSource addObject:newDict];
                ////NSLog(@"New Dictionary =\n\n%@",newDict);
                //  [self.tableView reloadData];
            }
            //AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            //delegate.jsonSearchData = tableDataSource;
            //NSLog(@"Values successfully loaded...");
            //NSLog(@"Passing values to UITableView...");
            //NSLog(@"Counting rows...");
        }
        [self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
    }
    else {
        //NSLog(@"Error creating Array...");
        UIAlertView *alertViewArray = [[UIAlertView alloc] init];
        alertViewArray.title = @"Error!";
        alertViewArray.message = @"A server with the specified hostname could not be found.\n\nPlease check your connection and try again.";
        [alertViewArray addButtonWithTitle:@"Ok"];
        [alertViewArray performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:YES];
        [alertViewArray release];
    }
    
}
    - (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
//#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
        if (section == 0) {
           if (tableDataSource == nil) {
               return @"";
           }
           else {
               return nil;
           }
        }
        else {
            return nil;
        }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    NSInteger key = [[tableDataSource valueForKey:@"key"] count];
    return key;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"subjectCell";
    TDBadgedCell *cell = [[[TDBadgedCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
    NSMutableDictionary *object = [tableDataSource objectAtIndex:indexPath.row];
    NSString *key = [object valueForKey:@"key"];
    NSDictionary *value = [object valueForKey:@"value"];
    
    NSInteger count = value.allValues.count;
    cell.textLabel.text = key;
    //cell.detailTextLabel.text = [NSString stringWithFormat:@"%i",count];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:15];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    //cell.imageView.image = [UIImage imageNamed:@"folderIcon.png"];
    //CELL BADGE
    cell.badge.radius = 7;
    cell.badgeString = [NSString stringWithFormat:@"%i",count];
    cell.badgeColor = [UIColor colorWithRed:0.58039215686275 green:0.58039215686275 blue:0.58039215686275 alpha:1.000];
 
    ////NSLog(@"%@ cell returned...",key);
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath) {
    [self performSegueWithIdentifier:@"subjectDrillDown" sender:nil];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    //NSLog(@"Attempting to identify segue...");
    // Make sure we're referring to the correct segue
    if ([[segue identifier] isEqualToString:@"subjectDrillDown"]) {
        
        //NSLog(@"Segue has been identified...");
        // Get reference to the destination view controller
        SubjectDrillDownViewController *vc = [segue destinationViewController];
        
        // get the selected index
        NSInteger selectedIndex = [[self.tableView indexPathForSelectedRow] row];
        
        // Pass the name and index of our film
        
        
        NSMutableDictionary *object = [tableDataSource objectAtIndex:selectedIndex];
        NSString *key = [object valueForKey:@"key"];
        [vc setSelectedItem:key];
        //[vc setSelectedIndex:selectedIndex];
        
        //NSLog(@"Switching to %@ detail view...",key);
        //NSLog(@"Passing dictionary to %@ view... (Source below)\n\n %@",key,[NSString stringWithFormat:@"%@", [tableDataSource objectAtIndex:selectedIndex]]);
        [vc setDetailDataSourceDict:[tableDataSource objectAtIndex:selectedIndex]];
        
        //[self performSegueWithIdentifier:@"subjectDrillDown" sender:nil];
    }
    else {
        //NSLog(@"ERROR, DOUBLE CHECK SEGUE'S NAME!");
    }
}

@end
