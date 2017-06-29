//
//  Chord.h
//  MIDIFileSequence
//
//  Created by Randy Weinstein on 11/16/14.
//  Copyright (c) 2014 Rockhopper Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Timing.h"

typedef NS_ENUM(NSUInteger, ChordQualities) {
    ChordQualityMajor,
    ChordQualityMinor,
    ChordQualityDiminished,
    ChordQualityAugmented,
    ChordQualityDominant,
    ChordQualitySuspended
};

typedef NS_ENUM(int16_t, ChordExtensions) {
    Six,
    Seven,
    MajorSeven,
    FlatNine,
    Nine,
    SharpNine,
    Eleven,
    SharpEleven,
    FlatThirteen,
    Thirteen
};

@interface Chord : NSObject
@property (nonatomic,assign) int16_t root;
@property (nonatomic,assign) int16_t quality;
@property (nonatomic,strong) NSMutableArray *extensions;
@property (nonatomic,strong) Timing *timing;
@property (nonatomic,assign) BOOL viewable;
@property (nonatomic,assign) BOOL systemSelected;

-(id) initWithRoot:(int16_t) root
        quality:(int16_t) quality
        extension:(NSMutableArray *) extensions
        timing:(Timing*) timing;

- (NSMutableArray *)getChordMembers;
- (int16_t)getBassNote;
- (NSString *)chordSymbol;

@end
