@import "files.ck"


public class OctaveBounds {
    float lowerFreq;
    float upperFreq;
    int register;

    fun @construct(float lowerFreq, float upperFreq, int register) {
        lowerFreq => this.lowerFreq;
        upperFreq => this.upperFreq;
        register => this.register;
    }

    fun void setLower(float lowerFreq) {
        lowerFreq => this.lowerFreq;
    }

    fun void setUpper(float upperFreq) {
        upperFreq => this.upperFreq;
    }

    fun void setRegister(int register) {
        register => this.register;
    }
}


public class TuningRegister {
    float registers[9];
    float tuningFreq;
    4 => int middleRegister;

    0. => float minFreq;
    22000. => float maxFreq;

    fun @construct() {
        440. => this.tuningFreq;
        this.calculateRegisters();
    }

    fun @construct(float tuningFreq) {
        this.setTuningFreq(tuningFreq);
    }

    fun void setTuningFreq(float tuningFreq) {
        tuningFreq => this.tuningFreq;
        this.calculateRegisters();
    }

    fun void calculateRegisters() {
        // set middle register
        this.tuningFreq => this.registers[this.middleRegister];

        // bottom registers
        this.tuningFreq => float currFreq;
        for (this.middleRegister - 1 => int idx; idx >=0; idx--) {
            currFreq / 2. => currFreq;
            currFreq => this.registers[idx];
        }

        // top registers
        this.tuningFreq => currFreq;
        for (this.middleRegister + 1 => int idx; idx < this.registers.size(); idx++) {
            currFreq * 2. => currFreq;
            currFreq => this.registers[idx];
        }
    }

    fun OctaveBounds getOctaveBounds(float freq) {
        0 => int currIdx;
        while (currIdx < this.registers.size()) {
            if (freq < this.registers[currIdx]) {
                break;
            }

            currIdx++;
        }

        float lowerFreq;
        float upperFreq;

        if (currIdx == 0) {
            this.minFreq => lowerFreq;
            this.registers[currIdx] => upperFreq;
        } else if (currIdx >= this.registers.size()) {
            this.registers[currIdx - 1] => lowerFreq;
            this.maxFreq => upperFreq;
        } else {
            this.registers[currIdx - 1] => lowerFreq;
            this.registers[currIdx] => upperFreq;
        }

        return new OctaveBounds(lowerFreq, upperFreq, currIdx);
    }

    fun void print() {
        for (int idx; idx < this.registers.size(); idx++) {
            <<< "Register #", idx, "Register Value", this.registers[idx] >>>;
        }
    }
}


public class Note {
    string name;
    string key;
    int degree;
    float freq;

    fun @construct(string name, float freq) {
        name => this.name;
        freq => this.freq;
    }

    fun @construct(string name, int degree, float freq) {
        name => this.name;
        degree => this.degree;
        freq => this.freq;
    }
}


public class Tuning {
    float startFreq;
    float freqDegrees[0];
    int divisions;
    string name;

    TuningFile @ file;
    TuningRegister register;

    fun @construct(TuningFile file) {
        file @=> this.file;
        440. => this.startFreq;
    }

    fun @construct(TuningFile file, float startFreq) {
        file @=> this.file;
        startFreq => this.startFreq;
        "Default Tuning" => this.name;
    }

    fun float freq(int degree) {
        0 => int octaveDiff;

        // Handle negative note diff
        while (degree < 0) {
            this.divisions + degree => degree;
            -1 + octaveDiff => octaveDiff;
        }

        // Calculate Frequency
        (degree / this.divisions) + octaveDiff => octaveDiff;
        degree % this.divisions => degree;
        this.freqDegrees[degree] => float freq;

        // Update octave
        if (octaveDiff < 0) {
            repeat (Math.abs(octaveDiff)) {
                freq / 2 => freq;
            }
        } else if (octaveDiff > 0) {
            repeat (octaveDiff) {
                freq * 2 => freq;
            }
        }

        return freq;
    }

    fun Note getClosestMatchingFreq(float otherFreq) {
        // TODO: fix magic numbers
        float lowerFreq;
        float upperFreq;

        -10 => int degree;
        while (degree < 50) {
            this.freq(degree) => float currFreq;
            if (currFreq > otherFreq) {
                currFreq => upperFreq;
                break;
            }

            currFreq => lowerFreq;
            degree++;
        }

        float freq;
        if (Std.fabs(otherFreq - lowerFreq) < Std.fabs(upperFreq - otherFreq)) {
            lowerFreq => freq;
        } else {
            upperFreq => freq;
        }

        this.file.get(degree) => string name;
        return new Note(name, freq);
    }

    fun void print() {
        for (int degree; degree < this.freqDegrees.size(); degree++){
            <<< "Degree:", degree, "Freq", (this.freqDegrees[degree]) >>>;
        }
    }
}


public class DiatonicJI extends Tuning {
    [
        1.,
        9./8.,
        5./4.,
        4./3.,
        3./2.,
        5./3.,
        15./8.
    ] @=> float stepMultiplier[];

    fun @construct(TuningFile file, float startFreq) {
        Tuning(file, startFreq);
        7 => this.divisions;

        for (int degree; degree < divisions; degree++) {
            this.freqDegrees << this.startFreq * this.stepMultiplier[degree];
        }
    }
}


public class Meantone extends Tuning {
    [
        1.,
        1.07,
        1.118,
        1.1963,
        1.25,
        1.3375,
        1.4311,
        1.4953,
        1.6,
        1.6719,
        1.7889,
        1.8692,
    ] @=> float stepMultiplier[];

    fun @construct(TuningFile file, float startFreq) {
        Tuning(file, startFreq);
        12 => this.divisions;
        "Meantone" => this.name;

        for (int degree; degree < divisions; degree++) {
            this.freqDegrees << this.startFreq * this.stepMultiplier[degree];
        }
    }
}


public class Pythagorean extends Tuning {
    [
        1.,
        256./243,
        9./8.,
        32./27.,
        81./64.,
        4./3.,
        1024./729.,
        3./2.,
        128./81.,
        27./16.,
        16./9.,
        243./128.
    ] @=> float stepMultiplier[];

    fun @construct(TuningFile file, float startFreq) {
        Tuning(file, startFreq);
        12 => this.divisions;
        "Pythag" => this.name;

        for (int degree; degree < divisions; degree++) {
            this.freqDegrees << this.startFreq * this.stepMultiplier[degree];
        }
    }
}


public class EDO extends Tuning {
    fun @construct(TuningFile file, float startFreq, int divisions) {
        Tuning(file, startFreq);
        divisions => this.divisions;
        divisions + " EDO" => this.name;

        for (int degree; degree < divisions; degree++) {
            Math.exp2(degree$float / divisions$float) => float freqStep;
            this.freqDegrees << this.startFreq * freqStep;
        }
    }

    fun void print() {
        <<< this.divisions, "EDO", ", Step division"  >>>;
        for (int degree; degree < this.freqDegrees.size(); degree++){
            <<< "Degree:", degree, "Freq", (this.freqDegrees[degree]) >>>;
        }
    }
}


public class TuningManager {
    Tuning tunings[];
    int numTunings;
    int selected;

    fun @construct(Tuning tunings[]) {
        tunings @=> this.tunings;
        tunings.size() => this.numTunings;
        0 => selected;
    }

    fun changeTuning(int diff) {
        this.selected + diff => this.selected;

        if (this.selected < 0) {
            this.selected + this.numTunings => this.selected;
        }

        this.selected % this.numTunings => this.selected;
    }

    fun Tuning getTuning() {
        return this.tunings[this.selected];
    }
}