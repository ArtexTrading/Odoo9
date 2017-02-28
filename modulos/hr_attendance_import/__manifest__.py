# -*- coding: utf-8 -*-
# Copyright 2017 Artex Trading <informatica@artextrading.com>
# License AGPL-3.0 or later (http://www.gnu.org/licenses/agpl).

{
    'name': 'Attendances_Import',
    'version': '1.0',
    "author": "Artex Trading",
    "license": "AGPL-3",
    'category': 'Human Resources',
    'summary': 'Import employee attendances',
    'description': """
This module allows importing employee's attendances from csv files.
===================================================================

Ability to automate employee's attendance with external controls by
importing your actions(Check in/Check out) from a CSV file.
       """,
    'depends': ['hr_attendance'],
    'application': False,
    'installable': True,
    'data': [
        'security/hr_attendance_import_security.xml',
        'wizards/hr_attendance_import_view.xml',
        'wizards/hr_attendance_fix_employee_view.xml',
        'wizards/hr_attendance_search_checkout_view.xml',
        'views/hr_attendance_incidence_view.xml',
        'views/menu.xml',
    ],
}
