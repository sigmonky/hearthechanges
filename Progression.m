//
//  Progression.m
//  MIDIFileSequence
//
//  Created by Randy Weinstein on 11/26/14.
//  Copyright (c) 2014 Rockhopper Technologies. All rights reserved.
//

#import "Progression.h"

@implementation Progression

- (NSMutableArray *) basicChordProgression {
    
    NSMutableArray *renderedProgression = [NSMutableArray new];
    int16_t placement = 0;
    int16_t duration = 4;
    for ( int16_t index = 0; index < [self.chordProgression count]; index++) {
        
        Chord *currentChord = self.chordProgression[index];
        
        NSArray *progressionElement = @[
                                        [NSNumber numberWithInt:placement],
                                         [currentChord getChordMembers],
                                         [NSNumber numberWithInt:duration]
                                        ];
        
        [renderedProgression addObject: progressionElement];
         placement += duration;
    }
    
    return renderedProgression;
}

- (NSMutableArray *) voicedChordProgression {
    
    NSMutableArray *renderedProgression = [NSMutableArray new];
    NSMutableArray *lastVoicing = [NSMutableArray new];
    
    int16_t placement = 0;
    int16_t duration = 4;
    
    for ( int16_t index = 0; index < [self.chordProgression count]; index++) {
       Chord *currentChord = self.chordProgression[index];
       NSMutableArray *chordMembers = [currentChord getChordMembers];
        
        if ( index > 0 ) {
            for ( int16_t chordMember = 0; chordMember < chordMembers.count; chordMember++ ) {
                
                int16_t currentChordMember = [chordMembers[chordMember] integerValue ];
                NSLog(@"current chord member %hd",currentChordMember);
               int16_t smallestDifference = 12;
                int16_t differenceFrom;
                for ( int16_t voiceIndex = 0; voiceIndex < lastVoicing.count; voiceIndex++) {
                    NSLog(@"comparing...%ld",[lastVoicing[voiceIndex] integerValue]);
                    int16_t currentDifference = currentChordMember - [lastVoicing[voiceIndex] integerValue];
                    if (abs(currentDifference - 12) < abs(currentDifference) ) {
                        currentDifference = (currentDifference - 12);
                    } else if (abs(currentDifference + 12) < abs(currentDifference)) {
                        currentDifference = (currentDifference + 12);
                    }
                    
                    if ( abs(currentDifference) < abs(smallestDifference)) {
                        smallestDifference = currentDifference;
                        differenceFrom = [lastVoicing[voiceIndex] integerValue];
                    }
                }
                NSLog(@"smallest distance is %hd from %hd",smallestDifference, differenceFrom);
                chordMembers[chordMember] = [[NSNumber alloc] initWithInt:(differenceFrom + smallestDifference)];
            }
        }
        
        NSArray *sortedChordMembers = [chordMembers sortedArrayUsingSelector: @selector(compare:)];
        
        chordMembers = [sortedChordMembers mutableCopy];

        
        lastVoicing = chordMembers;
        NSArray *progressionElement = @[
                                        [NSNumber numberWithInt:currentChord.timing.startTime],
                                        chordMembers,
                                        [NSNumber numberWithInt:currentChord.timing.duration]
                                        ];
        
        [renderedProgression addObject: progressionElement];
        placement += duration;
    
    }
    
    return renderedProgression;
    
}
- (NSMutableArray *) bassLine {
    NSMutableArray *renderedBassLine = [NSMutableArray new];
    int16_t placement = 0;
    int16_t duration = 4;
    
    for ( int16_t index = 0; index < [self.chordProgression count]; index++) {
        Chord *currentChord = self.chordProgression[index];
        
        NSArray *progressionElement = @[
                                        [NSNumber numberWithInt:currentChord.timing.startTime],
                                       @[[NSNumber numberWithInt:[currentChord getBassNote]]],
                                        [NSNumber numberWithInt:currentChord.timing.duration]
                                        ];
        
        
        [renderedBassLine addObject:progressionElement];
        
        placement += 4;
    }
    
    return renderedBassLine;
    
}

- (NSMutableArray *) arpeggiatedBassLine {
    NSMutableArray *renderedBassLine = [NSMutableArray new];
    int16_t placement = 0;
    int16_t duration = 4;
    
    for ( int16_t index = 0; index < [self.chordProgression count]; index++) {
        Chord *currentChord = self.chordProgression[index];
        
        NSArray *progressionElement = @[
                                        [NSNumber numberWithInt:currentChord.timing.startTime],
                                        @[[NSNumber numberWithInt:[currentChord getBassNote]]],
                                        [NSNumber numberWithInt:1.0]
                                        ];
        
        
        [renderedBassLine addObject:progressionElement];
        
        
        NSArray *chordMembers = [currentChord getChordMembers];
        
        int16_t bassAdjust = [chordMembers[1] integerValue] - 24;
        NSNumber *bassAdjusted = [NSNumber numberWithInt:bassAdjust];
        
        progressionElement = @[
                               [NSNumber numberWithInt:currentChord.timing.startTime + 1.0],
                               @[bassAdjusted],
                               [NSNumber numberWithInt:1.0]
                               ];
        
        
        [renderedBassLine addObject:progressionElement];
        
        bassAdjust = [chordMembers[2] integerValue] - 24;
        bassAdjusted = [NSNumber numberWithInt:bassAdjust];
        
        progressionElement = @[
                               [NSNumber numberWithInt:currentChord.timing.startTime + 2.0],
                               @[bassAdjusted],
                               [NSNumber numberWithInt:2.0]
                               ];
        
        
        [renderedBassLine addObject:progressionElement];
        placement += 4;
        
    }
    
    return renderedBassLine;
    
}


@end
