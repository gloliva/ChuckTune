public class Theme {
    string name;
    vec3 primary;
    vec3 secondary;
    vec3 tertiary;
    vec3 background;

    fun @construct(string name, vec3 primary, vec3 secondary, vec3 tertiary, vec3 background) {
        name => this.name;
        primary => this.primary;
        secondary => this.secondary;
        tertiary => this.tertiary;
        background => this.background;
    }
}


public class ThemeManager {
    Theme themes[];
    Theme @ theme;
    int currTheme;
    int numThemes;

    fun @construct() {
        [
            new Theme("Classic", Color.BLACK, Color.WHITE * 3, Color.BLUE, Color.BLACK),
            new Theme("Silver", @(0.1, 0.1, 0.1), Color.WHITE * 3, Color.LIGHTGRAY, @(0.05, 0.05, 0.05)),
            new Theme("Blue", @(0., 0., 0.23), Color.BLUE * 3., Color.BLACK, @(0., 0., 0.08)),
            new Theme("Red", @(0.23, 0., 0.), Color.RED * 3., Color.BLACK, @(0.08, 0., 0.)),
            new Theme("Grassy", @(0., 0.23, 0.), Color.LIME * 3., Color.BLACK, @(0., 0.08, 0.)),
            new Theme("NightOwl", @(0.15, 0., 0.37), Color.YELLOW * 4., Color.BLACK, @(0.08, 0., 0.14)),
            new Theme("BlueDream", @(0., 0., 0.23), @(1., 0.5, 0.) * 3., Color.BLACK,  @(0., 0., 0.08)),
        ] @=> this.themes;

        0 => this.currTheme;
        this.themes[this.currTheme] @=> theme;
        this.themes.size() => this.numThemes;
    }

    fun Theme getTheme() {
        return this.theme;
    }

    fun string getThemeName() {
        return this.theme.name;
    }

    fun void changeTheme(int diff) {
        this.currTheme + diff => int newTheme;

        if (newTheme < 0) {
            newTheme + this.numThemes => newTheme;
        }

        newTheme % this.numThemes => newTheme;
        newTheme => this.currTheme;
        this.themes[this.currTheme] @=> theme;
    }
}
