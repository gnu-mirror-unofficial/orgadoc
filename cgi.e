indexing
   description: "cgi for web search"
   author: "Julien Lemoine <speedblue@morpheus>"
	--| $Id: cgi.e,v 1.1 2003/10/16 20:20:22 speedblue Exp $
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
	process(query : STRING) is
		local
			tglobal : TEMPLATE
			index	  : INTEGER
			prog	  : ORGADOC
			res     : STRING
		do
			index := query.first_substring_index(CQUERY)
			if (index > 0) then
				!!tglobal.make(TEMPL_PATH + CTGLOBAL);
				is_writeable := tglobal.start
				!!prog.make_cgi(query.substring(1 + CQUERY.count,
														  query.count - index));
				res := prog.get_res
				tglobal.replace(DOCUMENTS, "<pre>" + res + "</pre>")
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

