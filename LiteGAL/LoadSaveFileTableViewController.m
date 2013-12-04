//
//  LoadSaveFileTableViewController.m
//  LiteGAL
//
//  Created by Artuira on 13-12-2.
//  Copyright (c) 2013年 Artuira. All rights reserved.
//
 
#import "LoadSaveFileTableViewController.h"
#import "LiteGALAppDelegate.h"
#import "SaveFile.h"
#import "UserDefaultsKey.h"

@interface LoadSaveFileTableViewController ()

@property (strong, nonatomic, readonly) NSFetchedResultsController* fetchedResultController;

@end

@implementation LoadSaveFileTableViewController

@synthesize fetchedResultController = _fetchedResultsController;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
       
    }
    return self;
}

- (void) initFetchedResultsController
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]init];
    
    
    LiteGALAppDelegate *appDelegate = (LiteGALAppDelegate*)[[UIApplication sharedApplication]delegate];
    
    NSManagedObjectContext *managedObjectContext = [appDelegate managedObjectContext];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"SaveFile" inManagedObjectContext:managedObjectContext];
    
    [fetchRequest setEntity:entity];
    [fetchRequest setFetchBatchSize:20];
    
    NSSortDescriptor *sortDescriptor= [[NSSortDescriptor alloc]initWithKey:@"saveTime" ascending:YES];
    
    
    NSArray *sortDescriptors = [[NSArray alloc]initWithObjects:sortDescriptor, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    NSString *sectionKey = nil;
    sectionKey = @"saveTime";
    
    _fetchedResultsController = [[NSFetchedResultsController alloc]initWithFetchRequest:fetchRequest managedObjectContext:managedObjectContext sectionNameKeyPath:sectionKey cacheName:@"SaveTime"];
    
    _fetchedResultsController.delegate = self;
}

- (NSFetchedResultsController*) fetchedResultController
{
    if ( _fetchedResultsController!= nil) {
        return _fetchedResultsController;
    }
    
    [self initFetchedResultsController];
    
    return _fetchedResultsController;

}
- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
     self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.navigationController.title = @"Loading";

    NSError *error;

    
    if (![self.fetchedResultController performFetch:&error]) {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:NSLocalizedString(@"Error loding", @"Error loding")
                              message:[NSString stringWithFormat:NSLocalizedString(@"Error was:%@ quitting.",@"Error was : %@,quitting.") ,[error localizedDescription] ]delegate:self cancelButtonTitle:NSLocalizedString(@"aw , Nuts", @"aw ,Nuts") otherButtonTitles:nil];
        
        [alert show];
        
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
    return [[self.fetchedResultController sections]count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id <NSFetchedResultsSectionInfo> info = [[self.fetchedResultController sections] objectAtIndex:section];
    
    return [info numberOfObjects];}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"SaveFileCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    SaveFile *saveFile = [self.fetchedResultController objectAtIndexPath:indexPath];
    
    NSDateFormatter* formater = [[NSDateFormatter alloc]init];
    [formater setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    cell.textLabel.text = [formater stringFromDate:saveFile.saveTime];
    cell.detailTextLabel.text = saveFile.branch;
    
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SaveFile *saveFile = [self.fetchedResultController objectAtIndexPath:indexPath];
    
    NSUserDefaults* userDefault = [NSUserDefaults standardUserDefaults];
    
    NSString *branch = [NSString stringWithString:saveFile.branch];
    NSNumber *screen = saveFile.screen;
    NSNumber *textRow = saveFile.textRow;
    
    [userDefault setObject:branch forKey:kBranchForLoading];
    [userDefault setObject:screen forKey:kScreenRowForLoading];
    [userDefault setObject:textRow forKey:kTextRowForLoading];
    
    NSString *updateState = kDidLoad;
    
    [userDefault setObject:updateState forKey:kUpdateGameViewBySaveFile];
    
}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSManagedObjectContext *context = [self.fetchedResultController managedObjectContext];
        [context deleteObject:[self.fetchedResultController objectAtIndexPath:indexPath]];
        
        NSError *error = nil;
        if (![context save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
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

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

#pragma mark - FetchedResultsControllerDelegate

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    UITableView *tableView = self.tableView;
    
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView endUpdates];
}

#pragma mark - GameViewControllerDelegate

- (void)saveFile:(NSString *)branch atScreen:(NSInteger)screen withTextIndex:(NSInteger)text
{
    NSManagedObjectContext *managedObjectContext = [self.fetchedResultController managedObjectContext];
    NSEntityDescription *entityDescription = [[self.fetchedResultController fetchRequest]entity];
    
    SaveFile *newSaveFile = [NSEntityDescription insertNewObjectForEntityForName:[entityDescription name] inManagedObjectContext:managedObjectContext];
    
    newSaveFile.saveTime = [NSDate date];
    newSaveFile.branch = branch;
    newSaveFile.screen = [[NSNumber alloc]initWithInt:screen];
    newSaveFile.textRow = [[NSNumber alloc]initWithInt:text];
    
    NSError * error;
    if (![managedObjectContext save:&error]) {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:NSLocalizedString(@"Error save", @"Error save")
                              message:[NSString stringWithFormat:NSLocalizedString(@"Error was:%@ quitting.",@"Error was : %@,quitting.") ,[error localizedDescription] ]delegate:self cancelButtonTitle:NSLocalizedString(@"aw , Nuts", @"aw ,Nuts") otherButtonTitles:nil];
        
        [alert show];
    }

}

@end
