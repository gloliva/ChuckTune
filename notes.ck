public class Note {
    // Accidentals
    "#".charAt(0) => int SHARP;
    "b".charAt(0) => int FLAT;
    "R" => string REST;

    // Base Note
    60 => int baseMidi;
    4 => int baseRegister;

    // This Note
    int midi;
    float freq;

    fun @construct(string noteSymbol) {
        // Handle rests
        if (noteSymbol == REST) {
            -1 => this.midi;
            0. => this.freq;
            return;
        }

        // Handle note
        noteSymbol.length() => int size;

        // Parse symbols from the note string
        noteSymbol.substring(0, 1).upper().charAt(0) - "A".charAt(0) => int noteName;
        -1 => int accidental;
        -1 => int register;

        if (size > 2) {
            noteSymbol.charAt(1) => accidental;
            noteSymbol.charAt(2) - "0".charAt(0) => register;
        } else {
            noteSymbol.charAt(1) - "0".charAt(0) => register;
        }

        // Handle Accidentals
        0 => int diff;
        if (accidental == SHARP) {
            1 => diff;
        } else if (accidental == FLAT) {
            -1 => diff;
        }

        // // Handle registers
        // NOTE_NAME_MAP[noteName] => int name;
        // if (name < 0) {
        //     register + 1 => register;
        // }

        // Calculate Midi and Freq
        this.baseMidi + diff + (name) + (12 * (register - baseRegister)) => this.midi;
        Math.mtof(this.midi) => this.freq;
    }

    fun int compare(Note other) {
        this.midi > other.midi;
    }
}
