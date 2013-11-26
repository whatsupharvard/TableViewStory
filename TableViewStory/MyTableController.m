//
//  MyTableController.m
//  ParseStarterProject
//
//  Created by James Yu on 12/29/11.
//

#import "MyTableController.h"
#import "EventCell.h"
#import "EventDetailViewController.h"
#import "EventDetailModel.h"
UIImage *tempimage;

@interface MyTableController() <UISearchDisplayDelegate, UISearchBarDelegate> {
    
}

@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) UISearchDisplayController *searchController;
@property (nonatomic, strong) NSMutableArray *searchResults;

@end


@interface MyTableController ()

@end

@implementation MyTableController

- (id)initWithCoder:(NSCoder *)aCoder
{
    self = [super initWithCoder:aCoder];
    
    if (self) {

        // Custom the table
        
        // The className to query on
        self.parseClassName = @"Events";
        
        // The key of the PFObject to display in the label of the default cell style
        self.textKey = @"name";
        
        // The title for this table in the Navigation Controller.
        self.title = @"Trending";
        
        // Whether the built-in pull-to-refresh is enabled
        self.pullToRefreshEnabled = YES;
        
        // Whether the built-in pagination is enabled
        self.paginationEnabled = YES;
        
        // The number of objects to show per page
        //self.objectsPerPage = 10;
    }
    return self;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    
    self.tableView.tableHeaderView = self.searchBar;
    
    self.searchController = [[UISearchDisplayController alloc] initWithSearchBar:self.searchBar contentsController:self];
    
    self.searchController.searchResultsDataSource = self;
    self.searchController.searchResultsDelegate = self;
    self.searchController.delegate = self;
    
    
    CGPoint offset = CGPointMake(0, self.searchBar.frame.size.height);
    self.tableView.contentOffset = offset;
    
    self.searchResults = [NSMutableArray array];
    
    //Uncomment the following line to preserve selection between presentations.
    //self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - Parse

- (void)objectsDidLoad:(NSError *)error {
    [super objectsDidLoad:error];
    
    // This method is called every time objects are loaded from Parse via the PFQuery
}

- (void)objectsWillLoad {
    [super objectsWillLoad];
    
    // This method is called before a PFQuery is fired to get more objects
}


 // Override to customize what kind of query to perform on the class. The default is to query for
 // all objects ordered by createdAt descending.
- (PFQuery *)queryForTable {
    PFQuery *query = [PFQuery queryWithClassName:self.parseClassName];
 
    // If no objects are loaded in memory, we look to the cache first to fill the table
    // and then subsequently do a query against the network.
    if ([self.objects count] == 0) {
        query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    }
 
    [query orderByAscending:@"priority"];
 
    return query;
}



 // Override to customize the look of a cell representing an object. The default is to display
 // a UITableViewCellStyleDefault style cell with the label being the first key in the object. 
/*- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object {
 static NSString *CellIdentifier = @"EventCell";
 
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
 
    // Configure the cell
    cell.textLabel.text = [object objectForKey:@"name"];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"Location: %@", [object objectForKey:@"location"]];
    PFFile *userImageFile = object[@"image"];
    [userImageFile getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
            UIImage *image = [UIImage imageWithData:imageData];
        cell.imageView.image = image;
        cell.imageView.frame = CGRectMake(0,0,0,0);
        cell.imageView.hidden = YES;
        
    }];

    return cell;
}
*/

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object {
    static NSString *CellIdentifier = @"EventCell";

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }

    
    if (tableView != self.searchDisplayController.searchResultsTableView) {
        cell.textLabel.text = [object objectForKey:@"name"];
        cell.detailTextLabel.text = [object objectForKey:@"location"];
        
        PFFile *userImageFile = object[@"image"];
        [userImageFile getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
            UIImage *image = [UIImage imageWithData:imageData];
            cell.imageView.image = image;
            //cell.imageView.frame = CGRectMake(20,20,20,20);
            cell.imageView.hidden = NO;
            
        }];
    }
    if ([tableView isEqual:self.searchDisplayController.searchResultsTableView]) {
        
        PFUser *obj2 = [self.searchResults objectAtIndex:indexPath.row];
        cell.textLabel.text = [obj2 objectForKey:@"name"];
        cell.detailTextLabel.text = [object objectForKey:@"location"];

    }
    return cell;
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"ShowEventDetails"])
    {
        NSIndexPath *selectedRowIndexPath = [self.tableView indexPathForSelectedRow];
        UITableViewCell *selectedCell = [self.tableView cellForRowAtIndexPath:selectedRowIndexPath];

        EventDetailViewController *detailViewController =[segue destinationViewController];
        
        detailViewController.EventDetailModel = @[selectedCell.textLabel.text, selectedCell.detailTextLabel.text, @"time", selectedCell.imageView.image];
    
           /*
        PFQuery *query = [PFQuery queryWithClassName:@"Events"];
        [query whereKey:@"name" equalTo:selectedCell.textLabel.text];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            
            if (!error) {
                // The find succeeded.
                NSLog(@"Successfully retrieved %d scores.", objects.count);
                
                // Do something with the found objects
                for (PFObject *object in objects) {
                    
                    PFFile *userImageFile = object[@"image"];
                    [userImageFile getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
                        if (!error) {
                            UIImage *image = [UIImage imageWithData:imageData];
                            [image setAccessibilityIdentifier:@"image.jpg"] ;
                            tempimage = image;
                            
                            //self.tableView.backgroundView = [[UIImageView alloc] initWithImage:image];
                            NSLog(@"%@", image.accessibilityIdentifier);
                        }
                    }];

                    
                }
                
                
            } else {
                // Log details of the failure
                NSLog(@"Error: %@ %@", error, [error userInfo]);
            }
        }];
         
        */
        if ([self.searchDisplayController isActive]) {
            NSLog(@"searched");
            //selectedRowIndexPath = [self.searchDisplayController.searchResultsTableView indexPathForSelectedRow];
            //selectedCell = [self.searchDisplayController.searchResultsTableView cellForRowAtIndexPath:selectedRowIndexPath];
            //detailViewController.EventDetailModel = @[selectedCell.textLabel.text, selectedCell.detailTextLabel.text, selectedCell.imageView.image];
        }
            
            //[searchResults objectAtIndex:myIndexPath.row];
            
    }
    
}


-(void)filterResults:(NSString *)searchTerm {
    
    [self.searchResults removeAllObjects];
    
    PFQuery *query = [PFQuery queryWithClassName: self.parseClassName];
    //[query whereKeyExists:@"name"];  //this is based on whatever query you are trying to accomplish
    [query whereKey:@"namelower" containsString:searchTerm];
    
    NSArray *results  = [query findObjects];
    
    //NSLog(@"%@", results);
    //NSLog(@"%u", results.count);
    
    [self.searchResults addObjectsFromArray:results];
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
    [self filterResults:searchString];
    return YES;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (tableView == self.tableView) {
        //if (tableView == self.searchDisplayController.searchResultsTableView) {
        
        return self.objects.count;
        
    } else {
        
        return self.searchResults.count;
        
    }
    
}
/*
 // Override if you need to change the ordering of objects in the table.
 - (PFObject *)objectAtIndex:(NSIndexPath *)indexPath { 
 return [objects objectAtIndex:indexPath.row];
 }
 */

/*
 // Override to customize the look of the cell that allows the user to load the next page of objects.
 // The default implementation is a UITableViewCellStyleDefault cell with simple labels.
 - (UITableViewCell *)tableView:(UITableView *)tableView cellForNextPageAtIndexPath:(NSIndexPath *)indexPath {
 static NSString *CellIdentifier = @"NextPage";
 
 UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
 
 if (cell == nil) {
 cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
 }
 
 cell.selectionStyle = UITableViewCellSelectionStyleNone;
 cell.textLabel.text = @"Load more...";
 
 return cell;
 }
 */

#pragma mark - Table view data source

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }   
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }   
 }
 */

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
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    
        if (tableView == self.searchDisplayController.searchResultsTableView) {
            NSLog(@"Search1");
            [self performSegueWithIdentifier: @"ShowEventDetails" sender: self];
            NSLog(@"Search2");
        }
    
    
    // load next view and set title:

}


@end
