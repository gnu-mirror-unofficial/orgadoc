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
	 paths	: LINKED_LIST[STRING]
	 i	: INTEGER
	 b	: BOOLEAN
      do
	 nb_docs := 0
	 !!params.make
	 if (params.recursive) then -- explore all files in sub directories
	    b := recursive_convert(params.input_path)
	 else -- convert only one file
	    convert_file_nosubpaths(correct(params.input_path), params.xml_file)
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
   
   --convert a file
   convert_file(path, file : STRING; 
		sub_paths : LINKED_LIST[STRING];
		sub_nb_docs : LINKED_LIST[INTEGER]) is
      require
	 path /= void
	 name /= void
      local
	 parser		: READ_XML
      	 display	: PRINT_VISITOR
	 html		: HTML_VISITOR
      	 ast		: AST
	 convert	: TREE_TO_AST
	 bool		: BOOLEAN
	 ofile		: STD_FILE_WRITE
	 new_path	: STRING
	 grep		: GREP_VISITOR
	 cerr		: STD_ERROR
      do
	 !!cerr.make
	 new_path := correct(path).substring(params.input_path.count + 
					     1,correct(path).count)
	 if new_path.is_equal(".") then
	    new_path := "./" 
	 end
	 print ("Try convert " + path + file + "%N")
	 !!parser.make(path + file)
	 create_dirs(correct(params.output_path) + new_path)
	 if (parser.parse) then
	    !!convert.make(parser.get_tree);
	    ast := convert.convert;
	    if (params.regexp /= void) then
	       !!grep.make(ast, params.regexp, params.insensitive)
	       grep.visit
	       if (grep.get_result) then
		  !!display.make(ast)
		  display.visit
		  print(display.get_result)	       
	       end
	    else
	       if (params.display_mode) then
		  !!display.make(ast)
		  display.visit
		  print(display.get_result)
	       end
	    end
	    print ("Successfully convert " + path + file + "%N")
	 else
	    ast := void
	    cerr.put_string ("Failed to convert " + path + file + "%N")
	 end
	 if (params.html_mode) then
	    !!html.make(ast, params.enable_private, 
			correct(params.output_path), 
			params.html_file, params.input_path,
			sub_paths, sub_nb_docs,
			correct(params.template_path))
	    html.visit
	    nb_docs := html.get_nb_docs
	    !!ofile.connect_to(correct(params.output_path) + 
			       new_path + params.html_file)
	       if (ofile /= void and ofile.is_connected) then
		  ofile.put_string(html.get_result)
		  ofile.disconnect
	       end
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
end
