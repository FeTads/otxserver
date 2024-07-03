////////////////////////////////////////////////////////////////////////
// OpenTibia - an opensource roleplaying game
////////////////////////////////////////////////////////////////////////
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <http://www.gnu.org/licenses/>.
////////////////////////////////////////////////////////////////////////
#include "otpch.h"
#include <iostream>

#include <libxml/xmlmemory.h>
#include <libxml/parser.h>

#include "wings.h"
#include "tools.h"

void Wings::clear()
{
	for(WingsMap::iterator it = wingsMap.begin(); it != wingsMap.end(); ++it)
		delete it->second;

	wingsMap.clear();
}

bool Wings::reload()
{
	clear();
	return loadFromXml();
}

bool Wings::loadFromXml()
{
	xmlDocPtr doc = xmlParseFile(getFilePath(FILE_TYPE_XML, "wings.xml").c_str());
	if(!doc)
	{
		std::cout << "[Warning - Wings::loadFromXml] Cannot load wings file." << std::endl;
		std::cout << getLastXMLError() << std::endl;
		return false;
	}

	xmlNodePtr p, root = xmlDocGetRootElement(doc);
	if(xmlStrcmp(root->name,(const xmlChar*)"wings"))
	{
		std::cout << "[Error - Wings::loadFromXml] Malformed wings file." << std::endl;
		xmlFreeDoc(doc);
		return false;
	}

	p = root->children;
	while(p)
	{
		parseWingNode(p);
		p = p->next;
	}

	xmlFreeDoc(doc);
	return true;
}

bool Wings::parseWingNode(xmlNodePtr p)
{
	if(xmlStrcmp(p->name, (const xmlChar*)"wing"))
		return false;

	int32_t wingId;
	if(!readXMLInteger(p, "id", wingId))
	{
		std::cout << "[Warning - Wings::parseWingNode] Missing wing id." << std::endl;
		return false;
	}

    int32_t wingClientId;
	if(!readXMLInteger(p, "clientid", wingClientId))
	{
		std::cout << "[Warning - Wings::parseWingNode] Missing wing clientid." << std::endl;
		return false;
	}

	std::string wingName;
	if(!readXMLString(p, "name", wingName))
	{
		std::cout << "[Warning - Wings::parseWingNode] Missing wing name." << std::endl;
		return false;
	}

    Wing* wing = new Wing(wingId, wingClientId, wingName);
	wingsMap[wing->id] = wing;
	return true;
}

uint32_t Wings::getWingId(const std::string& name)
{
	for(WingsMap::iterator it = wingsMap.begin(); it != wingsMap.end(); ++it)
	{
		if(!strcasecmp(it->second->name.c_str(), name.c_str()))
			return it->first;
	}

	return -1;
}

Wing* Wings::getWing(uint32_t wingId) {
    WingsMap::iterator it = wingsMap.find(wingId);
    if (it == wingsMap.end())
        return NULL;

    return it->second;
}

Wing* Wings::getWingByType(uint32_t wingType) {
   	for(WingsMap::iterator it = wingsMap.begin(); it != wingsMap.end(); ++it)
	{
		if(it->second->clientId == wingType)
			return it->second;
	}

    return NULL;
}
