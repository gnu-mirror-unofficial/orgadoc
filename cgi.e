indexing
   description: "cgi for web search"
   author: "Julien Lemoine <speedblue@morpheus>"
	--| $Id: cgi.e,v 1.5 2003/10/17 10:39:40 speedblue Exp $
	--| 
	--| Copyright (C) 2003 Julien Lemoine
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

class CGI     
creation
   make
feature {ANY}
   make is
		local
			sys	 : SYSTEM
			query	 : STRING
      do
			!!params.make
			query := sys.get_environment_variable("QUERY_STRING");
			if (query /= void) then
				process(query);
			else
				error("Error : no query");
			end
      end

feature{CGI}
	process(q : STRING) is
		local
			tglobal : TEMPLATE
			index	  : INTEGER
			prog	  : ORGADOC
			res     : STRING
			query   : STRING
		do
			index := q.first_substring_index(CQUERY)
			if (index > 0) then
				query := q.substring(1 + CQUERY.count, q.count - index + 1)
				query := replace(query, "+", " ")
				query := replace(query, "%%3F", "?")
				query := replace(query, "%%5B", "[")
				query := replace(query, "%%5D", "]")
				query := replace(query, "%%2B", "+")
				query := replace(query, "%%5B", "{")
				query := replace(query, "%%2D", "}")
				query := replace(query, "%%5E", "^")
				query := replace(query, "%%24", "$")
				query := replace(query, "%%28", "(")
				query := replace(query, "%%29", ")")
				query := replace(query, "%%3D", "=")
				query := replace(query, "%%7C", "|")
				query := replace(query, "%%5C", "\")
				query := replace(query, "%%2F", "/")
				!!prog.make_cgi(query);
				res := prog.get_res
				!!tglobal.make(TEMPL_PATH + CTGLOBAL);
				is_writeable := tglobal.start
				tglobal.replace(DOCUMENTS, res)
				tglobal.replace(VERSION, params.get_version)
				print(tglobal.stop)
			else
				error("Invalid Query : [" + query + "]");
			end
		end

	error(msg : STRING) is
		local
			tglobal : TEMPLATE
		do
			!!tglobal.make(TEMPL_PATH + CTGLOBAL);
			is_writeable := tglobal.start
			tglobal.replace(DOCUMENTS, "<h2><font color=#FF0000>"
								 + msg + "</font></h2>")
			tglobal.replace(VERSION, params.get_version)
			print(tglobal.stop)
		end

	replace(str, src, dst : STRING) : STRING is
		require
			str /= void
			src /= void
			dst /= void
		local
			index : INTEGER
		do
			from index := str.first_substring_index(src) until index <= 0 loop
				str.replace_substring(dst, index,
											 index + src.count - 1)
				index := str.first_substring_index(src)
			end
			Result := str
		end
	
feature{CGI}
	params		 :	PARAMS
	is_writeable : BOOLEAN
	
feature{NONE}
	-- Template files
	CQUERY		 : STRING is "query="
   VERSION		 : STRING is "%%%%VERSION%%"
	DOCUMENTS	 : STRING is "%%%%DOCUMENTS%%"
	TEMPL_PATH	 : STRING is "/etc/orgadoc/templates"
	CTGLOBAL		 : STRING is "/cgi/global.tpl"

end

