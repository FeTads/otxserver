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

#include "auras.h"
#include "tools.h"

void Auras::clear()
{
	for(AurasMap::iterator it = aurasMap.begin(); it != aurasMap.end(); ++it)
		delete it->second;

	aurasMap.clear();
}

bool Auras::reload()
{
	clear();
	return loadFromXml();
}

bool Auras::loadFromXml()
{
	xmlDocPtr doc = xmlParseFile(getFilePath(FILE_TYPE_XML, "auras.xml").c_str());
	if(!doc)
	{
		std::cout << "[Warning - Auras::loadFromXml] Cannot load auras file." << std::endl;
		std::cout << getLastXMLError() << std::endl;
		return false;
	}

	xmlNodePtr p, root = xmlDocGetRootElement(doc);
	if(xmlStrcmp(root->name,(const xmlChar*)"auras"))
	{
		std::cout << "[Error - Auras::loadFromXml] Malformed auras file." << std::endl;
		xmlFreeDoc(doc);
		return false;
	}

	p = root->children;
	while(p)
	{
		parseAuraNode(p);
		p = p->next;
	}

	xmlFreeDoc(doc);
	return true;
}

bool Auras::parseAuraNode(xmlNodePtr p)
{
	if(xmlStrcmp(p->name, (const xmlChar*)"aura"))
		return false;

	int32_t auraId;
	if(!readXMLInteger(p, "id", auraId))
	{
		std::cout << "[Warning - Auras::parseAuraNode] Missing aura id." << std::endl;
		return false;
	}

    int32_t auraClientId;
	if(!readXMLInteger(p, "clientid", auraClientId))
	{
		std::cout << "[Warning - Auras::parseAuraNode] Missing aura clientid." << std::endl;
		return false;
	}

	std::string auraName;

	if(!readXMLString(p, "name", auraName))
	{
		std::cout << "[Warning - Auras::parseAuraNode] Missing aura name." << std::endl;
		return false;
	}

    Aura* aura = new Aura(auraId, auraClientId, auraName);
	aurasMap[aura->id] = aura;
	return true;
}

uint32_t Auras::getAuraId(const std::string& name)
{
	for(AurasMap::iterator it = aurasMap.begin(); it != aurasMap.end(); ++it)
	{
		if(!strcasecmp(it->second->name.c_str(), name.c_str()))
			return it->first;
	}

	return -1;
}

Aura* Auras::getAura(uint32_t auraId) {
    AurasMap::iterator it = aurasMap.find(auraId);
    if (it == aurasMap.end())
        return NULL;

    return it->second;
}

Aura* Auras::getAuraByType(uint32_t auraType) {
   	for(AurasMap::iterator it = aurasMap.begin(); it != aurasMap.end(); ++it)
	{
		if(it->second->clientId == auraType)
			return it->second;
	}

    return NULL;
}
