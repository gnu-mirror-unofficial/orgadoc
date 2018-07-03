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
orgadoc_xml_printer(xmlDocPtr doc, xmlNodePtr cur)
{
  xmlChar *key;
  
  cur = cur->xmlChildrenNode;
  while (NULL != cur) {
    if ((!xmlStrcmp(cur->name, (const xmlChar *)"title"))) {
      key = xmlNodeListGetString(doc, cur->xmlChildrenNode, 1);
      if(html == 1)
      {
      	orgadoc_html_table_start_tags();
        printf("<tr>\n");
      	printf("<td>Title</td><td>%s</td>\n", key);
      	printf("</tr>\n");
      	xmlFree(key);
      }
      if(bibtex == 1)
      {
      	printf("Title=\"%s\"\n", key);
      	xmlFree(key);
      }
      if(latex == 1)
      {
      	printf("\\textbf{Title} \"%s\"\\\\\n", key);
      	xmlFree(key);
      }
      if(json == 1)
      {
      	printf("    \"Title\" : \"%s\"\n", key);
      	xmlFree(key);
      }
      if(text == 1)
      {
      	printf("Title: %s\n", key);
      	xmlFree(key);
      }
    }
    if ((!xmlStrcmp(cur->name, (const xmlChar *)"file"))) {
      key = xmlNodeListGetString(doc, cur->xmlChildrenNode, 1);
      if(html == 1)
      {
      	printf("<tr>\n");
      	printf("<td>Filename</td><td>%s</td>\n", key);
      	printf("</tr>\n");
      	xmlFree(key);
      }
      if(bibtex == 1)
      {
      	printf("Filename=\"%s\"\n", key);
      	xmlFree(key);
      }
      if(latex == 1)
      {
      	printf("\\textbf{Filename} \"%s\"\\\\\n", key);
      	xmlFree(key);
      }
      if(json == 1)
      {
      	printf("    \"Filename\" : \"%s\"\n", key);
      	xmlFree(key);
      }
      if(text == 1)
      {
      	printf("Filename: %s\n", key);
      	xmlFree(key);
      }
    }
    if ((!xmlStrcmp(cur->name, (const xmlChar *)"date"))) {
      key = xmlNodeListGetString(doc, cur->xmlChildrenNode, 1);
      if(html == 1)
      {
      	printf("<tr>\n");
      	printf("<td>Date/Time</td><td>%s</td>\n", key);
      	printf("</tr>\n");
      	xmlFree(key);
      }
      if(bibtex == 1)
      {
      	printf("Date-Time=\"%s\"\n", key);
      	xmlFree(key);
      }
      if(latex == 1)
      {
      	printf("\\textbf{Date-Time} \"%s\"\\\\\n", key);
      	xmlFree(key);
      }
      if(json == 1)
      {
      	printf("    \"Date-Time\" : \"%s\"\n", key);
      	xmlFree(key);
      }
      if(text == 1)
      {
      	printf("Date/Time: %s\n", key);
      	xmlFree(key);
      }
    }
    if ((!xmlStrcmp(cur->name, (const xmlChar *)"type"))) {
      key = xmlNodeListGetString(doc, cur->xmlChildrenNode, 1);
      if(html == 1)
      {
      	printf("<tr>\n");
      	printf("<td>Type</td><td>%s</td>\n", key);
      	printf("</tr>\n");
      	xmlFree(key);
      }
      if(bibtex == 1)
      {
      	printf("Type=\"%s\"\n", key);
      	xmlFree(key);
      }
      if(latex == 1)
      {
      	printf("\\textbf{Type} \"%s\"\\\\\n", key);
      	xmlFree(key);
      }
      if(json == 1)
      {
      	printf("    \"Type\" : \"%s\"\n", key);
      	xmlFree(key);
      }
      if(text == 1)
      {
      	printf("Type: %s\n", key);
      	xmlFree(key);
      }
    }
    if ((!xmlStrcmp(cur->name, (const xmlChar *)"author"))) {
      key = xmlNodeListGetString(doc, cur->xmlChildrenNode, 1);
      if(html == 1)
      {
      	printf("<tr>\n");
      	printf("<td>Author</td><td>%s</td>\n", key);
      	printf("</tr>\n");
      	xmlFree(key);
      }
      if(bibtex == 1)
      {
      	printf("Author=\"%s\"\n", key);
      	xmlFree(key);
      }
      if(latex == 1)
      {
      	printf("\\textbf{Author} \"%s\"\\\\\n", key);
      	xmlFree(key);
      }
      if(json == 1)
      {
      	printf("    \"Author\" : \"%s\"\n", key);
      	xmlFree(key);
      }
      if(text == 1)
      {
      	printf("Author: %s\n", key);
      	xmlFree(key);
      }
    }
    if ((!xmlStrcmp(cur->name, (const xmlChar *)"nbpages"))) {
      key = xmlNodeListGetString(doc, cur->xmlChildrenNode, 1);
      if(html == 1)
      {
      	printf("<tr>\n");
      	printf("<td>Number of Pages</td><td>%s</td>\n", key);
      	printf("</tr>\n");
      	xmlFree(key);
      }
      if(bibtex == 1)
      {
      	printf("Number-of-Pages=%s\n", key);
      	xmlFree(key);
      }
      if(latex == 1)
      {
      	printf("\\textbf{Number-of-Pages} %s\\\\\n", key);
      	xmlFree(key);
      }
      if(json == 1)
      {
      	printf("    \"Number-of-Pages\" : %s\n", key);
      	xmlFree(key);
      }
      if(text == 1)
      {
      	printf("Number of Pages: %s\n", key);
      	xmlFree(key);
      }
    }
    if ((!xmlStrcmp(cur->name, (const xmlChar *)"language"))) {
      key = xmlNodeListGetString(doc, cur->xmlChildrenNode, 1);
      if(html == 1)
      {
      	printf("<tr>\n");
      	printf("<td>Document Language</td><td>%s</td>\n", key);
      	printf("</tr>\n");
      	xmlFree(key);
      }
      if(bibtex == 1)
      {
      	printf("Document-Language=\"%s\"\n", key);
      	xmlFree(key);
      }
      if(latex == 1)
      {
      	printf("\\textbf{Document-Language} \"%s\"\\\\\n", key);
      	xmlFree(key);
      }
      if(json == 1)
      {
      	printf("    \"Document-language\" : \"%s\"\n", key);
      	xmlFree(key);
      }
      if(text == 1)
      {
      	printf("Document Language: %s\n", key);
      	xmlFree(key);
      }
    }
    if ((!xmlStrcmp(cur->name, (const xmlChar *)"summary"))) {
      key = xmlNodeListGetString(doc, cur->xmlChildrenNode, 1);
      if(html == 1)
      {
      	printf("<tr>\n");
      	printf("<td>Summary</td><td>%s</td>\n", key);
      	printf("</tr>\n");
      	xmlFree(key);
      }
      if(bibtex == 1)
      {
      	printf("Summary=\"%s\"\n", key);
      	xmlFree(key);
      }
      if(latex == 1)
      {
      	printf("\\textbf{Summary} \"%s\"\\\\\n", key);
      	xmlFree(key);
      }
      if(json == 1)
      {
      	printf("    \"Summary\" : \"%s\"\n", key);
      	xmlFree(key);
      }
      if(text == 1)
      {
      	printf("Summary: %s\n", key);
      	xmlFree(key);
      }
    }
    if ((!xmlStrcmp(cur->name, (const xmlChar *)"part"))) {
      key = xmlNodeListGetString(doc, cur->xmlChildrenNode, 1);
      if(html == 1)
      {
      	printf("<tr>\n");
      	printf("<td>Chapter(s)</td><td>%s</td>\n", key);
      	printf("</tr>\n");
      	xmlFree(key);
      }
      if(bibtex == 1)
      {
      	printf("Chapter(s)=\"%s\"\n", key);
      	xmlFree(key);
      }
      if(latex == 1)
      {
      	printf("\\textbf{Chapter(s)} \"%s\"\\\\\n", key);
      	xmlFree(key);
      }
      if(json == 1)
      {
      	printf("    \"Chapter\" : \"%s\"\n", key);
      	xmlFree(key);
      }
      if(text == 1)
      {
      	printf("Chapter(s): %s\n", key);
      	xmlFree(key);
      }
    }
    if ((!xmlStrcmp(cur->name, (const xmlChar *)"notes"))) {
      key = xmlNodeListGetString(doc, cur->xmlChildrenNode, 1);
      if(html == 1)
      {
      	printf("<tr>\n");
      	printf("<td>Notes/Comments</td><td>%s</td>\n", key);
      	printf("</tr>\n");
      	orgadoc_html_table_end_tags();
      	xmlFree(key);
      }
      if(bibtex == 1)
      {
      	printf("Notes-or-Comments=\"%s\"\n", key);
      	printf("\n");
      	xmlFree(key);
      }
      if(latex == 1)
      {
      	printf("\\textbf{Notes-or-Comments} \"%s\"\\\\\n", key);
      	printf("\\\\\n");
      	xmlFree(key);
      }
      if(json == 1)
      {
      	printf("    \"Notes\" : \"%s\"\n", key);
      	printf("\n");
      	xmlFree(key);
      }
      if(text == 1)
      {
      	printf("Notes/Comments: %s\n", key);
      	printf("\n");
      	xmlFree(key);
      }
    }
    cur = cur->next;
  }
  return;
}

void
orgadoc_xml_parser(char *readme)
{
  xmlDocPtr doc = NULL;
  xmlNodePtr cur = NULL;

  doc = xmlParseFile(readme);
  if (NULL == doc) {
    fprintf(stderr, "Document cannot be parsed!\n");
    return;
  }
  cur = xmlDocGetRootElement(doc);
  if (NULL == cur) {
    fprintf(stderr, "Empty document or is less than 1 byte!\n");
    xmlFreeDoc(doc);
    return;
  }
  if (xmlStrcmp(cur->name, (const xmlChar *)"readme")) {
    fprintf(stderr, "Root node is of incorrect type!\n");
    xmlFreeDoc(doc);
  }
  cur = cur->xmlChildrenNode;
  while (NULL != cur) {
    if ((!xmlStrcmp(cur->name, (const xmlChar *)"document"))) {
      orgadoc_xml_printer(doc, cur);
    }
    cur = cur->next;
  }
  xmlFreeDoc(doc);
  return;
}
