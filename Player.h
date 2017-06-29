//
//  Player.h
//  MIDIFileSequence
//
//  Created by Randy Weinstein on 11/26/14.
//  Copyright (c) 2014 Rockhopper Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Player : NSObject
@property (nonatomic,strong) NSString *instrument;
@property (nonatomic,strong) NSNumber *midiInstrument;
@property (nonatomic,strong) NSMutableArray *performance;
@end


