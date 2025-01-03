@import "themes.ck"


public class Text {
    string text;
    float scale;

    fun @construct(string text, float scale) {
        text => this.text;
        scale => this.scale;
    }
}


public class Title extends GGen {
    GCube border;
    GPlane inside;
    GText titleTop;
    GText titleBot;

    fun @construct() {
        // Scaling
        @(1.5, 1., 0.05) => this.border.sca;
        @(1.4, 0.9, 0.9) => this.inside.sca;
        @(0.4, 0.4, 0.4) => this.titleTop.sca;
        @(0.5, 0.4, 0.4) => this.titleBot.sca;

        // Position
        -0.025 => this.border.posZ;
        0.001 => this.inside.posZ;

        @(0, 0.2, 0.01) => this.titleTop.pos;
        @(0, -0.2, 0.01) => this.titleBot.pos;

        @(-5.12, 2.81, 0.) => this.pos;

        // Color
        Color.WHITE * 2. => this.border.color;
        Color.BLACK => this.inside.color;
        @(2., 2., 2., 1.) => this.titleTop.color;
        @(2., 2., 2., 1.) => this.titleBot.color;

        // Text
        "ChucK" => this.titleTop.text;
        "TUNE" => this.titleBot.text;

        // Names
        "Border" => this.border.name;
        "Inside" => this.inside.name;
        "Title Top" => this.titleTop.name;
        "Title Bot" => this.titleBot.name;
        "Title" => this.name;

        // Connection
        border --> this;
        inside --> this;
        titleTop --> this;
        titleBot --> this;
        this --> GG.scene();
    }

    fun void setTheme(Theme newTheme) {
        newTheme.primary => this.inside.color;
        newTheme.secondary => this.border.color;
    }
}


public class TuningSelect extends GGen {
    GCube border;
    GPlane inside;

    GText leftSelect;
    GCube lsBorder;
    GPlane lsInside;

    GText rightSelect;
    GCube rsBorder;
    GPlane rsInside;

    GText tuning;
    GCube tBorder;
    GPlane tInside;

    int leftButtonPressed;
    int rightButtonPressed;

    fun @construct() {
        // Scaling
        @(1.5, 1., 0.05) => this.border.sca;
        @(1.4, 0.9, 0.9) => this.inside.sca;

        @(0.2, 0.2, 0.2) => this.leftSelect.sca;
        @(0.25, 0.25, 0.05) => this.lsBorder.sca;
        @(0.9, 0.9, 0.9) => this.lsInside.sca;

        @(0.2, 0.2, 0.2) => this.rightSelect.sca;
        @(0.25, 0.25, 0.05) => this.rsBorder.sca;
        @(0.9, 0.9, 0.9) => this.rsInside.sca;

        @(0.2, 0.2, 0.2) => this.tuning.sca;
        @(1.2, 0.35, 0.05) => this.tBorder.sca;
        @(0.98, 0.9, 0.9) => this.tInside.sca;

        // Position
        -0.025 => this.border.posZ;
        0.001 => this.inside.posZ;

        @(0, 0.15, 0.0251) => this.tuning.pos;
        @(0, 0.15, 0) => this.tBorder.pos;
        0.501 => this.tInside.posZ;

        @(-0.3, -0.25, 0.0251) => this.leftSelect.pos;
        @(-0.3, -0.25, 0) => this.lsBorder.pos;
        0.501 => this.lsInside.posZ;

        @(0.3, -0.25, 0.0251) => this.rightSelect.pos;
        @(0.3, -0.25, 0) => this.rsBorder.pos;
        0.501 => this.rsInside.posZ;

        @(-5.12, 1.85, 0.) => this.pos;

        // Text
        "12 EDO" => this.tuning.text;
        "<" => this.leftSelect.text;
        ">" => this.rightSelect.text;

        // Color
        Color.WHITE * 2. => this.border.color;
        Color.WHITE * 2. => this.lsBorder.color;
        Color.WHITE * 2. => this.rsBorder.color;
        Color.WHITE * 2. => this.tBorder.color;

        Color.BLACK => this.inside.color;
        Color.BLACK => this.lsInside.color;
        Color.BLACK => this.rsInside.color;
        Color.BLACK => this.tInside.color;

        @(2., 2., 2., 1.) => this.tuning.color;

        // Name
        "Border" => this.border.name;
        "Inside" => this.inside.name;

        "Left Select" => this.leftSelect.name;
        "LS Border" => this.lsBorder.name;
        "LS Inside" => this.lsInside.name;

        "Right Select" => this.rightSelect.name;
        "RS Border" => this.rsBorder.name;
        "RS Inside" => this.rsInside.name;

        "Selected Tuning" => this.tuning.name;
        "T Border" => this.tBorder.name;
        "T Inside" => this.tInside.name;

        "Tuning UI" => this.name;

        // Connection
        border --> this;
        inside --> this;

        leftSelect --> this;
        lsInside --> lsBorder --> this;

        rightSelect --> this;
        rsInside --> rsBorder --> this;

        tuning --> this;
        tInside --> tBorder --> this;

        this --> GG.scene();
    }

    fun int checkIfSelected(vec2 mousePos) {
        0 => int selectMode;
        if (mousePos.y >= 348 && mousePos.y <= 398) {
            if (mousePos.x >= 75 && mousePos.x <= 125) -1 => selectMode;
            if (mousePos.x >= 205 && mousePos.x <= 255) 1 => selectMode;
        }

        return selectMode;
    }

    fun void clickLeft() {
        1 => this.leftButtonPressed;
        this.lsBorder.posZ() - 0.02 => this.lsBorder.posZ;
        this.leftSelect.posZ() - 0.02 => this.leftSelect.posZ;
    }

    fun void resetLeft() {
        0 => this.leftButtonPressed;
        this.lsBorder.posZ() + 0.02 => this.lsBorder.posZ;
        this.leftSelect.posZ() + 0.02 => this.leftSelect.posZ;
    }

    fun void clickRight() {
        1 => this.rightButtonPressed;
        this.rsBorder.posZ() - 0.02 => this.rsBorder.posZ;
        this.rightSelect.posZ() - 0.02 => this.rightSelect.posZ;
    }

    fun void resetRight() {
        0 => this.rightButtonPressed;
        this.rsBorder.posZ() + 0.02 => this.rsBorder.posZ;
        this.rightSelect.posZ() + 0.02 => this.rightSelect.posZ;
    }

    fun void setText(string text) {
        text => this.tuning.text;
    }

    fun void setTheme(Theme newTheme) {
        newTheme.primary => this.inside.color;
        newTheme.primary => this.lsInside.color;
        newTheme.primary => this.rsInside.color;
        newTheme.primary => this.tInside.color;

        newTheme.secondary => this.border.color;
        newTheme.secondary => this.lsBorder.color;
        newTheme.secondary => this.rsBorder.color;
        newTheme.secondary => this.tBorder.color;
    }
}


public class SoundSelect extends GGen {
    GCube border;
    GPlane inside;

    GText leftSelect;
    GCube lsBorder;
    GPlane lsInside;

    GText rightSelect;
    GCube rsBorder;
    GPlane rsInside;

    GText instrument;
    GCube iBorder;
    GPlane iInside;

    int leftButtonPressed;
    int rightButtonPressed;

    int currName;
    string names[];

    fun @construct() {
        // Sound names
        0 => this.currName;
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
        this.setName(this.currName);

        // Scaling
        @(1.5, 1., 0.05) => this.border.sca;
        @(1.4, 0.9, 0.9) => this.inside.sca;

        @(0.2, 0.2, 0.2) => this.leftSelect.sca;
        @(0.25, 0.25, 0.05) => this.lsBorder.sca;
        @(0.9, 0.9, 0.9) => this.lsInside.sca;

        @(0.2, 0.2, 0.2) => this.rightSelect.sca;
        @(0.25, 0.25, 0.05) => this.rsBorder.sca;
        @(0.9, 0.9, 0.9) => this.rsInside.sca;

        @(0.2, 0.2, 0.2) => this.instrument.sca;
        @(1.2, 0.35, 0.05) => this.iBorder.sca;
        @(0.98, 0.9, 0.9) => this.iInside.sca;

        // Position
        -0.025 => this.border.posZ;
        0.001 => this.inside.posZ;

        @(0, 0.15, 0.0251) => this.instrument.pos;
        @(0, 0.15, 0) => this.iBorder.pos;
        0.501 => this.iInside.posZ;

        @(-0.3, -0.25, 0.0251) => this.leftSelect.pos;
        @(-0.3, -0.25, 0) => this.lsBorder.pos;
        0.501 => this.lsInside.posZ;

        @(0.3, -0.25, 0.0251) => this.rightSelect.pos;
        @(0.3, -0.25, 0) => this.rsBorder.pos;
        0.501 => this.rsInside.posZ;

        @(-5.12, -1.84, 0.) => this.pos;

        // Text
        "SinOsc" => this.instrument.text;
        "<" => this.leftSelect.text;
        ">" => this.rightSelect.text;

        // Color
        Color.WHITE * 2. => this.border.color;
        Color.WHITE * 2. => this.lsBorder.color;
        Color.WHITE * 2. => this.rsBorder.color;
        Color.WHITE * 2. => this.iBorder.color;

        Color.BLACK => this.inside.color;
        Color.BLACK => this.lsInside.color;
        Color.BLACK => this.rsInside.color;
        Color.BLACK => this.iInside.color;

        @(2., 2., 2., 1.) => this.instrument.color;

        // Name
        "Border" => this.border.name;
        "Inside" => this.inside.name;

        "Left Select" => this.leftSelect.name;
        "LS Border" => this.lsBorder.name;
        "LS Inside" => this.lsInside.name;

        "Right Select" => this.rightSelect.name;
        "RS Border" => this.rsBorder.name;
        "RS Inside" => this.rsInside.name;

        "Selected Instrument" => this.instrument.name;
        "I Border" => this.iBorder.name;
        "I Inside" => this.iInside.name;

        "Instrument UI" => this.name;

        // Connection
        border --> this;
        inside --> this;

        leftSelect --> this;
        lsInside --> lsBorder --> this;

        rightSelect --> this;
        rsInside --> rsBorder --> this;

        instrument --> this;
        iInside --> iBorder --> this;

        this --> GG.scene();
    }

    fun int checkIfSelected(vec2 mousePos) {
        0 => int selectMode;

        if (mousePos.y >= 1153 && mousePos.y <= 1202) {
            if (mousePos.x >= 75 && mousePos.x <= 125) -1 => selectMode;
            if (mousePos.x >= 205 && mousePos.x <= 255) 1 => selectMode;
        }

        return selectMode;
    }

    fun void clickLeft() {
        1 => this.leftButtonPressed;
        this.lsBorder.posZ() - 0.02 => this.lsBorder.posZ;
        this.leftSelect.posZ() - 0.02 => this.leftSelect.posZ;
    }

    fun void resetLeft() {
        0 => this.leftButtonPressed;
        this.lsBorder.posZ() + 0.02 => this.lsBorder.posZ;
        this.leftSelect.posZ() + 0.02 => this.leftSelect.posZ;
    }

    fun void clickRight() {
        1 => this.rightButtonPressed;
        this.rsBorder.posZ() - 0.02 => this.rsBorder.posZ;
        this.rightSelect.posZ() - 0.02 => this.rightSelect.posZ;
    }

    fun void resetRight() {
        0 => this.rightButtonPressed;
        this.rsBorder.posZ() + 0.02 => this.rsBorder.posZ;
        this.rightSelect.posZ() + 0.02 => this.rightSelect.posZ;
    }

    fun void setName(int idx) {
        this.names[idx] => string text;
        text => this.instrument.text;
    }

    fun void changeName(int diff) {
        this.currName + diff => int newName;

        if (newName < 0) {
            newName + this.names.size() => newName;
        }

        newName % this.names.size() => newName;

        this.names[newName] => string text;
        text => this.instrument.text;
        newName => this.currName;
    }

    fun void setTheme(Theme newTheme) {
        newTheme.primary => this.inside.color;
        newTheme.primary => this.lsInside.color;
        newTheme.primary => this.rsInside.color;
        newTheme.primary => this.iInside.color;

        newTheme.secondary => this.border.color;
        newTheme.secondary => this.lsBorder.color;
        newTheme.secondary => this.rsBorder.color;
        newTheme.secondary => this.iBorder.color;
    }
}


public class HoldVisualizer extends GGen {
    GCube border;
    GPlane inside;

    GText nowTime;
    GCube nowBorder;
    GPlane nowInside;

    GText sec2Time;
    GCube sec2Border;
    GPlane sec2Inside;

    GText sec5Time;
    GCube sec5Border;
    GPlane sec5Inside;

    GText hold;
    GCube holdBorder;
    GPlane holdInside;

    GText track;
    GCube trackBorder;
    GPlane trackInside;

    int holdPressed;
    int trackPressed;
    int currTimeSelected;
    int timeButtonPressed;
    dur waitTime;

    // Constants
    1 => int HOLD_PRESS;
    5 => int TRACK_PRESS;
    2 => int NOW_PRESS;
    3 => int SEC2_PRESS;
    4 => int SEC5_PRESS;

    fun @construct() {
        // Scaling
        @(1.5, 1., 0.05) => this.border.sca;
        @(1.4, 0.9, 0.9) => this.inside.sca;

        @(0.17, 0.17, 0.17) => this.nowTime.sca;
        @(0.4, 0.25, 0.05) => this.nowBorder.sca;
        @(0.95, 0.9, 0.9) => this.nowInside.sca;

        @(0.17, 0.17, 0.17) => this.sec2Time.sca;
        @(0.4, 0.25, 0.05) => this.sec2Border.sca;
        @(0.95, 0.9, 0.9) => this.sec2Inside.sca;

        @(0.17, 0.17, 0.17) => this.sec5Time.sca;
        @(0.4, 0.25, 0.05) => this.sec5Border.sca;
        @(0.95, 0.9, 0.9) => this.sec5Inside.sca;

        @(0.17, 0.17, 0.17) => this.hold.sca;
        @(0.6, 0.35, 0.05) => this.holdBorder.sca;
        @(0.98, 0.9, 0.9) => this.holdInside.sca;

        @(0.17, 0.17, 0.17) => this.track.sca;
        @(0.6, 0.35, 0.05) => this.trackBorder.sca;
        @(0.98, 0.9, 0.9) => this.trackInside.sca;

        // Position
        -0.025 => this.border.posZ;
        0.001 => this.inside.posZ;

        @(-0.330, 0.15, 0.0251) => this.hold.pos;
        @(-0.330, 0.15, 0) => this.holdBorder.pos;
        0.501 => this.holdInside.posZ;

        @(0.350, 0.15, 0.0251) => this.track.pos;
        @(0.350, 0.15, 0) => this.trackBorder.pos;
        0.501 => this.trackInside.posZ;

        @(-0.45, -0.25, 0.0251) => this.nowTime.pos;
        @(-0.45, -0.25, 0) => this.nowBorder.pos;
        0.501 => this.nowInside.posZ;

        @(0., -0.25, 0.0251) => this.sec2Time.pos;
        @(0., -0.25, 0) => this.sec2Border.pos;
        0.501 => this.sec2Inside.posZ;

        @(0.45, -0.25, 0.0251) => this.sec5Time.pos;
        @(0.45, -0.25, 0) => this.sec5Border.pos;
        0.501 => this.sec5Inside.posZ;

        @(-5.12, -0.07, 0.) => this.pos;

        // Text
        "HOLD" => this.hold.text;
        "TRACK" => this.track.text;
        "Now" => this.nowTime.text;
        "2s" => this.sec2Time.text;
        "5s" => this.sec5Time.text;

        // Color
        Color.WHITE * 2. => this.border.color;
        Color.WHITE * 2. => this.nowBorder.color;
        Color.WHITE * 2. => this.sec2Border.color;
        Color.WHITE * 2. => this.sec5Border.color;
        Color.WHITE * 2. => this.holdBorder.color;
        Color.WHITE * 2. => this.trackBorder.color;

        Color.BLACK => this.inside.color;
        Color.BLACK => this.nowInside.color;
        Color.BLACK => this.sec2Inside.color;
        Color.BLACK => this.sec5Inside.color;
        Color.BLACK => this.holdInside.color;
        Color.BLACK => this.trackInside.color;

        @(2., 2., 2., 1.) => this.hold.color;
        @(2., 2., 2., 1.) => this.track.color;

        // Name
        "Border" => this.border.name;
        "Inside" => this.inside.name;

        "Now Time" => this.nowTime.name;
        "Now Border" => this.nowBorder.name;
        "Now Inside" => this.nowInside.name;

        "2 Sec Time" => this.sec2Time.name;
        "2 Sec Border" => this.sec2Border.name;
        "2 Sec Inside" => this.sec2Inside.name;

        "5 Sec Time" => this.sec5Time.name;
        "5 Sec Border" => this.sec5Border.name;
        "5 Sec Inside" => this.sec5Inside.name;

        "Hold" => this.hold.name;
        "Hold Border" => this.holdBorder.name;
        "Hold Inside" => this.holdInside.name;

        "Track" => this.track.name;
        "Track Border" => this.trackBorder.name;
        "Track Inside" => this.trackInside.name;

        "Hold UI" => this.name;

        // Member variables
        0::ms => this.waitTime;
        this.clickNow();

        // Connection
        border --> this;
        inside --> this;

        nowTime --> this;
        nowInside --> nowBorder --> this;

        sec2Time --> this;
        sec2Inside --> sec2Border --> this;

        sec5Time --> this;
        sec5Inside --> sec5Border --> this;

        hold --> this;
        holdInside --> holdBorder --> this;

        track --> this;
        trackInside --> trackBorder --> this;

        this --> GG.scene();
    }

    fun int checkIfSelected(vec2 mousePos) {
        0 => int selectMode;

        if (mousePos.y >= 671 && mousePos.y <= 738) {
            if (mousePos.x >= 30 && mousePos.x <= 157) this.HOLD_PRESS => selectMode;
            if (mousePos.x >= 177 && mousePos.x <= 305) this.TRACK_PRESS => selectMode;
        }

        if (mousePos.y >= 767 && mousePos.y <= 815) {
            if (mousePos.x >= 27 && mousePos.x <= 108) {
                this.NOW_PRESS => selectMode;
                0::ms => this.waitTime;
            }

            if (mousePos.x >= 124 && mousePos.x <= 204){
                this.SEC2_PRESS => selectMode;
                2::second => this.waitTime;
            }

            if (mousePos.x >= 222 && mousePos.x <= 304) {
                this.SEC5_PRESS => selectMode;
                5::second => this.waitTime;
            }
        }

        return selectMode;
    }

    fun void toggleHold() {
        if (this.holdPressed == 1) {
            this.resetHold();
        } else if (this.holdPressed == 0) {
            this.clickHold();
        }
    }

    fun void clickHold() {
        1 => this.holdPressed;
        Color.BLUE => this.holdInside.color;
        @(4., 4., 4., 1.) => this.hold.color;

        this.hold.posZ() - 0.02 => this.hold.posZ;
        this.holdBorder.posZ() - 0.02 => this.holdBorder.posZ;
    }

    fun void resetHold() {
        0 => this.holdPressed;
        Color.BLACK => this.holdInside.color;
        @(2., 2., 2., 1.) => this.hold.color;

        this.hold.posZ() + 0.02 => this.hold.posZ;
        this.holdBorder.posZ() + 0.02 => this.holdBorder.posZ;
    }

    fun void toggleTrack() {
        if (this.trackPressed == 1) {
            this.resetTrack();
        } else if (this.trackPressed == 0) {
            this.clickTrack();
        }
    }

    fun void clickTrack() {
        1 => this.trackPressed;
        Color.BLUE => this.trackInside.color;
        @(4., 4., 4., 1.) => this.track.color;

        this.track.posZ() - 0.02 => this.track.posZ;
        this.trackBorder.posZ() - 0.02 => this.trackBorder.posZ;
    }

    fun void resetTrack() {
        0 => this.trackPressed;
        Color.BLACK => this.trackInside.color;
        @(2., 2., 2., 1.) => this.track.color;

        this.track.posZ() + 0.02 => this.track.posZ;
        this.trackBorder.posZ() + 0.02 => this.trackBorder.posZ;
    }

    fun void resetTime() {
        if (this.currTimeSelected == this.NOW_PRESS) {
            this.resetNow();
        } else if (this.currTimeSelected == this.SEC2_PRESS) {
            this.resetSec2();
        } else if (this.currTimeSelected == this.SEC5_PRESS) {
            this.resetSec5();
        }
    }

    fun void updateTime(int timeSelected) {
        if (timeSelected == this.NOW_PRESS) {
            this.clickNow();
        } else if (timeSelected == this.SEC2_PRESS) {
            this.clickSec2();
        } else if (timeSelected == this.SEC5_PRESS) {
            this.clickSec5();
        }
    }

    fun void clickNow() {
        this.NOW_PRESS => this.currTimeSelected;
        Color.BLUE => this.nowInside.color;
        @(4., 4., 4., 1.) => this.nowTime.color;

        this.nowTime.posZ() - 0.02 => this.nowTime.posZ;
        this.nowBorder.posZ() - 0.02 => this.nowBorder.posZ;
    }

    fun void resetNow() {
        Color.BLACK => this.nowInside.color;
        @(2., 2., 2., 1.) => this.nowTime.color;

        this.nowTime.posZ() + 0.02 => this.nowTime.posZ;
        this.nowBorder.posZ() + 0.02 => this.nowBorder.posZ;
    }

    fun void clickSec2() {
        this.SEC2_PRESS => this.currTimeSelected;
        Color.BLUE => this.sec2Inside.color;
        @(4., 4., 4., 1.) => this.sec2Time.color;

        this.sec2Time.posZ() - 0.02 => this.sec2Time.posZ;
        this.sec2Border.posZ() - 0.02 => this.sec2Border.posZ;
    }

    fun void resetSec2() {
        Color.BLACK => this.sec2Inside.color;
        @(2., 2., 2., 1.) => this.sec2Time.color;

        this.sec2Time.posZ() + 0.02 => this.sec2Time.posZ;
        this.sec2Border.posZ() + 0.02 => this.sec2Border.posZ;
    }

    fun void clickSec5() {
        this.SEC5_PRESS => this.currTimeSelected;
        Color.BLUE => this.sec5Inside.color;
        @(4., 4., 4., 1.) => this.sec5Time.color;

        this.sec5Time.posZ() - 0.02 => this.sec5Time.posZ;
        this.sec5Border.posZ() - 0.02 => this.sec5Border.posZ;
    }

    fun void resetSec5() {
        Color.BLACK => this.sec5Inside.color;
        @(2., 2., 2., 1.) => this.sec5Time.color;

        this.sec5Time.posZ() + 0.02 => this.sec5Time.posZ;
        this.sec5Border.posZ() + 0.02 => this.sec5Border.posZ;
    }

    fun void setTheme(Theme newTheme) {
        newTheme.primary => this.inside.color;
        newTheme.primary => this.holdInside.color;
        newTheme.primary => this.trackInside.color;
        newTheme.primary => this.nowInside.color;
        newTheme.primary => this.sec2Inside.color;
        newTheme.primary => this.sec5Inside.color;

        newTheme.secondary => this.border.color;
        newTheme.secondary => this.holdBorder.color;
        newTheme.secondary => this.trackBorder.color;
        newTheme.secondary => this.nowBorder.color;
        newTheme.secondary => this.sec2Border.color;
        newTheme.secondary => this.sec5Border.color;
    }
}


public class BlendSelect extends GGen {
    GCube border;
    GPlane inside;

    GText leftSelect;
    GCube lsBorder;
    GPlane lsInside;

    GText rightSelect;
    GCube rsBorder;
    GPlane rsInside;

    GText blend;
    GCube blendBorder;
    GPlane blendInside;

    int leftButtonPressed;
    int rightButtonPressed;

    fun @construct() {
        // Scaling
        @(1.5, 1., 0.05) => this.border.sca;
        @(1.4, 0.9, 0.9) => this.inside.sca;

        @(0.2, 0.2, 0.2) => this.leftSelect.sca;
        @(0.25, 0.25, 0.05) => this.lsBorder.sca;
        @(0.9, 0.9, 0.9) => this.lsInside.sca;

        @(0.2, 0.2, 0.2) => this.rightSelect.sca;
        @(0.25, 0.25, 0.05) => this.rsBorder.sca;
        @(0.9, 0.9, 0.9) => this.rsInside.sca;

        @(0.2, 0.2, 0.2) => this.blend.sca;
        @(1.2, 0.35, 0.05) => this.blendBorder.sca;
        @(0.98, 0.9, 0.9) => this.blendInside.sca;

        // Position
        -0.025 => this.border.posZ;
        0.001 => this.inside.posZ;

        @(0, 0.15, 0.0251) => this.blend.pos;
        @(0, 0.15, 0) => this.blendBorder.pos;
        0.501 => this.blendInside.posZ;

        @(-0.3, -0.25, 0.0251) => this.leftSelect.pos;
        @(-0.3, -0.25, 0) => this.lsBorder.pos;
        0.501 => this.lsInside.posZ;

        @(0.3, -0.25, 0.0251) => this.rightSelect.pos;
        @(0.3, -0.25, 0) => this.rsBorder.pos;
        0.501 => this.rsInside.posZ;

        @(-5.12, 0.89, 0.) => this.pos;

        // Text
        "Blend" => this.blend.text;
        "<" => this.leftSelect.text;
        ">" => this.rightSelect.text;

        // Color
        Color.WHITE * 2. => this.border.color;
        Color.WHITE * 2. => this.lsBorder.color;
        Color.WHITE * 2. => this.rsBorder.color;
        Color.WHITE * 2. => this.blendBorder.color;

        Color.BLACK => this.inside.color;
        Color.BLACK => this.lsInside.color;
        Color.BLACK => this.rsInside.color;
        Color.BLACK => this.blendInside.color;

        @(2., 2., 2., 1.) => this.blend.color;

        // Name
        "Border" => this.border.name;
        "Inside" => this.inside.name;

        "Left Select" => this.leftSelect.name;
        "LS Border" => this.lsBorder.name;
        "LS Inside" => this.lsInside.name;

        "Right Select" => this.rightSelect.name;
        "RS Border" => this.rsBorder.name;
        "RS Inside" => this.rsInside.name;

        "Selected Blend" => this.blend.name;
        "Blend Border" => this.blendBorder.name;
        "Blend Inside" => this.blendInside.name;

        "Blend UI" => this.name;

        // Connection
        border --> this;
        inside --> this;

        leftSelect --> this;
        lsInside --> lsBorder --> this;

        rightSelect --> this;
        rsInside --> rsBorder --> this;

        blend --> this;
        blendInside --> blendBorder --> this;

        this --> GG.scene();
    }

    fun int checkIfSelected(vec2 mousePos) {
        0 => int selectMode;
        if (mousePos.y >= 558 && mousePos.y <= 607) {
            if (mousePos.x >= 75 && mousePos.x <= 125) -1 => selectMode;
            if (mousePos.x >= 205 && mousePos.x <= 255) 1 => selectMode;
        }

        return selectMode;
    }

    fun void clickLeft() {
        1 => this.leftButtonPressed;
        this.lsBorder.posZ() - 0.02 => this.lsBorder.posZ;
        this.leftSelect.posZ() - 0.02 => this.leftSelect.posZ;
    }

    fun void resetLeft() {
        0 => this.leftButtonPressed;
        this.lsBorder.posZ() + 0.02 => this.lsBorder.posZ;
        this.leftSelect.posZ() + 0.02 => this.leftSelect.posZ;
    }

    fun void clickRight() {
        1 => this.rightButtonPressed;
        this.rsBorder.posZ() - 0.02 => this.rsBorder.posZ;
        this.rightSelect.posZ() - 0.02 => this.rightSelect.posZ;
    }

    fun void resetRight() {
        0 => this.rightButtonPressed;
        this.rsBorder.posZ() + 0.02 => this.rsBorder.posZ;
        this.rightSelect.posZ() + 0.02 => this.rightSelect.posZ;
    }

    fun void setText(string text) {
        text => this.blend.text;
    }

    fun void setText(string text, float scale) {
        text => this.blend.text;
        @(scale, scale, scale) => this.blend.sca;
    }

    fun void setTheme(Theme newTheme) {
        newTheme.primary => this.inside.color;
        newTheme.primary => this.lsInside.color;
        newTheme.primary => this.rsInside.color;
        newTheme.primary => this.blendInside.color;

        newTheme.secondary => this.border.color;
        newTheme.secondary => this.lsBorder.color;
        newTheme.secondary => this.rsBorder.color;
        newTheme.secondary => this.blendBorder.color;
    }
}


public class MoveVisualizer extends GGen {
    GCube border;
    GPlane inside;

    GText leftSelect;
    GCube lsBorder;
    GPlane lsInside;

    GText rightSelect;
    GCube rsBorder;
    GPlane rsInside;

    GText plusSelect;
    GCube plusBorder;
    GPlane plusInside;

    GText minusSelect;
    GCube minusBorder;
    GPlane minusInside;

    int leftButtonPressed;
    int rightButtonPressed;
    int plusButtonPressed;
    int minusButtonPressed;

    // Modes
    1 => int LEFT;
    2 => int RIGHT;
    3 => int PLUS;
    4 => int MINUS;

    fun @construct() {
        // Scaling
        @(1.5, 0.85, 0.05) => this.border.sca;
        @(1.4, 0.75, 0.9) => this.inside.sca;

        @(0.2, 0.2, 0.2) => this.leftSelect.sca;
        @(0.25, 0.25, 0.05) => this.lsBorder.sca;
        @(0.9, 0.9, 0.9) => this.lsInside.sca;

        @(0.2, 0.2, 0.2) => this.rightSelect.sca;
        @(0.25, 0.25, 0.05) => this.rsBorder.sca;
        @(0.9, 0.9, 0.9) => this.rsInside.sca;

        @(0.2, 0.2, 0.2) => this.plusSelect.sca;
        @(0.25, 0.25, 0.05) => this.plusBorder.sca;
        @(0.9, 0.9, 0.9) => this.plusInside.sca;

        @(0.2, 0.2, 0.2) => this.minusSelect.sca;
        @(0.25, 0.25, 0.05) => this.minusBorder.sca;
        @(0.9, 0.9, 0.9) => this.minusInside.sca;

        // Position
        -0.025 => this.border.posZ;
        0.001 => this.inside.posZ;

        @(-0.18, -0.18, 0.0251) => this.leftSelect.pos;
        @(-0.18, -0.18, 0) => this.lsBorder.pos;
        0.501 => this.lsInside.posZ;

        @(0.18, -0.18, 0.0251) => this.rightSelect.pos;
        @(0.18, -0.18, 0) => this.rsBorder.pos;
        0.501 => this.rsInside.posZ;

        @(-0.18, 0.18, 0.0251) => this.plusSelect.pos;
        @(-0.18, 0.18, 0) => this.plusBorder.pos;
        0.501 => this.plusInside.posZ;

        @(0.18, 0.18, 0.0251) => this.minusSelect.pos;
        @(0.18, 0.18, 0) => this.minusBorder.pos;
        0.501 => this.minusInside.posZ;


        @(-5.12, -0.95, 0.) => this.pos;

        // Text
        "+" => this.plusSelect.text;
        "-" => this.minusSelect.text;
        "<" => this.leftSelect.text;
        ">" => this.rightSelect.text;

        // Color
        Color.WHITE * 2. => this.border.color;
        Color.WHITE * 2. => this.lsBorder.color;
        Color.WHITE * 2. => this.rsBorder.color;
        Color.WHITE * 2. => this.plusBorder.color;
        Color.WHITE * 2. => this.minusBorder.color;

        Color.BLACK => this.inside.color;
        Color.BLACK => this.lsInside.color;
        Color.BLACK => this.rsInside.color;
        Color.BLACK => this.plusInside.color;
        Color.BLACK => this.minusInside.color;

        // Name
        "Border" => this.border.name;
        "Inside" => this.inside.name;

        "Left Select" => this.leftSelect.name;
        "LS Border" => this.lsBorder.name;
        "LS Inside" => this.lsInside.name;

        "Right Select" => this.rightSelect.name;
        "RS Border" => this.rsBorder.name;
        "RS Inside" => this.rsInside.name;

        "Plus Select" => this.plusSelect.name;
        "Plus Border" => this.plusBorder.name;
        "Plus Inside" => this.plusInside.name;

        "Minus Select" => this.minusSelect.name;
        "Minus Border" => this.minusBorder.name;
        "Minus Inside" => this.minusInside.name;

        "Move UI" => this.name;

        // Connection
        border --> this;
        inside --> this;

        leftSelect --> this;
        lsInside --> lsBorder --> this;

        rightSelect --> this;
        rsInside --> rsBorder --> this;

        plusSelect --> this;
        plusInside --> plusBorder --> this;

        minusSelect --> this;
        minusInside --> minusBorder --> this;

        this --> GG.scene();
    }

    fun int checkIfSelected(vec2 mousePos) {
        0 => int selectMode;

        if (mousePos.y >= 866 && mousePos.y <= 913) {
            if (mousePos.x >= 75 && mousePos.x <= 125) this.PLUS => selectMode;
            if (mousePos.x >= 205 && mousePos.x <= 255) this.MINUS => selectMode;
        }

        if (mousePos.y >= 944 && mousePos.y <= 992) {
            if (mousePos.x >= 75 && mousePos.x <= 125) this.LEFT => selectMode;
            if (mousePos.x >= 205 && mousePos.x <= 255) this.RIGHT => selectMode;
        }

        return selectMode;
    }

    fun void clickLeft() {
        1 => this.leftButtonPressed;
        this.lsBorder.posZ() - 0.02 => this.lsBorder.posZ;
        this.leftSelect.posZ() - 0.02 => this.leftSelect.posZ;
    }

    fun void resetLeft() {
        0 => this.leftButtonPressed;
        this.lsBorder.posZ() + 0.02 => this.lsBorder.posZ;
        this.leftSelect.posZ() + 0.02 => this.leftSelect.posZ;
    }

    fun void clickRight() {
        1 => this.rightButtonPressed;
        this.rsBorder.posZ() - 0.02 => this.rsBorder.posZ;
        this.rightSelect.posZ() - 0.02 => this.rightSelect.posZ;
    }

    fun void resetRight() {
        0 => this.rightButtonPressed;
        this.rsBorder.posZ() + 0.02 => this.rsBorder.posZ;
        this.rightSelect.posZ() + 0.02 => this.rightSelect.posZ;
    }

    fun void clickPlus() {
        1 => this.plusButtonPressed;
        this.plusBorder.posZ() - 0.02 => this.plusBorder.posZ;
        this.plusSelect.posZ() - 0.02 => this.plusSelect.posZ;
    }

    fun void resetPlus() {
        0 => this.plusButtonPressed;
        this.plusBorder.posZ() + 0.02 => this.plusBorder.posZ;
        this.plusSelect.posZ() + 0.02 => this.plusSelect.posZ;
    }

    fun void clickMinus() {
        1 => this.minusButtonPressed;
        this.minusBorder.posZ() - 0.02 => this.minusBorder.posZ;
        this.minusSelect.posZ() - 0.02 => this.minusSelect.posZ;
    }

    fun void resetMinus() {
        0 => this.minusButtonPressed;
        this.minusBorder.posZ() + 0.02 => this.minusBorder.posZ;
        this.minusSelect.posZ() + 0.02 => this.minusSelect.posZ;
    }

    fun void setTheme(Theme newTheme) {
        newTheme.primary => this.inside.color;
        newTheme.primary => this.lsInside.color;
        newTheme.primary => this.rsInside.color;
        newTheme.primary => this.plusInside.color;
        newTheme.primary => this.minusInside.color;

        newTheme.secondary => this.border.color;
        newTheme.secondary => this.lsBorder.color;
        newTheme.secondary => this.rsBorder.color;
        newTheme.secondary => this.plusBorder.color;
        newTheme.secondary => this.minusBorder.color;
    }
}


public class ThemeSelect extends GGen {
    GCube border;
    GPlane inside;

    GText leftSelect;
    GCube lsBorder;
    GPlane lsInside;

    GText rightSelect;
    GCube rsBorder;
    GPlane rsInside;

    GText theme;
    GCube tBorder;
    GPlane tInside;

    int leftButtonPressed;
    int rightButtonPressed;

    fun @construct() {
        // Scaling
        @(1.5, 1., 0.05) => this.border.sca;
        @(1.4, 0.9, 0.9) => this.inside.sca;

        @(0.2, 0.2, 0.2) => this.leftSelect.sca;
        @(0.25, 0.25, 0.05) => this.lsBorder.sca;
        @(0.9, 0.9, 0.9) => this.lsInside.sca;

        @(0.2, 0.2, 0.2) => this.rightSelect.sca;
        @(0.25, 0.25, 0.05) => this.rsBorder.sca;
        @(0.9, 0.9, 0.9) => this.rsInside.sca;

        @(0.2, 0.2, 0.2) => this.theme.sca;
        @(1.2, 0.35, 0.05) => this.tBorder.sca;
        @(0.98, 0.9, 0.9) => this.tInside.sca;

        // Position
        -0.025 => this.border.posZ;
        0.001 => this.inside.posZ;

        @(0, 0.15, 0.0251) => this.theme.pos;
        @(0, 0.15, 0) => this.tBorder.pos;
        0.501 => this.tInside.posZ;

        @(-0.3, -0.25, 0.0251) => this.leftSelect.pos;
        @(-0.3, -0.25, 0) => this.lsBorder.pos;
        0.501 => this.lsInside.posZ;

        @(0.3, -0.25, 0.0251) => this.rightSelect.pos;
        @(0.3, -0.25, 0) => this.rsBorder.pos;
        0.501 => this.rsInside.posZ;

        @(-5.12, -2.81, 0.) => this.pos;

        // Text
        "Classic" => this.theme.text;
        "<" => this.leftSelect.text;
        ">" => this.rightSelect.text;

        // Color
        Color.WHITE * 2. => this.border.color;
        Color.WHITE * 2. => this.lsBorder.color;
        Color.WHITE * 2. => this.rsBorder.color;
        Color.WHITE * 2. => this.tBorder.color;

        Color.BLACK => this.inside.color;
        Color.BLACK => this.lsInside.color;
        Color.BLACK => this.rsInside.color;
        Color.BLACK => this.tInside.color;

        @(2., 2., 2., 1.) => this.theme.color;

        // Name
        "Border" => this.border.name;
        "Inside" => this.inside.name;

        "Left Select" => this.leftSelect.name;
        "LS Border" => this.lsBorder.name;
        "LS Inside" => this.lsInside.name;

        "Right Select" => this.rightSelect.name;
        "RS Border" => this.rsBorder.name;
        "RS Inside" => this.rsInside.name;

        "Selected Theme" => this.theme.name;
        "T Border" => this.tBorder.name;
        "T Inside" => this.tInside.name;

        "Theme UI" => this.name;

        // Connection
        border --> this;
        inside --> this;

        leftSelect --> this;
        lsInside --> lsBorder --> this;

        rightSelect --> this;
        rsInside --> rsBorder --> this;

        theme --> this;
        tInside --> tBorder --> this;

        this --> GG.scene();
    }

    fun int checkIfSelected(vec2 mousePos) {
        0 => int selectMode;
        if (mousePos.y >= 1364 && mousePos.y <= 1414) {
            if (mousePos.x >= 75 && mousePos.x <= 125) -1 => selectMode;
            if (mousePos.x >= 205 && mousePos.x <= 255) 1 => selectMode;
        }

        return selectMode;
    }

    fun void clickLeft() {
        1 => this.leftButtonPressed;
        this.lsBorder.posZ() - 0.02 => this.lsBorder.posZ;
        this.leftSelect.posZ() - 0.02 => this.leftSelect.posZ;
    }

    fun void resetLeft() {
        0 => this.leftButtonPressed;
        this.lsBorder.posZ() + 0.02 => this.lsBorder.posZ;
        this.leftSelect.posZ() + 0.02 => this.leftSelect.posZ;
    }

    fun void clickRight() {
        1 => this.rightButtonPressed;
        this.rsBorder.posZ() - 0.02 => this.rsBorder.posZ;
        this.rightSelect.posZ() - 0.02 => this.rightSelect.posZ;
    }

    fun void resetRight() {
        0 => this.rightButtonPressed;
        this.rsBorder.posZ() + 0.02 => this.rsBorder.posZ;
        this.rightSelect.posZ() + 0.02 => this.rightSelect.posZ;
    }

    fun void setText(string text) {
        text => this.theme.text;
    }

    fun void setTheme(Theme newTheme) {
        newTheme.primary => this.inside.color;
        newTheme.primary => this.lsInside.color;
        newTheme.primary => this.rsInside.color;
        newTheme.primary => this.tInside.color;

        newTheme.secondary => this.border.color;
        newTheme.secondary => this.lsBorder.color;
        newTheme.secondary => this.rsBorder.color;
        newTheme.secondary => this.tBorder.color;
    }
}
