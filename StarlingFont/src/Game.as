package 
{
    import flash.ui.Keyboard;
    import flash.utils.getDefinitionByName;
    
    import starling.core.Starling;
    import starling.display.Button;
    import starling.display.Image;
    import starling.display.Sprite;
    import starling.events.Event;
    import starling.events.KeyboardEvent;
    import starling.text.BitmapFont;
    import starling.text.TextField;
    import starling.textures.Texture;
    import starling.utils.AssetManager;
    import starling.utils.Color;
    import starling.utils.HAlign;
    import starling.utils.VAlign;
    
    public class Game extends Sprite
    {
        private static var sAssets:AssetManager;
        
        public function Game()
        {
            // nothing to do here -- Startup will call "start" immediately.
        }
        
        public function start(background:Texture, assets:AssetManager):void
        {
            sAssets = assets;
            
            // The background is passed into this method for two reasons:
            // 
            // 1) we need it right away, otherwise we have an empty frame
            // 2) the Startup class can decide on the right image, depending on the device.
            
            addChild(new Image(background));
            
            assets.loadQueue(function(ratio:Number):void
            {
                if (ratio == 1)
                    Starling.juggler.delayCall(function():void
                    {
                        showMainMenu();
                    }, 0.15);
            });
        }
        
        private function showMainMenu():void
        {
			var bmpFontTF:TextField = new TextField(400,400, "Hello Foxg\nWhy use pig", "ArialMT");
			bmpFontTF.fontSize = BitmapFont.NATIVE_SIZE; // the native bitmap font size, no scaling
			bmpFontTF.color = Color.WHITE; // use white to use the texture as it is (no tinting)
			bmpFontTF.hAlign = HAlign.LEFT;
			bmpFontTF.vAlign = VAlign.TOP;
			bmpFontTF.x = 0;
			bmpFontTF.y = 0;
			
			this.addChild(bmpFontTF);
        }
        
        public static function get assets():AssetManager { return sAssets; }
    }
}