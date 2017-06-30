//
//  Sequence.m
//  ProtoypeJSONParser
//
//  Created by Weinstein, Randy - Nick.com on 8/18/15.
//  Copyright (c) 2015 com.ihearchanges. All rights reserved.
//

#import "SequenceTemplate.h"
#import "ChordFunction.h"
#import "Chord.h"

@implementation SequenceTemplate

- (NSArray *)generateProgressionMetaData {
    
    NSMutableArray *theProgression = [[NSMutableArray alloc] init];
    
    NSDictionary *progressionStep;
    
    for ( progressionStep in self.progression) {
        int_fast16_t nextChord = 0;
        
        if ([progressionStep[@"options"] count] > 1) {
            nextChord = (arc4random() % [progressionStep[@"options"] count]);
        }
        
        int16_t chordCatalogIndex =  [progressionStep[@"options"][nextChord] integerValue];
        
        for(int16_t index = 0; index < [self.chordCatalog[chordCatalogIndex] count]; index++)
        {
            ChordFunction *chordFunction = self.chordCatalog[chordCatalogIndex][index];
            int_fast16_t subSelected = (arc4random() % [chordFunction.subs count]);
            NSArray *currentSub = chordFunction.subs[subSelected];
           // NSInteger scaleDegree = currentSub[0];
            [theProgression addObject:@{@"chord":chordFunction.function,
                                        @"beats":progressionStep[@"beats"],
                                        @"scaleDegree":currentSub[0],
                                        @"chordType":currentSub[1],
                                        @"extensions":chordFunction.extensions}];
            
        }        
    }
    
    return theProgression;
    
}



- (Progression *) generateProgression {
    NSArray *progressionMetaData = [self generateProgressionMetaData];
    NSLog(@"%@",progressionMetaData);
    
    Progression *generatedProgression = [[Progression alloc] init];
    generatedProgression.chordProgression = [[NSMutableArray alloc] init];
    
    
    NSDictionary *currentChord;
    int16_t startTime = 0;
    
    
    
    for ( currentChord in progressionMetaData ) {
        
        Chord *newChord = [[Chord alloc] init];
        
        NSNumber  *scaleDegree = currentChord[@"scaleDegree"];
        newChord.root = self.homeKey + [scaleDegree integerValue];
        
        NSLog(@"%@",currentChord[@"chordType"]);
        if ([currentChord[@"chordType"] isEqualToString:@"maj"] ) {
            NSLog(@"chord quality is %lu",(unsigned long)ChordQualityMajor);
            newChord.quality = ChordQualityMajor;
        }
        if ([currentChord[@"chordType"] isEqualToString:@"min"] ) {
            NSLog(@"chord quality is %lu",(unsigned long)ChordQualityMinor);
            newChord.quality = ChordQualityMinor;
        }
        if ([currentChord[@"chordType"] isEqualToString:@"dim"] ) {
            NSLog(@"chord quality is %lu",(unsigned long)ChordQualityDiminished);
            newChord.quality = ChordQualityDiminished;
        }
        if ([currentChord[@"chordType"] isEqualToString:@"aug"] ) {
            NSLog(@"chord quality is %lu",(unsigned long)ChordQualityAugmented);
            newChord.quality = ChordQualityAugmented;
        }
        if ([currentChord[@"chordType"] isEqualToString:@"dom"] ) {
            NSLog(@"chord quality is %lu",(unsigned long)ChordQualityDominant);
            newChord.quality = ChordQualityDominant;
        }
        if ([currentChord[@"chordType"] isEqualToString:@"sus"] ) {
            NSLog(@"chord quality is %lu",(unsigned long)ChordQualitySuspended);
            newChord.quality = ChordQualitySuspended;
        }
        
        Timing *newTiming = [[Timing alloc] init];
        newTiming.startTime = startTime;
        NSNumber *duration = currentChord[@"beats"];
        newTiming.duration = [duration integerValue];
        newChord.timing = newTiming;
        
        startTime += newTiming.duration;
        
        [generatedProgression.chordProgression addObject:newChord];
        
    }
    
    
    return generatedProgression;
}



- (BOOL) loadTemplate:(NSString *)filePath {
    NSString *myJSON = [[NSString alloc] initWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:NULL];
    
    if (!myJSON) {
        NSLog(@"File couldn't be read!");
        return NO;
    }
    
    NSError *error;
    
    NSDictionary *result = [NSJSONSerialization JSONObjectWithData:[myJSON dataUsingEncoding:NSUTF8StringEncoding] options:0 error:&error];
    
    if (!result) {
        return NO;
    }
    
    NSMutableArray *chordCatalog = [[NSMutableArray alloc] init];
    NSArray *transferCatalog = result[@"chordCatalog"];
    for ( int16_t x = 0; x < transferCatalog.count; x++ ) {
        NSMutableArray *chordCatalogStep = [[NSMutableArray alloc] init];
        for (int16_t y=0; y < [transferCatalog[x] count];y++) {
            NSDictionary *dict = transferCatalog[x][y];
            ChordFunction *chordFunction = [[ChordFunction alloc] init];
            chordFunction.function = dict[@"function"];
            chordFunction.extensions = dict[@"extensions"];
            chordFunction.subs = dict[@"subs"];
            [chordCatalogStep addObject:chordFunction];
        }
        [chordCatalog addObject:chordCatalogStep];
    }
    self.chordCatalog = [chordCatalog copy];
    self.progression = result[@"progression"];
    
    return YES;

}

@end
