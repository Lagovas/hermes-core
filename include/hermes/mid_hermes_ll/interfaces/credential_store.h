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



#ifndef HERMES_CREDENTIAL_STORE_H
#define HERMES_CREDENTIAL_STORE_H

#include <hermes/common/errors.h>

#include <stdint.h>
#include <stdlib.h>

typedef struct hermes_credential_store_type hermes_credential_store_t;
hermes_status_t hermes_credential_store_get_public_key(
        hermes_credential_store_t *credential_store,
        const uint8_t *user_id, size_t user_id_length,
        uint8_t **public_key, size_t *public_key_length);

hermes_status_t hermes_credential_store_destroy(hermes_credential_store_t **credential_store);

#endif //HERMES_CREDENTIAL_STORE_H

