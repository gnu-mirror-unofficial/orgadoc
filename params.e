indexing
   description: "Parse command options"
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

class PARAMS
creation
   make
   
feature {ANY}
   make is
      local
			parser	: PARSER
      do
			reinit
			verbose := false
			recursive := false
			output_path := "./"
			httpd_path := ""
			enable_private := false
			insensitive := false
			template_path := DEFAULT_TPL_PATH
			pre_process_arguments
			if conffile = void then
				conffile := DEFAULT_CONF_FILE
			end
			!!parser.execute(conffile)
			debug
				parser.get_data.display
			end
			use_conffile(parser.get_data)
			process_arguments
			if (xml_file = void) then -- default value
				xml_file := DEFAULT_XML_FILE
			end
			if (regexp = void 
				 and not html_mode 
				 and not display_mode
				 and not bibtex_mode
				 and not latex_mode) then
				html_mode := true
			end
			if (input_path = void) then
				input_path := "./"
			end
			if (output_file = void) then
				if bibtex_mode then
					if parser.get_data.bibtex_file /= void then
						output_file := parser.get_data.bibtex_file
					else
						output_file := DEFAULT_BIBTEX_FILE
					end
				elseif latex_mode then
					if parser.get_data.latex_file /= void then
						output_file := parser.get_data.latex_file
					else
						output_file := DEFAULT_LATEX_FILE
					end	       
				else
					output_file := DEFAULT_HTML_FILE
				end
			end
      end
   
   get_version : STRING is
      do
			Result := VERSION
      end

   set_search(search : STRING; case : BOOLEAN) is
		require
			search /= void
		do
			regexp := search;
			insensitive := case;
		end
	
feature {PARAMS}
   reinit is
      do
			html_mode := false
			display_mode := false
			latex_mode := false
			bibtex_mode := false
      end
   
   display_help is
      do
			std_output.put_string(NAME + " %
												  %(organizes documents from XML descriptions)%N%N")
			std_output.put_string("Usage: " + command_arguments.item(0) + 
										 " [OPTION]%N%N")
			std_output.put_string("Options:%N")
			std_output.put_string("  -c, --conf-file <file>%Tgive %
										 %configuration file %N")
			std_output.put_string("  -f, --file <file>%T%Tgive xml file %N")
			std_output.put_string("  -o, --output-file <file>%Tfile to %
										 %store Output%N")
			std_output.put_string("  -p, --path <path>%T%Tpath to convert%N")
			std_output.put_string("  -e, --prefix <path>%T%Tpath to %
										 %store files%N")	    
			std_output.put_string("  -a, --httpd-path <path>%
										 %%Tdocument prefix path on http server%N")
			std_output.put_string("  -s, --search <regexp>%T%T%
										 %print AST matching a pattern%N")
			std_output.put_string("  -i, --case-insensitive%T%
										 %ignore case distinctions%N")
			std_output.put_string("  -w, --with-private%T%Tadd private doc%N")
			std_output.put_string("  -r, --recursive%T%TRecursively %
										 %convert directories.%N")
			std_output.put_string("  -t, --html%T%T%Toutput in html%N")
			std_output.put_string("  -b, --bibtex%T%T%Toutput in BibTex%N")
			std_output.put_string("  -l, --latex%T%T%Toutput in LaTex%N")
			std_output.put_string("  -d, --display-ast%T%Tdisplay AST%N")
			std_output.put_string("  -V, --verbose%T%T%Tenable verbose mode%N")
			std_output.put_string("  -v, --version%T%T%Toutput version %
										 %information and exit%N")
			std_output.put_string("  -h, --help%T%T%Tdisplay this help %
										 %and exit%N")
			die_with_code(0)
      end
   
   pre_process_arguments is
      local
			parser_switch	: STRING
			i					: INTEGER
      do
			from i := 1 until i > argument_count loop 
				parser_switch := command_arguments.item(i)
				if ((parser_switch.is_equal("--conf-file") or
					  parser_switch.is_equal("-c")) and 
					 (i /= argument_count)) then
					conffile := command_arguments.item(i + 1)
					i := i + 1
				end
				i := i + 1
			end
      end
						   
   process_arguments is
      local
			parser_switch	: STRING
			i					: INTEGER
      do
			from i := 1 until i > argument_count loop
				parser_switch := command_arguments.item(i)
				if (parser_switch.is_equal("--html") or
					 parser_switch.is_equal("-t")) then
					reinit
					html_mode := true
				elseif (parser_switch.is_equal("--bibtex") or
						  parser_switch.is_equal("-b")) then
					reinit
					bibtex_mode := true
				elseif (parser_switch.is_equal("--latex") or
						  parser_switch.is_equal("-l")) then
					reinit
					latex_mode := true	    
				elseif (parser_switch.is_equal("--display-ast") or
						  parser_switch.is_equal("-d")) then
					reinit
					display_mode := true
				elseif (parser_switch.is_equal("--case-insensitive") or
						  parser_switch.is_equal("-i")) then
					insensitive := true	    
				elseif (parser_switch.is_equal("--verbose") or
						  parser_switch.is_equal("-V")) then
					verbose := true	    
				elseif (parser_switch.is_equal("--with-private") or
						  parser_switch.is_equal("-w")) then
					enable_private := true	    
				elseif (parser_switch.is_equal("--recursive") or
						  parser_switch.is_equal("-r")) then
					recursive := true	    
				elseif (parser_switch.is_equal("--help") or
						  parser_switch.is_equal("-h")) then
					display_help
				elseif (parser_switch.is_equal("--version") or
						  parser_switch.is_equal("-v")) then
					display_version
				elseif ((parser_switch.is_equal("--file") or
							parser_switch.is_equal("-f")) and 
						  (i /= argument_count)) then
					xml_file := command_arguments.item(i + 1)
					i := i + 1
				elseif ((parser_switch.is_equal("--path") or
							parser_switch.is_equal("-p")) and 
						  (i /= argument_count)) then
					input_path := command_arguments.item(i + 1)
					i := i + 1
				elseif ((parser_switch.is_equal("--output-file") or
							parser_switch.is_equal("-o")) and 
						  (i /= argument_count)) then
					output_file := command_arguments.item(i + 1)
					i := i + 1
				elseif ((parser_switch.is_equal("--search") or
							parser_switch.is_equal("-s")) and 
						  (i /= argument_count)) then
					regexp := command_arguments.item(i + 1)
					i := i + 1	    	    
				elseif ((parser_switch.is_equal("--httpd-path") or
							parser_switch.is_equal("-a")) and 
						  (i /= argument_count)) then
					httpd_path := command_arguments.item(i + 1)
					i := i + 1	    
				elseif ((parser_switch.is_equal("--prefix") or
							parser_switch.is_equal("-e")) and 
						  (i /= argument_count)) then
					output_path := command_arguments.item(i + 1)
					i := i + 1	    
				elseif ((parser_switch.is_equal("--conf-file") or
							parser_switch.is_equal("-c")) and 
						  (i /= argument_count)) then
					conffile := command_arguments.item(i + 1)
					i := i + 1	    
				end
				i := i + 1
			end
      rescue
			display_help
			die_with_code(1)
      end
      
   display_version is
      do
			std_output.put_string(NAME + " version " + VERSION + "%N%N")
			std_output.put_string("Copyright 2002-2003")
			std_output.put_string(" Julien LEMOINE <julien@happycoders.org>%N")
			std_output.put_string("%NReport bugs to <julien@happycoders.org>.%N")
			die_with_code(0)
      end
   
   use_conffile(data : PARSER_DATA) is
      do
			if (data /= void) then
				if data.xml_file /= void then
					xml_file := data.xml_file
				end
				if data.input_path /= void then
					input_path := data.input_path
				end
				if data.output_path /= void then
					output_path := data.output_path
				end
				if data.recursive /= void then
					recursive := data.recursive
				end
				if data.enable_private /= void then
					enable_private := data.enable_private
				end
				if data.template_path /= void then
					template_path := data.template_path
				end
				if data.httpd_path /= void then
					httpd_path := data.httpd_path
				end
			end
      end
   
feature {ANY}
   verbose			: BOOLEAN
   html_mode		: BOOLEAN
   display_mode	: BOOLEAN
   bibtex_mode		: BOOLEAN
   latex_mode		: BOOLEAN
   xml_file			: STRING
   input_path		: STRING
   recursive		: BOOLEAN
   output_file 	: STRING
   output_path		: STRING
   httpd_path		: STRING
   enable_private	: BOOLEAN
   regexp			: STRING
   insensitive		: BOOLEAN
   conffile			: STRING
   template_path	: STRING
   
feature {PARAMS}
   DEFAULT_CONF_FILE		: STRING is "/etc/orgadoc/orgadoc.conf"
   DEFAULT_TPL_PATH		: STRING is "/etc/orgadoc/templates/html/"
   DEFAULT_XML_FILE		: STRING is "readme.xml"
   DEFAULT_HTML_FILE		: STRING is "index.html"
   DEFAULT_BIBTEX_FILE	: STRING is "orgadoc.bib"
   DEFAULT_LATEX_FILE	: STRING is "orgadoc.tex"
   NAME						: STRING is "OrgaDoc"
   VERSION					: STRING is "0.7.2-cvs"
end
