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

@protocol SaveNewSaveFile <NSObject>

@required

- (void) saveFile:(NSString*)branch atScreen:(NSInteger)screen  withTextIndex:(NSInteger)text;

@end



@interface GameViewController : UIViewController

@property (weak, nonatomic) id <ScreenDataSourceDelegate> screenFactoryDelegate;
@property (weak, nonatomic) id <SaveNewSaveFile> saveDataDelegate;

- (void) updateBySaveData:(NSString *)name atScreenIndex:(NSInteger)screen andTextIndex:(NSInteger)text;



@end
