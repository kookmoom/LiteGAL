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
#import "BranchController.h"
#import "GameNavigationViewController.h"
#import "BranchOptionsTableViewController.h"

@interface LiteGALTabBarViewController ()

@property (strong, nonatomic) ScreenFactory* testScreenFactory;
@property (strong, nonatomic) BranchController *testBanchController;



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
    
    UINavigationController* testController = [self.viewControllers objectAtIndex:0];
    
    GameViewController  *gameview= [testController.viewControllers objectAtIndex:0];
    
    
    
    gameview.screenFactoryDelegate = self.testScreenFactory;
    
}

- (void)testingBranch
{
    //UINavigationController* testController = [self.viewControllers objectAtIndex:0];

    BranchController *testingBranchController = [[BranchController alloc]initWithBranchName:@"1"];
    
    
    self.testBanchController = testingBranchController;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
//	[self testScreenFactoryAtTabBarController];
//    [self testingBranch];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any res- (IBAction)tesssa:(id)sender {
}



#pragma mark - action Methods

@end
