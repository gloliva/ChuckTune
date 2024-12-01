@import "bloom.ck"
@import "color.ck"
@import "input.ck"
@import "instrument.ck"
@import "keyboard.ck"
@import "nodes.ck"
@import "tuning.ck"
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

// Bloom
Bloom bloom(1.5, 0.75);
bloom.radius(1.0);
bloom.levels(4);

// Tunings
FileReader file;
file.parseFile("tunings/5edo.txt") @=> TuningFile file5Edo;
file.parseFile("tunings/7edo.txt") @=> TuningFile file7Edo;
file.parseFile("tunings/12edo.txt") @=> TuningFile file12Edo;
file.parseFile("tunings/19edo.txt") @=> TuningFile file19Edo;
file.parseFile("tunings/pythagorean.txt") @=> TuningFile filePy;

EDO EDO5(file5Edo, 130.81, 5);
EDO EDO7(file7Edo, 130.81, 7);
EDO EDO12(file12Edo, 130.81, 12);
EDO EDO19(file19Edo, 130.81, 19);
Pythagorean PY(filePy, 130.81);

TuningRegister register;

// Instruments
VoiceState state;
Instrument inst(state);

// Visuals
AudioColorMapper colorMapper;
ColorVisualizer visualizer(PY);
visualizer.setPos(0., 1.5, 0.);

// Keyboard and Input
KeyPoller kp;
Keyboard kb(PY);

// Node Test
Node node("A#", Color.BLUE);


while (true) {
    kp.getKeyPress() @=> Key keysDown[];

    for (Key key : keysDown) {
        kb.getFreq(key.key) => float freq;
        inst.voiceOn(key.key, freq);

        colorMapper.freqToColor( register, freq ) @=> vec3 keyColor;
        kb.visuals.setKeyColor(keyColor, Color.WHITE * 4, key.keyRow, key.keyCol);
        kb.visuals.pressKey(key.keyRow, key.keyCol);

        kb.getNoteDiff(key.key) => int noteDiff;
        visualizer.addPane(key.key, keyColor, noteDiff);
    }


    kp.getKeyRelease() @=> Key keysUp[];
    for (Key key : keysUp) {
        inst.voiceOff(key.key);
        kb.visuals.setKeyColor(Color.BLACK, Color.WHITE * 2., key.keyRow, key.keyCol);
        kb.visuals.releaseKey(key.keyRow, key.keyCol);
        visualizer.removePane(key.key);
    }

    visualizer.update();

    GG.nextFrame() => now;
    // UI
    if (UI.begin("ChuckTune")) {
        // show a UI display of the current scenegraph
        UI.scenegraph(GG.scene());
    }
    UI.end();
}
