%{
indexing
   description: "configuration file scanner"
   author: "Julien Lemoine <speedblue@happycoders.org>"
   --| Copyright (C) 2002-2004 Julien Lemoine
   --| This program is free software; you can redistribute it and/or modify
   --| it under the terms of the GNU General Public License as published by
   --| the Free Software Foundation; either version 2 of the License, or
   --| (at your option) any later version.
   --| 
   --| This program is distributed in the hope that it will be useful,
   --| but WITHOUT ANY WARRANTY; without even the implied warranty of
   --| MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   --| GNU General Public License for more details.
   --|
   --| You should have received a copy of the GNU General Public License
   --| along with this program; if not, write to the Free Software
   --| Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA 

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
"BibTexFile"		last_token := T_BIBTEX
"LaTexFile"		last_token := T_LATEX
"InputPath"		last_token := T_INPUT
"OutputPath"		last_token := T_OUTPUT
"EnablePrivateDoc"	last_token := T_PRIVATE
"Mode"			last_token := T_MODE
"Recursive"		last_token := T_REC
"TemplatePath"		last_token := T_TEMPLATE
"HttpdDocPath"		last_token := T_HTTPDPATH
[tT][rR][uU][eE]	last_token := T_TRUE
[fF][aA][lL][sS][eE]	last_token := T_FALSE
"="			last_token := T_EQUAL
[0-9]+			{
			  last_token := T_INTEGER
			  last_value := text.to_integer
			}
[-a-zA-Z0-9_~/.:]+		{
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
