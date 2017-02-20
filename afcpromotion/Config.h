//
//  Config.h
//  afcpromotion
//
//  Created by Olivier on 15/02/2017.
//  Copyright © 2017 Olivier. All rights reserved.
//

#ifndef Config_h
#define Config_h

#define BUNDLED_DATA
#define REMOTE_PACKAGE_URL  @"http://olivier.huguenot.free.fr/cdv/afcpromotion/data.zip"
#define DATA_FOLDER         @"data"


#define EMAIL_DATABASE      @"emails.csv"
#define MAIL_HOST           @"smtp.gmail.com"
#define MAIL_PORT           (465)
#define MAIL_SENDER         @"olivier.huguenot@gmail.com"
#define MAIL_DISPLAY        @"Spam Hole"
#define MAIL_PASSWORD       @""
#define MAIL_SUBJECT        @"Vos infos sur %@"
#define MAIL_FILE_NAME      @"email.html"


#define INT2F(x)            ((x) * (1.0f / 255))
#define RGBA(r, g, b, a)    [UIColor colorWithRed:(INT2F(r)) green:(INT2F(g)) blue:(INT2F(b)) alpha:(INT2F(a))]
#define ARGB(a, r, g, b)    [UIColor colorWithRed:(INT2F(r)) green:(INT2F(g)) blue:(INT2F(b)) alpha:(INT2F(a))]


#define FG_COLOR            RGBA(31, 31, 31, 255)
#define BG_COLOR            RGBA(244, 244, 241, 255)


#define MCFONT_XLARGE                           [UIFont fontWithName:@"HelveticaNeue-Light" size:[ACUtils isPad] ? 18 : IPHONE_GT5 ? 26 : 20]
#define MCFONT_LARGE                            [UIFont fontWithName:@"HelveticaNeue-Light" size:[ACUtils isPad] ? 16 : IPHONE_GT5 ? 20 : 16]
#define MCFONT_MEDIUM                           [UIFont fontWithName:@"HelveticaNeue-Light" size:[ACUtils isPad] ? 14 : IPHONE_GT5 ? 16 : 14]
#define MCFONT_SMALL                            [UIFont fontWithName:@"HelveticaNeue-Light" size:[ACUtils isPad] ? 12 : IPHONE_GT5 ? 12 : 10]
#define MCFONT_XSMALL                           [UIFont fontWithName:@"HelveticaNeue-Light" size:[ACUtils isPad] ? 10 : IPHONE_GT5 ? 10 : 8]


#endif /* Config_h */
