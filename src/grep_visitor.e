indexing
   description: "Search in AST"
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

class GREP_VISITOR     

inherit DEFAULT_VISITOR
      rename
			make as make_default
      redefine
			visit_string, sub_visit
		end
	
creation
   make
   
feature {ANY}   
   make(a : AST; private : BOOLEAN; 
		  rexp : STRING; case_sensitive : BOOLEAN) is
      do
			make_default(a)
			!!regexp.compile(rexp, case_sensitive)
			res := false
			allow_private := private
      end
   
   get_result : BOOLEAN is
      do
			Result := res
      end
   
feature {GREP_VISITOR}
   sub_visit (doc : DOCUMENT) is
      require
			doc /= void
      do
			document := doc
			if (allow_private or doc.type.same_as(PUBLIQUE) or
				 doc.type.same_as(PUBLIC)) then
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
      end
   
   visit_string(str : STRING) is
      do
			if (str /= void) then
				if (regexp.is_compiled and regexp.matches(str)) then
					res := true
					if (document /= void) then
						document.set_mark(true)
					end
				end
			end
      end
   
feature {GREP_VISITOR}
   -- Vars
   regexp		: LX_DFA_REGULAR_EXPRESSION
   res			: BOOLEAN
   document		: DOCUMENT
   allow_private	: BOOLEAN
end

