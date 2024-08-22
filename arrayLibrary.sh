function lib.printArray {
    # lib.printArray [pattern] listName
    # Usage:
    #   lib.printArray listName
    #   lib.printArray '%s;' listName
    if [ -z "$2" ]; then
        eval "[ ! -z \"$1\" ]" && eval "printf '%s\n' \"\${$1[@]}\""
    else
        eval "[ ! -z \"$2\" ]" && eval "printf '$1' \"\${$2[@]}\""
    fi
}

function lib.printArrays {
    # lib.printArrays [pattern] listName1 listName2 ...
    # Usage:
    #   lib.printArrays listName1 listName2 ...
    #   lib.printArrays '%s;' listName1 listName2 ...
    if ! grep -q '%' <<< "$1"; then
        for i in "$@"; do
            lib.printArray "$i"
        done
    else
        pattern="$1"
        for i in "${@:2}"; do
            lib.printArray "${pattern}" "$i"
        done
    fi
}

function lib.deltaSet {
    local list1=$1
    local list2=$2
    local egrepFilter="\b($(lib.printArray '%s|' $list2 | sed -E 's/\|$//'))\b"
    lib.printArray '%s\n' $list1 | egrep -v "$egrepFilter"   
}

function lib.mergeSet {
    local list1=$1
    local list2=$2
    echo "$(lib.printArrays '%s\n' $list1 $list2)" | sort | uniq | egrep -v '^s*$'
}

function lib.intersectSet {
    local list1=$1
    local list2=$2
    local egrepFilter="($(lib.printArray '%s|' $list2 | sed -E 's/\|$//'))"
    lib.printArray '%s\n' $list1 | egrep "$egrepFilter"  
}

function lib.dropDuplicates {
    local list=$1
    eval "readarray -t $list <<< \"$(lib.printArray $list | sort | uniq)\""
}

function lib.isin {
    local element=$1
    local list=$2
    if grep -q ";;;${element};;;" <<< "$(lib.printArray ';;;%s;;;' $list)"; then
        return 0
    else
        return 1
    fi
}
