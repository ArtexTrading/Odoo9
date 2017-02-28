# -*- coding: utf-8 -*-
# Copyright 2016 Artex Trading <informatica@artextrading.com>
# License AGPL-3.0 or later (http://www.gnu.org/licenses/agpl).

from openerp import fields, models


class HomelessDistributionLine(models.Model):
    _name = 'homeless.distribution.line'
    _description = 'Distribution Meetingplace'
    _order = 'distribution_id, sequence, id'

    distribution_id = fields.Many2one(
        string='Distribution Reference',
        comodel_name='homeless.distribution',
        required=True,
        ondelete='cascade',
        index=True,
        copy=False)

    sequence = fields.Integer(
        string='Sequence',
        default=10)

    meetingplace_id = fields.Many2one(
        string='Meeting Place',
        comodel_name='homeless.meetingplace',
        required=True,
        index=True)

    state = fields.Selection(
        [('draft', 'Creating'),
         ('pending', 'Pending'),
         ('done', 'Finished'),
         ('cancel', 'Cancelled'),],
        string='Meeting Place Status')

    note = fields.Text(string='Note')
