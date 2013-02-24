package
{
    public class EmbeddedAssets
    {
        /** ATTENTION: Naming conventions!
         *  
         *  - Classes for embedded IMAGES should have the exact same name as the file,
         *    without extension. This is required so that references from XMLs (atlas, bitmap font)
         *    won't break.
         *    
         *  - Atlas and Font XML files can have an arbitrary name, since they are never
         *    referenced by file name.
         * 
         */
		
		[Embed(source = "/assets/arial.png")]
		public static const arial:Class;
		
        [Embed(source="/assets/arial.fnt", mimeType="application/octet-stream")]
        public static const arial_fnt:Class;
     }
}