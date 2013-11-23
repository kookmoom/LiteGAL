//
//  GameViewController.m
//  LiteGAL
//
//  Created by Artuira on 13-11-21.
//  Copyright (c) 2013年 Artuira. All rights reserved.
//

#import "GameViewController.h"
#import "GameImageView.h"

@interface GameViewController ()

#pragma mark - UIKit property
@property (weak, nonatomic) IBOutlet UILabel *GameTextDisplay;

@property (weak, nonatomic) IBOutlet GameImageView *imageView;

#pragma mark - Self strong property pointer
@property (strong, nonatomic) UIImage *screenLayer;

@property (strong, nonatomic) NSArray *screenText;

#pragma mark - Self weak property pointer

@property (weak, nonatomic) LiteGALScreen *screen;

#pragma mark - Self varialble
@property NSInteger textRow;// the index of screen's text;

@end

@implementation GameViewController

#pragma mark - init Methods

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark - Gesture Methods

- (void) gestureResponse
{
    self.textRow++;
    
    if (self.textRow >= [self.screen.textArray count]) {
        [self getScreenFromFactory];
    }
    else{
        self.GameTextDisplay.text = [self.screen.textArray objectAtIndex:self.textRow];
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
    self.screen = [self.delegate getScreenFromDelegate];
    
    [self updateFirstScreen];
    
    
}

- (void) updateFirstScreen
{
    [self.imageView setImage:[[UIImage alloc]initWithData:self.screen.picture]];
    self.GameTextDisplay.text = [self.screen.textArray objectAtIndex:0];
    
    self.textRow = 0;
}

#pragma mark - ios View Methods

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //load screen
    //set gameview
    [self getScreenFromFactory];
    
	//gesture
    [self gestureRecognizerSetup];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




@end
