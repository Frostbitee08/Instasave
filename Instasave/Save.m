//
//  Save.m
//  Instasave
//
//  Created by Rocco Del Priore on 12/30/12.
//  Copyright (c) 2012 Rocco Del Priore. All rights reserved.
//

#import "Save.h"

@implementation Save

-(void)onTick:(NSTimer *)timer {
    NSString *empty = @"";
    NSString *label1place = @"1. Enter an Instagram URL";
    NSString *label2place = @"2. Click Save to download the photo";
    NSString *check = [html stringValue];
    if ([check rangeOfString:@"instagram.com"].location != NSNotFound) {
        [label1 setStringValue:@""];
        [label1 display];
        [label2 setStringValue:label2place];
        [label2 display];
    }
    else if([[html stringValue] isEqualToString:empty]) {
        [label1 setStringValue:label1place];
        [label1 display];
        [label2 setStringValue:@""];
        [label2 display];
    }
}

-(id) init {
    NSTimer *t = [NSTimer scheduledTimerWithTimeInterval: .5
                                                  target: self
                                                selector:@selector(onTick:)
                                                userInfo: nil repeats:YES];
    NSRunLoop *runner = [NSRunLoop currentRunLoop];
    [runner addTimer: t forMode: NSDefaultRunLoopMode];
    
    return self;
}
-(void)saveFolder:(NSString *)htmlLink {
    //Get source string of source code
    NSURL *profileUrl = [NSURL URLWithString:htmlLink];
    NSData *profileText = [NSData dataWithContentsOfURL:profileUrl];
    NSString *sourceString = [[NSString alloc] initWithData:profileText encoding:NSASCIIStringEncoding];
    NSString *sourceString2 = [NSString stringWithString:sourceString];
    
    //Loop through and save photos
    NSMutableArray *arrayOne = [[NSMutableArray alloc] init];
    int i = 0;
    int k = 0;
    while (i == 0) {
        //Check if aLink exist
        if ([sourceString rangeOfString:@"distilleryimage"].location != NSNotFound) {
            //get link for saving
            for (unsigned int f =0; f<2; f++) {
                NSRange linkBegin1 = [sourceString rangeOfString:@"distilleryimage"];
                sourceString = [sourceString substringFromIndex:linkBegin1.location+15];
            }
            NSRange linkBegin = [sourceString rangeOfString:@"distilleryimage"];
            NSRange linkEnd = [sourceString rangeOfString:@"_7.jpg"];
            NSString *aLink=[sourceString substringWithRange:NSMakeRange(linkBegin.location, linkEnd.location-linkBegin.location)];
            NSString *save = @"http://";
            save = [save stringByAppendingString:aLink];
            save = [save stringByAppendingString:@"_7.jpg"];
            
            //Get rid of backslash
            NSMutableString *save2 = [NSMutableString stringWithString:save];
            NSRange backSlash = [save2 rangeOfString:@".com"];
            [save2 deleteCharactersInRange:NSMakeRange(backSlash.location+4, 1)];
            
            //Save to array
            arrayOne[k] = save2;
            k = k +1;
            
            //Delete the original
            //i = 1;
            sourceString = [sourceString substringFromIndex:linkEnd.location];
            //sourceString = [sourceString substringWithRange:NSMakeRange(linkBegin.location + (linkEnd.location - linkBegin.location) , [sourceString length]-(linkBegin.location + (linkEnd.location - linkBegin.location)))];
        }
        //End loop
        else {
            i = 1;
        }
    }
    
    //Get Folder Name
    NSRange linkBegin2 = [sourceString2 rangeOfString:@"full_name"];
    sourceString2 = [sourceString2 substringFromIndex:linkBegin2.location];
    NSRange linkEnd2 = [sourceString2 rangeOfString:@","];
    linkBegin2 = [sourceString2 rangeOfString:@"full_name"];
    NSString *photoName = [sourceString2 substringWithRange:NSMakeRange(linkBegin2.location+12, linkEnd2.location-linkBegin2.location-13)];
    NSString *folderName = [photoName stringByAppendingString:@"'s Instagram/"];

    //Create Folder
    NSString *FNPath = NSHomeDirectory();
    FNPath = [FNPath stringByAppendingString:@"/Desktop/"];
    FNPath = [FNPath stringByAppendingString:folderName];
    NSFileManager *fileManager= [NSFileManager defaultManager];
    if(![fileManager fileExistsAtPath:FNPath isDirectory:nil]) {
        if(![fileManager createDirectoryAtPath:FNPath withIntermediateDirectories:YES attributes:nil error:NULL]) {
            NSLog(@"Error: Create folder failed %@", FNPath);
        }
    }
    
    //Loop through array and save photos
    [label1 setStringValue:@""];
    [label1 display];
    [label2 setStringValue:@""];
    [label2 display];
    int c = [arrayOne count];
    for (unsigned int j = 0; j<c; j++) {
        //Make save path and save Image
        int v = j+1;
        NSString *lable3value = [NSString stringWithFormat:@"3. Downloading photo %d of %d", v, c];
        [label1 setStringValue:@""];
        [label1 display];
        [label2 setStringValue:@""];
        [label2 display];
        [label3 setStringValue:lable3value];
        [label3 display];
        NSURL *imageUrl = [NSURL URLWithString:arrayOne[j]];
        NSData *imageData = [NSData dataWithContentsOfURL:imageUrl];
        NSString *NewPhotoName = [photoName stringByAppendingString:@" - "];
        NSString *countString = [NSString stringWithFormat:@"%d", v];
        NewPhotoName = [NewPhotoName stringByAppendingString:countString];
        NewPhotoName = [NewPhotoName stringByAppendingString:@".jpg"];
        NSString *almost = [FNPath stringByAppendingString:NewPhotoName];
        [fileManager createFileAtPath:almost contents:imageData attributes:nil];
    }
    
    //Create Alert
    NSAlert *done = [[NSAlert alloc] init];
    [done addButtonWithTitle:@"Okay"];
    [done setMessageText:@"Instasave"];
    [done setInformativeText:[NSString stringWithFormat:@"%d photos saved to your desktop!", c]];
    [done setAlertStyle:NSInformationalAlertStyle];
     NSImage *appIcon = [NSImage imageNamed:@"InstAppIcon"];
    [done setIcon:appIcon];
    [done runModal];
    
    //Change all Labels
    [label1 setStringValue:@"1. Enter an Instagram URL"];
    [label1 display];
    [label2 setStringValue:@""];
    [label2 display];
    [label3 setStringValue:@""];
    [label3 display];
    [html setStringValue:@""];
    [html display];
}

-(void)savePhotos:(NSString *)htmlLink {
    //"display_src":"
    //Change tag to Done!
    NSString *label1place = @"1. Enter an Instagram URL";
    [label1 setStringValue:@""];
    [label1 display];
    [label2 setStringValue:@""];
    [label2 display];
    [label3 setStringValue:@"3. Done!"];
    [label3 display];
    
    //Get HTML Data
    NSURL *url = [NSURL URLWithString:htmlLink];
    NSData *webText = [NSData dataWithContentsOfURL:url];
    NSString *forShits = [[NSString alloc] initWithData:webText encoding:NSASCIIStringEncoding];
    
    
    //Make Image Link
    NSRange match = [forShits rangeOfString:@"display_src"];
    NSString *temp = [forShits substringWithRange:NSMakeRange(match.location, forShits.length - (match.location))];
    NSRange match1 = [temp rangeOfString: @".jpg"];
    temp = [temp substringWithRange:NSMakeRange(14, match1.location - 14)];
    NSString *imageLink = [temp stringByAppendingString:@".jpg"];
    imageLink = [imageLink stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    imageLink = [imageLink stringByReplacingOccurrencesOfString:@"%5C" withString:@""];
    
    //Photo Name
    NSRange match3 = [forShits rangeOfString:@"<meta property=\"og:description\" content=\""];
    temp = [forShits substringWithRange:NSMakeRange(match3.location, forShits.length - (match3.location))];
    NSRange match4 = [temp rangeOfString:@"'s"];
    NSString *userName = [temp substringWithRange:NSMakeRange(41, match4.location - 41)];
    NSString *photoName = [userName stringByAppendingString:@" - "];
    
    NSString *directory = NSHomeDirectory();
    NSString *desktop = [directory stringByAppendingString:@"/Desktop/"];
    
    NSError *error;
    NSArray * directoryContents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:desktop error:&error];
    
    NSString *photoNameFinal;
    int count = 1;
    NSString *countString = [NSString stringWithFormat:@"%d", count];
    photoNameFinal = [photoName stringByAppendingString:countString];
    photoNameFinal = [photoNameFinal stringByAppendingString:@".jpg"];
    for (NSString *someString in directoryContents) {
        if ([someString rangeOfString:photoName].location != NSNotFound) {
            NSRange m1 = [someString rangeOfString: @"- "];
            NSRange m2 = [someString rangeOfString: @".jpg"];
            NSString *number = [someString substringWithRange:NSMakeRange(m1.location + 2, m2.location - 2 - (m1.location))];
            NSInteger val = [number integerValue];
            val = val + 1;
            NSString *countString = [NSString stringWithFormat:@"%ld", val];
            photoNameFinal = [photoName stringByAppendingString:countString];
            photoNameFinal = [photoNameFinal stringByAppendingString:@".jpg"];
        }
    }

    
    //Initiate NSFileManager to save image
    NSFileManager *fm = [NSFileManager defaultManager];
    NSURL *imageUrl = [NSURL URLWithString:imageLink];
    NSData *imageData = [NSData dataWithContentsOfURL:imageUrl];

    
    //Make save path and save Image
    NSImage *appIcon = [NSImage imageNamed:@"InstAppIcon"];
    NSString *almost = [desktop stringByAppendingString:photoNameFinal];
    [fm createFileAtPath:almost contents:imageData attributes:nil];
    
    
    //Create Alert
    NSAlert *done = [[NSAlert alloc] init];
    [done addButtonWithTitle:@"Okay"];
    [done setMessageText:@"Instasave"];
    [done setInformativeText:@"1 photo saved to your desktop!"];
    [done setAlertStyle:NSInformationalAlertStyle];
    [done setIcon:appIcon];
    [done runModal];
    
    //Change all Labels
    [label1 setStringValue:label1place];
    [label1 display];
    [label2 setStringValue:@""];
    [label2 display];
    [label3 setStringValue:@""];
    [label3 display];
    [html setStringValue:@""];
    [html display];
}

-(IBAction)getInfo:(id)sender {
    NSString *http = @"http://";
    NSString *input = [html stringValue];
    if ([input rangeOfString:@"instagram.com/p/"].location != NSNotFound) {
        NSLog(@"Link of Picture");
        
        //Make sure http has been added
        if ([input rangeOfString:http].location == NSNotFound) {
            input = [http stringByAppendingString:input];
        }
        //Send to savePhotos
        [self savePhotos:input];
    }

    else if ([input rangeOfString:@"instagram.com/"].location != NSNotFound && [input rangeOfString:@"http://instagram.com/p/"].location == NSNotFound) {
        NSLog(@"Instagram Link");
        
        //Make sure http has been added
        if ([input rangeOfString:http].location == NSNotFound) {
            input = [http stringByAppendingString:input];
        }
        
        //Send to saveFolders
        [self saveFolder:input];
        
    }
}
    
@end
