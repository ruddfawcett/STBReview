//
//  DownloadsViewController.m
//  STBReview
//
//  Created by Rudd Fawcett on 11/17/12.
//  Copyright (c) 2012 Rudd Fawcett. All rights reserved.
//

#import "DownloadsViewController.h"

@interface DownloadsViewController ()

@end

@implementation DownloadsViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void)viewDidAppear:(BOOL)animated {
    
    /* NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSArray *filePathsArray = [[NSFileManager defaultManager] subpathsOfDirectoryAtPath:documentsDirectory  error:nil];
    
    //NSLog(@"files array %@", filePathsArray); */
    
    [self.tableView reloadData];
     
    //NSString *filePath = [documentsDirectory stringByAppendingPathComponent:[filePathsArray objectAtIndex:0]];
    
    ////NSLog(@"Files: %@",filePath);
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSArray *filePathsArray = [[NSFileManager defaultManager] subpathsOfDirectoryAtPath:documentsDirectory  error:nil];
    ////NSLog(@"files array %@", filePathsArray);
    NSMutableArray *finalArray = [(NSArray*)filePathsArray mutableCopy];
    if ([finalArray count] == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert!"
                                                           message:@"You have not downloaded any sheets.\n\nYou can download a sheet from its detail page."
                                                          delegate:nil
                                                 cancelButtonTitle:@"Ok"
                                                 otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
    [finalArray release];
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
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSArray *filePathsArray = [[NSFileManager defaultManager] subpathsOfDirectoryAtPath:documentsDirectory  error:nil];
    ////NSLog(@"files array %@", filePathsArray);
    NSMutableArray *finalArray = [(NSArray*)filePathsArray mutableCopy];

    //NSUInteger index = [finalArray indexOfObject:@".DS_Store"];
    //[finalArray removeObjectAtIndex: index];
    ////NSLog(@"files array %@", finalArray);
    return [finalArray count];
    [finalArray release];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSArray *filePathsArray = [[NSFileManager defaultManager] subpathsOfDirectoryAtPath:documentsDirectory  error:nil];
    NSMutableArray *finalArray = [(NSArray*)filePathsArray mutableCopy];
    NSFileManager *fm = [NSFileManager defaultManager];
    NSArray *files = [fm contentsOfDirectoryAtPath:documentsDirectory error:nil];
    NSString *fileFirst = [files objectAtIndex:0];
    NSString *fullPath = [NSString stringWithFormat:@"%@/%@", documentsDirectory, fileFirst];
    /* NSUInteger index = [finalArray indexOfObject:@".DS_Store"];
    [finalArray removeObjectAtIndex: index]; */
    //NSLog(@"files array %@", finalArray);
    NSString *title = [[[finalArray objectAtIndex:indexPath.row] lastPathComponent]stringByDeletingPathExtension];
    NSString *image = [[[finalArray objectAtIndex:indexPath.row] lastPathComponent]uppercaseString];
    NSString *newimage = [[image pathExtension]stringByAppendingPathExtension:@"png"];
    NSLog(@"%@",newimage);
    
    if (![UIImage imageNamed:newimage]) {
        newimage = @"notFound.png";
    }
    
    NSDictionary *fileAttribs = [[NSFileManager defaultManager] attributesOfItemAtPath:fullPath error:nil];
    ////NSLog(@"Here: %@",fileAttribs);
    //long long fileSize = [fileAttribs fileSize];
    
    NSDate *result = [fileAttribs valueForKey:NSFileCreationDate]; //or NSFileModificationDate
	NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init]  autorelease];
	[dateFormatter setDateStyle:NSDateFormatterLongStyle];
	NSString *dateString = [dateFormatter stringFromDate:result];	
	[dateFormatter setDateStyle:NSDateFormatterNoStyle];

    cell.textLabel.text = title;
    cell.imageView.image = [UIImage imageNamed:newimage];
    //cell.detailTextLabel.text = [NSString stringWithFormat:@"File extenstion: %@",[[image pathExtension]uppercaseString]];
    cell.detailTextLabel.text = dateString;
    cell.detailTextLabel.font = [UIFont systemFontOfSize:15];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
         NSString *documentsDirectory = [paths objectAtIndex:0];    
         NSArray *filePathsArray = [[NSFileManager defaultManager] subpathsOfDirectoryAtPath:documentsDirectory  error:nil];
        NSMutableArray *finalArray = [(NSArray*)filePathsArray mutableCopy];
        NSString *fileToDelete = [finalArray objectAtIndex: indexPath.row];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        [fileManager removeItemAtPath:[documentsDirectory stringByAppendingPathComponent:fileToDelete] error:nil];
        [finalArray removeObjectAtIndex: indexPath.row];
        ////NSLog (@"Final Array: %@",finalArray);
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [tableView reloadData];
        if ([finalArray count] == 0) {
            [[[UIAlertView alloc] initWithTitle:@"Alert!"
                                        message:@"You have not downloaded any sheets.\n\nYou can download a sheet from its detail page."
                                       delegate:nil
                              cancelButtonTitle:@"Ok"
                              otherButtonTitles: nil] show];
        }
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	// When user taps a row, create the preview controller
	QLPreviewController *previewer = [[[QLPreviewController alloc] init] autorelease];
    
	// Set data source
	[previewer setDataSource:self];
    
    // Which item to preview
	[previewer setCurrentPreviewItemIndex:indexPath.row];
    
    [previewer setHidesBottomBarWhenPushed:YES];
    
	// Push new viewcontroller, previewing the document
	[[self navigationController] pushViewController:previewer animated:YES];
}

#pragma mark -
#pragma mark Preview Controller

/*---------------------------------------------------------------------------
 *
 *--------------------------------------------------------------------------*/
- (NSInteger) numberOfPreviewItemsInPreviewController: (QLPreviewController *) controller
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSArray *filePathsArray = [[NSFileManager defaultManager] subpathsOfDirectoryAtPath:documentsDirectory  error:nil];
    NSMutableArray *finalArray = [(NSArray*)filePathsArray mutableCopy];
	return [finalArray count];
}

/*---------------------------------------------------------------------------
 *
 *--------------------------------------------------------------------------*/
- (id <QLPreviewItem>)previewController: (QLPreviewController *)controller previewItemAtIndex:(NSInteger)index
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSArray *filePathsArray = [[NSFileManager defaultManager] subpathsOfDirectoryAtPath:documentsDirectory  error:nil];
    //NSMutableArray *finalArray = [(NSArray*)filePathsArray mutableCopy];
	// Break the path into it's components (filename and extension)
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:[filePathsArray objectAtIndex:index]];
    
	//NSArray *fileComponents = [[finalArray objectAtIndex: index] componentsSeparatedByString:@"."];
    
	// Use the filename (index 0) and the extension (index 1) to get path
    //NSString *path = [[NSBundle mainBundle] pathForResource:[fileComponents objectAtIndex:0] ofType:[fileComponents objectAtIndex:1]];
    
	return [NSURL fileURLWithPath:filePath];
}

#pragma mark -
#pragma mark Cleanup

/*---------------------------------------------------------------------------
 *
 *--------------------------------------------------------------------------*/
- (void)dealloc
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSArray *filePathsArray = [[NSFileManager defaultManager] subpathsOfDirectoryAtPath:documentsDirectory  error:nil];
    NSMutableArray *finalArray = [(NSArray*)filePathsArray mutableCopy];
	// Free up all the documents
	[finalArray release];
    
	[super dealloc];
}

@end
