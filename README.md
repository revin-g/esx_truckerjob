# esx_truckerjob
Trucker job for ESX<br>
Originally by `nimarcio`, adapted by me for Midgard RP.
When you have the Delivery job, you are able to accept delivery missions at the warehouse.<br>
The script gives you a random zone between Los Santos and Blaine County.<br>
<br>
In each zone you have 10 possible delivery points given out at random.<br>
After each delivery, the script sends you a new delivery location or asks you to return to the depot.<br>
The maximum amount of deliveries per trip is configurable in client/main.lua. By default it is set to 10.<br>
<br>
When returning to the depot, the condition of the truck is checked and the cost of repairs is deducted from your salary.<br>
If you lose your truck, you cover the replacement cost.<br>
<br>
It is possible to return to the depot early to be paid for the deliveries you have completed successfully.<br>
<br>
You do not receive your salary until the truck is returned and checked for damage.<br>
<br>
# REQUIREMENTS
https://github.com/indilo53/fivem-es_extended
<br>
# INSTALLATION
Copy the `esx_deliveryjob` folder to resources\\[esx]<br>
Import `esx_eliveryjob.sql` into your databse<br>
Add `start esx_deliveryjob` to your `server.cfg` file<br>
<br>
# THANKS
Thanks to Renaiku for converting CFX to FX<br>
<br>
