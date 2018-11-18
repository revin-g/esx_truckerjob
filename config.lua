Config              = {}
Config.DrawDistance = 100.0
Config.CompanyRange = 500.0
Config.MaxDelivery	= 5
Config.VehiclePrice	= 1500
Config.Locale       = 'en'

Config.Vans = {
	"burrito3",
	"speedo",
	"pony",
	"rumpo",
	"boxville2",
	"boxville4"
}

Config.Trucks = {
	"mule",
	"mule2",
	"mule3",
	"biff", -- recycling
	"benson",
	"pounder"
}

Config.TractorTrucks = {
	"phantom",
	"packer",
	"hauler",
	-- "docktug", -- utility
	"barracks2" -- military
}

Config.Companies = {
	['Walker Logistic'] = {
		Type = 'NCV',
		CloakRoom = { x = 146.0555, y = -3219.3471, z = 4.89 },
		Markers = {
			{
				Type = 'IL',
				Coords = { x = 142.5, y = -3204.0001, z = 5.5 },
				Heading = 270.0
			}, {
				Type = 'OL',
				Coords = { x = 115.0001, y = -3204.0001, z = 5.5 },
				Heading = 180.0
			}, {
				Type = 'IL',
				Coords = { x = 128.25, y = -3197.0001, z = 5.01 },
				Heading = 90.0
			}
		}
	},
	['Bugstar Pest Control'] = {
		Type = 'N',
		Markers = {
			{
				Type = 'IS',
				Coords = { x = 137.7, y = -3096.25, z = 5.01 },
				Heading = 270.0
			}, {
				Type = 'IS',
				Coords = { x = 137.7, y = -3089.0001, z = 5.01 },
				Heading = 270.0
			}
		}
	},
	['Los Santos Pier 400'] = {
		Type = 'NCLTVM',
		CloakRoom = { x = -53.1, y = -2525.1, z = 11.5 },
		Markers = {
			{
				Type = 'OL',
				Coords = { x = -174.5, y = -2408.8, z = 5.01 },
				Heading = 0.0
			}, {
				Type = 'OL',
				Coords = { x = -186.1, y = -2408.8, z = 5.01 },
				Heading = 0.0
			}, {
				Type = 'OL',
				Coords = { x = -202.5, y = -2408.8, z = 5.01 },
				Heading = 0.0
			}
		}
	},
	['Class-A Lines'] = {
		Type = 'NL',
		Markers = {
			{
				Type = 'IL',
				Coords = { x = 33.5, y = -2678.5, z = 5.01 },
				Heading = 0.0
			}
		}
	},
	['Pacific Bait'] = {
		Type = 'NCLTV',
		Markers = {
			{
				Type = 'OL',
				Coords = { x = 75.01, y = -2712.5, z = 5.01 },
				Heading = 180.01
			}, {
				Type = 'OL',
				Coords = { x = 82.5, y = -2712.5, z = 5.01 },
				Heading = 180.01
			}, {
				Type = 'OL',
				Coords = { x = 86.04, y = -2712.5, z = 5.01 },
				Heading = 180.01
			}, {
				Type = 'OL',
				Coords = { x = 89.7, y = -2712.5, z = 5.01 },
				Heading = 180.01
			}
		}
	},
	['D-Rail'] = {
		Type = 'NCTV',
		Markers = {
			{
				Type = 'IL',
				Coords = { x = -112.5, y = -2678.0001, z = 5.01 },
				Heading = 0.0
			}, {
				Type = 'IS',
				Coords = { x = -130.0001, y = -2655.0001, z = 5.01 },
				Heading = 0.0
			}, {
				Type = 'OL',
				Coords = { x = -160.0001, y = -2660.0001, z = 5.01 },
				Heading = 270.0
			}
		}
	},
	['Jetsam'] = {
		Type = 'NCTV',
		Markers = {
			{
				Type = 'OL',
				Coords = { x = -765.5, y = -2609.2, z = 12.83 },
				Heading = 240.0
			}, {
				Type = 'OL',
				Coords = { x = -763.3, y = -2605.0001, z = 12.83 },
				Heading = 240.0
			}, {
				Type = 'OL',
				Coords = { x = -760.7, y = -2600.5, z = 12.83 },
				Heading = 240.0
			}
		}
	},
	['Vinewood Video Store'] = {
		Type = 'N',
		Markers = {
			{
				Type = 'OL',
				Coords = { x = 239.5, y = 129.3, z = 101.6 },
				Heading = 250.0
			}, {
				Type = 'OL',
				Coords = { x = 237.4, y = 125.0001, z = 101.6 },
				Heading = 250.0
			}
		}
	},
	['Radio Rebels'] = {
		Type = 'N',
		Markers = {
			{
				Type = 'OL',
				Coords = { x = 738.32, y = 2532.0001, z = 72.16 },
				Heading = 266.0
			}
		}
	},
	['Humane Labs'] = {
		Type = 'NTMMM',
		Markers = {
			{
				Type = 'IS',
				Coords = { x = 3610.8, y = 3737.5, z = 27.69 },
				Heading = 330.0
			}, {
				Type = 'IS',
				Coords = { x = 3617.9, y = 3732.6, z = 27.69 },
				Heading = 330.0
			}, {
				Type = 'IS',
				Coords = { x = 3595.0001, y = 3662.0001, z = 32.87 },
				Heading = 80.0
			}, {
				Type = 'IS',
				Coords = { x = 3596.75, y = 3667.0001, z = 32.87 },
				Heading = 80.0
			}
		}
	},
	['Dollar Pills'] = {
		Type = 'NC',
		Markers = {
			{
				Type = 'OL',
				Coords = { x = 582.0001, y = 2796.0001, z = 41.13 },
				Heading = 5.0
			}, {
				Type = 'OL',
				Coords = { x = 587.5, y = 2796.0001, z = 41.13 },
				Heading = 5.0
			}
		}
	},
	['Lumber Yard'] = {
		Type = 'NLLLT',
		Markers = {
			{
				Type = 'OL',
				Coords = { x = -596.5, y = 5342.5, z = 69.39 },
				Heading = 160.0
			}, {
				Type = 'OL',
				Coords = { x = -795.0001, y = 5402.0001, z = 33.14 },
				Heading = 90.0
			}
		}
	},
	['Lumber Warehouse'] = {
		Type = 'NLLLT',
		Markers = {
			{
				Type = 'OL',
				Coords = { x = 1209.0001, y = -1256.5, z = 34.23 },
				Heading = 180.0
			}, {
				Type = 'OL',
				Coords = { x = 1199.1, y = -1335.9, z = 34.22 },
				Heading = 180.0
			}
		}
	},
	['Mirror Park Train Yard'] = {
		Type = 'NLT',
		Markers = {
			{
				Type = 'OL',
				Coords = { x = 519.4, y = -632.9, z = 23.75 },
				Heading = 175.0001
			}, {
				Type = 'OL',
				Coords = { x = 619.0001, y = -461.3, z = 23.76 },
				Heading = 353.0
			}, {
				Type = 'OL',
				Coords = { x = 607.5, y = -473.0001, z = 23.76 },
				Heading = 174.0
			}, {
				Type = 'IL',
				Coords = { x = 601.2, y = -454.0001, z = 23.76 },
				Heading = 353.0
			}
		}
	},
	['Port Zancudo'] = {
		Type = 'NTMMM',
		CloakRoom = { x = -1811.95, y = 3102.75, z = 31.84 },
		Markers = {
			{
				Type = 'OL',
				Coords = { x = -1776.7, y = 3081.74, z = 31.81 },
				Heading = 240.0001
			}, {
				Type = 'OL',
				Coords = { x = -1773.6, y = 3087.1, z = 31.81 },
				Heading = 240.0001
			}, {
				Type = 'OL',
				Coords = { x = -1770.58, y = 3092.32, z = 31.8 },
				Heading = 240.0001
			}, {
				Type = 'OL',
				Coords = { x = -1767.6, y = 3097.4, z = 31.8 },
				Heading = 240.0001
			}, {
				Type = 'IL',
				Coords = { x = -1798.1, y = 3094.3, z = 31.84 },
				Heading = 240.0001
			}, {
				Type = 'IL',
				Coords = { x = -1795.11, y = 3099.35, z = 31.84 },
				Heading = 240.0001
			}
		}
	},
	['You Tool'] = {
		Type = 'NC',
		Markers = {
			{
				Type = 'OL',
				Coords = { x = 2669.1, y = 3521.6, z = 51.62 },
				Heading = 66.58
			}, {
				Type = 'OL',
				Coords = { x = 2666.56, y = 3516.3, z = 51.78 },
				Heading = 66.58
			}, {
				Type = 'OL',
				Coords = { x = 2699.33, y = 3446.1, z = 54.8 },
				Heading = 157.32
			}, {
				Type = 'OS',
				Coords = { x = 2682.56, y = 3457.59, z = 54.76 },
				Heading = 157.32
			}, {
				Type = 'OS',
				Coords = { x = 2692.13, y = 3453.46, z = 54.79 },
				Heading = 157.32
			}
		}
	},
	['Thomson Aviation Scrap'] = {
		Type = 'N',
		Markers = {
			{
				Type = 'OL',
				Coords = { x = 2351.27, y = 3042.88, z = 47.15 },
				Heading = 357.5
			}, {
				Type = 'OL',
				Coords = { x = 2425.43, y = 3130.16, z = 47.2 },
				Heading = 250.01
			}
		}
	},
	['Recycling Center'] = {
		Type = 'N',
		Markers = {
			{
				Type = 'IL',
				Coords = { x = 2358.71, y = 3133.16, z = 47.21 },
				Heading = 260.01
			}
		}
	},
	['Davis Quartz'] = {
		Type = 'NT',
		Markers = {
			{
				Type = 'OL',
				Coords = { x = 2697.75, y = 2775.24, z = 36.88 },
				Heading = 120.01
			}, {
				Type = 'OL',
				Coords = { x = 2782.53, y = 2812.45, z = 40.57 },
				Heading = 300.01
			}, {
				Type = 'OL',
				Coords = { x = 2682.27, y = 2812.05, z = 39.44 },
				Heading = 0.01
			}
		}
	},
	['Palmer Taylor Power Station'] = {
		Type = 'NT',
		Markers = {
			{
				Type = 'OL',
				Coords = { x = 2672.4, y = 1414.56, z = 23.53 },
				Heading = 180.01
			}, {
				Type = 'OL',
				Coords = { x = 2771.65, y = 1397.46, z = 23.51 },
				Heading = 170.01
			}, {
				Type = 'OL',
				Coords = { x = 2771.24, y = 1480.01, z = 23.53 },
				Heading = 345.01
			}, {
				Type = 'OL',
				Coords = { x = 2754.65, y = 1709.93, z = 23.64 },
				Heading = 90.01
			}
		}
	},
	['Covington'] = {
		Type = 'NT',
		Markers = {
			{
				Type = 'IL',
				Coords = { x = 1353.74, y = -2089.7, z = 51.01 },
				Heading = 40.01
			}, {
				Type = 'OL',
				Coords = { x = 1390.2, y = -2041.18, z = 51.01 },
				Heading = 83.12
			}
		}
	},
	['Jetsam Terminal'] = {
		Type = 'N',
		CloakRoom = { x = 814.75, y = -2982.44, z = 5.02 },
		Markers = {
			{
				Type = 'OL',
				Coords = { x = 947.19, y = -2915.1, z = 4.9 },
				Heading = 270.01
			}, {
				Type = 'OL',
				Coords = { x = 990.54, y = -2915.1, z = 4.9 },
				Heading = 270.01
			}, {
				Type = 'OL',
				Coords = { x = 1109.62, y = -2915.1, z = 4.9 },
				Heading = 270.01
			}, {
				Type = 'OL',
				Coords = { x = 1167.85, y = -2915.1, z = 4.9 },
				Heading = 270.01
			}
		}
	},
	['Bilgeco'] = {
		Type = 'N',
		Markers = {
			{
				Type = 'OL',
				Coords = { x = 834.31, y = -3217.37, z = 4.9 },
				Heading = 180.01
			}, {
				Type = 'OL',
				Coords = { x = 827.53, y = -3217.37, z = 4.9 },
				Heading = 180.01
			}, {
				Type = 'OL',
				Coords = { x = 815.82, y = -3211.56, z = 4.9 },
				Heading = 180.01
			}
		}
	},
	['Post OP Warehouse'] = {
		Type = 'N',
		Markers = {
			{
				Type = 'OL',
				Coords = { x = 1200.45, y = -3229.76, z = 4.94 },
				Heading = 0.0
			}, {
				Type = 'OS',
				Coords = { x = 1177.42, y = -3272.56, z = 4.79 },
				Heading = 90.01
			}
		}
	},
	['Bristols Fuel Storage'] = {
		Type = 'T',
		Markers = {
			{
				Type = 'OL',
				Coords = { x = 597.4, y = -2762.56, z = 5.06 },
				Heading = 330.01
			}, {
				Type = 'OL',
				Coords = { x = 593.47, y = -2760.22, z = 5.06 },
				Heading = 330.01
			}, {
				Type = 'OL',
				Coords = { x = 585.68, y = -2755.84, z = 5.06 },
				Heading = 330.01
			}, {
				Type = 'OL',
				Coords = { x = 574.01, y = -2749.15, z = 5.06 },
				Heading = 330.01
			}, {
				Type = 'OL',
				Coords = { x = 562.43, y = -2742.17, z = 5.06 },
				Heading = 330.01
			}, {
				Type = 'OL',
				Coords = { x = 546.88, y = -2733.03, z = 5.06 },
				Heading = 330.01
			}, {
				Type = 'OL',
				Coords = { x = 535.16, y = -2726.27, z = 5.06 },
				Heading = 330.01
			}, {
				Type = 'OL',
				Coords = { x = 527.36, y = -2721.9, z = 5.06 },
				Heading = 330.01
			}
		}
	},
	['Mega Mall'] = {
		Type = 'NC',
		Markers = {
			{
				Type = 'OL',
				Coords = { x = 101.02, y = -1821.64, z = 25.42 },
				Heading = 140.01
			}
		}
	}
}

Config.Cloakroom = {
	CloakRoom = {
			Pos   = {x = 146.0555, y = -3219.3471, z = 4.5},
			Size  = {x = 3.0, y = 3.0, z = 1.0},
			Color = {r = 204, g = 204, b = 0},
			Type  = 1
		},
}

Config.Zones = {
	VehicleSpawner = {
		Pos   = {x = 152.3740, y = -3212.1042, z = 4.5},
		Size  = {x = 3.0, y = 3.0, z = 1.0},
		Color = {r = 204, g = 204, b = 0},
		Type  = 1
	},

	VehiclePrimarySpawnPoint = {
		Pos   = {x = 142.5, y = -3204.0, z = 5.5},
		Dir   = 270.0,
		Size  = {x = 3.0, y = 3.0, z = 1.0},
		Type  = -1
	},

	VehicleSecondarySpawnPoint = {
		Pos   = {x = 115.0, y = -3204.0, z = 5.5},
		Dir   = 180.0,
		Size  = {x = 3.0, y = 3.0, z = 1.0},
		Type  = -1
	},

	VehiclePrimaryDeliveryPoint = {
		Pos   = {x = 128.25, y = -3197.0, z = 5.0},
		Dir   = 90.0,
		Size  = {x = 3.0, y = 3.0, z = 1.0},
		Type  = -1
	},
}

Config.Delivery = {
-------------------------------------------Los Santos
	DeliveryTestLS = {
			Pos   = {x = 188.49, y = -3204.02, z = 4.8},
			Size  = {x = 5.0, y = 5.0, z = 3.0},
			Color = {r = 204, g = 204, b = 0},
			Type  = 1,
			Paye = 0
		},
	-- Strawberry avenue and Davis avenue
	Delivery1LS = {
			Pos   = {x = 121.0655, y = -1488.4984, z = 28.0},
			Size  = {x = 5.0, y = 5.0, z = 3.0},
			Color = {r = 204, g = 204, b = 0},
			Type  = 1,
			Paye = 150
		},
	-- next to the cop
	Delivery2LS = {
			Pos   = {x = 451.4836, y = -899.0954, z = 27.5},
			Size  = {x = 5.0, y = 5.0, z = 3.0},
			Color = {r = 204, g = 204, b = 0},
			Type  = 1,
			Paye = 200
		},
	-- to the beach
	Delivery3LS = {
			Pos   = {x = -1129.4438, y = -1607.2420, z = 3.9},
			Size  = {x = 5.0, y = 5.0, z = 3.0},
			Color = {r = 204, g = 204, b = 0},
			Type  = 1,
			Paye = 250
		},
	-- studio 1
	Delivery4LS = {
			Pos   = {x = -1064.7435, y = -553.4235, z = 32.5},
			Size  = {x = 5.0, y = 5.0, z = 3.0},
			Color = {r = 204, g = 204, b = 0},
			Type  = 1,
			Paye = 300
		},
	-- popular street and el rancho boulevard
	Delivery5LS = {
			Pos   = {x = 809.5350, y = -2024.2238, z = 28.0},
			Size  = {x = 5.0, y = 5.0, z = 3.0},
			Color = {r = 204, g = 204, b = 0},
			Type  = 1,
			Paye = 350
		},
	--Alta street and las lagunas boulevard
	Delivery6LS = {
			Pos   = {x = 63.2668, y = -227.9965, z = 50.0},
			Size  = {x = 5.0, y = 5.0, z = 3.0},
			Color = {r = 204, g = 204, b = 0},
			Type  = 1,
			Paye = 150
		},
	--Rockford Drive Noth and boulevard del perro
	Delivery7LS = {
			Pos   = {x = -1338.6923, y = -402.4188, z = 34.9},
			Size  = {x = 5.0, y = 5.0, z = 3.0},
			Color = {r = 204, g = 204, b = 0},
			Type  = 1,
			Paye = 200
		},
	--Rockford Drive Noth and boulevard del perro
	Delivery8LS = {
			Pos   = {x = 548.6097, y = -206.3496, z = 52.5},
			Size  = {x = 5.0, y = 5.0, z = 3.0},
			Color = {r = 204, g = 204, b = 0},
			Type  = 1,
			Paye = 250
		},
	--New empire way (airport)
	Delivery9LS = {
			Pos   = {x = -1141.9106, y = -2699.9340, z = 13.0},
			Size  = {x = 5.0, y = 5.0, z = 3.0},
			Color = {r = 204, g = 204, b = 0},
			Type  = 1,
			Paye = 300
		},
	--Rockford drive south
	Delivery10LS = {
			Pos   = {x = -640.0313, y = -1224.9519, z = 10.5},
			Size  = {x = 5.0, y = 5.0, z = 3.0},
			Color = {r = 204, g = 204, b = 0},
			Type  = 1,
			Paye = 350
		},
------------------------------------------- Blaine County
	-- panorama drive
	Delivery1BC = {
			Pos   = {x = 1999.5457, y = 3055.0686, z = 45.5},
			Size  = {x = 5.0, y = 5.0, z = 3.0},
			Color = {r = 204, g = 204, b = 0},
			Type  = 1,
			Paye = 300
		},
	-- route 68
	Delivery2BC = {
			Pos   = {x = 555.4768, y = 2733.9533, z = 41.0},
			Size  = {x = 5.0, y = 5.0, z = 3.0},
			Color = {r = 204, g = 204, b = 0},
			Type  = 1,
			Paye = 350
		},
	-- Algonquin boulevard and cholla springs avenue
	Delivery3BC = {
			Pos   = {x =1685.1549, y = 3752.0849, z = 33.0},
			Size  = {x = 5.0, y = 5.0, z = 3.0},
			Color = {r = 204, g = 204, b = 0},
			Type  = 1,
			Paye = 400
		},
	-- Joshua road
	Delivery4BC = {
			Pos   = {x = 182.7030, y = 2793.9829, z = 44.5},
			Size  = {x = 5.0, y = 5.0, z = 3.0},
			Color = {r = 204, g = 204, b = 0},
			Type  = 1,
			Paye = 450
		},
	-- East joshua road
	Delivery5BC = {
			Pos   = {x = 2710.6799, y = 4335.3168, z = 44.8},
			Size  = {x = 5.0, y = 5.0, z = 3.0},
			Color = {r = 204, g = 204, b = 0},
			Type  = 1,
			Paye = 500
		},
	-- Seaview road
	Delivery6BC = {
			Pos   = {x = 1930.6518, y = 4637.5878, z = 39.3},
			Size  = {x = 5.0, y = 5.0, z = 3.0},
			Color = {r = 204, g = 204, b = 0},
			Type  = 1,
			Paye = 300
		},
	-- Paleto boulevard
	Delivery7BC = {
			Pos   = {x = -448.2438, y = 5993.8686, z = 30.3},
			Size  = {x = 5.0, y = 5.0, z = 3.0},
			Color = {r = 204, g = 204, b = 0},
			Type  = 1,
			Paye = 350
		},
	-- Paleto boulevard and Procopio drive
	Delivery8BC = {
			Pos   = {x = 107.9181, y = 6605.9750, z = 30.8},
			Size  = {x = 5.0, y = 5.0, z = 3.0},
			Color = {r = 204, g = 204, b = 0},
			Type  = 1,
			Paye = 400
		},
	-- Marina drive and joshua road
	Delivery9BC = {
			Pos   = {x = 916.6915, y = 3568.7783, z = 32.7},
			Size  = {x = 5.0, y = 5.0, z = 3.0},
			Color = {r = 204, g = 204, b = 0},
			Type  = 1,
			Paye = 450
		},
	-- Pyrite Avenue
	Delivery10BC = {
			Pos   = {x = -128.6733, y = 6344.5493, z = 31.0},
			Size  = {x = 5.0, y = 5.0, z = 3.0},
			Color = {r = 204, g = 204, b = 0},
			Type  = 1,
			Paye = 500
		},
	
	ReturnTruck = {
			Pos   = {x = 162.5408, y = -3188.7770, z = 4.5},
			Size  = {x = 5.0, y = 5.0, z = 3.0},
			Color = {r = 204, g = 204, b = 0},
			Type  = 1,
			Paye = 0
		},
}
