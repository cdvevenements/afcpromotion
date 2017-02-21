//
//  DataManager.m
//  afcpromotion
//
//  Created by Olivier on 15/02/2017.
//  Copyright © 2017 Olivier. All rights reserved.
//

#import "DataManager.h"

static DataManager * sInstance;


double map(double x, double in_min, double in_max, double out_min, double out_max) {
    return (x - in_min) * (out_max - out_min) / (in_max - in_min) + out_min;
}



@implementation MapData
@end

@implementation ProgramData
@end

@implementation DataManager


+ (NSString *)emailDatabasePath {
    static NSString * path = nil;
    if(path == nil) {
        NSString * folder =  [NSString stringWithFormat:@"%@/%@", [[[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil] path], DATA_FOLDER];
        [[NSFileManager defaultManager] createDirectoryAtPath:folder withIntermediateDirectories:YES attributes:nil error:nil];
        path = [NSString stringWithFormat:@"%@/%@-%@", folder, [[UIDevice currentDevice] name], EMAIL_DATABASE];
    }
    return path;
}


+ (NSString *)dataPath {
    NSString * path = nil;
#ifdef BUNDLED_DATA
    path = [NSString stringWithFormat:@"%@/%@", [[NSBundle mainBundle] bundlePath], DATA_FOLDER];
#else
     path = [NSString stringWithFormat:@"%@/%@", [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil], DATA_FOLDER];
#endif
    return path;
}



+ (DataManager *)instance {
    if(sInstance == nil) {
        NSError * err = nil;
        NSString * path = [[NSBundle mainBundle] pathForResource:@"programs" ofType:@"json" inDirectory:@"data"];
        NSData * data = [[NSFileManager defaultManager] contentsAtPath:path];
        id json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&err];
        if(err) {
            NSLog(@"error: cannot open datafile");
        }
        else {
            if ([json isKindOfClass:[NSDictionary class]]) {
                sInstance = [[DataManager alloc] init];
                
                // parse
                NSArray * programs = [json objectForKey:@"programs"];
                NSMutableArray * temp = [NSMutableArray array];
                for(NSDictionary * program in programs) {
                    NSString * name = [program objectForKey:@"name"];
                    NSString * address = [program objectForKey:@"address"];
                    NSString * folder = [program objectForKey:@"folder"];
                    NSString * video = [program objectForKey:@"video"];
                    NSDictionary * coord = [program objectForKey:@"point"];
                    CLLocationDegrees lat = [[coord objectForKey:@"lat"] doubleValue];
                    CLLocationDegrees lon = [[coord objectForKey:@"lon"] doubleValue];
                    
                    ProgramData * p = [[ProgramData alloc] init];
                    [p setName:name];
                    [p setVideo:[NSString stringWithFormat:@"%@/%@/%@", [self dataPath], folder, video]];
                    [p setAddress:address];
                    [p setImageFolder:[NSString stringWithFormat:@"%@/%@/images", [self dataPath], folder]];
                    [p setCoord:CLLocationCoordinate2DMake(lat, lon)];
                    
                    [temp addObject:p];
                }
                
                NSDictionary * m = [json objectForKey:@"map"];
                MapData * map = [[MapData alloc] init];
                float zoom = [[m objectForKey:@"zoom"] floatValue];
                NSString * image = [m objectForKey:@"image"];
                [map setZoom:zoom];
                [map setImage:image];
                {
                    NSDictionary * coord = [m objectForKey:@"topleft"];
                    CLLocationDegrees lat = [[coord objectForKey:@"lat"] doubleValue];
                    CLLocationDegrees lon = [[coord objectForKey:@"lon"] doubleValue];
                    [map setTopleft:CLLocationCoordinate2DMake(lat, lon)];
                }
                {
                    NSDictionary * coord = [m objectForKey:@"bottomright"];
                    CLLocationDegrees lat = [[coord objectForKey:@"lat"] doubleValue];
                    CLLocationDegrees lon = [[coord objectForKey:@"lon"] doubleValue];
                    [map setBottomright:CLLocationCoordinate2DMake(lat, lon)];
                }
                
//                {
//                    NSDictionary * coord = [m objectForKey:@"center"];
//                    CLLocationDegrees lat = [[coord objectForKey:@"lat"] doubleValue];
//                    CLLocationDegrees lon = [[coord objectForKey:@"lon"] doubleValue];
//                    [map setCenter:CLLocationCoordinate2DMake(lat, lon)];
//                }

                [sInstance setPrograms:[NSArray arrayWithArray:temp]];
                [sInstance setMapData:map];
            }
            else {
                NSLog(@"error: not json dictionnary");
            }
        }
        
    }
    return sInstance;
}


@end
