//
//  LiteGALTabBarViewController.m
//  LiteGAL
//
//  Created by Artuira on 13-11-21.
//  Copyright (c) 2013年 Artuira. All rights reserved.
//

#import "LiteGALTabBarViewController.h"
#import "ScreenFactory.h"
#import "GameViewController.h"

@interface LiteGALTabBarViewController ()

@property (strong, nonatomic) ScreenFactory* testScreenFactory;

@end

@implementation LiteGALTabBarViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) testScreenFactoryAtTabBarController
{
    NSURL *plistURL = [[NSBundle mainBundle] URLForResource:@"1" withExtension:@"plist"];
    NSDictionary *Branch = [NSDictionary dictionaryWithContentsOfURL:plistURL];
    
    NSArray *screens = [Branch valueForKey:@"Screens"];
    
    self.testScreenFactory = [[ScreenFactory alloc]initWithScreens:screens];
    
    GameViewController* testGameViewController = [self.viewControllers objectAtIndex:0];
    
    testGameViewController.delegate = self.testScreenFactory;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	[self testScreenFactoryAtTabBarController];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
