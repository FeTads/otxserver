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

#ifndef __AURAS__
#define __AURAS__
#include "otsystem.h"

struct Aura
{
	Aura(uint32_t id, uint16_t clientId, std::string name)
		: name(name), clientId(clientId), id(id) {}

	std::string name;
	uint16_t clientId;
	uint32_t id;
};

typedef std::map<uint32_t, Aura*> AurasMap;
class Auras
{
	public:
		virtual ~Auras() {clear();}

		static Auras* getInstance()
		{
			static Auras instance;
			return &instance;
		}

		bool loadFromXml();
		bool parseAuraNode(xmlNodePtr p);

		void clear();
		bool reload();

        const AurasMap& getAuras() {return aurasMap;}
		Aura* getAura(uint32_t auraId);
		Aura* getAuraByType(uint32_t auraType);
		uint32_t getAuraId(const std::string& name);

		AurasMap::iterator getFirstGroup() {return aurasMap.begin();}
		AurasMap::iterator getLastGroup() {return aurasMap.end();}

	private:
		Auras() {}
		AurasMap aurasMap;
};
#endif
