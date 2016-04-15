package views.settings {
	import com.tuarua.torrent.settings.NetworkAddress;
	import com.tuarua.torrent.settings.NetworkInterface;
	
	import flash.net.NetworkInfo;
	import flash.net.NetworkInterface;
	
	import events.FormEvent;
	
	import model.Settings;
	import model.SettingsLocalStore;
	
	import starling.display.Sprite;
	import starling.text.TextField;
	import starling.utils.HAlign;
	import starling.utils.VAlign;
	
	import views.forms.CheckBox;
	import views.forms.DropDown;
	import views.forms.FormGroup;
	import views.forms.Input;
	import views.forms.Stepper;
	
	public class AdvancedPanel extends Sprite {
		private var txtHolder:Sprite = new Sprite();
		private var diskWriteStppr:Stepper;
		private var diskCacheExpiryStppr:Stepper;
		private var outPortMinStppr:Stepper;
		private var outPortMaxStppr:Stepper;
		private var maxHalfStppr:Stepper;
		
		private var chkOScache:CheckBox;
		private var chkRecheckTorrents:CheckBox;
		private var chkPeerIP:CheckBox;
		private var chkPeerHost:CheckBox;
		private var chkSeeding:CheckBox;
		private var chkIPv6:CheckBox;
		private var chkTrackerExchange:CheckBox;
		private var chkAnnounceAll:CheckBox;
		private var interfaces:DropDown;
		
		public var IPannounceInput:Input;

		private var availableNetworkInterfaces:Vector.<flash.net.NetworkInterface>;
		public function AdvancedPanel() {
			super();
			
			drawLabel("Settings",15,-8);
			drawLabel("Enable OS cache",45,20);
			drawLabel("Recheck torrents on completion",45,50);
			drawLabel("Resolve peers countries (Geoip)",45,80);
			drawLabel("Resolve peers host names",45,110);
			drawLabel("Super seeding",45,140);
			drawLabel("Listen on IPv6",45,170);
			drawLabel("Enable tracker exchange",45,200);
			drawLabel("Announce to all trackers",45,230);
			
			var settings2Group:FormGroup = new FormGroup(550,66,320);
			settings2Group.x = 550;
			
			drawLabel("Settings",settings2Group.x + 15,-8);
			drawLabel("Disk write cache size (MiB) [0: Auto]",settings2Group.x + 15,20);
			drawLabel("Disk cache expiry interval (s)",settings2Group.x + 15,50);
			drawLabel("Outgoing ports (Min) [0: Disabled]",settings2Group.x + 15,80);
			drawLabel("Outgoing ports (Max) [0: Disabled]",settings2Group.x + 15,110);
			drawLabel("Max num of 1/2 open connections [0: Disabled]",settings2Group.x + 15,140);
			drawLabel("Network Interface",settings2Group.x + 15,170);
			drawLabel("Announce IP",settings2Group.x + 15,200);
			
			var settings1Group:FormGroup = new FormGroup(450,66,320);
			addChild(settings1Group);
			

			diskWriteStppr = new Stepper(75,String(model.SettingsLocalStore.settings.advanced.diskCacheSize),5);
			diskWriteStppr.addEventListener(FormEvent.CHANGE,onFormChange);
			diskWriteStppr.y = 17;
			
			diskCacheExpiryStppr = new Stepper(75,(model.SettingsLocalStore.settings.advanced.diskCacheTTL),5);
			diskCacheExpiryStppr.addEventListener(FormEvent.CHANGE,onFormChange);
			diskCacheExpiryStppr.y = 47;

			outPortMinStppr = new Stepper(75,String(model.SettingsLocalStore.settings.advanced.outgoingPortsMin),5);
			outPortMinStppr.addEventListener(FormEvent.CHANGE,onFormChange);
			outPortMinStppr.y = 77;
			
			outPortMaxStppr = new Stepper(75,String(model.SettingsLocalStore.settings.advanced.outgoingPortsMax),5);
			outPortMaxStppr.addEventListener(FormEvent.CHANGE,onFormChange);
			outPortMaxStppr.y = 107;
			
			maxHalfStppr = new Stepper(75,String(model.SettingsLocalStore.settings.advanced.numMaxHalfOpenConnections),5);
			maxHalfStppr.addEventListener(FormEvent.CHANGE,onFormChange);
			diskWriteStppr.x = diskCacheExpiryStppr.x = outPortMinStppr.x = outPortMaxStppr.x = maxHalfStppr.x = 925;
			maxHalfStppr.y = 137;
			
			
			var interfacesDataList:Vector.<Object> = new Vector.<Object>();
			var selectedInterfaceIndex:int = 0;
			var ni:Object = model.SettingsLocalStore.settings.advanced.networkInterface;
			
			interfacesDataList.push({value:"{Any}",label:"Any Interface"});
			availableNetworkInterfaces = NetworkInfo.networkInfo.findInterfaces();
			for (var i:int=0, l:int=availableNetworkInterfaces.length; i<l; ++i){
				
				/*
				Name: {590C3F85-3B3D-4F5C-B645-250A491B7335}
				DisplayName: Wi-Fi 2
				Active: true
				Addr: 2a02:c7d:b915:c600:8845:3e4:dd26:7fe IPVersion: IPv6
				Addr: fd65:ea8d:4622:0:8845:3e4:dd26:7fe IPVersion: IPv6
				Addr: 2a02:c7d:b915:c600:785c:1087:8850:fb0c IPVersion: IPv6
				Addr: fd65:ea8d:4622:0:785c:1087:8850:fb0c IPVersion: IPv6
				Addr: 192.168.0.10 IPVersion: IPv4
				*/
				
				//trace("Name:",availableNetworkInterfaces[i].name);
				//trace("DisplayName:",availableNetworkInterfaces[i].displayName);
				//trace("Active:",availableNetworkInterfaces[i].active);
				//for (var j:int=0; j<availableNetworkInterfaces[i].addresses.length; j++) {
					//trace("Addr:",availableNetworkInterfaces[i].addresses[j].address,"IPVersion:",availableNetworkInterfaces[i].addresses[j].ipVersion);
				//}
				interfacesDataList.push({value:availableNetworkInterfaces[i].name,label:availableNetworkInterfaces[i].displayName});
				if(model.SettingsLocalStore.settings.advanced.networkInterface && model.SettingsLocalStore.settings.advanced.networkInterface.name == availableNetworkInterfaces[i].name)
					selectedInterfaceIndex = i+1;
				
				//trace("-------");
			}
			
			interfaces = new DropDown(200,interfacesDataList,selectedInterfaceIndex);
			interfaces.addEventListener(FormEvent.CHANGE,onFormChange);
			interfaces.addEventListener(FormEvent.FOCUS_IN,onInterfaceFocusIn);
			interfaces.addEventListener(FormEvent.FOCUS_OUT,onInterfaceFocusOut);
			interfaces.x = 800;
			interfaces.y = 167;
			
			IPannounceInput = new Input(200,model.SettingsLocalStore.settings.advanced.announceIP);
			IPannounceInput.addEventListener(FormEvent.CHANGE,onFormChange);
			IPannounceInput.x = 800;
			IPannounceInput.y = 197;
			
			chkOScache = new CheckBox(model.SettingsLocalStore.settings.advanced.enableOsCache);
			chkOScache.addEventListener(FormEvent.CHANGE,onFormChange);
			chkOScache.x = 0;
			chkOScache.y = 5;
			
			
			chkRecheckTorrents = new CheckBox(model.SettingsLocalStore.settings.advanced.recheckTorrentsOnCompletion);
			chkRecheckTorrents.addEventListener(FormEvent.CHANGE,onFormChange);
			chkRecheckTorrents.x = 0;
			chkRecheckTorrents.y = 35;
			
			chkPeerIP = new CheckBox(model.SettingsLocalStore.settings.advanced.resolveCountries);
			chkPeerIP.addEventListener(FormEvent.CHANGE,onFormChange);
			chkPeerIP.x = 0;
			chkPeerIP.y = 65;
			
			chkPeerHost = new CheckBox(model.SettingsLocalStore.settings.advanced.resolvePeerHostNames);
			chkPeerHost.addEventListener(FormEvent.CHANGE,onFormChange);
			chkPeerHost.x = 0;
			chkPeerHost.y = 95;
			
			
			chkSeeding = new CheckBox(model.SettingsLocalStore.settings.advanced.isSuperSeedingEnabled);
			chkSeeding.addEventListener(FormEvent.CHANGE,onFormChange);
			chkSeeding.x = 0;
			chkSeeding.y = 125;
			
			chkIPv6 = new CheckBox(model.SettingsLocalStore.settings.advanced.listenOnIPv6);
			chkIPv6.addEventListener(FormEvent.CHANGE,onFormChange);
			chkIPv6.x = 0;
			chkIPv6.y = 155;
			
			chkTrackerExchange = new CheckBox(model.SettingsLocalStore.settings.advanced.enableTrackerExchange);
			chkTrackerExchange.addEventListener(FormEvent.CHANGE,onFormChange);
			chkTrackerExchange.x = 0;
			chkTrackerExchange.y = 185;
			
			chkAnnounceAll = new CheckBox(model.SettingsLocalStore.settings.advanced.announceToAllTrackers);
			chkAnnounceAll.addEventListener(FormEvent.CHANGE,onFormChange);
			chkAnnounceAll.x = 0;
			chkAnnounceAll.y = 215;
			
			addChild(settings2Group);
			
			addChild(chkOScache);
			addChild(chkPeerIP);
			addChild(chkPeerHost);
			addChild(chkRecheckTorrents);
			
			addChild(chkSeeding);
			addChild(chkIPv6);
			addChild(chkTrackerExchange);
			addChild(chkAnnounceAll);
				
			addChild(diskWriteStppr);
			addChild(diskCacheExpiryStppr);
			addChild(outPortMinStppr)
			addChild(outPortMaxStppr);
			addChild(maxHalfStppr);
			
			addChild(IPannounceInput);
			addChild(interfaces);
			
			
			
			
			
			addChild(txtHolder);
			
		}
		
		private function drawLabel(_s:String,_x:int,_y:int):void {
			var txt:TextField = new TextField(500,32,_s, "Fira Sans Regular 13", 13, 0xD8D8D8);
			txt.vAlign = VAlign.TOP;
			txt.hAlign = HAlign.LEFT;
			txt.touchable = false;
			txt.batchable = true;
			txt.x = _x;
			txt.y = _y;
			txtHolder.addChild(txt);
		}
		
		private function onInterfaceFocusIn(event:FormEvent):void {
			IPannounceInput.nti.enable(false,false);
		}
		private function onInterfaceFocusOut(event:FormEvent):void {
			IPannounceInput.nti.enable(true,false);
		}
		private function onFormChange(event:FormEvent):void {
			var test:int;
			/*
			for (var i:int=0, l:int=availableNetworkInterfaces.length; i<l; ++i){
			
			
			
			trace("Name:",availableNetworkInterfaces[i].name);
			trace("DisplayName:",availableNetworkInterfaces[i].displayName);
			trace("Active:",availableNetworkInterfaces[i].active);
			for (var j:int=0; j<availableNetworkInterfaces[i].addresses.length; j++) {
			trace("Addr:",availableNetworkInterfaces[i].addresses[j].address,"IPVersion:",availableNetworkInterfaces[i].addresses[j].ipVersion);
			}
			
			
			
			interfacesDataList.push({value:availableNetworkInterfaces[i].name,label:availableNetworkInterfaces[i].displayName});
			if(model.SettingsLocalStore.settings.advanced.networkInterface == availableNetworkInterfaces[i].name)
			selectedInterfaceIndex = i;
			
			trace("-------");
			}
			*/
			switch(event.currentTarget){
				case interfaces:
					trace(event.params.value);
					var networkInterface:Object = new com.tuarua.torrent.settings.NetworkInterface();
					for (var i:int=0, l:int=availableNetworkInterfaces.length; i<l; ++i){
						if(availableNetworkInterfaces[i].name == event.params.value){
							networkInterface.name = event.params.value;
							for (var j:int=0; j<availableNetworkInterfaces[i].addresses.length; j++) {
								networkInterface.addresses.push(new NetworkAddress(availableNetworkInterfaces[i].addresses[j].address,availableNetworkInterfaces[i].addresses[j].ipVersion));
							}
							break;
						}
					}
					trace();
					model.SettingsLocalStore.setProp("advanced",networkInterface,"networkInterface");
					break;
				case IPannounceInput:
					model.SettingsLocalStore.setProp("advanced",IPannounceInput.nti.input.text,"announceIP");
					break;
				case diskWriteStppr:
					if(event.params)
						test = (parseInt(diskWriteStppr.nti.input.text)+event.params.value);
					else
						test = parseInt(diskWriteStppr.nti.input.text);
					if(test > -1){
						diskWriteStppr.nti.input.text = test.toString();
						model.SettingsLocalStore.setProp("advanced",test,"diskCacheSize");
					}
					break;
				case diskCacheExpiryStppr:
					if(event.params)
						test = (parseInt(diskCacheExpiryStppr.nti.input.text)+event.params.value);
					else
						test = parseInt(diskCacheExpiryStppr.nti.input.text);
					if(test > -1){
						diskCacheExpiryStppr.nti.input.text = test.toString();
						model.SettingsLocalStore.setProp("advanced",test,"diskCacheTTL");
					}
					break;
				
				case outPortMinStppr:
					if(event.params)
						test = (parseInt(outPortMinStppr.nti.input.text)+event.params.value);
					else
						test = parseInt(outPortMinStppr.nti.input.text);
					if(test > -1){
						outPortMinStppr.nti.input.text = test.toString();
						model.SettingsLocalStore.setProp("advanced",test,"outgoingPortsMin");
					}
					break;
				case outPortMaxStppr:
					if(event.params)
						test = (parseInt(outPortMaxStppr.nti.input.text)+event.params.value);
					else
						test = parseInt(outPortMaxStppr.nti.input.text);
					if(test > -1){
						outPortMaxStppr.nti.input.text = test.toString();
						model.SettingsLocalStore.setProp("advanced",test,"outgoingPortsMax");
					}
					break;
				case maxHalfStppr:
					if(event.params)
						test = (parseInt(maxHalfStppr.nti.input.text)+event.params.value);
					else
						test = parseInt(maxHalfStppr.nti.input.text);
					if(test > -1){
						maxHalfStppr.nti.input.text = test.toString();
						model.SettingsLocalStore.setProp("advanced",test,"numMaxHalfOpenConnections");
					}
					break;
				case chkPeerHost:
					model.SettingsLocalStore.setProp("advanced",event.params.value,"resolvePeerHostNames");
					break;
				case chkPeerIP:
					model.SettingsLocalStore.setProp("advanced",event.params.value,"resolveCountries");
					break;
				case chkRecheckTorrents:
					model.SettingsLocalStore.setProp("advanced",event.params.value,"recheckTorrentsOnCompletion");
					break;
				case chkOScache:
					model.SettingsLocalStore.setProp("advanced",event.params.value,"enableOsCache");
					break;
				case chkIPv6:
					model.SettingsLocalStore.setProp("advanced",event.params.value,"listenOnIPv6");
					break;
				case chkSeeding:
					model.SettingsLocalStore.setProp("advanced",event.params.value,"isSuperSeedingEnabled");
					break;
				case chkTrackerExchange:
					model.SettingsLocalStore.setProp("advanced",event.params.value,"enableTrackerExchange");
					break;
				case chkAnnounceAll:
					model.SettingsLocalStore.setProp("advanced",event.params.value,"announceToAllTrackers");
					break;
			}
		}
		public function showFields(_b:Boolean):void {
			diskWriteStppr.nti.show(_b);
			diskCacheExpiryStppr.nti.show(_b);
			outPortMinStppr.nti.show(_b);
			outPortMaxStppr.nti.show(_b);
			maxHalfStppr.nti.show(_b);
			IPannounceInput.nti.show(_b);
		}
		public function positionAllFields():void {
		}
	}
}