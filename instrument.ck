public class VoiceState {
    static int FREE;
    static int BUSY;

    fun @construct() {
        0 => this.FREE;
        1 => this.BUSY;
    }
}


public class Voice {
    SawOsc osc;
    Gain g;
    Envelope env;
    NRev rev;

    fun @construct() {
        this.osc => this.g => this.env => this.rev => dac;
        100::ms => this.env.duration;
        0.1 => this.g.gain;
        0.1 => this.rev.mix;
    }

    fun float freq() {
        return this.osc.freq();
    }

    fun void freq(float f) {
        f => this.osc.freq;
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
