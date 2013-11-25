//
//  BranchPopoverTableViewController.h
//  LiteGAL
//
//  Created by Artuira on 13-11-24.
//  Copyright (c) 2013年 Artuira. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PopDataDelegate <NSObject>

@required

- (NSArray*) getOptionsFormBranchController;

@optional

- (void) updateGameViewAtBranch:(NSInteger)row;

@end

@interface BranchOptionsTableViewController : UITableViewController

@property (weak, nonatomic) id <PopDataDelegate> branchDelegate;

@end
