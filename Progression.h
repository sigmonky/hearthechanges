//
//  Progression.h
//  MIDIFileSequence
//
//  Created by Randy Weinstein on 11/26/14.
//  Copyright (c) 2014 Rockhopper Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Chord.h"

@interface Progression : NSObject
    @property (nonatomic,strong) NSMutableArray *chordProgression;
    - (NSMutableArray *) basicChordProgression;
    - (NSMutableArray *) voicedChordProgression;
    - (NSMutableArray *) bassLine;
    - (NSMutableArray *) arpeggiatedBassLine;
@end
