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

#ifndef __WINGS__
#define __WINGS__
#include "otsystem.h"

struct Wing
{
	Wing(uint32_t id, uint16_t clientId, std::string name)
		: name(name), clientId(clientId), id(id) {}

	std::string name;
	uint16_t clientId;
	uint32_t id;
};

typedef std::map<uint32_t, Wing*> WingsMap;
class Wings
{
	public:
		virtual ~Wings() {clear();}

		static Wings* getInstance()
		{
			static Wings instance;
			return &instance;
		}

		bool loadFromXml();
		bool parseWingNode(xmlNodePtr p);

		void clear();
		bool reload();

        const WingsMap& getWings() {return wingsMap;}
		Wing* getWing(uint32_t wingId);
		Wing* getWingByType(uint32_t wingType);
		uint32_t getWingId(const std::string& name);

		WingsMap::iterator getFirstGroup() {return wingsMap.begin();}
		WingsMap::iterator getLastGroup() {return wingsMap.end();}

	private:
		Wings() {}
		WingsMap wingsMap;
};
#endif
