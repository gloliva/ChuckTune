@import "bloom.ck"
@import "color.ck"
@import "input.ck"
@import "instrument.ck"
@import "keyboard.ck"
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
file.parseFile("tunings/12edo.txt") @=> TuningFile file12Edo;
EDO EDO12(file12Edo, 440., 12);
TuningRegister register;

// Instruments
VoiceState state;
Instrument inst(state);

// Visuals
AudioColorMapper colorMapper;
ColorVisualizer visualizer(EDO12);

// Keyboard and Input
KeyPoller kp;
Keyboard kb(file12Edo);

// ColorPane Test
// ColorPane paneTest(3);
// paneTest.setColorGradient(Color.RED * 3, Color.BLUE * 3);
// paneTest.setPos(0., 1.5, 0.);
// paneTest.attach();


while (true) {
    kp.getKeyPress() @=> Key keysDown[];

    for (Key key : keysDown) {
        <<< "Note on", key.key >>>;

        kb.getMidiNote(key.key) => int note;
        inst.voiceOn(key.key, note);
        colorMapper.freqToColor( register, inst.getVoice(key.key).freq() ) @=> vec3 keyColor;
        kb.visuals.setKeyColor(keyColor, Color.BLACK, key.keyRow, key.keyCol);

        kb.getNoteDiff(key.key) => int noteDiff;
        visualizer.addPane(key.key, keyColor, noteDiff);
    }


    kp.getKeyRelease() @=> Key keysUp[];
    for (Key key : keysUp) {
        <<< "Note off", key.key >>>;

        inst.voiceOff(key.key);
        kb.visuals.setKeyColor(Color.BLACK, Color.WHITE * 2., key.keyRow, key.keyCol);
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
