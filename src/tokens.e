indexing

	description: "Parser token codes"
	generator: "geyacc version 3.2"

class TOKENS

inherit

	YY_PARSER_TOKENS


feature -- Access

	token_name (a_token: INTEGER): STRING is
			-- Name of token `a_token'
		do
			inspect a_token
			when 0 then
				Result := "EOF token"
			when -1 then
				Result := "Error token"
			when T_XML then
				Result := "T_XML"
			when T_HTML then
				Result := "T_HTML"
			when T_BIBTEX then
				Result := "T_BIBTEX"
			when T_INPUT then
				Result := "T_INPUT"
			when T_OUTPUT then
				Result := "T_OUTPUT"
			when T_PRIVATE then
				Result := "T_PRIVATE"
			when T_MODE then
				Result := "T_MODE"
			when T_REC then
				Result := "T_REC"
			when T_LATEX then
				Result := "T_LATEX"
			when T_TRUE then
				Result := "T_TRUE"
			when T_FALSE then
				Result := "T_FALSE"
			when T_EQUAL then
				Result := "T_EQUAL"
			when T_TEMPLATE then
				Result := "T_TEMPLATE"
			when T_HTTPDPATH then
				Result := "T_HTTPDPATH"
			when T_STRING then
				Result := "T_STRING"
			when T_INTEGER then
				Result := "T_INTEGER"
			else
				Result := yy_character_token_name (a_token)
			end
		end

feature -- Token codes

	T_XML: INTEGER is 258
	T_HTML: INTEGER is 259
	T_BIBTEX: INTEGER is 260
	T_INPUT: INTEGER is 261
	T_OUTPUT: INTEGER is 262
	T_PRIVATE: INTEGER is 263
	T_MODE: INTEGER is 264
	T_REC: INTEGER is 265
	T_LATEX: INTEGER is 266
	T_TRUE: INTEGER is 267
	T_FALSE: INTEGER is 268
	T_EQUAL: INTEGER is 269
	T_TEMPLATE: INTEGER is 270
	T_HTTPDPATH: INTEGER is 271
	T_STRING: INTEGER is 272
	T_INTEGER: INTEGER is 273

end
