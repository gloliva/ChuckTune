@import "files.ck"


public class Keyboard {

    int letterToIndex[0];
    string keyboardLayout[4][0];
    int midiBase;

    // Keyboard Visualizer
    TuningFile @ tuning;
    KeyboardVisuals visuals;

    fun @construct(TuningFile tuning) {
        48 => this.midiBase;
        tuning @=> this.tuning;
        this.setUpKeyMapping();
        this.setUpVisuals();
    }

    fun int getMidiNote(string key) {
        return this.midiBase + this.letterToIndex[key];
    }

    fun int getNoteDiff(string key) {
        return this.letterToIndex[key];
    }

    fun void updateTuning(TuningFile tuning) {
        tuning @=> this.tuning;
        this.setUpVisuals();
    }

    fun void setUpKeyMapping() {
        // Row 1: Z - '?'
        // 10 keys
        1 => this.letterToIndex["Z"];
        3 => this.letterToIndex["X"];
        5 => this.letterToIndex["C"];
        7 => this.letterToIndex["V"];
        9 => this.letterToIndex["B"];
        11 => this.letterToIndex["N"];
        13 => this.letterToIndex["M"];
        15 => this.letterToIndex[","];
        17 => this.letterToIndex["."];
        19 => this.letterToIndex["/"];

        [
            "Z", "X", "C", "V", "B",
            "N", "M", ",", ".", "/"
        ] @=> this.keyboardLayout[0];

        // Row 2: A - '''
        // 11 keys
        0 => this.letterToIndex["A"];
        2 => this.letterToIndex["S"];
        4 => this.letterToIndex["D"];
        6 => this.letterToIndex["F"];
        8 => this.letterToIndex["G"];
        10 => this.letterToIndex["H"];
        12 => this.letterToIndex["J"];
        14 => this.letterToIndex["K"];
        16 => this.letterToIndex["L"];
        18 => this.letterToIndex[";"];
        20 => this.letterToIndex["'"];

        [
            "A", "S", "D", "F", "G",
            "H", "J", "K", "L", ";", "'"
        ] @=> this.keyboardLayout[1];

        // Row 3: Q - ']'
        // 12 keys
        -1 => this.letterToIndex["Q"];
        1 => this.letterToIndex["W"];
        3 => this.letterToIndex["E"];
        5 => this.letterToIndex["R"];
        7 => this.letterToIndex["T"];
        9 => this.letterToIndex["Y"];
        11 => this.letterToIndex["U"];
        13 => this.letterToIndex["I"];
        15 => this.letterToIndex["O"];
        17 => this.letterToIndex["P"];
        19 => this.letterToIndex["["];
        21 => this.letterToIndex["]"];

        [
            "Q", "W", "E", "R", "T", "Y",
            "U", "I", "O", "P", "[", "]"
        ] @=> this.keyboardLayout[2];

        // Row 4: 1 - '='
        // 12 keys
        -2 => this.letterToIndex["1"];
        0 => this.letterToIndex["2"];
        2 => this.letterToIndex["3"];
        4 => this.letterToIndex["4"];
        6 => this.letterToIndex["5"];
        8 => this.letterToIndex["6"];
        10 => this.letterToIndex["7"];
        12 => this.letterToIndex["8"];
        14 => this.letterToIndex["9"];
        16 => this.letterToIndex["0"];
        18 => this.letterToIndex["-"];
        20 => this.letterToIndex["="];

        [
            "1", "2", "3", "4", "5", "6",
            "7", "8", "9", "0", "-", "="
        ] @=> this.keyboardLayout[3];
    }

    fun void setUpVisuals() {
        for (int row; row < this.keyboardLayout.size(); row++) {
            for (string key : this.keyboardLayout[row]) {
                this.letterToIndex[key] => int idx;
                this.tuning.get(idx) => string note;
                this.visuals.set(row, note, key);
            }
        }
    }
}


public class KeyboardKey extends GGen {
    // GPlane border;
    GCube border;
    GPlane inside;
    GText noteLetter;
    GText keyboardLetter;

    fun @construct() {
        KeyboardKey("NOT SET", "NOT SET");
    }

    fun @construct(string noteText, string keyboardText) {
        // Position
        -0.05 => this.border.posZ;
        0.01 => this.inside.posZ;
        0.02 => this.noteLetter.posZ;
        @(0.35, -0.35, 0.02) => this.keyboardLetter.pos;

        // Scale
        0.1 => this.border.scaZ;
        @(0.95, 0.95, 0.95) => this.inside.sca;
        @(0.5, 0.5, 0.5) => this.noteLetter.sca;
        @(0.2, 0.2, 0.2) => this.keyboardLetter.sca;

        // Color
        Color.WHITE => this.border.color;
        Color.BLACK => this.inside.color;
        @(2., 2., 2., 1.) => this.noteLetter.color;
        @(2., 2., 2., 1.) => this.keyboardLetter.color;

        // Text
        noteText => this.noteLetter.text;
        keyboardText => this.keyboardLetter.text;

        // Names
        "Border" => this.border.name;
        "Inside" => this.inside.name;
        "Note Text" => this.noteLetter.name;
        "Keyboard Text" => this.keyboardLetter.name;
        "Keyboard Key: " + noteText => this.name;

        this.border --> this;
        this.inside --> this;
        this.noteLetter --> this;
        this.keyboardLetter --> this;
    }

    fun void setText(string text) {
        text => this.noteLetter.text;
    }

    fun void setColor(vec3 color) {
        color => this.inside.color;
    }

    fun void setTextColor(vec3 color) {
        @(color.x, color.y, color.z, 1.) => this.noteLetter.color;
        @(color.x, color.y, color.z, 1.) => this.keyboardLetter.color;
    }

    fun void press() {
        0.1 => this.posZ;
    }

    fun void release() {
        0 => this.posZ;
    }

    fun void setPosX(float x) {
        x => this.posX;
    }
}


public class KeyboardRow extends GGen {
    KeyboardKey row[0];
    int length;
    int rowID;

    fun @construct() {
        // Names
        "Row" => this.name;
    }

    fun void addKey(string noteText, string keyboardText) {
        KeyboardKey key(noteText, keyboardText);
        this.length => key.setPosX;

        // Add to row
        this.row << key;
        this.length++;

        // Connect to this object
        key --> this;
    }

    fun void setRowID(int id) {
        id => this.rowID;
        "Row" + id => this.name;
    }

    fun void setPosX(float x) {
        x => this.posX;
    }

    fun void setPosY(float y) {
        y => this.posY;
    }

    fun void setKeyColor(vec3 color, int col) {
        this.row[col].setColor(color);
    }

    fun void setKeyColor(vec3 keyColor, vec3 textColor, int col) {
        this.row[col].setColor(keyColor);
        this.row[col].setTextColor(textColor);
    }

    fun void pressKey(int col) {
         this.row[col].press();
    }

    fun void releaseKey(int col) {
        this.row[col].release();
    }
}


public class KeyboardVisuals extends GGen {
    KeyboardRow rows[4];

    [-2.5, -2.8, -3.1, -3.4] @=> float xPos[];
    [-3., -2.41, -1.82, -1.23] @=> float yPos[];

    fun @construct() {
        for (int idx; idx < this.rows.size(); idx++) {
            this.rows[idx] @=> KeyboardRow row;

            // Scale row
            @(0.6, 0.6, 0.6) => row.sca;

            // Rotate
            -0.8 => this.rotX;

            // Set positions
            row.setPosX(xPos[idx]);
            row.setPosY(yPos[idx]);

            // Set row ID
            row.setRowID(idx);

            // Connections
            row --> this;
        }

        // Names
        "Keyboard Visualizer" => this.name;

        // Connections
        this --> GG.scene();
    }

    fun void set(int row, string note, string key) {
        this.rows[row].addKey(note, key);
    }

    fun void setKeyColor(vec3 keyColor, int row, int col) {
        this.rows[row].setKeyColor(keyColor, col);
    }

    fun void setKeyColor(vec3 keyColor, vec3 textColor, int row, int col) {
        this.rows[row].setKeyColor(keyColor, textColor, col);
    }

    fun void pressKey(int row, int col) {
         this.rows[row].pressKey(col);
    }

    fun void releaseKey(int row, int col) {
        this.rows[row].releaseKey(col);
    }
}
