public class TuningSelect extends GGen {
    GPlane border;
    GPlane inside;
    GText leftSelect;
    GText rightSelect;
    GText tuning;

    fun @construct() {
        // Scaling
        @(1.5, 1., 1.) => this.border.sca;
        @(1.4, 0.9, 0.9) => this.inside.sca;
        @(0.2, 0.2, 0.2) => this.tuning.sca;
        @(0.2, 0.2, 0.2) => this.leftSelect.sca;
        @(0.2, 0.2, 0.2) => this.rightSelect.sca;

        // Position
        0.001 => this.inside.posZ;
        @(0, 0.05, 0.0011) => this.tuning.pos;
        @(-0.2, -0.25, 0.0011) => this.leftSelect.pos;
        @(0.2, -0.25, 0.0011) => this.rightSelect.pos;

        @(-5.12, -2.8, 0.) => this.pos;

        // Text
        "12 EDO" => this.tuning.text;
        "<" => this.leftSelect.text;
        ">" => this.rightSelect.text;

        // Color
        Color.WHITE * 2. => this.border.color;
        Color.BLACK => this.inside.color;

        // Name
        "Border" => this.border.name;
        "Inside" => this.inside.name;
        "Left Select" => this.leftSelect.name;
        "Right Select" => this.rightSelect.name;
        "Selected Tuning" => this.tuning.name;
        "Tuning UI" => this.name;

        // Connection
        border --> this;
        inside --> this;
        leftSelect --> this;
        rightSelect --> this;
        tuning --> this;
        this --> GG.scene();
    }

    fun int checkIfSelected(vec2 mousePos) {
        0 => int selectMode;
        if (mousePos.y >= 1367 && mousePos.y <= 1395) {
            if (mousePos.x >= 110 && mousePos.x <= 140) -1 => selectMode;
            if (mousePos.x >= 195 && mousePos.x <= 225) 1 => selectMode;
        }

        return selectMode;
    }

    fun void setText(string text) {
        text => this.tuning.text;
    }
}
