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
@import "ui.ck"


public class ColorPane {
    vec3 color;
    int noteDiff;

    int center;
    int lower;
    int upper;


    fun @construct(vec3 color, int noteDiff, int center, int length, int upperMax) {
        color => this.color;
        noteDiff => this.noteDiff;

        // Indexing
        center => this.center;

        center - length => this.lower;
        if (this.lower < 0) 0 => this.lower;

        center + length => this.upper;
        if (this.upper > upperMax) upperMax => this.upper;
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

    // Color Panes
    ColorPane panesMap[0];
    ColorPane activePanes[0];

    // Tuning
    Tuning @ tuning;
    int steps;

    // Layers
    0 => int BLOCK;
    1 => int BLEND;
    2 => int BLEND_SHOW_CENTER;

    [
        "Block",
        "Blend",
        "Blend+Center",
    ] @=> string layersText[];

    [
        0.2,
        0.2,
        0.15,
    ] @=> float layersTextScale[];

    fun @construct(Tuning tuning) {
        // Tuning
        tuning @=> this.tuning;
        tuning.file.length => this.steps;
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

        1.0 => this.scaX;
        this --> GG.scene();
        "ColorVisualizer" => this.name;
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

    fun void addPane(string key, vec3 color, int shardCenter, int noteDiff) {
        // Skip if in hold mode
        if (this.hold == 1) return;

        ColorPane pane(color, noteDiff, shardCenter, 125, this.shards.size());
        this.addPaneToActiveList(pane);

        pane @=> this.panesMap[key];
    }

    fun void removePane(string key) {
        // Skip if in hold mode
        if (this.hold == 1) return;

        this.panesMap[key] @=> ColorPane pane;
        this.setColor(Color.BLACK, pane.lower, pane.upper);
        this.removePaneToActiveList(pane);
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

        if (this.layerMode == this.BLOCK) {
            for (ColorPane pane : this.activePanes) {
                this.setColor(pane.color, pane.lower, pane.upper);
            }
        }

        if (this.layerMode == this.BLEND || this.layerMode == this.BLEND_SHOW_CENTER) {
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
                        bottomPane.center + 1 => topLowerIdx;
                        // <<< "New IDX", topLowerIdx, "Old IDX", topPane.lower >>>;
                    } else {
                        topPane.lower => topLowerIdx;
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

        if (this.layerMode == this.BLEND_SHOW_CENTER) {
            for (ColorPane pane : this.activePanes) {
                this.setColor(pane.color * 3., pane.center - 2, pane.center + 2);
            }
        }
    }
}
