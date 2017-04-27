indexing
   description: "main class"
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


class ORGADOC
creation
   make, make_cgi

feature {ANY}
   -- Constructor for cgi
	make_cgi (regexp : STRING) is
		require
			regexp /= void
      local
			b : BOOLEAN
      do
			nb_docs := 0
			is_prog := false;
			!!params.make
			res := ""
			params.set_search(regexp, true);
			if (params.recursive) then -- explore all files in sub directories
				b := recursive_convert(params.input_path)
			else -- convert only one file
				convert_file_nosubpaths(correct(params.input_path), 
												params.xml_file)
			end
		end

   -- default Constructor
   make is
      local
			b					: BOOLEAN
			ofile				: TEXT_FILE_WRITE
			latex				: TEMPLATE
			can_write		: BOOLEAN
      do
			bibtex_index := 1
			is_prog := true;
			!!tex_str.make_empty
			nb_docs := 0
			!!params.make
			!!latex.make(params.template_path + LATEXTPL)
			if params.latex_mode then
				can_write := latex.start
			end
			if (params.recursive) then -- explore all files in sub directories
				b := recursive_convert(params.input_path)
			else -- convert only one file
				convert_file_nosubpaths(correct(params.input_path), 
												params.xml_file)
			end
			if params.bibtex_mode then	 
				!!ofile.connect_to(correct(params.output_path) + 
										 params.output_file)
				if (ofile /= void and ofile.is_connected) then
					ofile.put_string(tex_str)
					ofile.disconnect
				end
			end
			if params.latex_mode then	 
				!!ofile.connect_to(correct(params.output_path) + 
										 params.output_file)
				if (ofile /= void and ofile.is_connected) then
					if can_write then
						latex.replace(VERSION, params.get_version)
						latex.replace(DOCUMENTS, tex_str)
						ofile.put_string(latex.stop)
						ofile.disconnect
					else
						print("Error, cannot localize template : " +
								params.template_path + LATEXTPL + "%N")
					end
				end
			end      
      end

	-- get result (for cgi mode)
	get_res : STRING is
		do
			Result := res
		end

feature {ORGADOC}
   
   --convert a file with no sub path
   convert_file_nosubpaths(path, file : STRING) is
      local
			sl : LINKED_LIST[STRING]
			il : LINKED_LIST[INTEGER]
      do
			!!sl.make
			sl.add_last(path)
			!!il.make
			convert_file(path, file, sl, il)
      end
   
   -- create directories
   create_dirs(path : STRING) is 
      local
			dir				: BASIC_DIRECTORY
			start_index		: INTEGER
			b					: BOOLEAN
      do
			from start_index := 1 until start_index <= 0 loop
				start_index := path.substring_index("/", start_index + 1)
				if start_index > 0 then
					b := dir.create_new_directory(path.substring(1, start_index))
				else
					b := dir.create_new_directory(path)
				end
			end
      end
   
   convert_html_file(ast : AST; path : STRING;
		               sub_paths : LINKED_LIST[STRING];
		               sub_nb_docs : LINKED_LIST[INTEGER]) is
      local
			new_path	: STRING
			httpd		: STRING
			ofile		: TEXT_FILE_WRITE
			html		: HTML_VISITOR
      do
			new_path := correct(path).substring(params.input_path.count + 
															1,correct(path).count)
			if new_path.is_equal(".") then
				new_path := "./" 
			end
			if params.httpd_path.count > 0 then
				httpd := params.httpd_path + new_path
			else
				httpd := correct(params.output_path) + new_path
			end
			create_dirs(correct(params.output_path) + new_path)
			!!html.make(ast, httpd, correct(params.output_path), 
							params.output_file, params.input_path,
							sub_paths, sub_nb_docs,
							correct(params.template_path), params)
			html.visit
			nb_docs := html.get_nb_docs
			!!ofile.connect_to(correct(params.output_path) + 
									 new_path + params.output_file)
			if (ofile /= void and ofile.is_connected) then
				ofile.put_string(html.get_result)
				ofile.disconnect
			end
      end
   
   convert_display_file(ast : AST; path : STRING) is
      local
			display	: PRINT_VISITOR
      do
			if (is_prog) then
				!!display.make_all(ast, params.template_path + REP_PROG, path)
			else
				!!display.make_all(ast, params.template_path + REP_CGI, path)
			end
			display.visit
			print(display.get_result)
      end
   
   convert_regexp_file(ast : AST; path : STRING) is
      local
			grep		: GREP_VISITOR	 
			display	: PRINT_VISITOR
			index	   : INTEGER
      do
			!!grep.make(ast, params.enable_private, 
							params.regexp, params.insensitive)
			grep.visit
			if (grep.get_result) then
				if (is_prog) then
					!!display.make(ast, params.template_path + REP_PROG, path)
				else
					index := path.first_substring_index(params.input_path)
					if (index > 0) then
						path.replace_substring(params.httpd_path, index,
													  index + params.input_path.count - 1)
					end
					!!display.make(ast, params.template_path + REP_CGI, path)
				end
				display.visit
				if (is_prog) then
					print(display.get_result)
				else
					res := res + display.get_result
				end
			end
      end
   
   -- convert to BibTex format
   convert_bibtex_file(ast : AST; path : STRING) is
      local
			bibtex		: BIBTEX_VISITOR
      do
			!!bibtex.make(ast, params.enable_private, 
							  path, bibtex_index, params.template_path);
			bibtex.visit
			bibtex_index := bibtex.get_pos
			tex_str.append(bibtex.get_result)
      end
   
   -- convert to LaTex format
   convert_latex_file(ast : AST; path : STRING) is
      local
			latex		: LATEX_VISITOR
      do
			!!latex.make(ast, params.enable_private, 
							 path, params.template_path);
			latex.visit
			tex_str.append(latex.get_result)
      end

   --convert a file
   convert_file(path, file : STRING; 
		sub_paths : LINKED_LIST[STRING];
		sub_nb_docs : LINKED_LIST[INTEGER]) is
      require
			path /= void
      local
			parser	: READ_XML
			ast		: AST
			convert	: TREE_TO_AST
			cerr		: STD_ERROR
      do
			!!cerr.make
			!!parser.make(correct(path) + file)
			if (parser.file_exist) then
				if params.verbose then
					print ("Try convert " + correct(path) + file + "%N")
				end
				if (parser.parse) then
					!!convert.make(parser.get_tree, params, correct(path) + file);
					ast := convert.convert;
					if (ast /= void) then
						-- Select type of conversion
						if params.regexp /= void then
							convert_regexp_file(ast, sub_paths.item(1))
						elseif params.display_mode then
							convert_display_file(ast, sub_paths.item(1))
						elseif params.bibtex_mode then
							convert_bibtex_file(ast, path)
						elseif params.latex_mode then
							convert_latex_file(ast, path)	    
						end -- end select
					end
				else
					ast := void
					if params.verbose then
						cerr.put_string ("Failed to convert " + 
											  correct(path) + file + "%N")
					end
				end
			end
			if params.html_mode then
				convert_html_file(ast, path, sub_paths, sub_nb_docs)
			end
			if ast = void and parser.file_exist then
				cerr.put_string("Error [" + correct(path) + file +
									 "] : Empty AST%N")
			elseif params.verbose and parser.file_exist then
				print ("Successfully convert " + correct(path) + file + "%N")
			elseif not parser.file_exist and params.verbose then
				print ("No file " + correct(path) + file + "%N")
			end
         rescue
   			cerr.put_string ("%N" + correct(path) + file + " is not correct%N")
   			cerr.put_string ("verify the xml header, it must contain : %
   								  % encoding=%"ISO-8859-1%"%N")
   			die_with_code(0)
      end
   
   -- add a final '/' if there is not one
   correct (path : STRING) : STRING is
      require
			path /= void
      do
			if path.last = '/' or path.is_equal("") then
				Result := path
			else
				Result := path + "/"
			end
      end
   
   -- explore all sub directory and create file
   recursive_convert(some_path : STRING) : BOOLEAN is
      require
			some_path /= void
      local
			sub_paths	 : LINKED_LIST[STRING]
			sub_nb_doc	 : LINKED_LIST[INTEGER]
			dir		    : BASIC_DIRECTORY;
			tmp_dir	    : BASIC_DIRECTORY
			another_path : STRING
			file		    : TEXT_FILE_READ
			tnb_docs	    : INTEGER
      do
			tnb_docs := 0
			!!sub_paths.make
			sub_paths.add_last(correct(some_path))
			!!sub_nb_doc.make
			Result := false
			dir.connect_to(some_path);
			if dir.is_connected then -- directory exist
				from dir.read_entry until dir.end_of_input loop -- loop on sub directory
					dir.compute_subdirectory_with(some_path, dir.last_entry.twin)
					another_path := dir.last_entry.twin
					if another_path.count > 0 then
						if tmp_dir.is_connected then
							tmp_dir.disconnect
						end
						tmp_dir.connect_to(another_path)
						if tmp_dir.is_connected and recursive_convert(another_path) then
							Result := true
							sub_paths.add_last(another_path)
							sub_nb_doc.add_last(nb_docs)
							tnb_docs := tnb_docs + nb_docs
							if tmp_dir.is_connected then
								tmp_dir.disconnect
							end
						end
					end
					dir.read_entry -- next sub directory
				end
				dir.disconnect
				!!file.connect_to(correct(some_path) + params.xml_file)
				if Result or file.is_connected then
					if file.is_connected then
						file.disconnect
					end
					Result := true
					convert_file(some_path, params.xml_file, sub_paths, sub_nb_doc)
					tnb_docs := tnb_docs + nb_docs
				end
				nb_docs := tnb_docs
			end
      end
   
feature {ORGADOC}
   params		  : PARAMS
   nb_docs		  : INTEGER
   bibtex_index  : INTEGER
   tex_str		  : STRING
	is_prog		  : BOOLEAN
	res			  : STRING
	
			-- csts
   LATEXTPL		 : STRING is "/latex/global.tpl"
	DOCUMENTS	 : STRING is "%%%%DOCUMENTS%%"	 
	VERSION		 : STRING is "%%%%VERSION%%"	 
	REP_PROG		 : STRING is "/ast"
	REP_CGI		 : STRING is "/cgi"
end
