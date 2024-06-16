f1=0;f2=0;f3=0

function test_screen ()
{
    clear
    echo "Test started at $(date)." >> Test_Log.txt
    echo -e "Test Screen:\n"

    n=$(cat Question_Bank.txt | wc -l)
    echo "" > User_Answer.txt

    for i in `seq 5 5 ${n}`
    do
        option=""
        cat Question_Bank.txt | head -${i} | tail -5
        echo
        for j in `seq 9 -1 0`
        do
            echo -e "\rTime remaining: ${j}\tChoose your option: \c"
            read -t 1 option
            if [ -n "${option}" ]
            then
                break
            else
                option="E"
            fi
        done

        echo "${option}" >> User_Answer.txt
        echo
    done
    clear
    echo "Test submitted successfully at $(date)." >> Test_Log.txt
    echo -e "Test completed successfully!\n"
    result_calc
}

function result_calc ()
{
    sed -i '/^[[:blank:]]*$/d' User_Answer.txt
    score=0
    u_ans=(`cat User_Answer.txt`)
    o_ans=(`cat Original_Answer.txt`)
    length=$((${#u_ans[@]} - 1))
    for i in `seq 0 ${length}`
    do
        if [ "${u_ans[i]}" = "${o_ans[i]}" ]
        then
            score=$((${score} + 1))
        fi
    done
    echo -e "Your score in the Test is: ${score}\n"
}

function display_ans ()
{
    echo -e "\nYour Test history is as follows:\n"
    n=$(cat Question_Bank.txt | wc -l)
    u_ans=(`cat User_Answer.txt`)
    o_ans=(`cat Original_Answer.txt`)

    for i in `seq 5 5 ${n}`
    do
        cat Question_Bank.txt | head -${i} | tail -5
        echo
        YELLOW='\033[1;33m'
        GREEN='\033[1;36m'
        NC='\033[0m'
        echo -e "${YELLOW}Your answer is ${u_ans[$(((${i}/5)-1))]}${NC}"
        echo -e "${GREEN}Correct answer is ${o_ans[$(((${i}/5)-1))]}${NC}\n"
    done
}

function sign_in ()
{
    echo "Sign-In Screen:"
    echo
    echo "Please enter your: "
    echo -n "Username: "
    read u_name
    echo -n "Password: "
    read -s u_pswd
    echo
    
    arr_uname=(`cat Username.csv`)
    arr_upswd=(`cat Password.csv`)
    length=$((${#arr_uname[@]} - 1))

    if [ ${length} -ge 0 ]
    then
        for i in `seq 0 ${length}`
        do
            if [ "${u_name}" = "${arr_uname[i]}" ]
            then
                if [ "${u_pswd}" = "${arr_upswd[i]}" ]
                then
                    f2=1
                    break
                else
                    f2=0
                fi
            else
                f2=0
            fi
        done
        if [ ${f2} -eq 0 ]
        then
            echo -e "The entered User credentials are incorrect. Please re-enter the Username and Password.\n"
            sign_in
        else
            echo "Sign-In successfully at $(date)." >> Test_Log.txt
            echo -e "Sign-In successful!\n"
            echo -ne "1. Take Test\n2. View your Test\n3. Exit\nPlease choose your option: "
            read choice
            case ${choice} in
                1) test_screen
                    ;;
                2) display_ans
                    ;;
                3) echo -e "\nThank you for using the Command Line Test. Have a great day!\n"
                    ;;
            esac
        fi
    else
        echo -e "No Users are registered in the Database. Please use the Sign-up function to get registered first.\n"
        f2=1
    fi
}

function sign_up ()
{
    echo "Sign-Up Screen:"
    echo
    echo -n "Please choose your Username: "
    read u_name
    echo -n "Please enter your Password: "
    read -s u_pswd
    echo
    echo -n "Please re-enter your Password: "
    read -s u_confpswd
    echo

    arr_uname=(`cat Username.csv`)
    length=$((${#arr_uname[@]} - 1))
    if [ "${u_pswd}" != "${u_confpswd}" ]
    then
        echo -e "The entered Passwords are not matching. Please enter the Password again.\n"
        f1=0
    else
        if [ ${#u_pswd} -ge 8 ]
        then
            if [ ${length} -ge 0 ]
            then
                for i in `seq 0 ${length}`
                do
                    if [ "${u_name}" != "${arr_uname[i]}" ]
                    then
                        f1=1
                    else
                        echo -e "Username ${u_name} already exists. Please enter the details again with any other Username.\n"
                        f1=0
                        break
                    fi
                done
            else
                f1=1
            fi
        else
            echo -e "The password length must be minimum of 8 characters. Please enter the Password again.\n"
            f1=0
        fi
    fi
    if [ ${f1} -eq 1 ]
    then
        echo "${u_name}" >> Username.csv
        echo "${u_pswd}" >> Password.csv
        echo "Sign-up successfully at $(date)." >> Test_Log.txt
        echo -e "\nRegistration successful!\n"
    fi
}

clear
echo "Script started at $(date)." > Test_Log.txt
while [ 1 ]
do
    echo "-----------------------------"
    echo "Welcome to Command Line Test!"
    echo "-----------------------------"

    echo -e "1. Sign-up\n2. Sign-in\n3. Exit\n"
    echo -n "Please choose your choice: "
    read choice
    echo

    case ${choice} in
        1) while [ ${f1} -eq 0 ]
            do
                sign_up
            done
            sign_in
            ;;
        2) while [ ${f2} -eq 0 ]
            do
                sign_in
            done
            ;;
        3) f3=1
            echo -e "Thank you for using the Command Line Test. Have a great day!\n"
            ;;
    esac
    if [ ${f1} -eq 1 -o ${f2} -eq 1 -o ${f3} -eq 1 ]
    then
        break
    fi
done
echo "Script ended at $(date)." >> Test_Log.txt
