%{
indexing
   description: "configuration file parser"
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
	   
   maintainer: "Adam Bilbrough"
   --| Copyright (C) 2017 Adam Bilbrough
   --| This file is part of GNU OrgaDoc.
   --|
   --| GNU OrgaDoc is free software: you can redistribute it
   --| and/or modify it under the terms of the GNU General Public License
   --| as published by the Free Software Foundation, either version 3
   --| of the License, or (at your option) any later version.
   --|
   --| GNU OrgaDoc is distributed in the hope that it will be useful,
   --| but WITHOUT ANY WARRANTY; without even the implied warranty of
   --| MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
   --| See the GNU General Public License for more details.
   --|
   --| You should have received a copy of the GNU General Public License
   --| along with this program. If not, see http://www.gnu.org/licenses/. 
 

class PARSER
   
inherit
   YY_PARSER_SKELETON [ANY]
      rename
	 make as make_parser_skeleton
      redefine
	 report_error
      end
   
  SCANNER
      rename
	 make as make_scanner
      end
   
   KL_SHARED_EXCEPTIONS
   KL_SHARED_ARGUMENTS
   
creation
   make, execute
   
%}

%token T_XML T_HTML T_BIBTEX T_INPUT T_OUTPUT T_PRIVATE T_MODE T_REC T_LATEX
%token T_TRUE T_FALSE T_EQUAL T_TEMPLATE T_HTTPDPATH
%token <STRING> T_STRING 
%token <INTEGER> T_INTEGER

%type <BOOLEAN> Boolean

%start ConfFile

%%

ConfFile: Entrys
	;
	
Entrys: -- Empty
	| Entry Entrys
	;
	
Entry : T_XML T_EQUAL T_STRING { data.set_xml($3) }
	| T_HTML T_EQUAL T_STRING { data.set_html($3) }
	| T_BIBTEX T_EQUAL T_STRING { data.set_bibtex($3) }
	| T_LATEX T_EQUAL T_STRING { data.set_latex($3) }
	| T_INPUT T_EQUAL T_STRING { data.set_input($3) }
	| T_OUTPUT T_EQUAL T_STRING { data.set_output($3) }
	| T_MODE T_EQUAL T_STRING { data.set_mode($3) }
	| T_PRIVATE T_EQUAL Boolean { data.set_private($3) }
	| T_REC T_EQUAL Boolean { data.set_rec($3) }
	| T_TEMPLATE T_EQUAL T_STRING { data.set_template($3) }
	| T_HTTPDPATH T_EQUAL T_STRING { data.set_httpdpath($3) }
	;
	
Boolean: T_FALSE { $$ := false }
	| T_TRUE { $$ := true }
	;
	
%%

feature {NONE} -- Initialization
   make is
      do
	 make_scanner
	 make_parser_skeleton
	 !!data.make
      end
   
   execute (filename : STRING) is
      local
	 file: KL_TEXT_INPUT_FILE
      do
	 make
         !!file.make (filename)
         file.open_read
         if file.is_open_read then
	     reset
	     set_input_buffer (new_file_buffer (file))
	     parse
	     file.close
	 else
	     std.error.put_string ("parser: cannot read %'")
	     std.error.put_string (filename)
	     std.error.put_string ("%'%N")
	 end
      end
      
   report_error (message: STRING) is
      local
	 f_buffer: YY_FILE_BUFFER
      do
	 f_buffer ?= input_buffer
	 if f_buffer /= Void then
	    std.error.put_string (f_buffer.file.name)
	    std.error.put_string (", line ")
	 else
	    std.error.put_string ("line ")
	 end
	 std.error.put_integer (eif_lineno)
	 std.error.put_string (": ")
	 std.error.put_string (message)
	 std.error.put_character ('%N')
      end
   
feature {ANY}
   get_data : PARSER_DATA is
      do
	 Result := data
      end
   
feature {NONE}
   data : PARSER_DATA
   
end -- class PARSER
