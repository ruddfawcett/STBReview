//
//  SubjectDrillDownViewController.m
//  STBReview
//
//  Created by Rudd Fawcett on 11/11/12.
//  Copyright (c) 2012 Rudd Fawcett. All rights reserved.
//

#import "SubjectDrillDownViewController.h"
#import "SheetDrillDownViewController.h"

@interface SubjectDrillDownViewController ()

@end

@implementation SubjectDrillDownViewController

@synthesize selectedItem, selectedIndex, detailDataSource, detailDataSourceDict;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewDidAppear:(BOOL)animated {
    [self.tableView reloadData];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = selectedItem;
    
    /* for (NSString *title in [detailDataSourceDict valueForKey:@"value"]) {
        NSMutableDictionary *newDict = [NSMutableDictionary dictionary];
        NSDictionary *subDict = [rootDict valueForKey:key];
        [newDict setValue:title forKey:@"sheetTitle"];
        [newDict setValue:author forKey:@"author"];
        [self.detailDataSource addObject:newDict];
    }
        //NSLog(@"Dictionary created, loading values from JSON...");

        //NSLog(@"Arrived at %@ view...",selectedItem);
        self.navigationItem.title = selectedItem;
    //NSLog(@"Confirming dictionary has been passed...");
    ////NSLog(@"Is this the dictionary for %@?\n%@",selectedItem,detailDataSourceDict);
    //NSLog(@"Is this the array for %@?\n%@",selectedItem,detailDataSource);
    ////NSLog(@"I think it is, let's make a table!"); */
    //}
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//#warning Incomplete method implementation.
    // Return the number of rows in the section.
    NSInteger value = [[self.detailDataSourceDict valueForKey:@"value"] count];
    return value;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"sheetCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    NSDictionary *dictionary = [self.detailDataSourceDict valueForKey:@"value"];
    NSArray *arrayFromDict = [dictionary allValues];
    //NSLog(@"Array: %@",arrayFromDict);
    
    NSMutableArray *object = [arrayFromDict objectAtIndex:indexPath.row];
    
    NSString *author = [object valueForKey:@"author"];
    NSString *title = [object valueForKey:@"title"];
    NSString *ext = [object valueForKey:@"ext"];
    NSString *png = @".png";
    NSString *sheetIconPath = [ext stringByAppendingString: png];
    if (![UIImage imageNamed:sheetIconPath]) {
        sheetIconPath = @"notFound.png";
    }
    //NSLog(@"%@",sheetIconPath);
    
    cell.textLabel.text = title;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"Uploaded by %@",author];
    cell.imageView.image = [UIImage imageNamed:sheetIconPath];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//    //NSLog(@"Author: %@",author);
    
  //  //NSLog(@"Sheet Title: %@\n",title);
    
    return cell;
}


#pragma mark - Table view delegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
   // if (indexPath) {
     //   [self performSegueWithIdentifier:@"sheetDrillDown" sender:nil];
    //}
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    //NSLog(@"Attempting to identify segue...");
    // Make sure we're referring to the correct segue
    if ([[segue identifier] isEqualToString:@"sheetDrillDown"]) {
        
        [segue.destinationViewController setHidesBottomBarWhenPushed:YES];
        
        //NSLog(@"Segue has been identified...");
        // Get reference to the destination view controller
        SheetDrillDownViewController *vc = [segue destinationViewController];
        
        // get the selected index
        NSInteger selectedIndex2 = [[self.tableView indexPathForSelectedRow] row];
        
        NSDictionary *dictionary = [detailDataSourceDict valueForKey:@"value"];
        NSArray *arrayFromDict = [dictionary allValues];
        
        
        NSMutableArray *object = [arrayFromDict objectAtIndex:selectedIndex2];
        
        //NSString *author = [object valueForKey:@"author"];
        NSString *titleSheet = [object valueForKey:@"title"];
        //NSString *ext = [object valueForKey:@"ext"];
        [vc setSelectedItem:titleSheet];
        //[vc setSelectedIndex:selectedIndex];
        
        //NSLog(@"Switching to %@ detail view...",titleSheet);
        //NSLog(@"Passing dictionary to %@ view... (Source below)\n\n %@",titleSheet,[NSString stringWithFormat:@"%@", [arrayFromDict objectAtIndex:selectedIndex2]]);
        [vc setDetailDataSourceDict:[arrayFromDict objectAtIndex:selectedIndex2]];
        
        //[self performSegueWithIdentifier:@"subjectDrillDown" sender:nil];
    }
    else {
    //NSLog(@"ERROR, DOUBLE CHECK SEGUE'S NAME!");
    }
}

@end
