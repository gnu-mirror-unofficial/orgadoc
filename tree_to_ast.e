indexing
   description: "Tree to AST"
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

class TREE_TO_AST     
   
inherit KL_IMPORTED_STRING_ROUTINES; XM_NODE_PROCESSOR
      redefine
	 process_document, process_element, 
	 process_character_data
   
creation
   make

feature {ANY}
   make (tree : XM_DOCUMENT) is
      require
	 tree /= void
      do
	 doc := tree
      end
   
   convert : AST is
      require
	 doc /= void
      do
	 !!ast.make
	 process_document(doc)
	 Result := ast
      end
   
feature {TREE_TO_AST}
   process_document (p_doc : XM_DOCUMENT) is
      do
	 process_composite (p_doc)
      end
   
   process_element (el : XM_ELEMENT) is
      require
	 el /= void
      do
	 -- empty node is a <node/> with no data
	 if not el.is_empty then
	    process_start_element(el.name.out) --to_utf8)
	    process_composite(el)
	    process_end_element(el.name.out) --to_utf8)
	 end
      end
   
   process_start_element (name : STRING) is
      require
	 name /= void
      do
	 !!node_content.make_empty
      	 if (name.same_as(CREADME)) then
	    !!documents.make
	 elseif (name.same_as(CDOCUMENT)) then
	    !!authors.make
	    !!parts.make
	    !!comments.make
	    !!authors.make
	    title := void
	    language := void
	    date := void
	    type := void
	    file := void
	    summary := void
	    nbpages := void
	 elseif (name.same_as(CCOMMENT)) then
	    content := void
	    author_name := void
	 end
      end
   
   process_end_element (name : STRING) is
      require
	 name /= void
      local
	 comment : COMMENT
	 document : DOCUMENT
      do
	 if (name.same_as(CREADME)) then
	    ast.set_documents(documents)
	 elseif (name.same_as(CDOCUMENT)) then
	    !!document.make
	    document.set_parts(parts)
	    document.set_authors(authors)
	    document.set_comments(comments)
	    document.set_summary(summary)
	    document.set_nbpages(nbpages)
	    document.set_date(date)
	    document.set_type(type)
	    document.set_url(url)
	    document.set_file(file)
	    document.set_title(title)
	    document.set_language(language)
	    documents.add_last(document)
	 elseif (name.same_as(CCOMMENT)) then
	    !!comment.make
	    comment.set_content(content)
	    comment.set_author_name(author_name)
	    comments.add_last(comment)
	 elseif (name.same_as(CPART)) then
	    parts.add_last(node_content)
	 elseif (name.same_as(CAUTHOR)) then
	    authors.add_last(node_content)
	 elseif (name.same_as(CCOMMENT)) then
	    comments.add_last(comment)
	 elseif (name.same_as(CNBPAGES)) then
	    nbpages := node_content
	 elseif (name.same_as(CSUMMARY)) then
	    summary := node_content
	 elseif (name.same_as(CDATE)) then
	    date := node_content
	 elseif (name.same_as(CTYPE)) then
	    type := node_content
	 elseif (name.same_as(CURL)) then
	    url := node_content	 
	 elseif (name.same_as(CFILE)) then
	    file := node_content
	 elseif (name.same_as(CTITLE)) then
	    title := node_content
	 elseif (name.same_as(CLANGUAGE)) then
	    language := node_content
	 elseif (name.same_as(CAUTHOR_NAME)) then
	    author_name := node_content
	 elseif (name.same_as(CCONTENT)) then
	    content := node_content
	 end
      end
   
   process_character_data(c : XM_CHARACTER_DATA) is
      do
	 node_content := STRING_.concat (node_content, c.content.out)
      end
   
   process_composite (c: XM_COMPOSITE) is
	 -- Process composite `c'.
      require
	 c_not_void: c /= Void
      local
	 cs: DS_BILINEAR_CURSOR [XM_NODE]
      do
	 cs := c.new_cursor
	 from cs.start until cs.after loop
	    cs.item.process (Current)
	    cs.forth
	 end
      end

feature {TREE_TO_AST}
   -- Xml Document
   doc : XM_DOCUMENT
	 
   -- AST
   ast : AST
   
   -- To Construct Document Node
   parts	: LINKED_LIST[STRING]
   authors	: LINKED_LIST[STRING]
   comments	: LINKED_LIST[COMMENT]
   summary	: STRING
   nbpages	: STRING
   date		: STRING
   type		: STRING
   file		: STRING
   title	: STRING
   language	: STRING
   url		: STRING
   
   -- To Construct Root Node
   documents	: LINKED_LIST[DOCUMENT]
	 
   -- To construct Comment Node
   author_name	: STRING
   content	: STRING
   
   -- Node Content
   node_content	: STRING

   -- Constants
   CREADME	: STRING is "readme"
   CDOCUMENT	: STRING is "document"
   CCOMMENT	: STRING is "comment"
   CPART	: STRING is "part"
   CAUTHOR	: STRING is "author"
   CSUMMARY	: STRING is "summary"
   CNBPAGES	: STRING is "nbpages"
   CDATE	: STRING is "date"
   CTYPE	: STRING is "type"
   CURL		: STRING is "url"
   CFILE	: STRING is "file"
   CTITLE	: STRING is "title"
   CLANGUAGE	: STRING is "language"
   CAUTHOR_NAME	: STRING is "author_name"
   CCONTENT	: STRING is "content"
   
end
