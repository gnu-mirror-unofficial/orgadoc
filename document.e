indexing
   description: "Document node"
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

class DOCUMENT     
creation
   make
feature {ANY}
   make is
      do
			!!parts.make
			!!authors.make
			!!comments.make
			mark := false
      end
   
   set_parts (p_parts : LINKED_LIST[STRING]) is
      require
			p_parts /= void
      do
			parts := p_parts
      end
   
   set_authors (p_authors : LINKED_LIST[STRING]) is
      require
			p_authors /= void
      do
			authors := p_authors
      end

   set_comments (p_comments : LINKED_LIST[COMMENT]) is
      require
			p_comments /= void
      do
			comments := p_comments
      end

   add_part (part : STRING) is
      require
			part /= void
			parts /= void
      do
			parts.add_last(part)
      end
   
   add_author (author : STRING) is
      require
			author /= void
			authors /= void
      do
			authors.add_last(author)
      end
   
   add_comment (comment : COMMENT) is
      require
			comments /= void
			comment /= void
      do
			comments.add_last(comment)
      end
   
   set_nbpages (p_nbpages : STRING) is
      do
			nbpages := p_nbpages
      end
   
   set_summary (p_summary : STRING) is
      do
			summary := p_summary
      end
   
   set_date (p_date : STRING) is
      do
			date := p_date
      end
   
   set_type (p_type : STRING) is
      require
			p_type /= void
      do
			type := p_type
      end
   
   set_file (p_file : STRING) is
      require
			p_file /= void
      do
			file := p_file
      end
   
   set_url (p_url : STRING) is
      do
			url := p_url
      end
   
   set_title (p_title : STRING) is
      require
			p_title /= void
      do
			title := p_title
      end
   
   set_language (p_language : STRING) is
      require
			p_language /= void
      do
			language := p_language
      end
   
   set_mark (pmark : BOOLEAN) is
      do
			mark := pmark
      end
   
feature {ANY}
   parts	: LINKED_LIST[STRING]
   authors	: LINKED_LIST[STRING]
   comments	: LINKED_LIST[COMMENT]
   summary	: STRING
   nbpages	: STRING
   date		: STRING
   type		: STRING
   file		: STRING
   url		: STRING
   title	: STRING
   language	: STRING
   mark		: BOOLEAN
end

