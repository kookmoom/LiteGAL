//
//  BranchController.h
//  LiteGAL
//
//  Created by Artuira on 13-11-24.
//  Copyright (c) 2013年 Artuira. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BranchOptionsTableViewController.h"
#import "GameViewController.h"

#import "ScreenFactory.h"

@interface BranchController : NSObject<PopDataDelegate>

- (id)initWithBranchName:(NSString*)name;
- (void) updateGameViewControllerBySaveData:(NSString *)name atScreenIndex:(NSInteger)screen andTextIndex:(NSInteger)text;

- (ScreenFactory*) getCurrentScreenFactory;

- (NSString*) getCurrentBranchName;
- (NSInteger) getCurrentScreenRow;
@end
