export $(cat .env | xargs)

build() {
    terraform validate .
    terraform plan
    while true; do
        read -p "Continue Terraform apply? [y/n] " yn
        case $yn in
            [Yy]* ) terraform apply; break;;
            [Nn]* ) echo "exit"; exit;;
            * ) echo "Please answer yes or no.";;
        esac
    done
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