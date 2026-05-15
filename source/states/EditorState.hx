package states;

import flixel.FlxState;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.ui.FlxButton;

import openfl.display.BitmapData;
import openfl.display.Shape;
import openfl.geom.Rectangle;
import openfl.net.FileReference;
import openfl.display.PNGEncoderOptions;

class EditorState extends FlxState
{
    var canvasData:BitmapData;
    var canvas:FlxSprite;

    var currentColor:Int = 0xFF0000;
    var brushSize:Int = 8;

    var drawing:Bool = false;

    override public function create():Void
    {
        super.create();

        var bg = new FlxSprite().loadGraphic("assets/images/bg.png");
        add(bg);

        createCanvas(900, 500);

        createPalette();

        var saveButton = new FlxButton(20, 20, "Export PNG", saveImage);
        add(saveButton);

        var textButton = new FlxButton(20, 60, "Add Text", addSampleText);
        add(textButton);

        var increaseBrush = new FlxButton(20, 100, "Brush +", function()
        {
            brushSize += 2;
        });

        add(increaseBrush);

        var decreaseBrush = new FlxButton(20, 140, "Brush -", function()
        {
            brushSize = Math.max(2, brushSize - 2);
        });

        add(decreaseBrush);
    }

    function createCanvas(w:Int, h:Int):Void
    {
        canvasData = new BitmapData(w, h, false, 0xFFFFFFFF);

        canvas = new FlxSprite(250, 100);
        canvas.pixels = canvasData;

        add(canvas);
    }

    function createPalette():Void
    {
        var colors = [
            0xFF0000,
            0x00FF00,
            0x0000FF,
            0xFFFF00,
            0x000000,
            0xFFFFFF,
            0xFF00FF,
            0x00FFFF
        ];

        for (i in 0...colors.length)
        {
         var selectedColor:Int = color;

 var box = new FlxButton(
    20,
    220 + (i * 40),
    "",
    function()
    {
        currentColor = selectedColor;
    }
);

            box.makeGraphic(30, 30, colors[i]);

            add(box);
        }
    }

    override public function update(elapsed:Float):Void
    {
        super.update(elapsed);

        if (FlxG.mouse.pressed)
        {
            var mx = FlxG.mouse.x - canvas.x;
            var my = FlxG.mouse.y - canvas.y;

            if (mx >= 0 && my >= 0 && mx < canvasData.width && my < canvasData.height)
            {
                drawPixel(mx, my);
            }
        }
    }

    function drawPixel(x:Float, y:Float):Void
    {
        var shape = new Shape();

        shape.graphics.beginFill(currentColor);
        shape.graphics.drawCircle(x, y, brushSize);
        shape.graphics.endFill();

        canvasData.draw(shape);

        canvas.pixels = canvasData;
        canvas.dirty = true;
    }

    function addSampleText():Void
    {
        var txt = new FlxText(350, 120, 300, "Sample Text");
        txt.size = 32;
        txt.color = currentColor;

        add(txt);
    }

    function saveImage():Void
    {
        var bytes = canvasData.encode(
            new Rectangle(0, 0, canvasData.width, canvasData.height),
            new PNGEncoderOptions()
        );

        var file = new FileReference();
        file.save(bytes, "drawing.png");
    }
}

}
