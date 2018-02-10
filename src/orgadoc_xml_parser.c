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

int
is_leaf(xmlNode * node)
{
  xmlNode * child = node->children;
  while(child)
    {
      if(child->type == XML_ELEMENT_NODE) return 0;	
      child = child->next;
    }
  return 1;
}

void
print_xml(xmlNode * node, int indent_len)
{
  while(node)
    {	
      if(node->type == XML_ELEMENT_NODE)
	{
	  	  printf("<tr>\n");
          printf("<td>%s</td><td>%s</td>\n",node->name,is_leaf(node)?xmlNodeGetContent(node):xmlGetProp(node, "id"));
          printf("</tr>\n");
        }
      print_xml(node->children, indent_len + 1);
      node = node->next;
    }
}

void
print_xml_bibtex(xmlNode * node, int indent_len)
{
  while(node)
    {	
      if(node->type == XML_ELEMENT_NODE)
	{
	  printf("%s=\"%s\"\n",node->name,is_leaf(node)?xmlNodeGetContent(node):xmlGetProp(node, "id"));
        }
      print_xml_bibtex(node->children, indent_len + 1);
      node = node->next;
    }
}

void
print_xml_latex(xmlNode * node, int indent_len)
{
  while(node)
    {	
      if(node->type == XML_ELEMENT_NODE)
	{
	  printf("\\%s{%s}\n",node->name,is_leaf(node)?xmlNodeGetContent(node):xmlGetProp(node, "id"));
        }
      print_xml_latex(node->children, indent_len + 1);
      node = node->next;
    }
}

void
print_xml_json(xmlNode * node, int indent_len)
{
  while(node)
    {	
      if(node->type == XML_ELEMENT_NODE)
	{
	  printf("    \"%s\": \"%s\",\n",node->name,is_leaf(node)?xmlNodeGetContent(node):xmlGetProp(node, "id"));
        }
      print_xml_json(node->children, indent_len + 1);
      node = node->next;
    }
}

void
print_xml_text(xmlNode * node, int indent_len)
{
  while(node)
   {
     if(node->type == XML_ELEMENT_NODE)
       {
         printf("%s: %s\n",node->name,is_leaf(node)?xmlNodeGetContent(node):xmlGetProp(node, "id"));
       }
     print_xml_text(node->children, indent_len + 1);
     node = node->next;
   }
}
