indexing
   description: "Display AST"
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

class PRINT_VISITOR
   
inherit DEFAULT_VISITOR
      rename
	 make as make_default
      redefine
	 sub_visit,
	 visit_string,
	 visit_strings,
	 visit_comment
creation
   make
   
feature {ANY}
   make(a : AST) is
      do
	 make_default(a)
	 !!str.make_empty
	 str.append("***********************************%N")
	 str.append("*           DOCUMENT              *%N")
	 str.append("***********************************%N")
      end
   
   get_result : STRING is
      do
	 Result := "%N" + str + "%N"
      end
   
feature {PRINT_VISITOR} -- visitor function
   pre_section (name : STRING) is
      do
	 if (name /= void) then
	    str.append (name)
	 end
      end
   
   sub_visit (doc : DOCUMENT) is
      require
	 doc /= void
      do
	 if (doc.mark) then
	    pre_section("Title    : ")
	    visit_string(doc.title)
	    pre_section("Authors  : ")
	    visit_strings(doc.authors)
	    pre_section("Date     : ")
	    visit_string(doc.date);
	    pre_section("Language : ")
	    visit_string(doc.language);
	    pre_section("Type     : ")
	    visit_string(doc.type);
	    pre_section("File     : ")
	    visit_string(doc.file);
	    pre_section("Url      : ")
	    visit_string(doc.url);	    
	    pre_section("Summary  : ")
	    visit_string(doc.summary);
	    pre_section("Parts    : ")
	    visit_strings(doc.parts);
	    visit_comments(doc.comments);
	 end
      end
   
   visit_comment (comment : COMMENT) is
      do   
	 if (comment /= void) then
	    str.append("***********************************%N")
	    str.append("*            COMMENT              *%N")
	    str.append("***********************************%N")
	    pre_section("Author   : ")
	    visit_string(comment.author_name)
	    pre_section("Content  : ")
	    visit_string(comment.content)
	 end
      end
   
   visit_strings (strs : LINKED_LIST[STRING]) is
      local
	 i : INTEGER
      do
	 if (strs /= void) then
	    from i := 1 until i > strs.count loop
	       if (i > 1) then
		  str.append("           ");
	       end
	       visit_string(strs.item(i))
	       i := i + 1
	    end
	 end
      end

   visit_string (name : STRING) is
      do
	 if (name /= void) then
	    str.append(name + "%N")
	 end
      end
   
feature {PRINT_VISITOR}   
   str		: STRING
end

