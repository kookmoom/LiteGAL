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
#import "SaveFile.h"
#import "UserDefaultsKey.h"
#import "LoadSaveFileTableViewController.h"

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

- (void) testDeleteAll
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths lastObject];
    NSString *persistentStorePath = [documentsDirectory stringByAppendingPathComponent:@"LiteGAL.sqlite"];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:persistentStorePath]) {
        NSError *error = nil;
        BOOL oldStoreRemovalSuccess = [[NSFileManager defaultManager] removeItemAtPath:persistentStorePath error:&error];
        NSAssert3(oldStoreRemovalSuccess, @"Unhandled error adding persistent store in %s at line %d: %@", __FUNCTION__, __LINE__, [error localizedDescription]);
    }

}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    [self testDeleteAll];
    
    UINavigationController *navigationController = [self.viewControllers objectAtIndex:0];
    GameViewController *gameViewController = [navigationController.viewControllers objectAtIndex:0];
    
    navigationController = [self.viewControllers objectAtIndex:1];
    LoadSaveFileTableViewController *loadController = [navigationController.viewControllers objectAtIndex:0];
    
    gameViewController.saveDataDelegate = loadController;
    [loadController initFetchedResultsController];
    
    NSUserDefaults *userDefualts = [NSUserDefaults standardUserDefaults];
    
    [userDefualts setObject:kWillLoad forKey:kUpdateGameViewBySaveFile];
    [userDefualts setObject:kUpdate forKey:kUpdateGameView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any res- (IBAction)tesssa:(id)sender {
}



#pragma mark - action Methods


- (void) tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    //changge branch at GameViewController
 
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString* updateState = [userDefault objectForKey:kUpdateGameViewBySaveFile];
    
    if ([updateState isEqualToString:kDidLoad]) {
        
        UINavigationController *navigationController = [self.viewControllers objectAtIndex:0];
        GameViewController *gameViewController = [navigationController.viewControllers objectAtIndex:0];
        
        NSString *branch = [userDefault objectForKey:kBranchForLoading];
        NSNumber *screen = [userDefault objectForKey:kScreenRowForLoading];
        NSNumber *textRow = [userDefault objectForKey:kTextRowForLoading];
        
        [gameViewController updateBySaveData:branch atScreenIndex:[screen integerValue] andTextIndex:[textRow integerValue]];
    }
    
    
    
    
}


@end
