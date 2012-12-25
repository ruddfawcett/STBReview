//
//  SearchViewController.m
//  STBReview
//
//  Created by Rudd Fawcett on 11/3/12.
//  Copyright (c) 2012 Rudd Fawcett. All rights reserved.
//

#import "SearchViewController.h"
#import "API.h"
#import "MBProgressHUD.h"
#import "SheetDrillDownViewController.h"
//#import "AppDelegate.h"

@interface SearchViewController(private)
-(void)viewDidAppear:(BOOL)animated;
-(void)viewDidLoad;
-(void)getJSON;
@end

@implementation SearchViewController
{
    NSArray *searchResults;
}

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
        [self performSegueWithIdentifier:@"showLogin" sender:nil];
	}];
    NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
    [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:appDomain];
    [tableDataSource removeAllObjects];
    [self.tableView reloadData];
}

-(IBAction)refresh:(UIButton*)sender {
    //NSLog(@"\n\nRefreshing View...\n\n");
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
	[self.navigationController.view addSubview:hud];
	hud.labelText = @"Loading...";
	
	[hud showAnimated:YES whileExecutingBlock:^{
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        [self.tableView reloadData];
	} completionBlock:^{
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
		[hud removeFromSuperview];
		[hud release];
    }];
}

- (void)viewDidLoad
{
    //NSLog(@"Checking to see if user logged in...");
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
}

-(void)viewDidAppear:(BOOL)animated {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *group = [defaults objectForKey:@"group"];
    if (group !=nil && [[defaults objectForKey:@"view2"] integerValue]==0) {
        MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
        [self.navigationController.view addSubview:hud];
        hud.labelText = @"Loading...";
        
        [hud showAnimated:YES whileExecutingBlock:^{
            [self jsonLoadingData];
        } completionBlock:^{
            [hud removeFromSuperview];
            [hud release];
        }];
        [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"view2"];
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
    NSLog(@"Group: %@",group);
    NSString *jsonStr = [NSString stringWithFormat:@"http://api.stbreview.com/sheets.php?json=1&group=%@",group];
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
    NSLog(@"Group: %@",group);
    NSString *jsonStr = [NSString stringWithFormat:@"http://api.stbreview.com/sheets.php?json=1&group=%@",group];
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

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    NSPredicate *resultPredicate = [NSPredicate
                                    predicateWithFormat:@"SELF contains[cd] %@",
                                    searchText];
    //NSArray *tableDataSourceArray = [[[NSArray alloc] initWithArray:tableDataSource] valueForKey:@"key"];
    searchResults = [[[tableDataSource valueForKey:@"key"] filteredArrayUsingPredicate:resultPredicate] retain];
    //NSLog(@"Results from query \"%@\": %@",searchText,searchResults);
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForSearchText:searchString
                               scope:[[self.searchDisplayController.searchBar scopeButtonTitles]
                                      objectAtIndex:[self.searchDisplayController.searchBar
                                                     selectedScopeButtonIndex]]];
    
    return YES;
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
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return [searchResults count];
        //NSLog(@"Count of rows: %u",[searchResults count]);
    } else {
        NSInteger key = [[tableDataSource valueForKey:@"key"] count];
        return key;    
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle  reuseIdentifier:CellIdentifier];
    }
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        cell.textLabel.text = [searchResults objectAtIndex:indexPath.row];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    else {
    NSMutableArray *object = [self.tableDataSource objectAtIndex:indexPath.row];
    NSMutableArray *values = [object valueForKey:@"value"];
    NSString *author = [values valueForKey:@"author"];
    NSString *title = [values valueForKey:@"title"];
    NSString *ext = [values valueForKey:@"ext"];
    NSString *png = @".png";
    NSString *sheetIconPath = [ext stringByAppendingString: png];
    if (![UIImage imageNamed:sheetIconPath]) {
        sheetIconPath = @"notFound.png";
    }
    cell.textLabel.text = title;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"Uploaded by %@",author];
    cell.imageView.image = [UIImage imageNamed:sheetIconPath];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    ////NSLog(@"%@ cell returned...",key);
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        [self performSegueWithIdentifier: @"sheetDrillDown" sender: self];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    //NSLog(@"Attempting to identify segue...");
    // Make sure we're referring to the correct segue
    if ([[segue identifier] isEqualToString:@"sheetDrillDown"]) {
        [segue.destinationViewController setHidesBottomBarWhenPushed:YES];
        NSIndexPath *indexPath = nil;
        SheetDrillDownViewController *vc = [segue destinationViewController];
        if ([self.searchDisplayController isActive]) {
        indexPath = [self.searchDisplayController.searchResultsTableView indexPathForSelectedRow];
        NSString *title = [searchResults objectAtIndex:indexPath.row];
        //NSInteger selectedIndex = [[self.tableView indexPathForSelectedRow] row];
        NSInteger index = [[tableDataSource valueForKey:@"key"]indexOfObject:title];
        //NSLog(@"index: %d",index);
        //NSIndexPath *path = [NSIndexPath indexPathWithIndex:index];
        NSMutableDictionary *object = [tableDataSource objectAtIndex:index];
        NSString *key = [object valueForKey:@"key"];
        [vc setSelectedItem:key];
        //[vc setSelectedIndex:selectedIndex];
        
        //NSLog(@"Switching to %@ detail view...",key);
        //NSLog(@"Passing dictionary to %@ view... (Source below)\n\n %@",key,[NSString stringWithFormat:@"%@", [tableDataSource objectAtIndex:selectedIndex]]);
        [vc setDetailDataSourceDict:[[tableDataSource objectAtIndex:index] valueForKey:@"value"]];
            
        //[self performSegueWithIdentifier:@"subjectDrillDown" sender:nil];
        }
        else {
        //NSLog(@"Segue has been identified...");
        // Get reference to the destination view controller
        SheetDrillDownViewController *vc = [segue destinationViewController];
        
        // get the selected index
        NSInteger selectedIndex = [[self.tableView indexPathForSelectedRow] row];
        
        // Pass the name and index of our film
        
        
        NSMutableDictionary *object = [tableDataSource objectAtIndex:selectedIndex];
        NSString *key = [object valueForKey:@"key"];
        [vc setSelectedItem:key];
        //[vc setSelectedIndex:selectedIndex];
        
        //NSLog(@"Switching to %@ detail view...",key);
        //NSLog(@"Passing dictionary to %@ view... (Source below)\n\n %@",key,[NSString stringWithFormat:@"%@", [tableDataSource objectAtIndex:selectedIndex]]);
        [vc setDetailDataSourceDict:[[tableDataSource objectAtIndex:selectedIndex] valueForKey:@"value"]];
        
        //[self performSegueWithIdentifier:@"subjectDrillDown" sender:nil];
        }
    }
    else {
        //NSLog(@"ERROR, DOUBLE CHECK SEGUE'S NAME!");
    }
}

-(void)dealloc
{
    [searchResults dealloc];
    [super dealloc];
}

@end
