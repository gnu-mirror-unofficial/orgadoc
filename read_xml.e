indexing
   description: "Traduction d'un fichier en arbre XML"
   author: "Julien LEMOINE <speedblue@debian.org>"
   --| This program is free software; you can redistribute it and/or modify
   --| it under the terms of the GNU General Public License as published by
   --| the Free Software Foundation; either version 2 of the License, or
   --| (at your option) any later version.

class READ_XML
creation
   make
   
feature {ANY}                   -- creation
   make(ppath : STRING) is
      do
	 path := ppath
      end
   
   get_tree : XM_TREE_PARSER is
      require
	 tree /= void
      do
	 Result := tree
      end
   
   parse : BOOLEAN is
      require
	 path /= void
      local
	 str	: UCSTRING
	 tools	: FILE_TOOLS
      do
	 -- choose expat if available
	 if fact.is_expat_event_available then
	    tree := parse_expat
	 else
	    tree := parse_eiffel
	 end
	 !!str.make_from_string(path)
	 if (tools.is_readable(path)) then
	    tree.parse_from_file_name(str);
	    if (tree /= void) then
	       Result := tree.is_correct
	    else
	       Result := false
	    end
	 else
	    Result := false
	 end
      end
   
   output is
      require
	 tree /= void
      do
	 print (tree.out + "%N")
	 print (tree.document.out + "%N")                    
      end
   
feature {READ_XML}
      
   parse_eiffel : XM_TREE_PARSER is
      do
      	 Result :=  fact.new_toe_eiffel_tree_parser
      ensure
	 Result /= void
      end
   
   parse_expat : XM_TREE_PARSER is
      do
	 Result :=  fact.new_toe_expat_tree_parser
      ensure
	 Result /= void
      end

feature {NONE}
   path : STRING;
   tree : XM_TREE_PARSER
   fact : expanded XM_PARSER_FACTORY
end
