/*
TODO:

- Instead of having each key generate its own pane, add static panes
  the screen. Each key will have a PaneIdx that + will color the left X and Right X shards
  with that color. Thus each pane has a "length", and you can check if two or more panes
  overlap. The paneIdx will be the exact color as the key, and then you can compute
  the gradient better so each key still stands out.
- Instead of having panes composed of shreds, just have a pane be equal to a shred
- Panes still need to be in a list in order to recalculate / compute color gradients, but instead
  of each pane being its own visual, it just stores its indexes and baseColor

*/

@import "background.ck"
@import "themes.ck"
@import "ui.ck"


public class NotePane extends GGen {
    GPlane border;
    GPlane inner;
    GText noteText;

    int visible;
    float initialXScale;

    fun @construct(vec3 color, string noteName) {
        NotePane(color, noteName, 0.25);
    }

    fun @construct(vec3 color, string noteName, float initScale) {
        // Text
        noteName => this.noteText.text;

        // Scale
        @(0.9, 0.9, 0.9) => this.inner.sca;
        @(0.5, 0.5, 0.5) => this.noteText.sca;
        @(initScale, initScale, initScale) => this.sca;
        initScale => this.initialXScale;

        // Position
        0.005 => this.posZ;
        0.002 => this.inner.posZ;
        0.003 => this.noteText.posZ;

        // Color
        color => this.inner.color;
        Color.WHITE * 4. => this.border.color;
        @(4., 4., 4., 1.) => this.noteText.color;

        // Name
        "Border" => this.border.name;
        "Inside" => this.inner.name;
        "Note Text" => this.noteText.name;
        "Note Pane" => this.name;

        // Connections
        this.border --> this;
        this.inner --> this;
        this.noteText --> this.inner;
    }

    fun void setPos(float x, float y, float z) {
        x => this.posX;
        y => this.posY;
        z => this.posZ;
    }

    fun void updateScale(float visualizerXScale) {
        this.initialXScale / visualizerXScale => this.scaX;
    }
}


public class IntervalLine extends GGen {
    GLines line;
    NotePane @ intervalPane;

    string intervalName;

    fun @construct(string intervalName, Theme theme, vec2 points[], float width) {
        intervalName => this.intervalName;

        // Setup lines
        width => this.line.width;
        points => this.line.positions;
        theme.secondary => this.line.color;

        // Setup interval
        new NotePane(theme.primary, intervalName, 0.18) @=> this.intervalPane;

        // Position
        0.001 => this.posZ;

        (points[1].x + points[0].x) / 2. => float xPos;
        xPos => this.intervalPane.posX;
        Math.random2f(-0.5, 0.5) => this.posY;

        // Names
        "Line" => this.line.name;
        "Interval Line" => this.name;

        // Connections
        this.line --> this;
        this.intervalPane --> this;
    }

    fun void setY(float y) {
        y => this.posY;
    }

    fun updateTheme(Theme theme) {
        theme.primary => this.intervalPane.inner.color;
        theme.secondary => this.line.color;
    }
}


public class ColorPane {
    vec3 color;
    string noteName;
    int noteDiff;
    int panelIdx;

    // Visualizer position
    int center;
    int lower;
    int upper;

    // Visuals
    NotePane @ noteVisuals;
    IntervalLine intervals[0];
    int intervalMapping[0];
    int numIntervals;

    fun @construct(vec3 color, string noteName, int noteDiff, int center, int length, int upperMax) {
        color => this.color;
        noteName => this.noteName;
        noteDiff => this.noteDiff;

        // Active Panel IDX not set
        -1 => this.panelIdx;

        // Visuals
        new NotePane(color, noteName) @=> this.noteVisuals;

        // Indexing
        center => this.center;

        center - length => this.lower;
        if (this.lower < 0) 0 => this.lower;

        center + length => this.upper;
        if (this.upper > upperMax) upperMax => this.upper;
    }

    fun void setPanelIdx(int idx) {
        idx => this.panelIdx;
    }

    fun updateVisualScale(float visualizerXScale) {
        this.noteVisuals.updateScale(visualizerXScale);
        for (IntervalLine line : this.intervals) {
            line.intervalPane.updateScale(visualizerXScale);
        }
    }

    fun updateTheme(Theme theme) {
        for (IntervalLine line : this.intervals) {
            line.updateTheme(theme);
        }
    }

    fun void addInterval(IntervalLine interval, string intervalName) {
        this.intervals << interval;
        this.numIntervals => this.intervalMapping[intervalName];
        this.numIntervals++;
    }

    fun int checkInterval(string intervalName) {
        return this.intervalMapping.isInMap(intervalName);
    }

    fun IntervalLine getInterval(string intervalName) {
        this.intervalMapping[intervalName] => int idx;
        return this.intervals[idx];
    }

    fun void removeInterval(string intervalName) {
        if (this.checkInterval(intervalName)) {
            this.intervalMapping[intervalName] => int idx;
            this.intervalMapping.erase(intervalName);
            this.intervals.erase(idx);
            this.numIntervals--;

            // Remap interval name to list idx
            for (int idx; idx < this.numIntervals; idx++) {
                this.intervals[idx] @=> IntervalLine interval;
                idx => this.intervalMapping[interval.intervalName];
            }
        }

    }

    fun void clearIntervals() {
        this.intervals.clear();
        0 => this.numIntervals;

        string keys[0];
        this.intervalMapping.getKeys(keys);

        for (string key : keys) {
            this.intervalMapping.erase(key);
        }
    }
}


public class ColorVisualizer extends GGen {
    // Visual Color Shards
    GPlane shards[2000];
    0.01 => float xScaleFactor;
    2. => float yScaleFactor;
    int layerMode;

    // Hold Color Shards
    int hold;
    int track;

    // Color Panes
    ColorPane panesMap[0];
    ColorPane activePanes[0];

    // Tuning
    Tuning @ tuning;

    // Theme
    Theme @ theme;

    // Layers
    0 => int BLOCK;
    1 => int BLEND;
    2 => int BLEND_SHOW_CENTER;
    3 => int BLEND_SHOW_NOTE_NAMES;
    4 => int BLEND_SHOW_INTERVALS;

    [
        "Block",
        "Blend",
        "Blend+Center",
        "Blend+Notes",
        "Blend+Intervals"
    ] @=> string layersText[];

    [
        0.2,
        0.2,
        0.15,
        0.15,
        0.12,
    ] @=> float layersTextScale[];

    fun @construct(Tuning tuning) {
        // Tuning
        tuning @=> this.tuning;
        12 => this.activePanes.capacity;
        1 => this.layerMode;

        // Handle shards
        (this.shards.size() / 2 )$int => int midPoint;

        // Left shards
        for (int idx; idx < midPoint; idx++) {
            this.shards[idx] @=> GPlane shard;
            @(this.xScaleFactor, this.yScaleFactor, 1.) => shard.sca;
            ((-1 * (midPoint - idx)) * this.xScaleFactor) + (this.xScaleFactor / 2.) => shard.posX;

            // Set default color
            Color.BLACK => shard.color;

            // Connect to visualizer
            "Shard" + idx => shard.name;
            shard --> this;
        }

        // Right shards
        for (midPoint => int idx; idx < this.shards.size(); idx++) {
            this.shards[idx] @=> GPlane shard;
            @(this.xScaleFactor, this.yScaleFactor, 1.) => shard.sca;
            ((idx - midPoint) * this.xScaleFactor) + (this.xScaleFactor / 2.) => shard.posX;

            // Set default color
            Color.BLACK => shard.color;

            // Connect to visualizer
            "Shard" + idx => shard.name;
            shard --> this;
        }

        this --> GG.scene();
        "ColorVisualizer" => this.name;
    }

    fun void setTuning(Tuning tuning) {
        if (this.hold == 1 || this.track == 1) return;
        tuning @=> this.tuning;
    }

    fun void setTheme(Theme theme) {
        theme @=> this.theme;

        for (ColorPane pane : this.activePanes) {
            pane.updateTheme(theme);
        }
    }

    fun void setColorGradient(vec3 leftColor, vec3 rightColor) {
        this.setColorGradient(leftColor, rightColor, 0, this.shards.size());
    }

    fun void setColorGradient(vec3 leftColor, vec3 rightColor, int startIdx, int endIdx) {
        Color.rgb2hsv(leftColor).x => float leftHue;
        Color.rgb2hsv(rightColor).x => float rightHue;

        for (startIdx => int idx; idx < endIdx; idx++) {
            this.shards[idx] @=> GPlane shard;

            leftColor.x => float redMin;
            rightColor.x => float redMax;
            Std.scalef(idx, startIdx, endIdx, redMin, redMax) => float red;

            leftColor.y => float greenMin;
            rightColor.y => float greenMax;
            Std.scalef(idx, startIdx, endIdx, greenMin, greenMax) => float green;

            leftColor.z => float blueMin;
            rightColor.z => float blueMax;
            Std.scalef(idx, startIdx, endIdx, blueMin, blueMax) => float blue;

            @(red, green, blue) => shard.color;
        }
    }

    fun void setColor(vec3 color, int startIdx, int endIdx) {
        for (startIdx => int idx; idx < endIdx; idx++) {
            this.shards[idx] @=> GPlane shard;
            color => shard.color;
        }
    }

    fun void setPos(float x, float y, float z) {
        x => this.posX;
        y => this.posY;
        z => this.posZ;
    }

    fun void setScale(float x, float y, float z) {
        x => this.scaX;
        y => this.scaY;
        z => this.scaZ;
    }

    fun void scaleWidth(float diff) {
        this.scaX() + diff => this.scaX;
    }

    fun void translate(float diff) {
        diff => this.translateX;
    }

    fun void updateNoteScale() {
        if (this.layerMode == this.BLEND_SHOW_NOTE_NAMES || this.layerMode == this.BLEND_SHOW_INTERVALS) {
            for (ColorPane pane : this.activePanes) {
                pane.updateVisualScale(this.scaX());
            }
        }
    }

    fun void setHold() {
        1 => this.hold;
    }

    fun void setHold(dur wait) {
        wait => now;
        1 => this.hold;
    }

    fun void releaseHold() {
        0 => this.hold;

        string keys[0];
        this.panesMap.getKeys(keys);

        for (string key : keys) {
            this.removePane(key);
        }
    }

    fun void setTrack() {
        1 => this.track;
    }

    fun void setTrack(dur wait) {
        wait => now;
        1 => this.track;
        <<< "Set track", this.track >>>;
    }

    fun void releaseTrack() {
        0 => this.track;
    }

    fun void changeLayer(int diff) {
        this.layerMode + diff => this.layerMode;

        if (this.layerMode < 0) {
            this.layersText.size() + this.layerMode => this.layerMode;
        }

        this.layerMode % this.layersText.size() => this.layerMode;
    }

    fun Text getLayerType() {
        this.layersText[this.layerMode] => string text;
        this.layersTextScale[this.layerMode] => float scale;
        return new Text(text, scale);
    }

    fun void addPane(string key, vec3 color, int shardCenter, string noteName, int noteDiff) {
        // Skip if in hold mode
        if (this.hold == 1) return;

        ColorPane pane(color, noteName, noteDiff, shardCenter, 125, this.shards.size());
        pane.updateVisualScale(this.scaX());
        this.addPaneToActiveList(pane);

        pane @=> this.panesMap[key];
    }

    fun void removePane(string key) {
        // Skip if in hold mode
        if (this.hold == 1) return;

        this.panesMap[key] @=> ColorPane pane;
        this.setColor(Color.BLACK, pane.lower, pane.upper);

        if (this.layerMode == this.BLEND_SHOW_INTERVALS) {
            // Remove intervals connected to this pane
            for (int idx; idx < pane.panelIdx; idx++) {
                this.activePanes[idx] @=> ColorPane lowerPane;
                this.tuning.file.getIntervalBetweenNotes(lowerPane.noteDiff, pane.noteDiff) => string intervalName;

                lowerPane.getInterval(intervalName) --< this;
                lowerPane.removeInterval(intervalName);
            }

            // Remove intervals this pane is connected to
            for (IntervalLine line : pane.intervals) {
                line --< this;
            }
            pane.clearIntervals();
        }

        // Remove from active panels list
        this.removePaneToActiveList(pane);

        // Remove NotePane from scene
        if (pane.noteVisuals.visible) {
            pane.noteVisuals --< this;
            0 => pane.noteVisuals.visible;
        }
    }

    fun void addPaneToActiveList(ColorPane active) {
        0 => int activeIdx;

        // find where to insert pane
        while (activeIdx < this.activePanes.size()) {
            if (active.noteDiff < this.activePanes[activeIdx].noteDiff) {
                break;
            }

            activeIdx++;
        }

        // shift other panes over by 1
        this.activePanes.size() + 1 => this.activePanes.size;
        for (this.activePanes.size() - 1 => int idx; idx > activeIdx; idx--) {

            // Update PanelIdx
            this.activePanes[idx - 1] @=> this.activePanes[idx];
            this.activePanes[idx].setPanelIdx(idx);
        }

        // set active
        active.setPanelIdx(activeIdx);
        active @=> this.activePanes[activeIdx];
    }

    fun void removePaneToActiveList(ColorPane active) {
        0 => int activeIdx;

        // find where to remove pane
        while (activeIdx < this.activePanes.size()) {
            if (active.noteDiff == this.activePanes[activeIdx].noteDiff) {
                this.activePanes.popOut(activeIdx);
                break;
            }

            activeIdx++;
        }

        // Update Panel IDX for each pane
        for (int idx; idx < this.activePanes.size(); idx++) {
            this.activePanes[idx].setPanelIdx(idx);
        }
    }

    fun void update() {
        // Update colors

        if (this.layerMode == this.BLOCK) {
            for (ColorPane pane : this.activePanes) {
                this.setColor(pane.color, pane.lower, pane.upper);

                // Hide note if blend mode changed
                if (pane.noteVisuals.visible) {
                    pane.noteVisuals --< this;
                    0 => pane.noteVisuals.visible;
                }

                for (IntervalLine interval : pane.intervals) {
                    interval --< this;
                }

                pane.clearIntervals();
            }
        }

        // Blend colors together for every mode besides Block Mode
        if (this.layerMode != this.BLOCK) {
            if (this.activePanes.size() >= 1) {
                this.activePanes[0] @=> ColorPane pane;
                this.setColor(pane.color, pane.lower, pane.upper);
            }

            for (1 => int idx; idx < this.activePanes.size(); idx++) {

                this.activePanes[idx - 1] @=> ColorPane bottomPane;
                this.activePanes[idx] @=> ColorPane topPane;

                Color.rgb2hsv(bottomPane.color).x => float leftHue;
                Color.rgb2hsv(topPane.color).x => float rightHue;

                ( (leftHue + rightHue) / 2 ) % 360 => float blendHue;
                Color.hsv2rgb(@(blendHue, 1., 1.)) => vec3 blend;

                // TODO: If topPane.lower < bottomPane.center, just blend from center

                if (bottomPane.upper > topPane.lower) {
                    int topLowerIdx;

                    if (topPane.lower < bottomPane.center) {
                        bottomPane.center + 3 => topLowerIdx;
                        // <<< "New IDX", topLowerIdx, "Old IDX", topPane.lower >>>;
                    } else {
                        topPane.lower - 3 => topLowerIdx;
                    }

                    this.shards[topLowerIdx].color() => vec3 bottomColor;
                    this.shards[bottomPane.upper].color() => vec3 topColor;

                    ((bottomPane.upper - topLowerIdx) / 2)$int + topLowerIdx => int midPoint;
                    this.setColorGradient(bottomColor, blend, topLowerIdx, midPoint);
                    this.setColorGradient(blend, topColor, midPoint, bottomPane.upper);
                    this.setColor(topPane.color, bottomPane.upper, topPane.upper);
                } else {
                    this.setColor(topPane.color, topPane.lower, topPane.upper);
                }
            }
        }

        // Highlight Center
        if (this.layerMode == this.BLEND_SHOW_CENTER || this.layerMode == this.BLEND_SHOW_NOTE_NAMES || this.layerMode == this.BLEND_SHOW_INTERVALS) {
            for (ColorPane pane : this.activePanes) {
                this.setColor(pane.color * 3., pane.center - 2, pane.center + 2);

                // Add note names
                if (this.layerMode == this.BLEND_SHOW_NOTE_NAMES || this.layerMode == this.BLEND_SHOW_INTERVALS) {
                    this.shards[pane.center] @=> GPlane shard;

                    if (!pane.noteVisuals.visible) {
                        pane.noteVisuals --> this;

                        ((pane.noteDiff % 5) - 2) * 0.3 => float yDiff;
                        pane.noteVisuals.setPos(shard.posX(), shard.posY() + yDiff, 0.001);
                        1 => pane.noteVisuals.visible;
                    }
                } else {
                    // Otherwise remove note names
                    if (pane.noteVisuals.visible) {
                        pane.noteVisuals --< this;
                        0 => pane.noteVisuals.visible;
                    }
                }
            }
        }

        // Add interval information
        if (this.layerMode == this.BLEND_SHOW_INTERVALS) {
            // Set intervals between each pairing of panes
            for (int outerIdx; outerIdx < this.activePanes.size(); outerIdx++) {

                this.activePanes[outerIdx] @=> ColorPane startPane;
                for (outerIdx + 1 => int innerIdx; innerIdx < this.activePanes.size(); innerIdx++) {
                    this.activePanes[innerIdx] @=> ColorPane endPane;


                    startPane.noteDiff => int startDiff;
                    endPane.noteDiff => int endDiff;
                    this.tuning.file.getIntervalBetweenNotes(startDiff, endDiff) => string intervalName;

                    if (startPane.checkInterval(intervalName)) {
                        // Interval already exists, skip
                        continue;
                    }


                    // Calculate points
                    this.shards[startPane.center] @=> GPlane startShard;
                    this.shards[endPane.center] @=> GPlane endShard;

                    [
                        @(startShard.posX() + 0.015, startShard.posY()),
                        @(endShard.posX() - 0.028, endShard.posY())
                    ] @=> vec2 points[];

                    IntervalLine interval(intervalName, this.theme, points, 0.05);
                    startPane.addInterval(interval, intervalName);
                    startPane.updateVisualScale(this.scaX());
                    interval --> this;
                }
            }
        } else {
            for (ColorPane pane : this.activePanes) {
                for (IntervalLine interval : pane.intervals) {
                    interval --< this;
                }

                pane.clearIntervals();
            }
        }

        // Interval Y pos
        for (this.activePanes.size() - 1 => int idx; idx >= 0; idx--) {
            this.activePanes[idx] @=> ColorPane pane;
            (this.activePanes.size() - 2) - idx => float yDiff;
            Std.scalef(yDiff, 0, this.activePanes.size(), 0., 0.6) => yDiff;

            1 => int sign;
            for (int intervalIdx; intervalIdx < pane.numIntervals; intervalIdx++) {
                pane.intervals[intervalIdx] @=> IntervalLine interval;
                yDiff => float y;

                if (intervalIdx != 0) {
                    intervalIdx => float localDiff;
                    if (intervalIdx % 2 == 0) localDiff - 1 => localDiff;

                    (sign * 0.2 * localDiff) + (sign * yDiff) => y;

                    sign * -1 => sign;
                }
                interval.setY(y);
            }
        }
    }
}
