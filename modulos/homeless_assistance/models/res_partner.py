# -*- coding: utf-8 -*-
# Copyright 2016 Artex Trading <informatica@artextrading.com>
# License AGPL-3.0 or later (http://www.gnu.org/licenses/agpl).

from openerp import fields, models

class ResPartner(models.Model):
    _inherit = "res.partner"

    # inherit Fields
    customer = fields.Boolean(
        string='Is a Homeless', default=False,
        help="Check this box if this contact is a homeless."
    )

    # New Fields
    volunteer = fields.Boolean(
        string="Is Volunteer",
        help="Check this box if this contact is a volunteer."
    )
