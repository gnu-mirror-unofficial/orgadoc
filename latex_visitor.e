
indexing
   description: "Convert AST to LaTex"
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

class LATEX_VISITOR     


inherit DEFAULT_VISITOR
      rename
			make as make_default
      redefine
			sub_visit
		end
	
creation
   make
	 
feature {ANY}
   make (a : AST; private : BOOLEAN; ppath, template_path : STRING) is
      do
	 make_default(a)
	 enable_private := private
	 path := ppath
	 !!str.make_empty
	 !!tdocument.make(template_path + CTDOCUMENT)
	 !!tcomment.make(template_path + CTCOMMENT)
      end
   
   get_result : STRING is
      do
	 Result := str
      end
   
feature {LATEX_VISITOR}
   sub_visit(doc : DOCUMENT) is
      do
	 if (enable_private or doc.type.same_as(PUBLIQUE) or
	     doc.type.same_as(PUBLIC)) then
	    if (tdocument.start) then
	       tdocument.replace(TITRE, correct(doc.title))
	       tdocument.replace(TITREL, correct(path + doc.file))
	       tdocument.replace(AUTHORS, correct(visit_strs(doc.authors)))
	       tdocument.replace(DATE, correct(doc.date))
	       tdocument.replace(LANGUAGE, correct(doc.language))
	       tdocument.replace(TYPE, correct(doc.type))
	       tdocument.replace(URL, correct(doc.url))
	       tdocument.replace(SUMMARY, correct(doc.summary))
	       tdocument.replace(NBPAGES, correct(doc.nbpages))
	       tdocument.replace(PARTS, visit_strs(doc.parts))
	       tdocument.replace(COMMENTS, visit_cmts(doc.comments))
	       str.append(tdocument.stop)
	    end
	 end
      end
   
   correct(n : STRING) : STRING is
      local
	 val : INTEGER
	 name : STRING
      do
	 val := -2
	 name := n
	 if (name /= void) then
	    from val :=  name.substring_index("_", val + 2) until val <= 0 loop
	       name := name.substring(1, val - 1) + "\_" +
		  name.substring(val + 1, name.count);
	       val :=  name.substring_index("_", val + 3)
	    end
	    Result := name
	 else
	    Result := ""
	 end
      end
   
   visit_str (name : STRING) : STRING is
      do
	 if (name /= void) then
	    Result := correct(name)
	 else
	    Result := ""
	 end
      end
   
   visit_strs (strs : LINKED_LIST[STRING]) : STRING is
      local
	 i : INTEGER
      do
	 Result := ""
	 from i := 1 until i > strs.count loop
	    Result.append(visit_str(strs.item(i)))
	    i := i + 1
	    if (i <= strs.count) then
	       Result.append (", ")
	    end
	 end
      end
   
   visit_cmts (p_comments : LINKED_LIST[COMMENT]) : STRING is
      local
	 i : INTEGER
      do
	 Result := ""
	 if (p_comments /= void) then
	    from i := 1 until i > p_comments.count loop
	       Result.append(visit_cmt(p_comments.item(i)))
	       i := i + 1
	    end
	 end
      end

   visit_cmt (comment : COMMENT) : STRING is
      do   
	 Result := ""
	 if (comment /= void) then
	    if (tcomment.start) then
	       tcomment.replace(AUTHOR, comment.author_name)
	       tcomment.replace(CONTENT, comment.content)
	       Result.append(tcomment.stop)
	    end
	 end
      end
   
feature {LATEX_VISITOR}
   -- Vars
   enable_private	: BOOLEAN
   path			: STRING
   str			: STRING
   tdocument		: TEMPLATE
   tcomment		: TEMPLATE
   
feature {ANY}
   -- Templates Files
   CTGLOBAL		: STRING is "/latex/global.tpl"
   CTDOCUMENT		: STRING is "/latex/document.tpl"
   CTCOMMENT		: STRING is "/latex/comment.tpl"

end -- latex_vivitor
