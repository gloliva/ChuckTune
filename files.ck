public class TuningFile {
    string notes[0];
    int noteMapping[0];
    string intervalMapping[0];
    int keyboardToMidi[0];
    int length;

    fun void addNote(string note) {
        this.length => this.noteMapping[note];
        this.length++;
        this.notes << note;
    }

    fun void addInterval(string interval) {
        this.intervalMapping << interval;
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

    fun string getIntervalBetweenNotes(int lowerIdx, int upperIdx) {
        if (lowerIdx < 0) {
            upperIdx - lowerIdx => upperIdx;
            0 => lowerIdx;
        }

        upperIdx - lowerIdx => int distance;
        return this.getInterval(distance);
    }

    fun string getInterval(int distance) {
        return this.intervalMapping[distance % this.length];
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
            fio.readLine() => string line;

            StringTokenizer tok;
            tok.set(line);
            string note, interval;
            tok.next( note );
            tok.next( interval );

            // Skip commented out lines
            set.addNote(note);
            set.addInterval(interval);
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
