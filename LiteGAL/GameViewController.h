//
//  GameViewController.h
//  LiteGAL
//
//  Created by Artuira on 13-11-21.
//  Copyright (c) 2013年 Artuira. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LiteGALScreen.h"
#import "BranchOptionsTableViewController.h"


#define INIT_SCREEN_ROW 0;

@protocol ScreenDataSourceDelegate <NSObject>

@required

- (LiteGALScreen*) getScreenFromDelegate;

@end


@interface GameViewController : UIViewController

@property (weak, nonatomic) id <ScreenDataSourceDelegate> screenFactoryDelegate;


- (void) updateBySaveData:(NSString *)name atScreenIndex:(NSInteger)screen andTextIndex:(NSInteger)text;



@end
