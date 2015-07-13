//
//  CoreDataHandler.m
//  TweetHeap
//
//  Created by Narin Kittikul on 7/10/15.
//  Copyright (c) 2015 Narin Kittikul. All rights reserved.
//

#import "CoreDataHandler.h"

@interface CoreDataHandler ()
- (NSURL *)applicationDocumentsDirectory;
@end

@implementation CoreDataHandler

+ (CoreDataHandler *)sharedInstance {
    __strong static CoreDataHandler *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[CoreDataHandler alloc] init];
        sharedInstance.persistentStoreCoordinator = [sharedInstance persistentStoreCoordinator];
        sharedInstance.searchMoc = [sharedInstance searchMoc];
        sharedInstance.savedMoc = [sharedInstance savedMoc];
    });
    return sharedInstance;
}

#pragma mark - Core Data stack

@synthesize searchMoc = _searchMoc;
@synthesize savedMoc = _savedMoc;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "com.example.forgot" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Model" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"forgot.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)searchMoc {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_searchMoc != nil) {
        return _searchMoc;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _searchMoc = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [_searchMoc setPersistentStoreCoordinator:coordinator];
    return _searchMoc;
}

- (NSManagedObjectContext *)savedMoc {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_savedMoc != nil) {
        return _savedMoc;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _savedMoc = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [_savedMoc setPersistentStoreCoordinator:coordinator];
    return _savedMoc;
}

@end