# -*- coding: utf-8 -*-
# Copyright 2016 Artex Trading <informatica@artextrading.com>
# License AGPL-3.0 or later (http://www.gnu.org/licenses/agpl).

from openerp import fields, models


class HomelessDistribution(models.Model):
    _name = 'homeless.distribution'
    _order = 'date_distribution desc, id desc'

    date_distribution = fields.Date(
        string='Distribution Date',
        readonly=True,
        index=True,
        copy=False,
        states={'draft': [('readonly', False)],
                'start': [('readonly', False)]},
        default=fields.Date.today)

    state = fields.Selection(
        [('draft', 'Creating'),
         ('start', 'Distributing'),
         ('done', 'Finished'),
         ('cancel', 'Cancelled'),],
        string='Status',
        readonly=True,
        copy=False,
        index=True,
        track_visibility='onchange',
        default='draft')

    route_id = fields.Many2one(
        string='Route',
        comodel_name='homeless.route',
        required=True)

    responsible_id = fields.Many2one(
        string='Responsible',
        comodel_name='res.partner',
        required=True,
        readonly=True,
        domain=[('volunteer', '=', True)],
        states = {'draft': [('readonly', False)],
                  'start': [('readonly', False)]})

    note = fields.Text(string='Note')

    distribution_line_ids = fields.One2many(
        string='Distribution Lines',
        comodel_name='homeless.distribution.line',
        inverse_name='distribution_id',
        states={'done': [('readonly', True)],
                'cancel': [('readonly', True)]})
