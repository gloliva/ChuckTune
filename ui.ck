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
