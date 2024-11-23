public class Key {
    string key;
    int ascii;
    int num;
    int keyRow;
    int keyCol;

    fun @construct(string key) {
        Key(key, -1, -1);
    }

    fun @construct(string key, int row, int col) {
        key => this.key;
        key.charAt(0) => this.ascii;
        row => this.keyRow;
        col => this.keyCol;
    }
}


class LetterKey extends Key {
    int midiNote;

    fun @construct(string key) {
        Key(key, -1, -1);
    }

    fun @construct(string key, int row, int col) {
        Key(key, row, col);
        key.charAt(0) - "A".charAt(0) => this.num;
    }

    fun setMidiNote(int note) {
        note => this.midiNote;
    }
}


class NumberKey extends Key {
    fun @construct(string key) {
        Key(key, -1, -1);
    }

    fun @construct(string key, int row, int col) {
        Key(key, row, col);
        key.toInt() => this.num;
    }
}


class SpecialKey extends Key {
    fun @construct(string key) {
        Key(key, -1, -1);
    }

    fun @construct(string key, int row, int col) {
        Key(key, row, col);
    }
}


public class KeyPoller {
    // Key Types
    "LetterKey" => string LETTER_KEY;
    "NumberKey" => string NUMBER_KEY;
    "SpecialKey" => string SPECIAL_KEY;

    fun Key[] getKeyPress() {
        Key keys[0];

        // Letters
        if (GWindow.keyDown(GWindow.Key_A)) keys << new LetterKey("A", 1, 0);
        if (GWindow.keyDown(GWindow.Key_B)) keys << new LetterKey("B", 0, 4);
        if (GWindow.keyDown(GWindow.Key_C)) keys << new LetterKey("C", 0, 2);
        if (GWindow.keyDown(GWindow.Key_D)) keys << new LetterKey("D", 1, 2);
        if (GWindow.keyDown(GWindow.Key_E)) keys << new LetterKey("E", 2, 2);
        if (GWindow.keyDown(GWindow.Key_F)) keys << new LetterKey("F", 1, 3);
        if (GWindow.keyDown(GWindow.Key_G)) keys << new LetterKey("G", 1, 4);
        if (GWindow.keyDown(GWindow.Key_H)) keys << new LetterKey("H", 1, 5);
        if (GWindow.keyDown(GWindow.Key_I)) keys << new LetterKey("I", 2, 7);
        if (GWindow.keyDown(GWindow.Key_J)) keys << new LetterKey("J", 1, 6);
        if (GWindow.keyDown(GWindow.Key_K)) keys << new LetterKey("K", 1, 7);
        if (GWindow.keyDown(GWindow.Key_L)) keys << new LetterKey("L", 1, 8);
        if (GWindow.keyDown(GWindow.Key_M)) keys << new LetterKey("M", 0, 6);
        if (GWindow.keyDown(GWindow.Key_N)) keys << new LetterKey("N", 0, 5);
        if (GWindow.keyDown(GWindow.Key_O)) keys << new LetterKey("O", 2, 8);
        if (GWindow.keyDown(GWindow.Key_P)) keys << new LetterKey("P", 2, 9);
        if (GWindow.keyDown(GWindow.Key_Q)) keys << new LetterKey("Q", 2, 0);
        if (GWindow.keyDown(GWindow.Key_R)) keys << new LetterKey("R", 2, 3);
        if (GWindow.keyDown(GWindow.Key_S)) keys << new LetterKey("S", 1, 1);
        if (GWindow.keyDown(GWindow.Key_T)) keys << new LetterKey("T", 2, 4);
        if (GWindow.keyDown(GWindow.Key_U)) keys << new LetterKey("U", 2, 6);
        if (GWindow.keyDown(GWindow.Key_V)) keys << new LetterKey("V", 0, 3);
        if (GWindow.keyDown(GWindow.Key_W)) keys << new LetterKey("W", 2, 1);
        if (GWindow.keyDown(GWindow.Key_X)) keys << new LetterKey("X", 0, 1);
        if (GWindow.keyDown(GWindow.Key_Y)) keys << new LetterKey("Y", 2, 5);
        if (GWindow.keyDown(GWindow.Key_Z)) keys << new LetterKey("Z", 0, 0);

        // Numbers
        if (GWindow.keyDown(GWindow.Key_0)) keys << new NumberKey("0", 3, 9);
        if (GWindow.keyDown(GWindow.Key_1)) keys << new NumberKey("1", 3, 0);
        if (GWindow.keyDown(GWindow.Key_2)) keys << new NumberKey("2", 3, 1);
        if (GWindow.keyDown(GWindow.Key_3)) keys << new NumberKey("3", 3, 2);
        if (GWindow.keyDown(GWindow.Key_4)) keys << new NumberKey("4", 3, 3);
        if (GWindow.keyDown(GWindow.Key_5)) keys << new NumberKey("5", 3, 4);
        if (GWindow.keyDown(GWindow.Key_6)) keys << new NumberKey("6", 3, 5);
        if (GWindow.keyDown(GWindow.Key_7)) keys << new NumberKey("7", 3, 6);
        if (GWindow.keyDown(GWindow.Key_8)) keys << new NumberKey("8", 3, 7);
        if (GWindow.keyDown(GWindow.Key_9)) keys << new NumberKey("9", 3, 8);

        // Special characters
        if (GWindow.keyDown(GWindow.Key_Comma)) keys << new SpecialKey(",", 0, 7);
        if (GWindow.keyDown(GWindow.Key_Period)) keys << new SpecialKey(".", 0, 8);
        if (GWindow.keyDown(GWindow.Key_Slash)) keys << new SpecialKey("/", 0, 9);
        if (GWindow.keyDown(GWindow.Key_Semicolon)) keys << new SpecialKey(";", 1, 9);
        if (GWindow.keyDown(GWindow.Key_Apostrophe)) keys << new SpecialKey("'", 1, 10);
        if (GWindow.keyDown(GWindow.Key_RightBracket)) keys << new SpecialKey("]", 2, 11);
        if (GWindow.keyDown(GWindow.Key_LeftBracket)) keys << new SpecialKey("[", 2, 10);
        if (GWindow.keyDown(GWindow.Key_Minus)) keys << new SpecialKey("-", 3, 10);
        if (GWindow.keyDown(GWindow.Key_Equal)) keys << new SpecialKey("=", 3, 11);

        return keys;
    }

    fun Key[] getKeyHeld() {
        Key keys[0];

        // Letters
        if (GWindow.key(GWindow.Key_A)) keys << new LetterKey("A", 1, 0);
        if (GWindow.key(GWindow.Key_B)) keys << new LetterKey("B", 0, 4);
        if (GWindow.key(GWindow.Key_C)) keys << new LetterKey("C", 0, 2);
        if (GWindow.key(GWindow.Key_D)) keys << new LetterKey("D", 1, 2);
        if (GWindow.key(GWindow.Key_E)) keys << new LetterKey("E", 2, 2);
        if (GWindow.key(GWindow.Key_F)) keys << new LetterKey("F", 1, 3);
        if (GWindow.key(GWindow.Key_G)) keys << new LetterKey("G", 1, 4);
        if (GWindow.key(GWindow.Key_H)) keys << new LetterKey("H", 1, 5);
        if (GWindow.key(GWindow.Key_I)) keys << new LetterKey("I", 2, 7);
        if (GWindow.key(GWindow.Key_J)) keys << new LetterKey("J", 1, 6);
        if (GWindow.key(GWindow.Key_K)) keys << new LetterKey("K", 1, 7);
        if (GWindow.key(GWindow.Key_L)) keys << new LetterKey("L", 1, 8);
        if (GWindow.key(GWindow.Key_M)) keys << new LetterKey("M", 0, 6);
        if (GWindow.key(GWindow.Key_N)) keys << new LetterKey("N", 0, 5);
        if (GWindow.key(GWindow.Key_O)) keys << new LetterKey("O", 2, 8);
        if (GWindow.key(GWindow.Key_P)) keys << new LetterKey("P", 2, 9);
        if (GWindow.key(GWindow.Key_Q)) keys << new LetterKey("Q", 2, 0);
        if (GWindow.key(GWindow.Key_R)) keys << new LetterKey("R", 2, 3);
        if (GWindow.key(GWindow.Key_S)) keys << new LetterKey("S", 1, 1);
        if (GWindow.key(GWindow.Key_T)) keys << new LetterKey("T", 2, 4);
        if (GWindow.key(GWindow.Key_U)) keys << new LetterKey("U", 2, 6);
        if (GWindow.key(GWindow.Key_V)) keys << new LetterKey("V", 0, 3);
        if (GWindow.key(GWindow.Key_W)) keys << new LetterKey("W", 2, 1);
        if (GWindow.key(GWindow.Key_X)) keys << new LetterKey("X", 0, 1);
        if (GWindow.key(GWindow.Key_Y)) keys << new LetterKey("Y", 2, 5);
        if (GWindow.key(GWindow.Key_Z)) keys << new LetterKey("Z", 0, 0);

        // Numbers
        if (GWindow.key(GWindow.Key_0)) keys << new NumberKey("0", 3, 9);
        if (GWindow.key(GWindow.Key_1)) keys << new NumberKey("1", 3, 0);
        if (GWindow.key(GWindow.Key_2)) keys << new NumberKey("2", 3, 1);
        if (GWindow.key(GWindow.Key_3)) keys << new NumberKey("3", 3, 2);
        if (GWindow.key(GWindow.Key_4)) keys << new NumberKey("4", 3, 3);
        if (GWindow.key(GWindow.Key_5)) keys << new NumberKey("5", 3, 4);
        if (GWindow.key(GWindow.Key_6)) keys << new NumberKey("6", 3, 5);
        if (GWindow.key(GWindow.Key_7)) keys << new NumberKey("7", 3, 6);
        if (GWindow.key(GWindow.Key_8)) keys << new NumberKey("8", 3, 7);
        if (GWindow.key(GWindow.Key_9)) keys << new NumberKey("9", 3, 8);

        // Special characters
        if (GWindow.key(GWindow.Key_Comma)) keys << new SpecialKey(",", 0, 7);
        if (GWindow.key(GWindow.Key_Period)) keys << new SpecialKey(".", 0, 8);
        if (GWindow.key(GWindow.Key_Slash)) keys << new SpecialKey("/", 0, 9);
        if (GWindow.key(GWindow.Key_Semicolon)) keys << new SpecialKey(";", 1, 9);
        if (GWindow.key(GWindow.Key_Apostrophe)) keys << new SpecialKey("'", 1, 10);
        if (GWindow.key(GWindow.Key_RightBracket)) keys << new SpecialKey("]", 2, 11);
        if (GWindow.key(GWindow.Key_LeftBracket)) keys << new SpecialKey("[", 2, 10);
        if (GWindow.key(GWindow.Key_Minus)) keys << new SpecialKey("-", 3, 10);
        if (GWindow.key(GWindow.Key_Equal)) keys << new SpecialKey("=", 3, 11);

        return keys;
    }

    fun Key[] getKeyRelease() {
        Key keys[0];

        // Letters
        if (GWindow.keyUp(GWindow.Key_A)) keys << new LetterKey("A", 1, 0);
        if (GWindow.keyUp(GWindow.Key_B)) keys << new LetterKey("B", 0, 4);
        if (GWindow.keyUp(GWindow.Key_C)) keys << new LetterKey("C", 0, 2);
        if (GWindow.keyUp(GWindow.Key_D)) keys << new LetterKey("D", 1, 2);
        if (GWindow.keyUp(GWindow.Key_E)) keys << new LetterKey("E", 2, 2);
        if (GWindow.keyUp(GWindow.Key_F)) keys << new LetterKey("F", 1, 3);
        if (GWindow.keyUp(GWindow.Key_G)) keys << new LetterKey("G", 1, 4);
        if (GWindow.keyUp(GWindow.Key_H)) keys << new LetterKey("H", 1, 5);
        if (GWindow.keyUp(GWindow.Key_I)) keys << new LetterKey("I", 2, 7);
        if (GWindow.keyUp(GWindow.Key_J)) keys << new LetterKey("J", 1, 6);
        if (GWindow.keyUp(GWindow.Key_K)) keys << new LetterKey("K", 1, 7);
        if (GWindow.keyUp(GWindow.Key_L)) keys << new LetterKey("L", 1, 8);
        if (GWindow.keyUp(GWindow.Key_M)) keys << new LetterKey("M", 0, 6);
        if (GWindow.keyUp(GWindow.Key_N)) keys << new LetterKey("N", 0, 5);
        if (GWindow.keyUp(GWindow.Key_O)) keys << new LetterKey("O", 2, 8);
        if (GWindow.keyUp(GWindow.Key_P)) keys << new LetterKey("P", 2, 9);
        if (GWindow.keyUp(GWindow.Key_Q)) keys << new LetterKey("Q", 2, 0);
        if (GWindow.keyUp(GWindow.Key_R)) keys << new LetterKey("R", 2, 3);
        if (GWindow.keyUp(GWindow.Key_S)) keys << new LetterKey("S", 1, 1);
        if (GWindow.keyUp(GWindow.Key_T)) keys << new LetterKey("T", 2, 4);
        if (GWindow.keyUp(GWindow.Key_U)) keys << new LetterKey("U", 2, 6);
        if (GWindow.keyUp(GWindow.Key_V)) keys << new LetterKey("V", 0, 3);
        if (GWindow.keyUp(GWindow.Key_W)) keys << new LetterKey("W", 2, 1);
        if (GWindow.keyUp(GWindow.Key_X)) keys << new LetterKey("X", 0, 1);
        if (GWindow.keyUp(GWindow.Key_Y)) keys << new LetterKey("Y", 2, 5);
        if (GWindow.keyUp(GWindow.Key_Z)) keys << new LetterKey("Z", 0, 0);

        // Numbers
        if (GWindow.keyUp(GWindow.Key_0)) keys << new NumberKey("0", 3, 9);
        if (GWindow.keyUp(GWindow.Key_1)) keys << new NumberKey("1", 3, 0);
        if (GWindow.keyUp(GWindow.Key_2)) keys << new NumberKey("2", 3, 1);
        if (GWindow.keyUp(GWindow.Key_3)) keys << new NumberKey("3", 3, 2);
        if (GWindow.keyUp(GWindow.Key_4)) keys << new NumberKey("4", 3, 3);
        if (GWindow.keyUp(GWindow.Key_5)) keys << new NumberKey("5", 3, 4);
        if (GWindow.keyUp(GWindow.Key_6)) keys << new NumberKey("6", 3, 5);
        if (GWindow.keyUp(GWindow.Key_7)) keys << new NumberKey("7", 3, 6);
        if (GWindow.keyUp(GWindow.Key_8)) keys << new NumberKey("8", 3, 7);
        if (GWindow.keyUp(GWindow.Key_9)) keys << new NumberKey("9", 3, 8);

        // Special characters
        if (GWindow.keyUp(GWindow.Key_Comma)) keys << new SpecialKey(",", 0, 7);
        if (GWindow.keyUp(GWindow.Key_Period)) keys << new SpecialKey(".", 0, 8);
        if (GWindow.keyUp(GWindow.Key_Slash)) keys << new SpecialKey("/", 0, 9);
        if (GWindow.keyUp(GWindow.Key_Semicolon)) keys << new SpecialKey(";", 1, 9);
        if (GWindow.keyUp(GWindow.Key_Apostrophe)) keys << new SpecialKey("'", 1, 10);
        if (GWindow.keyUp(GWindow.Key_RightBracket)) keys << new SpecialKey("]", 2, 11);
        if (GWindow.keyUp(GWindow.Key_LeftBracket)) keys << new SpecialKey("[", 2, 10);
        if (GWindow.keyUp(GWindow.Key_Minus)) keys << new SpecialKey("-", 3, 10);
        if (GWindow.keyUp(GWindow.Key_Equal)) keys << new SpecialKey("=", 3, 11);

        return keys;
    }
}
