indexing
   description: "Comment node"
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
	 p_content /= void
      do
	 content := p_content
      end
   
feature {ANY}
   author_name	: STRING
   content	: STRING
end

