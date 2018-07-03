/*
    GNU OrgaDoc - organizes and converts your XML document pool.
    Copyright (C) 2017 - 2018 Adam Bilbrough

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <https://www.gnu.org/licenses/>.
*/

#include "main.h"

static struct option const long_options[] =
{
  {"help",   0,0,   opt_help},
  {"version",0,0,   opt_version},
  {"html",   0,0,   opt_generate_html},
  {"bibtex", 0,0,   opt_generate_bibtex},
  {"latex",  0,0,   opt_generate_latex},
  {"json",   0,0,   opt_generate_json},
  {"text",   0,0,   opt_generate_text},
  {NULL,     0,NULL,0}
};
static const char short_options[] = "hvtbljp";

void
parse_args(int argc, char** argv)
{
  int c;
  
  char *readme = argv[2];

  while ((c = getopt_long (argc, argv, short_options,
                           long_options, NULL)) != -1)
    {
      switch(c)
	{
	case opt_help:
	  help();
	  exit(0);
	break;

	case opt_version:
	  version();
	  exit(0);
	break;

	case opt_generate_html:
	  html = 1;
	  orgadoc_html_start_tags();
	  orgadoc_xml_parser(readme);
	  orgadoc_html_end_tags();
	  exit(0);

	case opt_generate_bibtex:
	  bibtex = 1;
	  orgadoc_bibtex_start_tags();
	  orgadoc_xml_parser(readme);
	  orgadoc_bibtex_end_tags();
	  exit(0);

	case opt_generate_latex:
	  latex = 1;
	  orgadoc_latex_start_tags();
	  orgadoc_xml_parser(readme);
	  orgadoc_latex_end_tags();
	  exit(0);

	case opt_generate_json:
	  json = 1;
	  orgadoc_json_start_tags();
	  orgadoc_xml_parser(readme);
	  orgadoc_json_end_tags();
	  exit(0);

    case opt_generate_text:
      text = 1;
	  orgadoc_text_start_tags();
	  orgadoc_xml_parser(readme);
	  orgadoc_text_end_tags();
	  exit(0);

	default:
	  help();
	  exit(1);
	}
    }
}
