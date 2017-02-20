//
//  MailManager.m
//  afcpromotion
//
//  Created by Olivier on 15/02/2017.
//  Copyright © 2017 Olivier. All rights reserved.
//

#import "MailManager.h"

@implementation MailManager


+ (void)presentEmailUI:(ProgramData *)aProgram inViewController:(UIViewController *)aVC {
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:[aProgram name] message:@"Pour recevoir la documentation, merci d'entrer vos noms et addresse email ci-dessous:" preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        [textField setKeyboardType:(UIKeyboardTypeAlphabet)];
        [textField setPlaceholder:@"Nom"];
    }];
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        [textField setKeyboardType:(UIKeyboardTypeEmailAddress)];
        [textField setPlaceholder:@"Adresse email"];
    }];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        // check fields
        NSString * name = [[[alert textFields] objectAtIndex:0] text];
        NSString * mail = [[[alert textFields] objectAtIndex:1] text];
        if([name isEqualToString:@""] == NO &&
           [mail isEqualToString:@""] == NO &&
           [MailManager isValidEmail:mail]) {
            [MailManager sendEmail:mail withUser:name withProgram:[aProgram name] withDelegate:nil];
        }
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"Annuler" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        ;
    }]];
    
    [aVC presentViewController:alert animated:YES completion:^{
        ;
    }];
}


+ (BOOL) isValidEmail:(NSString *)checkString {
    BOOL stricterFilter = NO; // Discussion http://blog.logichigh.com/2010/09/02/validating-an-e-mail-address/
    NSString *stricterFilterString = @"^[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}$";
    NSString *laxString = @"^.+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*$";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}



+ (void)sendEmail:(NSString *)aDestination withUser:(NSString *)aUser withProgram:(NSString *)aProgram withDelegate:(id<MailManagerDelegate>)aDelegate {
    
    // save to database
    NSString * dbline = [NSString stringWithFormat:@"%@;%@;%@\n", aUser, aDestination, aProgram];
    NSData * data = [NSData dataWithContentsOfFile:[DataManager emailDatabasePath]];
    if(data == nil) {
        data = [@"NOM;EMAIL;PROGRAMME\n" dataUsingEncoding:NSUTF8StringEncoding];
        [[NSFileManager defaultManager] createFileAtPath:[DataManager emailDatabasePath] contents:data attributes:nil];
    }
    
    {
        NSString * str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        if([str containsString:dbline] == NO) {
            // append and overwrite file
            str = [str stringByAppendingString:dbline];
            data = [str dataUsingEncoding:NSUTF8StringEncoding];
            [data writeToFile:[DataManager emailDatabasePath] atomically:YES];
        }
    }
    
    // sender ?
    MCOSMTPSession * session = [[MCOSMTPSession alloc] init];
    [session setHostname:MAIL_HOST];
    [session setPort:MAIL_PORT];
    [session setUsername:MAIL_SENDER];
    [session setPassword:MAIL_PASSWORD];
    [session setConnectionType:MCOConnectionTypeTLS];
    
    // from ?
    MCOMessageBuilder * builder = [[MCOMessageBuilder alloc] init];
    [[builder header] setFrom:[MCOAddress addressWithDisplayName:MAIL_DISPLAY mailbox:MAIL_SENDER]];
    
    // to ?
    NSArray * to = [NSArray arrayWithObject:[MCOAddress addressWithMailbox:aDestination]];
    [[builder header] setTo:to];

    // subject ?
    [[builder header] setSubject:[NSString stringWithFormat:MAIL_SUBJECT, aProgram]];
    
    // body ?
    NSString * path = [NSString stringWithFormat:@"%@/%@", [DataManager dataPath], MAIL_FILE_NAME];
    data = [[NSFileManager defaultManager] contentsAtPath:path];
    [builder setHTMLBody:[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]];
    
    // send !
    NSData * rfc822Data = [builder data];
    MCOSMTPSendOperation *sendOperation = [session sendOperationWithData:rfc822Data];
    [sendOperation start:^(NSError *error) {
        if(error) {
            NSLog(@"%@ Error sending email to: %@", aDestination, error);
            if([aDelegate respondsToSelector:@selector(onMailSent:)]) {
                [aDelegate onMailSent:error];
            }
        } else {
            NSLog(@"%@ Successfully sent email!", aDestination);
            if([aDelegate respondsToSelector:@selector(onMailSent:)]) {
                [aDelegate onMailSent:nil];
            }
        }
    }];
}



+ (void)sendEmail:(NSString *)aDestination withGender:(NSString *)aGender withFirstName:(NSString *)aFirstName withLastName:(NSString *)aLastName withAddress:(NSString *)aAddress withProgram:(NSString *)aProgram withType:(NSString *)aType withRooms:(NSString *)aRooms withSurface:(NSString *)aSurface withDelegate:(id<MailManagerDelegate>)aDelegate {
    
    // save to database
    NSString * dbline = [NSString stringWithFormat:@"%@;%@;%@;%@;%@;%@;%@;%@;%@\n", aGender, aFirstName, aLastName, aDestination, aAddress, aProgram, aType, aRooms, aSurface];
    NSData * data = [NSData dataWithContentsOfFile:[DataManager emailDatabasePath]];
    if(data == nil) {
        data = [@"GENRE;NOM;PRENOM;EMAIL;ADRESSE;PROGRAMME;TYPE;PIECES;SURFACE\n" dataUsingEncoding:NSUTF8StringEncoding];
        [[NSFileManager defaultManager] createFileAtPath:[DataManager emailDatabasePath] contents:data attributes:nil];
    }
    
    {
        NSString * str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        if([str containsString:dbline] == NO) {
            // append and overwrite file
            str = [str stringByAppendingString:dbline];
            data = [str dataUsingEncoding:NSUTF8StringEncoding];
            [data writeToFile:[DataManager emailDatabasePath] atomically:YES];
        }
    }
    
    // sender ?
    MCOSMTPSession * session = [[MCOSMTPSession alloc] init];
    [session setHostname:MAIL_HOST];
    [session setPort:MAIL_PORT];
    [session setUsername:MAIL_SENDER];
    [session setPassword:MAIL_PASSWORD];
    [session setConnectionType:MCOConnectionTypeTLS];
    
    // from ?
    MCOMessageBuilder * builder = [[MCOMessageBuilder alloc] init];
    [[builder header] setFrom:[MCOAddress addressWithDisplayName:MAIL_DISPLAY mailbox:MAIL_SENDER]];
    
    // to ?
    NSArray * to = [NSArray arrayWithObject:[MCOAddress addressWithMailbox:aDestination]];
    [[builder header] setTo:to];
    
    // subject ?
    [[builder header] setSubject:[NSString stringWithFormat:MAIL_SUBJECT, aProgram]];
    
    // body ?
    NSString * path = [NSString stringWithFormat:@"%@/%@", [DataManager dataPath], MAIL_FILE_NAME];
    data = [[NSFileManager defaultManager] contentsAtPath:path];
    [builder setHTMLBody:[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]];
    
    // send !
    NSData * rfc822Data = [builder data];
    MCOSMTPSendOperation *sendOperation = [session sendOperationWithData:rfc822Data];
    [sendOperation start:^(NSError *error) {
        if(error) {
            NSLog(@"%@ Error sending email to: %@", aDestination, error);
            if([aDelegate respondsToSelector:@selector(onMailSent:)]) {
                [aDelegate onMailSent:error];
            }
        } else {
            NSLog(@"%@ Successfully sent email!", aDestination);
            if([aDelegate respondsToSelector:@selector(onMailSent:)]) {
                [aDelegate onMailSent:nil];
            }
        }
    }];
}

@end
