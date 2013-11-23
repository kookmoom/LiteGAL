//
//  SaveFile.h
//  LiteGAL
//
//  Created by Artuira on 13-11-21.
//  Copyright (c) 2013年 Artuira. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface SaveFile : NSManagedObject

@property (nonatomic, retain) NSDate * saveTime;
@property (nonatomic, retain) NSNumber * branch;
@property (nonatomic, retain) NSString * screen;
@property (nonatomic, retain) NSSet *characters;
@end

@interface SaveFile (CoreDataGeneratedAccessors)

- (void)addCharactersObject:(NSManagedObject *)value;
- (void)removeCharactersObject:(NSManagedObject *)value;
- (void)addCharacters:(NSSet *)values;
- (void)removeCharacters:(NSSet *)values;

@end
