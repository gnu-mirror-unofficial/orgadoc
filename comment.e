indexing
   description: "Comment node"
   author: "Julien LEMOINE <speedblue@debian.org>"
   --| This program is free software; you can redistribute it and/or modify
   --| it under the terms of the GNU General Public License as published by
   --| the Free Software Foundation; either version 2 of the License, or
   --| (at your option) any later version.

class COMMENT     
creation
   make
feature {ANY}
   make is
      do
      end
   
   set_author_name (p_name : STRING) is
      require
	 p_name /= void
      do
	 author_name := p_name
      end
   
   set_content (p_content : STRING) is
      require
	 p_comment /= void
      do
	 content := p_content
      end
   
feature {ANY}
   author_name	: STRING
   content	: STRING
end

