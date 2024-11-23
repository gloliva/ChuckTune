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

public class ColorPane extends GGen {
    GPlane shards[24];
    0.1 => float xScaleFactor;
    2. => float yScaleFactor;

    -1 => int noteDiff;

    vec3 baseColor;

    fun @construct(int noteDiff) {
        noteDiff => this.noteDiff;
        ColorPane();
    }

    fun @construct() {
        (this.shards.size() / 2 )$int => int midPoint;

        // Left shards
        for (int idx; idx < midPoint; idx++) {
            this.shards[idx] @=> GPlane shard;
            @(this.xScaleFactor, this.yScaleFactor, 1.) => shard.sca;
            ((-1 * (midPoint - idx)) * this.xScaleFactor) + (this.xScaleFactor / 2.) => shard.posX;

            "Shard" + idx => shard.name;
            shard --> this;
        }

        // Right shards
        for (midPoint => int idx; idx < this.shards.size(); idx++) {
            this.shards[idx] @=> GPlane shard;
            @(this.xScaleFactor, this.yScaleFactor, 1.) => shard.sca;
            ((idx - midPoint) * this.xScaleFactor) + (this.xScaleFactor / 2.) => shard.posX;

            "Shard" + idx => shard.name;
            shard --> this;
        }

        1.15 => this.scaX;
        "ColorPane" => this.name;
    }

    fun void setColorGradient(vec3 leftColor, vec3 rightColor) {
        this.setColorGradient(leftColor, rightColor, 0, this.shards.size());
    }

    fun void setColorGradient(vec3 leftColor, vec3 rightColor, int startIdx, int endIdx) {
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

    fun void setColor(vec3 color) {
        color => this.baseColor;

        for (GPlane shard: this.shards) {
            color => shard.color;
        }
    }

    fun void setColor(vec3 color, int startIdx, int endIdx) {
        for (startIdx => int idx; idx < endIdx; idx++) {
            this.shards[idx] @=> GPlane shard;
            color => shard.color;
        }
    }

    fun void resetColor() {
        for (GPlane shard: this.shards) {
            this.baseColor => shard.color;
        }
    }

    fun void setPos(float x, float y, float z) {
        x => this.posX;
        y => this.posY;
        z => this.posZ;
    }

    fun int getIntersectedShard(ColorPane other) {
        // TODO: fix this hard-coded mess
        this.posX() - other.posX() => float distance;
        Std.scalef(distance, 0., 2.6, 0., 23.)$int => int paneIdx;

        if (distance > 2.7) {
            return -1;
        }

        return paneIdx;
    }

    fun void attach() {
        this --> GG.scene();
    }

    fun void detach() {
        this --< GG.scene();
    }
}


public class ColorVisualizer {
    ColorPane panesMap[0];
    ColorPane activePanes[0];
    Tuning @ tuning;
    int steps;

    fun @construct(Tuning tuning) {
        tuning @=> this.tuning;
        tuning.file.length => this.steps;
        12 => this.activePanes.capacity;
    }

    fun void addPane(string key, vec3 color, int noteDiff) {
        ColorPane pane(noteDiff);
        pane.setColor(color);
        pane.attach();

        Std.scalef(noteDiff, -2, 2 * this.steps, -3., 3.) => float x;
        pane.setPos(x, 1.5, 0.001 * noteDiff);

        this.addPaneToActiveList(pane);

        pane @=> this.panesMap[key];
    }

    fun void removePane(string key) {
        this.panesMap[key] @=> ColorPane pane;
        this.removePaneToActiveList(pane);
        pane.detach();
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
            this.activePanes[idx - 1] @=> this.activePanes[idx];
        }

        // set active
        active @=> this.activePanes[activeIdx];
    }

    fun void removePaneToActiveList(ColorPane active) {
        0 => int activeIdx;

        // find where to insert pane
        while (activeIdx < this.activePanes.size()) {
            if (active.noteDiff == this.activePanes[activeIdx].noteDiff) {
                this.activePanes.popOut(activeIdx);
                break;
            }

            activeIdx++;
        }
    }

    fun void update() {
        // Update colors

        if (this.activePanes.size() == 1) {
            this.activePanes[0] @=> ColorPane pane;
            pane.resetColor();
        }

        for (1 => int idx; idx < this.activePanes.size(); idx++) {
            this.activePanes[idx - 1] @=> ColorPane bottomPane;
            this.activePanes[idx] @=> ColorPane topPane;

            topPane.getIntersectedShard(bottomPane) => int shardIdx;

            if (shardIdx != -1) {
                topPane.setColorGradient(bottomPane.shards[shardIdx].color(), topPane.baseColor);
            } else {
                topPane.resetColor();
            }

        }


    }
}
