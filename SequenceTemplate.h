//
//  Sequence.h
//  ProtoypeJSONParser
//
//  Created by Weinstein, Randy - Nick.com on 8/18/15.
//  Copyright (c) 2015 com.ihearchanges. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Chord.h"
#import "Progression.h"

@interface SequenceTemplate : NSObject
    @property (nonatomic,strong) NSArray *chordCatalog;
    @property (nonatomic,strong) NSMutableArray *progression;
    @property (nonatomic,strong) Progression *renderedProgression;
    @property (nonatomic,assign) int16_t homeKey;

    - (BOOL)loadTemplate:(NSString *)filePath;
    - (Progression *) generateProgression;

@end
