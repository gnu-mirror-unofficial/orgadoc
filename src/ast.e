indexing
   description: "Abstract Syntax Tree (root node)"
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
   
class AST     

creation
   make

feature {ANY}
   make is
      do
      end
   
   set_documents (docs : LINKED_LIST[DOCUMENT]) is
      require
	 docs /= void
      do
	 documents := docs
      end
   
   add_document (document : DOCUMENT) is
      require
	 document /= void
      do
	 if (documents = void) then
	    !!documents.make
	 end
	 documents.add_last(document)
      end
   
feature {ANY}
   documents : LINKED_LIST[DOCUMENT]
end

