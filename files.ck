public class TuningFile {
    string notes[0];
    int noteMapping[0];
    int keyboardToMidi[0];
    int length;

    fun void addNote(string note) {
        this.length => this.noteMapping[note];
        this.length++;
        this.notes << note;
    }

    fun void addKey(string key, int midiDiff) {
        midiDiff => this.keyboardToMidi[key];
    }

    fun string get(int idx) {
        if (idx < 0) {
            this.length + idx => idx;
        }

        idx % this.length => idx;
        return this.notes[idx];
    }

    fun int getIdx(string note) {
        return this.noteMapping[note];
    }
}


public class FileReader {
    FileIO fio;

    fun TuningFile parseFile(string filename) {
        TuningFile set();

        // Open file for reading
        fio.open(filename, FileIO.READ);
        if (!fio.good()) {
            <<< "Failed to open file: ", filename >>>;
            me.exit();
        } else {
            <<< "Successfully opened ", filename >>>;
        }

        fio.readLine().toInt() => int numNotes;

        // Read each line as a word
        repeat ( numNotes ) {
            fio.readLine() => string word;

            // Skip commented out lines
            if (word.charAt(0) != "#".charAt(0)) {
                set.addNote(word);
            }
        }

        // Skip empty line
        fio.readLine();

        // Read in keyboard mappings
        while (fio.more()) {
            fio.readLine() => string line;
            StringTokenizer tok;
            tok.set(line);
            string key, midiDiff;
            tok.next( key );
            tok.next( midiDiff );

            set.addKey(key, Std.atoi( midiDiff ));
        }

        return set;
    }
}
