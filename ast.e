indexing
   description: "Abstract Syntax Tree (root node)"
   author: "Julien LEMOINE <speedblue@debian.org>"
   --| This program is free software; you can redistribute it and/or modify
   --| it under the terms of the GNU General Public License as published by
   --| the Free Software Foundation; either version 2 of the License, or
   --| (at your option) any later version.
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

