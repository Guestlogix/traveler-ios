#!/bin/bash

#Get current directory
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

#Fetch tags
git fetch --tags origin

DIRECTORIES= find . -name *"Info.plist"* | grep -i *'traveler'*

for directory in $DIRECTORIES
do
    echo $directory
done



# #!/bin/bash

# #Get current directory
# SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# #Fetch tags
# git fetch --tags origin

# for directory in */
# do
#     #Grep to get the files that start with traveler-...
#     for FILE_NAME in $directory*
#     do
#         echo $FILE_NAME
#         # if [[ $FILE_NAME == *"Info.plist"* ]]; then
#         #     echo "------------------------------------------"
#         #     echo "Upgrading version in $FILE_NAME"

#         #     # MODULE=$(echo $FILE_NAME | grep -o "\_[a-z]*" | head -1)
#         #     # MODULE=${MODULE#*_}
#         #     # NEW_VERSION_NAME=$(${SCRIPT_DIR}/version.sh $MODULE)
#         #     # CURRENT_VERSION_NAME=$(grep versionName $FILE_NAME | grep -o "[0-9.]\+")

#         #     # if [[ $NEW_VERSION_NAME != $CURRENT_VERSION_NAME ]]; then
#         #     #     echo "Updating version to: $NEW_VERSION_NAME"
#         #     #     sed -i  -e "s/versionName \"[0-9]*.[0-9]*.*[0-9]*\"/versionName \"$NEW_VERSION_NAME\"/" $FILE_NAME
#         #     #     NEW_TAG=${MODULE}-v$NEW_VERSION_NAME
#         #     #     MODULE=$(echo $MODULE | tr '[a-z]' '[A-Z]')
#         #     #     envman add --key ${MODULE}_VERSION_NAME --value $NEW_TAG

#         #     #     NEW_VERSION_CODE=$(grep versionCode $FILE_NAME | awk '{ print ++$2 }')
#         #     #     echo "Incrementing version code to: $NEW_VERSION_CODE"
#         #     #     sed -i  -e "s/versionCode [0-9]*/versionCode $NEW_VERSION_CODE/" $FILE_NAME
#         #     #fi
#         # fi
#     done
# done