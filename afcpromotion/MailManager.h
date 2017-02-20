//
//  MailManager.h
//  afcpromotion
//
//  Created by Olivier on 15/02/2017.
//  Copyright © 2017 Olivier. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <mailcore2-ios/MailCore/MailCore.h>
#import "DataManager.h"
#import "Config.h"

@protocol MailManagerDelegate <NSObject>

- (void)onMailSent:(NSError *)aError;

@end

@interface MailManager : NSObject
+ (void)presentEmailUI:(ProgramData *)aProgram inViewController:(UIViewController *)aVC;
+ (void)sendEmail:(NSString *)aDestination withUser:(NSString *)aUser withProgram:(NSString *)aProgram withDelegate:(id<MailManagerDelegate>)aDelegate;
+ (void)sendEmail:(NSString *)aDestination withFirstName:(NSString *)aFirstName withLastName:(NSString *)aLastName withAddress:(NSString *)aAddress withProgram:(NSString *)aProgram withType:(NSString *)aType withRooms:(NSString *)aRooms withSurface:(NSString *)aSurface withDelegate:(id<MailManagerDelegate>)aDelegate;
@end
