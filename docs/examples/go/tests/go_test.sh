#! /bin/sh
#
# Copyright (c) 2017 Cossack Labs Limited
#
# This file is a part of Hermes-core.
#
# Hermes-core is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# Hermes-core is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with Hermes-core.  If not, see <http://www.gnu.org/licenses/>.
#
#

# before running these script run credential/key/data stores from docs/examples/c/mid_hermes/*
# and update paths in this script to yours

TEST_FILE=/tmp/testfile
echo "some content" > $TEST_FILE
USER_ID=user1
# keypair of user 1
PRIVATE_KEY=UkVDMgAAAC0Tj5tGAPfpgfYMBACxX6onvlWvcc2Gb9ZylBlJdjebTpV3OCIx
PUBLIC_KEY=VUVDMgAAAC2ISqIZApjrN6BCVmWoJdbhjN2EmBAfLq3VKEdRnz0gVdYcIDQp

USER_ID2=user2
# keypair of user 2
PRIVATE_KEY2=UkVDMgAAAC00lzw7ABmvKHvjOqWW8i+dxwHTU8RzuaATkZNBcLmCm8TBxRn2
PUBLIC_KEY2=VUVDMgAAAC0lAFeZAqw+nKzco1l2qtXELqVr7fmpsMf4hSrOa/TkAu5OQ6Cy

# path to dir where are compiled client binary
BIN=.
SUCCESS=0
FAIL=1
DB_DIR=db/credential_store
KEYSTORE_PUBLIC=VUVDMgAAAC3QMLOAAoms9u5nTh1Ir3AnTPt5RkMJY9leIfF6uMIxms/Bkywp
DATASTORE_PUBLIC=VUVDMgAAAC0VCQ/fAt88d2N8vDFVAKbDJHsXew8HgB55PIrVfhELXrEf1N89
CONFIG_PATH=docs/examples/go/config.conf

echo -n "$PUBLIC_KEY" | base64 --decode > $DB_DIR/`echo -n $USER_ID|base64`
echo -n "$PUBLIC_KEY2" | base64 --decode > $DB_DIR/`echo -n $USER_ID2|base64`
echo -n $KEYSTORE_PUBLIC | base64 --decode > $DB_DIR/`echo -n "key_store_server" | base64`
echo -n $DATASTORE_PUBLIC | base64 --decode > $DB_DIR/`echo -n "data_store_server" | base64`

# add block
echo "add block"
$BIN/hermes_client -command=add_block -id=$USER_ID -private_key=$PRIVATE_KEY -config=$CONFIG_PATH -doc $TEST_FILE  -meta="some meta data" 1>/dev/null
if [ ! $? -eq $SUCCESS ]; then
    exit 1
fi

# read block
echo "read block"
$BIN/hermes_client -command=read_block -id=$USER_ID -private_key=$PRIVATE_KEY -config=$CONFIG_PATH -doc $TEST_FILE  1>/dev/null
if [ ! $? -eq $SUCCESS ]; then
    exit 1
fi

# update block
echo "update block"
echo "some new content" > $TEST_FILE
$BIN/hermes_client -command=update_block -id=$USER_ID -private_key=$PRIVATE_KEY -config=$CONFIG_PATH -doc $TEST_FILE  -meta="new metadata" 1>/dev/null
if [ ! $? -eq $SUCCESS ]; then
    exit 1
fi

# rotate block
echo "rotate block"
md5sum db/data_store/`echo -n ${TEST_FILE}|base64`/data > ${TEST_FILE}.1.md5
$BIN/hermes_client -command=rotate_block -id=$USER_ID -private_key=$PRIVATE_KEY -config=$CONFIG_PATH -doc $TEST_FILE 1>/dev/null
if [ ! $? -eq $SUCCESS ]; then
    exit 1
fi

md5sum db/data_store/`echo -n ${TEST_FILE}|base64`/data > ${TEST_FILE}.2.md5

diff ${TEST_FILE}.1.md5 ${TEST_FILE}.2.md5 > /dev/null
diff_result=$?
rm ${TEST_FILE}.1.md5 ${TEST_FILE}.2.md5

# check that md5 of data before rotate != md5 of data after rotate
# result == 1 if not equal
if [ ! $diff_result -eq 1 ]; then
    echo "md5 hash sum not different"
    exit 1
fi

# read by user 2
echo "read by user 2"
$BIN/hermes_client -command=read_block -id=$USER_ID2 -private_key=$PRIVATE_KEY2 -config=$CONFIG_PATH -doc $TEST_FILE  1>/dev/null
if [ $? -eq $SUCCESS ]; then
    exit 1
fi


# grant access
echo "grant read access"
$BIN/hermes_client -command=grant_read_access -id=$USER_ID -private_key=$PRIVATE_KEY -config=$CONFIG_PATH -doc $TEST_FILE -for_user=$USER_ID2 1>/dev/null
if [ ! $? -eq $SUCCESS ]; then
    exit 1
fi

# read by user 2
echo "read by user 2"
$BIN/hermes_client -command=read_block -id=$USER_ID2 -private_key=$PRIVATE_KEY2 -config=$CONFIG_PATH -doc $TEST_FILE  1>/dev/null
if [ ! $? -eq $SUCCESS ]; then
    exit 1
fi

# update block
echo "update block by user 2"
echo "some new content by user2" > $TEST_FILE
$BIN/hermes_client -command=update_block -id=$USER_ID2 -private_key=$PRIVATE_KEY2 -config=$CONFIG_PATH -doc $TEST_FILE  -meta="some metadata" 1>/dev/null
if [ $? -eq $SUCCESS ]; then
    exit 1
fi


echo "grant update"
# grant update to user 2
$BIN/hermes_client -command=grant_update_access -id=$USER_ID -private_key=$PRIVATE_KEY -config=$CONFIG_PATH -doc $TEST_FILE -for_user=$USER_ID2 1>/dev/null
if [ ! $? -eq $SUCCESS ]; then
    exit 1
fi

# update block
echo "update block by user 2"
echo "some new content by user2" > $TEST_FILE
$BIN/hermes_client -command=update_block -id=$USER_ID2 -private_key=$PRIVATE_KEY2 -config=$CONFIG_PATH -doc $TEST_FILE  -meta="new metadata" 1>/dev/null
if [ ! $? -eq $SUCCESS ]; then
    exit 1
fi


# revoke update from user 2
echo "revoke update"
$BIN/hermes_client -command=revoke_update_access -id=$USER_ID -private_key=$PRIVATE_KEY -config=$CONFIG_PATH -doc $TEST_FILE -for_user=$USER_ID2 1>/dev/null
if [ ! $? -eq $SUCCESS ]; then
    exit 1
fi

# update block
echo "update block by user 2"
echo "some new content by user2" > $TEST_FILE
$BIN/hermes_client -command=update_block -id=$USER_ID2 -private_key=$PRIVATE_KEY2 -config=$CONFIG_PATH -doc $TEST_FILE  -meta="new metadata" 1>/dev/null
if [ $? -eq $SUCCESS ]; then
    exit 1
fi

# revoke read from user 2
echo "revoke read"
$BIN/hermes_client -command=revoke_read_access -id=$USER_ID -private_key=$PRIVATE_KEY -config=$CONFIG_PATH -doc $TEST_FILE -for_user=$USER_ID2 1>/dev/null
if [ ! $? -eq $SUCCESS ]; then
    exit 1
fi

# read by user 2
echo "read by user 2"
$BIN/hermes_client -command=read_block -id=$USER_ID2 -private_key=$PRIVATE_KEY2 -config=$CONFIG_PATH -doc $TEST_FILE  1>/dev/null
if [ $? -eq $SUCCESS ]; then
    exit 1
fi

# delete block
echo "delete block"
$BIN/hermes_client -command=delete_block -id=$USER_ID -private_key=$PRIVATE_KEY -config=$CONFIG_PATH -doc $TEST_FILE  1>/dev/null
if [ ! $? -eq $SUCCESS ]; then
    exit 1
fi
echo "finished successfully"