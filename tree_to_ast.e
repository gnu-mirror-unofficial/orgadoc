indexing
   description: "Tree to AST"
   author: "Julien LEMOINE <speedblue@debian.org>"
   --| This program is free software; you can redistribute it and/or modify
   --| it under the terms of the GNU General Public License as published by
   --| the Free Software Foundation; either version 2 of the License, or
   --| (at your option) any later version.
class TREE_TO_AST     
   
inherit XM_NODE_PROCESSOR
      redefine
	 process_document, process_element, 
	 process_character_data
creation
   make

feature {ANY}
   make (tree : XM_TREE_PARSER) is
      require
	 tree /= void
      do
	 doc := tree.document
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
	    process_start_element(el.name.to_utf8)
	    process_composite(el)
	    process_end_element(el.name.to_utf8)
	 end
      end
   
   process_start_element (name : STRING) is
      require
	 name /= void
      do
	 !!node_content.make_empty
      	 if (name.same_as(README)) then
	    !!documents.make
	 elseif (name.same_as(DOCUMENT)) then
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
	 elseif (name.same_as(COMMENT)) then
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
	 if (name.same_as(README)) then
	    ast.set_documents(documents)
	 elseif (name.same_as(DOCUMENT)) then
	    !!document.make
	    document.set_parts(parts)
	    document.set_authors(authors)
	    document.set_comments(comments)
	    document.set_summary(summary)
	    document.set_date(date)
	    document.set_type(type)
	    document.set_file(file)
	    document.set_title(title)
	    document.set_language(language)
	    documents.add_last(document)
	 elseif (name.same_as(COMMENT)) then
	    !!comment.make
	    comment.set_content(content)
	    comment.set_author_name(author_name)
	    comments.add_last(comment)
	 elseif (name.same_as(PART)) then
	    parts.add_last(node_content)
	 elseif (name.same_as(AUTHOR)) then
	    authors.add_last(node_content)
	 elseif (name.same_as(COMMENT)) then
	    comments.add_last(comment)
	 elseif (name.same_as(SUMMARY)) then
	    summary := node_content
	 elseif (name.same_as(DATE)) then
	    date := node_content
	 elseif (name.same_as(TYPE)) then
	    type := node_content
	 elseif (name.same_as(FILE)) then
	    file := node_content
	 elseif (name.same_as(TITLE)) then
	    title := node_content
	 elseif (name.same_as(LANGUAGE)) then
	    language := node_content
	 elseif (name.same_as(AUTHOR_NAME)) then
	    author_name := node_content
	 elseif (name.same_as(CONTENT)) then
	    content := node_content
	 end
      end
   
   process_character_data(c : XM_CHARACTER_DATA) is
      do
	 node_content := node_content + c.content.to_utf8
      end
   
   process_composite(c : XM_COMPOSITE) is
      require
	 c /= void
      local
	 cs : DS_BILINEAR_CURSOR [XM_NODE]
      do
	 from 
	    cs := c.new_cursor
	    cs.start
	 until
	    cs.off
	 loop
	    cs.item.process(Current)
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
   date		: STRING
   type		: STRING
   file		: STRING
   title	: STRING
   language	: STRING
	 
   -- To Construct Root Node
   documents	: LINKED_LIST[DOCUMENT]
	 
   -- To construct Comment Node
   author_name	: STRING
   content	: STRING
   
   -- Node Content
   node_content	: STRING

   -- Constants
   README	: STRING is "readme"
   DOCUMENT	: STRING is "document"
   COMMENT	: STRING is "comment"
   PART		: STRING is "part"
   AUTHOR	: STRING is "author"
   SUMMARY	: STRING is "summary"
   DATE		: STRING is "date"
   TYPE		: STRING is "type"
   FILE		: STRING is "file"
   TITLE	: STRING is "title"
   LANGUAGE	: STRING is "language"
   AUTHOR_NAME	: STRING is "author_name"
   CONTENT	: STRING is "content"
   
end
