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

#include "shaders.h"
#include "tools.h"

void Shaders::clear()
{
	for(ShadersMap::iterator it = shadersMap.begin(); it != shadersMap.end(); ++it)
		delete it->second;

	shadersMap.clear();
}

bool Shaders::reload()
{
	clear();
	return loadFromXml();
}

bool Shaders::loadFromXml()
{
	xmlDocPtr doc = xmlParseFile(getFilePath(FILE_TYPE_XML, "shaders.xml").c_str());
	if(!doc)
	{
		std::cout << "[Warning - Shaders::loadFromXml] Cannot load shaders file." << std::endl;
		std::cout << getLastXMLError() << std::endl;
		return false;
	}

	xmlNodePtr p, root = xmlDocGetRootElement(doc);
	if(xmlStrcmp(root->name,(const xmlChar*)"shaders"))
	{
		std::cout << "[Error - Shaders::loadFromXml] Malformed shaders file." << std::endl;
		xmlFreeDoc(doc);
		return false;
	}

	p = root->children;
	while(p)
	{
		parseShaderNode(p);
		p = p->next;
	}

	xmlFreeDoc(doc);
	return true;
}

bool Shaders::parseShaderNode(xmlNodePtr p)
{
	if(xmlStrcmp(p->name, (const xmlChar*)"shader"))
		return false;

	int32_t shaderId;
	if(!readXMLInteger(p, "id", shaderId))
	{
		std::cout << "[Warning - Shaders::parseShaderNode] Missing shader id." << std::endl;
		return false;
	}

	std::string shaderName;
	if(!readXMLString(p, "name", shaderName))
	{
		std::cout << "[Warning - Shaders::parseShaderNode] Missing shader name." << std::endl;
		return false;
	}

    Shader* shader = new Shader(shaderId, shaderName);
	shadersMap[shader->id] = shader;
	return true;
}

uint32_t Shaders::getShaderId(const std::string& name)
{
	for(ShadersMap::iterator it = shadersMap.begin(); it != shadersMap.end(); ++it)
	{
		if(!strcasecmp(it->second->name.c_str(), name.c_str()))
			return it->first;
	}

	return -1;
}

Shader* Shaders::getShaderByName(const std::string& name) {
	for(ShadersMap::iterator it = shadersMap.begin(); it != shadersMap.end(); ++it)
	{
		if(!strcasecmp(it->second->name.c_str(), name.c_str()))
			return it->second;
	}

	return NULL;
}

Shader* Shaders::getShader(uint32_t shaderId) {
    ShadersMap::iterator it = shadersMap.find(shaderId);
    if (it == shadersMap.end())
        return NULL;

    return it->second;
}