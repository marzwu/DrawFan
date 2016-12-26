package {
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	
	/**
	 * @author marz
	 * @since 2016-12-26 下午10:51:15
	 */
	[SWF(width = "1000", height = "800", frameRate = "30")]
	public class DrawFan extends Sprite {
		
		private var start:Sprite;
		private var end:Sprite;
		private var center:Point;
		private var radius:int = 200;
		private var target:Sprite;
		private var _startAngle:Number;
		private var _endAngle:Number;
		
		public function DrawFan() {
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			
			graphics.lineStyle(1, 0x00ff00, .2);
			graphics.beginFill(0x00ff00, .2);
			graphics.drawRect(0, 0, stage.stageWidth - 1, stage.stageHeight - 1);
			graphics.endFill();
			
			center = new Point(stage.stageWidth >> 1, stage.stageHeight >> 1);
			
			start = new Sprite();
			start.graphics.beginFill(0xff0000);
			start.graphics.drawCircle(0, 0, 5);
			addChild(start);
			
			var p:Point = getPoint(0);
			start.x = p.x;
			start.y = p.y;
			
			end = new Sprite();
			end.graphics.beginFill(0x0000ff);
			end.graphics.drawCircle(0, 0, 5);
			addChild(end);
			
			p = getPoint(90);
			end.x = p.x;
			end.y = p.y;
			
			stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouse);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouse);
			stage.addEventListener(MouseEvent.MOUSE_UP, onMouse);
		}
		
		private function onMouse(e:MouseEvent):void {
			switch (e.type) {
				case MouseEvent.MOUSE_DOWN:
					if (target == null && (e.target == start || e.target == end)) {
						target = e.target as Sprite;
					}
					break;
				case MouseEvent.MOUSE_MOVE:
					if (target) {
						var p:Point = new Point(mouseX, mouseY);
						var d:Number = Point.distance(p, center);
						p.x = center.x + (p.x - center.x) / d * radius;
						p.y = center.y + (p.y - center.y) / d * radius;
						
						target.x = p.x;
						target.y = p.y;
						
						drawFan();
					}
					break;
				case MouseEvent.MOUSE_UP:
					target = null;
					break;
				default:
					break;
			}
		}
		
		private function drawFan():void {
			graphics.clear();
			graphics.lineStyle(1, 0x0);
			
			var diff:int = getAngle(radius, new Point(start.x, start.y), new Point(end.x, end.y));
			var startAngle:Number = Math.atan2(start.y - center.y, start.x - center.x) * 180 / Math.PI;
			var endAngle:Number = Math.atan2(end.y - center.y, end.x - center.x) * 180 / Math.PI;
			
			if (startAngle - _startAngle < -270) {
				startAngle += 360;
			} else if (startAngle - _startAngle > 270) {
				startAngle -= 360;
			} else if (endAngle - _endAngle < -270) {
				endAngle += 360;
			} else if (endAngle - _endAngle > 270) {
				endAngle -= 360;
			}
			
			while (endAngle - startAngle > 360) {
				endAngle -= 360;
			}
			
			while (endAngle - startAngle < -360) {
				startAngle -= 360;
			}
			
			_startAngle = startAngle;
			_endAngle = endAngle;
			
			if (startAngle > endAngle) {
				var temp:Number = startAngle;
				startAngle = endAngle;
				endAngle = temp;
				var reverse:Boolean = true;
			}
			
			
			if (!reverse) {
				graphics.moveTo(start.x, start.y);
			} else {
				graphics.moveTo(end.x, end.y);
			}
			
			while (startAngle < endAngle) {
				startAngle += 1;
				var _x:Number = center.x + radius * Math.cos(startAngle / 180 * Math.PI);
				var _y:Number = center.y + radius * Math.sin(startAngle / 180 * Math.PI);
				graphics.lineTo(_x, _y);
			}
			
			if (!reverse) {
				graphics.lineTo(end.x, end.y);
			} else {
				graphics.lineTo(start.x, start.y);
			}
		}
		
		private function getPoint(angle:int):Point {
			var r:Point = new Point();
			r.x = center.x + radius * Math.cos(angle / 180 * Math.PI);
			r.y = center.y + radius * Math.sin(angle / 180 * Math.PI);
			return r;
		}
		
		private function getAngle(r:int, start:Point, end:Point):int {
			var d:Number = Point.distance(start, end);
			var cos:Number = (r * r + r * r - d * d) / (2 * r * r);
			return Math.acos(cos) * 180 / Math.PI;
		}
	}
}
