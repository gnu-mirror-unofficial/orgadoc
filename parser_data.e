indexing
   description: "Store parser data"
   author: "Julien LEMOINE <speedblue@debian.org>"
   --| Copyright (C) 2002-2003 Julien LEMOINE
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

class PARSER_DATA     

creation
   make

feature {ANY}
   make is
      do
	 template_path := TEMP_DEFAULT_PATH
      end
   
   set_html(val : STRING) is
      require
	 val /= void
      do
	 html_file := val
      end
   
   set_bibtex(val : STRING) is
      require
	 val /= void
      do
	 bibtex_file := val
      end
   
   set_latex(val : STRING) is
      require
	 val /= void
      do
	 latex_file := val
      end

   set_xml(val : STRING) is
      require
	 val /= void
      do
	 xml_file := val
      end
   
   set_input(val : STRING) is
      require
	 val /= void
      do
	 input_path := val
      end
   
   set_output(val : STRING) is
      require
	 val /= void
      do
	 output_path := val
      end
   
   set_mode(val : STRING) is
      require
	 val /= void
      do
	 mode := val
      end
   
   set_rec(val : BOOLEAN) is
      require
	 val /= void
      do
	 recursive := val
      end
   
   set_private(val : BOOLEAN) is
      require
	 val /= void
      do
	 enable_private := val
      end
   
   set_httpdpath(val : STRING) is
      require
	 val /= void
      do
	 httpd_path := val
      end
   
   set_template(val : STRING) is
      require
	 val /= void
      do
	 template_path := val
      end

   display is
      do
	 print("----- Configuration File -----%N")
	 print_val("Html File%T", html)
	 print_val("Xml File%T", xml)
	 print_val("Input File%T", input)
	 print_val("Output File%T", output)
	 print_val("Mode%T%T", mode)
	 print_val("Recursive%T", rec)
	 print_val("Private%T%T", private)
	 print("%N")
      end
   
   is_html_mode : BOOLEAN is
      do
	 Result := false
	 if (mode /= void) then
	    Result := mode.same_as(HTML_MODE)
	 end
      end
   
   is_display_mode : BOOLEAN is
      do
	 Result := false
	 if (mode /= void) then
	    Result := mode.same_as(DISPLAY_MODE)
	 end
      end
   
   is_bibtex_mode : BOOLEAN is
      do
	 Result := false
	 if (mode /= void) then
	    Result := mode.same_as(BIBTEX_MODE)
	 end
      end
   
   is_latex_mode : BOOLEAN is
      do
	 Result := false
	 if (mode /= void) then
	    Result := mode.same_as(LATEX_MODE)
	 end
      end
  
feature {PARSER_DATA}
   print_val(desc : STRING; val : ANY) is
      do
	 if (desc /= void) then
	    print(desc + " : " )
	    print(val)
	    print("%N")
	 end
      end

feature {ANY}
   html_file		: STRING
   bibtex_file		: STRING
   latex_file		: STRING
   xml_file		: STRING
   input_path		: STRING
   output_path		: STRING
   mode			: STRING
   recursive		: BOOLEAN
   enable_private	: BOOLEAN
   template_path	: STRING
   httpd_path		: STRING
   
feature {PARSER_DATA}
   DISPLAY_MODE		: STRING is "DISPLAY"
   HTML_MODE		: STRING is "HTML"
   BIBTEX_MODE		: STRING is "BIBTEX"
   LATEX_MODE		: STRING is "LATEX"
   TEMP_DEFAULT_PATH	: STRING is "./"
end

