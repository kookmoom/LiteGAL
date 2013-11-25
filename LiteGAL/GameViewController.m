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

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
       
    }
    return self;
}

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

- (void) getScreenFromFactory
{
//    [self testScreen];
    self.screen = [self.screenFactoryDelegate  getScreenFromDelegate];
}


- (void) updateScreenAtTextIndex:(NSInteger)row
{
    [self updatePicture];
    
    [self updateTextAtIndex:row];
    
    self.textRow = row;
}

- (void) updateScreenByBranchAtTextIndex:(NSInteger)row
{
    [self getScreenFromFactory];
    
    [self updateScreenAtTextIndex:row];
    
}


#pragma mark - ios View Methods

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //load screen
    if (self.screenFactoryDelegate == nil) {
        self.screenFactoryDelegate = [self.myBranchController getCurrentScreenFactory];
    }
   
    [self getScreenFromFactory];
    
	//gesture
    [self gestureRecognizerSetup];
    
    //set gameview
    NSInteger row = INIT_SCREEN_ROW;
    [self updateScreenAtTextIndex:row];
    
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
    }
}



- (IBAction)saveData:(id)sender {
    
    [self performSegueWithIdentifier:@"OptionSegue" sender:sender];
}
@end
