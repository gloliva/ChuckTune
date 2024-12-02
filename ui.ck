public class Title extends GGen {
    GCube border;
    GPlane inside;
    GText titleTop;
    GText titleBot;

    fun @construct() {
        // Scaling
        @(1.5, 1.5, 0.05) => this.border.sca;
        @(1.4, 1.4, 0.9) => this.inside.sca;
        @(0.4, 0.4, 0.4) => this.titleTop.sca;
        @(0.5, 0.4, 0.4) => this.titleBot.sca;

        // Position
        -0.025 => this.border.posZ;
        0.001 => this.inside.posZ;

        @(0, 0.2, 0.01) => this.titleTop.pos;
        @(0, -0.2, 0.01) => this.titleBot.pos;

        @(-5.12, 2.57, 0.) => this.pos;

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

        @(-5.12, -2.8, 0.) => this.pos;

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
        if (mousePos.y >= 1362 && mousePos.y <= 1412) {
            if (mousePos.x >= 75 && mousePos.x <= 125) -1 => selectMode;
            if (mousePos.x >= 205 && mousePos.x <= 2255) 1 => selectMode;
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

        @(-5.12, -1.85, 0.) => this.pos;

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
        if (mousePos.y >= 1155 && mousePos.y <= 1205) {
            if (mousePos.x >= 75 && mousePos.x <= 125) -1 => selectMode;
            if (mousePos.x >= 205 && mousePos.x <= 2255) 1 => selectMode;
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
        text => this.instrument.text;
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

    int holdPressed;
    int currTimeSelected;
    int timeButtonPressed;
    dur waitTime;

    // Constants
    1 => int HOLD_PRESS;
    2 => int NOW_PRESS;
    3 => int SEC2_PRESS;
    4 => int SEC5_PRESS;

    fun @construct() {
        // Scaling
        @(1.5, 1., 0.05) => this.border.sca;
        @(1.4, 0.9, 0.9) => this.inside.sca;

        @(0.2, 0.2, 0.2) => this.nowTime.sca;
        @(0.4, 0.25, 0.05) => this.nowBorder.sca;
        @(0.95, 0.9, 0.9) => this.nowInside.sca;

        @(0.2, 0.2, 0.2) => this.sec2Time.sca;
        @(0.4, 0.25, 0.05) => this.sec2Border.sca;
        @(0.95, 0.9, 0.9) => this.sec2Inside.sca;

        @(0.2, 0.2, 0.2) => this.sec5Time.sca;
        @(0.4, 0.25, 0.05) => this.sec5Border.sca;
        @(0.95, 0.9, 0.9) => this.sec5Inside.sca;

        @(0.3, 0.3, 0.3) => this.hold.sca;
        @(1.2, 0.35, 0.05) => this.holdBorder.sca;
        @(0.98, 0.9, 0.9) => this.holdInside.sca;

        // Position
        -0.025 => this.border.posZ;
        0.001 => this.inside.posZ;

        @(0, 0.15, 0.0251) => this.hold.pos;
        @(0, 0.15, 0) => this.holdBorder.pos;
        0.501 => this.holdInside.posZ;

        @(-0.45, -0.25, 0.0251) => this.nowTime.pos;
        @(-0.45, -0.25, 0) => this.nowBorder.pos;
        0.501 => this.nowInside.posZ;

        @(0., -0.25, 0.0251) => this.sec2Time.pos;
        @(0., -0.25, 0) => this.sec2Border.pos;
        0.501 => this.sec2Inside.posZ;

        @(0.45, -0.25, 0.0251) => this.sec5Time.pos;
        @(0.45, -0.25, 0) => this.sec5Border.pos;
        0.501 => this.sec5Inside.posZ;

        @(-5.12, -0.9, 0.) => this.pos;

        // Text
        "HOLD" => this.hold.text;
        "Now" => this.nowTime.text;
        "2s" => this.sec2Time.text;
        "5s" => this.sec5Time.text;

        // Color
        Color.WHITE * 2. => this.border.color;
        Color.WHITE * 2. => this.nowBorder.color;
        Color.WHITE * 2. => this.sec2Border.color;
        Color.WHITE * 2. => this.sec5Border.color;
        Color.WHITE * 2. => this.holdBorder.color;

        Color.BLACK => this.inside.color;
        Color.BLACK => this.nowInside.color;
        Color.BLACK => this.sec2Inside.color;
        Color.BLACK => this.sec5Inside.color;
        Color.BLACK => this.holdInside.color;

        @(2., 2., 2., 1.) => this.hold.color;

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

        this --> GG.scene();
    }

    fun int checkIfSelected(vec2 mousePos) {
        0 => int selectMode;

        if (mousePos.y >= 850 && mousePos.y <= 920) {
            if (mousePos.x >= 38 && mousePos.x <= 294) this.HOLD_PRESS => selectMode;
        }

        if (mousePos.y >= 948 && mousePos.y <= 996) {
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
}
