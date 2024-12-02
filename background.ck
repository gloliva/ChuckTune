public class Frame extends GGen {
    GCube topEdge;
    GCube bottomEdge;
    GCube leftEdge;
    GCube rightEdge;

    fun @construct(float shiftY, float topEdgeY, float bottomEdgeY) {
        // Position
        @(0.2, topEdgeY, 0.0) => this.topEdge.pos;
        @(0.2, bottomEdgeY, 0.0) => this.bottomEdge.pos;
        @(-4.02, 0.54, 0.0) => this.leftEdge.pos;
        @(5.22, 0.51, 0.0) => this.rightEdge.pos;

        shiftY => this.posY;
        -0.02 => this.posZ;

        // Scale
        @(10.1, 0.06, 0.01) => this.topEdge.sca;
        @(10.1, 0.06, 0.01) => this.bottomEdge.sca;
        @(0.1, 1.65, 0.01) => this.leftEdge.sca;
        @(0.1, 1.65, 0.01) => this.rightEdge.sca;

        // Color
        Color.WHITE * 3. => this.topEdge.color;
        Color.WHITE * 3. => this.bottomEdge.color;
        Color.WHITE * 3. => this.leftEdge.color;
        Color.WHITE * 3. => this.rightEdge.color;

        // Names
        "TopEdge" => this.topEdge.name;
        "BottomEdge" => this.bottomEdge.name;
        "LeftEdge" => this.leftEdge.name;
        "RightEdge" => this.rightEdge.name;
        "Frame" => this.name;

        // Connection
        topEdge --> this;
        bottomEdge --> this;
        leftEdge --> this;
        rightEdge --> this;
        this --> GG.scene();
    }
}


public class Blocker extends GGen {
    GCube blocker;

    fun @construct(vec2 pos, vec2 scale) {
        // Position
        pos.x => this.posX;
        pos.y => this.posY;
        -0.01 => this.posZ;

        // Scale
        scale.x => this.scaX;
        scale.y => this.scaY;
        0.01 => this.scaZ;

        // Color
        Color.BLACK => this.blocker.color;
        Color.BLACK => this.blocker.specular;

        "Blocker Cube" => this.blocker.name;
        "Blocker" => this.name;
        this.blocker --> this --> GG.scene();
    }
}
