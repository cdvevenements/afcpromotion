//
//  FormVC.m
//  afcpromotion
//
//  Created by Olivier on 20/02/2017.
//  Copyright © 2017 Olivier. All rights reserved.
//

#import "FormVC.h"

@interface FormVC ()
@property (weak, nonatomic) IBOutlet UIView *uvData;
@property (weak, nonatomic) IBOutlet UITextField *tfLastName;
@property (weak, nonatomic) IBOutlet UITextField *tfFirstName;
@property (weak, nonatomic) IBOutlet UITextField *tfEmail;
@property (weak, nonatomic) IBOutlet UITextField *tfAddress;
@property (weak, nonatomic) IBOutlet UITextField *tfZipCode;
@property (weak, nonatomic) IBOutlet UITextField *tfPhone;

@property (weak, nonatomic) IBOutlet UILabel *lbLastName;
@property (weak, nonatomic) IBOutlet UILabel *lbFirstName;
@property (weak, nonatomic) IBOutlet UILabel *lbEmail;

@property (weak, nonatomic) IBOutlet UIButton *btValidate;

@property (weak, nonatomic) IBOutlet UIView *uvGender;
@property (weak, nonatomic) IBOutlet UIView *uvType;
@property (weak, nonatomic) IBOutlet UIView *uvRooms;
@property (weak, nonatomic) IBOutlet UIView *uvSurface;

@property (weak, nonatomic) IBOutlet UIView *uvHeader;
@property (weak, nonatomic) IBOutlet UILabel *lbProgram;

@end

@implementation FormVC


- (BOOL)prefersStatusBarHidden {
    return YES;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[self tfEmail] setDelegate:self];
    [[self tfEmail] setInputAccessoryView:nil];
    [[self tfLastName] setDelegate:self];
    [[self tfLastName] setInputAccessoryView:nil];
    [[self tfFirstName] setDelegate:self];
    [[self tfFirstName] setInputAccessoryView:nil];
    
    [self setTitle:@"Formulaire de contact"];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillShow:)
                                                     name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillHide:)
                                                     name:UIKeyboardWillHideNotification object:nil];
    
//    NSMutableAttributedString * attr = [[NSMutableAttributedString alloc] initWithString:@"* Nom:"];
//    [attr addAttribute:NSForegroundColorAttributeName value:FG_COLOR range:NSMakeRange(2, [attr length]-2)];
//    [attr addAttribute:NSForegroundColorAttributeName value:FLASH_COLOR range:NSMakeRange(0, 2)];
//    [[self lbLastName] setAttributedText:attr];
//    
//    attr = [[NSMutableAttributedString alloc] initWithString:@"* Prénom:"];
//    [attr addAttribute:NSForegroundColorAttributeName value:FG_COLOR range:NSMakeRange(2, [attr length]-2)];
//    [attr addAttribute:NSForegroundColorAttributeName value:FLASH_COLOR range:NSMakeRange(0, 2)];
//    [[self lbFirstName] setAttributedText:attr];
//    
//    attr = [[NSMutableAttributedString alloc] initWithString:@"* Adresse e-mail:"];
//    [attr addAttribute:NSForegroundColorAttributeName value:FG_COLOR range:NSMakeRange(2, [attr length]-2)];
//    [attr addAttribute:NSForegroundColorAttributeName value:FLASH_COLOR range:NSMakeRange(0, 2)];
//    [[self lbEmail] setAttributedText:attr];
    
    
    
    [[self btValidate] setEnabled:NO];
    [[[self btValidate] titleLabel] setFont:FONT_BOLD(FONT_SZ_MEDIUM)];
    [[self btValidate] setBackgroundColor:FLASH_COLOR];
    [[self btValidate] setTitleColor:BG_COLOR forState:UIControlStateNormal];
//    [[self btValidate] setTitleColor:BG_COLOR forState:UIControlStateNormal];
    
    
    [[[self uvType] layer] setBorderWidth:1];
    [[[self uvType] layer] setBorderColor:FG_COLOR.CGColor];
    [[[self uvType] layer] setCornerRadius:4];
    
    
    [[[self uvRooms] layer] setBorderWidth:1];
    [[[self uvRooms] layer] setBorderColor:FG_COLOR.CGColor];
    [[[self uvRooms] layer] setCornerRadius:4];
    
    
//    [[[self uvGender] layer] setBorderWidth:1];
//    [[[self uvGender] layer] setBorderColor:FG_COLOR.CGColor];
//    [[[self uvGender] layer] setCornerRadius:4];
    
    [[[self uvSurface] layer] setBorderWidth:1];
    [[[self uvSurface] layer] setBorderColor:FG_COLOR.CGColor];
    [[[self uvSurface] layer] setCornerRadius:4];
    
    
    [[self view] setBackgroundColor:BG_COLOR];
    
    
    [self configViews:[self view]];
    
    [[self lbProgram] setText:[[self program] name]];
    [[self lbProgram] setFont:FONT(FONT_SZ_XLARGE)];
    
}


- (void)keyboardWillShow:(id)aSender {
    CGAffineTransform t  = CGAffineTransformMakeTranslation(0, -1 * (CGRectGetHeight([[self uvHeader] frame]) + 8));
    [[self uvData] setTransform:t];
    
    [UIView animateWithDuration:0.3 animations:^{
        [[self uvHeader] setAlpha:0.0];
    }];
    
}


- (void)keyboardWillHide:(id)aSender {
    CGAffineTransform t  = CGAffineTransformMakeTranslation(0, 1 * (CGRectGetHeight([[self uvHeader] frame]) + 8));
    [[self uvData] setTransform:CGAffineTransformMakeTranslation(0, 0)];
    [UIView animateWithDuration:0.3 animations:^{
        [[self uvHeader] setAlpha:1.0];
    }];
}


- (void)configViews:(UIView *)aParent {
    for(UIView * v in [aParent subviews]) {
        if([v isKindOfClass:[DLRadioButton class]]) {
            [[(DLRadioButton *)v titleLabel] setFont:FONT_BOLD(FONT_SZ_MEDIUM)];
            [(DLRadioButton *)v setTitleColor:FG_COLOR forState:UIControlStateNormal];
            [(DLRadioButton *)v setIndicatorColor:FLASH_COLOR];
        }
//        else if([v isKindOfClass:[UIButton class]]) {
//            [[(UIButton *)v titleLabel] setFont:FONT_BOLD(FONT_SZ_MEDIUM)];
//            [(UIButton *)v setTitleColor:FG_COLOR forState:UIControlStateNormal];
//        }
        else if([v isKindOfClass:[UILabel class]]) {
            [(UILabel *)v setFont:FONT_BOLD(FONT_SZ_MEDIUM)];
            [(UILabel *)v setTextColor:FG_COLOR];
        }
        else if([v isKindOfClass:[UITextField class]]) {
            [(UITextField *)v setFont:FONT(FONT_SZ_MEDIUM)];
            [(UITextField *)v setTextColor:FG_COLOR];
            [(UITextField *)v setText:@""];
        }
//        else if([v isKindOfClass:[UIView class]]) {
//            [[v layer] setBorderWidth:1];
//            [[v layer] setBorderColor:FG_COLOR.CGColor];
//            [[v layer] setCornerRadius:4];
//        }
        [self configViews:v];
    }
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
