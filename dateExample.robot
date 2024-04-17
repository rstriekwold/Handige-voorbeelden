*** Settings ***

Documentation                   New test suite
Library                         QWeb
Suite Setup                     Open Browser                about:blank                 chrome
Suite Teardown                  Close All Browsers
Library                         DateTime
Library        agecalculator.py

*** Test Cases ***
    ${GetCurrentMonth}=         Get Current Date            result_format=%B
    ${GetNewMonth}=             Get Current Date            increment=7 days            result_format=%B
    ${GetNewDay}=               Get Current Date            increment=7 days            result_format=%-d
    ${GetNewYear}=              Get Current Date            increment=7 days            result_format=%Y

    #Clicks on the month to open month selection
    ClickText                   ${GetCurrentMonth}
    #Click on new month
    ClickText                   ${GetNewMonth}
    #Click on the date
    ClickText                   ${GetNewDay}

    ${GetCurrentdate}=          Get Current Date            result_format=%-d %b, %Y
    ${GetCurrentdateMINDays}=                               Get Current Date            increment=-2 days           result_format=%-d %b, %Y
    ${GetCurrentdatePlUSDays}=                              Get Current Date            increment=2 days            result_format=%-d %b, %Y


    TypeText                    fieldlabel                  ${datePlusSeven}
    #first day of next month
    ${new_date}=                Evaluate                    ((datetime.datetime.now().replace(day=1)+datetime.timedelta(days=32)).replace(day=1))
    ${format_date}=             Convert Date                ${new_date}                 result_format=%b %d, %Y


    #using the datetime library to create a day for me instead of clicking next months everytime
    ${currentDate}=             Get Current Date
    ${closeDate}=               Add Time To Date            ${currentDate}              210 days                    result_format=%d.%m.%Y
    ${DeliveryDate}=            Add Time To Date            ${currentDate}              270 days                    result_format=%d.%m.%Y

    TypeText                    *Expected Close Date        ${closeDate}
    TypeText                    *Requested Delivery Date    ${DeliveryDate}

    ${currentDate}=             Get Current Date
    ${currentDate1}=            Add time to Date            ${currentDate}              1 hour                      result_format=%-m/%-d/%Y, %I:%M %p
    VerifyField                 SAL Date                    ${currentDate}


    ${new_date}=                Evaluate                    ((datetime.datetime.now().replace(day=1)+datetime.timedelta(days=32)).replace(day=1))
    ${nextMonth}=               Convert Date                ${new_date}                 result_format=%m

    ${new_date}=                Evaluate                    ((datetime.datetime.now().replace(day=1)-datetime.timedelta(days=31)).replace(day=1))
    ${prevMonth}=               Convert Date                ${new_date}                 result_format=%d/%m/%Y


    ${currentDate}=             Get Current Date            result_format=%d.%m.%Y
    ${datemindays}=             Get Current Date            increment=-367 days         result_format=%d.%m.%Y
    ${closeDate}=               Subtract Date From Date     ${currentDate}              ${datemindays}              verbose                     date1_format=%d.%m.%Y    date2_format=%d.%m.%Y


    #===================== Calculate age and return years and months



    ${birthYear}=               Get Current Date            increment=-3650 days          result_format=%d/%m/%Y
    ${years}     ${months}   calculate_age    ${birthYear}
    log to console     ${years}
    log to console     ${months}

    #===================== Select 1st day of previous month or 1sth day of next month 

    ${new_date}=                Evaluate                    ((datetime.datetime.now().replace(day=1)+datetime.timedelta(days=32)).replace(day=1))
    ${nextMonth}=               Convert Date                ${new_date}                 result_format=%d/%m/%Y

    ${new_date}=                Evaluate                    ((datetime.datetime.now().replace(day=1)-datetime.timedelta(days=31)).replace(day=1))
    ${prevMonth}=               Convert Date                ${new_date}                 result_format=%d/%m/%Y


# python code to calculate age in years and months
#prompt
# please create a python function for this, including an attribute for the birthdate and a return statement for the years and months:

# import datetime
# currentDate = datetime.datetime.now()

# deadline= input ('Please enter your date of birth (dd/mm/yyyy): ')
# deadlineDate= datetime.datetime.strptime(deadline,'%d/%m/%Y')
# print (deadlineDate)
# daysLeft = deadlineDate - currentDate
# print(daysLeft)

# years = ((daysLeft.total_seconds())/(365.242243600))
# years = abs(years)
# yearsInt=int(years)

# months=(years-yearsInt)*12
# months = abs(months)
# monthsInt=int(months)

# days=(months-monthsInt)*(365.242/12)
# days = abs(days)
# daysInt=int(days)

# hours = (days-daysInt)*24
# hours = abs(hours)
# hoursInt=int(hours)

# minutes = (hours-hoursInt)*60
# minutes = abs(minutes)
# minutesInt=int(minutes)

# seconds = (minutes-minutesInt)*60
# seconds = abs(seconds)
# secondsInt =int(seconds)

# print('You are {0:d} years, {1:d} months, {2:d} days, {3:d} hours, {4:d}
# minutes, {5:d} seconds old.'.format(yearsInt,monthsInt,daysInt,hoursInt,minutesInt,secondsInt))
