//
//  BranchController.m
//  LiteGAL
//
//  Created by Artuira on 13-11-24.
//  Copyright (c) 2013年 Artuira. All rights reserved.
//

#import "BranchController.h"

#import "LiteGALBranch.h"
#import "BranchOptionsTableViewController.h"


@interface BranchController ()


@property (strong, nonatomic) ScreenFactory* currentScreenFactory;
@property (strong, nonatomic) LiteGALBranch* currentBranch;
@property (strong, nonatomic) NSArray* preOptions;
@property (strong, nonatomic) NSArray* preScreenFactories;
@property (strong, nonatomic) NSArray* preBranchController;

@property NSInteger valueOfA;
@property NSInteger valueOfB;

@end


@implementation BranchController

#pragma mark - init Methods

- (LiteGALBranch*) loadBranchAtResource:(NSString*)name
{
    LiteGALBranch* liteBranch = [[LiteGALBranch alloc]init];
    
    NSURL *plistURL = [[NSBundle mainBundle] URLForResource:name withExtension:@"plist"];
    NSDictionary *branch = [NSDictionary dictionaryWithContentsOfURL:plistURL];
    
    liteBranch.branch = [branch valueForKey:@"Branch"];
    liteBranch.nextBranch = [branch valueForKey:@"NextBranch"];
    liteBranch.preOptions = [branch valueForKey:@"PreOptions"];
    liteBranch.screens = [branch valueForKey:@"Screens"];
    
    return liteBranch;
}


- (id) initWithBranchName:(NSString*)name
{
    self = [super init];
        if  (self)
        {
            _valueOfA = 0;
            _valueOfB = 0;
            
           
            
                if (name == nil)
                {
                    name = @"0";
                }
                    _currentBranch = [self loadBranchAtResource:name];
                        
                    [self prepareOptions];
            
                    _currentScreenFactory = [self setupFirstScreenFactory:_currentBranch.screens];
        }
    
    return self;
}


#pragma mark - update Self Branch

- (void) updateSelfBranchAtChoose:(NSInteger)chooseRow
{
    NSInteger choosedOption = [[[self.preOptions objectAtIndex:chooseRow]valueForKey:@"row"]intValue];
    
    NSDictionary *choosedOptionDic = [self.currentBranch.preOptions objectAtIndex:choosedOption];
    
    self.currentBranch = [self loadBranchAtResource:[choosedOptionDic valueForKey:@"NextBranch"]];
    
    if (!self.currentBranch.branch) {
        return;
    }
    
    [self prepareOptions];
}

#pragma mark - update GameViewController

- (void) upadateGameViewControllerTextAtIndex:(NSInteger)row
{
    //There is not ready for now
}

- (void) updateGameViewControllerWithScreenFactory:(ScreenFactory*)screenFactory atTextIndex:(NSInteger)row
{
    //CurrentScreenFactory will be deleted
    self.currentScreenFactory = screenFactory;

    [self upadateGameViewControllerTextAtIndex:row];
}

- (void) setupScreenFactoryWithScreens:(NSArray*)screens atScreenIndex:(NSInteger)screen andTextIndex:(NSInteger)text
{
    ScreenFactory* screenFactory = [[ScreenFactory alloc]initWithScreens:screens AtIndex:screen];
    [self updateGameViewControllerWithScreenFactory:screenFactory atTextIndex:text];
}

- (void) updateGameViewControllerBySaveData:(NSString *)name atScreenIndex:(NSInteger)screen andTextIndex:(NSInteger)text
{
    self.currentBranch = [self loadBranchAtResource:name];
    [self setupScreenFactoryWithScreens:self.currentBranch.screens atScreenIndex:screen andTextIndex:text];
}

- (void) updateGameViewControllerByChoose:(NSInteger)row
{
    ScreenFactory* chooseScreenFactory = [self.preScreenFactories objectAtIndex:row];
    [self updateGameViewControllerWithScreenFactory:chooseScreenFactory atTextIndex:0];
}

#pragma mark - prepare ScreenFactory

- (ScreenFactory*)setupFirstScreenFactory:(NSArray*)screens
{
    ScreenFactory* screenFactory= [[ScreenFactory alloc]initWithScreens:screens];
    return screenFactory;
}


#pragma mark - prepare Options

- (BOOL) isMatchTheConditionAtDict:(NSDictionary *)character
{
    NSString *conditon = [character valueForKey:@"Condition"];
    NSInteger score = [[character valueForKey:@"Score"] intValue];
    
    if ([conditon isEqualToString:@"="]) {
        
        
        if (score == self.valueOfA) {
            return YES;
        }
        
    }
    else if ([conditon isEqualToString:@"<"])
    {
        
        if (score < self.valueOfA) {
            return YES;
        }
    }
    else if ([conditon isEqualToString:@">"] )
    {
        
        if (score > self.valueOfA) {
            return YES;
        }

    }
    
    return NO;
}

- (BOOL)isRightOption:(NSDictionary*)branchDict
{
    if ([self isMatchTheConditionAtDict:[branchDict valueForKey:@"A"]]) {
        if ([self isMatchTheConditionAtDict:[branchDict valueForKey:@"B"]]) {
            return YES;
        }
    }
    
    return NO;
}

- (ScreenFactory*) prepareScreenFactoryAtBranch:(NSDictionary*)branchDict
{
    NSString *name = [branchDict valueForKey:@"NextBranch"];
    LiteGALBranch* branch = [self loadBranchAtResource:name];
    
    return [self setupFirstScreenFactory:branch.screens];
}

- (void)prepareOptions
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSMutableArray *preOptions = [[NSMutableArray alloc]init];
        NSMutableArray *preScreenFactories = [[NSMutableArray alloc]init];
        
        
        NSDictionary *tempDict;
        NSDictionary *branchDict;
        
        
        for (int row = 0; row < [self.currentBranch.preOptions count]; row++) {
            
            branchDict = [self.currentBranch.preOptions objectAtIndex:row];
            
            if ([self isRightOption:branchDict])
            {
                
                tempDict = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d",row],@"row",
                            [branchDict valueForKey:@"OptionText"],@"OptionText",nil];
                
                [preOptions addObject:tempDict];
                
                [preScreenFactories addObject:[self prepareScreenFactoryAtBranch:branchDict]];
                
            }
        }
        
        self.preOptions = preOptions;
        self.preScreenFactories = preScreenFactories;
     
        
        
    });
    
}

#pragma mark - BranchOptionsTableViewController Delegate Methods

- (NSArray*) getOptionsFormBranchController
{
    return self.preOptions;
}

- (void)updateGameViewAtBranch:(NSInteger)row
{
    NSInteger chooseRow = row;
    [self updateGameViewControllerByChoose:row];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        [self updateSelfBranchAtChoose:chooseRow];
        
    });
    
        

}

#pragma mark - out Methdos;

- (ScreenFactory*) getCurrentScreenFactory
{
    return self.currentScreenFactory;
}



@end
