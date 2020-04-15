#!/usr/bin/sh

# Utility functions

show_help() {
    # Show some nice logo
    printf "\n"
    printf "   __            _             \n"
    printf "  / /  ___   ___| | _____ _ __ \n"
    printf " / /  / _ \ / __| |/ / _ \ '__|\n"
    printf "/ /__| (_) | (__|   <  __/ |   \n"
    printf "\____/\___/ \___|_|\_\___|_|   \n\n"

    printf "\n\t--Developed by deepjyoti30, 2020\n"

    # Show help
    printf "\nUsage: locker OPERATION DIR [--help]\n"
    printf "\n"

    # Positional arguments
    printf "Positional arguments:\n\n"
    printf "  OPERATION: Either of [lock] or [unlock] can be passed.\n"
    printf "  DIR: Directory to operate on.\n"
    
    # Optional arguments
    printf "\nOptional arguments:\n\n"
    printf "  --help: Show this message and exit\n"

    exit
}

get_lower() {
    # Convert the passed string from upper to lower

    # Check if arg passed
    if [ "$#" -ne 1 ]; then
        printf "[-] Error in get_lower! Exiting...!\n"
        return -1
    fi

    echo "$(echo "$1" | tr '[:upper:]' '[:lower:]')"
}

get_upper() {
    # Return the uppercase of the passed string
    echo "$(echo "$1" | tr '[:lower:]' '[:upper:]')"
}

get_hash() {
    # Return the hash of the passed string
    echo "$(echo "$1" | md5sum)"
}

get_store_loc() {
    # Return the location of the passed dir
    dir_hash=$(get_hash $1)

    # Replace all the spaces with #
    echo "$(tr ' ' '#' <<< "$dir_hash")"
}

save_pw_hash() {
    # Generate a hash for the password created by the user
    # and save it somewhere safe

    hash=$(get_hash "$1")
    dir_hash=$(get_store_loc $DIR)
    store_loc="$par_dir/.locker/hash-$dir_hash"

    # Create the dir in case it doesn't exits
    mkdir -p "$par_dir/.locker"; touch "$store_loc"

    printf "[*] Storing the passwd hash to %s\n" "$store_loc"
    echo "$hash" > $store_loc
}

is_pw_invalid() {
    # Check if the entered password is valid
    hash=$(get_hash $1)

    # Now read the saved hash
    dir_hash=$(get_store_loc $DIR)
    store_loc="$par_dir/.locker/hash-$dir_hash"

    if [ ! -e $store_loc ];then
        printf "[-] The directory is probably not locked!\n"
        exit
    fi

    # If the file is present, read from it and
    # compare the string
    saved_hash=$(cat $store_loc)

    if [ "$saved_hash" != "$hash" ];then
        return 1
    fi

    return 0
}

remove_file() {
    # Remove the pw file once the dir is unlocked
    dir_hash=$(get_store_loc $DIR)
    store_loc="$par_dir/.locker/hash-$dir_hash"

    rm $store_loc
}

lock_dir() {
    # Now lock the dir
    chmod u-rwx,go-rwx $1
    return $!
}

unlock_dir() {
    # Unlock the dir now
    chmod u+rwx,go+rx $1
    return $!
}

lock() {
    # Do all the operations related to locking the DIR
    save_pw_hash $1
    lock_dir $DIR
    status=$?

    if [ "$status" = "0" ];then
        printf "[*] Directory locked succesfully!\n"
        return 0
    else
        printf "[-] Directory couldn't be locked. SORRY!\n"
        return -1
    fi
}

unlock() {
    # Unlock the DIR
    passed_pw=$1
    is_pw_invalid $passed_pw
    status=$?

    if [ "$status" = "1" ];then
        printf "[-] The password is wrong!.\n"
        return -1
    fi

    unlock_dir $DIR
    status=$?

    if [ "$status" = "0" ];then
        printf "[*] The directory was unlocked succesfully!\n";
    else
        printf "[-] Something went wrong. SORRY!\n";
        return -1
    fi

    remove_file
    return 0
}

main() {
    # Declare the possible operations available
    possible_op=("lock", "unlock")

    # Show the passed values
    printf "[*] Passed OPERATION is: %s\n" "$(get_upper $OP)"
    printf "[*] Passed DIRECTORY is: %s\n" "$DIR"

    # Check if the Operation passed is a valid one
    # If it's not exit and show reason
    if $(echo ${possible_op[@]} | grep -q -w "$OP");then
        printf "[*] Passed OPERATION is valid.\n"
    else
        printf "[-] Passed OPERATION is not valid! Exitting...\n"   
    fi

    # Check if the passed directory is valid or not
    if [ -d "$DIR" ];then
        printf "[*] Passed directory is valid....\n"
    else
        printf "[-] Passed directory is not valid...\n"
    fi

    # Get a passwd from the user
    printf "[*] Enter the password: "
    read temp_pw

    # Check if to lock or unlock
    if [ $OP = "lock" ];then
        lock $temp_pw
        status=$?
    else
        # Since we have already checked the operation
        # for validity, there are only two possibilities
        # THUS, no need to check for unlock
        unlock $temp_pw
        status=$?
    fi

    return $status
}

if [ "$#" -ne 2 ] || [ "$1" = "--help" ]; then
    show_help
fi

# Extract the passed operation and dir
par_dir=$(echo ~)
OP=$(get_lower $1)
DIR=$2

main
