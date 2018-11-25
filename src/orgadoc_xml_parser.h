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

int is_leaf(xmlNode *);
void print_xml(xmlNode *, int);
void orgadoc_xml_parser(char *);
