indexing
   description: "Default Visitor"
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

class DEFAULT_VISITOR     

creation
   make

feature {ANY}
   make (p_ast : AST) is
      require
	 p_ast /= void
      do
	 ast := p_ast
      end
   
   visit is
      local
	 i : INTEGER
      do
	 if (ast /= void) then
	    if (ast.documents /= void) then
	       from i := 1 until i > ast.documents.count loop
		  sub_visit(ast.documents.item(i))
		  i := i + 1
	       end
	    end
	 end
      end
   
feature {DEFAULT_VISITOR}
   sub_visit (doc : DOCUMENT) is
      require
	 doc /= void
      do
	 visit_strings(doc.authors)
	 visit_strings(doc.parts)
	 visit_comments(doc.comments)
	 visit_string(doc.summary)
	 visit_string(doc.nbpages)
	 visit_string(doc.date)
	 visit_string(doc.type)
	 visit_string(doc.file)
	 visit_string(doc.title)
	 visit_string(doc.language)
      end
   
   visit_string (str : STRING) is
      do
      end
   
   visit_comment (comment : COMMENT) is
      do
	 visit_string(comment.author_name)
	 visit_string(comment.content)
      end

   visit_strings (strs : LINKED_LIST[STRING]) is
      local
	 i : INTEGER
      do
	 if (strs /= void) then
	    from i := 1 until i > strs.count loop
	       visit_string(strs.item(i))
	       i := i + 1
	    end
	 end
      end
   
   visit_comments (p_comments : LINKED_LIST[COMMENT]) is
      local
	 i : INTEGER
      do
	 if (p_comments /= void) then
	    from i := 1 until i > p_comments.count loop
	       visit_comment(p_comments.item(i))
	       i := i + 1
	    end
	 end
      end
   
feature {DEFAULT_VISITOR}
   ast : AST
   
   -- Public
   PUBLIC		: STRING is "public"
   PUBLIQUE		: STRING is "publique"

   -- Strings to Replace 
   AUTHOR		: STRING is "%%%%AUTHOR%%"
   CONTENT		: STRING is "%%%%CONTENT%%"
   TITREL		: STRING is "%%%%TITLEL%%"
   TITRE		   : STRING is "%%%%TITLE%%"
   AUTHORS		: STRING is "%%%%AUTHORS%%"
   DATE			: STRING is "%%%%DATE%%"
   LANGUAGE		: STRING is "%%%%LANGUAGE%%"
   TYPE			: STRING is "%%%%TYPE%%"
   URL			: STRING is "%%%%URL%%"
   SUMMARY		: STRING is "%%%%SUMMARY%%"
   NBPAGES		: STRING is "%%%%NBPAGES%%"
   PARTS		   : STRING is "%%%%PARTS%%"
   COMMENTS		: STRING is "%%%%COMMENTS%%"
   DOCUMENTS	: STRING is "%%%%DOCUMENTS%%"
   LINKS		   : STRING is "%%%%LINKS%%"
   LINK			: STRING is "%%%%LINK%%"
   NUMBER		: STRING is "%%%%NUMBER%%"
   VERSION		: STRING is "%%%%VERSION%%"
   ID			   : STRING is "%%%%ID%%"
end

