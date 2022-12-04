export $(cat .env | xargs)

build() {
    terraform validate . && \
    terraform plan && \
    terraform apply
}

PS3="Select action: "
select option in Build Destroy Exit
do
    case $option in
        "Build")
            build
            break;;
        "Destroy")
            terraform destroy
            break;;
        "Exit")
            echo "exit"
            break;;
        *)
            echo "Please select an action.";;
    esac
done