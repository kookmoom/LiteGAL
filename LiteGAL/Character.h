//
//  Character.h
//  LiteGAL
//
//  Created by Artuira on 13-11-24.
//  Copyright (c) 2013年 Artuira. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class SaveFile;

@interface Character : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * value;
@property (nonatomic, retain) SaveFile *saveFile;

@end
