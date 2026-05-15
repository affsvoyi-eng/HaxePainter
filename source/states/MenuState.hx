package states;

import flixel.FlxState;
import flixel.FlxG;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.FlxSprite;
import states.EditorState;
class MenuState extends FlxState
{
    override public function create():Void
    {
        super.create();

        var bg = new FlxSprite().loadGraphic("assets/images/bg.png");
        bg.screenCenter();
        add(bg);

        var title = new FlxText(0, 50, 1280, "HaxePainter");
        title.setFormat(null, 40, 0xFFFFFFFF, "center");
        add(title);

        var drawButton = new FlxButton(540, 300, "Open Editor", function()
        {
            FlxG.switchState(new EditorState());
        });

        add(drawButton);
    }
}
