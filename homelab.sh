#!/bin/bash

STACKS=("monitoring" "game-servers" "moriscribe" "utilities")

run_stack() {
    local stack="$1"
    shift
    local action=("$@")
    local stack_name="${STACKS[$stack]}"
    local stack_dir="services/${stack_name}"

    echo " Running action (${action[*]}) on stack: ${stack_name}"
    echo "----------------------------------------"

    if [ ! -d "$stack_dir" ]; then
        echo "Error: Directory '$stack_dir' does not exist."
        return 1
    fi

    for sub_dir in "$stack_dir"/*/; do
        if [ -d "$sub_dir" ] && [ -f "${sub_dir}docker-compose.yml" ]; then
            echo " -> Executing on $(basename "$sub_dir")..."
            docker compose -f "${sub_dir}docker-compose.yml" "${action[@]}"
        fi
    done
}

select_stack() {
    echo
    echo "Stacks:"
    echo

    for ((i = 0; i < ${#STACKS[@]}; i++)); do
        echo " $((i+1)) ${STACKS[i]}"
    done

    echo
    read -rp "Select stack : " stack

    if [[ ! "$stack" =~ ^[0-9]+$ ]] || [ "$stack" -lt 1 ] || [ "$stack" -gt "${#STACKS[@]}" ]; then
        echo "Invalid selection."
        return 1
    fi

    selected_stack=$((stack - 1))

    echo
    echo " Selected stack: ${STACKS[$selected_stack]}"
    echo
}

stack_action() {
    select_stack || return 1

    run_stack "$selected_stack" "$@"
}

while true; do
    clear
    echo "--------------------------"
    echo "Service manager interface "
    echo "--------------------------"
    echo
    echo " [1] Start stack"
    echo " [2] Stop stack"
    echo " [3] Restart stack"
    echo " [4] Stack logs"
    echo " [Q] Quit"
    echo

    read -rp "Select option: " option

    case "$option" in
        1)
            stack_action up -d
            ;;
        2)
            stack_action down
            ;;
        3)
            stack_action restart
            ;;
        q|Q)
            echo "Exiting..."
            exit 0
            ;;

        4)
            stack_action logs -f --tail 15
            ;;
        *)
            echo "Invalid option."
            ;;
    esac

    echo
    read -rp "Press enter to continue..."
done
