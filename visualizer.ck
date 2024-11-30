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
    GPlane shards[1000];
    0.01 => float xScaleFactor;
    2. => float yScaleFactor;

    // Color Panes
    ColorPane panesMap[0];
    ColorPane activePanes[0];

    // Tuning
    Tuning @ tuning;
    int steps;

    fun @construct(Tuning tuning) {
        // Tuning
        tuning @=> this.tuning;
        tuning.file.length => this.steps;
        12 => this.activePanes.capacity;

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

    fun void addPane(string key, vec3 color, int noteDiff) {
        Std.scalef(noteDiff, -2, 2 * this.steps, 100., this.shards.size() - 100)$int => int idx;
        ColorPane pane(color, noteDiff, idx, 100, this.shards.size());
        this.addPaneToActiveList(pane);

        pane @=> this.panesMap[key];
    }

    fun void removePane(string key) {
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

        if (this.activePanes.size() == 1) {
            this.activePanes[0] @=> ColorPane pane;
            this.setColor(pane.color, pane.lower, pane.upper);
        }

        for (ColorPane pane : this.activePanes) {
            this.setColor(pane.color, pane.lower, pane.upper);
        }

        for (1 => int idx; idx < this.activePanes.size(); idx++) {

            this.activePanes[idx - 1] @=> ColorPane bottomPane;
            this.activePanes[idx] @=> ColorPane topPane;

            // @(
            //     (bottomPane.color.x + topPane.color.x) / 2.,
            //     (bottomPane.color.y + topPane.color.y) / 2.,
            //     (bottomPane.color.z + topPane.color.z) / 2.
            // ) => vec3 blend;

            ( bottomPane.color.x )$int + 1 => int maxVal;

            @(
                maxVal - (maxVal - bottomPane.color.x) - (maxVal - topPane.color.x),
                maxVal - (maxVal - bottomPane.color.y) - (maxVal - topPane.color.y),
                maxVal - (maxVal - bottomPane.color.z) - (maxVal - topPane.color.z)
            ) => vec3 blend;


            if (blend.x < 0) 0 => blend.x;
            if (blend.y < 0) 0 => blend.y;
            if (blend.z < 0) 0 => blend.z;

            if (bottomPane.upper > topPane.lower) {
                this.shards[topPane.lower].color() => vec3 bottomColor;
                this.shards[bottomPane.upper].color() => vec3 topColor;


                ((bottomPane.upper - topPane.lower) / 2)$int + topPane.lower => int midPoint;
                this.setColorGradient(bottomPane.color, blend, topPane.lower, midPoint);
                this.setColorGradient(blend, topColor, midPoint, bottomPane.upper);
            }

            // if (bottomPane.upper > topPane.lower) {
            //     this.setColor(topPane.color, bottomPane.upper, topPane.upper);
            // } else {
            //     this.setColor(topPane.color, topPane.lower, topPane.upper);
            // }

            // topPane.getIntersectedShard(bottomPane) => int shardIdx;

            // if (shardIdx != -1) {
            //     topPane.setColorGradient(bottomPane.shards[shardIdx].color(), topPane.baseColor);
            // } else {
            //     topPane.resetColor();
            // }
        }
    }
}


// public class ColorVisualizer {
//     ColorPane panesMap[0];
//     ColorPane activePanes[0];
//     Tuning @ tuning;
//     int steps;

//     fun @construct(Tuning tuning) {
//         tuning @=> this.tuning;
//         tuning.file.length => this.steps;
//         12 => this.activePanes.capacity;
//     }

//     fun void addPane(string key, vec3 color, int noteDiff) {
//         ColorPane pane(noteDiff);
//         pane.setColor(color);
//         pane.attach();

//         Std.scalef(noteDiff, -2, 2 * this.steps, -3., 3.) => float x;
//         pane.setPos(x, 1.5, 0.001 * noteDiff);

//         this.addPaneToActiveList(pane);

//         pane @=> this.panesMap[key];
//     }

//     fun void removePane(string key) {
//         this.panesMap[key] @=> ColorPane pane;
//         this.removePaneToActiveList(pane);
//         pane.detach();
//     }

//     fun void addPaneToActiveList(ColorPane active) {
//         0 => int activeIdx;

//         // find where to insert pane
//         while (activeIdx < this.activePanes.size()) {
//             if (active.noteDiff < this.activePanes[activeIdx].noteDiff) {
//                 break;
//             }

//             activeIdx++;
//         }

//         // shift other panes over by 1
//         this.activePanes.size() + 1 => this.activePanes.size;
//         for (this.activePanes.size() - 1 => int idx; idx > activeIdx; idx--) {
//             this.activePanes[idx - 1] @=> this.activePanes[idx];
//         }

//         // set active
//         active @=> this.activePanes[activeIdx];
//     }

//     fun void removePaneToActiveList(ColorPane active) {
//         0 => int activeIdx;

//         // find where to insert pane
//         while (activeIdx < this.activePanes.size()) {
//             if (active.noteDiff == this.activePanes[activeIdx].noteDiff) {
//                 this.activePanes.popOut(activeIdx);
//                 break;
//             }

//             activeIdx++;
//         }
//     }

//     fun void update() {
//         // Update colors

//         if (this.activePanes.size() == 1) {
//             this.activePanes[0] @=> ColorPane pane;
//             pane.resetColor();
//         }

//         for (1 => int idx; idx < this.activePanes.size(); idx++) {
//             this.activePanes[idx - 1] @=> ColorPane bottomPane;
//             this.activePanes[idx] @=> ColorPane topPane;

//             topPane.getIntersectedShard(bottomPane) => int shardIdx;

//             if (shardIdx != -1) {
//                 topPane.setColorGradient(bottomPane.shards[shardIdx].color(), topPane.baseColor);
//             } else {
//                 topPane.resetColor();
//             }

//         }
//     }
// }
