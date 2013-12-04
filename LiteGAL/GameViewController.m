//
//  GameViewController.m
//  LiteGAL
//
//  Created by Artuira on 13-11-21.
//  Copyright (c) 2013年 Artuira. All rights reserved.
//

#import "GameViewController.h"
#import "GameImageView.h"
#import "BranchController.h"

#import "UserDefaultsKey.h"

#define INIT_SCREEN_ROW 0;

@interface GameViewController ()

#pragma mark - UIKit property
@property (weak, nonatomic) IBOutlet UILabel *GameTextDisplay;

@property (weak, nonatomic) IBOutlet GameImageView *imageView;
- (IBAction)saveData:(id)sender;


#pragma mark - action Methods


#pragma mark - Self strong property pointer
@property (strong, nonatomic) UIImage *screenLayer;

@property (strong, nonatomic) NSArray *screenText;

@property (strong, nonatomic) BranchController *myBranchController;


#pragma mark - Self weak property pointer

@property (weak, nonatomic) LiteGALScreen *screen;

#pragma mark - Self varialble
@property NSInteger textRow;// the index of screen's text;

@end

@implementation GameViewController

- (BranchController*) myBranchController
{
    if (_myBranchController == nil)
    _myBranchController = [[BranchController alloc]initWithBranchName:@"1"];
    
    return _myBranchController;
}


#pragma mark - init Methods



#pragma mark - update View Methods

- (void)updateTextAtIndex:(NSInteger)row
{
    self.GameTextDisplay.text = [self.screen.textArray objectAtIndex:row];
}

- (void)updatePicture
{
    [self.imageView setImage:[[UIImage alloc]initWithData:self.screen.picture]];
}

#pragma mark - Gesture Methods

- (void) gestureResponse
{
    self.textRow++;
    
    if (self.textRow >= [self.screen.textArray count]) {
        [self getScreenFromFactory];
        self.textRow = INIT_SCREEN_ROW;
    }
    else{
        
        [self updateTextAtIndex:self.textRow];
    }
   
}

- (void) gestureRecognizerSetup
{
    UISwipeGestureRecognizer *recognizer;
    
    recognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(gestureResponse)];
    
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionLeft)];
    [[self view] addGestureRecognizer:recognizer];
}

#pragma mark - View Change Methods

- (void) testScreen
{
    NSURL *plistURL = [[NSBundle mainBundle] URLForResource:@"1" withExtension:@"plist"];
    NSDictionary *Branch = [NSDictionary dictionaryWithContentsOfURL:plistURL];
    
    NSArray *screens = [Branch valueForKey:@"Screens"];
    NSDictionary *screen = [screens objectAtIndex:0];
    
    NSString *picture = [screen valueForKey:@"Picture"];
 //   NSString *text = [screen valueForKey:@"Text"];
    
    plistURL = [[NSBundle mainBundle] URLForResource:picture withExtension:@"png"];
    
    self.screenLayer = [[UIImage alloc]initWithData:[[NSData alloc]initWithContentsOfURL:plistURL]];
    [self.imageView setImage:self.screenLayer];
    
    plistURL = [[NSBundle mainBundle] URLForResource:@"testtext" withExtension:@"plist"];
    self.screenText = [NSArray arrayWithContentsOfURL:plistURL];
    
    self.GameTextDisplay.text = [self.screenText objectAtIndex:0];
    
    self.textRow = 0;
    
}

- (void) branchDidChange
{
    self.screenFactoryDelegate = [self.myBranchController getCurrentScreenFactory];
    
    [self getScreenFromFactory];
    
    
    NSInteger row = INIT_SCREEN_ROW;
    [self updateScreenAtTextIndex:row];

}

- (void) getScreenFromFactory
{
//    [self testScreen];
    self.screen = [self.screenFactoryDelegate  getScreenFromDelegate];
    
    self.textRow = INIT_SCREEN_ROW;
    
    [self updatePicture];
    [self updateTextAtIndex:self.textRow];
    
    if (self.screen == nil ) {
        
        if ([self.myBranchController isBranch])
        {
            [self performSegueWithIdentifier:@"OptionSegue" sender:nil];
        }
        else
        {
            [self.myBranchController branchIsUpdatedByGameViewController];
            [self branchDidChange];
        }
    }
    
    
}


- (void) updateScreenAtTextIndex:(NSInteger)row
{
    [self updateTextAtIndex:row];
    
    self.textRow = row;
}

- (void) updateScreenByBranchAtTextIndex:(NSInteger)row
{
    [self getScreenFromFactory];
    
    [self updateScreenAtTextIndex:row];
    
}

- (void) updateBySaveData:(NSString *)name atScreenIndex:(NSInteger)screen andTextIndex:(NSInteger)text
{
    [self.myBranchController updateGameViewControllerBySaveData:name atScreenIndex:screen andTextIndex:text];
    [self branchDidChange];
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setObject:kWillLoad forKey:kUpdateGameViewBySaveFile];
}


#pragma mark - ios View Methods

- (void)viewDidLoad
{
    [super viewDidLoad];
    //load screen
    if (self.screenFactoryDelegate == nil) {
        self.screenFactoryDelegate = [self.myBranchController getCurrentScreenFactory];
        [self gestureRecognizerSetup];
    }
   
    
    
    
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString* updateState = [userDefault objectForKey:kUpdateGameView];
    
    if ([updateState isEqualToString:kUpdate]) {
        
        [self branchDidChange];
        [userDefault setObject:kDontUpdate forKey:kUpdateGameView];
    }
    
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Segue Methods

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"OptionSegue"]) {
        
        BranchOptionsTableViewController* temp = segue.destinationViewController;
        
        temp.branchDelegate = self.myBranchController;
        
        [self.navigationController setHidesBottomBarWhenPushed:YES];
    }
}

#pragma mark - action Methods

- (IBAction)saveData:(id)sender {
    
    [self.saveDataDelegate saveFile:[self.myBranchController getCurrentBranchName] atScreen:[self.myBranchController getCurrentScreenRow ]withTextIndex:self.textRow];
}
@end
