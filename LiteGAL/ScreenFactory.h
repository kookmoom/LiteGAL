//
//  ScreenFactory.h
//  LiteGAL
//
//  Created by Artuira on 13-11-22.
//  Copyright (c) 2013年 Artuira. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GameViewController.h"

@interface ScreenFactory : NSObject <ScreenDataSourceDelegate >

- (id)initWithScreens:(NSArray *)screens;

- (id)initWithScreens:(NSArray *)screens AtIndex:(NSInteger)row;

@end
