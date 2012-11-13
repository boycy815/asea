package com.alibado.fuildui.mouse
{
    import alternativa.gui.mouse.CursorData;
    import alternativa.gui.mouse.CursorManager;
    
    import flash.display.BitmapData;
    import flash.geom.Point;
    import flash.ui.MouseCursorData;
    
    /**
     * 通用鼠标样式构建器
     * @example
     * GUI.init(stage, false);
     * CursorManager.init(FdCursors.createCursors());
     */
    public class FdCursors
    {
        [Embed(source="../assets/cursors/move.png")]
        private static const moveCursorTexture:Class;
        protected static const moveCursor:BitmapData = new moveCursorTexture().bitmapData;
        
        [Embed(source="../assets/cursors/ew.png")]
        private static const ewCursorTexture:Class;
        protected static const ewCursor:BitmapData = new ewCursorTexture().bitmapData;
        
        [Embed(source="../assets/cursors/ns.png")] 
        private static const nsCursorTexture:Class;
        protected static const nsCursor:BitmapData = new nsCursorTexture().bitmapData;
        
        [Embed(source="../assets/cursors/nwse.png")] 
        private static const nwseCursorTexture:Class;
        protected static const nwseCursor:BitmapData = new nwseCursorTexture().bitmapData;
        
        [Embed(source="../assets/cursors/nesw.png")] 
        private static const neswCursorTexture:Class;
        protected static const neswCursor:BitmapData = new neswCursorTexture().bitmapData;
        
        
        public static function createCursors():Vector.<CursorData>
        {
            var vector:Vector.<CursorData> = new Vector.<CursorData>();
            
            var moveCursorData:MouseCursorData = new MouseCursorData();
            var moveCursorBD:Vector.<BitmapData> = new Vector.<BitmapData>();
            moveCursorBD.push(moveCursor);
            moveCursorData.data = moveCursorBD;
            moveCursorData.hotSpot = new Point(10,10);
            vector.push(new CursorData(CursorManager.CROSS, moveCursorData));
            
            var ewCursorData:MouseCursorData = new MouseCursorData();
            var ewCursorBD:Vector.<BitmapData> = new Vector.<BitmapData>();
            ewCursorBD.push(ewCursor);
            ewCursorData.data = ewCursorBD;
            ewCursorData.hotSpot = new Point(10,10);
            vector.push(new CursorData(CursorManager.SIZE_WE, ewCursorData));
            
            var nsCursorData:MouseCursorData = new MouseCursorData();
            var nsCursorBD:Vector.<BitmapData> = new Vector.<BitmapData>();
            nsCursorBD.push(nsCursor);
            nsCursorData.data = nsCursorBD;
            nsCursorData.hotSpot = new Point(10,9);
            vector.push(new CursorData(CursorManager.SIZE_NS, nsCursorData));
            
            var nwseCursorData:MouseCursorData = new MouseCursorData();
            var nwseCursorBD:Vector.<BitmapData> = new Vector.<BitmapData>();
            nwseCursorBD.push(nwseCursor);
            nwseCursorData.data = nwseCursorBD;
            nwseCursorData.hotSpot = new Point(11,10);
            vector.push(new CursorData(CursorManager.SIZE_NWSE, nwseCursorData));
            
            var neswCursorData:MouseCursorData = new MouseCursorData();
            var neswCursorBD:Vector.<BitmapData> = new Vector.<BitmapData>();
            neswCursorBD.push(neswCursor);
            neswCursorData.data = neswCursorBD;
            neswCursorData.hotSpot = new Point(10,10);
            vector.push(new CursorData(CursorManager.SIZE_NESW, neswCursorData));
            
            return vector;
        }
    }
}