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

#ifndef __SHADERS__
#define __SHADERS__
#include "otsystem.h"

struct Shader
{
	Shader(uint32_t id, std::string name)
		: name(name), id(id) {}

	std::string name;
	uint32_t id;
};

typedef std::map<uint32_t, Shader*> ShadersMap;
class Shaders
{
	public:
		virtual ~Shaders() {clear();}

		static Shaders* getInstance()
		{
			static Shaders instance;
			return &instance;
		}

		bool loadFromXml();
		bool parseShaderNode(xmlNodePtr p);

		void clear();
		bool reload();

        const ShadersMap& getShaders() {return shadersMap;}
		Shader* getShader(uint32_t shaderId);
		Shader* getShaderByName(const std::string& name);
		uint32_t getShaderId(const std::string& name);

		ShadersMap::iterator getFirstGroup() {return shadersMap.begin();}
		ShadersMap::iterator getLastGroup() {return shadersMap.end();}

	private:
		Shaders() {}
		ShadersMap shadersMap;
};
#endif
