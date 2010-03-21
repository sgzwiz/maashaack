package core.strings
{
    /**
    * Apply character padding to a string.
    * 
    * <p>
    * The padding amount is relative to the string length,
    * if you try to pad the string <code>"hello"</code> (5 chars) with an amount of 10,
    * you will not add 10 spacing chars to the original string,
    * but you will obtain <code>"     hello"</code>, exactly 10 chars after the padding.
    * </p>
    * 
    * <p>
    * A positive <code>amount</code> value will pad the string on the left (right align),
    * and a negative <code>amount</code> value will pad the string on the right (left align),
    * </p>
    * 
    * @example basic usage
    * <listing version="3.0">
    * <code class="prettyprint">
    * import core.strings.pad;
    * 
    * var word:String = "hello";
    * trace( "[" + pad( word, 8 ) + "]" ); //align to the right
    * trace( "[" + pad( word, -8 ) + "]" ); //align to the left
    * 
    * //output
    * //[   hello]
    * //[hello   ]
    * </code>
    * </listing>
    * 
    * @example padding a list of names
    * <listing version="3.0">
    * <code class="prettyprint">
    * import core.strings.pad;
    * 
    * var seinfeld:Array = [ "jerry", "george", "kramer", "helen" ];
    * 
    * for( var i:uint=0; i<seinfeld.length; i++ )
    * {
    *     trace( pad( seinfeld[i], 10, "." ) );
    * }
    * 
    * //output
    * //.....jerry
    * //....george
    * //....kramer
    * //.....helen
    * </code>
    * </listing>
    * 
    * @param str the string to pad
    * @param amount the amount of padding (number sign is the padding direction)
    * @param char the character to pad with (default is space)
    */
    public var pad:Function = function( str:String, amount:int, char:String = " " ):String
    {
        var right:Boolean = (amount > 0) ? false: true;
        var width:int     = (amount > 0) ? amount: -amount;
        
        if( (width < str.length) || (width == 0) )
        {
            return str;
        }
        
        char = char.charAt(0); //we want only 1 char
        
        while( str.length != width )
        {
            if( right )
            {
                str += char;
            }
            else
            {
                str = char + str;
            }
        }
        
        return str;
    }
}