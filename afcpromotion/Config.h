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
#define FLASH_COLOR         RGBA(111, 26, 107, 1.00)

// ==========================================================================================
// FONTS : modify these fonts if needed, beware of the width !!!
// ==========================================================================================
#define __FONT_BASE                             @"GGalexandra"
#define __FONT_REGULAR                          @"-Regular"
#define __FONT_BOLD                             @"-Bold"
#define __FONT_LITE                             @"-Light"
#define FONT_SZ_XLARGE                          26
#define FONT_SZ_LARGE                           20
#define FONT_SZ_MEDIUM                          16
#define FONT_SZ_SMALL                           12
#define FONT_SZ_XSMALL                          10
#define FONT(sz)                                [UIFont fontWithName:[NSString stringWithFormat:@"%@%@", __FONT_BASE, __FONT_REGULAR] size:(sz)]
#define FONT_BOLD(sz)                           [UIFont fontWithName:[NSString stringWithFormat:@"%@%@", __FONT_BASE, __FONT_BOLD] size:(sz)]
#define FONT_LITE(sz)                           [UIFont fontWithName:[NSString stringWithFormat:@"%@%@", __FONT_BASE, __FONT_LITE] size:(sz)]

#endif /* Config_h */
