public class Node extends GGen {
    GSphere node;
    GText letter;

    fun @construct(string letter, vec3 nodeColor) {
        // Text
        letter => this.letter.text;

        // Position
        0.501 => this.letter.posZ;

        // Scale
        @(0.5, 0.5, 0.5) => this.letter.sca;

        // Color
        @(2., 2., 2., 1.) => this.letter.color;
        nodeColor => this.node.color;

        // Name
        "Letter " + this.letter.text() => this.letter.name;
        "Node Circle" => this.node.name;
        "Node " + this.letter.text() => this.name;

        // Connections
        this.letter --> this;
        this.node --> this;
        this --> GG.scene();
    }

    fun void setPos(float x, float y, float z) {
        x => this.posX;
        y => this.posY;
        z => this.posZ;
    }
}
