indexing
   description: "main class"
   author: "Julien LEMOINE <speedblue@debian.org>"
   --| This program is free software; you can redistribute it and/or modify
   --| it under the terms of the GNU General Public License as published by
   --| the Free Software Foundation; either version 2 of the License, or
   --| (at your option) any later version.

class ORGADOC
creation
   make

feature {ANY}
   make is
      local
	 paths	: LINKED_LIST[STRING]
	 i	: INTEGER
      do
	 !!params.make
	 if (params.recursive) then
	    paths := recursive_list_of(true, params.input_path)
	    from i := 1 until i > paths.count loop
	       convert_file(correct(paths.item(i)), params.xml_file)
	       i := i + 1
	    end
	 else
	    convert_file(correct(params.input_path), params.xml_file)
	 end
      end
   
feature {ORGADOC}
   convert_file(path, file : STRING) is
      require
	 path /= void
	 name /= void
      local
	 parser		: READ_XML
      	 display	: PRINT_VISITOR
	 html		: HTML_VISITOR
      	 ast		: AST
	 convert	: TREE_TO_AST
	 dir		: BASIC_DIRECTORY
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
	 if (params.html_mode) then
	    bool := dir.create_new_directory(correct(params.output_path) + 
					     new_path)
	 end
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
			recursive_list_of(false, path),
			correct(params.template_path))
	    html.visit
	    !!ofile.connect_to(correct(params.output_path) + 
			       new_path + params.html_file)
	       if (ofile /= void and ofile.is_connected) then
		  ofile.put_string(html.get_result)
		  ofile.disconnect
	       end
	 end
      
      end
   
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
   
   already_visited_places: ARRAY[STRING] is
      once
         !!Result.with_capacity(1,32);
      end;
   
   recursive_list_of(rec : BOOLEAN;
		     some_path : STRING) : LINKED_LIST[STRING] is
      do
	 !!rpaths.make
	 sub_recursive_list_of(rec, some_path, 0)
	 Result := rpaths
      end
   
   sub_recursive_list_of(rec : BOOLEAN; 
			 some_path: STRING; level : INTEGER) is
      require
	 some_path /= void
      local
         basic_directory		: BASIC_DIRECTORY;
	 tmp				: BASIC_DIRECTORY;
         some_entry, another_path	: STRING;
      do
	 basic_directory.connect_to(some_path);
	 if basic_directory.is_connected then
	    rpaths.add_last(correct(some_path));
	    from
	       basic_directory.read_entry;
	    until
	       basic_directory.end_of_input
	    loop
	       
	       some_entry := basic_directory.last_entry.twin;
	       basic_directory.compute_subdirectory_with(some_path,
							 some_entry);
	       if (rec or level < 1) and 
		  not basic_directory.last_entry.is_empty then
		  another_path := basic_directory.last_entry.twin;
		  tmp.connect_to(another_path)
		  if tmp.is_connected then
		     sub_recursive_list_of(rec, another_path, level + 1);
		  end;
	       end;
	       basic_directory.read_entry;
	    end;
	    basic_directory.disconnect;
	 end;
      end;
   
feature {ORGADOC}
   params	: PARAMS
   rpaths	: LINKED_LIST[STRING]
end
