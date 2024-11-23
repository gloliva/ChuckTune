@import "tuning.ck"


public class ColorBounds {
    vec3 lowerColor;
    vec3 upperColor;
    float freqIncrement;

    fun @construct(vec3 lowerColor, vec3 upperColor, float freqIncrement) {
        lowerColor => this.lowerColor;
        upperColor => this.upperColor;
        freqIncrement => this.freqIncrement;
    }

    fun void setLower(vec3 lowerColor) {
        lowerColor => this.lowerColor;
    }

    fun void setUpper(vec3 upperColor) {
        upperColor => this.upperColor;
    }

    fun void setFreqIncrement(float freqIncrement) {
        freqIncrement => this.freqIncrement;
    }
}


public class AudioColorMapper {
    255. => float RGBMax;

    [
        @(255., 0., 0.),
        @(255., 128., 0.),
        @(255., 255., 0.),
        @(128., 255., 0.),
        @(0., 255., 0.),
        @(0., 255., 128.),
        @(0., 255., 255.),
        @(0., 128., 255.),
        @(0., 0., 255.),
        @(127., 0., 255.),
        @(255., 0., 255.),
        @(255., 0., 127.),
    ] @=> vec3 colors[];

    int numColors;

    fun @construct() {
        this.colors.size() => this.numColors;

        // Normalize colors to [0., 1.]
        for (int idx; idx < colors.size(); idx++) {
            this.colors[idx] / this.RGBMax => this.colors[idx];
        }
    }

    fun vec3 freqToColor(TuningRegister register, float freq) {
        // Determine color bounds
        register.getOctaveBounds(freq) @=> OctaveBounds octaveBounds;
        this.getColorBounds(octaveBounds, freq) @=> ColorBounds colorBounds;

        // Scale color based on frequency
        colorBounds.lowerColor.x => float redMin;
        colorBounds.upperColor.x => float redMax;
        Std.scalef(freq, octaveBounds.lowerFreq, octaveBounds.upperFreq, redMin, redMax) => float red;

        colorBounds.lowerColor.y => float greenMin;
        colorBounds.upperColor.y => float greenMax;
        Std.scalef(freq, octaveBounds.lowerFreq, octaveBounds.upperFreq, greenMin, greenMax) => float green;

        colorBounds.lowerColor.z => float blueMin;
        colorBounds.upperColor.z => float blueMax;
        Std.scalef(freq, octaveBounds.lowerFreq, octaveBounds.upperFreq, blueMin, blueMax) => float blue;

        // Base intensity from Octave register
        octaveBounds.register + 1 => float intensity;
        @(red * intensity, green * intensity, blue * intensity) => vec3 retColor;
        return retColor;
    }

    fun ColorBounds getColorBounds(OctaveBounds octaveBounds, float freq) {
        (octaveBounds.upperFreq - octaveBounds.lowerFreq) / this.numColors => float freqIncrement;
        octaveBounds.lowerFreq => float currFreq;

        0 => int currColorIdx;
        while (currFreq < freq) {
            currColorIdx++;
            currFreq + freqIncrement => currFreq;
        }

        this.colors[currColorIdx] => vec3 lowerColor;
        this.colors[( currColorIdx + 1 ) % this.numColors] => vec3 uppperColor;

        return new ColorBounds(lowerColor, uppperColor, freqIncrement);
    }
}
