# hear the changes
An iOS Chord Progression Ear Trainer

**hear the changes** is a chord progression ear trainer for iOS devices that enables listeners to:
* generate a selected type of chord progression that will be a bit different every time it is regenerated
* loop the entire selected progression or any chosen subsection of it for as long as they like
* add and subtract voices from the chords to focus on chosen combinations of voice leading lines
* attempt to identify each chord in the progression individually and get instant feedback on the proposed answer.

Imgagine it to be an infintely patient piano player, tirelessly looping whatever segment of a pre-selected chord progression the user chooses. And letting them identify each chord and carefully study the motion of various voices throughout the selected segment.


The generated chord progressions conform to the rules of functional harmony at several graduated levels of sophistication. 
The sequences could be described as **stochastic** -- random within the constraints of a particular progression's character. 
For example,a progression designed to train the ear to distinguish between a tonic and its most typical dominant chord 
may have generation rules that invaraibly start with the tonic but then randomly select either tonic or dominant for all
other chords in the progression.

The generated chord progressions conform to conventional voice leading rules and are currently only in close position. 
Chords are played on a fender rhodes electric piano at 120 beats per minute, with 4 beats to the bar and one chord per 
bar. 

# Selecting a Progression
On launch, a user is presented a menu of various chord progression types grouped in order of progressive difficulty. 
After the user makes a selection, they are immediately taken to the **Main Display**.

# The Main Display
The **Main Display** has 3 major areas:
* the **Score View**, which represents the selected chord progression 
* the **User Activity View**, which organizes user options for interacting with the chord progression into several activity groups
* the **Activity Selection Menu**, a series of buttons that lets the user quickly move through various activity groups while the chord progression plays and the **Score View** updates

## The Score View
The **Score View** represents the selected chord progression as a simple grid. Each grid cell represents a **measure** in the selected chord progression. The **Score View** has the following features:
* one chord per measure
* the current activity state of each measure indicated by the background color. A yellow background indicates the currently sounding chord.
* the **answer status** of each chord. A **?** indicates that the user has not yet attempted to identify a particular chord.  A **green chord symbol** indicates that the user has correctly identified a particular chord. A **red chord symbol** indicates that the user has incorrectly identified a particular chord. An **orange border** indicates the chord the user has currently selected to identify.

A user can select a particular measure by simply pressing on it. Selection enables the user to identify the chord by using the options presented in the **Answer View** discussed below.

## The User Activity View
The **User Activity View** presents three separate user activity groups:
* the **Playack View**
* the **Sound Mix View**
* the **Answer View**
* the **Information View**

### Playback View
The **Playback View** enables a user to: 
* generate new chord progressions that follow a pre-selected rule set by pressing the **Play/New Progression** button
* set the beginning and ending loop points for the current chord progression by moving the **Loop Setting Slide Controls**
* activate a new loop setting by pressing the **Loop** button

### Sound Mix View
The **Sound Mix View** enables a user to turn various chord *voices* on and off. This enables a user to follow the melody line of a particular sub-group of voices in the chord stack and so attain a more precise understanding of how the various voices move in relation to one another during the chord progression. The *bass voice* is turned off by default. It comes in handy when the user is unable to correctly identify the selected chord. 

### Answer View
The **Answer View** presents three sets of controls that enable the user to enter the assumed identity of the chord playing in the currently selected *measure* in the **Score View**:
* The **chord root controls** are a collection of Roman numerals that identify the root of a chord relative to the home key of the chord progression, which is identified by the Roman numral **I**.
* The **chord quality controls** are a list of the various possible qualitis of a particular chord. These include -- major (M),minor (m), dominant 7 (7), diminished (dim), augmented (aug) and various extensions of these basic chord quality types.
* The **accident controls** enable the user to identify if the current chord is a sharpened or flattened variant of the selected root. For example, a user would select the **"b"** control in conjunction with the **II** control to indicate a flatted second chord. To select a sharp four chord, the user would select the **"#"** control in conjunction with the **IV** control. 


