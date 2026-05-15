package states;

import flixel.FlxState;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;

import states.EditorState;

class MenuState extends FlxState
{
    var bg:FlxSprite;

    var title:FlxText;
    var subtitle:FlxText;

    var drawButton:FlxButton;
    var exitButton:FlxButton;

    override public function create():Void
    {
        super.create();

        // =====================================
        // BACKGROUND
        // =====================================

        bg = new FlxSprite();
        bg.loadGraphic("assets/images/bg.png");

        bg.setGraphicSize(1280, 720);
        bg.updateHitbox();

        add(bg);

        // =====================================
        // OVERLAY
        // =====================================

        var overlay = new FlxSprite();
        overlay.makeGraphic(1280, 720, 0x44000000);

        add(overlay);

        // =====================================
        // TITLE
        // =====================================

        title = new FlxText(
            0,
            60,
            1280,
            "HaxePainter"
        );

        title.setFormat(
            null,
            56,
            FlxColor.WHITE,
            CENTER
        );

        title.borderStyle = OUTLINE;
        title.borderColor = FlxColor.BLACK;
        title.borderSize = 3;

        add(title);

        // =====================================
        // SUBTITLE
        // =====================================

        subtitle = new FlxText(
            0,
            135,
            1280,
            "Professional Drawing Application"
        );

        subtitle.setFormat(
            null,
            24,
            FlxColor.WHITE,
            CENTER
        );

        subtitle.alpha = 0.8;

        add(subtitle);

        // =====================================
        // OPEN EDITOR BUTTON
        // =====================================

        drawButton = new FlxButton(
            0,
            0,
            "Open Editor",
            function()
            {
                FlxG.switchState(new EditorState());
            }
        );

        drawButton.screenCenter();
        drawButton.y += 40;

        drawButton.label.setFormat(
            null,
            20,
            FlxColor.BLACK,
            CENTER
        );

        add(drawButton);

        // =====================================
        // EXIT BUTTON
        // =====================================

        exitButton = new FlxButton(
            0,
            0,
            "Exit",
            function()
            {
                #if sys
                Sys.exit(0);
                #end
            }
        );

        exitButton.screenCenter();
        exitButton.y += 110;

        exitButton.label.setFormat(
            null,
            18,
            FlxColor.BLACK,
            CENTER
        );

        add(exitButton);

        // =====================================
        // VERSION TEXT
        // =====================================

        var versionText = new FlxText(
            10,
            690,
            0,
            "v1.0.0"
        );

        versionText.setFormat(
            null,
            16,
            FlxColor.WHITE
        );

        versionText.alpha = 0.7;

        add(versionText);

        // =====================================
        // ANIMATION
        // =====================================

        title.alpha = 0;
        title.y -= 30;

        FlxTween.tween(
            title,
            {
                alpha: 1,
                y: 60
            },
            1,
            {
                ease: FlxEase.quadOut
            }
        );

        drawButton.alpha = 0;

        FlxTween.tween(
            drawButton,
            {
                alpha: 1
            },
            1.2
        );

        exitButton.alpha = 0;

        FlxTween.tween(
            exitButton,
            {
                alpha: 1
            },
            1.4
        );
    }

    override public function update(elapsed:Float):Void
    {
        super.update(elapsed);

        title.angle = Math.sin(FlxG.game.ticks / 30) * 1.5;
    }
}
