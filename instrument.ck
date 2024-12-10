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
    Envelope envs[];
    Gain mix;

    int numVoices;
    int currVoice;

    string names[];

    fun @construct() {

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
            new Envelope(500::ms),
            new Envelope(500::ms),
            new Envelope(500::ms),
            new Envelope(500::ms),
            new Envelope(500::ms),
            new Envelope(500::ms),
            new Envelope(500::ms),
            new Envelope(500::ms),
            new Envelope(500::ms),
            new Envelope(500::ms),
        ] @=> this.envs;

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
            this.oscVoices[idx] => this.envs[idx] => this.gains[idx] => this.mix;
        }

        for (int idx; idx < this.fmVoices.size(); idx++) {
            this.fmVoices[idx] => this.envs[idx + this.oscVoices.size()] => this.gains[idx + this.oscVoices.size()] => this.mix;
            this.fmVoices[idx].noteOn(1.);
        }
    }

    fun void select(int idx) {
        this.currVoice => int prevVoice;
        idx % this.numVoices => this.currVoice;

        this.envs[prevVoice].keyOff(1);
        this.envs[this.currVoice].keyOn(1);
        500::ms => now;
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
        this.select(voiceSelect);

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
