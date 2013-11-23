//
//  GameViewController.h
//  LiteGAL
//
//  Created by Artuira on 13-11-21.
//  Copyright (c) 2013年 Artuira. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LiteGALScreen.h"

@protocol ScreenDataSourceDelegate <NSObject>

@required

- (LiteGALScreen*) getScreenFromDelegate;

@end


@interface GameViewController : UIViewController

@property (weak, nonatomic) id <ScreenDataSourceDelegate> delegate;

@end
