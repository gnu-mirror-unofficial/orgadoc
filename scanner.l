%{
indexing
   description: "configuration file scanner"
   author: "Julien LEMOINE <speedblue@debian.org>"
   --| This program is free software; you can redistribute it and/or modify
   --| it under the terms of the GNU General Public License as published by
   --| the Free Software Foundation; either version 2 of the License, or
   --| (at your option) any later version.

class SCANNER
   inherit
   YY_COMPRESSED_SCANNER_SKELETON
      rename
	 make as make_compressed_scanner_skeleton,
	 reset as reset_compressed_scanner_skeleton
      end
   
   TOKENS
      export {NONE} all end
      
      UT_CHARACTER_CODES
      export {NONE} all end
      
      KL_IMPORTED_INTEGER_ROUTINES
      KL_IMPORTED_STRING_ROUTINES
      KL_SHARED_PLATFORM
      
creation
   make

%}

%option outfile="scanner.e"

%%

[ \t\r]+		-- Ignore separators
\n+			eif_lineno := eif_lineno + text_count
"#".*			-- Ignore comments

"XmlFile"		last_token := T_XML
"HtmlFile"		last_token := T_HTML
"InputPath"		last_token := T_INPUT
"OutputPath"		last_token := T_OUTPUT
"EnablePrivateDoc"	last_token := T_PRIVATE
"Mode"			last_token := T_MODE
"Recursive"		last_token := T_REC
"TemplatePath"		last_token := T_TEMPLATE
[tT][rR][uU][eE]	last_token := T_TRUE
[fF][aA][lL][sS][eE]	last_token := T_FALSE
"="			last_token := T_EQUAL
[0-9]+			{
			  last_token := T_INTEGER
			  last_value := text.to_integer
			}
[a-zA-Z0-9~/.]+		{
			  last_token := T_STRING			
			  last_value := text
			}
<<EOF>>			terminate
			
%%

feature {NONE}
   make is
      do
	 make_with_buffer(Empty_buffer)
	 eif_buffer := STRING_.make (Init_buffer_size)
	 eif_lineno := 1
      end
   
   reset is -- Reset scanner before scanning next input
      do
	 reset_compressed_scanner_skeleton
	 eif_lineno := 1
	 eif_buffer.wipe_out
      end
   
feature -- Access
   last_value : ANY
   eif_buffer : STRING
   eif_lineno : INTEGER
   
feature {NONE} -- constants
   Init_buffer_size: INTEGER is 256

end -- class SCANNER
