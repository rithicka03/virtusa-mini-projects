rates = {'Economy': 10, 'Premium': 18, 'SUV': 25}

def calculate_fare(km, vehicle_type, hour):
    if vehicle_type not in rates:
        return None, "Service Not Available"
    
    base_fare = rates[vehicle_type] * km
    surge_applied = False
    
    if 17 <= hour <= 20:
        base_fare *= 1.5
        surge_applied = True
    
    return base_fare, surge_applied

print("-" * 40)
print("       CITYCAB - FARE CALCULATOR")
print("-" * 40)

try:
    km = float(input("Enter distance (km): "))
    vehicle_type = input("Enter vehicle type (Economy / Premium / SUV): ").strip()
    hour = int(input("Enter hour of day (0-23): "))

    if not (0 <= hour <= 23):
        print("Invalid hour. Please enter a value between 0 and 23.")
    else:
        result, extra = calculate_fare(km, vehicle_type, hour)

        if result is None:
            print("\n[ERROR] Service Not Available for vehicle type:", vehicle_type)
            print("Available types:", ', '.join(rates.keys()))
        else:
            print("\n" + "-" * 40)
            print("           PRICE RECEIPT")
            print("-" * 40)
            print(f"  Vehicle Type   : {vehicle_type}")
            print(f"  Distance       : {km} km")
            print(f"  Rate per km    : ₹{rates[vehicle_type]}")
            print(f"  Surge Pricing  : {'Yes (1.5x) - Peak Hours' if extra else 'No'}")
            print(f"  Hour of Travel : {hour}:00")
            print("-" * 40)
            print(f"  TOTAL FARE     : ₹{result:.2f}")
            print("-" * 40)
            print("   Thank you for choosing CityCab!")
            print("-" * 40)

except ValueError:
    print("[ERROR] Invalid input. Please enter numeric values for distance and hour.")