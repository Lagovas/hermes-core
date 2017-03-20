/*
 * Copyright (c) 2016 Cossack Labs Limited
 *
 * This file is part of Hermes.
 *
 * Hermes is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Affero General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * Hermes is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Affero General Public License for more details.
 *
 * You should have received a copy of the GNU Affero General Public License
 * along with Hermes.  If not, see <http://www.gnu.org/licenses/>.
 *
 */

#ifndef HERMES_ERRORS_H_
#define HERMES_ERRORS_H_

#define HM_SUCCESS 0
#define HM_ERROR 0x000f0000
#define HM_FAIL (HM_ERROR|1)
#define HM_INVALID_PARAMETER (HM_ERROR|2)
#define HM_BUFFER_TOO_SMALL (HM_ERROR|3)
#define HM_BAD_ALLOC (HM_ERROR|4)
#define HM_NOT_IMPLEMENTED (HM_ERROR|0x8000)

#ifdef DEBUG
#define DEBUGINFO(level, msg) {}while(false)
#else
#define DEBUGINFO(level, msg) {}while(false)
#endif

#endif /* HERMES_ERRORS_H_ */
