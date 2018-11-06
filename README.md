# esx_truckerjob
Trucker job for ESX

Originally by `nimarcio`, adapted by me for Midgard RP.

When you have the Delivery job, you are able to accept delivery missions at the warehouse.

The script gives you a random zone between Los Santos and Blaine County.
In each zone you have 10 possible delivery points given out at random.

After each delivery, the script sends you a new delivery location or asks you to return to the depot.
The maximum amount of deliveries per trip is configurable in client/main.lua. By default it is set to 10.

When returning to the depot, the condition of the truck is checked and the cost of repairs is deducted from your salary.

If you lose your truck, you cover the replacement cost.
It is possible to return to the depot early to be paid for the deliveries you have completed successfully.

You do not receive your salary until the truck is returned and checked for damage.

# Requirements
https://github.com/ESX-Org/es_extended

# Download & Installation
### Using Git
```
cd resources
git clone https://github.com/revin-g/esx_truckerjob [esx]/esx_truckerjob
```

### Manual
- Copy the `esx_truckerjob` folder to resources\\[esx]
  
### Installation
- Import `esx_truckerjob.sql` into your databse
- Add `start esx_truckerjob` to your `server.cfg` file

# Thanks
Thanks to Renaiku for converting CFX to FX