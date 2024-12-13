/*

    TODO: IDEAS
    - [x] Freeze Current band to compare to a different tuning (persists across tunings)
        - [x] Instant Hold + Timed Hold
    - [x] Zoom in and out of bands (and scroll)
    - [ ] Track band from different tuning at same time as current band in-real time (pick closest notes)
    - [ ] Add a blend mode that shows Note names
    - [ ] Add a blend mode that shows interval names between notes
    - [ ] Envelope color when going to and from black
    - [ ] Add color themes
    - [ ] Additional tunings
    - [ ] Support Scala files with notation

*/

@import "background.ck"
@import "bloom.ck"
@import "color.ck"
@import "input.ck"
@import "instrument.ck"
@import "keyboard.ck"
@import "nodes.ck"
@import "themes.ck"
@import "tuning.ck"
@import "ui.ck"
@import "visualizer.ck"


// Window Setup
GWindow.title("ChuckTune");
GWindow.fullscreen();
GWindow.windowSize() => vec2 WINDOW_SIZE;

// Camera
GG.scene().camera() @=> GCamera mainCam;
mainCam.posZ(8.0);

// Background
Color.BLACK => GG.scene().backgroundColor;
Blocker blockLeft(@(-5.03, 0.), @(2., 7.));
Blocker blockRight(@(6.22, 0.), @(2., 7.));
Blocker blockTop(@(0., 3.38), @(10.5, 1.));
Blocker blockBottom(@(0., -1.94), @(10.5, 3.));

Frame topFrame(1.5, 1.36, -0.28);
Frame bottomFrame(-0.12, 1.34, -0.29);

// Bloom
Bloom bloom(2., 0.75);
bloom.radius(1.0);
bloom.levels(4);

// Tunings
FileReader file;
file.parseFile("tunings/5edo.txt") @=> TuningFile file5Edo;
file.parseFile("tunings/7edo.txt") @=> TuningFile file7Edo;
file.parseFile("tunings/12edo.txt") @=> TuningFile file12Edo;
file.parseFile("tunings/19edo.txt") @=> TuningFile file19Edo;
file.parseFile("tunings/24edo.txt") @=> TuningFile file24Edo;
file.parseFile("tunings/31edo.txt") @=> TuningFile file31Edo;
file.parseFile("tunings/pythagorean.txt") @=> TuningFile filePy;
file.parseFile("tunings/meantone.txt") @=> TuningFile fileMeantone;

EDO EDO5(file5Edo, 130.81, 5);
EDO EDO7(file7Edo, 130.81, 7);
EDO EDO12(file12Edo, 130.81, 12);
EDO EDO19(file19Edo, 130.81, 19);
EDO EDO24(file24Edo, 130.81, 24);
EDO EDO31(file31Edo, 130.81, 31);
Pythagorean PY(filePy, 130.81);
Meantone MEANTONE(fileMeantone, 130.81);

[
    EDO12,
    PY,
    MEANTONE,
    EDO19,
    EDO24,
    EDO31,
    EDO5,
    EDO7,
] @=> Tuning tunings[];
TuningManager tuningManager(tunings);
TuningRegister register;

// Instruments
VoiceState state;
Instrument inst(state);

// Visuals
AudioColorMapper colorMapper;
ColorVisualizer primaryVisualizer(tuningManager.getTuning());
primaryVisualizer.setPos(0.6, 0.4, -0.05);
primaryVisualizer.setScale(0.92, 0.8, 1.);
primaryVisualizer.setTuningNamePos(-3.65, 1.11);

ColorVisualizer secondaryVisualizer(tuningManager.getTuning());
secondaryVisualizer.setPos(0.6, 2.05, -0.05);
secondaryVisualizer.setScale(0.92, 0.8, 1.);
secondaryVisualizer.setTuningNamePos(-3.65, 2.74);

// Keyboard and Mouse Input
KeyPoller kp;
Keyboard kb(tuningManager.getTuning(), 0);
Keyboard kb2(tuningManager.getTuning(), 1);
MousePoller mp;

// Themes
ThemeManager themes;
primaryVisualizer.setTheme(themes.getTheme());
secondaryVisualizer.setTheme(themes.getTheme());

// UI
Title title;
TuningSelect tuningUI;
SoundSelect soundUI;
HoldVisualizer holdUI;
BlendSelect blendUI;
MoveVisualizer moveUI;
ThemeSelect themeUI;


while (true) {
    mp.getMouseInfo() @=> MouseInfo mouseInfo;

    // mouseInfo.print();

    // Handle Mouse Clicks
    if (mouseInfo.leftDown == 1) {
        // Update tuning
        tuningUI.checkIfSelected(mouseInfo.pos) => int tuningSelectMode;

        if (tuningSelectMode != 0) {
            tuningManager.changeTuning(tuningSelectMode);
            tuningManager.getTuning() @=> Tuning newTuning;

            // Update everything with new tuning
            kb.updateTuning(newTuning);
            if (secondaryVisualizer.track == 0) {
                kb2.updateTuning(newTuning);
            }
            primaryVisualizer.setTuning(newTuning);
            secondaryVisualizer.setTuning(newTuning);
            tuningUI.setText(newTuning.name);
        }

        if (tuningSelectMode == -1) tuningUI.clickLeft();
        if (tuningSelectMode == 1) tuningUI.clickRight();

        // Update instrument
        soundUI.checkIfSelected(mouseInfo.pos) => int instrumentSelectMode;

        if (instrumentSelectMode != 0) {
            spork ~ inst.changeVoiceInstrument(instrumentSelectMode);
            soundUI.changeName(instrumentSelectMode);
        }

        if (instrumentSelectMode == -1) soundUI.clickLeft();
        if (instrumentSelectMode == 1) soundUI.clickRight();

        // Blend mode
        blendUI.checkIfSelected(mouseInfo.pos) => int blendSelectMode;

        if (blendSelectMode != 0) {
            primaryVisualizer.changeLayer(blendSelectMode);
            secondaryVisualizer.changeLayer(blendSelectMode);
            primaryVisualizer.getLayerType() @=> Text blendText;
            blendUI.setText(blendText.text, blendText.scale);
        }

        if (blendSelectMode == -1) blendUI.clickLeft();
        if (blendSelectMode == 1) blendUI.clickRight();

        // Scale and position handling
        moveUI.checkIfSelected(mouseInfo.pos) => int moveSelectMode;

        if (moveSelectMode == moveUI.LEFT) moveUI.clickLeft();
        if (moveSelectMode == moveUI.RIGHT) moveUI.clickRight();
        if (moveSelectMode == moveUI.PLUS) moveUI.clickPlus();
        if (moveSelectMode == moveUI.MINUS) moveUI.clickMinus();

        // Hold visualizer
        holdUI.checkIfSelected(mouseInfo.pos) => int holdSelectMode;

        if (holdSelectMode == holdUI.HOLD_PRESS && holdUI.trackPressed == 0) {
            holdUI.toggleHold();
            if (holdUI.holdPressed == 1) spork ~ secondaryVisualizer.setHold(holdUI.waitTime);
            if (holdUI.holdPressed == 0) {
                secondaryVisualizer.releaseHold();
                secondaryVisualizer.setTuning(tuningManager.getTuning());
            }
        } else if (holdSelectMode == holdUI.TRACK_PRESS && holdUI.holdPressed == 0) {
            // track
            holdUI.toggleTrack();
            if (holdUI.trackPressed == 1) secondaryVisualizer.setTrack();
            if (holdUI.trackPressed == 0) {
                secondaryVisualizer.releaseTrack();
                secondaryVisualizer.setTuning(tuningManager.getTuning());
                kb2.updateTuning(tuningManager.getTuning());
            }
        } else if (holdSelectMode != 0 && holdSelectMode != holdUI.HOLD_PRESS && holdSelectMode != holdUI.TRACK_PRESS) {
            holdUI.resetTime();
            holdUI.updateTime(holdSelectMode);
        }

        // Update theme
        themeUI.checkIfSelected(mouseInfo.pos) => int themeSelectMode;

        if (themeSelectMode != 0) {
            themes.changeTheme(themeSelectMode);
            themeUI.setText(themes.getThemeName());
            themes.getTheme() @=> Theme currTheme;

            // Update themes for each UI element
            title.setTheme(currTheme);
            tuningUI.setTheme(currTheme);
            blendUI.setTheme(currTheme);
            holdUI.setTheme(currTheme);
            moveUI.setTheme(currTheme);
            soundUI.setTheme(currTheme);
            themeUI.setTheme(currTheme);

            // Update theme for keyboard
            kb.setTheme(currTheme);

            // Visualizer theme
            primaryVisualizer.setTheme(currTheme);
            secondaryVisualizer.setTheme(currTheme);

            // Update background color
            blockLeft.setTheme(currTheme.background);
            blockRight.setTheme(currTheme.background);
            blockTop.setTheme(currTheme.background);
            blockBottom.setTheme(currTheme.background);

            topFrame.setTheme(currTheme.secondary);
            bottomFrame.setTheme(currTheme.secondary);
        }

        if (themeSelectMode == -1) themeUI.clickLeft();
        if (themeSelectMode == 1) themeUI.clickRight();
    }

    if (mouseInfo.leftHeld == 1) {
        // Scale and position handling
        if (moveUI.leftButtonPressed == 1) {
            primaryVisualizer.translate(-0.05);
            secondaryVisualizer.translate(-0.05);
        } else if (moveUI.rightButtonPressed == 1) {
            primaryVisualizer.translate(0.05);
            secondaryVisualizer.translate(0.05);
        } else if (moveUI.plusButtonPressed == 1) {
            primaryVisualizer.scaleWidth(0.05);
            secondaryVisualizer.scaleWidth(0.05);

            primaryVisualizer.updateNoteScale();
            secondaryVisualizer.updateNoteScale();
        } else if (moveUI.minusButtonPressed == 1) {
            primaryVisualizer.scaleWidth(-0.05);
            secondaryVisualizer.scaleWidth(-0.05);

            primaryVisualizer.updateNoteScale();
            secondaryVisualizer.updateNoteScale();
        }
    }

    if (mouseInfo.leftUp == 1) {
        if (tuningUI.leftButtonPressed == 1) tuningUI.resetLeft();
        if (tuningUI.rightButtonPressed == 1) tuningUI.resetRight();

        if (soundUI.leftButtonPressed == 1) soundUI.resetLeft();
        if (soundUI.rightButtonPressed == 1) soundUI.resetRight();

        if (blendUI.leftButtonPressed == 1) blendUI.resetLeft();
        if (blendUI.rightButtonPressed == 1) blendUI.resetRight();

        if (moveUI.leftButtonPressed == 1) moveUI.resetLeft();
        if (moveUI.rightButtonPressed == 1) moveUI.resetRight();
        if (moveUI.plusButtonPressed == 1) moveUI.resetPlus();
        if (moveUI.minusButtonPressed == 1) moveUI.resetMinus();

        if (themeUI.leftButtonPressed == 1) themeUI.resetLeft();
        if (themeUI.rightButtonPressed == 1) themeUI.resetRight();
    }

    // Handle Key presses
    kp.getKeyPress() @=> Key keysDown[];
    for (Key key : keysDown) {
        // Set frequency
        kb.getFreq(key.key) => float freq;
        inst.voiceOn(key.key, freq);

        // Handle key press
        colorMapper.freqToColor( register, freq ) @=> vec3 keyColor;
        kb.visuals.setKeyColor(keyColor, Color.WHITE * 4, key.keyRow, key.keyCol);
        kb.visuals.pressKey(key.keyRow, key.keyCol);

        // Map to visual spectrum
        colorMapper.freqToShard( register, freq ) => int shardCenter;
        kb.getNoteName(key.keyRow, key.keyCol) => string note;
        kb.getNoteDiff(key.key) => int noteDiff;
        primaryVisualizer.addPane(key.key, keyColor, shardCenter, note, noteDiff);

        if (secondaryVisualizer.track == 0) {
            secondaryVisualizer.addPane(key.key, keyColor, shardCenter, note, noteDiff);
        } else {
            // Handle secondary Visualizer
            kb2.getClosestMatchingFreq(freq) @=> Note secondNote;
            colorMapper.freqToColor( register, secondNote.freq ) @=> vec3 secondKeyColor;
            colorMapper.freqToShard( register, secondNote.freq ) => int secondShardCenter;
            secondaryVisualizer.addPane(key.key, secondKeyColor, secondShardCenter, secondNote.name, secondNote.degree);
        }
    }

    kp.getKeyRelease() @=> Key keysUp[];
    for (Key key : keysUp) {
        inst.voiceOff(key.key);
        kb.visuals.setKeyColor(themes.getTheme().primary, Color.WHITE * 2., key.keyRow, key.keyCol);
        kb.visuals.releaseKey(key.keyRow, key.keyCol);
        primaryVisualizer.removePane(key.key);
        secondaryVisualizer.removePane(key.key);
    }

    primaryVisualizer.update();
    secondaryVisualizer.update();

    GG.nextFrame() => now;
    // UI
    // if (UI.begin("ChuckTune")) {
    //     // show a UI display of the current scenegraph
    //     UI.scenegraph(GG.scene());
    // }
    // UI.end();
}
