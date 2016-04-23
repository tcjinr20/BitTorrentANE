package views.client {

	import flash.geom.Rectangle;
	
	import events.FormEvent;
	import events.InteractionEvent;
	
	import feathers.display.Scale9Image;
	import feathers.textures.Scale9Textures;
	
	import starling.display.BlendMode;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;
	import starling.utils.HAlign;
	
	import views.forms.Input;
	
	public class MagnetScreen extends Sprite {
		private var bgTexture:Scale9Textures;
		private var bg:Scale9Image;
		private var lbl:TextField;
		private var input:Input;
		private var okButton:Image = new Image(Assets.getAtlas().getTexture("ok-button"));
		private var cancelButton:Image = new Image(Assets.getAtlas().getTexture("cancel-button"));
		public function MagnetScreen(_txt:String="") {
			super();
			
			bgTexture = new Scale9Textures(Assets.getAtlas().getTexture("popmenu-bg"),new Rectangle(4,4,16,16));
			bg = new Scale9Image(bgTexture);
			bg.blendMode = BlendMode.NONE;
			bg.touchable = false;
			bg.width = 600;
			bg.height = 318;
			
			lbl = new TextField(600,32,"Add torrent links (one per line, magnet uris and info hashes supported)", "Fira Sans Semi-Bold 13", 13, 0xD8D8D8);
			lbl.hAlign = HAlign.LEFT;
			lbl.batchable = true;
			lbl.touchable = false;
			
			lbl.x = 20;
			lbl.y = 10;
			
			input = new Input(560,_txt,200);
			input.multiline = true;
			input.addEventListener(FormEvent.CHANGE,onFormChange);
			input.x = 20;
			input.y = 40;
			
			okButton.x = (600 - 180)/2;
			cancelButton.x = okButton.x + 100;
			
			okButton.y = 260;
			cancelButton.y = 260;
			
			okButton.addEventListener(TouchEvent.TOUCH,onOK);
			cancelButton.addEventListener(TouchEvent.TOUCH,onCancel);
			
			addChild(bg);
			addChild(lbl);
			addChild(input);
			addChild(okButton);
			addChild(cancelButton);
		}
		private function onOK(event:TouchEvent):void {
			var touch:Touch = event.getTouch(okButton);
			if(touch != null && touch.phase == TouchPhase.ENDED){
				this.dispatchEvent(new InteractionEvent(InteractionEvent.ON_MAGNET_ADD_LIST,{value:input.nti.input.text},true));
				hide();
			}
		}
		private function onCancel(event:TouchEvent):void {
			var touch:Touch = event.getTouch(cancelButton);
			if(touch != null && touch.phase == TouchPhase.ENDED)
				hide();
		}
		private function onFormChange(event:FormEvent):void {
			var test:int;
			switch(event.currentTarget){
			}
		}
		
		public function showFields(_b:Boolean):void {
			input.nti.show(_b);
		}
		
		public function show():void {
			this.visible = true;
			showFields(true);
		}
		public function hide():void {
			this.visible = false;
			input.nti.input.text = "";
			showFields(false);
		}
	}
}