//
//  CoreDataHandler.h
//  TweetHeap
//
//  Created by Narin Kittikul on 7/11/15.
//  Copyright (c) 2015 Narin Kittikul. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface CoreDataHandler : NSObject

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (strong, nonatomic) NSManagedObjectContext *tempMoc;

+ (CoreDataHandler *)sharedInstance;
- (NSURL *)applicationDocumentsDirectory;

@end