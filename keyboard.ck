@import "files.ck"
@import "themes.ck"
@import "tuning.ck"


public class Keyboard {
    string keyboardLayout[4][0];
    int midiBase;

    // Keyboard Visualizer
    Tuning @ tuning;
    KeyboardVisuals @ visuals;

    fun @construct(Tuning tuning, int hideVisuals) {
        48 => this.midiBase;
        tuning @=> this.tuning;
        new KeyboardVisuals(hideVisuals) @=> this.visuals;

        this.setUpKeyMapping();
        this.setUpVisuals();
    }

    fun float getFreq(string key) {
        this.getNoteDiff(key) => int midiDiff;
        return this.tuning.freq(midiDiff);
    }

    fun float getFreq(string key, Tuning tuning) {
        this.getNoteDiff(key, tuning) => int midiDiff;
        return tuning.freq(midiDiff);
    }

    fun int getNoteDiff(string key) {
        return this.tuning.file.keyboardToMidi[key];
    }

    fun int getNoteDiff(string key, Tuning tuning) {
        return tuning.file.keyboardToMidi[key];
    }

    fun string getNoteName(int keyRow, int keyCol) {
        return this.visuals.getRow(keyRow).getKey(keyCol).getNote();
    }

    fun string getNoteName(int keyRow, int keyCol, Tuning tuning) {
        this.keyboardLayout[keyRow][keyCol] => string key;
        tuning.file.keyboardToMidi[key] => int idx;
        tuning.file.get(idx) => string note;
        return note;
    }

    fun Note getClosestMatchingFreq(float otherFreq) {
        // TODO: fix magic numbers
        float lowerFreq;
        float upperFreq;

        -10 => int degree;
        while (degree < 50) {
            if (this.tuning.file.midiToKeyboard.isInMap(Std.itoa(degree))) {
                this.tuning.file.getKeyFromMidi(degree) => string key;
                this.getFreq(key) => float currFreq;
                if (currFreq > otherFreq) {
                    currFreq => upperFreq;
                    break;
                }

                currFreq => lowerFreq;
            }
            degree++;
        }

        otherFreq => float freq;
        if (Std.fabs(otherFreq - lowerFreq) < Std.fabs(upperFreq - otherFreq)) {
            lowerFreq => freq;
            degree - 1 => degree;
        } else {
            upperFreq => freq;
        }

        this.tuning.file.get(degree) => string name;
        return new Note(name, degree, freq);
    }

    fun void updateTuning(Tuning tuning) {
        tuning @=> this.tuning;
        this.updateVisuals();
    }

    fun void setUpKeyMapping() {
        // Row 1: Z - '?'
        // 10 keys
        [
            "Z", "X", "C", "V", "B",
            "N", "M", ",", ".", "/"
        ] @=> this.keyboardLayout[0];

        // Row 2: A - '''
        // 11 keys
        [
            "A", "S", "D", "F", "G",
            "H", "J", "K", "L", ";", "'"
        ] @=> this.keyboardLayout[1];

        // Row 3: Q - ']'
        // 12 keys
        [
            "Q", "W", "E", "R", "T", "Y",
            "U", "I", "O", "P", "[", "]"
        ] @=> this.keyboardLayout[2];

        // Row 4: 1 - '='
        // 12 keys
        [
            "1", "2", "3", "4", "5", "6",
            "7", "8", "9", "0", "-", "="
        ] @=> this.keyboardLayout[3];
    }

    fun void setUpVisuals() {
        for (int row; row < this.keyboardLayout.size(); row++) {
            for (string key : this.keyboardLayout[row]) {
                this.tuning.file.keyboardToMidi[key] => int idx;
                this.tuning.file.get(idx) => string note;
                this.visuals.addKey(row, note, key);
            }
        }
    }

    fun void updateVisuals() {
        for (int row; row < this.keyboardLayout.size(); row++) {
            for (int col; col < this.keyboardLayout[row].size(); col++) {
                this.keyboardLayout[row][col] => string key;
                this.tuning.file.keyboardToMidi[key] => int idx;
                this.tuning.file.get(idx) => string note;
                this.visuals.updateKey(row, col, note);
            }
        }
    }

    fun void setTheme(Theme currTheme) {
        for (int row; row < this.keyboardLayout.size(); row++) {
            for (int col; col < this.keyboardLayout[row].size(); col++) {
                this.visuals.setTheme(currTheme, row, col);
            }
        }
    }
}


public class KeyboardKey extends GGen {
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

    fun string getNote() {
        return this.noteLetter.text();
    }

    fun void setTheme(Theme currTheme) {
        currTheme.primary => this.inside.color;
        currTheme.secondary => this.border.color;
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

    fun void updateKey(string noteText, int keyIdx) {
        this.row[keyIdx].setText(noteText);
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

    fun KeyboardKey getKey(int col) {
        return this.row[col];
    }

    fun void setTheme(Theme currTheme, int col) {
        this.row[col].setTheme(currTheme);
    }
}


public class KeyboardVisuals extends GGen {
    KeyboardRow rows[4];

    [-2.5, -2.8, -3.1, -3.4] @=> float xPos[];
    [-3., -2.41, -1.82, -1.23] @=> float yPos[];

    fun @construct(int hideVisuals) {
        for (int idx; idx < this.rows.size(); idx++) {
            this.rows[idx] @=> KeyboardRow row;

            // Scale row
            @(0.6, 0.6, 0.6) => row.sca;

            // Set positions
            row.setPosX(xPos[idx]);
            row.setPosY(yPos[idx]);

            // Set row ID
            row.setRowID(idx);

            // Connections
            row --> this;
        }

        // Rotate
        -0.8 => this.rotX;

        // Move
        0.3 => this.posX;

        // Names
        "Keyboard Visualizer" => this.name;

        // Connections
        if (!hideVisuals) {
            this --> GG.scene();
        }
    }

    fun void addKey(int row, string note, string key) {
        this.rows[row].addKey(note, key);
    }

    fun void updateKey(int row, int col, string note) {
        this.rows[row].updateKey(note, col);
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

    fun KeyboardRow getRow(int row) {
        return this.rows[row];
    }

    fun void setTheme(Theme currTheme, int row, int col) {
        this.rows[row].setTheme(currTheme, col);
    }
}
