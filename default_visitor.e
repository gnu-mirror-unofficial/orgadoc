indexing
   description: "Default Visitor"
   author: "Julien LEMOINE <speedblue@debian.org>"
   --| This program is free software; you can redistribute it and/or modify
   --| it under the terms of the GNU General Public License as published by
   --| the Free Software Foundation; either version 2 of the License, or
   --| (at your option) any later version.
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
		  i := i + 11
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
   
   visit_comments (comments : LINKED_LIST[COMMENT]) is
      local
	 i : INTEGER
      do
	 if (comments /= void) then
	    from i := 1 until i > comments.count loop
	       visit_comment(comments.item(i))
	       i := i + 1
	    end
	 end
      end
   
feature {DEFAULT_VISITOR}
   ast : AST
end

