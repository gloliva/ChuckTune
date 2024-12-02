@import "tuning.ck"


public class ColorBounds {
    int lowerHue;
    int upperHue;
    float freqIncrement;

    fun @construct(int lowerHue, int upperHue, float freqIncrement) {
        lowerHue => this.lowerHue;
        upperHue => this.upperHue;
        freqIncrement => this.freqIncrement;
    }

    fun void setLower(int lowerHue) {
        lowerHue => this.lowerHue;
    }

    fun void setUpper(int upperHue) {
        upperHue => this.upperHue;
    }

    fun void setFreqIncrement(float freqIncrement) {
        freqIncrement => this.freqIncrement;
    }
}


public class AudioColorMapper {
    int hues[0];
    int numColors;
    int registerToShardIdx[];

    fun @construct() {
        0 => int currHue;
        while (currHue < 360) {
            this.hues << currHue;
            currHue + 15 => currHue;
        }

        [
            -500,
            -250,
            0,
            250,
            500,
            750,
            1000,
            1250,
            1500,
            1750,
            2000
        ] @=> this.registerToShardIdx;

        this.hues.size() => this.numColors;
    }

    fun int freqToShard(TuningRegister register, float freq) {
        register.getOctaveBounds(freq) @=> OctaveBounds octaveBounds;

        this.registerToShardIdx[octaveBounds.register] => int shardStart;
        this.registerToShardIdx[octaveBounds.register + 1] => int shardEnd;

        Std.scalef(
            freq,
            octaveBounds.lowerFreq,
            octaveBounds.upperFreq,
            shardStart,
            shardEnd
        )$int => int shardCenter;

        return shardCenter;
    }

    fun vec3 freqToColor(TuningRegister register, float freq) {
        // Determine color bounds
        register.getOctaveBounds(freq) @=> OctaveBounds octaveBounds;
        this.getColorBounds(octaveBounds, freq) @=> ColorBounds colorBounds;

        // Scale color based on frequency
        Std.scalef(
            freq,
            octaveBounds.lowerFreq,
            octaveBounds.upperFreq,
            colorBounds.lowerHue,
            colorBounds.upperHue
        ) => float hue;
        Color.hsv2rgb(@(hue, 1., 1.)) => vec3 retColor;
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

        this.hues[currColorIdx  % this.numColors] => int lowerHue;
        this.hues[( currColorIdx + 1 ) % this.numColors] => int upperHue;

        return new ColorBounds(lowerHue, upperHue, freqIncrement);
    }
}
