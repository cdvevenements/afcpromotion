//
//  DataManager.m
//  afcpromotion
//
//  Created by Olivier on 15/02/2017.
//  Copyright © 2017 Olivier. All rights reserved.
//

#import "DataManager.h"

#define USERPREF_REMOTE_DATA        @"USERPREF_REMOTE_DATA"


static DataManager * sInstance;


double map(double x, double in_min, double in_max, double out_min, double out_max) {
    return (x - in_min) * (out_max - out_min) / (in_max - in_min) + out_min;
}



@implementation MapData
@end

@implementation ProgramData

- (BOOL)hasVideo {
    return [[NSFileManager defaultManager] fileExistsAtPath:[self video]];
}

- (BOOL)hasPictures {
    if([[NSFileManager defaultManager] fileExistsAtPath:[self imageFolder]]) {
        if([[[NSFileManager defaultManager] contentsOfDirectoryAtPath:[self imageFolder] error:nil] count] > 0) {
            return YES;
        }
    }
    return NO;
}

@end



@implementation SponsorData
@end


@interface DataManager()
@property BOOL isRemoteData;
@end

@implementation DataManager


+ (void)flagRemoteData {
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:USERPREF_REMOTE_DATA];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

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
    if([[DataManager instance] isRemoteData] == NO) {
        path = [NSString stringWithFormat:@"%@/%@", [[NSBundle mainBundle] bundlePath], DATA_FOLDER];
    }
    else {
        path = [NSString stringWithFormat:@"%@/%@", [[[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil] path], DATA_FOLDER];
    }
    return path;
}



+ (DataManager *)instance {
    if(sInstance == nil) {
        
        sInstance = [[DataManager alloc] init];
        [sInstance setIsRemoteData: [[[NSUserDefaults standardUserDefaults] objectForKey:USERPREF_REMOTE_DATA] boolValue]];

        
        NSError * err = nil;
        NSString * path;
        if([sInstance isRemoteData] == NO) {
            path = [NSString stringWithFormat:@"%@/%@/%@", [[NSBundle mainBundle] bundlePath], DATA_FOLDER, @"programs.json"];
        }
        else {
            path = [NSString stringWithFormat:@"%@/%@/%@", [[[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil] path], DATA_FOLDER, @"programs.json"];
        }
        
//        NSString * path = [[NSBundle mainBundle] pathForResource:@"programs" ofType:@"json" inDirectory:@"data"];
        NSData * data = [[NSFileManager defaultManager] contentsAtPath:path];
        
        id json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&err];
        if(err) {
            NSLog(@"error: cannot open datafile %@", path);
        }
        else {
            if ([json isKindOfClass:[NSDictionary class]]) {
                
                // PROGRAMS
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
                [sInstance setPrograms:[NSArray arrayWithArray:temp]];

                
                // AGENCIES
                NSArray * agencies = [json objectForKey:@"agencies"];
                temp = [NSMutableArray array];
                for(NSDictionary * agency in agencies) {
                    NSString * name = [agency objectForKey:@"name"];
                    NSString * address = [agency objectForKey:@"address"];
                    NSString * folder = [agency objectForKey:@"folder"];
                    NSString * video = [agency objectForKey:@"video"];
                    NSDictionary * coord = [agency objectForKey:@"point"];
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
                [sInstance setAgencies:[NSArray arrayWithArray:temp]];
                
                
                // SPONSORS
                NSArray * sponsors = [json objectForKey:@"sponsors"];
                temp = [NSMutableArray array];
                for(NSDictionary * sponsor in sponsors) {
                    NSString * name = [sponsor objectForKey:@"name"];
                    NSString * icon = [sponsor objectForKey:@"icon"];
                    NSString * address = [sponsor objectForKey:@"address"];
                    NSString * url = [sponsor objectForKey:@"url"];

//                    NSString * folder = [sponsor objectForKey:@"folder"];
//                    if(!folder || [folder isEqualToString:@""]) {
//                        folder = @"NULLFOLDER";
//                    }
//                    NSString * video = [sponsor objectForKey:@"video"];
//                    if(!video || [video isEqualToString:@""]) {
//                        video = @"NULLVIDEO";
//                    }
                    NSDictionary * coord = [sponsor objectForKey:@"point"];
                    CLLocationDegrees lat = [[coord objectForKey:@"lat"] doubleValue];
                    CLLocationDegrees lon = [[coord objectForKey:@"lon"] doubleValue];
                    
                    SponsorData * p = [[SponsorData alloc] init];
                    [p setName:name];
                    NSData * icondata = [[NSFileManager defaultManager] contentsAtPath:[NSString stringWithFormat:@"%@/%@", [self dataPath], icon]];
                    [p setIcon:[UIImage imageWithData:icondata]];
//                    [p setVideo:[NSString stringWithFormat:@"%@/%@/%@", [self dataPath], folder, video]];
                    [p setAddress:address];
                    [p setUrl:url];
//                    [p setImageFolder:[NSString stringWithFormat:@"%@/%@/images", [self dataPath], folder]];
                    [p setCoord:CLLocationCoordinate2DMake(lat, lon)];
                    
                    [temp addObject:p];
                }
                [sInstance setSponsors:[NSArray arrayWithArray:temp]];
                
                
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
