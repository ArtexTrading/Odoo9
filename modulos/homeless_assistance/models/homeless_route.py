# -*- coding: utf-8 -*-
# Copyright 2016 Artex Trading <informatica@artextrading.com>
# License AGPL-3.0 or later (http://www.gnu.org/licenses/agpl).

from openerp import api, fields, models


class HomelessRoute(models.Model):
    _name = 'homeless.route'

    name = fields.Char(
        string='Title',
        required=True)

    require_car = fields.Boolean(
        string='Require a car', default=False,
        help="Check this box if this route require a car."
    )

    note = fields.Text(string='Note')

    meetingplace_ids = fields.One2many(
        comodel_name='homeless.meetingplace',
        inverse_name='route_id')

    total_meetingplace = fields.Integer(
        string='Total Meeting Place',
        compute='_compute_total_meetingplace',
        store=True)

    @api.one
    @api.depends('meetingplace_ids')
    def _compute_total_meetingplace(self):
        self.total_meetingplace = len(self.meetingplace_ids)
