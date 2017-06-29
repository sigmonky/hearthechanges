//
//  Tune.m
//  MIDIFileSequence
//
//  Created by Weinstein, Randy - Nick.com on 6/11/14.
//  Copyright (c) 2014 Rockhopper Technologies. All rights reserved.
//

#import "Tune.h"

@implementation Tune
+ (NSMutableArray *) theTuneList {
    NSMutableArray *tunes = [[NSMutableArray alloc] init];
    
    Tune *newTune;
    
    newTune = [[Tune alloc] initWithTitle:@"Tonic-Dominant 1"
                                 fileName:@"I-V-1"];
    
   newTune.lessonInfo = @"The tonic to dominant harmonic progression is both quite common and fundamental to functional harmony. It describes the most basic harmonic motion between states of tension and rest. The ear hears the tonic chord as a state of rest while the dominant is heard as a state of tension.\n\n     The numerical designation of the tonic chord is 1 and the dominant is 5. The Roman numerals conventionally used to indicate tonic and dominant are I and V respectively.\n\n     This exericise is an eight measure progression starting on the I chord, followed by a V chord. These two opening chords are followed by a randomly generated set of 6 chords that will be either a I or a V chord. \n\n     After starting playback, listen to the eight bar progression as many times as needed for you to hear which chords are tonic and which are dominant. When you think you can hear the progression, touch the blue measure bars to reveal the chord identities. Of course, you can reveal them any time you like. The challenge level is up to you.";
    
    [tunes addObject:newTune];
    
    newTune = [[Tune alloc] initWithTitle:@"Subdominant-Tonic 1"
                                 fileName:@"I-IV-1" ];
    
    
    
    [tunes addObject:newTune];
    
    newTune = [[Tune alloc] initWithTitle:@"Dominant-Tonic 2"
                                 fileName:@"I-V-2"];
    
    [tunes addObject:newTune];
    
    newTune = [[Tune alloc] initWithTitle:@"Subdominant-Tonic 2"
                                 fileName:@"I-IV-2"];
    
    [tunes addObject:newTune];
    
    newTune = [[Tune alloc] initWithTitle:@"Dominant-Tonic 3"
                                 fileName:@"I-V-3"];
    
    [tunes addObject:newTune];
    
    newTune = [[Tune alloc] initWithTitle:@"Subdominant-Tonic 3"
                                 fileName:@"I-IV-3"];
    
    [tunes addObject:newTune];
    
    newTune = [[Tune alloc] initWithTitle:@"Dominant-Tonic 4"
                                 fileName:@"I-V-4"];
    
    [tunes addObject:newTune];
    
    newTune = [[Tune alloc] initWithTitle:@"Subdominant-Tonic 4"
                                 fileName:@"I-IV-4"];
    
    [tunes addObject:newTune];

    
    newTune = [[Tune alloc] initWithTitle:@"Tonic-Subdominant-Dominant 1"
                                         fileName:@"I-IV-V-1"];
    
    [tunes addObject:newTune];
    
    newTune = [[Tune alloc] initWithTitle:@"Tonic-Subdominant-Dominant 2"
                                 fileName:@"I-IV-V-2"];
    
    [tunes addObject:newTune];
    
    newTune = [[Tune alloc] initWithTitle:@"Tonic-Subdominant-Dominant 3"
                                 fileName:@"I-IV-V-3"];
    
    [tunes addObject:newTune];
    
    newTune = [[Tune alloc] initWithTitle:@"Tonic-Subdominant-Dominant 4"
                                 fileName:@"I-IV-V-4"];
    
    [tunes addObject:newTune];
    
    newTune = [[Tune alloc] initWithTitle:@"Tonic-Subdominant-Dominant 5"
                                 fileName:@"I-IV-V-5"];
    
    [tunes addObject:newTune];
    
    newTune = [[Tune alloc] initWithTitle:@"Tonic-Subdominant-Dominant 6"
                                 fileName:@"I-IV-V-6"];
    
    [tunes addObject:newTune];
    
    newTune = [[Tune alloc] initWithTitle:@"Tonic-Subdominant-Dominant 7"
                                 fileName:@"I-IV-V-7"];
    
    [tunes addObject:newTune];
    
    
    newTune = [[Tune alloc] initWithTitle:@"Tonic-Subdominant-Dominant 8"
                                 fileName:@"I-IV-V-8"];
    
    [tunes addObject:newTune];
    
    newTune = [[Tune alloc] initWithTitle:@"Tonic-Subdominant-Dominant 9"
                                 fileName:@"I-IV-V-9"];
    
    [tunes addObject:newTune];
    

    newTune = [[Tune alloc] initWithTitle:@"secondary dominants 1"
                                 fileName:@"secondaryDominants1"];
    
    [tunes addObject:newTune];
    
    newTune = [[Tune alloc] initWithTitle:@"secondary dominants 2"
                                 fileName:@"secondaryDominants2"];
    
    [tunes addObject:newTune];
    
    newTune = [[Tune alloc] initWithTitle:@"key modulations 1"
                                 fileName:@"keymodulations-1"];
    
    [tunes addObject:newTune];
    
    newTune = [[Tune alloc] initWithTitle:@"key modulations 2"
                                 fileName:@"keymodulations-2"];
    
    [tunes addObject:newTune];
    
    newTune = [[Tune alloc] initWithTitle:@"key modulations 3"
                                 fileName:@"keymodulations-3"];
    
    [tunes addObject:newTune];
    
    newTune = [[Tune alloc] initWithTitle:@"key modulations 4"
                                 fileName:@"keymodulations-4"];
    
    [tunes addObject:newTune];
    
    newTune = [[Tune alloc] initWithTitle:@"minor folk songs"
                                 fileName:@"minorfolk"];
    
    [tunes addObject:newTune];
    
    newTune = [[Tune alloc] initWithTitle:@"No More Cane"
                                 fileName:@"nomorecane"];
    
    [tunes addObject:newTune];
    
    newTune = [[Tune alloc] initWithTitle:@"Cadences 1"
                                 fileName:@"cadences1"];
    
    [tunes addObject:newTune];
    
    newTune = [[Tune alloc] initWithTitle:@"Cadences 2"
                                 fileName:@"cadences2"];
    
    [tunes addObject:newTune];
    
    newTune = [[Tune alloc] initWithTitle:@"Cadences 3"
                                 fileName:@"cadences3"];
    
    [tunes addObject:newTune];
    
    
    return tunes;
}





- (id)initWithTitle:(NSString *)title fileName:(NSString *)fileName {
    if ((self = [super init])) {
        _title = title;
        _fileName = fileName;
    }
    return self;
}


@end
