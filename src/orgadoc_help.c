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
help(void)
{
  printf("GNU OrgaDoc Copyright (C) 2017 - 2019  Adam Bilbrough\n");
  printf("This program comes with ABSOLUTELY NO WARRANTY;\n");
  printf("\nThis is free software, and you are welcome to redistribute it\n");
  printf("under certain conditions;  for details visit <https://www.gnu.org/licenses/>.\n");
  printf("\nUsage: orgadoc [Options] [File]\n");
  printf("Options:\n");
  printf("  -h, --help\t\tdisplay this help and exit\n");
  printf("  -v, --version\t\toutput version information and exit\n\n");
  printf("  -t, --html\t\tGenerate HTML output\n");
  printf("  -b, --bibtex\t\tGenerate BIBTEX output\n\n");
  printf("  -l, --latex\t\tGenerate LATEX output\n");
  printf("  -j, --json\t\tGenerate JSON output\n\n");
  printf("  -p, --text\t\tGenerate PLAIN TEXT output\n\n");
  printf("  -s, --search\t\tDisplays contents of readme.xml onto the terminal\n\n");
}
