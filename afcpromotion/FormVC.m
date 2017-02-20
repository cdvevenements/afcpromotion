//
//  FormVC.m
//  afcpromotion
//
//  Created by Olivier on 20/02/2017.
//  Copyright © 2017 Olivier. All rights reserved.
//

#import "FormVC.h"

@interface FormVC ()
@property (weak, nonatomic) IBOutlet UITextField *tfLastName;
@property (weak, nonatomic) IBOutlet UITextField *tfFirstName;
@property (weak, nonatomic) IBOutlet UITextField *tfEmail;
@property (weak, nonatomic) IBOutlet UITextField *tfAddress;

@property (weak, nonatomic) IBOutlet UIButton *btValidate;

@property (weak, nonatomic) IBOutlet UIView *uvGender;
@property (weak, nonatomic) IBOutlet UIView *uvType;
@property (weak, nonatomic) IBOutlet UIView *uvRooms;
@property (weak, nonatomic) IBOutlet UIView *uvSurface;

@end

@implementation FormVC


- (BOOL)prefersStatusBarHidden {
    return YES;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[self tfEmail] setDelegate:self];
    [[self tfLastName] setDelegate:self];
    [[self tfFirstName] setDelegate:self];
    
    [[self btValidate] setEnabled:NO];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)onValidateClicked:(id)sender {
    
    NSString * gender;
    for(DLRadioButton * rb in [[self uvGender] subviews]) {
        if([rb isSelected]) {
            gender = [rb currentTitle];
        }
    }
    NSString * type;
    for(DLRadioButton * rb in [[self uvType] subviews]) {
        if([rb isSelected]) {
            type = [rb currentTitle];
        }
    }
    NSString * rooms;
    for(DLRadioButton * rb in [[self uvRooms] subviews]) {
        if([rb isSelected]) {
            rooms = [rb currentTitle];
        }
    }
    NSString * surface;
    for(DLRadioButton * rb in [[self uvSurface] subviews]) {
        if([rb isSelected]) {
            surface = [rb currentTitle];
        }
    }
    
    [MailManager sendEmail:[[self tfEmail] text] withGender:gender withFirstName:[[self tfFirstName] text] withLastName:[[self tfLastName] text] withAddress:[[self tfAddress] text] withProgram:[[self program] name] withType:type withRooms:rooms withSurface:surface withDelegate:self];
}



+ (BOOL)isEmailValid:(NSString *)aEmail {
    NSError * err = nil;
    NSString *expression = @"^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}$"; // Edited: added ^ and $
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:expression options:NSRegularExpressionCaseInsensitive error:&err];
    NSTextCheckingResult *match = [regex firstMatchInString:aEmail options:0 range:NSMakeRange(0, [aEmail length])];
    return match != nil;
}

- (BOOL)validateEmailWithString:(NSString*)email {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}



// =======================================================================================================
#pragma mark - UITextFieldDelegate
// =======================================================================================================
//- (BOOL)textFieldShouldReturn:(UITextField *)aTextField {
//    [self textFieldDidEndEditing:self];
//    //[mDelegate textFieldShouldReturn:self];
//    return YES;
//}
//- (void)textFieldDidBeginEditing:(UITextField *)aTextField {
//    [self setState:ECheckTextFieldStateIdle];
//}
//- (void)textFieldDidEndEditing:(UITextField *)aTextField {
//    [self setState:[self validate]];
//}
//- (BOOL)textFieldShouldClear:(UITextField *)aTextField {
//    [self setState:ECheckTextFieldStateIdle];
//    return YES;
//}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if(/*[[[self tfFirstName] text] isEqualToString:@""] == NO && */
       [[[self tfLastName] text] isEqualToString:@""] == NO &&
       [[[self tfEmail] text] isEqualToString:@""] == NO &&
       [self validateEmailWithString:[[self tfEmail] text]] == YES) {
        [[self btValidate] setEnabled:YES];
    }
    else {
        [[self btValidate] setEnabled:NO];
    }
    return YES;
}


// =======================================================================================================
#pragma mark - MailManagerDelegate
// =======================================================================================================
- (void)onMailSent:(NSError *)aError {
    
    [SVProgressHUD showSuccessWithStatus:@"Vos informations ont été prises en compte."];
    [[self btValidate] setEnabled:NO];
    [NSTimer scheduledTimerWithTimeInterval:2.0 repeats:NO block:^(NSTimer * _Nonnull timer) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [[self navigationController] popViewControllerAnimated:YES];
        });
    }];
    
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
