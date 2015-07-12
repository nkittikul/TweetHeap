//
//  Tweet.h
//  
//
//  Created by Narin Kittikul on 7/10/15.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Tweet : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * screenName;
@property (nonatomic, retain) NSString * text;
@property (nonatomic, retain) NSData * image;
@property (nonatomic, retain) NSDate * date;

@end
