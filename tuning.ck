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


public class Tuning {
    float startFreq;
    float freqDegrees[0];

    TuningFile @ file;
    TuningRegister register;

    fun @construct(TuningFile file) {
        file @=> this.file;
        440. => this.startFreq;
    }

    fun @construct(TuningFile file, float startFreq) {
        file @=> this.file;
        startFreq => this.startFreq;
    }

    fun float freq(int degree) {
        return this.freqDegrees[degree - 1];
    }

    fun void print() {
        for (int degree; degree < this.freqDegrees.size(); degree++){
            <<< "Degree:", degree, "Freq", (this.freqDegrees[degree]) >>>;
        }
    }
}


public class DiatonicJI extends Tuning {
    int divisions;
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

public class EDO extends Tuning {
    int divisions;

    fun @construct(TuningFile file, float startFreq, int divisions) {
        Tuning(file, startFreq);
        divisions => this.divisions;

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
