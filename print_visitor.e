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
	 sub_visit
creation
   make
   
feature {ANY}
   make(a : AST, template_path, ppath : STRING) is
      do
	 !!tdocument.make(template_path + CTDOCUMENT)
	 !!tcomment.make(template_path + CTCOMMENT)
	 make_default(a)
	 path := ppath
	 !!str.make_empty
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
	    if (tdocument.start) then
	       tdocument.replace(TITRE, doc.title)
	       tdocument.replace(TITREL, path + doc.file)
	       tdocument.replace(AUTHORS, visit_strs(doc.authors))
	       tdocument.replace(DATE, doc.date)
	       tdocument.replace(LANGUAGE, doc.language)
	       tdocument.replace(TYPE, doc.type)
	       tdocument.replace(URL, doc.url)
	       tdocument.replace(NBPAGES, doc.nbpages)
	       tdocument.replace(SUMMARY, doc.summary)
	       tdocument.replace(PARTS, visit_strs(doc.parts))
	       tdocument.replace(COMMENTS, visit_cmts(doc.comments))
	       str.append(tdocument.stop)
	    end

	 end
      end
   
   visit_str (name : STRING) : STRING is
      do
	 if (name /= void) then
	    Result := name
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
   
feature {PRINT_VISITOR}   
   path		: STRING
   str		: STRING
   tdocument	: TEMPLATE
   tcomment	: TEMPLATE
   
   -- consts
   CTDOCUMENT	: STRING is "/ast/document.tpl"
   CTCOMMENT	: STRING is "/ast/comment.tpl"
	 
end
