public class VoiceState {
    static int FREE;
    static int BUSY;

    fun @construct() {
        0 => this.FREE;
        1 => this.BUSY;
    }
}


public class VoiceSelect {
    Osc oscVoices[];
    FM fmVoices[];
    Gain gains[];
    Envelope envUp(500::ms);
    Envelope envDown(500::ms);
    Gain mix;

    int numVoices;
    int currVoice;

    string names[];

    fun @construct() {

        this.envUp => blackhole;
        this.envDown => blackhole;

        [
            new SinOsc(),
            new TriOsc(),
            new SawOsc(),
            new SqrOsc(),
        ] @=> this.oscVoices;

        [
            new FMVoices(),
            new KrstlChr(),
            new FrencHrn(),
            new PercFlut(),
            new HnkyTonk(),
            new BeeThree(),
        ] @=> this.fmVoices;

        [
            new Gain(1.5),
            new Gain(2.2),
            new Gain(0.7),
            new Gain(0.6),
            new Gain(1.2),
            new Gain(2.2),
            new Gain(1.8),
            new Gain(4.2),
            new Gain(3.),
            new Gain(3.),
        ] @=> this.gains;

        [
            "SinOsc",
            "TriOsc",
            "SawOsc",
            "SqrOsc",
            "Voices",
            "Choir",
            "Horn",
            "Flute",
            "HT Piano",
            "Hammond",
        ] @=> this.names;

        this.oscVoices.size() + this.fmVoices.size() => this.numVoices;
        0 => currVoice;
        0.4 => this.mix.gain;

        // Hook up to Mix
        for (int idx; idx < this.oscVoices.size(); idx++) {
            this.oscVoices[idx] => this.gains[idx] => this.mix;
            0. => this.oscVoices[idx].gain;
        }

        for (int idx; idx < this.fmVoices.size(); idx++) {
            this.fmVoices[idx] => this.gains[idx + this.oscVoices.size()] => this.mix;
            this.fmVoices[idx].noteOn(1.);
            0. => this.fmVoices[idx].gain;
        }
    }

    fun void set(int idx) {
        this.currVoice => int prevVoice;
        idx % this.numVoices => this.currVoice;

        // Set prevGain
        if (prevVoice < this.oscVoices.size()) {
            0. => this.oscVoices[prevVoice].gain;
        } else {
            0. => this.fmVoices[prevVoice - this.oscVoices.size()].gain;
        }

        // Set currGain
        if (this.currVoice < this.oscVoices.size()) {
            1. => this.oscVoices[this.currVoice].gain;
        } else {
            1. => this.fmVoices[this.currVoice - this.oscVoices.size()].gain;
        }
    }

    fun void select(int idx) {
        this.currVoice => int prevVoice;
        idx % this.numVoices => this.currVoice;

        // CrossFade between voices
        now + 500::ms => time end;

        0. => this.envUp.value;
        1. => this.envDown.value;

        this.envUp.ramp(500::ms, 1.);
        this.envDown.ramp(500::ms, 0.);

        while (now < end) {
            this.envDown.value() => float envDownVal;
            this.envUp.value() => float envUpVal;

            if (prevVoice < this.oscVoices.size()) {
                envDownVal => this.oscVoices[prevVoice].gain;
            } else {
                envDownVal => this.fmVoices[prevVoice - this.oscVoices.size()].gain;
            }

            if (this.currVoice < this.oscVoices.size()) {
                envUpVal => this.oscVoices[this.currVoice].gain;
            } else {
                envUpVal => this.fmVoices[this.currVoice - this.oscVoices.size()].gain;
            }

            50::ms => now;
        }

        // Set prevGain
        if (prevVoice < this.oscVoices.size()) {
            0. => this.oscVoices[prevVoice].gain;
        } else {
            0. => this.fmVoices[prevVoice - this.oscVoices.size()].gain;
        }

        // Set currGain
        if (this.currVoice < this.oscVoices.size()) {
            1. => this.oscVoices[this.currVoice].gain;
        } else {
            1. => this.fmVoices[this.currVoice - this.oscVoices.size()].gain;
        }
    }

    fun void change(int diff) {
        this.currVoice + diff => int newVoice;

        if (newVoice < 0) {
            newVoice + this.numVoices => newVoice;
        }

        newVoice % this.numVoices => newVoice;

        this.select(newVoice);
    }

    fun string name() {
        return this.names[this.currVoice];
    }

    fun void freq(float f) {
        for (Osc osc : this.oscVoices) {
            f => osc.freq;
        }

        for (FM fm : this.fmVoices) {
            f => fm.freq;
        }
    }

    fun float freq() {
        return this.oscVoices[this.currVoice].freq();
    }
}


public class Voice {
    VoiceSelect voice;
    Gain g;
    Envelope env;
    NRev rev;

    fun @construct() {
        Voice(0);
    }

    fun @construct(int voiceSelect) {
        this.voice.mix => this.g => this.env => this.rev => dac;
        this.set(voiceSelect);

        100::ms => this.env.duration;
        0.1 => this.g.gain;
        0.1 => this.rev.mix;
    }

    fun float freq() {
        return this.voice.freq();
    }

    fun void freq(float f) {
        f => this.voice.freq;
    }

    fun void set(int idx) {
        this.voice.set(idx);
    }

    fun void select(int idx) {
        this.voice.select(idx);
    }

    fun void change(int diff) {
        this.voice.change(diff);
    }

    fun string name() {
        return this.voice.name();
    }

    fun int numVoices() {
        return this.voice.numVoices;
    }

    fun void on() {
        this.env.keyOn();

    }

    fun void off() {
        this.env.keyOff();
    }
}


public class Instrument {
    Voice voices[10];
    int voiceState[10];
    int keyMap[0];

    VoiceState @ state;

    fun @construct(VoiceState state) {
        state @=> this.state;
    }

    fun int findOpenVoice() {
        for (int idx; idx < this.voiceState.size(); idx++) {
            if (this.voiceState[idx] == state.FREE) {
                return idx;
            }
        }

        return -1;
    }

    fun void setVoiceInstrument(int voiceSelect) {
        for (Voice voice : this.voices) {
            voice.select(voiceSelect);
        }
    }

    fun void changeVoiceInstrument(int voiceDiff) {
        for (Voice voice : this.voices) {
            spork ~ voice.change(voiceDiff);
        }

        5::second => now;
    }

    fun string getVoiceName() {
        return this.voices[0].name();
    }

    fun void setVoiceState(int voiceNum, int state) {
        state => this.voiceState[voiceNum];
    }

    fun void voiceOn(string key, float freq) {
        this.findOpenVoice() => int voiceNum;
        voiceNum => this.keyMap[key];
        state.BUSY => voiceState[voiceNum];

        this.voices[voiceNum] @=> Voice voice;
        freq => voice.freq;
        voice.on();
    }

    fun void voiceOff(string key) {
        this.keyMap[key] => int voiceNum;
        state.FREE => voiceState[voiceNum];

        this.voices[voiceNum] @=> Voice voice;
        voice.off();
    }

    fun Voice getVoice(string key) {
        return this.voices[ this.keyMap[key] ];
    }
}
