## Copyright 2009 Laurent Bovet <laurent.bovet@windmaster.ch>
##                Jordi Puigsegur <jordi.puigsegur@gmail.com>
##
##  This file is part of wfrog
##
##  wfrog is free software: you can redistribute it and/or modify
##  it under the terms of the GNU General Public License as published by
##  the Free Software Foundation, either version 3 of the License, or
##  (at your option) any later version.
##
##  This program is distributed in the hope that it will be useful,
##  but WITHOUT ANY WARRANTY; without even the implied warranty of
##  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
##  GNU General Public License for more details.
##
##  You should have received a copy of the GNU General Public License
##  along with this program.  If not, see <http://www.gnu.org/licenses/>.

import wrapper
import logging
import time

class StopWatchElement(wrapper.ElementWrapper):

    measures = None

    logger = logging.getLogger("generic.stopwatch")

    target = None

    def _call(self, attr, *args, **keywords):

        if self.measures is None:
            self.measures = {}

        start = time.clock()
        result = self.target.__getattribute__(attr).__call__(*args, **keywords)
        duration = time.clock() - start

        if self.measures.has_key(attr):
            measure = self.measures.get(attr)
            measure = (duration, measure[1]+duration, measure[2]+1)
        else:
            measure = (duration, duration, 1)

        self.measures[attr] = measure

        self.logger.info(str(self.target)+"."+attr+": "+str(measure))

        return result