# -*- coding: utf-8 -*-
# Copyright 2016 Jose Antonio Cuello <yopli2000@hotmail.com>
# License AGPL-3.0 or later (http://www.gnu.org/licenses/agpl).
{
    "name": "Homeless Assistance",
    "summary": "Module for Homeless Assistance management",
    "version": "10.0.1.0.0",
    "category": "Custom Modules",
    "website": "https://www.jcpdigital.es/",
    "author": "Jose Antonio Cuello",
    "license": "AGPL-3",
    "application": False,
    "installable": True,
    "depends": [
        "base",
    ],
    "data": [
        "views/res_partner_view.xml",
        "views/homeless_distribution_view.xml",
        "views/homeless_meetingplace_view.xml",
        "views/homeless_route_view.xml",
        "views/menu.xml",
    ],
}
