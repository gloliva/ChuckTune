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


// EDO EDO31(440., 31);
// DiatonicJI dji(440.);

// TriOsc osc1;
// TriOsc osc2;
// TriOsc osc3;

// osc1 => Gain g1(0.1) => dac;
// osc2 => Gain g2(0.1) => dac;
// osc3 => Gain g3(0.1) => dac;

// <<< "12TET" >>>;
// EDO12.freq(1) => osc1.freq;
// EDO12.freq(5) => osc2.freq;
// EDO12.freq(8) => osc3.freq;
// 2::second => now;

// <<< "JI" >>>;
// dji.freq(1) => osc1.freq;
// dji.freq(3) => osc2.freq;
// dji.freq(5) => osc3.freq;
// 2::second => now;

// <<< "31EDO" >>>;
// EDO31.freq(1) => osc1.freq;
// EDO31.freq(11) => osc2.freq;
// EDO31.freq(19) => osc3.freq;

// 2::second => now;