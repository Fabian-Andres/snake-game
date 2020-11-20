#!/usr/bin/env bash

diff=""
if [ "$1" != "" ]
then
    diff="$1"
fi

commits_behind=`git log origin/master...HEAD --oneline --no-merges | wc -l | xargs`
if [[ $commits_behind -gt 150 ]]
then
    echo "This branch is ${commits_behind} commits behind master. Please sync it."
    exit 1
fi

commits=`git log --no-merges --format="===%n%s%n%b;;;" $diff`

previous_line=""
previous_title=""
title_line=""
is_start=false
has_jira=false
has_why=false
has_what=false
counter=0

if [[ $commits == "" ]]
then
    exit 0
fi

while IFS= read -r line
do
    if [[ $line == "" ]]
    then
        # ignore empty lines
        continue
    fi

    if [[ $line == "===" ]]
    then
        is_start=true
        counter=0
        has_jira=false
        has_why=false
        has_what=false
        continue
    fi

    if [[ $line == ";;;" ]]
    then
        is_start=false
        if [[ $has_jira == false ]]
        then
            echo "Commit doesn't have an associated JIRA: $title_line"
            exit 1
        fi

        if [[ $has_why == false ]]
        then
            echo "Commit is missing the Why line: $title_line"
            exit 1
        fi

        if [[ $has_what == false ]]
        then
            echo "Commit is missing the What line: $title_line"
            exit 1
        fi

        if [[ $counter -lt 3 ]]
        then
            echo "Missing commit description: $title_line count=$counter"
            exit 1
        fi

        continue
    fi

    if [[ $is_start == true ]] && [[ ${#line} -lt 20 ]]
    then
        echo "Line is too short: $line"
        exit 1
    fi

    if [[ ${#line} -gt 80 ]]
    then
        echo "Line is too long: $line"
        exit 1
    fi

    first_word=`echo "$line" | cut -d" " -f1`
    if [[ $is_start == true ]] && [[ $first_word == *ed ]]
    then
        echo "Verb should be in imperative form: $line"
        exit 1
    fi

    if [[ $is_start == false ]] && [[ $first_word == "Why:" ]]
    then
        has_why=true
    fi

    if [[ $is_start == false ]] && [[ $first_word == "What:" ]]
    then
        has_what=true
    fi

    if [[ $is_start == true ]] && [[ ${line:0:1} =~ [a-z] ]]
    then
        echo "Commit text should be capitalized: $line"
        exit 1
    fi

    if [[ $is_start == true ]] && [[ $line =~ [A-Z]{2,5}-[0-9]{1,6} ]]
    then
        echo "Don't add the ticket to the title: $line"
        exit 1
    fi

    if [[ $is_start == true ]]
    then
        if [[ $previous_title != "" ]] && [[ $previous_title == $line ]]
        then
            echo "Don't repeat commit titles"
            exit 1
        fi

        previous_title=$title_line
        title_line=$line
        is_start=false
    fi

    if [[ $line =~ [A-Z]{2,5}-[0-9]{1,6} ]]
    then
        has_jira=true
    fi

    if [[ $line == ${previous_line} ]]
    then
        echo "body is missing or line is duplicated/contained in: $line vs $previous_line"
        exit 1
    else
        previous_line=$line
    fi

    if [[ $line != "" ]]
    then
        counter=$((counter+1))
    fi
done <<<"$commits"
