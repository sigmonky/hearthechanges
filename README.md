# hear the changes
An iOS Chord Progression Ear Trainer

**hear the changes** is a chord progression ear trainer for iOS devices that enables listeners to:
* generate a selected type of chord progression that will be a bit different every time it is regenerated
* loop the entire selected progression or any chosen subsection of it for as long as they like
* add and subtract voices from the chords to focus on chosen combinations of voice leading lines
* attempt to identify each chord in the progression individually and get instant feedback on the proposed answer


The generated chord progressions conform to the rules of functional harmony at several graduated levels of sophistication. 
The sequences could be described as **stochastic** -- random within the constraints of a particular progression's character. 
For example,a progression designed to train the ear to distinguish between a tonic and its most typical dominant chord 
may have generation rules that invaraibly start with the tonic but then randomly select either tonic or dominant for all
other chords in the progression.

The generated chord progressions conform to conventional voice leading rules and are currently only in close position. 
Chords are played on a fender rhodes electric piano at 120 beats per minute, with 4 beats to the bar and one chord per 
bar. 

# Selecting a Progression
On launch, a user is presented a menu of various chord progression type and are grouped in order or progressive difficulty. 
After the user makes a selection, they are immediately taken to the **Main Display**.

# The Main Display
The **Main Display** has 3 major areas. At the top, is the **Score View**, which represents the chord progression and
shows the following:

* one *measure* for each chord
* the current activity state of each measure indicated by the background color. A yellow background indicates the currently sounding chord
* the *answer status* of each chord. A *?* indicates that the user has not yet attempted to identify a particular chord. A 
*green chord symbol* indicates that the user has correctly identified a particular chord. A *red chord symbol* indicates that 
the user has incorrectly identified a particular chord. An orange border indicates the chord the user has currently selected 
for identification.
