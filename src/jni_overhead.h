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

#ifndef JNI_OVERHEAD_H
#define JNI_OVERHEAD_H

#include <stdint.h>
#include "rdtsc.h"

uint64_t start;

void jni_overhead_start() {
	start = rdtsc();
}

long jni_overhead_end() {
	//hopefully the time between these two calls won't be so horrendous we'll require more than a long to store it
	//Otherwise, we'll have to find some other way to communicate it back to Java, because Java doesn't natively do integer types greater than long
	return (long)rdtsc()-start;
}

#endif /* JNI_OVERHEAD_H */
