//
//  Save.h
//  Instasave
//
//  Created by Rocco Del Priore on 12/30/12.
//  Copyright (c) 2012 Rocco Del Priore. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Save : NSObject {
    IBOutlet NSTextField *html;
    IBOutlet NSTextField *label1;
    IBOutlet NSTextField *label2;
    IBOutlet NSTextField *label3;
}
-(void)onTick:(NSTimer *)timer;
-(void)saveFolder:(NSString *)sender;
-(void)savePhotos:(NSString *)sender;
-(IBAction)getInfo:(id)sender;

@end
