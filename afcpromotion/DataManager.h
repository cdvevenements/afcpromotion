//
//  DataManager.h
//  afcpromotion
//
//  Created by Olivier on 15/02/2017.
//  Copyright © 2017 Olivier. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

#import "Config.h"

@interface ProgramData : NSObject
@property(strong, nonatomic) NSString * name;
@property(strong, nonatomic) NSString * imageFolder;
@property(strong, nonatomic) NSString * address;
@property(strong, nonatomic) NSString * video;
@property CLLocationCoordinate2D coord;
@end

@interface MapData : NSObject
@property CLLocationCoordinate2D topleft;
@property CLLocationCoordinate2D bottomright;
@property CLLocationCoordinate2D center;
@property float zoom;
@property(strong, nonatomic) NSString * image;
@end

@interface DataManager : NSObject

+ (DataManager *) instance;
+ (NSString *)dataPath;
+ (NSString *)emailDatabasePath;
@property (strong, nonatomic) NSArray * programs;
@property (strong, nonatomic) MapData * mapData;

@end

double map(double x, double in_min, double in_max, double out_min, double out_max) ;
