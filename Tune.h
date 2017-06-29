//
//  Tune.h
//  MIDIFileSequence
//
//  Created by Weinstein, Randy - Nick.com on 6/11/14.
//  Copyright (c) 2014 Rockhopper Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Tune : NSObject

@property (strong) NSString *title;
@property (strong) NSString *fileName;
@property (strong) NSString *lessonInfo;
+ (NSMutableArray *) theTuneList;
- (id)initWithTitle:(NSString *)title fileName:(NSString *)fileName;
@end
