//
//  LiteGALBranch.h
//  LiteGAL
//
//  Created by Artuira on 13-11-24.
//  Copyright (c) 2013年 Artuira. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LiteGALBranch : NSObject

@property BOOL branch;
@property (strong, nonatomic) NSString* nextBranch;
@property (strong, nonatomic) NSArray *preOptions;
@property (strong, nonatomic) NSArray *screens;
@property (strong, nonatomic) NSString *branchName;
@end
