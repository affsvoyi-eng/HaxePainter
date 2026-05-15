package states;

import flixel.FlxState;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;

import openfl.display.BitmapData;
import openfl.display.Shape;
import openfl.geom.Rectangle;
import openfl.net.FileReference;
import openfl.display.PNGEncoderOptions;

class EditorState extends FlxState
{
    // =====================================
    // VARIABLES
    // =====================================

    var canvasData:BitmapData;
    var canvas:FlxSprite;

    var currentColor:Int = FlxColor.RED;
    var brushSize:Int = 8;

    var infoText:FlxText;

    // =====================================
    // CREATE
    // =====================================

    override public function create():Void
    {
        super.create();

        // =====================================
        // BACKGROUND
        // =====================================

        var bg = new FlxSprite();
        bg.loadGraphic("assets/images/bg.png");

        bg.setGraphicSize(1280, 720);
        bg.updateHitbox();

        add(bg);

        // =====================================
        // OVERLAY
        // =====================================

        var overlay = new FlxSprite();
        overlay.makeGraphic(1280, 720, 0x33000000);

        add(overlay);

        // =====================================
        // CANVAS BORDER
        // =====================================

        var border = new FlxSprite(245, 95);
        border.makeGraphic(910, 510, FlxColor.BLACK);

        add(border);

        // =====================================
        // CREATE CANVAS
        // =====================================

        createCanvas(900, 500);

        // =====================================
        // CREATE PALETTE
        // =====================================

        createPalette();

        // =====================================
        // EXPORT BUTTON
        // =====================================

        var saveButton = new FlxButton(
            20,
            20,
            "Export PNG",
            saveImage
        );

        add(saveButton);

        // =====================================
        // ADD TEXT BUTTON
        // =====================================

        var textButton = new FlxButton(
            20,
            60,
            "Add Text",
            addSampleText
        );

        add(textButton);

        // =====================================
        // BRUSH +
        // =====================================

        var increaseBrush = new FlxButton(
            20,
            100,
            "Brush +",
            function()
            {
                brushSize += 2;
                updateInfo();
            }
        );

        add(increaseBrush);

        // =====================================
        // BRUSH -
        // =====================================

        var decreaseBrush = new FlxButton(
            20,
            140,
            "Brush -",
            function()
            {
                brushSize = Std.int(Math.max(2, brushSize - 2));
                updateInfo();
            }
        );

        add(decreaseBrush);

        // =====================================
        // INFO TEXT
        // =====================================

        infoText = new FlxText(
            20,
            650,
            300,
            ""
        );

        infoText.size = 16;
        infoText.color = FlxColor.WHITE;

        add(infoText);

        updateInfo();
    }

    // =====================================
    // CREATE CANVAS
    // =====================================

    function createCanvas(w:Int, h:Int):Void
    {
        canvasData = new BitmapData(
            w,
            h,
            false,
            FlxColor.WHITE
        );

        canvas = new FlxSprite(250, 100);

        canvas.makeGraphic(
            w,
            h,
            FlxColor.WHITE
        );

        canvas.pixels = canvasData;

        add(canvas);
    }

    // =====================================
    // CREATE COLOR PALETTE
    // =====================================

    function createPalette():Void
    {
        var colors:Array<Int> =
        [
            FlxColor.RED,
            FlxColor.GREEN,
            FlxColor.BLUE,
            FlxColor.YELLOW,
            FlxColor.BLACK,
            FlxColor.WHITE,
            FlxColor.PINK,
            FlxColor.CYAN,
            FlxColor.ORANGE
        ];

        for (i in 0...colors.length)
        {
            var color:Int = colors[i];

            var selectedColor:Int = color;

            var box = new FlxButton(
                20,
                220 + (i * 40),
                "",
                function()
                {
                    currentColor = selectedColor;
                    updateInfo();
                }
            );

            box.makeGraphic(
                30,
                30,
                color
            );

            add(box);
        }
    }

    // =====================================
    // UPDATE
    // =====================================

    override public function update(elapsed:Float):Void
    {
        super.update(elapsed);

        if (FlxG.mouse.pressed)
        {
            var mx:Float = FlxG.mouse.x - canvas.x;
            var my:Float = FlxG.mouse.y - canvas.y;

            if (
                mx >= 0 &&
                my >= 0 &&
                mx < canvasData.width &&
                my < canvasData.height
            )
            {
                drawPixel(mx, my);
            }
        }
    }

    // =====================================
    // DRAW PIXEL
    // =====================================

    function drawPixel(x:Float, y:Float):Void
    {
        var shape = new Shape();

        shape.graphics.beginFill(currentColor);

        shape.graphics.drawCircle(
            x,
            y,
            brushSize
        );

        shape.graphics.endFill();

        canvasData.draw(shape);

        canvas.pixels = canvasData;
        canvas.dirty = true;
    }

    // =====================================
    // ADD TEXT
    // =====================================

    function addSampleText():Void
    {
        var txt = new FlxText(
            350,
            120,
            300,
            "Sample Text"
        );

        txt.size = 32;
        txt.color = currentColor;

        add(txt);
    }

    // =====================================
    // SAVE IMAGE
    // =====================================

    function saveImage():Void
    {
        var bytes = canvasData.encode(
            new Rectangle(
                0,
                0,
                canvasData.width,
                canvasData.height
            ),
            new PNGEncoderOptions()
        );

        var file = new FileReference();

        file.save(
            bytes,
            "drawing.png"
        );
    }

    // =====================================
    // UPDATE INFO
    // =====================================

    function updateInfo():Void
    {
        infoText.text =
            "Brush Size: " + brushSize +
            "\nCurrent Color: #" + StringTools.hex(currentColor, 6);
    }
}
