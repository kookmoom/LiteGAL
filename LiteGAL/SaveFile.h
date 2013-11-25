//
//  SaveFile.h
//  LiteGAL
//
//  Created by Artuira on 13-11-24.
//  Copyright (c) 2013年 Artuira. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Character;

@interface SaveFile : NSManagedObject

@property (nonatomic, retain) NSNumber * branch;
@property (nonatomic, retain) NSDate * saveTime;
@property (nonatomic, retain) NSNumber * screen;
@property (nonatomic, retain) NSNumber * textRow;
@property (nonatomic, retain) NSSet *characters;
@end

@interface SaveFile (CoreDataGeneratedAccessors)

- (void)addCharactersObject:(Character *)value;
- (void)removeCharactersObject:(Character *)value;
- (void)addCharacters:(NSSet *)values;
- (void)removeCharacters:(NSSet *)values;

@end
