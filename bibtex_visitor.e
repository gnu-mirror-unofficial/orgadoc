indexing
   description: "Convert AST to BibTex"
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

class BIBTEX_VISITOR     


inherit DEFAULT_VISITOR
      rename
	 make as make_default
      redefine
	 sub_visit

creation
   make
	 
feature {ANY}
   make (a : AST; private : BOOLEAN; ppath : STRING; nb : INTEGER) is
      do
	 make_default(a)
	 enable_private := private
	 pos := nb
	 path := ppath
	 !!str.make_empty
      end
   
   get_result : STRING is
      do
	 Result := str
      end
   
   get_pos : INTEGER is
      do
	 Result := pos
      end
   
feature {BIBTEX_VISITOR}
   sub_visit(doc : DOCUMENT) is
      local
	 i : INTEGER
      do
	 if (enable_private or doc.type.same_as(PUBLIQUE) or
	     doc.type.same_as(PUBLIC)) then
	    str.append("@article{orgadoc." + pos.to_string + ",%N")
	    pos := pos + 1
	    item_visitor("title=%"",doc.title)
	    items_visitor("author=%"", doc.authors)
	    item_visitor("url=%"", path + doc.file)
	    item_visitor("url=%"", doc.url)
	    item_visitor("year=%"", doc.date)
	    item_visitor("abstract=%"", doc.summary)
	    str.append("}%N")
	 end
      end
   
   items_visitor(desc : STRING; strs : LINKED_LIST[STRING]) is
      local
	 i : INTEGER
      do
	 if strs /= void then
	    from i := 1 until i > strs.count loop
	       item_visitor(desc, strs.item(i))
	       i := i + 1
	    end
	 end	 
      end
   
   item_visitor(desc : STRING; pstr : STRING) is
      do
	 if pstr /= void then
	    str.append(desc + pstr + "%",%N")
	 end
      end
   
feature {BIBTEX_VISITOR}
   -- Public
   PUBLIC		: STRING is "public"
   PUBLIQUE		: STRING is "publique"
   
   -- Vars
   enable_private	: BOOLEAN
   pos			: INTEGER
   path			: STRING
   str			: STRING
   
end -- bibtex_vivitor

