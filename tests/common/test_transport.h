/*
* Copyright (c) 2017 Cossack Labs Limited
*
* This file is a part of Hermes-core.
*
* Hermes-core is free software: you can redistribute it and/or modify
* it under the terms of the GNU Affero General Public License as published by
* the Free Software Foundation, either version 3 of the License, or
* (at your option) any later version.
*
* Hermes-core is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
* GNU Affero General Public License for more details.
*
* You should have received a copy of the GNU Affero General Public License
* along with Hermes-core.  If not, see <http://www.gnu.org/licenses/>.
*
*/



#ifndef HERMES_TEST_TRANSPORT_H
#define HERMES_TEST_TRANSPORT_H

#include <hermes/rpc/transport.h>

#include <stdbool.h>

hm_rpc_transport_t* hm_test_transport_create(const char* write_pipe_name, const char* read_pipe_name, bool is_server);
uint32_t hm_test_transport_destroy(hm_rpc_transport_t* t);

#endif //HERMES_TEST_TRANSPORT_H
