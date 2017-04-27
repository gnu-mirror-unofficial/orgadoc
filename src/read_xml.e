indexing
   description: "Traduction d'un fichier en arbre XML"
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
 

class READ_XML
creation
   make
   
feature {ANY}                   -- creation
   make(ppath : STRING) is
      do
			path := ppath
      end
   
   get_tree : XM_DOCUMENT is
      require
			tree_pipe /= void
      do
			Result := tree_pipe.document
      end
   
   file_exist : BOOLEAN is
      require
			path /= void
      local
			in	: KL_TEXT_INPUT_FILE
      do
			!! in.make (path)
			in.open_read
			if in.is_open_read then
				in.close
				Result := true
			else
				Result := false
			end
      end
   
   parse : BOOLEAN is
      require
			path /= void
      local
			tools	: FILE_TOOLS
			in	: KL_TEXT_INPUT_FILE
      do
			--choose expat if available
			if fact.is_expat_parser_available then
				event_parser := fact.new_expat_parser
				-- tree := parse_expat
			else
				!XM_EIFFEL_PARSER! event_parser.make
				-- tree := parse_eiffel
			end
			!! tree_pipe.make
			event_parser.set_callbacks (tree_pipe.start)
			!! in.make (path)
			in.open_read
			if in.is_open_read then
				event_parser.parse_from_stream (in)
				in.close
				Result := not tree_pipe.error.has_error
				-- to fix
				if Result /= true then
					print("Tree not correct%N");
					debug
						print(tree_pipe.last_error + "%N")
					end
				end
			else
				Result := false
			end
      end
   
   output is
      require
			tree /= void
      do
			print (tree.out + "%N")
			print (tree.document.out + "%N")                    
      end
   
feature -- Parser
   fact		: XM_EXPAT_PARSER_FACTORY is
      once
			!! Result
      ensure
			factory_not_void: Result /= Void
      end   
   
feature {ANY}
   path				: STRING;
   event_parser	: XM_PARSER
   tree_pipe		: XM_TREE_CALLBACKS_PIPE
end
