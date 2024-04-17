import datetime

def calculate_age(birthdate_str):
    """
    Calculate the age in years and months from the birthdate.

    Parameters:
    birthdate_str (str): The birthdate in 'dd/mm/yyyy' format.

    Returns:
    tuple: A tuple containing the age in years and months.
    """
    # Convert the current date and birthdate from string to datetime objects
    current_date = datetime.datetime.now()
    birthdate = datetime.datetime.strptime(birthdate_str, '%d/%m/%Y')
    
    # Calculate the difference between the current date and the birthdate
    time_difference = current_date - birthdate
    total_days = time_difference.days
    total_seconds = time_difference.total_seconds()
    
    # Calculate the age in years
    years = int(total_seconds / (365.242243600 * 24 * 3600))
    
    # Calculate the remaining days after subtracting the years
    remaining_days = total_days - (years * 365.25)
    
    # Calculate the age in months from the remaining days
    months = int(remaining_days / 30.436875)
    
    return years, months
