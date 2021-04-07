/*
    GNU OrgaDoc - organizes and converts your XML document pool.
    Copyright (C) 2017 - 2019 Adam Bilbrough

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
orgadoc_search(char *file)
{
  FILE *f;

  printf("\nDisplaying contents of %s\n\n",file);
  f = fopen(file, "r");
  if (f == NULL)
    {
      fprintf(stderr,"ERROR: %s does not exist or cannot be opened! \n",file);
      exit(1);
    }
  if (f)
    {
      while((nread = fread(BUFFER,1,sizeof BUFFER,f)) > 0)
	fwrite(BUFFER,1,nread,stdout);
    }
  fclose(f);
}

