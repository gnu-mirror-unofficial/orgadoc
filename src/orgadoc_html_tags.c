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

void
orgadoc_html_table_start_tags()
{
  printf("<table border=\"1\">\n");
  printf("<thead>\n<tr>\n<th>Section</th>\n<th>Content</th>\n</tr>\n</thead>\n");
  printf("<tbody>\n");
}

void
orgadoc_html_table_end_tags()
{
  printf("</tbody>\n");
  printf("</table>\n");
}

void
orgadoc_html_start_tags()
{
  printf("<!DOCTYPE HTML>\n");
  printf("<title>HTML Document Listing</title>\n");
  printf("<body>\n");
}

void
orgadoc_html_end_tags()
{
  printf("</body>\n");
  printf("<footer>");
  printf("%s %s",FOOTER,VERSION);
  printf("</footer>\n");
  printf("</html>\n");
}
