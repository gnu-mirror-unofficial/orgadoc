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

#include <stdio.h>
#include <stdlib.h>
#include <getopt.h>
#include <string.h>
#include <libxml/parser.h>

#include "orgadoc_version.h"
#include "orgadoc_help.h"
#include "orgadoc_argparse.h"
#include "orgadoc_html_tags.h"
#include "orgadoc_bibtex_tags.h"
#include "orgadoc_json_tags.h"
#include "orgadoc_latex_tags.h"
#include "orgadoc_text_tags.h"
#include "orgadoc_xml_parser.h"
#include "orgadoc_search.h"

#ifndef MAIN_H_
#define MAIN_H_

#define COPYRIGHT "Copyright (C) 2017-2019 Adam Bilbrough"
#define VERSION   "1.2"
#define FOOTER    "Generated by GNU OrgaDoc"
#define FILE_BUFSIZ 256

int html;
int bibtex;
int latex;
int json;
int text;

char BUFFER[FILE_BUFSIZ];
size_t nread;

typedef struct s_options
{
  char s;
} options;

enum options_e
  {
    opt_help            = 'h',
    opt_version         = 'v',
    opt_generate_html   = 't',
    opt_generate_bibtex = 'b',
    opt_generate_latex  = 'l',
    opt_generate_json   = 'j',
    opt_generate_text   = 'p',
    opt_search_file     = 's'
  };

#endif /* !MAIN_H_ */
