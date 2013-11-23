//
//  ScreenFactory.m
//  LiteGAL
//
//  Created by Artuira on 13-11-22.
//  Copyright (c) 2013年 Artuira. All rights reserved.
//

#import "ScreenFactory.h"

@interface ScreenFactory () <ScreenDataSourceDelegate>

@property (weak, nonatomic) GameViewController *gameViewController;

@property (strong, nonatomic) NSArray *screens;

@property NSInteger row;

@property (strong, nonatomic) LiteGALScreen* currentScreen;
@property (strong, nonatomic) LiteGALScreen* delayScreen;

@end

@implementation ScreenFactory

#pragma mark - init Methods

- (id)initWithScreens:(NSArray *)screens
{
    self = [super init];
        if (self)
        {
            self.screens = screens;
            self.row = 0;
            [self loadFirstScreen];
        }
    
            return self;
    
}

#pragma mark - Load screen Automatically

- (NSData*) loadPictureAtScreen:(NSDictionary*)screenDict
{
    
    NSString *picture = [screenDict valueForKey:@"Picture"];
    NSURL *tempURL = [[NSBundle mainBundle] URLForResource:picture withExtension:@"png"];
    
    return [[NSData alloc]initWithContentsOfURL:tempURL];

}

- (NSArray*) loadTextAtScreen:(NSDictionary*)screenDict
{
    NSString *text = [screenDict valueForKey:@"text"];
    NSURL *tempURL = [[NSBundle mainBundle]URLForResource:text withExtension:@"plist"];
    
    tempURL = [[NSBundle mainBundle] URLForResource:@"testtext" withExtension:@"plist"];//test
    
    return [NSArray arrayWithContentsOfURL:tempURL];
}

- (LiteGALScreen*) loadingScreenByEfficientWayAtIndex:(NSInteger)row
{
    __block LiteGALScreen * liteGALScreen = [[LiteGALScreen alloc]init];
    
    NSDictionary *screen = [self.screens objectAtIndex:row];
    
    
    dispatch_queue_t queque = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_async(queque, ^{
        dispatch_group_t group = dispatch_group_create();
        
        dispatch_group_async(group, queque, ^{
            liteGALScreen.picture = [self loadPictureAtScreen:screen];
        });
        
        dispatch_group_async(group, queque, ^{
            liteGALScreen.textArray = [self loadTextAtScreen:screen];
        });
    });
    
    return liteGALScreen;
}

- (LiteGALScreen*) loadingScreenByCurrentWayAtIndex:(NSInteger)row
{
    LiteGALScreen * liteGALScreen = [[LiteGALScreen alloc]init];
    
    NSDictionary *screen = [self.screens objectAtIndex:row];
    
    liteGALScreen.picture = [self loadPictureAtScreen:screen];
    liteGALScreen.textArray = [self loadTextAtScreen:screen];
    
    return liteGALScreen;
}

- (LiteGALScreen*) loadingScreenByEfficientlyWay
{
    dispatch_queue_t queque = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    if (self.row < [self.screens count]) {
        dispatch_async(queque, ^{
            
            [NSThread sleepForTimeInterval:1];
            self.currentScreen = nil;
            self.currentScreen = self.delayScreen;
            
            self.delayScreen = [self loadingScreenByEfficientWayAtIndex:self.row];
            
            self.row++;
            
        });

    }
    
    else if (self.row == [self.screens count])
    {
            self.currentScreen = nil;
            self.currentScreen = self.delayScreen;
        
            self.row++;
    }
    
    else
    {
            self.delayScreen = nil;
    }
    

    return self.delayScreen;
}

- (LiteGALScreen*) loadFirstScreen
{
    if (self.delayScreen == nil)
        self.delayScreen = [self loadingScreenByCurrentWayAtIndex:self.row];
    
    self.row++;
    
    return self.delayScreen;
}

#pragma mark - GameViewControllerDelegate

- (LiteGALScreen*) getScreenFromDelegate
{
    return [self loadingScreenByEfficientlyWay];
}

@end
