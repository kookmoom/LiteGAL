//
//  LoadSaveFileTableViewController.h
//  LiteGAL
//
//  Created by Artuira on 13-12-2.
//  Copyright (c) 2013年 Artuira. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameViewController.h"

@interface LoadSaveFileTableViewController : UITableViewController<NSFetchedResultsControllerDelegate, SaveNewSaveFile>

- (void) initFetchedResultsController;

@end
