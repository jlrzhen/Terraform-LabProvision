setup() {
    git update-index --skip-worktree .env
    echo "setup complete"
}

teardown() {
    git update-index --no-skip-worktree .env
    echo "teardown complete"
}

PS3="Select action: "
select option in Setup Teardown Exit
do
    case $option in
        "Setup")
            setup
            break;;
        "Teardown")
            teardown
            break;;
        "Exit")
            echo "exit"
            break;;
        *)
            echo "Please select an action.";;
    esac
done