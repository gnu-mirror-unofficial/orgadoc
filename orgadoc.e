indexing
   description: "main class"
   author: "Julien LEMOINE <speedblue@debian.org>"
   --| Copyright (C) 2002 Julien LEMOINE
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

class ORGADOC
creation
   make

feature {ANY}
   -- Constructor
   make is
      local
	 paths		: LINKED_LIST[STRING]
	 i		: INTEGER
	 b		: BOOLEAN
      	 ofile		: STD_FILE_WRITE
	 latex		: TEMPLATE
	 can_write	: BOOLEAN
      do
	 bibtex_index := 1
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
	 dir		: BASIC_DIRECTORY
	 start_index	: INTEGER
	 b		: BOOLEAN
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
	 ofile		: STD_FILE_WRITE
	 html		: HTML_VISITOR
      do
	 new_path := correct(path).substring(params.input_path.count + 
					     1,correct(path).count)
	 if new_path.is_equal(".") then
	    new_path := "./" 
	 end
	 create_dirs(correct(params.output_path) + new_path)
	 !!html.make(ast, correct(params.output_path), 
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
   
   convert_display_file(ast : AST) is
      local
	 display	: PRINT_VISITOR
      do
	 !!display.make(ast)
	 display.visit
	 print(display.get_result)
      end
   
   convert_regexp_file(ast : AST) is
      local
	 grep		: GREP_VISITOR	 
      	 display	: PRINT_VISITOR	 
      do
	 !!grep.make(ast, params.enable_private, 
		     params.regexp, params.insensitive)
	 grep.visit
	 if (grep.get_result) then
	    !!display.make(ast)
	    display.visit
	    print(display.get_result)	       
	 end
      end
   
   -- convert to BibTex format
   convert_bibtex_file(ast : AST; path : STRING) is
      local
	 bibtex		: BIBTEX_VISITOR
      do
	 !!bibtex.make(ast, params.enable_private, 
		       path, bibtex_index);
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
	 name /= void
      local
	 parser		: READ_XML
      	 ast		: AST
	 convert	: TREE_TO_AST
	 bool		: BOOLEAN
	 cerr		: STD_ERROR
      do
	 !!cerr.make
	 print ("Try convert " + correct(path) + file + "%N")
	 !!parser.make(path + file)
	 if (parser.parse) then
	    !!convert.make(parser.get_tree);
	    ast := convert.convert;
	    -- Select type of conversion
	    if params.regexp /= void then
	       convert_regexp_file(ast)
	    elseif params.display_mode then
	       convert_display_file(ast)
	    elseif params.bibtex_mode then
	       convert_bibtex_file(ast, path)
	    elseif params.latex_mode then
	       convert_latex_file(ast, path)	    
	    end -- end select
	    print ("Successfully convert " + path + file + "%N")
	 else
	    ast := void
	    cerr.put_string ("Failed to convert " + correct(path) + file + "%N")
	 end
	 if (params.html_mode) then
	    convert_html_file(ast, path, sub_paths, sub_nb_docs)
	 end
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
	 sub_paths	: LINKED_LIST[STRING]
	 sub_nb_doc	: LINKED_LIST[INTEGER]
	 dir		: BASIC_DIRECTORY;
	 tmp_dir	: BASIC_DIRECTORY
	 another_path	: STRING
	 file		: STD_FILE_READ
	 tnb_docs	: INTEGER
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
	       tmp_dir.connect_to(another_path)
	       if tmp_dir.is_connected and recursive_convert(another_path) then
		  Result := true
		  sub_paths.add_last(another_path)
		  sub_nb_doc.add_last(nb_docs)
		  tnb_docs := tnb_docs + nb_docs
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
   params	: PARAMS
   nb_docs	: INTEGER
   bibtex_index : INTEGER
   tex_str	: STRING

   -- csts
   LATEXTPL	: STRING is "/latex/global.tpl"
   DOCUMENTS	: STRING is "%%%%DOCUMENTS%%"	 
   VERSION	: STRING is "%%%%VERSION%%"	 

end
