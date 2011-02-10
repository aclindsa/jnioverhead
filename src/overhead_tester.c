/***************************************************************************
 *   Copyright (C) 2011 Aaron Lindsay                                      *
 *   aaron.lindsay@vt.edu                                                  *
 *                                                                         *
 *   This program is free software; you can redistribute it and/or modify  *
 *   it under the terms of the GNU General Public License as published by  *
 *   the Free Software Foundation; either version 2 of the License, or     *
 *   (at your option) any later version.                                   *
 *                                                                         *
 *   This program is distributed in the hope that it will be useful,       *
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of        *
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the         *
 *   GNU General Public License for more details.                          *
 *                                                                         *
 *   You should have received a copy of the GNU General Public License     *
 *   along with this program; if not, write to the                         *
 *   Free Software Foundation, Inc.,                                       *
 *   51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.           *
 ***************************************************************************/

#include "jni_overhead.h"
#include <stdio.h>

#define NUM_CALLS 100000

int main() {
	int i;
	for (i=0; i < NUM_CALLS; i++) {
		jni_overhead_start();
		printf("%ld\n", jni_overhead_end());
	}
	return 0;
}
