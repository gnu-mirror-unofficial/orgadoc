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
orgadoc_latex_start_tags()
{
  printf("\\documentclass[10pt]{article}\n");
  printf("\\title{\\bfseries\\Document-Listing}\n");
  printf("\\author{someone@email}\n");
  printf("\\date{}\n");
  printf("\\begin{document}\n");
  printf("\\maketitle\n");
  printf("\\bgroup{obeylines}\n");
}
void
orgadoc_latex_end_tags()
{
  printf("\n%s %s\n",FOOTER,VERSION);
  printf("\\end{document}\n");
}
