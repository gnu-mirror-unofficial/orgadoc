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
creation
   make

inherit DEFAULT_VISITOR
      rename
	 make as make_default
      redefine
	 sub_visit
	 
feature {ANY}
   make (a : AST; private : BOOLEAN; path : STRING; nb : INTEGER) is
      do
	 make_default(a)
	 enable_private := private
	 pos := nb
	 !!str.make_empty
      end
   
   get_result : STRING is
      do
	 Result := str
      end
   
feature {BIBTEX_VISITOR}
   sub_visit(doc : DOCUMENT) is
      do
	 if (allow_private or doc.type.same_as(PUBLIQUE) or
	     doc.type.same_as(PUBLIC)) then
	    
	    str.append("@article{orgadoc." + pos.to_string + ",%N")
	    pos := pos + 1
	    str.append("title=%"" + doc.title + "%",%N")
	    str.append("author=%"" + doc.author + "%",%N")
	    str.append("url=%"" + path + doc.file + "%",%N")
	    if doc.url /= void and doc.url.count > 0 then
	       str.append("url=%"" + doc.url + "%",%N")
	    end	 
	    str.append("year=%"" + doc.date + "%",%N")
	    str.append("abstract=%"" + doc.summary + "%"%N")
	    str.append("}%N")
	 end
      end
   
feature {BIBTEX_VISITOR}
   enable_private	: BOOLEAN
   path			: STRING
   str			: STRING
   
end

