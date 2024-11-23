public class TuningFile {
    string notes[0];
    int noteMapping[0];
    int length;

    fun void add(string note) {
        this.length => this.noteMapping[note];
        this.length++;
        this.notes << note;
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

        // Read each line as a word
        while (fio.more()) {
            fio.readLine().upper() => string word;

            // Skip commented out lines
            if (word.charAt(0) != "#".charAt(0)) {
                set.add(word);
            }
        }

        return set;
    }
}
