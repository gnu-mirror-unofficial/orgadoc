indexing
   description: "Convert AST to BibTex"
   author: "Julien Lemoine <speedblue@happycoders.org>"
   --| Copyright (C) 2002-2004 Julien Lemoine
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
   
   maintainer: "Adam Bilbrough <abilbrou@gmail.com>"
   --| Copyright (C) 2017 Adam Bilbrough
   --| This file is part of GNU OrgaDoc.
   --|
   --| GNU OrgaDoc is free software: you can redistribute it
   --| and/or modify it under the terms of the GNU General Public License
   --| as published by the Free Software Foundation, either version 3
   --| of the License, or (at your option) any later version.
   --|
   --| GNU OrgaDoc is distributed in the hope that it will be useful,
   --| but WITHOUT ANY WARRANTY; without even the implied warranty of
   --| MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
   --| See the GNU General Public License for more details.
   --|
   --| You should have received a copy of the GNU General Public License
   --| along with this program. If not, see http://www.gnu.org/licenses/.

class BIBTEX_VISITOR     


inherit DEFAULT_VISITOR
      rename
			make as make_default
      redefine
			sub_visit
		end
	
creation
   make
	 
feature {ANY}
   make (a : AST; private : BOOLEAN; ppath : STRING; nb : INTEGER;
	 template_path : STRING) is
      do
	 make_default(a)
	 enable_private := private
	 pos := nb
	 path := ppath
	 !!tdocument.make(template_path + CTDOCUMENT)
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
      do
		if (enable_private or doc.type.same_as(PUBLIQUE) or
	     doc.type.same_as(PUBLIC)) then
	    if (tdocument.start) then
	       tdocument.replace(ID, "orgadoc." + pos.to_string)
	       pos := pos + 1
	       tdocument.replace(TITRE, doc.title)
	       tdocument.replace(TITREL, path + doc.file)
	       tdocument.replace(AUTHORS, visit_strs(doc.authors))
	       tdocument.replace(DATE, doc.date)
	       tdocument.replace(LANGUAGE, doc.language)
	       tdocument.replace(TYPE, doc.type)
	       tdocument.replace(URL, doc.url)
	       tdocument.replace(SUMMARY, doc.summary)
	       tdocument.replace(NBPAGES, doc.nbpages)
	       tdocument.replace(PARTS, visit_strs(doc.parts))
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
   
feature {BIBTEX_VISITOR}
   -- Vars
   enable_private	: BOOLEAN
   pos			: INTEGER
   path			: STRING
   str			: STRING
   tdocument		: TEMPLATE
   
   -- Template files
   CTDOCUMENT		: STRING is "/bibtex/document.tpl"
   
end -- bibtex_vivitor

